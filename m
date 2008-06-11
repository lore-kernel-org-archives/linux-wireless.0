Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:2940 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbYFKVWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 17:22:08 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3278785wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 14:22:08 -0700 (PDT)
Subject: [PATCHv2 05/11] mac80211: use new helpers in util.c -
	ieee80211_get_bssid()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 11 Jun 2008 14:21:58 -0700
Message-Id: <1213219318.5974.178.camel@brick> (sfid-20080611_232212_949312_5AA48250)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/util.c |   41 +++++++++++++++++++----------------------
 1 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9f365a3..ce62b16 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -45,38 +45,37 @@ const unsigned char bridge_tunnel_header[] __aligned(2) =
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 			enum ieee80211_if_types type)
 {
-	u16 fc;
+	__le16 fc = hdr->frame_control;
 
 	 /* drop ACK/CTS frames and incorrect hdr len (ctrl) */
 	if (len < 16)
 		return NULL;
 
-	fc = le16_to_cpu(hdr->frame_control);
-
-	switch (fc & IEEE80211_FCTL_FTYPE) {
-	case IEEE80211_FTYPE_DATA:
+	if (ieee80211_is_data(fc)) {
 		if (len < 24) /* drop incorrect hdr len (data) */
 			return NULL;
-		switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
-		case IEEE80211_FCTL_TODS:
-			return hdr->addr1;
-		case (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS):
+
+		if (ieee80211_has_a4(fc))
 			return NULL;
-		case IEEE80211_FCTL_FROMDS:
+		if (ieee80211_has_tods(fc))
+			return hdr->addr1;
+		if (ieee80211_has_fromds(fc))
 			return hdr->addr2;
-		case 0:
-			return hdr->addr3;
-		}
-		break;
-	case IEEE80211_FTYPE_MGMT:
+
+		return hdr->addr3;
+	}
+
+	if (ieee80211_is_mgmt(fc)) {
 		if (len < 24) /* drop incorrect hdr len (mgmt) */
 			return NULL;
 		return hdr->addr3;
-	case IEEE80211_FTYPE_CTL:
-		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)
+	}
+
+	if (ieee80211_is_ctl(fc)) {
+		if(ieee80211_is_pspoll(fc))
 			return hdr->addr1;
-		else if ((fc & IEEE80211_FCTL_STYPE) ==
-						IEEE80211_STYPE_BACK_REQ) {
+
+		if (ieee80211_is_back_req(fc)) {
 			switch (type) {
 			case IEEE80211_IF_TYPE_STA:
 				return hdr->addr2;
@@ -84,11 +83,9 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 			case IEEE80211_IF_TYPE_VLAN:
 				return hdr->addr1;
 			default:
-				return NULL;
+				break; /* fall through to the return */
 			}
 		}
-		else
-			return NULL;
 	}
 
 	return NULL;
-- 
1.5.6.rc2.261.ga8fbe


