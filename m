Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:16274 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbYGPBoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 21:44:08 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1738137yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2008 18:44:07 -0700 (PDT)
Subject: [PATCH 04/12] mac80211: explicitly check skb->len
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 18:44:05 -0700
Message-Id: <1216172645.6610.51.camel@brick> (sfid-20080716_034411_335588_A768D125)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_get_hdrlen_from_skb internally checks the skb is long enough to
hold the full ieee80211_hdr, else it returns zero.  Use ieee80211_hdrlen
which always returns the hdrlen and check the remaining room in the
skb explicitly when removing encryption headers or the qos control field.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/main.c |   26 +++++++++++---------------
 1 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 10533bf..22a5435 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1247,16 +1247,16 @@ static void ieee80211_remove_tx_extra(struct ieee80211_local *local,
 				      struct ieee80211_key *key,
 				      struct sk_buff *skb)
 {
-	int hdrlen, iv_len, mic_len;
+	unsigned int hdrlen, iv_len, mic_len;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	info->flags &=	IEEE80211_TX_CTL_REQ_TX_STATUS |
 			IEEE80211_TX_CTL_DO_NOT_ENCRYPT |
 			IEEE80211_TX_CTL_REQUEUE |
 			IEEE80211_TX_CTL_EAPOL_FRAME;
 
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-
 	if (!key)
 		goto no_key;
 
@@ -1277,24 +1277,20 @@ static void ieee80211_remove_tx_extra(struct ieee80211_local *local,
 		goto no_key;
 	}
 
-	if (skb->len >= mic_len &&
+	if (skb->len >= hdrlen + mic_len &&
 	    !(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
 		skb_trim(skb, skb->len - mic_len);
-	if (skb->len >= iv_len && skb->len > hdrlen) {
+	if (skb->len >= hdrlen + iv_len) {
 		memmove(skb->data + iv_len, skb->data, hdrlen);
-		skb_pull(skb, iv_len);
+		hdr = (struct ieee80211_hdr *)skb_pull(skb, iv_len);
 	}
 
 no_key:
-	{
-		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-		u16 fc = le16_to_cpu(hdr->frame_control);
-		if ((fc & 0x8C) == 0x88) /* QoS Control Field */ {
-			fc &= ~IEEE80211_STYPE_QOS_DATA;
-			hdr->frame_control = cpu_to_le16(fc);
-			memmove(skb->data + 2, skb->data, hdrlen - 2);
-			skb_pull(skb, 2);
-		}
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		hdr->frame_control &= ~cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
+		memmove(skb->data + IEEE80211_QOS_CTL_LEN, skb->data,
+			hdrlen - IEEE80211_QOS_CTL_LEN);
+		skb_pull(skb, IEEE80211_QOS_CTL_LEN);
 	}
 }
 
-- 
1.5.6.3.499.geae9


