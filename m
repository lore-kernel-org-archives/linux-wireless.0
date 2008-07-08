Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:16368 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbYGHS11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 14:27:27 -0400
Received: by py-out-1112.google.com with SMTP id p76so1274879pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 11:27:26 -0700 (PDT)
Subject: [PATCH 3/8] mac80211: remove one user of ieee80211_get_hdr_info
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 11:00:27 -0700
Message-Id: <1215540027.476.17.camel@brick> (sfid-20080708_202729_906842_C582AE44)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ccmp_special_blocks was only using it to calculate data_len,
calculate that directly.

Use unaligned helpers rather than masking/shifting.

Use symbolic constants for the masked frame_control, and do it directly
on a le16 value.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/wpa.c |   78 ++++++++++++++++++++++++---------------------------
 1 files changed, 37 insertions(+), 41 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 222001c..919e30c 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -11,6 +11,8 @@
 #include <linux/slab.h>
 #include <linux/skbuff.h>
 #include <linux/compiler.h>
+#include <linux/ieee80211.h>
+#include <asm/unaligned.h>
 #include <net/mac80211.h>
 
 #include "ieee80211_i.h"
@@ -296,67 +298,61 @@ ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
 static void ccmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *b_0, u8 *aad,
 				int encrypted)
 {
-	u16 fc;
-	int a4_included, qos_included;
-	u8 qos_tid, *fc_pos, *data, *sa, *da;
-	int len_a;
-	size_t data_len;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	__le16 mask_fc;
+	int a4_included;
+	u8 qos_tid;
+	u16 data_len, len_a;
+	unsigned int hdrlen;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
-	fc_pos = (u8 *) &hdr->frame_control;
-	fc = fc_pos[0] ^ (fc_pos[1] << 8);
-	a4_included = (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) ==
-		(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
-
-	ieee80211_get_hdr_info(skb, &sa, &da, &qos_tid, &data, &data_len);
-	data_len -= CCMP_HDR_LEN + (encrypted ? CCMP_MIC_LEN : 0);
-	if (qos_tid & 0x80) {
-		qos_included = 1;
-		qos_tid &= IEEE80211_QOS_CTL_TID_MASK;
-	} else
-		qos_included = 0;
-	/* First block, b_0 */
+	/*
+	 * Mask FC: zero subtype b4 b5 b6
+	 * Retry, PwrMgt, MoreData; set Protected
+	 */
+	mask_fc = hdr->frame_control;
+	mask_fc &= ~cpu_to_le16(0x0070 | IEEE80211_FCTL_RETRY |
+				IEEE80211_FCTL_PM | IEEE80211_FCTL_MOREDATA);
+	mask_fc |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	len_a = hdrlen - 2;
+	a4_included = ieee80211_has_a4(hdr->frame_control);
 
+	if (ieee80211_is_data_qos(hdr->frame_control))
+		qos_tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
+	else
+		qos_tid = 0;
+
+	data_len = skb->len - hdrlen - CCMP_HDR_LEN;
+	if (encrypted)
+		data_len -= CCMP_MIC_LEN;
+
+	/* First block, b_0 */
 	b_0[0] = 0x59; /* flags: Adata: 1, M: 011, L: 001 */
 	/* Nonce: QoS Priority | A2 | PN */
 	b_0[1] = qos_tid;
 	memcpy(&b_0[2], hdr->addr2, ETH_ALEN);
 	memcpy(&b_0[8], pn, CCMP_PN_LEN);
 	/* l(m) */
-	b_0[14] = (data_len >> 8) & 0xff;
-	b_0[15] = data_len & 0xff;
-
+	put_unaligned_be16(data_len, &b_0[14]);
 
 	/* AAD (extra authenticate-only data) / masked 802.11 header
 	 * FC | A1 | A2 | A3 | SC | [A4] | [QC] */
-
-	len_a = a4_included ? 28 : 22;
-	if (qos_included)
-		len_a += IEEE80211_QOS_CTL_LEN;
-
-	aad[0] = 0; /* (len_a >> 8) & 0xff; */
-	aad[1] = len_a & 0xff;
-	/* Mask FC: zero subtype b4 b5 b6 */
-	aad[2] = fc_pos[0] & ~(BIT(4) | BIT(5) | BIT(6));
-	/* Retry, PwrMgt, MoreData; set Protected */
-	aad[3] = (fc_pos[1] & ~(BIT(3) | BIT(4) | BIT(5))) | BIT(6);
+	put_unaligned_be16(len_a, &aad[0]);
+	put_unaligned(mask_fc, (__le16 *)&aad[2]);
 	memcpy(&aad[4], &hdr->addr1, 3 * ETH_ALEN);
 
 	/* Mask Seq#, leave Frag# */
 	aad[22] = *((u8 *) &hdr->seq_ctrl) & 0x0f;
 	aad[23] = 0;
+
 	if (a4_included) {
 		memcpy(&aad[24], hdr->addr4, ETH_ALEN);
-		aad[30] = 0;
+		aad[30] = qos_tid;
 		aad[31] = 0;
-	} else
+	} else {
 		memset(&aad[24], 0, ETH_ALEN + IEEE80211_QOS_CTL_LEN);
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
1.5.6.1.322.ge904b


