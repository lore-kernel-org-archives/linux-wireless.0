Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:52932 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaC0Jak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2014 05:30:40 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so2581752eek.39
        for <linux-wireless@vger.kernel.org>; Thu, 27 Mar 2014 02:30:38 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: add vif to flush call
Date: Thu, 27 Mar 2014 11:30:29 +0200
Message-Id: <1395912629-1458-1-git-send-email-egrumbach@gmail.com> (sfid-20140327_103047_313727_ADAEC912)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This will allow the low level driver to make decision based
on the vif such as queues etc...
Since the vif might be NULL, we can't add it to the tracing
functions.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/ath/ar5523/ar5523.c              | 3 ++-
 drivers/net/wireless/ath/ath10k/mac.c                 | 3 ++-
 drivers/net/wireless/ath/ath9k/main.c                 | 3 ++-
 drivers/net/wireless/ath/carl9170/main.c              | 4 +++-
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c | 3 ++-
 drivers/net/wireless/cw1200/sta.c                     | 3 ++-
 drivers/net/wireless/cw1200/sta.h                     | 3 ++-
 drivers/net/wireless/iwlegacy/common.c                | 3 ++-
 drivers/net/wireless/iwlegacy/common.h                | 3 ++-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c           | 3 ++-
 drivers/net/wireless/mac80211_hwsim.c                 | 4 +++-
 drivers/net/wireless/p54/main.c                       | 3 ++-
 drivers/net/wireless/rt2x00/rt2x00.h                  | 3 ++-
 drivers/net/wireless/rt2x00/rt2x00mac.c               | 3 ++-
 drivers/net/wireless/rtlwifi/core.c                   | 3 ++-
 drivers/net/wireless/ti/wlcore/main.c                 | 3 ++-
 include/net/mac80211.h                                | 4 +++-
 net/mac80211/driver-ops.h                             | 8 +++++++-
 net/mac80211/util.c                                   | 2 +-
 19 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 507d9a9..f920506 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1090,7 +1090,8 @@ static int ar5523_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	return ret;
 }
 
-static void ar5523_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+static void ar5523_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			 u32 queues, bool drop)
 {
 	struct ar5523 *ar = hw->priv;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 511a2f8..d1df993 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3544,7 +3544,8 @@ static int ath10k_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
 	return ret;
 }
 
-static void ath10k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+static void ath10k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			 u32 queues, bool drop)
 {
 	struct ath10k *ar = hw->priv;
 	bool skip;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index d69853b..49265c6 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1883,7 +1883,8 @@ static bool ath9k_has_tx_pending(struct ath_softc *sc)
 	return !!npend;
 }
 
-static void ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+static void ath9k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			u32 queues, bool drop)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 4c8cdb0..f8ded84 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1707,7 +1707,9 @@ found:
 	return 0;
 }
 
-static void carl9170_op_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+static void carl9170_op_flush(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      u32 queues, bool drop)
 {
 	struct ar9170 *ar = hw->priv;
 	unsigned int vid;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 8c5fa4e..43c71bf 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -897,7 +897,8 @@ static bool brcms_tx_flush_completed(struct brcms_info *wl)
 	return result;
 }
 
-static void brcms_ops_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+static void brcms_ops_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			    u32 queues, bool drop)
 {
 	struct brcms_info *wl = hw->priv;
 	int ret;
diff --git a/drivers/net/wireless/cw1200/sta.c b/drivers/net/wireless/cw1200/sta.c
index 103f7bc..cd0cad7 100644
--- a/drivers/net/wireless/cw1200/sta.c
+++ b/drivers/net/wireless/cw1200/sta.c
@@ -936,7 +936,8 @@ static int __cw1200_flush(struct cw1200_common *priv, bool drop)
 	return ret;
 }
 
-void cw1200_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+void cw1200_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		  u32 queues, bool drop)
 {
 	struct cw1200_common *priv = hw->priv;
 
diff --git a/drivers/net/wireless/cw1200/sta.h b/drivers/net/wireless/cw1200/sta.h
index 35babb6..b7e386b 100644
--- a/drivers/net/wireless/cw1200/sta.h
+++ b/drivers/net/wireless/cw1200/sta.h
@@ -40,7 +40,8 @@ int cw1200_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
 
 int cw1200_set_rts_threshold(struct ieee80211_hw *hw, u32 value);
 
-void cw1200_flush(struct ieee80211_hw *hw, u32 queues, bool drop);
+void cw1200_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		  u32 queues, bool drop);
 
 u64 cw1200_prepare_multicast(struct ieee80211_hw *hw,
 			     struct netdev_hw_addr_list *mc_list);
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 4f42174..ecc6746 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4755,7 +4755,8 @@ out:
 }
 EXPORT_SYMBOL(il_mac_change_interface);
 
-void il_mac_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+void il_mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		  u32 queues, bool drop)
 {
 	struct il_priv *il = hw->priv;
 	unsigned long timeout = jiffies + msecs_to_jiffies(500);
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index dfb13c7..ea5c0f8 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1723,7 +1723,8 @@ void il_mac_remove_interface(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif);
 int il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    enum nl80211_iftype newtype, bool newp2p);
-void il_mac_flush(struct ieee80211_hw *hw, u32 queues, bool drop);
+void il_mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		  u32 queues, bool drop);
 int il_alloc_txq_mem(struct il_priv *il);
 void il_free_txq_mem(struct il_priv *il);
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index d3abc15..29af7b5 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1091,7 +1091,8 @@ static void iwlagn_configure_filter(struct ieee80211_hw *hw,
 			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
 }
 
-static void iwlagn_mac_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+static void iwlagn_mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			     u32 queues, bool drop)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 9d7a52f..754c225 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1676,7 +1676,9 @@ static int mac80211_hwsim_ampdu_action(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static void mac80211_hwsim_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+static void mac80211_hwsim_flush(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif, u32 queues,
+				 bool drop)
 {
 	/* Not implemented, queues only on kernel side */
 }
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index eede90b..7be3a48 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -669,7 +669,8 @@ static unsigned int p54_flush_count(struct p54_common *priv)
 	return total;
 }
 
-static void p54_flush(struct ieee80211_hw *dev, u32 queues, bool drop)
+static void p54_flush(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
+		      u32 queues, bool drop)
 {
 	struct p54_common *priv = dev->priv;
 	unsigned int total, i;
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index e3b885d..010b765 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1448,7 +1448,8 @@ int rt2x00mac_conf_tx(struct ieee80211_hw *hw,
 		      struct ieee80211_vif *vif, u16 queue,
 		      const struct ieee80211_tx_queue_params *params);
 void rt2x00mac_rfkill_poll(struct ieee80211_hw *hw);
-void rt2x00mac_flush(struct ieee80211_hw *hw, u32 queues, bool drop);
+void rt2x00mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		     u32 queues, bool drop);
 int rt2x00mac_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant);
 int rt2x00mac_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant);
 void rt2x00mac_get_ringparam(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index ddeb5a7..30a2367 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -747,7 +747,8 @@ void rt2x00mac_rfkill_poll(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_rfkill_poll);
 
-void rt2x00mac_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+void rt2x00mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		     u32 queues, bool drop)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct data_queue *queue;
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index ded691f..442c762 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -1387,7 +1387,8 @@ static void rtl_op_rfkill_poll(struct ieee80211_hw *hw)
  * before switch channel or power save, or tx buffer packet
  * maybe send after offchannel or rf sleep, this may cause
  * dis-association by AP */
-static void rtl_op_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+static void rtl_op_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			 u32 queues, bool drop)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index ed88d39..077eb5b 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5184,7 +5184,8 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
-static void wlcore_op_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+static void wlcore_op_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			    u32 queues, bool drop)
 {
 	struct wl1271 *wl = hw->priv;
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2de7ff4..3fd772d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2609,6 +2609,7 @@ enum ieee80211_roc_type {
  *	of queues to flush, which is useful if different virtual interfaces
  *	use different hardware queues; it may also indicate all queues.
  *	If the parameter @drop is set to %true, pending frames may be dropped.
+ *	Note that vif can be NULL.
  *	The callback can sleep.
  *
  * @channel_switch: Drivers that need (or want) to offload the channel
@@ -2871,7 +2872,8 @@ struct ieee80211_ops {
 			     struct netlink_callback *cb,
 			     void *data, int len);
 #endif
-	void (*flush)(struct ieee80211_hw *hw, u32 queues, bool drop);
+	void (*flush)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		      u32 queues, bool drop);
 	void (*channel_switch)(struct ieee80211_hw *hw,
 			       struct ieee80211_channel_switch *ch_switch);
 	int (*set_antenna)(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index fc689f5..5331582 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -726,13 +726,19 @@ static inline void drv_rfkill_poll(struct ieee80211_local *local)
 }
 
 static inline void drv_flush(struct ieee80211_local *local,
+			     struct ieee80211_sub_if_data *sdata,
 			     u32 queues, bool drop)
 {
+	struct ieee80211_vif *vif = sdata ? &sdata->vif : NULL;
+
 	might_sleep();
 
+	if (sdata)
+		check_sdata_in_driver(sdata);
+
 	trace_drv_flush(local, queues, drop);
 	if (local->ops->flush)
-		local->ops->flush(&local->hw, queues, drop);
+		local->ops->flush(&local->hw, vif, queues, drop);
 	trace_drv_return_void(local);
 }
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 275c94f..5cf62ec 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -554,7 +554,7 @@ void ieee80211_flush_queues(struct ieee80211_local *local,
 	ieee80211_stop_queues_by_reason(&local->hw, IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_FLUSH);
 
-	drv_flush(local, queues, false);
+	drv_flush(local, sdata, queues, false);
 
 	ieee80211_wake_queues_by_reason(&local->hw, IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_FLUSH);
-- 
1.8.3.2

