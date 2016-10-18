Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49450 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932875AbcJRUMZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 16:12:25 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 18 Oct 2016 23:12:11 +0300
Message-Id: <20161018201213.18873-6-luca@coelho.fi> (sfid-20161018_221233_949551_AEF38A27)
In-Reply-To: <20161018201213.18873-1-luca@coelho.fi>
References: <20161018201213.18873-1-luca@coelho.fi>
Subject: [PATCH 5/7] mac80211: add a HW flag for supporting HW TX fragmentation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently mac80211 determines whether HW does fragmentation
by checking whether the set_frag_threshold callback is set
or not.
However, some drivers may want to set the HW fragmentation
capability depending on HW generation.
Allow this by checking a HW flag instead of checking the
callback.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
[added the flag to ath10k and wlcore]
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |  1 +
 drivers/net/wireless/ti/wlcore/main.c |  1 +
 include/net/mac80211.h                | 10 ++++++++--
 net/mac80211/debugfs.c                |  1 +
 net/mac80211/main.c                   |  4 ++++
 net/mac80211/tx.c                     |  4 ++--
 net/mac80211/wpa.c                    |  2 +-
 7 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 76297d6..e322b6d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7881,6 +7881,7 @@ int ath10k_mac_register(struct ath10k *ar)
 	ieee80211_hw_set(ar->hw, WANT_MONITOR_VIF);
 	ieee80211_hw_set(ar->hw, CHANCTX_STA_CSA);
 	ieee80211_hw_set(ar->hw, QUEUE_CONTROL);
+	ieee80211_hw_set(ar->hw, SUPPORTS_TX_FRAG);
 
 	if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
 		ieee80211_hw_set(ar->hw, SW_CRYPTO_CONTROL);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 471521a..9f39c6c 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6086,6 +6086,7 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	ieee80211_hw_set(wl->hw, SUPPORTS_DYNAMIC_PS);
 	ieee80211_hw_set(wl->hw, SIGNAL_DBM);
 	ieee80211_hw_set(wl->hw, SUPPORTS_PS);
+	ieee80211_hw_set(wl->hw, SUPPORTS_TX_FRAG);
 
 	wl->hw->wiphy->cipher_suites = cipher_suites;
 	wl->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f3dbada..a1a2702 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2025,6 +2025,10 @@ struct ieee80211_txq {
  *	drivers, mac80211 packet loss mechanism will not be triggered and driver
  *	is completely depending on firmware event for station kickout.
  *
+ * @IEEE80211_HW_SUPPORTS_TX_FRAG: Hardware does fragmentation by itself.
+ *	The stack will not do fragmentation.
+ *	The callback for @set_frag_threshold should be set as well.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2066,6 +2070,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TX_AMSDU,
 	IEEE80211_HW_TX_FRAG_LIST,
 	IEEE80211_HW_REPORTS_LOW_ACK,
+	IEEE80211_HW_SUPPORTS_TX_FRAG,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
@@ -3093,8 +3098,9 @@ enum ieee80211_reconfig_type {
  *	The callback must be atomic.
  *
  * @set_frag_threshold: Configuration of fragmentation threshold. Assign this
- *	if the device does fragmentation by itself; if this callback is
- *	implemented then the stack will not do fragmentation.
+ *	if the device does fragmentation by itself. Note that to prevent the
+ *	stack from doing fragmentation IEEE80211_HW_SUPPORTS_TX_FRAG
+ *	should be set as well.
  *	The callback can sleep.
  *
  * @set_rts_threshold: Configuration of RTS threshold (if device needs it)
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index f56e2f4..e02ba42 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -210,6 +210,7 @@ static const char *hw_flag_names[] = {
 	FLAG(TX_AMSDU),
 	FLAG(TX_FRAG_LIST),
 	FLAG(REPORTS_LOW_ACK),
+	FLAG(SUPPORTS_TX_FRAG),
 #undef FLAG
 };
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 1075ac2..0d9163c 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -821,6 +821,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	     !local->ops->tdls_recv_channel_switch))
 		return -EOPNOTSUPP;
 
+	if (WARN_ON(ieee80211_hw_check(hw, SUPPORTS_TX_FRAG) &&
+		    !local->ops->set_frag_threshold))
+		return -EINVAL;
+
 	if (WARN_ON(local->hw.wiphy->interface_modes &
 			BIT(NL80211_IFTYPE_NAN) &&
 		    (!local->ops->start_nan || !local->ops->stop_nan)))
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 772e369..62ccaf6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -934,7 +934,7 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 	if (info->flags & IEEE80211_TX_CTL_DONTFRAG)
 		return TX_CONTINUE;
 
-	if (tx->local->ops->set_frag_threshold)
+	if (ieee80211_hw_check(&tx->local->hw, SUPPORTS_TX_FRAG))
 		return TX_CONTINUE;
 
 	/*
@@ -2800,7 +2800,7 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 
 	/* fast-xmit doesn't handle fragmentation at all */
 	if (local->hw.wiphy->frag_threshold != (u32)-1 &&
-	    !local->ops->set_frag_threshold)
+	    !ieee80211_hw_check(&local->hw, SUPPORTS_TX_FRAG))
 		goto out;
 
 	rcu_read_lock();
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index b48c1e1..c249345 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -57,7 +57,7 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 
 	if (info->control.hw_key &&
 	    (info->flags & IEEE80211_TX_CTL_DONTFRAG ||
-	     tx->local->ops->set_frag_threshold) &&
+	     ieee80211_hw_check(&tx->local->hw, SUPPORTS_TX_FRAG)) &&
 	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC)) {
 		/* hwaccel - with no need for SW-generated MMIC */
 		return TX_CONTINUE;
-- 
2.9.3
