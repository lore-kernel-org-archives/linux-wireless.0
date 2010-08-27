Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:32183 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab0H0L1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 07:27:18 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com
Subject: [PATCHv2 2/4] mac80211: allow vendor specific cipher suites
Date: Fri, 27 Aug 2010 14:26:52 +0300
Message-Id: <1282908414-26783-3-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1282908414-26783-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1282908414-26783-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Allow drivers to specify their own set of cipher
suites to advertise vendor-specific ciphers. The
driver is then required to implement hardware
crypto offload for it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/mac80211/cfg.c         |    5 +++--
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/key.c         |   38 ++++++++++++++++++++++++++++++--------
 net/mac80211/key.h         |    6 +++---
 net/mac80211/main.c        |   44 ++++++++++++++++++++++++++++++++++++++------
 net/mac80211/rx.c          |    6 ++++++
 net/mac80211/tx.c          |   12 ++++++++++--
 7 files changed, 92 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5814382..f149b4e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -119,9 +119,10 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 		}
 	}
 
-	ieee80211_key_link(key, sdata, sta);
+	err = ieee80211_key_link(key, sdata, sta);
+	if (err)
+		ieee80211_key_free(sdata->local, key);
 
-	err = 0;
  out_unlock:
 	mutex_unlock(&sdata->local->sta_mtx);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e73ae51..0262dfe 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -662,6 +662,8 @@ struct ieee80211_local {
 	int fif_fcsfail, fif_plcpfail, fif_control, fif_other_bss, fif_pspoll;
 	unsigned int filter_flags; /* FIF_* */
 
+	bool wiphy_ciphers_allocated;
+
 	/* protects the aggregated multicast list and filter calls */
 	spinlock_t filter_lock;
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 2ce2dbb..3570f8c 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -60,7 +60,7 @@ static struct ieee80211_sta *get_sta_for_key(struct ieee80211_key *key)
 	return NULL;
 }
 
-static void ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
+static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_sta *sta;
@@ -68,8 +68,10 @@ static void ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 
 	might_sleep();
 
-	if (!key->local->ops->set_key)
-		return;
+	if (!key->local->ops->set_key) {
+		ret = -EOPNOTSUPP;
+		goto out_unsupported;
+	}
 
 	assert_key_lock(key->local);
 
@@ -90,6 +92,24 @@ static void ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		wiphy_err(key->local->hw.wiphy,
 			  "failed to set key (%d, %pM) to hardware (%d)\n",
 			  key->conf.keyidx, sta ? sta->addr : bcast_addr, ret);
+
+out_unsupported:
+	if (ret) {
+		switch (key->conf.cipher) {
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
+		case WLAN_CIPHER_SUITE_TKIP:
+		case WLAN_CIPHER_SUITE_CCMP:
+		case WLAN_CIPHER_SUITE_AES_CMAC:
+			/* all of these we can do in software */
+			ret = 0;
+			break;
+		default:
+			ret = -EINVAL;
+		}
+	}
+
+	return ret;
 }
 
 static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
@@ -329,12 +349,12 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key)
 	kfree(key);
 }
 
-void ieee80211_key_link(struct ieee80211_key *key,
-			struct ieee80211_sub_if_data *sdata,
-			struct sta_info *sta)
+int ieee80211_key_link(struct ieee80211_key *key,
+		       struct ieee80211_sub_if_data *sdata,
+		       struct sta_info *sta)
 {
 	struct ieee80211_key *old_key;
-	int idx;
+	int idx, ret;
 
 	BUG_ON(!sdata);
 	BUG_ON(!key);
@@ -389,9 +409,11 @@ void ieee80211_key_link(struct ieee80211_key *key,
 
 	ieee80211_debugfs_key_add(key);
 
-	ieee80211_key_enable_hw_accel(key);
+	ret = ieee80211_key_enable_hw_accel(key);
 
 	mutex_unlock(&sdata->local->key_mtx);
+
+	return ret;
 }
 
 static void __ieee80211_key_free(struct ieee80211_key *key)
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 53b5ce1..cb9a4a6 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -130,9 +130,9 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
  * Insert a key into data structures (sdata, sta if necessary)
  * to make it used, free old key.
  */
-void ieee80211_key_link(struct ieee80211_key *key,
-			struct ieee80211_sub_if_data *sdata,
-			struct sta_info *sta);
+int __must_check ieee80211_key_link(struct ieee80211_key *key,
+				    struct ieee80211_sub_if_data *sdata,
+				    struct sta_info *sta);
 void ieee80211_key_free(struct ieee80211_local *local,
 			struct ieee80211_key *key);
 void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 80db5ea..15f0e96 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -662,13 +662,40 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (local->hw.wiphy->max_scan_ie_len)
 		local->hw.wiphy->max_scan_ie_len -= local->scan_ies_len;
 
-	local->hw.wiphy->cipher_suites = cipher_suites;
-	local->hw.wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
-	if (!(local->hw.flags & IEEE80211_HW_MFP_CAPABLE))
-		local->hw.wiphy->n_cipher_suites--;
+	/* Set up cipher suites unless driver already did */
+	if (!local->hw.wiphy->cipher_suites) {
+		local->hw.wiphy->cipher_suites = cipher_suites;
+		local->hw.wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
+		if (!(local->hw.flags & IEEE80211_HW_MFP_CAPABLE))
+			local->hw.wiphy->n_cipher_suites--;
+	}
 	if (IS_ERR(local->wep_tx_tfm) || IS_ERR(local->wep_rx_tfm)) {
-		local->hw.wiphy->cipher_suites += 2;
-		local->hw.wiphy->n_cipher_suites -= 2;
+		if (local->hw.wiphy->cipher_suites == cipher_suites) {
+			local->hw.wiphy->cipher_suites += 2;
+			local->hw.wiphy->n_cipher_suites -= 2;
+		} else {
+			u32 *suites;
+			int r, w = 0;
+
+			/* Filter out WEP */
+
+			suites = kmemdup(
+				local->hw.wiphy->cipher_suites,
+				sizeof(u32) * local->hw.wiphy->n_cipher_suites,
+				GFP_KERNEL);
+			if (!suites)
+				return -ENOMEM;
+			for (r = 0; r < local->hw.wiphy->n_cipher_suites; r++) {
+				u32 suite = local->hw.wiphy->cipher_suites[r];
+				if (suite == WLAN_CIPHER_SUITE_WEP40 ||
+				    suite == WLAN_CIPHER_SUITE_WEP104)
+					continue;
+				suites[w++] = suite;
+			}
+			local->hw.wiphy->cipher_suites = suites;
+			local->hw.wiphy->n_cipher_suites = w;
+			local->wiphy_ciphers_allocated = true;
+		}
 	}
 
 	result = wiphy_register(local->hw.wiphy);
@@ -783,6 +810,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
  fail_workqueue:
 	wiphy_unregister(local->hw.wiphy);
  fail_wiphy_register:
+	if (local->wiphy_ciphers_allocated)
+		kfree(local->hw.wiphy->cipher_suites);
 	kfree(local->int_scan_req);
 	return result;
 }
@@ -840,6 +869,9 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
 	mutex_destroy(&local->iflist_mtx);
 	mutex_destroy(&local->mtx);
 
+	if (local->wiphy_ciphers_allocated)
+		kfree(local->hw.wiphy->cipher_suites);
+
 	wiphy_free(local->hw.wiphy);
 }
 EXPORT_SYMBOL(ieee80211_free_hw);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index e67deb4..6e5fb16 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1000,6 +1000,12 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		result = ieee80211_crypto_aes_cmac_decrypt(rx);
 		break;
+	default:
+		/*
+		 * We can reach here only with HW-only algorithms
+		 * but why didn't it decrypt the frame?!
+		 */
+		return RX_DROP_UNUSABLE;
 	}
 
 	/* either the frame has been decrypted or will be dropped */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a6ac9fd..31a8903 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -947,6 +947,8 @@ ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
 {
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+
 	if (!tx->key)
 		return TX_CONTINUE;
 
@@ -960,10 +962,16 @@ ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
 		return ieee80211_crypto_ccmp_encrypt(tx);
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		return ieee80211_crypto_aes_cmac_encrypt(tx);
+	default:
+		/* handle hw-only algorithm */
+		if (info->control.hw_key) {
+			ieee80211_tx_set_protected(tx);
+			return TX_CONTINUE;
+		}
+		break;
+
 	}
 
-	/* not reached */
-	WARN_ON(1);
 	return TX_DROP;
 }
 
-- 
1.6.3.3

