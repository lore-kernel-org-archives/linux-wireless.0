Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:10473 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbYFFSAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 14:00:00 -0400
Received: by wa-out-1112.google.com with SMTP id j37so822360waf.23
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jun 2008 11:00:00 -0700 (PDT)
Subject: [PATCH 6/7] mac80211: wpa.c use new access helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 10:51:13 -0700
Message-Id: <1212774673.6340.80.camel@brick> (sfid-20080606_200006_679579_B549562E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/wpa.c |   46 +++++++++++-----------------------------------
 1 files changed, 11 insertions(+), 35 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 9f6fd20..21a795f 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -24,46 +24,22 @@ static int ieee80211_get_hdr_info(const struct sk_buff *skb, u8 **sa, u8 **da,
 {
 	struct ieee80211_hdr *hdr;
 	size_t hdrlen;
-	u16 fc;
-	int a4_included;
-	u8 *pos;
+	__le16 fc;
 
-	hdr = (struct ieee80211_hdr *) skb->data;
-	fc = le16_to_cpu(hdr->frame_control);
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = hdr->frame_control;
 
-	hdrlen = 24;
-	if ((fc & (IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS)) ==
-	    (IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS)) {
-		hdrlen += ETH_ALEN;
-		*sa = hdr->addr4;
-		*da = hdr->addr3;
-	} else if (fc & IEEE80211_FCTL_FROMDS) {
-		*sa = hdr->addr3;
-		*da = hdr->addr1;
-	} else if (fc & IEEE80211_FCTL_TODS) {
-		*sa = hdr->addr2;
-		*da = hdr->addr3;
-	} else {
-		*sa = hdr->addr2;
-		*da = hdr->addr1;
-	}
+	hdrlen = ieee80211_hdrlen(fc);
 
-	if (fc & 0x80)
-		hdrlen += 2;
+	*sa = ieee80211_get_SA(hdr);
+	*da = ieee80211_get_DA(hdr);
 
 	*data = skb->data + hdrlen;
 	*data_len = skb->len - hdrlen;
 
-	a4_included = (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) ==
-		(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
-	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
-	    fc & IEEE80211_STYPE_QOS_DATA) {
-		pos = (u8 *) &hdr->addr4;
-		if (a4_included)
-			pos += 6;
-		*qos_tid = pos[0] & 0x0f;
-		*qos_tid |= 0x80; /* qos_included flag */
-	} else
+	if (ieee80211_data_has_qos(fc))
+		*qos_tid = (*ieee80211_get_qos_ctl(hdr, hdrlen) & 0x0f) | 0x80;
+	else
 		*qos_tid = 0;
 
 	return skb->len < hdrlen ? -1 : 0;
-- 
1.5.6.rc1.257.gba91d


