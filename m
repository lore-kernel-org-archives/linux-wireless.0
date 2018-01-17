Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32924 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752193AbeAQHee (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 02:34:34 -0500
From: tamizhr@codeaurora.org
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, tamizhr@qti.qualcomm.com,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 1/4] wireless: allow send peer mac in rssi cqm notify
Date: Wed, 17 Jan 2018 13:01:13 +0530
Message-Id: <1516174276-16789-2-git-send-email-tamizhr@codeaurora.org> (sfid-20180117_083449_311534_ECCC60AF)
In-Reply-To: <1516174276-16789-1-git-send-email-tamizhr@codeaurora.org>
References: <1516174276-16789-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>

Extend cqm rssi notifier apis to include peer mac address. Currently
netlink cqm msg already accepts the mac. With this change just passing
the mac address as an argument to cfg and mac80211 apis.

Co-Developed-by: Tamizh Chelvam <tamizhr@codeaurora.org>
Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c      |  4 ++--
 drivers/net/wireless/marvell/mwifiex/sta_event.c |  4 ++--
 drivers/net/wireless/rndis_wlan.c                |  3 ++-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c      |  2 +-
 drivers/net/wireless/st/cw1200/sta.c             |  4 +++-
 drivers/net/wireless/ti/wl1251/event.c           | 14 ++++++++------
 drivers/net/wireless/ti/wlcore/event.c           |  5 +++--
 include/net/cfg80211.h                           |  3 ++-
 include/net/mac80211.h                           |  3 ++-
 net/mac80211/mlme.c                              | 14 +++++++-------
 net/mac80211/trace.h                             | 11 +++++++----
 net/wireless/nl80211.c                           |  6 +++---
 net/wireless/trace.h                             | 12 ++++++++----
 13 files changed, 50 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index d26833c..a47c7d2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -600,7 +600,7 @@ static void iwl_mvm_stat_iterator(void *_data, u8 *mac,
 		IWL_DEBUG_RX(mvm, "cqm_iterator cqm low %d\n",
 			     sig);
 		ieee80211_cqm_rssi_notify(
-			vif,
+			vif, vif->bss_conf.bssid,
 			NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
 			sig,
 			GFP_KERNEL);
@@ -610,7 +610,7 @@ static void iwl_mvm_stat_iterator(void *_data, u8 *mac,
 		IWL_DEBUG_RX(mvm, "cqm_iterator cqm high %d\n",
 			     sig);
 		ieee80211_cqm_rssi_notify(
-			vif,
+			vif, vif->bss_conf.bssid,
 			NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
 			sig,
 			GFP_KERNEL);
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 93dfb76..5e4cf59 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -877,7 +877,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_RSSI_LOW:
-		cfg80211_cqm_rssi_notify(priv->netdev,
+		cfg80211_cqm_rssi_notify(priv->netdev, priv->cfg_bssid,
 					 NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
 					 0, GFP_KERNEL);
 		mwifiex_send_cmd(priv, HostCmd_CMD_RSSI_INFO,
@@ -892,7 +892,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		mwifiex_dbg(adapter, EVENT, "event: MAX_FAIL\n");
 		break;
 	case EVENT_RSSI_HIGH:
-		cfg80211_cqm_rssi_notify(priv->netdev,
+		cfg80211_cqm_rssi_notify(priv->netdev, priv->cfg_bssid,
 					 NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
 					 0, GFP_KERNEL);
 		mwifiex_send_cmd(priv, HostCmd_CMD_RSSI_INFO,
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 9935bd0..f5a5637 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -3194,7 +3194,8 @@ static void rndis_do_cqm(struct usbnet *usbdev, s32 rssi)
 		return;
 
 	priv->last_cqm_event_rssi = rssi;
-	cfg80211_cqm_rssi_notify(usbdev->net, event, rssi, GFP_KERNEL);
+	cfg80211_cqm_rssi_notify(usbdev->net, priv->bssid, event, rssi,
+				 GFP_KERNEL);
 }
 
 #define DEVICE_POLLER_JIFFIES (HZ)
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 32f5cb4..63e0f7a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1172,7 +1172,7 @@ static void rsi_perform_cqm(struct rsi_common *common,
 
 	common->cqm_info.last_cqm_event_rssi = rssi;
 	rsi_dbg(INFO_ZONE, "CQM: Notifying event: %d\n", event);
-	ieee80211_cqm_rssi_notify(vif, event, rssi, GFP_KERNEL);
+	ieee80211_cqm_rssi_notify(vif, bssid, event, rssi, GFP_KERNEL);
 
 	return;
 }
diff --git a/drivers/net/wireless/st/cw1200/sta.c b/drivers/net/wireless/st/cw1200/sta.c
index 38678e9..93efdee 100644
--- a/drivers/net/wireless/st/cw1200/sta.c
+++ b/drivers/net/wireless/st/cw1200/sta.c
@@ -1019,7 +1019,9 @@ void cw1200_event_handler(struct work_struct *work)
 				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW :
 				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH;
 			pr_debug("[CQM] RSSI event: %d.\n", rcpi_rssi);
-			ieee80211_cqm_rssi_notify(priv->vif, cqm_evt, rcpi_rssi,
+			ieee80211_cqm_rssi_notify(priv->vif,
+						  priv->vif->bss_conf.bssid,
+						  cqm_evt, rcpi_rssi,
 						  GFP_KERNEL);
 			break;
 		}
diff --git a/drivers/net/wireless/ti/wl1251/event.c b/drivers/net/wireless/ti/wl1251/event.c
index f5acd24..1f919a2 100644
--- a/drivers/net/wireless/ti/wl1251/event.c
+++ b/drivers/net/wireless/ti/wl1251/event.c
@@ -148,17 +148,19 @@ static int wl1251_event_process(struct wl1251 *wl, struct event_mailbox *mbox)
 		if (vector & ROAMING_TRIGGER_LOW_RSSI_EVENT_ID) {
 			wl1251_debug(DEBUG_EVENT,
 				     "ROAMING_TRIGGER_LOW_RSSI_EVENT");
-			ieee80211_cqm_rssi_notify(wl->vif,
-				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
-				0, GFP_KERNEL);
+			ieee80211_cqm_rssi_notify(
+					wl->vif, wl->bssid,
+					NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
+					0, GFP_KERNEL);
 		}
 
 		if (vector & ROAMING_TRIGGER_REGAINED_RSSI_EVENT_ID) {
 			wl1251_debug(DEBUG_EVENT,
 				     "ROAMING_TRIGGER_REGAINED_RSSI_EVENT");
-			ieee80211_cqm_rssi_notify(wl->vif,
-				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
-				0, GFP_KERNEL);
+			ieee80211_cqm_rssi_notify(
+					wl->vif, wl->bssid,
+					NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
+					0, GFP_KERNEL);
 		}
 	}
 
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index f2e90d2..a0df89d 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -129,8 +129,9 @@ void wlcore_event_rssi_trigger(struct wl1271 *wl, s8 *metric_arr)
 
 		vif = wl12xx_wlvif_to_vif(wlvif);
 		if (event != wlvif->last_rssi_event)
-			ieee80211_cqm_rssi_notify(vif, event, metric,
-						  GFP_KERNEL);
+			ieee80211_cqm_rssi_notify(vif,
+						  wl->roc_vif->bss_conf.bssid,
+						  event, metric, GFP_KERNEL);
 		wlvif->last_rssi_event = event;
 	}
 }
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 81174f9..da7f5d7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5626,6 +5626,7 @@ void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
 /**
  * cfg80211_cqm_rssi_notify - connection quality monitoring rssi event
  * @dev: network device
+ * @peer: peer's MAC address
  * @rssi_event: the triggered RSSI event
  * @rssi_level: new RSSI level value or 0 if not available
  * @gfp: context flags
@@ -5633,7 +5634,7 @@ void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
  * This function is called when a configured connection quality monitoring
  * rssi threshold reached event occurs.
  */
-void cfg80211_cqm_rssi_notify(struct net_device *dev,
+void cfg80211_cqm_rssi_notify(struct net_device *dev, const u8 *peer,
 			      enum nl80211_cqm_rssi_threshold_event rssi_event,
 			      s32 rssi_level, gfp_t gfp);
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 906e902..d71ac81 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5345,6 +5345,7 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
  *	rssi threshold triggered
  *
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @peer: peer's MAC address
  * @rssi_event: the RSSI trigger event type
  * @rssi_level: new RSSI level value or 0 if not available
  * @gfp: context flags
@@ -5353,7 +5354,7 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
  * monitoring is configured with an rssi threshold, the driver will inform
  * whenever the rssi level reaches the threshold.
  */
-void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
+void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif, const u8 *peer,
 			       enum nl80211_cqm_rssi_threshold_event rssi_event,
 			       s32 rssi_level,
 			       gfp_t gfp);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 39b660b..d8e76e7 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3418,14 +3418,14 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		    (last_event == 0 || sig < last_event - hyst)) {
 			ifmgd->last_cqm_event_signal = sig;
 			ieee80211_cqm_rssi_notify(
-				&sdata->vif,
+				&sdata->vif, bssid,
 				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
 				sig, GFP_KERNEL);
 		} else if (sig > thold &&
 			   (last_event == 0 || sig > last_event + hyst)) {
 			ifmgd->last_cqm_event_signal = sig;
 			ieee80211_cqm_rssi_notify(
-				&sdata->vif,
+				&sdata->vif, bssid,
 				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
 				sig, GFP_KERNEL);
 		}
@@ -3442,14 +3442,14 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		    (last_event == 0 || last_event >= low)) {
 			ifmgd->last_cqm_event_signal = sig;
 			ieee80211_cqm_rssi_notify(
-				&sdata->vif,
+				&sdata->vif, bssid,
 				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
 				sig, GFP_KERNEL);
 		} else if (sig > high &&
 			   (last_event == 0 || last_event <= high)) {
 			ifmgd->last_cqm_event_signal = sig;
 			ieee80211_cqm_rssi_notify(
-				&sdata->vif,
+				&sdata->vif, bssid,
 				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
 				sig, GFP_KERNEL);
 		}
@@ -5070,16 +5070,16 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 	sdata_unlock(sdata);
 }
 
-void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
+void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif, const u8 *peer,
 			       enum nl80211_cqm_rssi_threshold_event rssi_event,
 			       s32 rssi_level,
 			       gfp_t gfp)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 
-	trace_api_cqm_rssi_notify(sdata, rssi_event, rssi_level);
+	trace_api_cqm_rssi_notify(sdata, peer, rssi_event, rssi_level);
 
-	cfg80211_cqm_rssi_notify(sdata->dev, rssi_event, rssi_level, gfp);
+	cfg80211_cqm_rssi_notify(sdata->dev, peer, rssi_event, rssi_level, gfp);
 }
 EXPORT_SYMBOL(ieee80211_cqm_rssi_notify);
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 591ad02..7de1cbc 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1999,27 +1999,30 @@ struct trace_switch_entry {
 );
 
 TRACE_EVENT(api_cqm_rssi_notify,
-	TP_PROTO(struct ieee80211_sub_if_data *sdata,
+	TP_PROTO(struct ieee80211_sub_if_data *sdata, const u8 *peer,
 		 enum nl80211_cqm_rssi_threshold_event rssi_event,
 		 s32 rssi_level),
 
-	TP_ARGS(sdata, rssi_event, rssi_level),
+	TP_ARGS(sdata, peer, rssi_event, rssi_level),
 
 	TP_STRUCT__entry(
 		VIF_ENTRY
+		__array(char, peer, ETH_ALEN)
 		__field(u32, rssi_event)
 		__field(s32, rssi_level)
 	),
 
 	TP_fast_assign(
 		VIF_ASSIGN;
+		memcpy(__entry->peer, peer, ETH_ALEN);
 		__entry->rssi_event = rssi_event;
 		__entry->rssi_level = rssi_level;
 	),
 
 	TP_printk(
-		VIF_PR_FMT " event:%d rssi:%d",
-		VIF_PR_ARG, __entry->rssi_event, __entry->rssi_level
+		VIF_PR_FMT " peer :%pM event:%d rssi:%d",
+		VIF_PR_ARG, __entry->peer, __entry->rssi_event,
+		__entry->rssi_level
 	)
 );
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b48eb6d..ce5ee6f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14538,7 +14538,7 @@ static void cfg80211_send_cqm(struct sk_buff *msg, gfp_t gfp)
 				NL80211_MCGRP_MLME, gfp);
 }
 
-void cfg80211_cqm_rssi_notify(struct net_device *dev,
+void cfg80211_cqm_rssi_notify(struct net_device *dev, const u8 *peer,
 			      enum nl80211_cqm_rssi_threshold_event rssi_event,
 			      s32 rssi_level, gfp_t gfp)
 {
@@ -14546,7 +14546,7 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 
-	trace_cfg80211_cqm_rssi_notify(dev, rssi_event, rssi_level);
+	trace_cfg80211_cqm_rssi_notify(dev, peer, rssi_event, rssi_level);
 
 	if (WARN_ON(rssi_event != NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW &&
 		    rssi_event != NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH))
@@ -14561,7 +14561,7 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 			rssi_level = wdev->cqm_config->last_rssi_event_value;
 	}
 
-	msg = cfg80211_prepare_cqm(dev, NULL, gfp);
+	msg = cfg80211_prepare_cqm(dev, peer, gfp);
 	if (!msg)
 		return;
 
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index bcfedd3..052ce620 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2578,22 +2578,26 @@
 );
 
 TRACE_EVENT(cfg80211_cqm_rssi_notify,
-	TP_PROTO(struct net_device *netdev,
+	TP_PROTO(struct net_device *netdev, const u8 *peer,
 		 enum nl80211_cqm_rssi_threshold_event rssi_event,
 		 s32 rssi_level),
-	TP_ARGS(netdev, rssi_event, rssi_level),
+	TP_ARGS(netdev, peer, rssi_event, rssi_level),
 	TP_STRUCT__entry(
 		NETDEV_ENTRY
+		MAC_ENTRY(peer)
 		__field(enum nl80211_cqm_rssi_threshold_event, rssi_event)
 		__field(s32, rssi_level)
 	),
 	TP_fast_assign(
 		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
 		__entry->rssi_event = rssi_event;
 		__entry->rssi_level = rssi_level;
 	),
-	TP_printk(NETDEV_PR_FMT ", rssi event: %d, level: %d",
-		  NETDEV_PR_ARG, __entry->rssi_event, __entry->rssi_level)
+	TP_printk(NETDEV_PR_FMT ", peer: "
+		  MAC_PR_FMT ", rssi event: %d, level: %d",
+		  NETDEV_PR_ARG, MAC_PR_ARG(peer), __entry->rssi_event,
+		   __entry->rssi_level)
 );
 
 TRACE_EVENT(cfg80211_reg_can_beacon,
-- 
1.9.1
