Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:9488 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbYFWFuu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 01:50:50 -0400
Received: by py-out-1112.google.com with SMTP id p76so857638pyb.10
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jun 2008 22:50:49 -0700 (PDT)
Subject: [PATCH] mac80211: remove ieee80211_get_hdr_info
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Jun 2008 22:50:51 -0700
Message-Id: <1214200251.21092.23.camel@brick> (sfid-20080623_075152_340272_D0B9FF81)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the address selection into the michale_mic header calculation helper
and pass a pointer to the ieee80211_hdr directly.

Reorganize ccmp_special_blocks while eliminating the unneeded sa/da/qos
variables.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/michael.c |   17 ++++--
 net/mac80211/michael.h |    2 +-
 net/mac80211/wpa.c     |  139 ++++++++++++++++++++---------------------------
 3 files changed, 72 insertions(+), 86 deletions(-)

diff --git a/net/mac80211/michael.c b/net/mac80211/michael.c
index 1fcdf38..cbbef4b 100644
--- a/net/mac80211/michael.c
+++ b/net/mac80211/michael.c
@@ -8,6 +8,7 @@
  */
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <linux/ieee80211.h>
 #include <asm/unaligned.h>
 
 #include "michael.h"
@@ -26,9 +27,15 @@ static void michael_block(struct michael_mic_ctx *mctx, u32 val)
 	mctx->l += mctx->r;
 }
 
-static void michael_mic_hdr(struct michael_mic_ctx *mctx,
-			const u8 *key, const u8 *da, const u8 *sa, u8 priority)
+static void michael_mic_hdr(struct michael_mic_ctx *mctx, const u8 *key,
+			    const struct ieee80211_hdr *hdr)
 {
+	u8 *da, *sa, tid;
+
+	da = ieee80211_get_DA(hdr);
+	sa = ieee80211_get_SA(hdr);
+	tid = *ieee80211_get_qos_ctl(hdr) & 0x0f;
+
 	mctx->l = get_unaligned_le32(key);
 	mctx->r = get_unaligned_le32(key + 4);
 
@@ -40,17 +47,17 @@ static void michael_mic_hdr(struct michael_mic_ctx *mctx,
 	michael_block(mctx, get_unaligned_le16(&da[4]) |
 			    (get_unaligned_le16(sa) << 16));
 	michael_block(mctx, get_unaligned_le32(&sa[2]));
-	michael_block(mctx, priority);
+	michael_block(mctx, tid);
 }
 
-void michael_mic(const u8 *key, const u8 *da, const u8 *sa, u8 priority,
+void michael_mic(const u8 *key, const struct ieee80211_hdr *hdr,
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
index 69b4501..41ab4fe 100644
--- a/net/mac80211/michael.h
+++ b/net/mac80211/michael.h
@@ -18,7 +18,7 @@ struct michael_mic_ctx {
 	u32 l, r;
 };
 
-void michael_mic(const u8 *key, const u8 *da, const u8 *sa, u8 priority,
+void michael_mic(const u8 *key, const struct ieee80211_hdr *hdr,
 		 const u8 *data, size_t data_len, u8 *mic);
 
 #endif /* MICHAEL_H */
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 345e10e..fba5fda 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/skbuff.h>
 #include <linux/compiler.h>
+#include <asm/unaligned.h>
 #include <net/mac80211.h>
 
 #include "ieee80211_i.h"
@@ -19,38 +20,13 @@
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
-		*qos_tid = (*ieee80211_get_qos_ctl(hdr) & 0x0f) | 0x80;
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
-	u8 *data, *sa, *da, *key, *mic, qos_tid;
+	u8 *data, *key, *mic;
 	size_t data_len;
+	unsigned int hdrlen;
+	struct ieee80211_hdr *hdr;
 	u16 fc;
 	struct sk_buff *skb = tx->skb;
 	int authenticator;
@@ -63,9 +39,14 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
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
@@ -91,7 +72,7 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 	key = &tx->key->conf.key[authenticator ? ALG_TKIP_TEMP_AUTH_TX_MIC_KEY :
 				 ALG_TKIP_TEMP_AUTH_RX_MIC_KEY];
 	mic = skb_put(skb, MICHAEL_MIC_LEN);
-	michael_mic(key, da, sa, qos_tid & 0x0f, data, data_len, mic);
+	michael_mic(key, hdr, data, data_len, mic);
 
 	return TX_CONTINUE;
 }
@@ -100,8 +81,10 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 ieee80211_rx_result
 ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 {
-	u8 *data, *sa, *da, *key = NULL, qos_tid;
+	u8 *data, *key = NULL;
 	size_t data_len;
+	unsigned int hdrlen;
+	struct ieee80211_hdr *hdr;
 	u16 fc;
 	u8 mic[MICHAEL_MIC_LEN];
 	struct sk_buff *skb = rx->skb;
@@ -120,11 +103,13 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
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
@@ -133,13 +118,13 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 #endif
 	key = &rx->key->conf.key[authenticator ? ALG_TKIP_TEMP_AUTH_RX_MIC_KEY :
 				 ALG_TKIP_TEMP_AUTH_TX_MIC_KEY];
-	michael_mic(key, da, sa, qos_tid & 0x0f, data, data_len, mic);
+	michael_mic(key, hdr, data, data_len, mic);
 	if (memcmp(mic, data + data_len, MICHAEL_MIC_LEN) != 0 || wpa_test) {
 		if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 			return RX_DROP_UNUSABLE;
 
 		printk(KERN_DEBUG "%s: invalid Michael MIC in data frame from "
-		       "%s\n", rx->dev->name, print_mac(mac, sa));
+		       "%s\n", rx->dev->name, print_mac(mac, ieee80211_get_SA(hdr)));
 
 		mac80211_ev_michael_mic_failure(rx->dev, rx->key->conf.keyidx,
 						(void *) skb->data);
@@ -298,67 +283,61 @@ ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
 static void ccmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *b_0, u8 *aad,
 				int encrypted)
 {
-	u16 fc;
-	int a4_included, qos_included;
-	u8 qos_tid, *fc_pos, *data, *sa, *da;
-	int len_a;
+	unsigned int hdrlen;
+	__le16 msk_fc;
+	u8 qos_tid, *data;
 	size_t data_len;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	data = skb->data + hdrlen;
+
+	data_len = skb->len - hdrlen - CCMP_HDR_LEN;
+	if (encrypted)
+		data_len -= CCMP_MIC_LEN;
+
+	if (ieee80211_is_data_qos(hdr->frame_control))
+		qos_tid = *ieee80211_get_qos_ctl(hdr) & 0x0f;
+	else
+		qos_tid = 0;
 
-	fc_pos = (u8 *) &hdr->frame_control;
-	fc = fc_pos[0] ^ (fc_pos[1] << 8);
-	a4_included = (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) ==
-		(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
-
-	ieee80211_get_hdr_info(skb, &sa, &da, &qos_tid, &data, &data_len);
-	data_len -= CCMP_HDR_LEN + (encrypted ? CCMP_MIC_LEN : 0);
-	if (qos_tid & 0x80) {
-		qos_included = 1;
-		qos_tid &= 0x0f;
-	} else
-		qos_included = 0;
 	/* First block, b_0 */
 
 	b_0[0] = 0x59; /* flags: Adata: 1, M: 011, L: 001 */
 	/* Nonce: QoS Priority | A2 | PN */
 	b_0[1] = qos_tid;
-	memcpy(&b_0[2], hdr->addr2, 6);
+	memcpy(&b_0[2], hdr->addr2, ETH_ALEN);
 	memcpy(&b_0[8], pn, CCMP_PN_LEN);
 	/* l(m) */
-	b_0[14] = (data_len >> 8) & 0xff;
-	b_0[15] = data_len & 0xff;
-
+	put_unaligned_be16((u16)data_len, b_0 + 14);
 
-	/* AAD (extra authenticate-only data) / masked 802.11 header
-	 * FC | A1 | A2 | A3 | SC | [A4] | [QC] */
-
-	len_a = a4_included ? 28 : 22;
-	if (qos_included)
-		len_a += 2;
+	/*
+	 * AAD (extra authenticate-only data) / masked 802.11 header
+	 * FC | A1 | A2 | A3 | SC | [A4] | [QC]
+	 */
+	put_unaligned_be16(hdrlen - 2, aad);
 
-	aad[0] = 0; /* (len_a >> 8) & 0xff; */
-	aad[1] = len_a & 0xff;
-	/* Mask FC: zero subtype b4 b5 b6 */
-	aad[2] = fc_pos[0] & ~(BIT(4) | BIT(5) | BIT(6));
-	/* Retry, PwrMgt, MoreData; set Protected */
-	aad[3] = (fc_pos[1] & ~(BIT(3) | BIT(4) | BIT(5))) | BIT(6);
+	/*
+	 * Mask FC: zero subtype b4 b5 b6
+	 * Retry, PwrMgt, MoreData; set Protected
+	 */
+	msk_fc = hdr->frame_control;
+	msk_fc &= ~cpu_to_le16(IEEE80211_FCTL_STYPE | IEEE80211_FCTL_RETRY |
+			       IEEE80211_FCTL_PM | IEEE80211_FCTL_MOREDATA);
+	msk_fc |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+	put_unaligned(msk_fc, (__le16 *)(aad + 2));
 	memcpy(&aad[4], &hdr->addr1, 18);
 
 	/* Mask Seq#, leave Frag# */
-	aad[22] = *((u8 *) &hdr->seq_ctrl) & 0x0f;
+	aad[22] = *((u8 *)&hdr->seq_ctrl) & 0x0f;
 	aad[23] = 0;
-	if (a4_included) {
-		memcpy(&aad[24], hdr->addr4, 6);
-		aad[30] = 0;
+	if (ieee80211_has_a4(hdr->frame_control)) {
+		memcpy(&aad[24], hdr->addr4, ETH_ALEN);
+		aad[30] = qos_tid;
 		aad[31] = 0;
-	} else
+	} else {
 		memset(&aad[24], 0, 8);
-	if (qos_included) {
-		u8 *dpos = &aad[a4_included ? 30 : 24];
-
-		/* Mask QoS Control field */
-		dpos[0] = qos_tid;
-		dpos[1] = 0;
+		aad[24] = qos_tid;
 	}
 }
 
-- 
1.5.6.290.gc4e15



