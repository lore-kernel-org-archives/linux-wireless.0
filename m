Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:39457 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab1FMWgl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:36:41 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh05-2.mail.saunalahti.fi (Postfix) with SMTP id CD9708C0CF
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:36:39 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh06.mail.saunalahti.fi (Postfix) with ESMTP id 87C9FE51A3
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:36:38 +0300 (EEST)
Subject: [PATCH v2 13/27] mac80211: rename ieee80211_rx_data to
	mac80211_rx_data
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:36:32 +0300
Message-ID: <20110613223632.10517.24934.stgit@localhost6.localdomain6> (sfid-20110614_005723_236935_A1B564AF)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/mac80211_i.h |    2 +
 net/mac80211/rx.c         |   70 +++++++++++++++++++++++----------------------
 net/mac80211/wep.c        |    2 +
 net/mac80211/wep.h        |    2 +
 net/mac80211/wpa.c        |    8 +++--
 net/mac80211/wpa.h        |    8 +++--
 6 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index c33df24..035905e 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -194,7 +194,7 @@ enum mac80211_i_rx_flags {
 	MAC80211_RX_CMNTR		= BIT(0),
 };
 
-struct ieee80211_rx_data {
+struct mac80211_rx_data {
 	struct sk_buff *skb;
 	struct mac80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8245813..3c55ec4 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -327,7 +327,7 @@ ieee80211_rx_monitor(struct mac80211_local *local, struct sk_buff *origskb,
 }
 
 
-static void ieee80211_parse_qos(struct ieee80211_rx_data *rx)
+static void ieee80211_parse_qos(struct mac80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
@@ -386,7 +386,7 @@ static void ieee80211_parse_qos(struct ieee80211_rx_data *rx)
  * the payload is not supported, the driver is required to move the 802.11
  * header to be directly in front of the payload in that case.
  */
-static void ieee80211_verify_alignment(struct ieee80211_rx_data *rx)
+static void ieee80211_verify_alignment(struct mac80211_rx_data *rx)
 {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	WARN_ONCE((unsigned long)rx->skb->data & 1,
@@ -398,7 +398,7 @@ static void ieee80211_verify_alignment(struct ieee80211_rx_data *rx)
 /* rx handlers */
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_passive_scan(struct mac80211_rx_data *rx)
 {
 	struct mac80211_local *local = rx->local;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
@@ -465,7 +465,7 @@ static int ieee80211_get_mmie_keyidx(struct sk_buff *skb)
 
 
 static ieee80211_rx_result
-ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
+ieee80211_rx_mesh_check(struct mac80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	unsigned int hdrlen = ieee80211_hdrlen(hdr->frame_control);
@@ -739,7 +739,7 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
  * Reorder MPDUs from A-MPDUs, keeping them on a buffer. Returns
  * true if the MPDU was buffered, false if it should be processed.
  */
-static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
+static void ieee80211_rx_reorder_ampdu(struct mac80211_rx_data *rx)
 {
 	struct sk_buff *skb = rx->skb;
 	struct mac80211_local *local = rx->local;
@@ -802,7 +802,7 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_check(struct mac80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
@@ -850,7 +850,7 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_decrypt(struct mac80211_rx_data *rx)
 {
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
@@ -1057,7 +1057,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_check_more_data(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_check_more_data(struct mac80211_rx_data *rx)
 {
 	struct mac80211_local *local;
 	struct ieee80211_hdr *hdr;
@@ -1148,7 +1148,7 @@ int ieee80211_sta_ps_transition(struct ieee80211_sta *sta, bool start)
 EXPORT_SYMBOL(ieee80211_sta_ps_transition);
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_sta_process(struct mac80211_rx_data *rx)
 {
 	struct sta_info *sta = rx->sta;
 	struct sk_buff *skb = rx->skb;
@@ -1337,7 +1337,7 @@ ieee80211_reassemble_find(struct ieee80211_sub_if_data *sdata,
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_defragment(struct mac80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr;
 	u16 sc;
@@ -1459,7 +1459,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_ps_poll(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_ps_poll(struct mac80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	__le16 fc = ((struct ieee80211_hdr *)rx->skb->data)->frame_control;
@@ -1486,7 +1486,7 @@ ieee80211_rx_h_ps_poll(struct ieee80211_rx_data *rx)
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_remove_qos_control(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_remove_qos_control(struct mac80211_rx_data *rx)
 {
 	u8 *data = rx->skb->data;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)data;
@@ -1505,7 +1505,7 @@ ieee80211_rx_h_remove_qos_control(struct ieee80211_rx_data *rx)
 }
 
 static int
-ieee80211_802_1x_port_control(struct ieee80211_rx_data *rx)
+ieee80211_802_1x_port_control(struct mac80211_rx_data *rx)
 {
 	if (unlikely(!rx->sta ||
 	    !test_sta_flags(rx->sta, WLAN_STA_AUTHORIZED)))
@@ -1515,7 +1515,7 @@ ieee80211_802_1x_port_control(struct ieee80211_rx_data *rx)
 }
 
 static int
-ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx, __le16 fc)
+ieee80211_drop_unencrypted(struct mac80211_rx_data *rx, __le16 fc)
 {
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
@@ -1538,7 +1538,7 @@ ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx, __le16 fc)
 }
 
 static int
-ieee80211_drop_unencrypted_mgmt(struct ieee80211_rx_data *rx)
+ieee80211_drop_unencrypted_mgmt(struct mac80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
@@ -1592,7 +1592,7 @@ ieee80211_drop_unencrypted_mgmt(struct ieee80211_rx_data *rx)
 }
 
 static int
-__ieee80211_data_to_8023(struct ieee80211_rx_data *rx, bool *port_control)
+__ieee80211_data_to_8023(struct mac80211_rx_data *rx, bool *port_control)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
@@ -1634,7 +1634,7 @@ __ieee80211_data_to_8023(struct ieee80211_rx_data *rx, bool *port_control)
 /*
  * requires that rx->skb is a frame with ethernet header
  */
-static bool ieee80211_frame_allowed(struct ieee80211_rx_data *rx, __le16 fc)
+static bool ieee80211_frame_allowed(struct mac80211_rx_data *rx, __le16 fc)
 {
 	static const u8 pae_group_addr[ETH_ALEN] __aligned(2)
 		= { 0x01, 0x80, 0xC2, 0x00, 0x00, 0x03 };
@@ -1660,7 +1660,7 @@ static bool ieee80211_frame_allowed(struct ieee80211_rx_data *rx, __le16 fc)
  * requires that rx->skb is a frame with ethernet header
  */
 static void
-ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
+ieee80211_deliver_skb(struct mac80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct net_device *dev = sdata->dev;
@@ -1745,7 +1745,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_amsdu(struct mac80211_rx_data *rx)
 {
 	struct net_device *dev = rx->sdata->dev;
 	struct sk_buff *skb = rx->skb;
@@ -1803,7 +1803,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 
 #ifdef CONFIG_MAC80211_MESH
 static ieee80211_rx_result
-ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_mesh_fwding(struct mac80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr;
 	struct ieee80211s_hdr *mesh_hdr;
@@ -1919,7 +1919,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 #endif
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_data(struct mac80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct mac80211_local *local = rx->local;
@@ -1978,7 +1978,7 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_ctrl(struct mac80211_rx_data *rx)
 {
 	struct mac80211_local *local = rx->local;
 	struct ieee80211_hw *hw = &local->hw;
@@ -2080,7 +2080,7 @@ static void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_mgmt_check(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_mgmt_check(struct mac80211_rx_data *rx)
 {
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
@@ -2106,7 +2106,7 @@ ieee80211_rx_h_mgmt_check(struct ieee80211_rx_data *rx)
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_action(struct mac80211_rx_data *rx)
 {
 	struct mac80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
@@ -2243,7 +2243,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_userspace_mgmt(struct mac80211_rx_data *rx)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
@@ -2272,7 +2272,7 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_action_return(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_action_return(struct mac80211_rx_data *rx)
 {
 	struct mac80211_local *local = rx->local;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
@@ -2320,7 +2320,7 @@ ieee80211_rx_h_action_return(struct ieee80211_rx_data *rx)
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_mgmt(struct mac80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	ieee80211_rx_result rxs;
@@ -2374,7 +2374,7 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 }
 
 /* TODO: use MAC80211_RX_FRAGMENTED */
-static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
+static void ieee80211_rx_cooked_monitor(struct mac80211_rx_data *rx,
 					struct ieee80211_rate *rate)
 {
 	struct ieee80211_sub_if_data *sdata;
@@ -2459,7 +2459,7 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 	dev_kfree_skb(skb);
 }
 
-static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
+static void ieee80211_rx_handlers_result(struct mac80211_rx_data *rx,
 					 ieee80211_rx_result res)
 {
 	switch (res) {
@@ -2494,7 +2494,7 @@ static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
 	}
 }
 
-static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx)
+static void ieee80211_rx_handlers(struct mac80211_rx_data *rx)
 {
 	ieee80211_rx_result res = RX_DROP_MONITOR;
 	struct sk_buff *skb;
@@ -2555,7 +2555,7 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx)
 	spin_unlock(&rx->local->rx_skb_queue.lock);
 }
 
-static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
+static void ieee80211_invoke_rx_handlers(struct mac80211_rx_data *rx)
 {
 	ieee80211_rx_result res = RX_DROP_MONITOR;
 
@@ -2586,7 +2586,7 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
  */
 void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 {
-	struct ieee80211_rx_data rx = {
+	struct mac80211_rx_data rx = {
 		.sta = sta,
 		.sdata = sta->sdata,
 		.local = sta->local,
@@ -2608,7 +2608,7 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 
 /* main receive path */
 
-static int prepare_for_handlers(struct ieee80211_rx_data *rx,
+static int prepare_for_handlers(struct mac80211_rx_data *rx,
 				struct ieee80211_hdr *hdr)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
@@ -2700,7 +2700,7 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
  * if consume is true, is equivalent to whether
  * or not the skb was consumed.
  */
-static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
+static bool ieee80211_prepare_and_rx_handle(struct mac80211_rx_data *rx,
 					    struct sk_buff *skb, bool consume)
 {
 	struct mac80211_local *local = rx->local;
@@ -2745,7 +2745,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hdr *hdr;
 	__le16 fc;
-	struct ieee80211_rx_data rx;
+	struct mac80211_rx_data rx;
 	struct ieee80211_sub_if_data *prev;
 	struct sta_info *sta, *tmp, *prev_sta;
 	int err = 0;
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index a0a3f92..1a7c0cc 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -281,7 +281,7 @@ bool ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key)
 }
 
 ieee80211_rx_result
-ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx)
+ieee80211_crypto_wep_decrypt(struct mac80211_rx_data *rx)
 {
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
diff --git a/net/mac80211/wep.h b/net/mac80211/wep.h
index 24a01af..e1d3bad 100644
--- a/net/mac80211/wep.h
+++ b/net/mac80211/wep.h
@@ -28,7 +28,7 @@ int ieee80211_wep_decrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
 bool ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key);
 
 ieee80211_rx_result
-ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx);
+ieee80211_crypto_wep_decrypt(struct mac80211_rx_data *rx);
 ieee80211_tx_result
 ieee80211_crypto_wep_encrypt(struct mac80211_tx_data *tx);
 
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index cf45582..c09e05d 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -77,7 +77,7 @@ ieee80211_tx_h_michael_mic_add(struct mac80211_tx_data *tx)
 
 
 ieee80211_rx_result
-ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_michael_mic_verify(struct mac80211_rx_data *rx)
 {
 	u8 *data, *key = NULL;
 	size_t data_len;
@@ -228,7 +228,7 @@ ieee80211_crypto_tkip_encrypt(struct mac80211_tx_data *tx)
 
 
 ieee80211_rx_result
-ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
+ieee80211_crypto_tkip_decrypt(struct mac80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
 	int hdrlen, res, hwaccel = 0;
@@ -443,7 +443,7 @@ ieee80211_crypto_ccmp_encrypt(struct mac80211_tx_data *tx)
 
 
 ieee80211_rx_result
-ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
+ieee80211_crypto_ccmp_decrypt(struct mac80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	int hdrlen;
@@ -565,7 +565,7 @@ ieee80211_crypto_aes_cmac_encrypt(struct mac80211_tx_data *tx)
 
 
 ieee80211_rx_result
-ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx)
+ieee80211_crypto_aes_cmac_decrypt(struct mac80211_rx_data *rx)
 {
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
diff --git a/net/mac80211/wpa.h b/net/mac80211/wpa.h
index 474dec4..1b089d4 100644
--- a/net/mac80211/wpa.h
+++ b/net/mac80211/wpa.h
@@ -16,21 +16,21 @@
 ieee80211_tx_result
 ieee80211_tx_h_michael_mic_add(struct mac80211_tx_data *tx);
 ieee80211_rx_result
-ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx);
+ieee80211_rx_h_michael_mic_verify(struct mac80211_rx_data *rx);
 
 ieee80211_tx_result
 ieee80211_crypto_tkip_encrypt(struct mac80211_tx_data *tx);
 ieee80211_rx_result
-ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx);
+ieee80211_crypto_tkip_decrypt(struct mac80211_rx_data *rx);
 
 ieee80211_tx_result
 ieee80211_crypto_ccmp_encrypt(struct mac80211_tx_data *tx);
 ieee80211_rx_result
-ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx);
+ieee80211_crypto_ccmp_decrypt(struct mac80211_rx_data *rx);
 
 ieee80211_tx_result
 ieee80211_crypto_aes_cmac_encrypt(struct mac80211_tx_data *tx);
 ieee80211_rx_result
-ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx);
+ieee80211_crypto_aes_cmac_decrypt(struct mac80211_rx_data *rx);
 
 #endif /* WPA_H */

