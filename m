Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:34759 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab1FMWgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:36:06 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh04-2.mail.saunalahti.fi (Postfix) with SMTP id 1A47113BAF2
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:36:04 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh05.mail.saunalahti.fi (Postfix) with ESMTP id D1FA027D83
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:36:02 +0300 (EEST)
Subject: [PATCH v2 10/27] mac80211: rename ieee80211_tx_data to
	mac80211_tx_data
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:36:02 +0300
Message-ID: <20110613223602.10517.65013.stgit@localhost6.localdomain6> (sfid-20110614_005723_479248_3A9C8634)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/mac80211_i.h |    4 ++--
 net/mac80211/tx.c         |   40 ++++++++++++++++++++--------------------
 net/mac80211/util.c       |    2 +-
 net/mac80211/wep.c        |    4 ++--
 net/mac80211/wep.h        |    2 +-
 net/mac80211/wpa.c        |   12 ++++++------
 net/mac80211/wpa.h        |    8 ++++----
 7 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index 238228e..7def6bf 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -140,7 +140,7 @@ typedef unsigned __bitwise__ ieee80211_tx_result;
 #define IEEE80211_TX_UNICAST		BIT(1)
 #define IEEE80211_TX_PS_BUFFERED	BIT(2)
 
-struct ieee80211_tx_data {
+struct mac80211_tx_data {
 	struct sk_buff *skb;
 	struct mac80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
@@ -1075,7 +1075,7 @@ static inline int ieee80211_bssid_match(const u8 *raddr, const u8 *addr)
 
 
 int ieee80211_hw_config(struct mac80211_local *local, u32 changed);
-void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
+void ieee80211_tx_set_protected(struct mac80211_tx_data *tx);
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 				      u32 changed);
 void ieee80211_configure_filter(struct mac80211_local *local);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 99c9ab8..28811f4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -35,7 +35,7 @@
 
 /* misc utils */
 
-static __le16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
+static __le16 ieee80211_duration(struct mac80211_tx_data *tx, int group_addr,
 				 int next_frag_len)
 {
 	int rate, mrate, erp, dur, i;
@@ -177,7 +177,7 @@ static inline int is_ieee80211_device(struct mac80211_local *local,
 
 /* tx handlers */
 static ieee80211_tx_result debug_noinline
-ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
+ieee80211_tx_h_dynamic_ps(struct mac80211_tx_data *tx)
 {
 	struct mac80211_local *local = tx->local;
 	struct ieee80211_if_managed *ifmgd;
@@ -248,7 +248,7 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 }
 
 static ieee80211_tx_result debug_noinline
-ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
+ieee80211_tx_h_check_assoc(struct mac80211_tx_data *tx)
 {
 
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
@@ -362,7 +362,7 @@ static void purge_old_ps_buffers(struct mac80211_local *local)
 }
 
 static ieee80211_tx_result
-ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
+ieee80211_tx_h_multicast_ps_buf(struct mac80211_tx_data *tx)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
@@ -429,7 +429,7 @@ static int ieee80211_use_mfp(__le16 fc, struct sta_info *sta,
 }
 
 static ieee80211_tx_result
-ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
+ieee80211_tx_h_unicast_ps_buf(struct mac80211_tx_data *tx)
 {
 	struct sta_info *sta = tx->sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
@@ -502,7 +502,7 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 }
 
 static ieee80211_tx_result debug_noinline
-ieee80211_tx_h_ps_buf(struct ieee80211_tx_data *tx)
+ieee80211_tx_h_ps_buf(struct mac80211_tx_data *tx)
 {
 	if (unlikely(tx->flags & IEEE80211_TX_PS_BUFFERED))
 		return TX_CONTINUE;
@@ -514,7 +514,7 @@ ieee80211_tx_h_ps_buf(struct ieee80211_tx_data *tx)
 }
 
 static ieee80211_tx_result debug_noinline
-ieee80211_tx_h_check_control_port_protocol(struct ieee80211_tx_data *tx)
+ieee80211_tx_h_check_control_port_protocol(struct mac80211_tx_data *tx)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 
@@ -526,7 +526,7 @@ ieee80211_tx_h_check_control_port_protocol(struct ieee80211_tx_data *tx)
 }
 
 static ieee80211_tx_result debug_noinline
-ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
+ieee80211_tx_h_select_key(struct mac80211_tx_data *tx)
 {
 	struct ieee80211_key *key = NULL;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
@@ -598,7 +598,7 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 }
 
 static ieee80211_tx_result debug_noinline
-ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
+ieee80211_tx_h_rate_ctrl(struct mac80211_tx_data *tx)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (void *)tx->skb->data;
@@ -775,7 +775,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 }
 
 static ieee80211_tx_result debug_noinline
-ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
+ieee80211_tx_h_sequence(struct mac80211_tx_data *tx)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
@@ -879,7 +879,7 @@ static int ieee80211_fragment(struct mac80211_local *local,
 }
 
 static ieee80211_tx_result debug_noinline
-ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
+ieee80211_tx_h_fragment(struct mac80211_tx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -951,7 +951,7 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 }
 
 static ieee80211_tx_result debug_noinline
-ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
+ieee80211_tx_h_stats(struct mac80211_tx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
 
@@ -968,7 +968,7 @@ ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
 }
 
 static ieee80211_tx_result debug_noinline
-ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
+ieee80211_tx_h_encrypt(struct mac80211_tx_data *tx)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 
@@ -999,7 +999,7 @@ ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
 }
 
 static ieee80211_tx_result debug_noinline
-ieee80211_tx_h_calculate_duration(struct ieee80211_tx_data *tx)
+ieee80211_tx_h_calculate_duration(struct mac80211_tx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
 	struct ieee80211_hdr *hdr;
@@ -1026,7 +1026,7 @@ ieee80211_tx_h_calculate_duration(struct ieee80211_tx_data *tx)
  * deal with packet injection down monitor interface
  * with Radiotap Header -- only called for monitor mode interface
  */
-static bool __ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
+static bool __ieee80211_parse_tx_radiotap(struct mac80211_tx_data *tx,
 					  struct sk_buff *skb)
 {
 	/*
@@ -1116,7 +1116,7 @@ static bool __ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
 	return true;
 }
 
-static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
+static bool ieee80211_tx_prep_agg(struct mac80211_tx_data *tx,
 				  struct sk_buff *skb,
 				  struct ieee80211_tx_info *info,
 				  struct tid_ampdu_tx *tid_tx,
@@ -1174,7 +1174,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
  */
 static ieee80211_tx_result
 ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
-		     struct ieee80211_tx_data *tx,
+		     struct mac80211_tx_data *tx,
 		     struct sk_buff *skb)
 {
 	struct mac80211_local *local = sdata->local;
@@ -1380,7 +1380,7 @@ static bool __ieee80211_tx(struct mac80211_local *local, struct sk_buff **skbp,
  * Invoke TX handlers, return 0 on success and non-zero if the
  * frame was dropped or queued.
  */
-static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
+static int invoke_tx_handlers(struct mac80211_tx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1440,7 +1440,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 			 struct sk_buff *skb, bool txpending)
 {
 	struct mac80211_local *local = sdata->local;
-	struct ieee80211_tx_data tx;
+	struct mac80211_tx_data tx;
 	ieee80211_tx_result res_prepare;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	bool result = true;
@@ -2484,7 +2484,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 {
 	struct mac80211_local *local = hw_to_local(hw);
 	struct sk_buff *skb = NULL;
-	struct ieee80211_tx_data tx;
+	struct mac80211_tx_data tx;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_ap *bss = NULL;
 	struct beacon_data *beacon;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ae6daaa..5eef7cd 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -94,7 +94,7 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 	return NULL;
 }
 
-void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx)
+void ieee80211_tx_set_protected(struct mac80211_tx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
 	struct ieee80211_hdr *hdr;
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 0f599fb..a0a3f92 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -303,7 +303,7 @@ ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx)
 	return RX_CONTINUE;
 }
 
-static int wep_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
+static int wep_encrypt_skb(struct mac80211_tx_data *tx, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
@@ -324,7 +324,7 @@ static int wep_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 }
 
 ieee80211_tx_result
-ieee80211_crypto_wep_encrypt(struct ieee80211_tx_data *tx)
+ieee80211_crypto_wep_encrypt(struct mac80211_tx_data *tx)
 {
 	struct sk_buff *skb;
 
diff --git a/net/mac80211/wep.h b/net/mac80211/wep.h
index 1ef436c..24a01af 100644
--- a/net/mac80211/wep.h
+++ b/net/mac80211/wep.h
@@ -30,6 +30,6 @@ bool ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key);
 ieee80211_rx_result
 ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx);
 ieee80211_tx_result
-ieee80211_crypto_wep_encrypt(struct ieee80211_tx_data *tx);
+ieee80211_crypto_wep_encrypt(struct mac80211_tx_data *tx);
 
 #endif /* WEP_H */
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 6bc548f..cf45582 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -24,7 +24,7 @@
 #include "wpa.h"
 
 ieee80211_tx_result
-ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
+ieee80211_tx_h_michael_mic_add(struct mac80211_tx_data *tx)
 {
 	u8 *data, *key, *mic;
 	size_t data_len;
@@ -160,7 +160,7 @@ mic_fail:
 }
 
 
-static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
+static int tkip_encrypt_skb(struct mac80211_tx_data *tx, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_key *key = tx->key;
@@ -212,7 +212,7 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 
 
 ieee80211_tx_result
-ieee80211_crypto_tkip_encrypt(struct ieee80211_tx_data *tx)
+ieee80211_crypto_tkip_encrypt(struct mac80211_tx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
 
@@ -367,7 +367,7 @@ static inline void ccmp_hdr2pn(u8 *pn, u8 *hdr)
 }
 
 
-static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
+static int ccmp_encrypt_skb(struct mac80211_tx_data *tx, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_key *key = tx->key;
@@ -427,7 +427,7 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 
 
 ieee80211_tx_result
-ieee80211_crypto_ccmp_encrypt(struct ieee80211_tx_data *tx)
+ieee80211_crypto_ccmp_encrypt(struct mac80211_tx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
 
@@ -522,7 +522,7 @@ static inline void bip_ipn_swap(u8 *d, const u8 *s)
 
 
 ieee80211_tx_result
-ieee80211_crypto_aes_cmac_encrypt(struct ieee80211_tx_data *tx)
+ieee80211_crypto_aes_cmac_encrypt(struct mac80211_tx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
diff --git a/net/mac80211/wpa.h b/net/mac80211/wpa.h
index 2f4aa1b..474dec4 100644
--- a/net/mac80211/wpa.h
+++ b/net/mac80211/wpa.h
@@ -14,22 +14,22 @@
 #include "mac80211_i.h"
 
 ieee80211_tx_result
-ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx);
+ieee80211_tx_h_michael_mic_add(struct mac80211_tx_data *tx);
 ieee80211_rx_result
 ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx);
 
 ieee80211_tx_result
-ieee80211_crypto_tkip_encrypt(struct ieee80211_tx_data *tx);
+ieee80211_crypto_tkip_encrypt(struct mac80211_tx_data *tx);
 ieee80211_rx_result
 ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx);
 
 ieee80211_tx_result
-ieee80211_crypto_ccmp_encrypt(struct ieee80211_tx_data *tx);
+ieee80211_crypto_ccmp_encrypt(struct mac80211_tx_data *tx);
 ieee80211_rx_result
 ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx);
 
 ieee80211_tx_result
-ieee80211_crypto_aes_cmac_encrypt(struct ieee80211_tx_data *tx);
+ieee80211_crypto_aes_cmac_encrypt(struct mac80211_tx_data *tx);
 ieee80211_rx_result
 ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx);
 

