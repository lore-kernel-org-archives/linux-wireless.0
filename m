Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:11652 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbYGHS13 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 14:27:29 -0400
Received: by yx-out-2324.google.com with SMTP id 8so658804yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 11:27:28 -0700 (PDT)
Subject: [PATCH 4/8] mac80211: remove ieee80211_get_hdr_info
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 11:00:27 -0700
Message-Id: <1215540027.476.18.camel@brick> (sfid-20080708_202731_586543_B7659239)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do the check for sufficient skb->len explicitly and pass a pointer
to the struct ieee80211_hdr directly to the michael_mic calculation.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/michael.c |   20 +++++++++++++----
 net/mac80211/michael.h |    2 +-
 net/mac80211/wpa.c     |   54 ++++++++++++++++-------------------------------
 3 files changed, 35 insertions(+), 41 deletions(-)

diff --git a/net/mac80211/michael.c b/net/mac80211/michael.c
index 1fcdf38..408649b 100644
--- a/net/mac80211/michael.c
+++ b/net/mac80211/michael.c
@@ -8,6 +8,7 @@
  */
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <linux/ieee80211.h>
 #include <asm/unaligned.h>
 
 #include "michael.h"
@@ -26,9 +27,18 @@ static void michael_block(struct michael_mic_ctx *mctx, u32 val)
 	mctx->l += mctx->r;
 }
 
-static void michael_mic_hdr(struct michael_mic_ctx *mctx,
-			const u8 *key, const u8 *da, const u8 *sa, u8 priority)
+static void michael_mic_hdr(struct michael_mic_ctx *mctx, const u8 *key,
+			    struct ieee80211_hdr *hdr)
 {
+	u8 *da, *sa, tid;
+
+	da = ieee80211_get_DA(hdr);
+	sa = ieee80211_get_SA(hdr);
+	if (ieee80211_is_data_qos(hdr->frame_control))
+		tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
+	else
+		tid = 0;
+
 	mctx->l = get_unaligned_le32(key);
 	mctx->r = get_unaligned_le32(key + 4);
 
@@ -40,17 +50,17 @@ static void michael_mic_hdr(struct michael_mic_ctx *mctx,
 	michael_block(mctx, get_unaligned_le16(&da[4]) |
 			    (get_unaligned_le16(sa) << 16));
 	michael_block(mctx, get_unaligned_le32(&sa[2]));
-	michael_block(mctx, priority);
+	michael_block(mctx, tid);
 }
 
-void michael_mic(const u8 *key, const u8 *da, const u8 *sa, u8 priority,
+void michael_mic(const u8 *key, struct ieee80211_hdr *hdr,
 		 const u8 *data, size_t data_len, u8 *mic)
 {
 	u32 val;
 	size_t block, blocks, left;
 	struct michael_mic_ctx mctx;
 
-	michael_mic_hdr(&mctx, key, da, sa, priority);
+	michael_mic_hdr(&mctx, key, hdr);
 
 	/* Real data */
 	blocks = data_len / 4;
diff --git a/net/mac80211/michael.h b/net/mac80211/michael.h
index 69b4501..3b848da 100644
--- a/net/mac80211/michael.h
+++ b/net/mac80211/michael.h
@@ -18,7 +18,7 @@ struct michael_mic_ctx {
 	u32 l, r;
 };
 
-void michael_mic(const u8 *key, const u8 *da, const u8 *sa, u8 priority,
+void michael_mic(const u8 *key, struct ieee80211_hdr *hdr,
 		 const u8 *data, size_t data_len, u8 *mic);
 
 #endif /* MICHAEL_H */
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 919e30c..241c932 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -21,38 +21,13 @@
 #include "aes_ccm.h"
 #include "wpa.h"
 
-static int ieee80211_get_hdr_info(const struct sk_buff *skb, u8 **sa, u8 **da,
-				  u8 *qos_tid, u8 **data, size_t *data_len)
-{
-	struct ieee80211_hdr *hdr;
-	size_t hdrlen;
-	__le16 fc;
-
-	hdr = (struct ieee80211_hdr *)skb->data;
-	fc = hdr->frame_control;
-
-	hdrlen = ieee80211_hdrlen(fc);
-
-	*sa = ieee80211_get_SA(hdr);
-	*da = ieee80211_get_DA(hdr);
-
-	*data = skb->data + hdrlen;
-	*data_len = skb->len - hdrlen;
-
-	if (ieee80211_is_data_qos(fc))
-		*qos_tid = (*ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK) | 0x80;
-	else
-		*qos_tid = 0;
-
-	return skb->len < hdrlen ? -1 : 0;
-}
-
-
 ieee80211_tx_result
 ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 {
-	u8 *data, *sa, *da, *key, *mic, qos_tid, key_offset;
+	u8 *data, *key, *mic, key_offset;
 	size_t data_len;
+	unsigned int hdrlen;
+	struct ieee80211_hdr *hdr;
 	u16 fc;
 	struct sk_buff *skb = tx->skb;
 	int authenticator;
@@ -65,9 +40,14 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 	    !WLAN_FC_DATA_PRESENT(fc))
 		return TX_CONTINUE;
 
-	if (ieee80211_get_hdr_info(skb, &sa, &da, &qos_tid, &data, &data_len))
+	hdr = (struct ieee80211_hdr *)skb->data;
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	if (skb->len < hdrlen)
 		return TX_DROP;
 
+	data = skb->data + hdrlen;
+	data_len = skb->len - hdrlen;
+
 	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
 	    !(tx->flags & IEEE80211_TX_FRAGMENTED) &&
 	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) &&
@@ -97,7 +77,7 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 		NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY;
 	key = &tx->key->conf.key[key_offset];
 	mic = skb_put(skb, MICHAEL_MIC_LEN);
-	michael_mic(key, da, sa, qos_tid & 0x0f, data, data_len, mic);
+	michael_mic(key, hdr, data, data_len, mic);
 
 	return TX_CONTINUE;
 }
@@ -106,8 +86,10 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 ieee80211_rx_result
 ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 {
-	u8 *data, *sa, *da, *key = NULL, qos_tid, key_offset;
+	u8 *data, *key = NULL, key_offset;
 	size_t data_len;
+	unsigned int hdrlen;
+	struct ieee80211_hdr *hdr;
 	u16 fc;
 	u8 mic[MICHAEL_MIC_LEN];
 	struct sk_buff *skb = rx->skb;
@@ -126,11 +108,13 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 	    !(rx->fc & IEEE80211_FCTL_PROTECTED) || !WLAN_FC_DATA_PRESENT(fc))
 		return RX_CONTINUE;
 
-	if (ieee80211_get_hdr_info(skb, &sa, &da, &qos_tid, &data, &data_len)
-	    || data_len < MICHAEL_MIC_LEN)
+	hdr = (struct ieee80211_hdr *)skb->data;
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	if (skb->len < hdrlen + MICHAEL_MIC_LEN)
 		return RX_DROP_UNUSABLE;
 
-	data_len -= MICHAEL_MIC_LEN;
+	data = skb->data + hdrlen;
+	data_len = skb->len - hdrlen - MICHAEL_MIC_LEN;
 
 #if 0
 	authenticator = fc & IEEE80211_FCTL_TODS; /* FIX */
@@ -143,7 +127,7 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 		NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY :
 		NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY;
 	key = &rx->key->conf.key[key_offset];
-	michael_mic(key, da, sa, qos_tid & 0x0f, data, data_len, mic);
+	michael_mic(key, hdr, data, data_len, mic);
 	if (memcmp(mic, data + data_len, MICHAEL_MIC_LEN) != 0 || wpa_test) {
 		if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 			return RX_DROP_UNUSABLE;
-- 
1.5.6.1.322.ge904b


