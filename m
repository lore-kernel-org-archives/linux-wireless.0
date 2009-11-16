Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbZKPNBn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 08:01:43 -0500
Message-Id: <20091116130052.775535988@sipsolutions.net>
Date: Mon, 16 Nov 2009 13:58:20 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mac80211: trim RX data
References: <20091116125819.757434347@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RX data contains the netdev, which is
duplicated since we have the sdata, and the
RX status pointer, which is duplicate since
we have the skb. Remove those two fields to
have fewer fields that depend on each other
and simply load them as necessary.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    2 -
 net/mac80211/rx.c          |   80 +++++++++++++++++++++++----------------------
 net/mac80211/wep.c         |    8 ++--
 net/mac80211/wpa.c         |   25 +++++++-------
 4 files changed, 61 insertions(+), 54 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-11-16 13:19:32.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-11-16 13:32:55.000000000 +0100
@@ -167,12 +167,10 @@ typedef unsigned __bitwise__ ieee80211_r
 
 struct ieee80211_rx_data {
 	struct sk_buff *skb;
-	struct net_device *dev;
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	struct ieee80211_key *key;
-	struct ieee80211_rx_status *status;
 	struct ieee80211_rate *rate;
 
 	unsigned int flags;
--- wireless-testing.orig/net/mac80211/rx.c	2009-11-16 13:19:31.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-11-16 13:32:55.000000000 +0100
@@ -477,7 +477,7 @@ ieee80211_rx_mesh_check(struct ieee80211
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	unsigned int hdrlen = ieee80211_hdrlen(hdr->frame_control);
-	char *dev_addr = rx->dev->dev_addr;
+	char *dev_addr = rx->sdata->dev->dev_addr;
 
 	if (ieee80211_is_data(hdr->frame_control)) {
 		if (is_multicast_ether_addr(hdr->addr1)) {
@@ -591,7 +591,9 @@ ieee80211_rx_h_check(struct ieee80211_rx
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
+	struct sk_buff *skb = rx->skb;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	int keyidx;
 	int hdrlen;
 	ieee80211_rx_result result = RX_DROP_UNUSABLE;
@@ -645,8 +647,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 			return RX_CONTINUE;
 	} else if (mmie_keyidx >= 0) {
 		/* Broadcast/multicast robust management frame / BIP */
-		if ((rx->status->flag & RX_FLAG_DECRYPTED) &&
-		    (rx->status->flag & RX_FLAG_IV_STRIPPED))
+		if ((status->flag & RX_FLAG_DECRYPTED) &&
+		    (status->flag & RX_FLAG_IV_STRIPPED))
 			return RX_CONTINUE;
 
 		if (mmie_keyidx < NUM_DEFAULT_KEYS ||
@@ -678,8 +680,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 		 * we somehow allow the driver to tell us which key
 		 * the hardware used if this flag is set?
 		 */
-		if ((rx->status->flag & RX_FLAG_DECRYPTED) &&
-		    (rx->status->flag & RX_FLAG_IV_STRIPPED))
+		if ((status->flag & RX_FLAG_DECRYPTED) &&
+		    (status->flag & RX_FLAG_IV_STRIPPED))
 			return RX_CONTINUE;
 
 		hdrlen = ieee80211_hdrlen(hdr->frame_control);
@@ -715,8 +717,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	/* Check for weak IVs if possible */
 	if (rx->sta && rx->key->conf.alg == ALG_WEP &&
 	    ieee80211_is_data(hdr->frame_control) &&
-	    (!(rx->status->flag & RX_FLAG_IV_STRIPPED) ||
-	     !(rx->status->flag & RX_FLAG_DECRYPTED)) &&
+	    (!(status->flag & RX_FLAG_IV_STRIPPED) ||
+	     !(status->flag & RX_FLAG_DECRYPTED)) &&
 	    ieee80211_wep_is_weak_iv(rx->skb, rx->key))
 		rx->sta->wep_weak_iv_count++;
 
@@ -736,7 +738,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	}
 
 	/* either the frame has been decrypted or will be dropped */
-	rx->status->flag |= RX_FLAG_DECRYPTED;
+	status->flag |= RX_FLAG_DECRYPTED;
 
 	return result;
 }
@@ -816,7 +818,9 @@ static ieee80211_rx_result debug_noinlin
 ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 {
 	struct sta_info *sta = rx->sta;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
+	struct sk_buff *skb = rx->skb;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
 	if (!sta)
 		return RX_CONTINUE;
@@ -847,8 +851,8 @@ ieee80211_rx_h_sta_process(struct ieee80
 
 	sta->rx_fragments++;
 	sta->rx_bytes += rx->skb->len;
-	sta->last_signal = rx->status->signal;
-	sta->last_noise = rx->status->noise;
+	sta->last_signal = status->signal;
+	sta->last_noise = status->noise;
 
 	/*
 	 * Change STA power saving mode only at the end of a frame
@@ -1140,11 +1144,14 @@ ieee80211_802_1x_port_control(struct iee
 static int
 ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx, __le16 fc)
 {
+	struct sk_buff *skb = rx->skb;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+
 	/*
 	 * Pass through unencrypted frames if the hardware has
 	 * decrypted them already.
 	 */
-	if (rx->status->flag & RX_FLAG_DECRYPTED)
+	if (status->flag & RX_FLAG_DECRYPTED)
 		return 0;
 
 	/* Drop unencrypted frames if key is set. */
@@ -1178,8 +1185,8 @@ ieee80211_drop_unencrypted(struct ieee80
 static int
 __ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 {
-	struct net_device *dev = rx->dev;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct net_device *dev = sdata->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN && !sdata->use_4addr &&
@@ -1205,7 +1212,7 @@ static bool ieee80211_frame_allowed(stru
 	 * of whether the frame was encrypted or not.
 	 */
 	if (ehdr->h_proto == htons(ETH_P_PAE) &&
-	    (compare_ether_addr(ehdr->h_dest, rx->dev->dev_addr) == 0 ||
+	    (compare_ether_addr(ehdr->h_dest, rx->sdata->dev->dev_addr) == 0 ||
 	     compare_ether_addr(ehdr->h_dest, pae_group_addr) == 0))
 		return true;
 
@@ -1222,10 +1229,10 @@ static bool ieee80211_frame_allowed(stru
 static void
 ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 {
-	struct net_device *dev = rx->dev;
+	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct net_device *dev = sdata->dev;
 	struct ieee80211_local *local = rx->local;
 	struct sk_buff *skb, *xmit_skb;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ethhdr *ehdr = (struct ethhdr *) rx->skb->data;
 	struct sta_info *dsta;
 
@@ -1306,7 +1313,7 @@ ieee80211_deliver_skb(struct ieee80211_r
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 {
-	struct net_device *dev = rx->dev;
+	struct net_device *dev = rx->sdata->dev;
 	struct ieee80211_local *local = rx->local;
 	u16 ethertype;
 	u8 *payload;
@@ -1431,12 +1438,11 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 	unsigned int hdrlen;
 	struct sk_buff *skb = rx->skb, *fwd_skb;
 	struct ieee80211_local *local = rx->local;
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = rx->sdata;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	mesh_hdr = (struct ieee80211s_hdr *) (skb->data + hdrlen);
-	sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
 
 	if (!ieee80211_is_data(hdr->frame_control))
 		return RX_CONTINUE;
@@ -1474,7 +1480,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 
 	/* Frame has reached destination.  Don't forward */
 	if (!is_multicast_ether_addr(hdr->addr1) &&
-			compare_ether_addr(rx->dev->dev_addr, hdr->addr3) == 0)
+	    compare_ether_addr(sdata->dev->dev_addr, hdr->addr3) == 0)
 		return RX_CONTINUE;
 
 	mesh_hdr->ttl--;
@@ -1491,10 +1497,10 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 
 			if (!fwd_skb && net_ratelimit())
 				printk(KERN_DEBUG "%s: failed to clone mesh frame\n",
-						   rx->dev->name);
+						   sdata->dev->name);
 
 			fwd_hdr =  (struct ieee80211_hdr *) fwd_skb->data;
-			memcpy(fwd_hdr->addr2, rx->dev->dev_addr, ETH_ALEN);
+			memcpy(fwd_hdr->addr2, sdata->dev->dev_addr, ETH_ALEN);
 			info = IEEE80211_SKB_CB(fwd_skb);
 			memset(info, 0, sizeof(*info));
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
@@ -1528,7 +1534,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 	}
 
 	if (is_multicast_ether_addr(hdr->addr1) ||
-	    rx->dev->flags & IFF_PROMISC)
+	    sdata->dev->flags & IFF_PROMISC)
 		return RX_CONTINUE;
 	else
 		return RX_DROP_MONITOR;
@@ -1538,9 +1544,9 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 {
-	struct net_device *dev = rx->dev;
+	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct net_device *dev = sdata->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	__le16 fc = hdr->frame_control;
 	int err;
 
@@ -1664,7 +1670,7 @@ static ieee80211_rx_result debug_noinlin
 ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_local *local = rx->local;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
+	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
 	int len = rx->skb->len;
 
@@ -1776,7 +1782,7 @@ ieee80211_rx_h_action(struct ieee80211_r
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
+	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
 
 	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
@@ -1852,7 +1858,7 @@ static void ieee80211_rx_cooked_monitor(
 	} __attribute__ ((packed)) *rthdr;
 	struct sk_buff *skb = rx->skb, *skb2;
 	struct net_device *prev_dev = NULL;
-	struct ieee80211_rx_status *status = rx->status;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
 	if (rx->flags & IEEE80211_RX_CMNTR_REPORTED)
 		goto out_free_skb;
@@ -1928,7 +1934,6 @@ static void ieee80211_invoke_rx_handlers
 
 	rx->skb = skb;
 	rx->sdata = sdata;
-	rx->dev = sdata->dev;
 
 #define CALL_RXH(rxh)			\
 	do {				\
@@ -1987,7 +1992,9 @@ static int prepare_for_handlers(struct i
 				struct ieee80211_rx_data *rx,
 				struct ieee80211_hdr *hdr)
 {
-	u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len, sdata->vif.type);
+	struct sk_buff *skb = rx->skb;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	u8 *bssid = ieee80211_get_bssid(hdr, skb->len, sdata->vif.type);
 	int multicast = is_multicast_ether_addr(hdr->addr1);
 
 	switch (sdata->vif.type) {
@@ -2019,10 +2026,10 @@ static int prepare_for_handlers(struct i
 			rx->flags &= ~IEEE80211_RX_RA_MATCH;
 		} else if (!rx->sta) {
 			int rate_idx;
-			if (rx->status->flag & RX_FLAG_HT)
+			if (status->flag & RX_FLAG_HT)
 				rate_idx = 0; /* TODO: HT rates */
 			else
-				rate_idx = rx->status->rate_idx;
+				rate_idx = status->rate_idx;
 			rx->sta = ieee80211_ibss_add_sta(sdata, bssid, hdr->addr2,
 				BIT(rate_idx));
 		}
@@ -2088,7 +2095,6 @@ static void __ieee80211_rx_handle_packet
 	memset(&rx, 0, sizeof(rx));
 	rx.skb = skb;
 	rx.local = local;
-	rx.status = status;
 	rx.rate = rate;
 
 	if (ieee80211_is_data(hdr->frame_control) || ieee80211_is_mgmt(hdr->frame_control))
@@ -2102,10 +2108,8 @@ static void __ieee80211_rx_handle_packet
 	ieee80211_verify_alignment(&rx);
 
 	rx.sta = sta_info_get(local, hdr->addr2);
-	if (rx.sta) {
+	if (rx.sta)
 		rx.sdata = rx.sta->sdata;
-		rx.dev = rx.sta->sdata->dev;
-	}
 
 	if (rx.sdata && ieee80211_is_data(hdr->frame_control)) {
 		rx.flags |= IEEE80211_RX_RA_MATCH;
--- wireless-testing.orig/net/mac80211/wep.c	2009-11-16 13:19:32.000000000 +0100
+++ wireless-testing/net/mac80211/wep.c	2009-11-16 13:32:55.000000000 +0100
@@ -281,16 +281,18 @@ bool ieee80211_wep_is_weak_iv(struct sk_
 ieee80211_rx_result
 ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
+	struct sk_buff *skb = rx->skb;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
 	if (!ieee80211_is_data(hdr->frame_control) &&
 	    !ieee80211_is_auth(hdr->frame_control))
 		return RX_CONTINUE;
 
-	if (!(rx->status->flag & RX_FLAG_DECRYPTED)) {
+	if (!(status->flag & RX_FLAG_DECRYPTED)) {
 		if (ieee80211_wep_decrypt(rx->local, rx->skb, rx->key))
 			return RX_DROP_UNUSABLE;
-	} else if (!(rx->status->flag & RX_FLAG_IV_STRIPPED)) {
+	} else if (!(status->flag & RX_FLAG_IV_STRIPPED)) {
 		ieee80211_wep_remove_iv(rx->local, rx->skb, rx->key);
 		/* remove ICV */
 		skb_trim(rx->skb, rx->skb->len - WEP_ICV_LEN);
--- wireless-testing.orig/net/mac80211/wpa.c	2009-11-16 13:19:32.000000000 +0100
+++ wireless-testing/net/mac80211/wpa.c	2009-11-16 13:32:55.000000000 +0100
@@ -85,16 +85,16 @@ ieee80211_rx_h_michael_mic_verify(struct
 	u8 *data, *key = NULL, key_offset;
 	size_t data_len;
 	unsigned int hdrlen;
-	struct ieee80211_hdr *hdr;
 	u8 mic[MICHAEL_MIC_LEN];
 	struct sk_buff *skb = rx->skb;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	int authenticator = 1, wpa_test = 0;
 
 	/* No way to verify the MIC if the hardware stripped it */
-	if (rx->status->flag & RX_FLAG_MMIC_STRIPPED)
+	if (status->flag & RX_FLAG_MMIC_STRIPPED)
 		return RX_CONTINUE;
 
-	hdr = (struct ieee80211_hdr *)skb->data;
 	if (!rx->key || rx->key->conf.alg != ALG_TKIP ||
 	    !ieee80211_has_protected(hdr->frame_control) ||
 	    !ieee80211_is_data_present(hdr->frame_control))
@@ -216,6 +216,7 @@ ieee80211_crypto_tkip_decrypt(struct iee
 	int hdrlen, res, hwaccel = 0, wpa_test = 0;
 	struct ieee80211_key *key = rx->key;
 	struct sk_buff *skb = rx->skb;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
@@ -225,8 +226,8 @@ ieee80211_crypto_tkip_decrypt(struct iee
 	if (!rx->sta || skb->len - hdrlen < 12)
 		return RX_DROP_UNUSABLE;
 
-	if (rx->status->flag & RX_FLAG_DECRYPTED) {
-		if (rx->status->flag & RX_FLAG_IV_STRIPPED) {
+	if (status->flag & RX_FLAG_DECRYPTED) {
+		if (status->flag & RX_FLAG_IV_STRIPPED) {
 			/*
 			 * Hardware took care of all processing, including
 			 * replay protection, and stripped the ICV/IV so
@@ -442,6 +443,7 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 	int hdrlen;
 	struct ieee80211_key *key = rx->key;
 	struct sk_buff *skb = rx->skb;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	u8 pn[CCMP_PN_LEN];
 	int data_len;
 
@@ -455,8 +457,8 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 	if (!rx->sta || data_len < 0)
 		return RX_DROP_UNUSABLE;
 
-	if ((rx->status->flag & RX_FLAG_DECRYPTED) &&
-	    (rx->status->flag & RX_FLAG_IV_STRIPPED))
+	if ((status->flag & RX_FLAG_DECRYPTED) &&
+	    (status->flag & RX_FLAG_IV_STRIPPED))
 		return RX_CONTINUE;
 
 	ccmp_hdr2pn(pn, skb->data + hdrlen);
@@ -466,7 +468,7 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 		return RX_DROP_UNUSABLE;
 	}
 
-	if (!(rx->status->flag & RX_FLAG_DECRYPTED)) {
+	if (!(status->flag & RX_FLAG_DECRYPTED)) {
 		/* hardware didn't decrypt/verify MIC */
 		ccmp_special_blocks(skb, pn, key->u.ccmp.rx_crypto_buf, 1);
 
@@ -563,6 +565,7 @@ ieee80211_rx_result
 ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx)
 {
 	struct sk_buff *skb = rx->skb;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_key *key = rx->key;
 	struct ieee80211_mmie *mmie;
 	u8 aad[20], mic[8], ipn[6];
@@ -571,8 +574,8 @@ ieee80211_crypto_aes_cmac_decrypt(struct
 	if (!ieee80211_is_mgmt(hdr->frame_control))
 		return RX_CONTINUE;
 
-	if ((rx->status->flag & RX_FLAG_DECRYPTED) &&
-	    (rx->status->flag & RX_FLAG_IV_STRIPPED))
+	if ((status->flag & RX_FLAG_DECRYPTED) &&
+	    (status->flag & RX_FLAG_IV_STRIPPED))
 		return RX_CONTINUE;
 
 	if (skb->len < 24 + sizeof(*mmie))
@@ -591,7 +594,7 @@ ieee80211_crypto_aes_cmac_decrypt(struct
 		return RX_DROP_UNUSABLE;
 	}
 
-	if (!(rx->status->flag & RX_FLAG_DECRYPTED)) {
+	if (!(status->flag & RX_FLAG_DECRYPTED)) {
 		/* hardware didn't decrypt/verify MIC */
 		bip_aad(skb, aad);
 		ieee80211_aes_cmac(key->u.aes_cmac.tfm,


