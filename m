Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:2940 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbYFKVWK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 17:22:10 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3278785wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 14:22:10 -0700 (PDT)
Subject: [PATCHv2 06/11] mac80211: wpa.c use new access helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 11 Jun 2008 14:21:58 -0700
Message-Id: <1213219318.5974.179.camel@brick> (sfid-20080611_232215_284508_6028BFF0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/wpa.c |   63 +++++++++++++--------------------------------------
 1 files changed, 16 insertions(+), 47 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 9f6fd20..9834cec 100644
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
-
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
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = hdr->frame_control;
 
-	if (fc & 0x80)
-		hdrlen += 2;
+	hdrlen = ieee80211_hdrlen(fc);
+
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
+	if (ieee80211_is_data_qos(fc))
+		*qos_tid = (*ieee80211_get_qos_ctl(hdr) & 0x0f) | 0x80;
+	else
 		*qos_tid = 0;
 
 	return skb->len < hdrlen ? -1 : 0;
@@ -186,8 +162,8 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_key *key = tx->key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int hdrlen, len, tail;
-	u16 fc;
+	unsigned int hdrlen;
+	int len, tail;
 	u8 *pos;
 
 	info->control.icv_len = TKIP_ICV_LEN;
@@ -200,8 +176,7 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 		return 0;
 	}
 
-	fc = le16_to_cpu(hdr->frame_control);
-	hdrlen = ieee80211_get_hdrlen(fc);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	len = skb->len - hdrlen;
 
 	if (tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
@@ -272,14 +247,12 @@ ieee80211_rx_result
 ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
-	u16 fc;
 	int hdrlen, res, hwaccel = 0, wpa_test = 0;
 	struct ieee80211_key *key = rx->key;
 	struct sk_buff *skb = rx->skb;
 	DECLARE_MAC_BUF(mac);
 
-	fc = le16_to_cpu(hdr->frame_control);
-	hdrlen = ieee80211_get_hdrlen(fc);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
 	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
 		return RX_CONTINUE;
@@ -427,7 +400,6 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	struct ieee80211_key *key = tx->key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int hdrlen, len, tail;
-	u16 fc;
 	u8 *pos, *pn, *b_0, *aad, *scratch;
 	int i;
 
@@ -446,8 +418,7 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	b_0 = scratch + 3 * AES_BLOCK_LEN;
 	aad = scratch + 4 * AES_BLOCK_LEN;
 
-	fc = le16_to_cpu(hdr->frame_control);
-	hdrlen = ieee80211_get_hdrlen(fc);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	len = skb->len - hdrlen;
 
 	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
@@ -516,7 +487,6 @@ ieee80211_rx_result
 ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
-	u16 fc;
 	int hdrlen;
 	struct ieee80211_key *key = rx->key;
 	struct sk_buff *skb = rx->skb;
@@ -524,8 +494,7 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 	int data_len;
 	DECLARE_MAC_BUF(mac);
 
-	fc = le16_to_cpu(hdr->frame_control);
-	hdrlen = ieee80211_get_hdrlen(fc);
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
 	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
 		return RX_CONTINUE;
-- 
1.5.6.rc2.261.ga8fbe


