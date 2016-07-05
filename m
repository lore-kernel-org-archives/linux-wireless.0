Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:32930 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755034AbcGEMX1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 08:23:27 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>,
	Assaf Krauss <assaf.krauss@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  5 Jul 2016 15:23:12 +0300
Message-Id: <1467721394-8195-6-git-send-email-luca@coelho.fi> (sfid-20160705_142336_612796_B32E7195)
In-Reply-To: <1467721394-8195-1-git-send-email-luca@coelho.fi>
References: <1467721394-8195-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 5/7] mac80211: Add support for beacon report radio measurement
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Add the following to support beacon report radio measurement
with the measurement mode field set to passive or active:
1. Propagate the required scan duration to the device
2. Report the scan start time (in terms of TSF)
3. Report each BSS's detection time (also in terms of TSF)

TSF times refer to the BSS that the interface that requested the
scan is connected to.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
[changed ath9k/10k, at76c59x-usb, iwlegacy, wl1251 and wlcore to match
the new API]
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/ath/ath10k/mac.c         | 14 +++++----
 drivers/net/wireless/ath/ath9k/channel.c      |  5 +++-
 drivers/net/wireless/atmel/at76c50x-usb.c     |  5 +++-
 drivers/net/wireless/intel/iwlegacy/common.c  |  6 +++-
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c |  6 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 37 ++++++++++++++++++-----
 drivers/net/wireless/mac80211_hwsim.c         | 11 +++++--
 drivers/net/wireless/st/cw1200/scan.c         |  6 +++-
 drivers/net/wireless/ti/wl1251/event.c        |  6 +++-
 drivers/net/wireless/ti/wl1251/main.c         |  6 +++-
 drivers/net/wireless/ti/wlcore/main.c         | 11 +++++--
 drivers/net/wireless/ti/wlcore/scan.c         |  5 +++-
 include/net/mac80211.h                        |  5 ++--
 net/mac80211/ieee80211_i.h                    |  1 +
 net/mac80211/scan.c                           | 42 ++++++++++++++++++++++-----
 15 files changed, 131 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d4b7a16..ebc12c5 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3858,12 +3858,16 @@ void __ath10k_scan_finish(struct ath10k *ar)
 		break;
 	case ATH10K_SCAN_RUNNING:
 	case ATH10K_SCAN_ABORTING:
-		if (!ar->scan.is_roc)
-			ieee80211_scan_completed(ar->hw,
-						 (ar->scan.state ==
-						  ATH10K_SCAN_ABORTING));
-		else if (ar->scan.roc_notify)
+		if (!ar->scan.is_roc) {
+			struct cfg80211_scan_info info = {
+				.aborted = (ar->scan.state ==
+					    ATH10K_SCAN_ABORTING),
+			};
+
+			ieee80211_scan_completed(ar->hw, &info);
+		} else if (ar->scan.roc_notify) {
 			ieee80211_remain_on_channel_expired(ar->hw);
+		}
 		/* fall through */
 	case ATH10K_SCAN_STARTING:
 		ar->scan.state = ATH10K_SCAN_IDLE;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index e56bafc..57e26a6 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -960,6 +960,9 @@ void ath_roc_complete(struct ath_softc *sc, enum ath_roc_complete_reason reason)
 void ath_scan_complete(struct ath_softc *sc, bool abort)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct cfg80211_scan_info info = {
+		.aborted = abort,
+	};
 
 	if (abort)
 		ath_dbg(common, CHAN_CTX, "HW scan aborted\n");
@@ -969,7 +972,7 @@ void ath_scan_complete(struct ath_softc *sc, bool abort)
 	sc->offchannel.scan_req = NULL;
 	sc->offchannel.scan_vif = NULL;
 	sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
-	ieee80211_scan_completed(sc->hw, abort);
+	ieee80211_scan_completed(sc->hw, &info);
 	clear_bit(ATH_OP_SCANNING, &common->op_flags);
 	spin_lock_bh(&sc->chan_lock);
 	if (test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags))
diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index 7c10804..0e18067 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -1922,6 +1922,9 @@ static void at76_dwork_hw_scan(struct work_struct *work)
 {
 	struct at76_priv *priv = container_of(work, struct at76_priv,
 					      dwork_hw_scan.work);
+	struct cfg80211_scan_info info = {
+		.aborted = false,
+	};
 	int ret;
 
 	if (priv->device_unplugged)
@@ -1948,7 +1951,7 @@ static void at76_dwork_hw_scan(struct work_struct *work)
 
 	mutex_unlock(&priv->mtx);
 
-	ieee80211_scan_completed(priv->hw, false);
+	ieee80211_scan_completed(priv->hw, &info);
 
 	ieee80211_wake_queues(priv->hw);
 }
diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index eb24b92..140b6ea 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -1305,10 +1305,14 @@ il_send_scan_abort(struct il_priv *il)
 static void
 il_complete_scan(struct il_priv *il, bool aborted)
 {
+	struct cfg80211_scan_info info = {
+		.aborted = aborted,
+	};
+
 	/* check if scan was requested from mac80211 */
 	if (il->scan_request) {
 		D_SCAN("Complete scan in mac80211\n");
-		ieee80211_scan_completed(il->hw, aborted);
+		ieee80211_scan_completed(il->hw, &info);
 	}
 
 	il->scan_vif = NULL;
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
index d01766f..17e6a32 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
@@ -94,10 +94,14 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 
 static void iwl_complete_scan(struct iwl_priv *priv, bool aborted)
 {
+	struct cfg80211_scan_info info = {
+		.aborted = aborted,
+	};
+
 	/* check if scan was requested from mac80211 */
 	if (priv->scan_request) {
 		IWL_DEBUG_SCAN(priv, "Complete scan in mac80211\n");
-		ieee80211_scan_completed(priv->hw, aborted);
+		ieee80211_scan_completed(priv->hw, &info);
 	}
 
 	priv->scan_type = IWL_SCAN_NORMAL;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index e78fc56..1cac10c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -391,13 +391,16 @@ void iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
 		ieee80211_sched_scan_stopped(mvm->hw);
 		mvm->sched_scan_pass_all = SCHED_SCAN_PASS_ALL_DISABLED;
 	} else if (mvm->scan_status & IWL_MVM_SCAN_REGULAR) {
+		struct cfg80211_scan_info info = {
+			.aborted = aborted,
+		};
+
 		IWL_DEBUG_SCAN(mvm, "Regular scan %s, EBS status %s (FW)\n",
 			       aborted ? "aborted" : "completed",
 			       iwl_mvm_ebs_status_str(scan_notif->ebs_status));
 
 		mvm->scan_status &= ~IWL_MVM_SCAN_REGULAR;
-		ieee80211_scan_completed(mvm->hw,
-				scan_notif->status == IWL_SCAN_OFFLOAD_ABORTED);
+		ieee80211_scan_completed(mvm->hw, &info);
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
 		del_timer(&mvm->scan_timer);
 	} else {
@@ -1430,7 +1433,11 @@ void iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 
 	/* if the scan is already stopping, we don't need to notify mac80211 */
 	if (mvm->scan_uid_status[uid] == IWL_MVM_SCAN_REGULAR) {
-		ieee80211_scan_completed(mvm->hw, aborted);
+		struct cfg80211_scan_info info = {
+			.aborted = aborted,
+		};
+
+		ieee80211_scan_completed(mvm->hw, &info);
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
 		del_timer(&mvm->scan_timer);
 	} else if (mvm->scan_uid_status[uid] == IWL_MVM_SCAN_SCHED) {
@@ -1564,7 +1571,11 @@ void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm)
 
 		uid = iwl_mvm_scan_uid_by_status(mvm, IWL_MVM_SCAN_REGULAR);
 		if (uid >= 0) {
-			ieee80211_scan_completed(mvm->hw, true);
+			struct cfg80211_scan_info info = {
+				.aborted = true,
+			};
+
+			ieee80211_scan_completed(mvm->hw, &info);
 			mvm->scan_uid_status[uid] = 0;
 		}
 		uid = iwl_mvm_scan_uid_by_status(mvm, IWL_MVM_SCAN_SCHED);
@@ -1585,8 +1596,13 @@ void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm)
 				mvm->scan_uid_status[i] = 0;
 		}
 	} else {
-		if (mvm->scan_status & IWL_MVM_SCAN_REGULAR)
-			ieee80211_scan_completed(mvm->hw, true);
+		if (mvm->scan_status & IWL_MVM_SCAN_REGULAR) {
+			struct cfg80211_scan_info info = {
+				.aborted = true,
+			};
+
+			ieee80211_scan_completed(mvm->hw, &info);
+		}
 
 		/* Sched scan will be restarted by mac80211 in
 		 * restart_hw, so do not report if FW is about to be
@@ -1629,8 +1645,13 @@ out:
 		 */
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
 		del_timer(&mvm->scan_timer);
-		if (notify)
-			ieee80211_scan_completed(mvm->hw, true);
+		if (notify) {
+			struct cfg80211_scan_info info = {
+				.aborted = true,
+			};
+
+			ieee80211_scan_completed(mvm->hw, &info);
+		}
 	} else if (notify) {
 		ieee80211_sched_scan_stopped(mvm->hw);
 		mvm->sched_scan_pass_all = SCHED_SCAN_PASS_ALL_DISABLED;
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 97196c4..2ddde1a 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1941,8 +1941,12 @@ static void hw_scan_work(struct work_struct *work)
 
 	mutex_lock(&hwsim->mutex);
 	if (hwsim->scan_chan_idx >= req->n_channels) {
+		struct cfg80211_scan_info info = {
+			.aborted = false,
+		};
+
 		wiphy_debug(hwsim->hw->wiphy, "hw scan complete\n");
-		ieee80211_scan_completed(hwsim->hw, false);
+		ieee80211_scan_completed(hwsim->hw, &info);
 		hwsim->hw_scan_request = NULL;
 		hwsim->hw_scan_vif = NULL;
 		hwsim->tmp_chan = NULL;
@@ -2027,13 +2031,16 @@ static void mac80211_hwsim_cancel_hw_scan(struct ieee80211_hw *hw,
 					  struct ieee80211_vif *vif)
 {
 	struct mac80211_hwsim_data *hwsim = hw->priv;
+	struct cfg80211_scan_info info = {
+		.aborted = true,
+	};
 
 	wiphy_debug(hw->wiphy, "hwsim cancel_hw_scan\n");
 
 	cancel_delayed_work_sync(&hwsim->hw_scan);
 
 	mutex_lock(&hwsim->mutex);
-	ieee80211_scan_completed(hwsim->hw, true);
+	ieee80211_scan_completed(hwsim->hw, &info);
 	hwsim->tmp_chan = NULL;
 	hwsim->hw_scan_request = NULL;
 	hwsim->hw_scan_vif = NULL;
diff --git a/drivers/net/wireless/st/cw1200/scan.c b/drivers/net/wireless/st/cw1200/scan.c
index 9837881..0a0ff7e 100644
--- a/drivers/net/wireless/st/cw1200/scan.c
+++ b/drivers/net/wireless/st/cw1200/scan.c
@@ -167,6 +167,10 @@ void cw1200_scan_work(struct work_struct *work)
 	}
 
 	if (!priv->scan.req || (priv->scan.curr == priv->scan.end)) {
+		struct cfg80211_scan_info info = {
+			.aborted = priv->scan.status ? 1 : 0,
+		};
+
 		if (priv->scan.output_power != priv->output_power)
 			wsm_set_output_power(priv, priv->output_power * 10);
 		if (priv->join_status == CW1200_JOIN_STATUS_STA &&
@@ -188,7 +192,7 @@ void cw1200_scan_work(struct work_struct *work)
 		cw1200_scan_restart_delayed(priv);
 		wsm_unlock_tx(priv);
 		mutex_unlock(&priv->conf_mutex);
-		ieee80211_scan_completed(priv->hw, priv->scan.status ? 1 : 0);
+		ieee80211_scan_completed(priv->hw, &info);
 		up(&priv->scan.lock);
 		return;
 	} else {
diff --git a/drivers/net/wireless/ti/wl1251/event.c b/drivers/net/wireless/ti/wl1251/event.c
index c986303..d0593bc 100644
--- a/drivers/net/wireless/ti/wl1251/event.c
+++ b/drivers/net/wireless/ti/wl1251/event.c
@@ -36,7 +36,11 @@ static int wl1251_event_scan_complete(struct wl1251 *wl,
 		     mbox->scheduled_scan_channels);
 
 	if (wl->scanning) {
-		ieee80211_scan_completed(wl->hw, false);
+		struct cfg80211_scan_info info = {
+			.aborted = false,
+		};
+
+		ieee80211_scan_completed(wl->hw, &info);
 		wl1251_debug(DEBUG_MAC80211, "mac80211 hw scan completed");
 		wl->scanning = false;
 		if (wl->hw->conf.flags & IEEE80211_CONF_IDLE)
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 56384a4e..bbf7604 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -448,7 +448,11 @@ static void wl1251_op_stop(struct ieee80211_hw *hw)
 	WARN_ON(wl->state != WL1251_STATE_ON);
 
 	if (wl->scanning) {
-		ieee80211_scan_completed(wl->hw, true);
+		struct cfg80211_scan_info info = {
+			.aborted = true,
+		};
+
+		ieee80211_scan_completed(wl->hw, &info);
 		wl->scanning = false;
 	}
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 10fd24c..69267d5 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2615,6 +2615,10 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 
 	if (wl->scan.state != WL1271_SCAN_STATE_IDLE &&
 	    wl->scan_wlvif == wlvif) {
+		struct cfg80211_scan_info info = {
+			.aborted = true,
+		};
+
 		/*
 		 * Rearm the tx watchdog just before idling scan. This
 		 * prevents just-finished scans from triggering the watchdog
@@ -2625,7 +2629,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 		memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
 		wl->scan_wlvif = NULL;
 		wl->scan.req = NULL;
-		ieee80211_scan_completed(wl->hw, true);
+		ieee80211_scan_completed(wl->hw, &info);
 	}
 
 	if (wl->sched_vif == wlvif)
@@ -3649,6 +3653,9 @@ static void wl1271_op_cancel_hw_scan(struct ieee80211_hw *hw,
 {
 	struct wl1271 *wl = hw->priv;
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct cfg80211_scan_info info = {
+		.aborted = true,
+	};
 	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 cancel hw scan");
@@ -3681,7 +3688,7 @@ static void wl1271_op_cancel_hw_scan(struct ieee80211_hw *hw,
 	memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
 	wl->scan_wlvif = NULL;
 	wl->scan.req = NULL;
-	ieee80211_scan_completed(wl->hw, true);
+	ieee80211_scan_completed(wl->hw, &info);
 
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index 2334364..5612f59 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -36,6 +36,9 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	struct delayed_work *dwork;
 	struct wl1271 *wl;
 	struct wl12xx_vif *wlvif;
+	struct cfg80211_scan_info info = {
+		.aborted = false,
+	};
 	int ret;
 
 	dwork = to_delayed_work(work);
@@ -82,7 +85,7 @@ void wl1271_scan_complete_work(struct work_struct *work)
 
 	wlcore_cmd_regdomain_config_locked(wl);
 
-	ieee80211_scan_completed(wl->hw, false);
+	ieee80211_scan_completed(wl->hw, &info);
 
 out:
 	mutex_unlock(&wl->mutex);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a52009f..b4faadb 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4697,9 +4697,10 @@ void ieee80211_wake_queues(struct ieee80211_hw *hw);
  * any context, including hardirq context.
  *
  * @hw: the hardware that finished the scan
- * @aborted: set to true if scan was aborted
+ * @info: information about the completed scan
  */
-void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted);
+void ieee80211_scan_completed(struct ieee80211_hw *hw,
+			      struct cfg80211_scan_info *info);
 
 /**
  * ieee80211_sched_scan_results - got results from scheduled scan
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 54edfb6..f56d342 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1250,6 +1250,7 @@ struct ieee80211_local {
 	int scan_channel_idx;
 	int scan_ies_len;
 	int hw_scan_ies_bufsize;
+	struct cfg80211_scan_info scan_info;
 
 	struct work_struct sched_scan_stopped_work;
 	struct ieee80211_sub_if_data __rcu *sched_scan_sdata;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 4ec1c52..8d4a9cd 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -7,6 +7,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2013-2015  Intel Mobile Communications GmbH
+ * Copyright 2016  Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -70,6 +71,7 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 		.boottime_ns = rx_status->boottime_ns,
 	};
 	bool signal_valid;
+	struct ieee80211_sub_if_data *scan_sdata;
 
 	if (ieee80211_hw_check(&local->hw, SIGNAL_DBM))
 		bss_meta.signal = rx_status->signal * 100;
@@ -83,6 +85,20 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 		bss_meta.scan_width = NL80211_BSS_CHAN_WIDTH_10;
 
 	bss_meta.chan = channel;
+
+	rcu_read_lock();
+	scan_sdata = rcu_dereference(local->scan_sdata);
+	if (scan_sdata && scan_sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    scan_sdata->vif.bss_conf.assoc &&
+	    ieee80211_have_rx_timestamp(rx_status)) {
+		bss_meta.parent_tsf =
+			ieee80211_calculate_rx_timestamp(local, rx_status,
+							 len + FCS_LEN, 24);
+		ether_addr_copy(bss_meta.parent_bssid,
+				scan_sdata->vif.bss_conf.bssid);
+	}
+	rcu_read_unlock();
+
 	cbss = cfg80211_inform_bss_frame_data(local->hw.wiphy, &bss_meta,
 					      mgmt, len, GFP_ATOMIC);
 	if (!cbss)
@@ -345,6 +361,11 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 
 		if (rc == 0)
 			return;
+
+		/* HW scan failed and is going to be reported as done, so clear
+		 * old scan info.
+		 */
+		memset(&local->scan_info, 0, sizeof(local->scan_info));
 	}
 
 	kfree(local->hw_scan_req);
@@ -354,11 +375,8 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 					     lockdep_is_held(&local->mtx));
 
 	if (scan_req != local->int_scan_req) {
-		struct cfg80211_scan_info info = {
-			.aborted = aborted,
-		};
-
-		cfg80211_scan_done(scan_req, &info);
+		local->scan_info.aborted = aborted;
+		cfg80211_scan_done(scan_req, &local->scan_info);
 	}
 	RCU_INIT_POINTER(local->scan_req, NULL);
 
@@ -396,15 +414,19 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 		ieee80211_start_next_roc(local);
 }
 
-void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
+void ieee80211_scan_completed(struct ieee80211_hw *hw,
+			      struct cfg80211_scan_info *info)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	trace_api_scan_completed(local, aborted);
+	trace_api_scan_completed(local, info);
 
 	set_bit(SCAN_COMPLETED, &local->scanning);
-	if (aborted)
+	if (info->aborted)
 		set_bit(SCAN_ABORTED, &local->scanning);
+
+	memcpy(&local->scan_info, info, sizeof(*info));
+
 	ieee80211_queue_delayed_work(&local->hw, &local->scan_work, 0);
 }
 EXPORT_SYMBOL(ieee80211_scan_completed);
@@ -571,6 +593,9 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		local->hw_scan_req->req.ie = ies;
 		local->hw_scan_req->req.flags = req->flags;
 		eth_broadcast_addr(local->hw_scan_req->req.bssid);
+		local->hw_scan_req->req.duration = req->duration;
+		local->hw_scan_req->req.duration_mandatory =
+			req->duration_mandatory;
 
 		local->hw_scan_band = 0;
 
@@ -1078,6 +1103,7 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
 	 */
 	cancel_delayed_work(&local->scan_work);
 	/* and clean up */
+	memset(&local->scan_info, 0, sizeof(local->scan_info));
 	__ieee80211_scan_completed(&local->hw, true);
 out:
 	mutex_unlock(&local->mtx);
-- 
2.8.1

