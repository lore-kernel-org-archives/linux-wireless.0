Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:11652 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbYGHS1Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 14:27:24 -0400
Received: by yx-out-2324.google.com with SMTP id 8so658804yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 11:27:24 -0700 (PDT)
Subject: [PATCH 2/8] mac80211: use symbolic defines in wpa.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 11:00:26 -0700
Message-Id: <1215540026.476.16.camel@brick> (sfid-20080708_202727_231771_875B85A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ETH_ALEN and IEEE80211_QOS_CTL_LEN

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/wpa.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index b414d5d..222001c 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -38,7 +38,7 @@ static int ieee80211_get_hdr_info(const struct sk_buff *skb, u8 **sa, u8 **da,
 	*data_len = skb->len - hdrlen;
 
 	if (ieee80211_is_data_qos(fc))
-		*qos_tid = (*ieee80211_get_qos_ctl(hdr) & 0x0f) | 0x80;
+		*qos_tid = (*ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK) | 0x80;
 	else
 		*qos_tid = 0;
 
@@ -312,7 +312,7 @@ static void ccmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *b_0, u8 *aad,
 	data_len -= CCMP_HDR_LEN + (encrypted ? CCMP_MIC_LEN : 0);
 	if (qos_tid & 0x80) {
 		qos_included = 1;
-		qos_tid &= 0x0f;
+		qos_tid &= IEEE80211_QOS_CTL_TID_MASK;
 	} else
 		qos_included = 0;
 	/* First block, b_0 */
@@ -320,7 +320,7 @@ static void ccmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *b_0, u8 *aad,
 	b_0[0] = 0x59; /* flags: Adata: 1, M: 011, L: 001 */
 	/* Nonce: QoS Priority | A2 | PN */
 	b_0[1] = qos_tid;
-	memcpy(&b_0[2], hdr->addr2, 6);
+	memcpy(&b_0[2], hdr->addr2, ETH_ALEN);
 	memcpy(&b_0[8], pn, CCMP_PN_LEN);
 	/* l(m) */
 	b_0[14] = (data_len >> 8) & 0xff;
@@ -332,7 +332,7 @@ static void ccmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *b_0, u8 *aad,
 
 	len_a = a4_included ? 28 : 22;
 	if (qos_included)
-		len_a += 2;
+		len_a += IEEE80211_QOS_CTL_LEN;
 
 	aad[0] = 0; /* (len_a >> 8) & 0xff; */
 	aad[1] = len_a & 0xff;
@@ -340,17 +340,17 @@ static void ccmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *b_0, u8 *aad,
 	aad[2] = fc_pos[0] & ~(BIT(4) | BIT(5) | BIT(6));
 	/* Retry, PwrMgt, MoreData; set Protected */
 	aad[3] = (fc_pos[1] & ~(BIT(3) | BIT(4) | BIT(5))) | BIT(6);
-	memcpy(&aad[4], &hdr->addr1, 18);
+	memcpy(&aad[4], &hdr->addr1, 3 * ETH_ALEN);
 
 	/* Mask Seq#, leave Frag# */
 	aad[22] = *((u8 *) &hdr->seq_ctrl) & 0x0f;
 	aad[23] = 0;
 	if (a4_included) {
-		memcpy(&aad[24], hdr->addr4, 6);
+		memcpy(&aad[24], hdr->addr4, ETH_ALEN);
 		aad[30] = 0;
 		aad[31] = 0;
 	} else
-		memset(&aad[24], 0, 8);
+		memset(&aad[24], 0, ETH_ALEN + IEEE80211_QOS_CTL_LEN);
 	if (qos_included) {
 		u8 *dpos = &aad[a4_included ? 30 : 24];
 
-- 
1.5.6.1.322.ge904b


