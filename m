Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35488 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbbFATi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 15:38:58 -0400
Received: by igbyr2 with SMTP id yr2so70218063igb.0
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 12:38:58 -0700 (PDT)
From: David Liu <cfliu.tw@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, kvalo@qca.qualcomm.com,
	David Liu <cfliu.tw@gmail.com>
Subject: [PATCH] mac80211: support IEEE80211_KEY_FLAG_RESERVE_TAILROOM for CCMP and TKIP.
Date: Mon,  1 Jun 2015 12:38:18 -0700
Message-Id: <1433187498-15124-1-git-send-email-cfliu.tw@gmail.com> (sfid-20150601_213916_279898_ACBC4919)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The change reserves neccessary tailroom in CCMP and TKIP if required by
drivers that sets IEEE80211_KEY_FLAG_RESERVE_TAILROOM. For example,
ath10k HW engine in raw Tx/Rx encap mode requires SW reserve MIC/ICV space.

Signed-off-by: David Liu <cfliu.tw@gmail.com>
---
 net/mac80211/wpa.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 9d63d93..b56f31a 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -192,7 +192,9 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 
 	if (info->control.hw_key &&
 	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV) &&
-	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)) {
+	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
+	    !(info->control.hw_key->flags &
+	      IEEE80211_KEY_FLAG_RESERVE_TAILROOM)) {
 		/* hwaccel - with no need for software-generated IV */
 		return 0;
 	}
@@ -200,7 +202,8 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	len = skb->len - hdrlen;
 
-	if (info->control.hw_key)
+	if (info->control.hw_key && !(info->control.hw_key->flags &
+				      IEEE80211_KEY_FLAG_RESERVE_TAILROOM))
 		tail = 0;
 	else
 		tail = IEEE80211_TKIP_ICV_LEN;
@@ -227,8 +230,12 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	spin_unlock(&key->u.tkip.txlock);
 
 	/* hwaccel - with software IV */
-	if (info->control.hw_key)
+	if (info->control.hw_key) {
+		if (info->control.hw_key->flags &
+		    IEEE80211_KEY_FLAG_RESERVE_TAILROOM)
+			skb_put(skb, tail);
 		return 0;
+	}
 
 	/* Add room for ICV */
 	skb_put(skb, IEEE80211_TKIP_ICV_LEN);
@@ -411,6 +418,8 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb,
 	if (info->control.hw_key &&
 	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV) &&
 	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
+	    !(info->control.hw_key->flags &
+	       IEEE80211_KEY_FLAG_RESERVE_TAILROOM) &&
 	    !((info->control.hw_key->flags &
 	       IEEE80211_KEY_FLAG_GENERATE_IV_MGMT) &&
 	      ieee80211_is_mgmt(hdr->frame_control))) {
@@ -424,7 +433,8 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb,
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	len = skb->len - hdrlen;
 
-	if (info->control.hw_key)
+	if (info->control.hw_key && !(info->control.hw_key->flags &
+				      IEEE80211_KEY_FLAG_RESERVE_TAILROOM))
 		tail = 0;
 	else
 		tail = mic_len;
@@ -456,8 +466,12 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb,
 	ccmp_pn2hdr(pos, pn, key->conf.keyidx);
 
 	/* hwaccel - with software CCMP header */
-	if (info->control.hw_key)
+	if (info->control.hw_key) {
+		if (info->control.hw_key->flags &
+		    IEEE80211_KEY_FLAG_RESERVE_TAILROOM)
+			skb_put(skb, tail);
 		return 0;
+	}
 
 	pos += IEEE80211_CCMP_HDR_LEN;
 	ccmp_special_blocks(skb, pn, b_0, aad);
-- 
2.1.4

