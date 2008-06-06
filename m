Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:10473 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbYFFR76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 13:59:58 -0400
Received: by wa-out-1112.google.com with SMTP id j37so822360waf.23
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jun 2008 10:59:58 -0700 (PDT)
Subject: [PATCH 5/7] mac80211: use new helpers in util.c -
	ieee80211_get_bssid()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 10:51:13 -0700
Message-Id: <1212774673.6340.79.camel@brick> (sfid-20080606_200002_319076_01A19B1C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/ieee80211.h |   14 ++++++++++++++
 net/mac80211/util.c       |   41 +++++++++++++++++++----------------------
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 9496bea..ddd8bee 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -171,6 +171,20 @@ static inline int ieee80211_data_has_qos(__le16 fc)
 	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_DATA);
 }
 
+static inline int ieee80211_ctl_is_pspoll(__le16 fc)
+{
+	return (fc &
+	       cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL);
+}
+
+static inline int ieee80211_ctl_is_back_req(__le16 fc)
+{
+	return (fc &
+	       cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_BACK_REQ);
+}
+
 struct ieee80211s_hdr {
 	u8 flags;
 	u8 ttl;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 60fec1c..b7c6558 100644
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
+		if(ieee80211_ctl_is_pspoll(fc))
 			return hdr->addr1;
-		else if ((fc & IEEE80211_FCTL_STYPE) ==
-						IEEE80211_STYPE_BACK_REQ) {
+
+		if (ieee80211_ctl_is_back_req(fc)) {
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
1.5.6.rc1.257.gba91d


