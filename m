Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:32844 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753202AbcLLBwF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Dec 2016 20:52:05 -0500
Received: by mail-wj0-f195.google.com with SMTP id kp2so9394131wjc.0
        for <linux-wireless@vger.kernel.org>; Sun, 11 Dec 2016 17:52:04 -0800 (PST)
Received: from localhost.localdomain ([92.185.195.211])
        by smtp.gmail.com with ESMTPSA id wg8sm54668007wjb.42.2016.12.11.17.52.02
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Dec 2016 17:52:02 -0800 (PST)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/4] mac80211: Pass new RSSI level in CQM RSSI notification
Date: Mon, 12 Dec 2016 02:51:55 +0100
Message-Id: <20161212015155.21272-1-andrew.zaborowski@intel.com> (sfid-20161212_025230_276150_0947C728)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c |  2 ++
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |  2 +-
 drivers/net/wireless/st/cw1200/sta.c        |  2 +-
 drivers/net/wireless/ti/wl1251/event.c      |  4 ++--
 drivers/net/wireless/ti/wlcore/event.c      |  3 ++-
 include/net/mac80211.h                      |  2 ++
 net/mac80211/mlme.c                         |  7 ++++---
 net/mac80211/trace.h                        | 11 +++++++----
 8 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 0e60e38..e06a2e3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -571,6 +571,7 @@ static void iwl_mvm_stat_iterator(void *_data, u8 *mac,
 		ieee80211_cqm_rssi_notify(
 			vif,
 			NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
+			sig,
 			GFP_KERNEL);
 	} else if (sig > thold &&
 		   (last_event == 0 || sig > last_event + hyst)) {
@@ -580,6 +581,7 @@ static void iwl_mvm_stat_iterator(void *_data, u8 *mac,
 		ieee80211_cqm_rssi_notify(
 			vif,
 			NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
+			sig,
 			GFP_KERNEL);
 	}
 }
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index dbb2389..3e260b4 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -818,7 +818,7 @@ static void rsi_perform_cqm(struct rsi_common *common,
 
 	common->cqm_info.last_cqm_event_rssi = rssi;
 	rsi_dbg(INFO_ZONE, "CQM: Notifying event: %d\n", event);
-	ieee80211_cqm_rssi_notify(adapter->vifs[0], event, GFP_KERNEL);
+	ieee80211_cqm_rssi_notify(adapter->vifs[0], event, rssi, GFP_KERNEL);
 
 	return;
 }
diff --git a/drivers/net/wireless/st/cw1200/sta.c b/drivers/net/wireless/st/cw1200/sta.c
index daf06a4..a522248 100644
--- a/drivers/net/wireless/st/cw1200/sta.c
+++ b/drivers/net/wireless/st/cw1200/sta.c
@@ -1019,7 +1019,7 @@ void cw1200_event_handler(struct work_struct *work)
 				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW :
 				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH;
 			pr_debug("[CQM] RSSI event: %d.\n", rcpi_rssi);
-			ieee80211_cqm_rssi_notify(priv->vif, cqm_evt,
+			ieee80211_cqm_rssi_notify(priv->vif, cqm_evt, rcpi_rssi,
 						  GFP_KERNEL);
 			break;
 		}
diff --git a/drivers/net/wireless/ti/wl1251/event.c b/drivers/net/wireless/ti/wl1251/event.c
index d0593bc..f5acd24 100644
--- a/drivers/net/wireless/ti/wl1251/event.c
+++ b/drivers/net/wireless/ti/wl1251/event.c
@@ -150,7 +150,7 @@ static int wl1251_event_process(struct wl1251 *wl, struct event_mailbox *mbox)
 				     "ROAMING_TRIGGER_LOW_RSSI_EVENT");
 			ieee80211_cqm_rssi_notify(wl->vif,
 				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
-				GFP_KERNEL);
+				0, GFP_KERNEL);
 		}
 
 		if (vector & ROAMING_TRIGGER_REGAINED_RSSI_EVENT_ID) {
@@ -158,7 +158,7 @@ static int wl1251_event_process(struct wl1251 *wl, struct event_mailbox *mbox)
 				     "ROAMING_TRIGGER_REGAINED_RSSI_EVENT");
 			ieee80211_cqm_rssi_notify(wl->vif,
 				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
-				GFP_KERNEL);
+				0, GFP_KERNEL);
 		}
 	}
 
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 4b59f67..f2e90d2 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -129,7 +129,8 @@ void wlcore_event_rssi_trigger(struct wl1271 *wl, s8 *metric_arr)
 
 		vif = wl12xx_wlvif_to_vif(wlvif);
 		if (event != wlvif->last_rssi_event)
-			ieee80211_cqm_rssi_notify(vif, event, GFP_KERNEL);
+			ieee80211_cqm_rssi_notify(vif, event, metric,
+						  GFP_KERNEL);
 		wlvif->last_rssi_event = event;
 	}
 }
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a810dfc..33026e1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5244,6 +5244,7 @@ void ieee80211_resume_disconnect(struct ieee80211_vif *vif);
  *
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @rssi_event: the RSSI trigger event type
+ * @rssi_level: new RSSI level value or 0 if not available
  * @gfp: context flags
  *
  * When the %IEEE80211_VIF_SUPPORTS_CQM_RSSI is set, and a connection quality
@@ -5252,6 +5253,7 @@ void ieee80211_resume_disconnect(struct ieee80211_vif *vif);
  */
 void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 			       enum nl80211_cqm_rssi_threshold_event rssi_event,
+			       s32 rssi_level,
 			       gfp_t gfp);
 
 /**
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7486f2d..a55cdd7 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3405,14 +3405,14 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 			ieee80211_cqm_rssi_notify(
 				&sdata->vif,
 				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
-				GFP_KERNEL);
+				sig, GFP_KERNEL);
 		} else if (sig > thold &&
 			   (last_event == 0 || sig > last_event + hyst)) {
 			ifmgd->last_cqm_event_signal = sig;
 			ieee80211_cqm_rssi_notify(
 				&sdata->vif,
 				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
-				GFP_KERNEL);
+				sig, GFP_KERNEL);
 		}
 	}
 
@@ -5000,11 +5000,12 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 
 void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 			       enum nl80211_cqm_rssi_threshold_event rssi_event,
+			       s32 rssi_level,
 			       gfp_t gfp)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 
-	trace_api_cqm_rssi_notify(sdata, rssi_event);
+	trace_api_cqm_rssi_notify(sdata, rssi_event, rssi_level);
 
 	cfg80211_cqm_rssi_notify(sdata->dev, rssi_event, gfp);
 }
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 92a47af..f78d9f4 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1996,23 +1996,26 @@ TRACE_EVENT(api_connection_loss,
 
 TRACE_EVENT(api_cqm_rssi_notify,
 	TP_PROTO(struct ieee80211_sub_if_data *sdata,
-		 enum nl80211_cqm_rssi_threshold_event rssi_event),
+		 enum nl80211_cqm_rssi_threshold_event rssi_event,
+		 s32 rssi_level),
 
-	TP_ARGS(sdata, rssi_event),
+	TP_ARGS(sdata, rssi_event, rssi_level),
 
 	TP_STRUCT__entry(
 		VIF_ENTRY
 		__field(u32, rssi_event)
+		__field(s32, rssi_level)
 	),
 
 	TP_fast_assign(
 		VIF_ASSIGN;
 		__entry->rssi_event = rssi_event;
+		__entry->rssi_level = rssi_level;
 	),
 
 	TP_printk(
-		VIF_PR_FMT " event:%d",
-		VIF_PR_ARG, __entry->rssi_event
+		VIF_PR_FMT " event:%d rssi:%d",
+		VIF_PR_ARG, __entry->rssi_event, __entry->rssi_level
 	)
 );
 
-- 
2.9.3
