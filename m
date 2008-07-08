Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:11652 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbYGHS1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 14:27:32 -0400
Received: by yx-out-2324.google.com with SMTP id 8so658804yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 11:27:32 -0700 (PDT)
Subject: [PATCH 6/8] mac80211: wpa.c remove rx/tx_data ->fc users
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 11:00:28 -0700
Message-Id: <1215540028.476.20.camel@brick> (sfid-20080708_202735_659534_D19C020D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/wpa.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 241c932..ec2ae86 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -28,19 +28,16 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 	size_t data_len;
 	unsigned int hdrlen;
 	struct ieee80211_hdr *hdr;
-	u16 fc;
 	struct sk_buff *skb = tx->skb;
 	int authenticator;
 	int wpa_test = 0;
 	int tail;
 
-	fc = tx->fc;
-
+	hdr = (struct ieee80211_hdr *)skb->data;
 	if (!tx->key || tx->key->conf.alg != ALG_TKIP || skb->len < 24 ||
-	    !WLAN_FC_DATA_PRESENT(fc))
+	    !ieee80211_is_data_present(hdr->frame_control))
 		return TX_CONTINUE;
 
-	hdr = (struct ieee80211_hdr *)skb->data;
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	if (skb->len < hdrlen)
 		return TX_DROP;
@@ -90,25 +87,23 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 	size_t data_len;
 	unsigned int hdrlen;
 	struct ieee80211_hdr *hdr;
-	u16 fc;
 	u8 mic[MICHAEL_MIC_LEN];
 	struct sk_buff *skb = rx->skb;
 	int authenticator = 1, wpa_test = 0;
 	DECLARE_MAC_BUF(mac);
 
-	fc = rx->fc;
-
 	/*
 	 * No way to verify the MIC if the hardware stripped it
 	 */
 	if (rx->status->flag & RX_FLAG_MMIC_STRIPPED)
 		return RX_CONTINUE;
 
+	hdr = (struct ieee80211_hdr *)skb->data;
 	if (!rx->key || rx->key->conf.alg != ALG_TKIP ||
-	    !(rx->fc & IEEE80211_FCTL_PROTECTED) || !WLAN_FC_DATA_PRESENT(fc))
+	    !ieee80211_has_protected(hdr->frame_control) ||
+	    !ieee80211_is_data_present(hdr->frame_control))
 		return RX_CONTINUE;
 
-	hdr = (struct ieee80211_hdr *)skb->data;
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	if (skb->len < hdrlen + MICHAEL_MIC_LEN)
 		return RX_DROP_UNUSABLE;
@@ -239,7 +234,7 @@ ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
-	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
+	if (!ieee80211_is_data(hdr->frame_control))
 		return RX_CONTINUE;
 
 	if (!rx->sta || skb->len - hdrlen < 12)
@@ -458,7 +453,7 @@ ieee80211_crypto_ccmp_encrypt(struct ieee80211_tx_data *tx)
 ieee80211_rx_result
 ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	int hdrlen;
 	struct ieee80211_key *key = rx->key;
 	struct sk_buff *skb = rx->skb;
@@ -468,7 +463,7 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
-	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
+	if (!ieee80211_is_data(hdr->frame_control))
 		return RX_CONTINUE;
 
 	data_len = skb->len - hdrlen - CCMP_HDR_LEN - CCMP_MIC_LEN;
-- 
1.5.6.1.322.ge904b


