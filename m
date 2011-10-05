Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35975 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934241Ab1JEJ4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:56:07 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so1405752eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:56:06 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 14/29] wl12xx: move role_id into wlvif
Date: Wed,  5 Oct 2011 11:55:51 +0200
Message-Id: <1317808566-18857-15-git-send-email-eliad@wizery.com> (sfid-20111005_115611_264835_066D7316)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move role_id into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c     |  124 +++++++++++++++++++--------------
 drivers/net/wireless/wl12xx/acx.h     |   71 ++++++++++++-------
 drivers/net/wireless/wl12xx/cmd.c     |   33 +++++----
 drivers/net/wireless/wl12xx/cmd.h     |    7 +-
 drivers/net/wireless/wl12xx/debugfs.c |   10 +++-
 drivers/net/wireless/wl12xx/event.c   |   13 ++--
 drivers/net/wireless/wl12xx/init.c    |   69 ++++++++++---------
 drivers/net/wireless/wl12xx/main.c    |  118 ++++++++++++++++++-------------
 drivers/net/wireless/wl12xx/ps.c      |   14 ++--
 drivers/net/wireless/wl12xx/ps.h      |    4 +-
 drivers/net/wireless/wl12xx/scan.c    |    5 +-
 drivers/net/wireless/wl12xx/wl12xx.h  |    2 +-
 12 files changed, 270 insertions(+), 200 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 015938f..9b4eef6 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -33,7 +33,7 @@
 #include "reg.h"
 #include "ps.h"
 
-int wl1271_acx_wake_up_conditions(struct wl1271 *wl)
+int wl1271_acx_wake_up_conditions(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct acx_wake_up_condition *wake_up;
 	int ret;
@@ -46,7 +46,7 @@ int wl1271_acx_wake_up_conditions(struct wl1271 *wl)
 		goto out;
 	}
 
-	wake_up->role_id = wl->role_id;
+	wake_up->role_id = wlvif->role_id;
 	wake_up->wake_up_event = wl->conf.conn.wake_up_event;
 	wake_up->listen_interval = wl->conf.conn.listen_interval;
 
@@ -84,7 +84,8 @@ out:
 	return ret;
 }
 
-int wl1271_acx_tx_power(struct wl1271 *wl, int power)
+int wl1271_acx_tx_power(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			int power)
 {
 	struct acx_current_tx_power *acx;
 	int ret;
@@ -100,7 +101,7 @@ int wl1271_acx_tx_power(struct wl1271 *wl, int power)
 		goto out;
 	}
 
-	acx->role_id = wl->role_id;
+	acx->role_id = wlvif->role_id;
 	acx->current_tx_power = power * 10;
 
 	ret = wl1271_cmd_configure(wl, DOT11_CUR_TX_PWR, acx, sizeof(*acx));
@@ -114,7 +115,7 @@ out:
 	return ret;
 }
 
-int wl1271_acx_feature_cfg(struct wl1271 *wl)
+int wl1271_acx_feature_cfg(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct acx_feature_config *feature;
 	int ret;
@@ -128,7 +129,7 @@ int wl1271_acx_feature_cfg(struct wl1271 *wl)
 	}
 
 	/* DF_ENCRYPTION_DISABLE and DF_SNIFF_MODE_ENABLE are disabled */
-	feature->role_id = wl->role_id;
+	feature->role_id = wlvif->role_id;
 	feature->data_flow_options = 0;
 	feature->options = 0;
 
@@ -210,7 +211,8 @@ out:
 	return ret;
 }
 
-int wl1271_acx_slot(struct wl1271 *wl, enum acx_slot_type slot_time)
+int wl1271_acx_slot(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		    enum acx_slot_type slot_time)
 {
 	struct acx_slot *slot;
 	int ret;
@@ -223,7 +225,7 @@ int wl1271_acx_slot(struct wl1271 *wl, enum acx_slot_type slot_time)
 		goto out;
 	}
 
-	slot->role_id = wl->role_id;
+	slot->role_id = wlvif->role_id;
 	slot->wone_index = STATION_WONE_INDEX;
 	slot->slot_time = slot_time;
 
@@ -238,8 +240,8 @@ out:
 	return ret;
 }
 
-int wl1271_acx_group_address_tbl(struct wl1271 *wl, bool enable,
-				 void *mc_list, u32 mc_list_len)
+int wl1271_acx_group_address_tbl(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				 bool enable, void *mc_list, u32 mc_list_len)
 {
 	struct acx_dot11_grp_addr_tbl *acx;
 	int ret;
@@ -253,7 +255,7 @@ int wl1271_acx_group_address_tbl(struct wl1271 *wl, bool enable,
 	}
 
 	/* MAC filtering */
-	acx->role_id = wl->role_id;
+	acx->role_id = wlvif->role_id;
 	acx->enabled = enable;
 	acx->num_groups = mc_list_len;
 	memcpy(acx->mac_table, mc_list, mc_list_len * ETH_ALEN);
@@ -270,7 +272,8 @@ out:
 	return ret;
 }
 
-int wl1271_acx_service_period_timeout(struct wl1271 *wl)
+int wl1271_acx_service_period_timeout(struct wl1271 *wl,
+				      struct wl12xx_vif *wlvif)
 {
 	struct acx_rx_timeout *rx_timeout;
 	int ret;
@@ -283,7 +286,7 @@ int wl1271_acx_service_period_timeout(struct wl1271 *wl)
 
 	wl1271_debug(DEBUG_ACX, "acx service period timeout");
 
-	rx_timeout->role_id = wl->role_id;
+	rx_timeout->role_id = wlvif->role_id;
 	rx_timeout->ps_poll_timeout = cpu_to_le16(wl->conf.rx.ps_poll_timeout);
 	rx_timeout->upsd_timeout = cpu_to_le16(wl->conf.rx.upsd_timeout);
 
@@ -300,7 +303,8 @@ out:
 	return ret;
 }
 
-int wl1271_acx_rts_threshold(struct wl1271 *wl, u32 rts_threshold)
+int wl1271_acx_rts_threshold(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			     u32 rts_threshold)
 {
 	struct acx_rts_threshold *rts;
 	int ret;
@@ -320,7 +324,7 @@ int wl1271_acx_rts_threshold(struct wl1271 *wl, u32 rts_threshold)
 		goto out;
 	}
 
-	rts->role_id = wl->role_id;
+	rts->role_id = wlvif->role_id;
 	rts->threshold = cpu_to_le16((u16)rts_threshold);
 
 	ret = wl1271_cmd_configure(wl, DOT11_RTS_THRESHOLD, rts, sizeof(*rts));
@@ -363,7 +367,8 @@ out:
 	return ret;
 }
 
-int wl1271_acx_beacon_filter_opt(struct wl1271 *wl, bool enable_filter)
+int wl1271_acx_beacon_filter_opt(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				 bool enable_filter)
 {
 	struct acx_beacon_filter_option *beacon_filter = NULL;
 	int ret = 0;
@@ -380,7 +385,7 @@ int wl1271_acx_beacon_filter_opt(struct wl1271 *wl, bool enable_filter)
 		goto out;
 	}
 
-	beacon_filter->role_id = wl->role_id;
+	beacon_filter->role_id = wlvif->role_id;
 	beacon_filter->enable = enable_filter;
 
 	/*
@@ -401,7 +406,8 @@ out:
 	return ret;
 }
 
-int wl1271_acx_beacon_filter_table(struct wl1271 *wl)
+int wl1271_acx_beacon_filter_table(struct wl1271 *wl,
+				   struct wl12xx_vif *wlvif)
 {
 	struct acx_beacon_filter_ie_table *ie_table;
 	int i, idx = 0;
@@ -417,7 +423,7 @@ int wl1271_acx_beacon_filter_table(struct wl1271 *wl)
 	}
 
 	/* configure default beacon pass-through rules */
-	ie_table->role_id = wl->role_id;
+	ie_table->role_id = wlvif->role_id;
 	ie_table->num_ie = 0;
 	for (i = 0; i < wl->conf.conn.bcn_filt_ie_count; i++) {
 		struct conf_bcn_filt_rule *r = &(wl->conf.conn.bcn_filt_ie[i]);
@@ -458,7 +464,8 @@ out:
 
 #define ACX_CONN_MONIT_DISABLE_VALUE  0xffffffff
 
-int wl1271_acx_conn_monit_params(struct wl1271 *wl, bool enable)
+int wl1271_acx_conn_monit_params(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				 bool enable)
 {
 	struct acx_conn_monit_params *acx;
 	u32 threshold = ACX_CONN_MONIT_DISABLE_VALUE;
@@ -479,7 +486,7 @@ int wl1271_acx_conn_monit_params(struct wl1271 *wl, bool enable)
 		timeout = wl->conf.conn.bss_lose_timeout;
 	}
 
-	acx->role_id = wl->role_id;
+	acx->role_id = wlvif->role_id;
 	acx->synch_fail_thold = cpu_to_le32(threshold);
 	acx->bss_lose_timeout = cpu_to_le32(timeout);
 
@@ -582,7 +589,7 @@ out:
 	return ret;
 }
 
-int wl1271_acx_bcn_dtim_options(struct wl1271 *wl)
+int wl1271_acx_bcn_dtim_options(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct acx_beacon_broadcast *bb;
 	int ret;
@@ -595,7 +602,7 @@ int wl1271_acx_bcn_dtim_options(struct wl1271 *wl)
 		goto out;
 	}
 
-	bb->role_id = wl->role_id;
+	bb->role_id = wlvif->role_id;
 	bb->beacon_rx_timeout = cpu_to_le16(wl->conf.conn.beacon_rx_timeout);
 	bb->broadcast_timeout = cpu_to_le16(wl->conf.conn.broadcast_timeout);
 	bb->rx_broadcast_in_ps = wl->conf.conn.rx_broadcast_in_ps;
@@ -612,7 +619,7 @@ out:
 	return ret;
 }
 
-int wl1271_acx_aid(struct wl1271 *wl, u16 aid)
+int wl1271_acx_aid(struct wl1271 *wl, struct wl12xx_vif *wlvif, u16 aid)
 {
 	struct acx_aid *acx_aid;
 	int ret;
@@ -625,7 +632,7 @@ int wl1271_acx_aid(struct wl1271 *wl, u16 aid)
 		goto out;
 	}
 
-	acx_aid->role_id = wl->role_id;
+	acx_aid->role_id = wlvif->role_id;
 	acx_aid->aid = cpu_to_le16(aid);
 
 	ret = wl1271_cmd_configure(wl, ACX_AID, acx_aid, sizeof(*acx_aid));
@@ -668,7 +675,8 @@ out:
 	return ret;
 }
 
-int wl1271_acx_set_preamble(struct wl1271 *wl, enum acx_preamble_type preamble)
+int wl1271_acx_set_preamble(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			    enum acx_preamble_type preamble)
 {
 	struct acx_preamble *acx;
 	int ret;
@@ -681,7 +689,7 @@ int wl1271_acx_set_preamble(struct wl1271 *wl, enum acx_preamble_type preamble)
 		goto out;
 	}
 
-	acx->role_id = wl->role_id;
+	acx->role_id = wlvif->role_id;
 	acx->preamble = preamble;
 
 	ret = wl1271_cmd_configure(wl, ACX_PREAMBLE_TYPE, acx, sizeof(*acx));
@@ -695,7 +703,7 @@ out:
 	return ret;
 }
 
-int wl1271_acx_cts_protect(struct wl1271 *wl,
+int wl1271_acx_cts_protect(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			   enum acx_ctsprotect_type ctsprotect)
 {
 	struct acx_ctsprotect *acx;
@@ -709,7 +717,7 @@ int wl1271_acx_cts_protect(struct wl1271 *wl,
 		goto out;
 	}
 
-	acx->role_id = wl->role_id;
+	acx->role_id = wlvif->role_id;
 	acx->ctsprotect = ctsprotect;
 
 	ret = wl1271_cmd_configure(wl, ACX_CTS_PROTECTION, acx, sizeof(*acx));
@@ -839,8 +847,8 @@ out:
 	return ret;
 }
 
-int wl1271_acx_ac_cfg(struct wl1271 *wl, u8 ac, u8 cw_min, u16 cw_max,
-		      u8 aifsn, u16 txop)
+int wl1271_acx_ac_cfg(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		      u8 ac, u8 cw_min, u16 cw_max, u8 aifsn, u16 txop)
 {
 	struct acx_ac_cfg *acx;
 	int ret = 0;
@@ -855,7 +863,7 @@ int wl1271_acx_ac_cfg(struct wl1271 *wl, u8 ac, u8 cw_min, u16 cw_max,
 		goto out;
 	}
 
-	acx->role_id = wl->role_id;
+	acx->role_id = wlvif->role_id;
 	acx->ac = ac;
 	acx->cw_min = cw_min;
 	acx->cw_max = cpu_to_le16(cw_max);
@@ -873,7 +881,8 @@ out:
 	return ret;
 }
 
-int wl1271_acx_tid_cfg(struct wl1271 *wl, u8 queue_id, u8 channel_type,
+int wl1271_acx_tid_cfg(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		       u8 queue_id, u8 channel_type,
 		       u8 tsid, u8 ps_scheme, u8 ack_policy,
 		       u32 apsd_conf0, u32 apsd_conf1)
 {
@@ -889,7 +898,7 @@ int wl1271_acx_tid_cfg(struct wl1271 *wl, u8 queue_id, u8 channel_type,
 		goto out;
 	}
 
-	acx->role_id = wl->role_id;
+	acx->role_id = wlvif->role_id;
 	acx->queue_id = queue_id;
 	acx->channel_type = channel_type;
 	acx->tsid = tsid;
@@ -1098,7 +1107,8 @@ out:
 	return ret;
 }
 
-int wl1271_acx_bet_enable(struct wl1271 *wl, bool enable)
+int wl1271_acx_bet_enable(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			  bool enable)
 {
 	struct wl1271_acx_bet_enable *acx = NULL;
 	int ret = 0;
@@ -1114,7 +1124,7 @@ int wl1271_acx_bet_enable(struct wl1271 *wl, bool enable)
 		goto out;
 	}
 
-	acx->role_id = wl->role_id;
+	acx->role_id = wlvif->role_id;
 	acx->enable = enable ? CONF_BET_MODE_ENABLE : CONF_BET_MODE_DISABLE;
 	acx->max_consecutive = wl->conf.conn.bet_max_consecutive;
 
@@ -1129,7 +1139,8 @@ out:
 	return ret;
 }
 
-int wl1271_acx_arp_ip_filter(struct wl1271 *wl, u8 enable, __be32 address)
+int wl1271_acx_arp_ip_filter(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			     u8 enable, __be32 address)
 {
 	struct wl1271_acx_arp_filter *acx;
 	int ret;
@@ -1142,7 +1153,7 @@ int wl1271_acx_arp_ip_filter(struct wl1271 *wl, u8 enable, __be32 address)
 		goto out;
 	}
 
-	acx->role_id = wl->role_id;
+	acx->role_id = wlvif->role_id;
 	acx->version = ACX_IPV4_VERSION;
 	acx->enable = enable;
 
@@ -1189,7 +1200,8 @@ out:
 	return ret;
 }
 
-int wl1271_acx_keep_alive_mode(struct wl1271 *wl, bool enable)
+int wl1271_acx_keep_alive_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			       bool enable)
 {
 	struct wl1271_acx_keep_alive_mode *acx = NULL;
 	int ret = 0;
@@ -1202,7 +1214,7 @@ int wl1271_acx_keep_alive_mode(struct wl1271 *wl, bool enable)
 		goto out;
 	}
 
-	acx->role_id = wl->role_id;
+	acx->role_id = wlvif->role_id;
 	acx->enabled = enable;
 
 	ret = wl1271_cmd_configure(wl, ACX_KEEP_ALIVE_MODE, acx, sizeof(*acx));
@@ -1216,7 +1228,8 @@ out:
 	return ret;
 }
 
-int wl1271_acx_keep_alive_config(struct wl1271 *wl, u8 index, u8 tpl_valid)
+int wl1271_acx_keep_alive_config(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				 u8 index, u8 tpl_valid)
 {
 	struct wl1271_acx_keep_alive_config *acx = NULL;
 	int ret = 0;
@@ -1229,7 +1242,7 @@ int wl1271_acx_keep_alive_config(struct wl1271 *wl, u8 index, u8 tpl_valid)
 		goto out;
 	}
 
-	acx->role_id = wl->role_id;
+	acx->role_id = wlvif->role_id;
 	acx->period = cpu_to_le32(wl->conf.conn.keep_alive_interval);
 	acx->index = index;
 	acx->tpl_validation = tpl_valid;
@@ -1247,8 +1260,8 @@ out:
 	return ret;
 }
 
-int wl1271_acx_rssi_snr_trigger(struct wl1271 *wl, bool enable,
-				s16 thold, u8 hyst)
+int wl1271_acx_rssi_snr_trigger(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				bool enable, s16 thold, u8 hyst)
 {
 	struct wl1271_acx_rssi_snr_trigger *acx = NULL;
 	int ret = 0;
@@ -1263,7 +1276,7 @@ int wl1271_acx_rssi_snr_trigger(struct wl1271 *wl, bool enable,
 
 	wl->last_rssi_event = -1;
 
-	acx->role_id = wl->role_id;
+	acx->role_id = wlvif->role_id;
 	acx->pacing = cpu_to_le16(wl->conf.roam_trigger.trigger_pacing);
 	acx->metric = WL1271_ACX_TRIG_METRIC_RSSI_BEACON;
 	acx->type = WL1271_ACX_TRIG_TYPE_EDGE;
@@ -1288,7 +1301,8 @@ out:
 	return ret;
 }
 
-int wl1271_acx_rssi_snr_avg_weights(struct wl1271 *wl)
+int wl1271_acx_rssi_snr_avg_weights(struct wl1271 *wl,
+				    struct wl12xx_vif *wlvif)
 {
 	struct wl1271_acx_rssi_snr_avg_weights *acx = NULL;
 	struct conf_roam_trigger_settings *c = &wl->conf.roam_trigger;
@@ -1302,7 +1316,7 @@ int wl1271_acx_rssi_snr_avg_weights(struct wl1271 *wl)
 		goto out;
 	}
 
-	acx->role_id = wl->role_id;
+	acx->role_id = wlvif->role_id;
 	acx->rssi_beacon = c->avg_weight_rssi_beacon;
 	acx->rssi_data = c->avg_weight_rssi_data;
 	acx->snr_beacon = c->avg_weight_snr_beacon;
@@ -1367,6 +1381,7 @@ out:
 }
 
 int wl1271_acx_set_ht_information(struct wl1271 *wl,
+				   struct wl12xx_vif *wlvif,
 				   u16 ht_operation_mode)
 {
 	struct wl1271_acx_ht_information *acx;
@@ -1380,7 +1395,7 @@ int wl1271_acx_set_ht_information(struct wl1271 *wl,
 		goto out;
 	}
 
-	acx->role_id = wl->role_id;
+	acx->role_id = wlvif->role_id;
 	acx->ht_protection =
 		(u8)(ht_operation_mode & IEEE80211_HT_OP_MODE_PROTECTION);
 	acx->rifs_mode = 0;
@@ -1402,7 +1417,8 @@ out:
 }
 
 /* Configure BA session initiator/receiver parameters setting in the FW. */
-int wl12xx_acx_set_ba_initiator_policy(struct wl1271 *wl)
+int wl12xx_acx_set_ba_initiator_policy(struct wl1271 *wl,
+				       struct wl12xx_vif *wlvif)
 {
 	struct wl1271_acx_ba_initiator_policy *acx;
 	int ret;
@@ -1416,7 +1432,7 @@ int wl12xx_acx_set_ba_initiator_policy(struct wl1271 *wl)
 	}
 
 	/* set for the current role */
-	acx->role_id = wl->role_id;
+	acx->role_id = wlvif->role_id;
 	acx->tid_bitmap = wl->conf.ht.tx_ba_tid_bitmap;
 	acx->win_size = wl->conf.ht.tx_ba_win_size;
 	acx->inactivity_timeout = wl->conf.ht.inactivity_timeout;
@@ -1496,6 +1512,8 @@ out:
 
 int wl1271_acx_ps_rx_streaming(struct wl1271 *wl, bool enable)
 {
+	struct ieee80211_vif *vif = wl->vif; /* TODO: get as param */
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct wl1271_acx_ps_rx_streaming *rx_streaming;
 	u32 conf_queues, enable_queues;
 	int i, ret = 0;
@@ -1523,7 +1541,7 @@ int wl1271_acx_ps_rx_streaming(struct wl1271 *wl, bool enable)
 		if (!(conf_queues & BIT(i)))
 			continue;
 
-		rx_streaming->role_id = wl->role_id;
+		rx_streaming->role_id = wlvif->role_id;
 		rx_streaming->tid = i;
 		rx_streaming->enable = enable_queues & BIT(i);
 		rx_streaming->period = wl->conf.rx_streaming.interval;
@@ -1542,7 +1560,7 @@ out:
 	return ret;
 }
 
-int wl1271_acx_ap_max_tx_retry(struct wl1271 *wl)
+int wl1271_acx_ap_max_tx_retry(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct wl1271_acx_ap_max_tx_retry *acx = NULL;
 	int ret;
@@ -1553,7 +1571,7 @@ int wl1271_acx_ap_max_tx_retry(struct wl1271 *wl)
 	if (!acx)
 		return -ENOMEM;
 
-	acx->role_id = wl->role_id;
+	acx->role_id = wlvif->role_id;
 	acx->max_tx_retry = cpu_to_le16(wl->conf.tx.max_tx_retries);
 
 	ret = wl1271_cmd_configure(wl, ACX_MAX_TX_FAILURE, acx, sizeof(*acx));
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 2678e1d..7fccfcc 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1234,39 +1234,49 @@ enum {
 };
 
 
-int wl1271_acx_wake_up_conditions(struct wl1271 *wl);
+int wl1271_acx_wake_up_conditions(struct wl1271 *wl,
+				  struct wl12xx_vif *wlvif);
 int wl1271_acx_sleep_auth(struct wl1271 *wl, u8 sleep_auth);
-int wl1271_acx_tx_power(struct wl1271 *wl, int power);
-int wl1271_acx_feature_cfg(struct wl1271 *wl);
+int wl1271_acx_tx_power(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			int power);
+int wl1271_acx_feature_cfg(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl1271_acx_mem_map(struct wl1271 *wl,
 		       struct acx_header *mem_map, size_t len);
 int wl1271_acx_rx_msdu_life_time(struct wl1271 *wl);
 int wl1271_acx_pd_threshold(struct wl1271 *wl);
-int wl1271_acx_slot(struct wl1271 *wl, enum acx_slot_type slot_time);
-int wl1271_acx_group_address_tbl(struct wl1271 *wl, bool enable,
-				 void *mc_list, u32 mc_list_len);
-int wl1271_acx_service_period_timeout(struct wl1271 *wl);
-int wl1271_acx_rts_threshold(struct wl1271 *wl, u32 rts_threshold);
+int wl1271_acx_slot(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		    enum acx_slot_type slot_time);
+int wl1271_acx_group_address_tbl(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				 bool enable, void *mc_list, u32 mc_list_len);
+int wl1271_acx_service_period_timeout(struct wl1271 *wl,
+				      struct wl12xx_vif *wlvif);
+int wl1271_acx_rts_threshold(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			     u32 rts_threshold);
 int wl1271_acx_dco_itrim_params(struct wl1271 *wl);
-int wl1271_acx_beacon_filter_opt(struct wl1271 *wl, bool enable_filter);
-int wl1271_acx_beacon_filter_table(struct wl1271 *wl);
-int wl1271_acx_conn_monit_params(struct wl1271 *wl, bool enable);
+int wl1271_acx_beacon_filter_opt(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				 bool enable_filter);
+int wl1271_acx_beacon_filter_table(struct wl1271 *wl,
+				   struct wl12xx_vif *wlvif);
+int wl1271_acx_conn_monit_params(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				 bool enable);
 int wl1271_acx_sg_enable(struct wl1271 *wl, bool enable);
 int wl12xx_acx_sg_cfg(struct wl1271 *wl);
 int wl1271_acx_cca_threshold(struct wl1271 *wl);
-int wl1271_acx_bcn_dtim_options(struct wl1271 *wl);
-int wl1271_acx_aid(struct wl1271 *wl, u16 aid);
+int wl1271_acx_bcn_dtim_options(struct wl1271 *wl, struct wl12xx_vif *wlvif);
+int wl1271_acx_aid(struct wl1271 *wl, struct wl12xx_vif *wlvif, u16 aid);
 int wl1271_acx_event_mbox_mask(struct wl1271 *wl, u32 event_mask);
-int wl1271_acx_set_preamble(struct wl1271 *wl, enum acx_preamble_type preamble);
-int wl1271_acx_cts_protect(struct wl1271 *wl,
+int wl1271_acx_set_preamble(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			    enum acx_preamble_type preamble);
+int wl1271_acx_cts_protect(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			   enum acx_ctsprotect_type ctsprotect);
 int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats);
 int wl1271_acx_sta_rate_policies(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl1271_acx_ap_rate_policy(struct wl1271 *wl, struct conf_tx_rate_class *c,
 		      u8 idx);
-int wl1271_acx_ac_cfg(struct wl1271 *wl, u8 ac, u8 cw_min, u16 cw_max,
-		      u8 aifsn, u16 txop);
-int wl1271_acx_tid_cfg(struct wl1271 *wl, u8 queue_id, u8 channel_type,
+int wl1271_acx_ac_cfg(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		      u8 ac, u8 cw_min, u16 cw_max, u8 aifsn, u16 txop);
+int wl1271_acx_tid_cfg(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		       u8 queue_id, u8 channel_type,
 		       u8 tsid, u8 ps_scheme, u8 ack_policy,
 		       u32 apsd_conf0, u32 apsd_conf1);
 int wl1271_acx_frag_threshold(struct wl1271 *wl, u32 frag_threshold);
@@ -1276,25 +1286,32 @@ int wl1271_acx_init_mem_config(struct wl1271 *wl);
 int wl1271_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap);
 int wl1271_acx_init_rx_interrupt(struct wl1271 *wl);
 int wl1271_acx_smart_reflex(struct wl1271 *wl);
-int wl1271_acx_bet_enable(struct wl1271 *wl, bool enable);
-int wl1271_acx_arp_ip_filter(struct wl1271 *wl, u8 enable, __be32 address);
+int wl1271_acx_bet_enable(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			  bool enable);
+int wl1271_acx_arp_ip_filter(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			     u8 enable, __be32 address);
 int wl1271_acx_pm_config(struct wl1271 *wl);
-int wl1271_acx_keep_alive_mode(struct wl1271 *wl, bool enable);
-int wl1271_acx_keep_alive_config(struct wl1271 *wl, u8 index, u8 tpl_valid);
-int wl1271_acx_rssi_snr_trigger(struct wl1271 *wl, bool enable,
-				s16 thold, u8 hyst);
-int wl1271_acx_rssi_snr_avg_weights(struct wl1271 *wl);
+int wl1271_acx_keep_alive_mode(struct wl1271 *wl, struct wl12xx_vif *vif,
+			       bool enable);
+int wl1271_acx_keep_alive_config(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				 u8 index, u8 tpl_valid);
+int wl1271_acx_rssi_snr_trigger(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				bool enable, s16 thold, u8 hyst);
+int wl1271_acx_rssi_snr_avg_weights(struct wl1271 *wl,
+				    struct wl12xx_vif *wlvif);
 int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 				    struct ieee80211_sta_ht_cap *ht_cap,
 				    bool allow_ht_operation, u8 hlid);
 int wl1271_acx_set_ht_information(struct wl1271 *wl,
+				   struct wl12xx_vif *wlvif,
 				   u16 ht_operation_mode);
-int wl12xx_acx_set_ba_initiator_policy(struct wl1271 *wl);
+int wl12xx_acx_set_ba_initiator_policy(struct wl1271 *wl,
+				       struct wl12xx_vif *wlvif);
 int wl12xx_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index,
 				       u16 ssn, bool enable, u8 peer_hlid);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 int wl1271_acx_ps_rx_streaming(struct wl1271 *wl, bool enable);
-int wl1271_acx_ap_max_tx_retry(struct wl1271 *wl);
+int wl1271_acx_ap_max_tx_retry(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_acx_config_ps(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
 int wl1271_acx_fm_coex(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index d81c550..961d9b0 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -567,9 +567,9 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		goto out;
 	}
 
-	wl1271_debug(DEBUG_CMD, "cmd role start sta %d", wl->role_id);
+	wl1271_debug(DEBUG_CMD, "cmd role start sta %d", wlvif->role_id);
 
-	cmd->role_id = wl->role_id;
+	cmd->role_id = wlvif->role_id;
 	if (wl->band == IEEE80211_BAND_5GHZ)
 		cmd->band = WL12XX_BAND_5GHZ;
 	cmd->channel = wl->channel;
@@ -592,7 +592,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d "
 		     "basic_rate_set: 0x%x, remote_rates: 0x%x",
-		     wl->role_id, cmd->sta.hlid, cmd->sta.session,
+		     wlvif->role_id, cmd->sta.hlid, cmd->sta.session,
 		     wlvif->basic_rate_set, wlvif->rate_set);
 
 	ret = wl1271_cmd_send(wl, CMD_ROLE_START, cmd, sizeof(*cmd), 0);
@@ -615,7 +615,7 @@ out:
 }
 
 /* use this function to stop ibss as well */
-int wl12xx_cmd_role_stop_sta(struct wl1271 *wl)
+int wl12xx_cmd_role_stop_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct wl12xx_cmd_role_stop *cmd;
 	int ret;
@@ -629,9 +629,9 @@ int wl12xx_cmd_role_stop_sta(struct wl1271 *wl)
 		goto out;
 	}
 
-	wl1271_debug(DEBUG_CMD, "cmd role stop sta %d", wl->role_id);
+	wl1271_debug(DEBUG_CMD, "cmd role stop sta %d", wlvif->role_id);
 
-	cmd->role_id = wl->role_id;
+	cmd->role_id = wlvif->role_id;
 	cmd->disc_type = DISCONNECT_IMMEDIATE;
 	cmd->reason = cpu_to_le16(WLAN_REASON_UNSPECIFIED);
 
@@ -656,7 +656,7 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	struct ieee80211_bss_conf *bss_conf = &wl->vif->bss_conf;
 	int ret;
 
-	wl1271_debug(DEBUG_CMD, "cmd role start ap %d", wl->role_id);
+	wl1271_debug(DEBUG_CMD, "cmd role start ap %d", wlvif->role_id);
 
 	/* trying to use hidden SSID with an old hostapd version */
 	if (wlvif->ssid_len == 0 && !bss_conf->hidden_ssid) {
@@ -679,7 +679,7 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	if (ret < 0)
 		goto out_free_global;
 
-	cmd->role_id = wl->role_id;
+	cmd->role_id = wlvif->role_id;
 	cmd->ap.aging_period = cpu_to_le16(wl->conf.tx.ap_aging_period);
 	cmd->ap.bss_index = WL1271_AP_BSS_INDEX;
 	cmd->ap.global_hlid = wl->ap_global_hlid;
@@ -737,7 +737,7 @@ out:
 	return ret;
 }
 
-int wl12xx_cmd_role_stop_ap(struct wl1271 *wl)
+int wl12xx_cmd_role_stop_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct wl12xx_cmd_role_stop *cmd;
 	int ret;
@@ -748,9 +748,9 @@ int wl12xx_cmd_role_stop_ap(struct wl1271 *wl)
 		goto out;
 	}
 
-	wl1271_debug(DEBUG_CMD, "cmd role stop ap %d", wl->role_id);
+	wl1271_debug(DEBUG_CMD, "cmd role stop ap %d", wlvif->role_id);
 
-	cmd->role_id = wl->role_id;
+	cmd->role_id = wlvif->role_id;
 
 	ret = wl1271_cmd_send(wl, CMD_ROLE_STOP, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
@@ -781,9 +781,9 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		goto out;
 	}
 
-	wl1271_debug(DEBUG_CMD, "cmd role start ibss %d", wl->role_id);
+	wl1271_debug(DEBUG_CMD, "cmd role start ibss %d", wlvif->role_id);
 
-	cmd->role_id = wl->role_id;
+	cmd->role_id = wlvif->role_id;
 	if (wl->band == IEEE80211_BAND_5GHZ)
 		cmd->band = WL12XX_BAND_5GHZ;
 	cmd->channel = wl->channel;
@@ -806,7 +806,7 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d "
 		     "basic_rate_set: 0x%x, remote_rates: 0x%x",
-		     wl->role_id, cmd->sta.hlid, cmd->sta.session,
+		     wlvif->role_id, cmd->sta.hlid, cmd->sta.session,
 		     wlvif->basic_rate_set, wlvif->rate_set);
 
 	wl1271_debug(DEBUG_CMD, "vif->bss_conf.bssid = %pM",
@@ -966,7 +966,8 @@ out:
 	return ret;
 }
 
-int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode)
+int wl1271_cmd_ps_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		       u8 ps_mode)
 {
 	struct wl1271_cmd_ps_params *ps_params = NULL;
 	int ret = 0;
@@ -979,7 +980,7 @@ int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode)
 		goto out;
 	}
 
-	ps_params->role_id = wl->role_id;
+	ps_params->role_id = wlvif->role_id;
 	ps_params->ps_mode = ps_mode;
 
 	ret = wl1271_cmd_send(wl, CMD_SET_PS_MODE, ps_params,
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 37caf69..c17294c 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -42,15 +42,16 @@ int wl12xx_cmd_role_disable(struct wl1271 *wl, u8 *role_id);
 int wl12xx_cmd_role_start_dev(struct wl1271 *wl);
 int wl12xx_cmd_role_stop_dev(struct wl1271 *wl);
 int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif);
-int wl12xx_cmd_role_stop_sta(struct wl1271 *wl);
+int wl12xx_cmd_role_stop_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif);
-int wl12xx_cmd_role_stop_ap(struct wl1271 *wl);
+int wl12xx_cmd_role_stop_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_data_path(struct wl1271 *wl, bool enable);
-int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode);
+int wl1271_cmd_ps_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		       u8 ps_mode);
 int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
 			   size_t len);
 int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 8f88ad6..3309fea 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -620,11 +620,19 @@ static ssize_t beacon_filtering_write(struct file *file,
 				      size_t count, loff_t *ppos)
 {
 	struct wl1271 *wl = file->private_data;
+	struct ieee80211_vif *vif;
+	struct wl12xx_vif *wlvif;
 	char buf[10];
 	size_t len;
 	unsigned long value;
 	int ret;
 
+	if (!wl->vif)
+		return -EINVAL;
+
+	vif = wl->vif;
+	wlvif = wl12xx_vif_to_data(vif);
+
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
 		return -EFAULT;
@@ -642,7 +650,7 @@ static ssize_t beacon_filtering_write(struct file *file,
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_acx_beacon_filter_opt(wl, !!value);
+	ret = wl1271_acx_beacon_filter_opt(wl, wlvif, !!value);
 
 	wl1271_ps_elp_sleep(wl);
 out:
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index c519858..f59e354 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -64,8 +64,8 @@ void wl1271_pspoll_work(struct work_struct *work)
 	if (ret < 0)
 		goto out;
 
-	wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE, wlvif->basic_rate,
-			   true);
+	wl1271_ps_set_mode(wl, wlvif, STATION_POWER_SAVE_MODE,
+			   wlvif->basic_rate, true);
 
 	wl1271_ps_elp_sleep(wl);
 out:
@@ -85,7 +85,7 @@ static void wl1271_event_pspoll_delivery_fail(struct wl1271 *wl,
 
 	/* force active mode receive data from the AP */
 	if (test_bit(WL1271_FLAG_PSM, &wl->flags)) {
-		ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE,
+		ret = wl1271_ps_set_mode(wl, wlvif, STATION_ACTIVE_MODE,
 					 wlvif->basic_rate, true);
 		if (ret < 0)
 			return;
@@ -124,7 +124,8 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 
 		if (wl->psm_entry_retry < total_retries) {
 			wl->psm_entry_retry++;
-			ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE,
+			ret = wl1271_ps_set_mode(wl, wlvif,
+						 STATION_POWER_SAVE_MODE,
 						 wlvif->basic_rate, true);
 		} else {
 			wl1271_info("No ack to nullfunc from AP.");
@@ -136,7 +137,7 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 		wl->psm_entry_retry = 0;
 
 		/* enable beacon filtering */
-		ret = wl1271_acx_beacon_filter_opt(wl, true);
+		ret = wl1271_acx_beacon_filter_opt(wl, wlvif, true);
 		if (ret < 0)
 			break;
 
@@ -146,7 +147,7 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 		*/
 		if (wl->band == IEEE80211_BAND_2GHZ)
 			/* enable beacon early termination */
-			ret = wl1271_acx_bet_enable(wl, true);
+			ret = wl1271_acx_bet_enable(wl, wlvif, true);
 
 		if (wl->ps_compl) {
 			complete(wl->ps_compl);
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index d3f4183..85e3635 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -233,35 +233,37 @@ int wl1271_init_phy_config(struct wl1271 *wl)
 	return 0;
 }
 
-static int wl12xx_init_phy_vif_config(struct wl1271 *wl)
+static int wl12xx_init_phy_vif_config(struct wl1271 *wl,
+					    struct wl12xx_vif *wlvif)
 {
 	int ret;
 
-	ret = wl1271_acx_slot(wl, DEFAULT_SLOT_TIME);
+	ret = wl1271_acx_slot(wl, wlvif, DEFAULT_SLOT_TIME);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_service_period_timeout(wl);
+	ret = wl1271_acx_service_period_timeout(wl, wlvif);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_rts_threshold(wl, wl->hw->wiphy->rts_threshold);
+	ret = wl1271_acx_rts_threshold(wl, wlvif, wl->hw->wiphy->rts_threshold);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-static int wl1271_init_beacon_filter(struct wl1271 *wl)
+static int wl1271_init_beacon_filter(struct wl1271 *wl,
+				     struct wl12xx_vif *wlvif)
 {
 	int ret;
 
 	/* disable beacon filtering at this stage */
-	ret = wl1271_acx_beacon_filter_opt(wl, false);
+	ret = wl1271_acx_beacon_filter_opt(wl, wlvif, false);
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_beacon_filter_table(wl);
+	ret = wl1271_acx_beacon_filter_table(wl, wlvif);
 	if (ret < 0)
 		return ret;
 
@@ -294,11 +296,12 @@ int wl1271_init_energy_detection(struct wl1271 *wl)
 	return 0;
 }
 
-static int wl1271_init_beacon_broadcast(struct wl1271 *wl)
+static int wl1271_init_beacon_broadcast(struct wl1271 *wl,
+					struct wl12xx_vif *wlvif)
 {
 	int ret;
 
-	ret = wl1271_acx_bcn_dtim_options(wl);
+	ret = wl1271_acx_bcn_dtim_options(wl, wlvif);
 	if (ret < 0)
 		return ret;
 
@@ -352,20 +355,22 @@ static int wl1271_sta_hw_init(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	return 0;
 }
 
-static int wl1271_sta_hw_init_post_mem(struct wl1271 *wl)
+static int wl1271_sta_hw_init_post_mem(struct wl1271 *wl,
+				       struct ieee80211_vif *vif)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret, i;
 
 	/* disable all keep-alive templates */
 	for (i = 0; i < CMD_TEMPL_KLV_IDX_MAX; i++) {
-		ret = wl1271_acx_keep_alive_config(wl, i,
+		ret = wl1271_acx_keep_alive_config(wl, wlvif, i,
 						   ACX_KEEP_ALIVE_TPL_INVALID);
 		if (ret < 0)
 			return ret;
 	}
 
 	/* disable the keep-alive feature */
-	ret = wl1271_acx_keep_alive_mode(wl, false);
+	ret = wl1271_acx_keep_alive_mode(wl, wlvif, false);
 	if (ret < 0)
 		return ret;
 
@@ -410,7 +415,7 @@ int wl1271_ap_init_templates(struct wl1271 *wl, struct ieee80211_vif *vif)
 	 * when operating as AP we want to receive external beacons for
 	 * configuring ERP protection.
 	 */
-	ret = wl1271_acx_beacon_filter_opt(wl, false);
+	ret = wl1271_acx_beacon_filter_opt(wl, wlvif, false);
 	if (ret < 0)
 		return ret;
 
@@ -495,7 +500,7 @@ static int wl1271_set_ba_policies(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	wl->ba_support = true;
 
 	/* 802.11n initiator BA session setting */
-	return wl12xx_acx_set_ba_initiator_policy(wl);
+	return wl12xx_acx_set_ba_initiator_policy(wl, wlvif);
 }
 
 int wl1271_chip_specific_init(struct wl1271 *wl)
@@ -519,31 +524,31 @@ out:
 }
 
 /* vif-specifc initialization */
-int wl12xx_init_sta_role(struct wl1271 *wl, struct ieee80211_vif *vif)
+int wl12xx_init_sta_role(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int ret;
 
-	ret = wl1271_acx_group_address_tbl(wl, true, NULL, 0);
+	ret = wl1271_acx_group_address_tbl(wl, wlvif, true, NULL, 0);
 	if (ret < 0)
 		return ret;
 
 	/* Initialize connection monitoring thresholds */
-	ret = wl1271_acx_conn_monit_params(wl, false);
+	ret = wl1271_acx_conn_monit_params(wl, wlvif, false);
 	if (ret < 0)
 		return ret;
 
 	/* Beacon filtering */
-	ret = wl1271_init_beacon_filter(wl);
+	ret = wl1271_init_beacon_filter(wl, wlvif);
 	if (ret < 0)
 		return ret;
 
 	/* Beacons and broadcast settings */
-	ret = wl1271_init_beacon_broadcast(wl);
+	ret = wl1271_init_beacon_broadcast(wl, wlvif);
 	if (ret < 0)
 		return ret;
 
 	/* Configure rssi/snr averaging weights */
-	ret = wl1271_acx_rssi_snr_avg_weights(wl);
+	ret = wl1271_acx_rssi_snr_avg_weights(wl, wlvif);
 	if (ret < 0)
 		return ret;
 
@@ -551,16 +556,16 @@ int wl12xx_init_sta_role(struct wl1271 *wl, struct ieee80211_vif *vif)
 }
 
 /* vif-specific intialization */
-int wl12xx_init_ap_role(struct wl1271 *wl, struct ieee80211_vif *vif)
+int wl12xx_init_ap_role(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int ret;
 
-	ret = wl1271_acx_ap_max_tx_retry(wl);
+	ret = wl1271_acx_ap_max_tx_retry(wl, wlvif);
 	if (ret < 0)
 		return ret;
 
 	/* initialize Tx power */
-	ret = wl1271_acx_tx_power(wl, wl->power_level);
+	ret = wl1271_acx_tx_power(wl, wlvif, wl->power_level);
 	if (ret < 0)
 		return ret;
 
@@ -582,7 +587,7 @@ int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 		if (ret < 0)
 			return ret;
 
-		ret = wl12xx_init_ap_role(wl, vif);
+		ret = wl12xx_init_ap_role(wl, wlvif);
 		if (ret < 0)
 			return ret;
 	} else {
@@ -590,25 +595,25 @@ int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 		if (ret < 0)
 			return ret;
 
-		ret = wl12xx_init_sta_role(wl, vif);
+		ret = wl12xx_init_sta_role(wl, wlvif);
 		if (ret < 0)
 			return ret;
 	}
 
-	wl12xx_init_phy_vif_config(wl);
+	wl12xx_init_phy_vif_config(wl, wlvif);
 
 	/* Default TID/AC configuration */
 	BUG_ON(wl->conf.tx.tid_conf_count != wl->conf.tx.ac_conf_count);
 	for (i = 0; i < wl->conf.tx.tid_conf_count; i++) {
 		conf_ac = &wl->conf.tx.ac_conf[i];
-		ret = wl1271_acx_ac_cfg(wl, conf_ac->ac, conf_ac->cw_min,
-					conf_ac->cw_max, conf_ac->aifsn,
-					conf_ac->tx_op_limit);
+		ret = wl1271_acx_ac_cfg(wl, wlvif, conf_ac->ac,
+					conf_ac->cw_min, conf_ac->cw_max,
+					conf_ac->aifsn, conf_ac->tx_op_limit);
 		if (ret < 0)
 			return ret;
 
 		conf_tid = &wl->conf.tx.tid_conf[i];
-		ret = wl1271_acx_tid_cfg(wl,
+		ret = wl1271_acx_tid_cfg(wl, wlvif,
 					 conf_tid->queue_id,
 					 conf_tid->channel_type,
 					 conf_tid->tsid,
@@ -621,7 +626,7 @@ int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 	}
 
 	/* Configure HW encryption */
-	ret = wl1271_acx_feature_cfg(wl);
+	ret = wl1271_acx_feature_cfg(wl, wlvif);
 	if (ret < 0)
 		return ret;
 
@@ -629,7 +634,7 @@ int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 	if (is_ap)
 		ret = wl1271_ap_hw_init_post_mem(wl, vif);
 	else
-		ret = wl1271_sta_hw_init_post_mem(wl);
+		ret = wl1271_sta_hw_init_post_mem(wl, vif);
 
 	if (ret < 0)
 		return ret;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 4a35523..5c12bf4 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -402,7 +402,10 @@ static LIST_HEAD(wl_list);
 
 static int wl1271_check_operstate(struct wl1271 *wl, unsigned char operstate)
 {
+	struct ieee80211_vif *vif = wl->vif; /* TODO: get as param */
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret;
+
 	if (operstate != IF_OPER_UP)
 		return 0;
 
@@ -413,7 +416,7 @@ static int wl1271_check_operstate(struct wl1271 *wl, unsigned char operstate)
 	if (ret < 0)
 		return ret;
 
-	wl12xx_croc(wl, wl->role_id);
+	wl12xx_croc(wl, wlvif->role_id);
 
 	wl1271_info("Association completed.");
 	return 0;
@@ -695,7 +698,7 @@ static int wl1271_plt_init(struct wl1271 *wl)
 		goto out_free_memmap;
 
 	/* Initialize connection monitoring thresholds */
-	ret = wl1271_acx_conn_monit_params(wl, false);
+	ret = wl1271_acx_conn_monit_params(wl, NULL, false); /* TODO: fix */
 	if (ret < 0)
 		goto out_free_memmap;
 
@@ -727,14 +730,16 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	BUG_ON(wl->conf.tx.tid_conf_count != wl->conf.tx.ac_conf_count);
 	for (i = 0; i < wl->conf.tx.tid_conf_count; i++) {
 		conf_ac = &wl->conf.tx.ac_conf[i];
-		ret = wl1271_acx_ac_cfg(wl, conf_ac->ac, conf_ac->cw_min,
+		/* TODO: fix */
+		ret = wl1271_acx_ac_cfg(wl, NULL, conf_ac->ac, conf_ac->cw_min,
 					conf_ac->cw_max, conf_ac->aifsn,
 					conf_ac->tx_op_limit);
 		if (ret < 0)
 			goto out_free_memmap;
 
 		conf_tid = &wl->conf.tx.tid_conf[i];
-		ret = wl1271_acx_tid_cfg(wl, conf_tid->queue_id,
+		/* TODO: fix */
+		ret = wl1271_acx_tid_cfg(wl, NULL, conf_tid->queue_id,
 					 conf_tid->channel_type,
 					 conf_tid->tsid,
 					 conf_tid->ps_scheme,
@@ -1631,7 +1636,7 @@ static int wl1271_configure_suspend_sta(struct wl1271 *wl,
 		DECLARE_COMPLETION_ONSTACK(compl);
 
 		wl->ps_compl = &compl;
-		ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE,
+		ret = wl1271_ps_set_mode(wl, wlvif, STATION_POWER_SAVE_MODE,
 				   wlvif->basic_rate, true);
 		if (ret < 0)
 			goto out_sleep;
@@ -1664,7 +1669,8 @@ out:
 
 }
 
-static int wl1271_configure_suspend_ap(struct wl1271 *wl)
+static int wl1271_configure_suspend_ap(struct wl1271 *wl,
+				       struct wl12xx_vif *wlvif)
 {
 	int ret = 0;
 
@@ -1677,7 +1683,7 @@ static int wl1271_configure_suspend_ap(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_unlock;
 
-	ret = wl1271_acx_beacon_filter_opt(wl, true);
+	ret = wl1271_acx_beacon_filter_opt(wl, wlvif, true);
 
 	wl1271_ps_elp_sleep(wl);
 out_unlock:
@@ -1692,7 +1698,7 @@ static int wl1271_configure_suspend(struct wl1271 *wl,
 	if (wlvif->bss_type == BSS_TYPE_STA_BSS)
 		return wl1271_configure_suspend_sta(wl, wlvif);
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
-		return wl1271_configure_suspend_ap(wl);
+		return wl1271_configure_suspend_ap(wl, wlvif);
 	return 0;
 }
 
@@ -1714,10 +1720,10 @@ static void wl1271_configure_resume(struct wl1271 *wl,
 	if (is_sta) {
 		/* exit psm if it wasn't configured */
 		if (!test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags))
-			wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE,
+			wl1271_ps_set_mode(wl, wlvif, STATION_ACTIVE_MODE,
 					   wlvif->basic_rate, true);
 	} else if (is_ap) {
-		wl1271_acx_beacon_filter_opt(wl, false);
+		wl1271_acx_beacon_filter_opt(wl, wlvif, false);
 	}
 
 	wl1271_ps_elp_sleep(wl);
@@ -1850,6 +1856,7 @@ static u8 wl12xx_get_role_type(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 static void wl12xx_init_vif_data(struct wl12xx_vif *wlvif)
 {
 	wlvif->bss_type = MAX_BSS_TYPE;
+	wlvif->role_id = WL12XX_INVALID_ROLE_ID;
 	wlvif->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
 	wlvif->basic_rate = CONF_TX_RATE_MASK_BASIC;
 	wlvif->rate_set = CONF_TX_RATE_MASK_BASIC;
@@ -1957,7 +1964,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		}
 
 		ret = wl12xx_cmd_role_enable(wl, vif->addr,
-					     role_type, &wl->role_id);
+					     role_type, &wlvif->role_id);
 		if (ret < 0)
 			goto irq_disable;
 
@@ -2065,7 +2072,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 				goto deinit;
 		}
 
-		ret = wl12xx_cmd_role_disable(wl, &wl->role_id);
+		ret = wl12xx_cmd_role_disable(wl, &wlvif->role_id);
 		if (ret < 0)
 			goto deinit;
 
@@ -2123,7 +2130,7 @@ deinit:
 	wl->ap_fw_ps_map = 0;
 	wl->ap_ps_map = 0;
 	wl->sched_scanning = false;
-	wl->role_id = WL12XX_INVALID_ROLE_ID;
+	wlvif->role_id = WL12XX_INVALID_ROLE_ID;
 	wl->dev_role_id = WL12XX_INVALID_ROLE_ID;
 	memset(wl->roles_map, 0, sizeof(wl->roles_map));
 	memset(wl->links_map, 0, sizeof(wl->links_map));
@@ -2213,11 +2220,11 @@ static int wl1271_join(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	 * the join. The acx_aid starts the keep-alive process, and the order
 	 * of the commands below is relevant.
 	 */
-	ret = wl1271_acx_keep_alive_mode(wl, true);
+	ret = wl1271_acx_keep_alive_mode(wl, wlvif, true);
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_acx_aid(wl, wlvif->aid);
+	ret = wl1271_acx_aid(wl, wlvif, wlvif->aid);
 	if (ret < 0)
 		goto out;
 
@@ -2225,7 +2232,8 @@ static int wl1271_join(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_acx_keep_alive_config(wl, CMD_TEMPL_KLV_IDX_NULL_DATA,
+	ret = wl1271_acx_keep_alive_config(wl, wlvif,
+					   CMD_TEMPL_KLV_IDX_NULL_DATA,
 					   ACX_KEEP_ALIVE_TPL_VALID);
 	if (ret < 0)
 		goto out;
@@ -2234,12 +2242,12 @@ out:
 	return ret;
 }
 
-static int wl1271_unjoin(struct wl1271 *wl)
+static int wl1271_unjoin(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int ret;
 
 	/* to stop listening to a channel, we disconnect */
-	ret = wl12xx_cmd_role_stop_sta(wl);
+	ret = wl12xx_cmd_role_stop_sta(wl, wlvif);
 	if (ret < 0)
 		goto out;
 
@@ -2290,7 +2298,7 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		if (ret < 0)
 			goto out;
 		ret = wl1271_acx_keep_alive_config(
-			wl, CMD_TEMPL_KLV_IDX_NULL_DATA,
+			wl, wlvif, CMD_TEMPL_KLV_IDX_NULL_DATA,
 			ACX_KEEP_ALIVE_TPL_INVALID);
 		if (ret < 0)
 			goto out;
@@ -2449,7 +2457,8 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		 */
 		if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
 			wl1271_debug(DEBUG_PSM, "psm enabled");
-			ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE,
+			ret = wl1271_ps_set_mode(wl, wlvif,
+						 STATION_POWER_SAVE_MODE,
 						 wlvif->basic_rate, true);
 		}
 	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
@@ -2459,12 +2468,13 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		clear_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags);
 
 		if (test_bit(WL1271_FLAG_PSM, &wl->flags))
-			ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE,
+			ret = wl1271_ps_set_mode(wl, wlvif,
+						 STATION_ACTIVE_MODE,
 						 wlvif->basic_rate, true);
 	}
 
 	if (conf->power_level != wl->power_level) {
-		ret = wl1271_acx_tx_power(wl, conf->power_level);
+		ret = wl1271_acx_tx_power(wl, wlvif, conf->power_level);
 		if (ret < 0)
 			goto out_sleep;
 
@@ -2553,9 +2563,11 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 
 	if (wlvif->bss_type != BSS_TYPE_AP_BSS) {
 		if (*total & FIF_ALLMULTI)
-			ret = wl1271_acx_group_address_tbl(wl, false, NULL, 0);
+			ret = wl1271_acx_group_address_tbl(wl, wlvif, false,
+							   NULL, 0);
 		else if (fp)
-			ret = wl1271_acx_group_address_tbl(wl, fp->enabled,
+			ret = wl1271_acx_group_address_tbl(wl, wlvif,
+							   fp->enabled,
 							   fp->mc_list,
 							   fp->mc_list_length);
 		if (ret < 0)
@@ -3046,6 +3058,8 @@ out:
 static int wl1271_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 {
 	struct wl1271 *wl = hw->priv;
+	struct ieee80211_vif *vif = wl->vif;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret = 0;
 
 	mutex_lock(&wl->mutex);
@@ -3059,7 +3073,7 @@ static int wl1271_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_acx_rts_threshold(wl, value);
+	ret = wl1271_acx_rts_threshold(wl, wlvif, value);
 	if (ret < 0)
 		wl1271_warning("wl1271_op_set_rts_threshold failed: %d", ret);
 
@@ -3185,16 +3199,18 @@ static int wl1271_ap_set_probe_resp_tmpl(struct wl1271 *wl,
 }
 
 static int wl1271_bss_erp_info_changed(struct wl1271 *wl,
+				       struct ieee80211_vif *vif,
 				       struct ieee80211_bss_conf *bss_conf,
 				       u32 changed)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret = 0;
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
 		if (bss_conf->use_short_slot)
-			ret = wl1271_acx_slot(wl, SLOT_TIME_SHORT);
+			ret = wl1271_acx_slot(wl, wlvif, SLOT_TIME_SHORT);
 		else
-			ret = wl1271_acx_slot(wl, SLOT_TIME_LONG);
+			ret = wl1271_acx_slot(wl, wlvif, SLOT_TIME_LONG);
 		if (ret < 0) {
 			wl1271_warning("Set slot time failed %d", ret);
 			goto out;
@@ -3203,16 +3219,18 @@ static int wl1271_bss_erp_info_changed(struct wl1271 *wl,
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
 		if (bss_conf->use_short_preamble)
-			wl1271_acx_set_preamble(wl, ACX_PREAMBLE_SHORT);
+			wl1271_acx_set_preamble(wl, wlvif, ACX_PREAMBLE_SHORT);
 		else
-			wl1271_acx_set_preamble(wl, ACX_PREAMBLE_LONG);
+			wl1271_acx_set_preamble(wl, wlvif, ACX_PREAMBLE_LONG);
 	}
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
 		if (bss_conf->use_cts_prot)
-			ret = wl1271_acx_cts_protect(wl, CTSPROTECT_ENABLE);
+			ret = wl1271_acx_cts_protect(wl, wlvif,
+						     CTSPROTECT_ENABLE);
 		else
-			ret = wl1271_acx_cts_protect(wl, CTSPROTECT_DISABLE);
+			ret = wl1271_acx_cts_protect(wl, wlvif,
+						     CTSPROTECT_DISABLE);
 		if (ret < 0) {
 			wl1271_warning("Set ctsprotect failed %d", ret);
 			goto out;
@@ -3354,7 +3372,7 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 			}
 		} else {
 			if (test_bit(WL1271_FLAG_AP_STARTED, &wl->flags)) {
-				ret = wl12xx_cmd_role_stop_ap(wl);
+				ret = wl12xx_cmd_role_stop_ap(wl, wlvif);
 				if (ret < 0)
 					goto out;
 
@@ -3364,14 +3382,14 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 		}
 	}
 
-	ret = wl1271_bss_erp_info_changed(wl, bss_conf, changed);
+	ret = wl1271_bss_erp_info_changed(wl, vif, bss_conf, changed);
 	if (ret < 0)
 		goto out;
 
 	/* Handle HT information change */
 	if ((changed & BSS_CHANGED_HT) &&
 	    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
-		ret = wl1271_acx_set_ht_information(wl,
+		ret = wl1271_acx_set_ht_information(wl, wlvif,
 					bss_conf->ht_operation_mode);
 		if (ret < 0) {
 			wl1271_warning("Set ht information failed %d", ret);
@@ -3413,7 +3431,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		} else {
 			if (test_and_clear_bit(WL1271_FLAG_IBSS_JOINED,
 					       &wl->flags)) {
-				wl1271_unjoin(wl);
+				wl1271_unjoin(wl, wlvif);
 				wl12xx_cmd_role_start_dev(wl);
 				wl12xx_roc(wl, wl->dev_role_id);
 			}
@@ -3438,7 +3456,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		bool enable = false;
 		if (bss_conf->cqm_rssi_thold)
 			enable = true;
-		ret = wl1271_acx_rssi_snr_trigger(wl, enable,
+		ret = wl1271_acx_rssi_snr_trigger(wl, wlvif, enable,
 						  bss_conf->cqm_rssi_thold,
 						  bss_conf->cqm_rssi_hyst);
 		if (ret < 0)
@@ -3528,7 +3546,7 @@ sta_not_found:
 			wl1271_ssid_set(vif, wlvif->probereq, ieoffset);
 
 			/* enable the connection monitoring feature */
-			ret = wl1271_acx_conn_monit_params(wl, true);
+			ret = wl1271_acx_conn_monit_params(wl, wlvif, true);
 			if (ret < 0)
 				goto out;
 		} else {
@@ -3558,10 +3576,10 @@ sta_not_found:
 				goto out;
 
 			/* disable connection monitor features */
-			ret = wl1271_acx_conn_monit_params(wl, false);
+			ret = wl1271_acx_conn_monit_params(wl, wlvif, false);
 
 			/* Disable the keep-alive feature */
-			ret = wl1271_acx_keep_alive_mode(wl, false);
+			ret = wl1271_acx_keep_alive_mode(wl, wlvif, false);
 			if (ret < 0)
 				goto out;
 
@@ -3573,7 +3591,7 @@ sta_not_found:
 				 * no IF_OPER_UP notification.
 				 */
 				if (!was_ifup) {
-					ret = wl12xx_croc(wl, wl->role_id);
+					ret = wl12xx_croc(wl, wlvif->role_id);
 					if (ret < 0)
 						goto out;
 				}
@@ -3588,7 +3606,7 @@ sta_not_found:
 						goto out;
 				}
 
-				wl1271_unjoin(wl);
+				wl1271_unjoin(wl, wlvif);
 				if (!(conf_flags & IEEE80211_CONF_IDLE)) {
 					wl12xx_cmd_role_start_dev(wl);
 					wl12xx_roc(wl, wl->dev_role_id);
@@ -3618,7 +3636,7 @@ sta_not_found:
 		}
 	}
 
-	ret = wl1271_bss_erp_info_changed(wl, bss_conf, changed);
+	ret = wl1271_bss_erp_info_changed(wl, vif, bss_conf, changed);
 	if (ret < 0)
 		goto out;
 
@@ -3640,11 +3658,11 @@ sta_not_found:
 				goto out;
 			}
 
-			ret = wl1271_acx_arp_ip_filter(wl,
+			ret = wl1271_acx_arp_ip_filter(wl, wlvif,
 				ACX_ARP_FILTER_ARP_FILTERING,
 				addr);
 		} else
-			ret = wl1271_acx_arp_ip_filter(wl, 0, addr);
+			ret = wl1271_acx_arp_ip_filter(wl, wlvif, 0, addr);
 
 		if (ret < 0)
 			goto out;
@@ -3659,7 +3677,7 @@ sta_not_found:
 
 		/* ROC until connected (after EAPOL exchange) */
 		if (!is_ibss) {
-			ret = wl12xx_roc(wl, wl->role_id);
+			ret = wl12xx_roc(wl, wlvif->role_id);
 			if (ret < 0)
 				goto out;
 
@@ -3686,7 +3704,7 @@ sta_not_found:
 			enum wl1271_cmd_ps_mode mode;
 
 			mode = STATION_POWER_SAVE_MODE;
-			ret = wl1271_ps_set_mode(wl, mode,
+			ret = wl1271_ps_set_mode(wl, wlvif, mode,
 						 wlvif->basic_rate,
 						 true);
 			if (ret < 0)
@@ -3725,7 +3743,7 @@ sta_not_found:
 	/* Handle HT information change. Done after join. */
 	if ((changed & BSS_CHANGED_HT) &&
 	    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
-		ret = wl1271_acx_set_ht_information(wl,
+		ret = wl1271_acx_set_ht_information(wl, wlvif,
 					bss_conf->ht_operation_mode);
 		if (ret < 0) {
 			wl1271_warning("Set ht information failed %d", ret);
@@ -3775,6 +3793,7 @@ static int wl1271_op_conf_tx(struct ieee80211_hw *hw,
 			     const struct ieee80211_tx_queue_params *params)
 {
 	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	u8 ps_scheme;
 	int ret = 0;
 
@@ -3821,13 +3840,13 @@ static int wl1271_op_conf_tx(struct ieee80211_hw *hw,
 	 * the txop is confed in units of 32us by the mac80211,
 	 * we need us
 	 */
-	ret = wl1271_acx_ac_cfg(wl, wl1271_tx_get_queue(queue),
+	ret = wl1271_acx_ac_cfg(wl, wlvif, wl1271_tx_get_queue(queue),
 				params->cw_min, params->cw_max,
 				params->aifs, params->txop << 5);
 	if (ret < 0)
 		goto out_sleep;
 
-	ret = wl1271_acx_tid_cfg(wl, wl1271_tx_get_queue(queue),
+	ret = wl1271_acx_tid_cfg(wl, wlvif, wl1271_tx_get_queue(queue),
 				 CONF_CHANNEL_TYPE_EDCF,
 				 wl1271_tx_get_queue(queue),
 				 ps_scheme, CONF_ACK_POLICY_LEGACY,
@@ -4820,7 +4839,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->tx_security_seq = 0;
 	wl->tx_security_last_seq_lsb = 0;
 	wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
-	wl->role_id = WL12XX_INVALID_ROLE_ID;
 	wl->system_hlid = WL12XX_SYSTEM_HLID;
 	wl->sta_hlid = WL12XX_INVALID_LINK_ID;
 	wl->dev_role_id = WL12XX_INVALID_ROLE_ID;
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index c15ebf2..ac3f207 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -143,8 +143,8 @@ out:
 	return 0;
 }
 
-int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
-		       u32 rates, bool send)
+int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		       enum wl1271_cmd_ps_mode mode, u32 rates, bool send)
 {
 	int ret;
 
@@ -152,13 +152,13 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
 	case STATION_POWER_SAVE_MODE:
 		wl1271_debug(DEBUG_PSM, "entering psm");
 
-		ret = wl1271_acx_wake_up_conditions(wl);
+		ret = wl1271_acx_wake_up_conditions(wl, wlvif);
 		if (ret < 0) {
 			wl1271_error("couldn't set wake up conditions");
 			return ret;
 		}
 
-		ret = wl1271_cmd_ps_mode(wl, STATION_POWER_SAVE_MODE);
+		ret = wl1271_cmd_ps_mode(wl, wlvif, STATION_POWER_SAVE_MODE);
 		if (ret < 0)
 			return ret;
 
@@ -170,17 +170,17 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
 
 		/* disable beacon early termination */
 		if (wl->band == IEEE80211_BAND_2GHZ) {
-			ret = wl1271_acx_bet_enable(wl, false);
+			ret = wl1271_acx_bet_enable(wl, wlvif, false);
 			if (ret < 0)
 				return ret;
 		}
 
 		/* disable beacon filtering */
-		ret = wl1271_acx_beacon_filter_opt(wl, false);
+		ret = wl1271_acx_beacon_filter_opt(wl, wlvif, false);
 		if (ret < 0)
 			return ret;
 
-		ret = wl1271_cmd_ps_mode(wl, STATION_ACTIVE_MODE);
+		ret = wl1271_cmd_ps_mode(wl, wlvif, STATION_ACTIVE_MODE);
 		if (ret < 0)
 			return ret;
 
diff --git a/drivers/net/wireless/wl12xx/ps.h b/drivers/net/wireless/wl12xx/ps.h
index 25eb9bc..6ad0a0b 100644
--- a/drivers/net/wireless/wl12xx/ps.h
+++ b/drivers/net/wireless/wl12xx/ps.h
@@ -27,8 +27,8 @@
 #include "wl12xx.h"
 #include "acx.h"
 
-int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
-		       u32 rates, bool send);
+int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		       enum wl1271_cmd_ps_mode mode, u32 rates, bool send);
 void wl1271_ps_elp_sleep(struct wl1271 *wl);
 int wl1271_ps_elp_wakeup(struct wl1271 *wl);
 void wl1271_elp_work(struct work_struct *work);
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index e3b863b..9d0dfb5 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -163,6 +163,7 @@ static int wl1271_scan_send(struct wl1271 *wl, struct ieee80211_vif *vif,
 			    enum ieee80211_band band,
 			    bool passive, u32 basic_rate)
 {
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct wl1271_cmd_scan *cmd;
 	struct wl1271_cmd_trigger_scan_to *trigger;
 	int ret;
@@ -182,11 +183,11 @@ static int wl1271_scan_send(struct wl1271 *wl, struct ieee80211_vif *vif,
 	if (passive)
 		scan_options |= WL1271_SCAN_OPT_PASSIVE;
 
-	if (WARN_ON(wl->role_id == WL12XX_INVALID_ROLE_ID)) {
+	if (WARN_ON(wlvif->role_id == WL12XX_INVALID_ROLE_ID)) {
 		ret = -EINVAL;
 		goto out;
 	}
-	cmd->params.role_id = wl->role_id;
+	cmd->params.role_id = wlvif->role_id;
 	cmd->params.scan_options = cpu_to_le16(scan_options);
 
 	cmd->params.n_ch = wl1271_get_scan_channels(wl, wl->scan.req,
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 4ca483f..46258c7 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -400,7 +400,6 @@ struct wl1271 {
 
 	u8 mac_addr[ETH_ALEN];
 	int channel;
-	u8 role_id;
 	u8 dev_role_id;
 	u8 system_hlid;
 	u8 sta_hlid;
@@ -620,6 +619,7 @@ struct wl1271_station {
 struct wl12xx_vif {
 	u8 bss_type;
 	u8 p2p; /* we are using p2p role */
+	u8 role_id;
 
 	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 ssid_len;
-- 
1.7.6.401.g6a319

