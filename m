Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:39355 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab1FMWfS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:35:18 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh05-2.mail.saunalahti.fi (Postfix) with SMTP id 997308C0CF
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:35:15 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh01.mail.saunalahti.fi (Postfix) with ESMTP id A8679402E
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:35:12 +0300 (EEST)
Subject: [PATCH v2 05/27] mac80211: switch mac80211.h to use mac80211 prefix
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:35:11 +0300
Message-ID: <20110613223511.10517.16399.stgit@localhost6.localdomain6> (sfid-20110614_003523_952389_5FFD03C5)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's very confusing that mac80211 uses ieee80211_ prefix everywhere and then we
have the generic net/ieee80211.h and cfg80211 also using ieee80211_ prefix.

To make it easier to the developers change mac80211 use mac80211_ prefix
everywhere. As this is a huge task, introduce new file mac80211-compat.h which
makes it possible to not break the build while the transition is in progress.
Once mac80211 and all the drivers have been changed to use the new prefix
mac80211-compat.h will be removed.

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 include/net/mac80211-compat.h |  273 ++++++++
 include/net/mac80211.h        | 1430 +++++++++++++++++++++--------------------
 2 files changed, 989 insertions(+), 714 deletions(-)
 create mode 100644 include/net/mac80211-compat.h

diff --git a/include/net/mac80211-compat.h b/include/net/mac80211-compat.h
new file mode 100644
index 0000000..a314fca
--- /dev/null
+++ b/include/net/mac80211-compat.h
@@ -0,0 +1,273 @@
+/*
+ * mac80211 <-> driver interface
+ *
+ * Copyright 2002-2005, Devicescape Software, Inc.
+ * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
+ * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2011	Kalle Valo <kvalo@adurom.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef MAC80211_COMPAT_H
+#define MAC80211_COMPAT_H
+
+#define ieee80211_max_queues mac80211_max_queues
+#define IEEE80211_MAX_QUEUES MAC80211_MAX_QUEUES
+
+#define ieee80211_ac_numbers mac80211_ac_numbers
+#define IEEE80211_AC_VO MAC80211_AC_VO
+#define IEEE80211_AC_VI MAC80211_AC_VI
+#define IEEE80211_AC_BE MAC80211_AC_BE
+#define IEEE80211_AC_BK MAC80211_AC_BK
+
+#define ieee80211_tx_queue_params mac80211_tx_queue_params
+
+#define ieee80211_low_level_stats mac80211_low_level_stats
+
+#define ieee80211_bss_change mac80211_bss_change
+
+#define IEEE80211_BSS_ARP_ADDR_LIST_LEN MAC80211_BSS_ARP_ADDR_LIST_LEN
+
+#define ieee80211_bss_conf mac80211_bss_conf
+
+#define IEEE80211_TX_CTL_REQ_TX_STATUS MAC80211_TX_CTL_REQ_TX_STATUS
+#define IEEE80211_TX_CTL_ASSIGN_SEQ MAC80211_TX_CTL_ASSIGN_SEQ
+#define IEEE80211_TX_CTL_NO_ACK MAC80211_TX_CTL_NO_ACK
+#define IEEE80211_TX_CTL_CLEAR_PS_FILT MAC80211_TX_CTL_CLEAR_PS_FILT
+#define IEEE80211_TX_CTL_FIRST_FRAGMENT MAC80211_TX_CTL_FIRST_FRAGMENT
+#define IEEE80211_TX_CTL_SEND_AFTER_DTIM MAC80211_TX_CTL_SEND_AFTER_DTIM
+#define IEEE80211_TX_CTL_AMPDU MAC80211_TX_CTL_AMPDU
+#define IEEE80211_TX_CTL_INJECTED MAC80211_TX_CTL_INJECTED
+#define IEEE80211_TX_STAT_TX_FILTERED MAC80211_TX_STAT_TX_FILTERED
+#define IEEE80211_TX_STAT_ACK MAC80211_TX_STAT_ACK
+#define IEEE80211_TX_STAT_AMPDU MAC80211_TX_STAT_AMPDU
+#define IEEE80211_TX_STAT_AMPDU_NO_BACK MAC80211_TX_STAT_AMPDU_NO_BACK
+#define IEEE80211_TX_CTL_RATE_CTRL_PROBE MAC80211_TX_CTL_RATE_CTRL_PROBE
+#define IEEE80211_TX_INTFL_NEED_TXPROCESSING MAC80211_TX_INTFL_NEED_TXPROCESSING
+#define IEEE80211_TX_INTFL_RETRIED MAC80211_TX_INTFL_RETRIED
+#define IEEE80211_TX_INTFL_DONT_ENCRYPT MAC80211_TX_INTFL_DONT_ENCRYPT
+#define IEEE80211_TX_CTL_PSPOLL_RESPONSE MAC80211_TX_CTL_PSPOLL_RESPONSE
+#define IEEE80211_TX_CTL_MORE_FRAMES MAC80211_TX_CTL_MORE_FRAMES
+#define IEEE80211_TX_INTFL_RETRANSMISSION MAC80211_TX_INTFL_RETRANSMISSION
+#define IEEE80211_TX_INTFL_HAS_RADIOTAP MAC80211_TX_INTFL_HAS_RADIOTAP
+#define IEEE80211_TX_INTFL_NL80211_FRAME_TX MAC80211_TX_INTFL_NL80211_FRAME_TX
+#define IEEE80211_TX_CTL_LDPC MAC80211_TX_CTL_LDPC
+#define IEEE80211_TX_CTL_STBC MAC80211_TX_CTL_STBC
+#define IEEE80211_TX_CTL_TX_OFFCHAN MAC80211_TX_CTL_TX_OFFCHAN
+#define IEEE80211_TX_INTFL_TKIP_MIC_FAILURE MAC80211_TX_INTFL_TKIP_MIC_FAILURE
+
+#define IEEE80211_TX_CTL_STBC_SHIFT MAC80211_TX_CTL_STBC_SHIFT
+
+#define IEEE80211_TX_TEMPORARY_FLAGS MAC80211_TX_TEMPORARY_FLAGS
+
+#define IEEE80211_TX_RC_USE_RTS_CTS MAC80211_TX_RC_USE_RTS_CTS
+#define IEEE80211_TX_RC_USE_CTS_PROTECT MAC80211_TX_RC_USE_CTS_PROTECT
+#define IEEE80211_TX_RC_USE_SHORT_PREAMBLE MAC80211_TX_RC_USE_SHORT_PREAMBLE
+#define IEEE80211_TX_RC_MCS MAC80211_TX_RC_MCS
+#define IEEE80211_TX_RC_GREEN_FIELD MAC80211_TX_RC_GREEN_FIELD
+#define IEEE80211_TX_RC_40_MHZ_WIDTH MAC80211_TX_RC_40_MHZ_WIDTH
+#define IEEE80211_TX_RC_DUP_DATA MAC80211_TX_RC_DUP_DATA
+#define IEEE80211_TX_RC_SHORT_GI MAC80211_TX_RC_SHORT_GI
+
+#define IEEE80211_TX_INFO_DRIVER_DATA_SIZE MAC80211_TX_INFO_DRIVER_DATA_SIZE
+#define IEEE80211_TX_INFO_RATE_DRIVER_DATA_SIZE MAC80211_TX_INFO_RATE_DRIVER_DATA_SIZE
+#define IEEE80211_TX_MAX_RATES MAC80211_TX_MAX_RATES
+
+#define ieee80211_tx_rate mac80211_tx_rate
+#define ieee80211_tx_info mac80211_tx_info
+
+#define ieee80211_tx_info mac80211_tx_info
+#define ieee80211_rx_status mac80211_rx_status
+
+#define ieee80211_sched_scan_ies mac80211_sched_scan_ies
+
+#define IEEE80211_SKB_CB MAC80211_SKB_CB
+
+#define IEEE80211_SKB_RXCB MAC80211_SKB_RXCB
+
+#define ieee80211_tx_info_clear_status mac80211_tx_info_clear_status
+
+#define ieee80211_rx_status mac80211_rx_status
+
+#define ieee80211_conf_flags mac80211_conf_flags
+
+#define IEEE80211_CONF_MONITOR MAC80211_CONF_MONITOR 
+#define IEEE80211_CONF_PS MAC80211_CONF_PS
+#define IEEE80211_CONF_IDLE MAC80211_CONF_IDLE
+#define IEEE80211_CONF_OFFCHANNEL MAC80211_CONF_OFFCHANNEL
+
+#define ieee80211_conf_changed mac80211_conf_changed
+
+#define IEEE80211_CONF_CHANGE_SMPS MAC80211_CONF_CHANGE_SMPS
+#define IEEE80211_CONF_CHANGE_LISTEN_INTERVAL MAC80211_CONF_CHANGE_LISTEN_INTERVAL
+#define IEEE80211_CONF_CHANGE_MONITOR MAC80211_CONF_CHANGE_MONITOR
+#define IEEE80211_CONF_CHANGE_PS MAC80211_CONF_CHANGE_PS
+#define IEEE80211_CONF_CHANGE_POWER MAC80211_CONF_CHANGE_POWER
+#define IEEE80211_CONF_CHANGE_CHANNEL MAC80211_CONF_CHANGE_CHANNEL
+#define IEEE80211_CONF_CHANGE_RETRY_LIMITS MAC80211_CONF_CHANGE_RETRY_LIMITS
+#define IEEE80211_CONF_CHANGE_IDLE MAC80211_CONF_CHANGE_IDLE
+
+#define ieee80211_smps_mode mac80211_smps_mode
+#define IEEE80211_SMPS_AUTOMATIC MAC80211_SMPS_AUTOMATIC
+#define IEEE80211_SMPS_OFF MAC80211_SMPS_OFF
+#define IEEE80211_SMPS_STATIC MAC80211_SMPS_STATIC
+#define IEEE80211_SMPS_DYNAMIC MAC80211_SMPS_DYNAMIC
+#define IEEE80211_SMPS_NUM_MODES MAC80211_SMPS_NUM_MODES
+
+#define ieee80211_conf mac80211_conf
+#define ieee80211_channel_switch mac80211_channel_switch
+#define ieee80211_vif mac80211_vif
+#define ieee80211_vif_is_mesh mac80211_vif_is_mesh
+
+#define ieee80211_key_flags mac80211_key_flags
+#define IEEE80211_KEY_FLAG_WMM_STA MAC80211_KEY_FLAG_WMM_STA
+#define IEEE80211_KEY_FLAG_GENERATE_IV MAC80211_KEY_FLAG_GENERATE_IV
+#define IEEE80211_KEY_FLAG_GENERATE_MMIC MAC80211_KEY_FLAG_GENERATE_MMIC
+#define IEEE80211_KEY_FLAG_PAIRWISE MAC80211_KEY_FLAG_PAIRWISE
+#define IEEE80211_KEY_FLAG_SW_MGMT MAC80211_KEY_FLAG_SW_MGMT
+
+#define ieee80211_key_conf mac80211_key_conf
+#define ieee80211_sta mac80211_sta
+
+#define ieee80211_tkip_key_type mac80211_tkip_key_type
+#define IEEE80211_TKIP_P1_KEY MAC80211_TKIP_P1_KEY
+#define IEEE80211_TKIP_P2_KEY MAC80211_TKIP_P2_KEY
+
+#define ieee80211_hw_flags mac80211_hw_flags
+
+#define IEEE80211_HW_HAS_RATE_CONTROL MAC80211_HW_HAS_RATE_CONTROL
+#define IEEE80211_HW_RX_INCLUDES_FCS MAC80211_HW_RX_INCLUDES_FCS
+#define IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING MAC80211_HW_HOST_BROADCAST_PS_BUFFERING
+#define IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE MAC80211_HW_2GHZ_SHORT_SLOT_INCAPABLE
+#define IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE MAC80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE
+#define IEEE80211_HW_SIGNAL_UNSPEC MAC80211_HW_SIGNAL_UNSPEC
+#define IEEE80211_HW_SIGNAL_DBM MAC80211_HW_SIGNAL_DBM
+#define IEEE80211_HW_NEED_DTIM_PERIOD MAC80211_HW_NEED_DTIM_PERIOD
+#define IEEE80211_HW_SPECTRUM_MGMT MAC80211_HW_SPECTRUM_MGMT
+#define IEEE80211_HW_AMPDU_AGGREGATION MAC80211_HW_AMPDU_AGGREGATION
+#define IEEE80211_HW_SUPPORTS_PS MAC80211_HW_SUPPORTS_PS
+#define IEEE80211_HW_PS_NULLFUNC_STACK MAC80211_HW_PS_NULLFUNC_STACK
+#define IEEE80211_HW_SUPPORTS_DYNAMIC_PS MAC80211_HW_SUPPORTS_DYNAMIC_PS
+#define IEEE80211_HW_MFP_CAPABLE MAC80211_HW_MFP_CAPABLE
+#define IEEE80211_HW_BEACON_FILTER MAC80211_HW_BEACON_FILTER
+#define IEEE80211_HW_SUPPORTS_STATIC_SMPS MAC80211_HW_SUPPORTS_STATIC_SMPS
+#define IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS MAC80211_HW_SUPPORTS_DYNAMIC_SMPS
+#define IEEE80211_HW_SUPPORTS_UAPSD MAC80211_HW_SUPPORTS_UAPSD
+#define IEEE80211_HW_REPORTS_TX_ACK_STATUS MAC80211_HW_REPORTS_TX_ACK_STATUS
+#define IEEE80211_HW_CONNECTION_MONITOR MAC80211_HW_CONNECTION_MONITOR
+#define IEEE80211_HW_SUPPORTS_CQM_RSSI MAC80211_HW_SUPPORTS_CQM_RSSI
+#define IEEE80211_HW_SUPPORTS_PER_STA_GTK MAC80211_HW_SUPPORTS_PER_STA_GTK
+#define IEEE80211_HW_AP_LINK_PS MAC80211_HW_AP_LINK_PS
+
+#define ieee80211_hw mac80211_hw
+#define wiphy_to_ieee80211_hw wiphy_to_mac80211_hw
+#define SET_IEEE80211_DEV SET_MAC80211_DEV
+#define SET_IEEE80211_PERM_ADDR SET_MAC80211_PERM_ADDR
+
+#define ieee80211_get_tx_rate mac80211_get_tx_rate
+#define ieee80211_get_rts_cts_rate mac80211_get_rts_cts_rate
+#define ieee80211_get_alt_retry_rate mac80211_get_alt_retry_rate
+
+#define ieee80211_filter_flags mac80211_filter_flags
+
+#define ieee80211_ampdu_mlme_action mac80211_ampdu_mlme_action
+#define IEEE80211_AMPDU_RX_START MAC80211_AMPDU_RX_START
+#define IEEE80211_AMPDU_RX_STOP MAC80211_AMPDU_RX_STOP
+#define IEEE80211_AMPDU_TX_START MAC80211_AMPDU_TX_START
+#define IEEE80211_AMPDU_TX_STOP MAC80211_AMPDU_TX_STOP
+#define IEEE80211_AMPDU_TX_OPERATIONAL MAC80211_AMPDU_TX_OPERATIONAL
+
+#define ieee80211_ops mac80211_ops
+#define ieee80211_alloc_hw mac80211_alloc_hw
+#define ieee80211_register_hw mac80211_register_hw
+#define ieee80211_tpt_blink mac80211_tpt_blink
+
+#define ieee80211_tpt_led_trigger_flags mac80211_tpt_led_trigger_flags
+#define IEEE80211_TPT_LEDTRIG_FL_RADIO MAC80211_TPT_LEDTRIG_FL_RADIO
+#define IEEE80211_TPT_LEDTRIG_FL_WORK MAC80211_TPT_LEDTRIG_FL_WORK
+#define IEEE80211_TPT_LEDTRIG_FL_CONNECTED MAC80211_TPT_LEDTRIG_FL_CONNECTED
+
+#define __ieee80211_get_tx_led_name __mac80211_get_tx_led_name
+#define __ieee80211_get_rx_led_name __mac80211_get_rx_led_name
+#define __ieee80211_get_assoc_led_name __mac80211_get_assoc_led_name
+#define __ieee80211_get_radio_led_name __mac80211_get_radio_led_name
+#define __ieee80211_create_tpt_led_trigger __mac80211_create_tpt_led_trigger
+
+#define ieee80211_get_tx_led_name mac80211_get_tx_led_name
+#define ieee80211_get_rx_led_name mac80211_get_rx_led_name
+#define ieee80211_get_assoc_led_name mac80211_get_assoc_led_name
+#define ieee80211_get_radio_led_name mac80211_get_radio_led_name
+#define ieee80211_create_tpt_led_trigger mac80211_create_tpt_led_trigger
+#define ieee80211_unregister_hw mac80211_unregister_hw
+#define ieee80211_free_hw mac80211_free_hw
+#define ieee80211_restart_hw mac80211_restart_hw
+#define ieee80211_napi_schedule mac80211_napi_schedule
+#define ieee80211_napi_complete mac80211_napi_complete
+#define ieee80211_rx mac80211_rx
+#define ieee80211_rx_irqsafe mac80211_rx_irqsafe
+#define ieee80211_rx_ni mac80211_rx_ni
+#define ieee80211_sta_ps_transition mac80211_sta_ps_transition
+#define ieee80211_sta_ps_transition_ni mac80211_sta_ps_transition_ni
+#define IEEE80211_TX_STATUS_HEADROOM MAC80211_TX_STATUS_HEADROOM
+#define ieee80211_sta_set_tim mac80211_sta_set_tim
+#define ieee80211_tx_status mac80211_tx_status
+#define ieee80211_tx_status_ni mac80211_tx_status_ni
+#define ieee80211_tx_status_irqsafe mac80211_tx_status_irqsafe
+#define ieee80211_report_low_ack mac80211_report_low_ack
+#define ieee80211_beacon_get_tim mac80211_beacon_get_tim
+#define ieee80211_beacon_get mac80211_beacon_get
+#define ieee80211_pspoll_get mac80211_pspoll_get
+#define ieee80211_nullfunc_get mac80211_nullfunc_get
+#define ieee80211_probereq_get mac80211_probereq_get
+#define ieee80211_rts_get mac80211_rts_get
+#define ieee80211_rts_duration mac80211_rts_duration
+#define ieee80211_ctstoself_get mac80211_ctstoself_get
+#define ieee80211_ctstoself_duration mac80211_ctstoself_duration
+#define ieee80211_generic_frame_duration mac80211_generic_frame_duration
+#define ieee80211_get_buffered_bc mac80211_get_buffered_bc
+#define ieee80211_get_tkip_key mac80211_get_tkip_key
+#define ieee80211_wake_queue mac80211_wake_queue
+#define ieee80211_stop_queue mac80211_stop_queue
+#define ieee80211_queue_stopped mac80211_queue_stopped
+#define ieee80211_stop_queues mac80211_stop_queues
+#define ieee80211_wake_queues mac80211_wake_queues
+#define ieee80211_scan_completed mac80211_scan_completed
+#define ieee80211_sched_scan_results mac80211_sched_scan_results
+#define ieee80211_sched_scan_stopped mac80211_sched_scan_stopped
+#define ieee80211_iterate_active_interfaces mac80211_iterate_active_interfaces
+#define ieee80211_iterate_active_interfaces_atomic mac80211_iterate_active_interfaces_atomic
+#define ieee80211_queue_work mac80211_queue_work
+#define ieee80211_queue_delayed_work mac80211_queue_delayed_work
+#define ieee80211_start_tx_ba_session mac80211_start_tx_ba_session
+#define ieee80211_start_tx_ba_cb_irqsafe mac80211_start_tx_ba_cb_irqsafe
+#define ieee80211_stop_tx_ba_session mac80211_stop_tx_ba_session
+#define ieee80211_stop_tx_ba_cb_irqsafe mac80211_stop_tx_ba_cb_irqsafe
+#define ieee80211_find_sta mac80211_find_sta
+#define ieee80211_find_sta_by_ifaddr mac80211_find_sta_by_ifaddr
+#define ieee80211_sta_block_awake mac80211_sta_block_awake
+#define ieee80211_ap_probereq_get mac80211_ap_probereq_get
+#define ieee80211_beacon_loss mac80211_beacon_loss
+#define ieee80211_connection_loss mac80211_connection_loss
+#define ieee80211_disable_dyn_ps mac80211_disable_dyn_ps
+#define ieee80211_enable_dyn_ps mac80211_enable_dyn_ps
+#define ieee80211_cqm_rssi_notify mac80211_cqm_rssi_notify
+#define ieee80211_chswitch_done mac80211_chswitch_done
+#define ieee80211_request_smps mac80211_request_smps
+#define ieee80211_key_removed mac80211_key_removed
+#define ieee80211_ready_on_channel mac80211_ready_on_channel
+#define ieee80211_remain_on_channel_expired mac80211_remain_on_channel_expired
+
+#define IEEE80211_RC_HT_CHANGED MAC80211_RC_HT_CHANGED
+
+#define ieee80211_tx_rate_control mac80211_tx_rate_control
+
+#define ieee80211_rate_control_register mac80211_rate_control_register
+#define ieee80211_rate_control_unregister mac80211_rate_control_unregister
+
+#define ieee80211_iftype_p2p mac80211_iftype_p2p
+#define ieee80211_vif_type_p2p mac80211_vif_type_p2p
+
+#endif /* MAC80211_COMPAT_H */
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3b31ec9..20c6c3b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -21,6 +21,8 @@
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
 
+#include <net/mac80211-compat.h>
+
 /**
  * DOC: Introduction
  *
@@ -33,7 +35,7 @@
 /**
  * DOC: Calling mac80211 from interrupts
  *
- * Only ieee80211_tx_status_irqsafe() and ieee80211_rx_irqsafe() can be
+ * Only mac80211_tx_status_irqsafe() and mac80211_rx_irqsafe() can be
  * called in hardware interrupt context. The low-level driver must not call any
  * other functions in hardware interrupt context. If there is a need for such
  * call, the low-level driver should first ACK the interrupt and perform the
@@ -88,30 +90,30 @@
  */
 
 /**
- * enum ieee80211_max_queues - maximum number of queues
+ * enum mac80211_max_queues - maximum number of queues
  *
- * @IEEE80211_MAX_QUEUES: Maximum number of regular device queues.
+ * @MAC80211_MAX_QUEUES: Maximum number of regular device queues.
  */
-enum ieee80211_max_queues {
-	IEEE80211_MAX_QUEUES =		4,
+enum mac80211_max_queues {
+	MAC80211_MAX_QUEUES =		4,
 };
 
 /**
- * enum ieee80211_ac_numbers - AC numbers as used in mac80211
- * @IEEE80211_AC_VO: voice
- * @IEEE80211_AC_VI: video
- * @IEEE80211_AC_BE: best effort
- * @IEEE80211_AC_BK: background
+ * enum mac80211_ac_numbers - AC numbers as used in mac80211
+ * @MAC80211_AC_VO: voice
+ * @MAC80211_AC_VI: video
+ * @MAC80211_AC_BE: best effort
+ * @MAC80211_AC_BK: background
  */
-enum ieee80211_ac_numbers {
-	IEEE80211_AC_VO		= 0,
-	IEEE80211_AC_VI		= 1,
-	IEEE80211_AC_BE		= 2,
-	IEEE80211_AC_BK		= 3,
+enum mac80211_ac_numbers {
+	MAC80211_AC_VO		= 0,
+	MAC80211_AC_VI		= 1,
+	MAC80211_AC_BE		= 2,
+	MAC80211_AC_BK		= 3,
 };
 
 /**
- * struct ieee80211_tx_queue_params - transmit queue configuration
+ * struct mac80211_tx_queue_params - transmit queue configuration
  *
  * The information provided in this structure is required for QoS
  * transmit queue configuration. Cf. IEEE 802.11 7.3.2.29.
@@ -123,7 +125,7 @@ enum ieee80211_ac_numbers {
  * @txop: maximum burst time in units of 32 usecs, 0 meaning disabled
  * @uapsd: is U-APSD mode enabled for the queue
  */
-struct ieee80211_tx_queue_params {
+struct mac80211_tx_queue_params {
 	u16 txop;
 	u16 cw_min;
 	u16 cw_max;
@@ -131,7 +133,7 @@ struct ieee80211_tx_queue_params {
 	bool uapsd;
 };
 
-struct ieee80211_low_level_stats {
+struct mac80211_low_level_stats {
 	unsigned int dot11ACKFailureCount;
 	unsigned int dot11RTSFailureCount;
 	unsigned int dot11FCSErrorCount;
@@ -139,7 +141,7 @@ struct ieee80211_low_level_stats {
 };
 
 /**
- * enum ieee80211_bss_change - BSS change notification flags
+ * enum mac80211_bss_change - BSS change notification flags
  *
  * These flags are used with the bss_info_changed() callback
  * to indicate which BSS parameter changed.
@@ -165,7 +167,7 @@ struct ieee80211_low_level_stats {
  *	that it is only ever disabled for station mode.
  * @BSS_CHANGED_IDLE: Idle changed for this BSS/interface.
  */
-enum ieee80211_bss_change {
+enum mac80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
 	BSS_CHANGED_ERP_CTS_PROT	= 1<<1,
 	BSS_CHANGED_ERP_PREAMBLE	= 1<<2,
@@ -182,7 +184,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_QOS			= 1<<13,
 	BSS_CHANGED_IDLE		= 1<<14,
 
-	/* when adding here, make sure to change ieee80211_reconfig */
+	/* when adding here, make sure to change mac80211_reconfig */
 };
 
 /*
@@ -190,10 +192,10 @@ enum ieee80211_bss_change {
  * of addresses for an interface increase beyond this value, hardware ARP
  * filtering will be disabled.
  */
-#define IEEE80211_BSS_ARP_ADDR_LIST_LEN 4
+#define MAC80211_BSS_ARP_ADDR_LIST_LEN 4
 
 /**
- * struct ieee80211_bss_conf - holds the BSS's changing parameters
+ * struct mac80211_bss_conf - holds the BSS's changing parameters
  *
  * This structure keeps information about a BSS (and an association
  * to that BSS) that can change during the lifetime of the BSS.
@@ -205,13 +207,13 @@ enum ieee80211_bss_change {
  * @use_cts_prot: use CTS protection
  * @use_short_preamble: use 802.11b short preamble;
  *	if the hardware cannot handle this it must set the
- *	IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE hardware flag
+ *	MAC80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE hardware flag
  * @use_short_slot: use short slot time (only relevant for ERP);
  *	if the hardware cannot handle this it must set the
- *	IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE hardware flag
+ *	MAC80211_HW_2GHZ_SHORT_SLOT_INCAPABLE hardware flag
  * @dtim_period: num of beacons before the next DTIM, for beaconing,
  *	valid in station mode only while @assoc is true and if also
- *	requested by %IEEE80211_HW_NEED_DTIM_PERIOD (cf. also hw conf
+ *	requested by %MAC80211_HW_NEED_DTIM_PERIOD (cf. also hw conf
  *	@ps_dtim_period)
  * @timestamp: beacon timestamp
  * @beacon_int: beacon interval
@@ -225,7 +227,7 @@ enum ieee80211_bss_change {
  * @channel_type: Channel type for this BSS -- the hardware might be
  *	configured for HT40+ while this BSS only uses no-HT, for
  *	example.
- * @ht_operation_mode: HT operation mode (like in &struct ieee80211_ht_info).
+ * @ht_operation_mode: HT operation mode (like in &struct mac80211_ht_info).
  *	This field is only valid when the channel type is one of the HT types.
  * @cqm_rssi_thold: Connection quality monitor RSSI threshold, a zero value
  *	implies disabled
@@ -244,7 +246,7 @@ enum ieee80211_bss_change {
  *	hardware config which may be more appropriate depending on what
  *	your driver/device needs to do.
  */
-struct ieee80211_bss_conf {
+struct mac80211_bss_conf {
 	const u8 *bssid;
 	/* association related data */
 	bool assoc, ibss_joined;
@@ -264,7 +266,7 @@ struct ieee80211_bss_conf {
 	s32 cqm_rssi_thold;
 	u32 cqm_rssi_hyst;
 	enum nl80211_channel_type channel_type;
-	__be32 arp_addr_list[IEEE80211_BSS_ARP_ADDR_LIST_LEN];
+	__be32 arp_addr_list[MAC80211_BSS_ARP_ADDR_LIST_LEN];
 	u8 arp_addr_cnt;
 	bool arp_filter_enabled;
 	bool qos;
@@ -274,13 +276,13 @@ struct ieee80211_bss_conf {
 /**
  * enum mac80211_tx_control_flags - flags to describe transmission information/status
  *
- * These flags are used with the @flags member of &ieee80211_tx_info.
+ * These flags are used with the @flags member of &mac80211_tx_info.
  *
- * @IEEE80211_TX_CTL_REQ_TX_STATUS: require TX status callback for this frame.
- * @IEEE80211_TX_CTL_ASSIGN_SEQ: The driver has to assign a sequence
+ * @MAC80211_TX_CTL_REQ_TX_STATUS: require TX status callback for this frame.
+ * @MAC80211_TX_CTL_ASSIGN_SEQ: The driver has to assign a sequence
  *	number to this frame, taking care of not overwriting the fragment
  *	number and increasing the sequence number only when the
- *	IEEE80211_TX_CTL_FIRST_FRAGMENT flag is set. mac80211 will properly
+ *	MAC80211_TX_CTL_FIRST_FRAGMENT flag is set. mac80211 will properly
  *	assign sequence numbers to QoS-data frames but cannot do so correctly
  *	for non-QoS-data and management frames because beacons need them from
  *	that counter as well and mac80211 cannot guarantee proper sequencing.
@@ -288,154 +290,154 @@ struct ieee80211_bss_conf {
  *	assign a sequence number to the frame or assign one itself. Cf. IEEE
  *	802.11-2007 7.1.3.4.1 paragraph 3. This flag will always be set for
  *	beacons and always be clear for frames without a sequence number field.
- * @IEEE80211_TX_CTL_NO_ACK: tell the low level not to wait for an ack
- * @IEEE80211_TX_CTL_CLEAR_PS_FILT: clear powersave filter for destination
+ * @MAC80211_TX_CTL_NO_ACK: tell the low level not to wait for an ack
+ * @MAC80211_TX_CTL_CLEAR_PS_FILT: clear powersave filter for destination
  *	station
- * @IEEE80211_TX_CTL_FIRST_FRAGMENT: this is a first fragment of the frame
- * @IEEE80211_TX_CTL_SEND_AFTER_DTIM: send this frame after DTIM beacon
- * @IEEE80211_TX_CTL_AMPDU: this frame should be sent as part of an A-MPDU
- * @IEEE80211_TX_CTL_INJECTED: Frame was injected, internal to mac80211.
- * @IEEE80211_TX_STAT_TX_FILTERED: The frame was not transmitted
+ * @MAC80211_TX_CTL_FIRST_FRAGMENT: this is a first fragment of the frame
+ * @MAC80211_TX_CTL_SEND_AFTER_DTIM: send this frame after DTIM beacon
+ * @MAC80211_TX_CTL_AMPDU: this frame should be sent as part of an A-MPDU
+ * @MAC80211_TX_CTL_INJECTED: Frame was injected, internal to mac80211.
+ * @MAC80211_TX_STAT_TX_FILTERED: The frame was not transmitted
  *	because the destination STA was in powersave mode. Note that to
  *	avoid race conditions, the filter must be set by the hardware or
  *	firmware upon receiving a frame that indicates that the station
  *	went to sleep (must be done on device to filter frames already on
  *	the queue) and may only be unset after mac80211 gives the OK for
- *	that by setting the IEEE80211_TX_CTL_CLEAR_PS_FILT (see above),
+ *	that by setting the MAC80211_TX_CTL_CLEAR_PS_FILT (see above),
  *	since only then is it guaranteed that no more frames are in the
  *	hardware queue.
- * @IEEE80211_TX_STAT_ACK: Frame was acknowledged
- * @IEEE80211_TX_STAT_AMPDU: The frame was aggregated, so status
+ * @MAC80211_TX_STAT_ACK: Frame was acknowledged
+ * @MAC80211_TX_STAT_AMPDU: The frame was aggregated, so status
  * 	is for the whole aggregation.
- * @IEEE80211_TX_STAT_AMPDU_NO_BACK: no block ack was returned,
+ * @MAC80211_TX_STAT_AMPDU_NO_BACK: no block ack was returned,
  * 	so consider using block ack request (BAR).
- * @IEEE80211_TX_CTL_RATE_CTRL_PROBE: internal to mac80211, can be
+ * @MAC80211_TX_CTL_RATE_CTRL_PROBE: internal to mac80211, can be
  *	set by rate control algorithms to indicate probe rate, will
  *	be cleared for fragmented frames (except on the last fragment)
- * @IEEE80211_TX_INTFL_NEED_TXPROCESSING: completely internal to mac80211,
+ * @MAC80211_TX_INTFL_NEED_TXPROCESSING: completely internal to mac80211,
  *	used to indicate that a pending frame requires TX processing before
  *	it can be sent out.
- * @IEEE80211_TX_INTFL_RETRIED: completely internal to mac80211,
+ * @MAC80211_TX_INTFL_RETRIED: completely internal to mac80211,
  *	used to indicate that a frame was already retried due to PS
- * @IEEE80211_TX_INTFL_DONT_ENCRYPT: completely internal to mac80211,
+ * @MAC80211_TX_INTFL_DONT_ENCRYPT: completely internal to mac80211,
  *	used to indicate frame should not be encrypted
- * @IEEE80211_TX_CTL_PSPOLL_RESPONSE: (internal?)
+ * @MAC80211_TX_CTL_PSPOLL_RESPONSE: (internal?)
  *	This frame is a response to a PS-poll frame and should be sent
  *	although the station is in powersave mode.
- * @IEEE80211_TX_CTL_MORE_FRAMES: More frames will be passed to the
+ * @MAC80211_TX_CTL_MORE_FRAMES: More frames will be passed to the
  *	transmit function after the current frame, this can be used
  *	by drivers to kick the DMA queue only if unset or when the
  *	queue gets full.
- * @IEEE80211_TX_INTFL_RETRANSMISSION: This frame is being retransmitted
+ * @MAC80211_TX_INTFL_RETRANSMISSION: This frame is being retransmitted
  *	after TX status because the destination was asleep, it must not
  *	be modified again (no seqno assignment, crypto, etc.)
- * @IEEE80211_TX_INTFL_HAS_RADIOTAP: This frame was injected and still
+ * @MAC80211_TX_INTFL_HAS_RADIOTAP: This frame was injected and still
  *	has a radiotap header at skb->data.
- * @IEEE80211_TX_INTFL_NL80211_FRAME_TX: Frame was requested through nl80211
+ * @MAC80211_TX_INTFL_NL80211_FRAME_TX: Frame was requested through nl80211
  *	MLME command (internal to mac80211 to figure out whether to send TX
  *	status to user space)
- * @IEEE80211_TX_CTL_LDPC: tells the driver to use LDPC for this frame
- * @IEEE80211_TX_CTL_STBC: Enables Space-Time Block Coding (STBC) for this
+ * @MAC80211_TX_CTL_LDPC: tells the driver to use LDPC for this frame
+ * @MAC80211_TX_CTL_STBC: Enables Space-Time Block Coding (STBC) for this
  *	frame and selects the maximum number of streams that it can use.
- * @IEEE80211_TX_CTL_TX_OFFCHAN: Marks this packet to be transmitted on
+ * @MAC80211_TX_CTL_TX_OFFCHAN: Marks this packet to be transmitted on
  *	the off-channel channel when a remain-on-channel offload is done
  *	in hardware -- normal packets still flow and are expected to be
  *	handled properly by the device.
- * @IEEE80211_TX_INTFL_TKIP_MIC_FAILURE: Marks this packet to be used for TKIP
+ * @MAC80211_TX_INTFL_TKIP_MIC_FAILURE: Marks this packet to be used for TKIP
  *	testing. It will be sent out with incorrect Michael MIC key to allow
  *	TKIP countermeasures to be tested.
  *
  * Note: If you have to add new flags to the enumeration, then don't
- *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
+ *	 forget to update %MAC80211_TX_TEMPORARY_FLAGS when necessary.
  */
 enum mac80211_tx_control_flags {
-	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
-	IEEE80211_TX_CTL_ASSIGN_SEQ		= BIT(1),
-	IEEE80211_TX_CTL_NO_ACK			= BIT(2),
-	IEEE80211_TX_CTL_CLEAR_PS_FILT		= BIT(3),
-	IEEE80211_TX_CTL_FIRST_FRAGMENT		= BIT(4),
-	IEEE80211_TX_CTL_SEND_AFTER_DTIM	= BIT(5),
-	IEEE80211_TX_CTL_AMPDU			= BIT(6),
-	IEEE80211_TX_CTL_INJECTED		= BIT(7),
-	IEEE80211_TX_STAT_TX_FILTERED		= BIT(8),
-	IEEE80211_TX_STAT_ACK			= BIT(9),
-	IEEE80211_TX_STAT_AMPDU			= BIT(10),
-	IEEE80211_TX_STAT_AMPDU_NO_BACK		= BIT(11),
-	IEEE80211_TX_CTL_RATE_CTRL_PROBE	= BIT(12),
-	IEEE80211_TX_INTFL_NEED_TXPROCESSING	= BIT(14),
-	IEEE80211_TX_INTFL_RETRIED		= BIT(15),
-	IEEE80211_TX_INTFL_DONT_ENCRYPT		= BIT(16),
-	IEEE80211_TX_CTL_PSPOLL_RESPONSE	= BIT(17),
-	IEEE80211_TX_CTL_MORE_FRAMES		= BIT(18),
-	IEEE80211_TX_INTFL_RETRANSMISSION	= BIT(19),
-	IEEE80211_TX_INTFL_HAS_RADIOTAP		= BIT(20),
-	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(21),
-	IEEE80211_TX_CTL_LDPC			= BIT(22),
-	IEEE80211_TX_CTL_STBC			= BIT(23) | BIT(24),
-	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(25),
-	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(26),
+	MAC80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
+	MAC80211_TX_CTL_ASSIGN_SEQ		= BIT(1),
+	MAC80211_TX_CTL_NO_ACK			= BIT(2),
+	MAC80211_TX_CTL_CLEAR_PS_FILT		= BIT(3),
+	MAC80211_TX_CTL_FIRST_FRAGMENT		= BIT(4),
+	MAC80211_TX_CTL_SEND_AFTER_DTIM	= BIT(5),
+	MAC80211_TX_CTL_AMPDU			= BIT(6),
+	MAC80211_TX_CTL_INJECTED		= BIT(7),
+	MAC80211_TX_STAT_TX_FILTERED		= BIT(8),
+	MAC80211_TX_STAT_ACK			= BIT(9),
+	MAC80211_TX_STAT_AMPDU			= BIT(10),
+	MAC80211_TX_STAT_AMPDU_NO_BACK		= BIT(11),
+	MAC80211_TX_CTL_RATE_CTRL_PROBE	= BIT(12),
+	MAC80211_TX_INTFL_NEED_TXPROCESSING	= BIT(14),
+	MAC80211_TX_INTFL_RETRIED		= BIT(15),
+	MAC80211_TX_INTFL_DONT_ENCRYPT		= BIT(16),
+	MAC80211_TX_CTL_PSPOLL_RESPONSE	= BIT(17),
+	MAC80211_TX_CTL_MORE_FRAMES		= BIT(18),
+	MAC80211_TX_INTFL_RETRANSMISSION	= BIT(19),
+	MAC80211_TX_INTFL_HAS_RADIOTAP		= BIT(20),
+	MAC80211_TX_INTFL_NL80211_FRAME_TX	= BIT(21),
+	MAC80211_TX_CTL_LDPC			= BIT(22),
+	MAC80211_TX_CTL_STBC			= BIT(23) | BIT(24),
+	MAC80211_TX_CTL_TX_OFFCHAN		= BIT(25),
+	MAC80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(26),
 };
 
-#define IEEE80211_TX_CTL_STBC_SHIFT		23
+#define MAC80211_TX_CTL_STBC_SHIFT		23
 
 /*
  * This definition is used as a mask to clear all temporary flags, which are
  * set by the tx handlers for each transmission attempt by the mac80211 stack.
  */
-#define IEEE80211_TX_TEMPORARY_FLAGS (IEEE80211_TX_CTL_NO_ACK |		      \
-	IEEE80211_TX_CTL_CLEAR_PS_FILT | IEEE80211_TX_CTL_FIRST_FRAGMENT |    \
-	IEEE80211_TX_CTL_SEND_AFTER_DTIM | IEEE80211_TX_CTL_AMPDU |	      \
-	IEEE80211_TX_STAT_TX_FILTERED |	IEEE80211_TX_STAT_ACK |		      \
-	IEEE80211_TX_STAT_AMPDU | IEEE80211_TX_STAT_AMPDU_NO_BACK |	      \
-	IEEE80211_TX_CTL_RATE_CTRL_PROBE | IEEE80211_TX_CTL_PSPOLL_RESPONSE | \
-	IEEE80211_TX_CTL_MORE_FRAMES | IEEE80211_TX_CTL_LDPC |		      \
-	IEEE80211_TX_CTL_STBC)
+#define MAC80211_TX_TEMPORARY_FLAGS (MAC80211_TX_CTL_NO_ACK |		      \
+	MAC80211_TX_CTL_CLEAR_PS_FILT | MAC80211_TX_CTL_FIRST_FRAGMENT |    \
+	MAC80211_TX_CTL_SEND_AFTER_DTIM | MAC80211_TX_CTL_AMPDU |	      \
+	MAC80211_TX_STAT_TX_FILTERED |	MAC80211_TX_STAT_ACK |		      \
+	MAC80211_TX_STAT_AMPDU | MAC80211_TX_STAT_AMPDU_NO_BACK |	      \
+	MAC80211_TX_CTL_RATE_CTRL_PROBE | MAC80211_TX_CTL_PSPOLL_RESPONSE | \
+	MAC80211_TX_CTL_MORE_FRAMES | MAC80211_TX_CTL_LDPC |		      \
+	MAC80211_TX_CTL_STBC)
 
 /**
  * enum mac80211_rate_control_flags - per-rate flags set by the
  *	Rate Control algorithm.
  *
  * These flags are set by the Rate control algorithm for each rate during tx,
- * in the @flags member of struct ieee80211_tx_rate.
+ * in the @flags member of struct mac80211_tx_rate.
  *
- * @IEEE80211_TX_RC_USE_RTS_CTS: Use RTS/CTS exchange for this rate.
- * @IEEE80211_TX_RC_USE_CTS_PROTECT: CTS-to-self protection is required.
+ * @MAC80211_TX_RC_USE_RTS_CTS: Use RTS/CTS exchange for this rate.
+ * @MAC80211_TX_RC_USE_CTS_PROTECT: CTS-to-self protection is required.
  *	This is set if the current BSS requires ERP protection.
- * @IEEE80211_TX_RC_USE_SHORT_PREAMBLE: Use short preamble.
- * @IEEE80211_TX_RC_MCS: HT rate.
- * @IEEE80211_TX_RC_GREEN_FIELD: Indicates whether this rate should be used in
+ * @MAC80211_TX_RC_USE_SHORT_PREAMBLE: Use short preamble.
+ * @MAC80211_TX_RC_MCS: HT rate.
+ * @MAC80211_TX_RC_GREEN_FIELD: Indicates whether this rate should be used in
  *	Greenfield mode.
- * @IEEE80211_TX_RC_40_MHZ_WIDTH: Indicates if the Channel Width should be 40 MHz.
- * @IEEE80211_TX_RC_DUP_DATA: The frame should be transmitted on both of the
+ * @MAC80211_TX_RC_40_MHZ_WIDTH: Indicates if the Channel Width should be 40 MHz.
+ * @MAC80211_TX_RC_DUP_DATA: The frame should be transmitted on both of the
  *	adjacent 20 MHz channels, if the current channel type is
  *	NL80211_CHAN_HT40MINUS or NL80211_CHAN_HT40PLUS.
- * @IEEE80211_TX_RC_SHORT_GI: Short Guard interval should be used for this rate.
+ * @MAC80211_TX_RC_SHORT_GI: Short Guard interval should be used for this rate.
  */
 enum mac80211_rate_control_flags {
-	IEEE80211_TX_RC_USE_RTS_CTS		= BIT(0),
-	IEEE80211_TX_RC_USE_CTS_PROTECT		= BIT(1),
-	IEEE80211_TX_RC_USE_SHORT_PREAMBLE	= BIT(2),
+	MAC80211_TX_RC_USE_RTS_CTS		= BIT(0),
+	MAC80211_TX_RC_USE_CTS_PROTECT		= BIT(1),
+	MAC80211_TX_RC_USE_SHORT_PREAMBLE	= BIT(2),
 
 	/* rate index is an MCS rate number instead of an index */
-	IEEE80211_TX_RC_MCS			= BIT(3),
-	IEEE80211_TX_RC_GREEN_FIELD		= BIT(4),
-	IEEE80211_TX_RC_40_MHZ_WIDTH		= BIT(5),
-	IEEE80211_TX_RC_DUP_DATA		= BIT(6),
-	IEEE80211_TX_RC_SHORT_GI		= BIT(7),
+	MAC80211_TX_RC_MCS			= BIT(3),
+	MAC80211_TX_RC_GREEN_FIELD		= BIT(4),
+	MAC80211_TX_RC_40_MHZ_WIDTH		= BIT(5),
+	MAC80211_TX_RC_DUP_DATA		= BIT(6),
+	MAC80211_TX_RC_SHORT_GI		= BIT(7),
 };
 
 
 /* there are 40 bytes if you don't need the rateset to be kept */
-#define IEEE80211_TX_INFO_DRIVER_DATA_SIZE 40
+#define MAC80211_TX_INFO_DRIVER_DATA_SIZE 40
 
 /* if you do need the rateset, then you have less space */
-#define IEEE80211_TX_INFO_RATE_DRIVER_DATA_SIZE 24
+#define MAC80211_TX_INFO_RATE_DRIVER_DATA_SIZE 24
 
 /* maximum number of rate stages */
-#define IEEE80211_TX_MAX_RATES	5
+#define MAC80211_TX_MAX_RATES	5
 
 /**
- * struct ieee80211_tx_rate - rate selection/status
+ * struct mac80211_tx_rate - rate selection/status
  *
  * @idx: rate index to attempt to send with
  * @flags: rate control flags (&enum mac80211_rate_control_flags)
@@ -447,7 +449,7 @@ enum mac80211_rate_control_flags {
  * When used for transmit status reporting, the driver should
  * always report the rate along with the flags it used.
  *
- * &struct ieee80211_tx_info contains an array of these structs
+ * &struct mac80211_tx_info contains an array of these structs
  * in the control information, and it will be filled by the rate
  * control algorithm according to what should be sent. For example,
  * if this array contains, in the format { <idx>, <count> } the
@@ -462,14 +464,14 @@ enum mac80211_rate_control_flags {
  * since it was transmitted twice at rate 3, twice at rate 2
  * and once at rate 1 after which we received an acknowledgement.
  */
-struct ieee80211_tx_rate {
+struct mac80211_tx_rate {
 	s8 idx;
 	u8 count;
 	u8 flags;
 } __packed;
 
 /**
- * struct ieee80211_tx_info - skb transmit information
+ * struct mac80211_tx_info - skb transmit information
  *
  * This structure is placed in skb->cb for three uses:
  *  (1) mac80211 TX control - mac80211 tells the driver what to do
@@ -487,12 +489,12 @@ struct ieee80211_tx_rate {
  * @status: union for status data
  * @driver_data: array of driver_data pointers
  * @ampdu_ack_len: number of acked aggregated frames.
- * 	relevant only if IEEE80211_TX_STAT_AMPDU was set.
+ * 	relevant only if MAC80211_TX_STAT_AMPDU was set.
  * @ampdu_len: number of aggregated frames.
- * 	relevant only if IEEE80211_TX_STAT_AMPDU was set.
+ * 	relevant only if MAC80211_TX_STAT_AMPDU was set.
  * @ack_signal: signal strength of the ACK frame
  */
-struct ieee80211_tx_info {
+struct mac80211_tx_info {
 	/* common information */
 	u32 flags;
 	u8 band;
@@ -507,38 +509,38 @@ struct ieee80211_tx_info {
 			union {
 				/* rate control */
 				struct {
-					struct ieee80211_tx_rate rates[
-						IEEE80211_TX_MAX_RATES];
+					struct mac80211_tx_rate rates[
+						MAC80211_TX_MAX_RATES];
 					s8 rts_cts_rate_idx;
 				};
 				/* only needed before rate control */
 				unsigned long jiffies;
 			};
 			/* NB: vif can be NULL for injected frames */
-			struct ieee80211_vif *vif;
-			struct ieee80211_key_conf *hw_key;
-			struct ieee80211_sta *sta;
+			struct mac80211_vif *vif;
+			struct mac80211_key_conf *hw_key;
+			struct mac80211_sta *sta;
 		} control;
 		struct {
-			struct ieee80211_tx_rate rates[IEEE80211_TX_MAX_RATES];
+			struct mac80211_tx_rate rates[MAC80211_TX_MAX_RATES];
 			u8 ampdu_ack_len;
 			int ack_signal;
 			u8 ampdu_len;
 			/* 15 bytes free */
 		} status;
 		struct {
-			struct ieee80211_tx_rate driver_rates[
-				IEEE80211_TX_MAX_RATES];
+			struct mac80211_tx_rate driver_rates[
+				MAC80211_TX_MAX_RATES];
 			void *rate_driver_data[
-				IEEE80211_TX_INFO_RATE_DRIVER_DATA_SIZE / sizeof(void *)];
+				MAC80211_TX_INFO_RATE_DRIVER_DATA_SIZE / sizeof(void *)];
 		};
 		void *driver_data[
-			IEEE80211_TX_INFO_DRIVER_DATA_SIZE / sizeof(void *)];
+			MAC80211_TX_INFO_DRIVER_DATA_SIZE / sizeof(void *)];
 	};
 };
 
 /**
- * struct ieee80211_sched_scan_ies - scheduled scan IEs
+ * struct mac80211_sched_scan_ies - scheduled scan IEs
  *
  * This structure is used to pass the appropriate IEs to be used in scheduled
  * scans for all bands.  It contains both the IEs passed from the userspace
@@ -547,25 +549,25 @@ struct ieee80211_tx_info {
  * @ie: array with the IEs for each supported band
  * @len: array with the total length of the IEs for each band
  */
-struct ieee80211_sched_scan_ies {
+struct mac80211_sched_scan_ies {
 	u8 *ie[IEEE80211_NUM_BANDS];
 	size_t len[IEEE80211_NUM_BANDS];
 };
 
-static inline struct ieee80211_tx_info *IEEE80211_SKB_CB(struct sk_buff *skb)
+static inline struct mac80211_tx_info *MAC80211_SKB_CB(struct sk_buff *skb)
 {
-	return (struct ieee80211_tx_info *)skb->cb;
+	return (struct mac80211_tx_info *)skb->cb;
 }
 
-static inline struct ieee80211_rx_status *IEEE80211_SKB_RXCB(struct sk_buff *skb)
+static inline struct mac80211_rx_status *MAC80211_SKB_RXCB(struct sk_buff *skb)
 {
-	return (struct ieee80211_rx_status *)skb->cb;
+	return (struct mac80211_rx_status *)skb->cb;
 }
 
 /**
- * ieee80211_tx_info_clear_status - clear TX status
+ * mac80211_tx_info_clear_status - clear TX status
  *
- * @info: The &struct ieee80211_tx_info to be cleared.
+ * @info: The &struct mac80211_tx_info to be cleared.
  *
  * When the driver passes an skb back to mac80211, it must report
  * a number of things in TX status. This function clears everything
@@ -577,31 +579,31 @@ static inline struct ieee80211_rx_status *IEEE80211_SKB_RXCB(struct sk_buff *skb
  *	 instead if you need only the less space that allows.
  */
 static inline void
-ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
+mac80211_tx_info_clear_status(struct mac80211_tx_info *info)
 {
 	int i;
 
-	BUILD_BUG_ON(offsetof(struct ieee80211_tx_info, status.rates) !=
-		     offsetof(struct ieee80211_tx_info, control.rates));
-	BUILD_BUG_ON(offsetof(struct ieee80211_tx_info, status.rates) !=
-		     offsetof(struct ieee80211_tx_info, driver_rates));
-	BUILD_BUG_ON(offsetof(struct ieee80211_tx_info, status.rates) != 8);
+	BUILD_BUG_ON(offsetof(struct mac80211_tx_info, status.rates) !=
+		     offsetof(struct mac80211_tx_info, control.rates));
+	BUILD_BUG_ON(offsetof(struct mac80211_tx_info, status.rates) !=
+		     offsetof(struct mac80211_tx_info, driver_rates));
+	BUILD_BUG_ON(offsetof(struct mac80211_tx_info, status.rates) != 8);
 	/* clear the rate counts */
-	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
+	for (i = 0; i < MAC80211_TX_MAX_RATES; i++)
 		info->status.rates[i].count = 0;
 
 	BUILD_BUG_ON(
-	    offsetof(struct ieee80211_tx_info, status.ampdu_ack_len) != 23);
+	    offsetof(struct mac80211_tx_info, status.ampdu_ack_len) != 23);
 	memset(&info->status.ampdu_ack_len, 0,
-	       sizeof(struct ieee80211_tx_info) -
-	       offsetof(struct ieee80211_tx_info, status.ampdu_ack_len));
+	       sizeof(struct mac80211_tx_info) -
+	       offsetof(struct mac80211_tx_info, status.ampdu_ack_len));
 }
 
 
 /**
  * enum mac80211_rx_flags - receive flags
  *
- * These flags are used with the @flag member of &struct ieee80211_rx_status.
+ * These flags are used with the @flag member of &struct mac80211_rx_status.
  * @RX_FLAG_MMIC_ERROR: Michael MIC error was reported on this frame.
  *	Use together with %RX_FLAG_MMIC_STRIPPED.
  * @RX_FLAG_DECRYPTED: This frame was decrypted in hardware.
@@ -638,7 +640,7 @@ enum mac80211_rx_flags {
 };
 
 /**
- * struct ieee80211_rx_status - receive status
+ * struct mac80211_rx_status - receive status
  *
  * The low-level driver should provide this information (the subset
  * supported by hardware) to the 802.11 code with each received
@@ -650,14 +652,14 @@ enum mac80211_rx_flags {
  * @freq: frequency the radio was tuned to when receiving this frame, in MHz
  * @signal: signal strength when receiving this frame, either in dBm, in dB or
  *	unspecified depending on the hardware capabilities flags
- *	@IEEE80211_HW_SIGNAL_*
+ *	@MAC80211_HW_SIGNAL_*
  * @antenna: antenna used
  * @rate_idx: index of data rate into band's supported rates or MCS index if
  *	HT rates are use (RX_FLAG_HT)
  * @flag: %RX_FLAG_*
  * @rx_flags: internal RX flags for mac80211
  */
-struct ieee80211_rx_status {
+struct mac80211_rx_status {
 	u64 mactime;
 	enum ieee80211_band band;
 	int freq;
@@ -669,80 +671,80 @@ struct ieee80211_rx_status {
 };
 
 /**
- * enum ieee80211_conf_flags - configuration flags
+ * enum mac80211_conf_flags - configuration flags
  *
  * Flags to define PHY configuration options
  *
- * @IEEE80211_CONF_MONITOR: there's a monitor interface present -- use this
+ * @MAC80211_CONF_MONITOR: there's a monitor interface present -- use this
  *	to determine for example whether to calculate timestamps for packets
  *	or not, do not use instead of filter flags!
- * @IEEE80211_CONF_PS: Enable 802.11 power save mode (managed mode only).
+ * @MAC80211_CONF_PS: Enable 802.11 power save mode (managed mode only).
  *	This is the power save mode defined by IEEE 802.11-2007 section 11.2,
  *	meaning that the hardware still wakes up for beacons, is able to
  *	transmit frames and receive the possible acknowledgment frames.
  *	Not to be confused with hardware specific wakeup/sleep states,
  *	driver is responsible for that. See the section "Powersave support"
  *	for more.
- * @IEEE80211_CONF_IDLE: The device is running, but idle; if the flag is set
+ * @MAC80211_CONF_IDLE: The device is running, but idle; if the flag is set
  *	the driver should be prepared to handle configuration requests but
  *	may turn the device off as much as possible. Typically, this flag will
  *	be set when an interface is set UP but not associated or scanning, but
  *	it can also be unset in that case when monitor interfaces are active.
- * @IEEE80211_CONF_OFFCHANNEL: The device is currently not on its main
+ * @MAC80211_CONF_OFFCHANNEL: The device is currently not on its main
  *	operating channel.
  */
-enum ieee80211_conf_flags {
-	IEEE80211_CONF_MONITOR		= (1<<0),
-	IEEE80211_CONF_PS		= (1<<1),
-	IEEE80211_CONF_IDLE		= (1<<2),
-	IEEE80211_CONF_OFFCHANNEL	= (1<<3),
+enum mac80211_conf_flags {
+	MAC80211_CONF_MONITOR		= (1<<0),
+	MAC80211_CONF_PS		= (1<<1),
+	MAC80211_CONF_IDLE		= (1<<2),
+	MAC80211_CONF_OFFCHANNEL	= (1<<3),
 };
 
 
 /**
- * enum ieee80211_conf_changed - denotes which configuration changed
+ * enum mac80211_conf_changed - denotes which configuration changed
  *
- * @IEEE80211_CONF_CHANGE_LISTEN_INTERVAL: the listen interval changed
- * @IEEE80211_CONF_CHANGE_MONITOR: the monitor flag changed
- * @IEEE80211_CONF_CHANGE_PS: the PS flag or dynamic PS timeout changed
- * @IEEE80211_CONF_CHANGE_POWER: the TX power changed
- * @IEEE80211_CONF_CHANGE_CHANNEL: the channel/channel_type changed
- * @IEEE80211_CONF_CHANGE_RETRY_LIMITS: retry limits changed
- * @IEEE80211_CONF_CHANGE_IDLE: Idle flag changed
- * @IEEE80211_CONF_CHANGE_SMPS: Spatial multiplexing powersave mode changed
+ * @MAC80211_CONF_CHANGE_LISTEN_INTERVAL: the listen interval changed
+ * @MAC80211_CONF_CHANGE_MONITOR: the monitor flag changed
+ * @MAC80211_CONF_CHANGE_PS: the PS flag or dynamic PS timeout changed
+ * @MAC80211_CONF_CHANGE_POWER: the TX power changed
+ * @MAC80211_CONF_CHANGE_CHANNEL: the channel/channel_type changed
+ * @MAC80211_CONF_CHANGE_RETRY_LIMITS: retry limits changed
+ * @MAC80211_CONF_CHANGE_IDLE: Idle flag changed
+ * @MAC80211_CONF_CHANGE_SMPS: Spatial multiplexing powersave mode changed
  */
-enum ieee80211_conf_changed {
-	IEEE80211_CONF_CHANGE_SMPS		= BIT(1),
-	IEEE80211_CONF_CHANGE_LISTEN_INTERVAL	= BIT(2),
-	IEEE80211_CONF_CHANGE_MONITOR		= BIT(3),
-	IEEE80211_CONF_CHANGE_PS		= BIT(4),
-	IEEE80211_CONF_CHANGE_POWER		= BIT(5),
-	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
-	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
-	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
+enum mac80211_conf_changed {
+	MAC80211_CONF_CHANGE_SMPS		= BIT(1),
+	MAC80211_CONF_CHANGE_LISTEN_INTERVAL	= BIT(2),
+	MAC80211_CONF_CHANGE_MONITOR		= BIT(3),
+	MAC80211_CONF_CHANGE_PS		= BIT(4),
+	MAC80211_CONF_CHANGE_POWER		= BIT(5),
+	MAC80211_CONF_CHANGE_CHANNEL		= BIT(6),
+	MAC80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
+	MAC80211_CONF_CHANGE_IDLE		= BIT(8),
 };
 
 /**
- * enum ieee80211_smps_mode - spatial multiplexing power save mode
+ * enum mac80211_smps_mode - spatial multiplexing power save mode
  *
- * @IEEE80211_SMPS_AUTOMATIC: automatic
- * @IEEE80211_SMPS_OFF: off
- * @IEEE80211_SMPS_STATIC: static
- * @IEEE80211_SMPS_DYNAMIC: dynamic
- * @IEEE80211_SMPS_NUM_MODES: internal, don't use
+ * @MAC80211_SMPS_AUTOMATIC: automatic
+ * @MAC80211_SMPS_OFF: off
+ * @MAC80211_SMPS_STATIC: static
+ * @MAC80211_SMPS_DYNAMIC: dynamic
+ * @MAC80211_SMPS_NUM_MODES: internal, don't use
  */
-enum ieee80211_smps_mode {
-	IEEE80211_SMPS_AUTOMATIC,
-	IEEE80211_SMPS_OFF,
-	IEEE80211_SMPS_STATIC,
-	IEEE80211_SMPS_DYNAMIC,
+enum mac80211_smps_mode {
+	MAC80211_SMPS_AUTOMATIC,
+	MAC80211_SMPS_OFF,
+	MAC80211_SMPS_STATIC,
+	MAC80211_SMPS_DYNAMIC,
 
 	/* keep last */
-	IEEE80211_SMPS_NUM_MODES,
+	MAC80211_SMPS_NUM_MODES,
 };
 
 /**
- * struct ieee80211_conf - configuration of the device
+ * struct mac80211_conf - configuration of the device
  *
  * This struct indicates how the driver shall configure the hardware.
  *
@@ -774,10 +776,10 @@ enum ieee80211_smps_mode {
  *    number of transmissions not the number of retries
  *
  * @smps_mode: spatial multiplexing powersave mode; note that
- *	%IEEE80211_SMPS_STATIC is used when the device is not
+ *	%MAC80211_SMPS_STATIC is used when the device is not
  *	configured for an HT channel
  */
-struct ieee80211_conf {
+struct mac80211_conf {
 	u32 flags;
 	int power_level, dynamic_ps_timeout;
 	int max_sleep_period;
@@ -789,11 +791,11 @@ struct ieee80211_conf {
 
 	struct ieee80211_channel *channel;
 	enum nl80211_channel_type channel_type;
-	enum ieee80211_smps_mode smps_mode;
+	enum mac80211_smps_mode smps_mode;
 };
 
 /**
- * struct ieee80211_channel_switch - holds the channel switch data
+ * struct mac80211_channel_switch - holds the channel switch data
  *
  * The information provided in this structure is required for channel switch
  * operation.
@@ -807,7 +809,7 @@ struct ieee80211_conf {
  * @channel: the new channel to switch to
  * @count: the number of TBTT's until the channel switch event
  */
-struct ieee80211_channel_switch {
+struct mac80211_channel_switch {
 	u64 timestamp;
 	bool block_tx;
 	struct ieee80211_channel *channel;
@@ -815,7 +817,7 @@ struct ieee80211_channel_switch {
 };
 
 /**
- * struct ieee80211_vif - per-interface data
+ * struct mac80211_vif - per-interface data
  *
  * Data in this structure is continually present for driver
  * use during the life of a virtual interface.
@@ -829,16 +831,16 @@ struct ieee80211_channel_switch {
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *).
  */
-struct ieee80211_vif {
+struct mac80211_vif {
 	enum nl80211_iftype type;
-	struct ieee80211_bss_conf bss_conf;
+	struct mac80211_bss_conf bss_conf;
 	u8 addr[ETH_ALEN];
 	bool p2p;
 	/* must be last */
 	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
 };
 
-static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
+static inline bool mac80211_vif_is_mesh(struct mac80211_vif *vif)
 {
 #ifdef CONFIG_MAC80211_MESH
 	return vif->type == NL80211_IFTYPE_MESH_POINT;
@@ -847,44 +849,44 @@ static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
 }
 
 /**
- * enum ieee80211_key_flags - key flags
+ * enum mac80211_key_flags - key flags
  *
  * These flags are used for communication about keys between the driver
- * and mac80211, with the @flags parameter of &struct ieee80211_key_conf.
+ * and mac80211, with the @flags parameter of &struct mac80211_key_conf.
  *
- * @IEEE80211_KEY_FLAG_WMM_STA: Set by mac80211, this flag indicates
+ * @MAC80211_KEY_FLAG_WMM_STA: Set by mac80211, this flag indicates
  *	that the STA this key will be used with could be using QoS.
- * @IEEE80211_KEY_FLAG_GENERATE_IV: This flag should be set by the
+ * @MAC80211_KEY_FLAG_GENERATE_IV: This flag should be set by the
  *	driver to indicate that it requires IV generation for this
  *	particular key.
- * @IEEE80211_KEY_FLAG_GENERATE_MMIC: This flag should be set by
+ * @MAC80211_KEY_FLAG_GENERATE_MMIC: This flag should be set by
  *	the driver for a TKIP key if it requires Michael MIC
  *	generation in software.
- * @IEEE80211_KEY_FLAG_PAIRWISE: Set by mac80211, this flag indicates
+ * @MAC80211_KEY_FLAG_PAIRWISE: Set by mac80211, this flag indicates
  *	that the key is pairwise rather then a shared key.
- * @IEEE80211_KEY_FLAG_SW_MGMT: This flag should be set by the driver for a
+ * @MAC80211_KEY_FLAG_SW_MGMT: This flag should be set by the driver for a
  *	CCMP key if it requires CCMP encryption of management frames (MFP) to
  *	be done in software.
  */
-enum ieee80211_key_flags {
-	IEEE80211_KEY_FLAG_WMM_STA	= 1<<0,
-	IEEE80211_KEY_FLAG_GENERATE_IV	= 1<<1,
-	IEEE80211_KEY_FLAG_GENERATE_MMIC= 1<<2,
-	IEEE80211_KEY_FLAG_PAIRWISE	= 1<<3,
-	IEEE80211_KEY_FLAG_SW_MGMT	= 1<<4,
+enum mac80211_key_flags {
+	MAC80211_KEY_FLAG_WMM_STA	= 1<<0,
+	MAC80211_KEY_FLAG_GENERATE_IV	= 1<<1,
+	MAC80211_KEY_FLAG_GENERATE_MMIC= 1<<2,
+	MAC80211_KEY_FLAG_PAIRWISE	= 1<<3,
+	MAC80211_KEY_FLAG_SW_MGMT	= 1<<4,
 };
 
 /**
- * struct ieee80211_key_conf - key information
+ * struct mac80211_key_conf - key information
  *
  * This key information is given by mac80211 to the driver by
- * the set_key() callback in &struct ieee80211_ops.
+ * the set_key() callback in &struct mac80211_ops.
  *
  * @hw_key_idx: To be set by the driver, this is the key index the driver
  *	wants to be given when a frame is transmitted and needs to be
  *	encrypted in hardware.
  * @cipher: The key's cipher suite selector.
- * @flags: key flags, see &enum ieee80211_key_flags.
+ * @flags: key flags, see &enum mac80211_key_flags.
  * @keyidx: the key index (0-3)
  * @keylen: key material length
  * @key: key material. For ALG_TKIP the key is encoded as a 256-bit (32 byte)
@@ -895,7 +897,7 @@ enum ieee80211_key_flags {
  * @icv_len: The ICV length for this key type
  * @iv_len: The IV length for this key type
  */
-struct ieee80211_key_conf {
+struct mac80211_key_conf {
 	u32 cipher;
 	u8 icv_len;
 	u8 iv_len;
@@ -909,7 +911,7 @@ struct ieee80211_key_conf {
 /**
  * enum set_key_cmd - key command
  *
- * Used with the set_key() callback in &struct ieee80211_ops, this
+ * Used with the set_key() callback in &struct mac80211_ops, this
  * indicates whether a key is being removed or added.
  *
  * @SET_KEY: a key is set
@@ -920,11 +922,11 @@ enum set_key_cmd {
 };
 
 /**
- * struct ieee80211_sta - station table entry
+ * struct mac80211_sta - station table entry
  *
  * A station table entry represents a station we are possibly
  * communicating with. Since stations are RCU-managed in
- * mac80211, any ieee80211_sta pointer you get access to must
+ * mac80211, any mac80211_sta pointer you get access to must
  * either be protected by rcu_read_lock() explicitly or implicitly,
  * or you must take good care to not use such a pointer after a
  * call to your sta_remove callback that removed it.
@@ -936,7 +938,7 @@ enum set_key_cmd {
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *), size is determined in hw information.
  */
-struct ieee80211_sta {
+struct mac80211_sta {
 	u32 supp_rates[IEEE80211_NUM_BANDS];
 	u8 addr[ETH_ALEN];
 	u16 aid;
@@ -949,7 +951,7 @@ struct ieee80211_sta {
 /**
  * enum sta_notify_cmd - sta notify command
  *
- * Used with the sta_notify() callback in &struct ieee80211_ops, this
+ * Used with the sta_notify() callback in &struct mac80211_ops, this
  * indicates if an associated station made a power state transition.
  *
  * @STA_NOTIFY_SLEEP: a station is now sleeping
@@ -960,22 +962,22 @@ enum sta_notify_cmd {
 };
 
 /**
- * enum ieee80211_tkip_key_type - get tkip key
+ * enum mac80211_tkip_key_type - get tkip key
  *
  * Used by drivers which need to get a tkip key for skb. Some drivers need a
  * phase 1 key, others need a phase 2 key. A single function allows the driver
  * to get the key, this enum indicates what type of key is required.
  *
- * @IEEE80211_TKIP_P1_KEY: the driver needs a phase 1 key
- * @IEEE80211_TKIP_P2_KEY: the driver needs a phase 2 key
+ * @MAC80211_TKIP_P1_KEY: the driver needs a phase 1 key
+ * @MAC80211_TKIP_P2_KEY: the driver needs a phase 2 key
  */
-enum ieee80211_tkip_key_type {
-	IEEE80211_TKIP_P1_KEY,
-	IEEE80211_TKIP_P2_KEY,
+enum mac80211_tkip_key_type {
+	MAC80211_TKIP_P1_KEY,
+	MAC80211_TKIP_P2_KEY,
 };
 
 /**
- * enum ieee80211_hw_flags - hardware flags
+ * enum mac80211_hw_flags - hardware flags
  *
  * These flags are used to indicate hardware capabilities to
  * the stack. Generally, flags here should have their meaning
@@ -983,7 +985,7 @@ enum ieee80211_tkip_key_type {
  * any particular flags. There are some exceptions to this rule,
  * however, so you are advised to review these flags carefully.
  *
- * @IEEE80211_HW_HAS_RATE_CONTROL:
+ * @MAC80211_HW_HAS_RATE_CONTROL:
  *	The hardware or firmware includes rate control, and cannot be
  *	controlled by the stack. As such, no rate control algorithm
  *	should be instantiated, and the TX rate reported to userspace
@@ -996,151 +998,151 @@ enum ieee80211_tkip_key_type {
  *	timing in 2.4 GHz and @use_short_preamble for preambles for
  *	CCK frames.
  *
- * @IEEE80211_HW_RX_INCLUDES_FCS:
+ * @MAC80211_HW_RX_INCLUDES_FCS:
  *	Indicates that received frames passed to the stack include
  *	the FCS at the end.
  *
- * @IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING:
+ * @MAC80211_HW_HOST_BROADCAST_PS_BUFFERING:
  *	Some wireless LAN chipsets buffer broadcast/multicast frames
  *	for power saving stations in the hardware/firmware and others
  *	rely on the host system for such buffering. This option is used
  *	to configure the IEEE 802.11 upper layer to buffer broadcast and
  *	multicast frames when there are power saving stations so that
- *	the driver can fetch them with ieee80211_get_buffered_bc().
+ *	the driver can fetch them with mac80211_get_buffered_bc().
  *
- * @IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE:
+ * @MAC80211_HW_2GHZ_SHORT_SLOT_INCAPABLE:
  *	Hardware is not capable of short slot operation on the 2.4 GHz band.
  *
- * @IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE:
+ * @MAC80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE:
  *	Hardware is not capable of receiving frames with short preamble on
  *	the 2.4 GHz band.
  *
- * @IEEE80211_HW_SIGNAL_UNSPEC:
+ * @MAC80211_HW_SIGNAL_UNSPEC:
  *	Hardware can provide signal values but we don't know its units. We
  *	expect values between 0 and @max_signal.
  *	If possible please provide dB or dBm instead.
  *
- * @IEEE80211_HW_SIGNAL_DBM:
+ * @MAC80211_HW_SIGNAL_DBM:
  *	Hardware gives signal values in dBm, decibel difference from
  *	one milliwatt. This is the preferred method since it is standardized
  *	between different devices. @max_signal does not need to be set.
  *
- * @IEEE80211_HW_SPECTRUM_MGMT:
+ * @MAC80211_HW_SPECTRUM_MGMT:
  * 	Hardware supports spectrum management defined in 802.11h
  * 	Measurement, Channel Switch, Quieting, TPC
  *
- * @IEEE80211_HW_AMPDU_AGGREGATION:
+ * @MAC80211_HW_AMPDU_AGGREGATION:
  *	Hardware supports 11n A-MPDU aggregation.
  *
- * @IEEE80211_HW_SUPPORTS_PS:
+ * @MAC80211_HW_SUPPORTS_PS:
  *	Hardware has power save support (i.e. can go to sleep).
  *
- * @IEEE80211_HW_PS_NULLFUNC_STACK:
+ * @MAC80211_HW_PS_NULLFUNC_STACK:
  *	Hardware requires nullfunc frame handling in stack, implies
  *	stack support for dynamic PS.
  *
- * @IEEE80211_HW_SUPPORTS_DYNAMIC_PS:
+ * @MAC80211_HW_SUPPORTS_DYNAMIC_PS:
  *	Hardware has support for dynamic PS.
  *
- * @IEEE80211_HW_MFP_CAPABLE:
+ * @MAC80211_HW_MFP_CAPABLE:
  *	Hardware supports management frame protection (MFP, IEEE 802.11w).
  *
- * @IEEE80211_HW_BEACON_FILTER:
+ * @MAC80211_HW_BEACON_FILTER:
  *	Hardware supports dropping of irrelevant beacon frames to
  *	avoid waking up cpu.
  *
- * @IEEE80211_HW_SUPPORTS_STATIC_SMPS:
+ * @MAC80211_HW_SUPPORTS_STATIC_SMPS:
  *	Hardware supports static spatial multiplexing powersave,
  *	ie. can turn off all but one chain even on HT connections
  *	that should be using more chains.
  *
- * @IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS:
+ * @MAC80211_HW_SUPPORTS_DYNAMIC_SMPS:
  *	Hardware supports dynamic spatial multiplexing powersave,
  *	ie. can turn off all but one chain and then wake the rest
  *	up as required after, for example, rts/cts handshake.
  *
- * @IEEE80211_HW_SUPPORTS_UAPSD:
+ * @MAC80211_HW_SUPPORTS_UAPSD:
  *	Hardware supports Unscheduled Automatic Power Save Delivery
  *	(U-APSD) in managed mode. The mode is configured with
  *	conf_tx() operation.
  *
- * @IEEE80211_HW_REPORTS_TX_ACK_STATUS:
+ * @MAC80211_HW_REPORTS_TX_ACK_STATUS:
  *	Hardware can provide ack status reports of Tx frames to
  *	the stack.
  *
- * @IEEE80211_HW_CONNECTION_MONITOR:
+ * @MAC80211_HW_CONNECTION_MONITOR:
  *      The hardware performs its own connection monitoring, including
  *      periodic keep-alives to the AP and probing the AP on beacon loss.
  *      When this flag is set, signaling beacon-loss will cause an immediate
  *      change to disassociated state.
  *
- * @IEEE80211_HW_SUPPORTS_CQM_RSSI:
+ * @MAC80211_HW_SUPPORTS_CQM_RSSI:
  *	Hardware can do connection quality monitoring - i.e. it can monitor
  *	connection quality related parameters, such as the RSSI level and
  *	provide notifications if configured trigger levels are reached.
  *
- * @IEEE80211_HW_NEED_DTIM_PERIOD:
+ * @MAC80211_HW_NEED_DTIM_PERIOD:
  *	This device needs to know the DTIM period for the BSS before
  *	associating.
  *
- * @IEEE80211_HW_SUPPORTS_PER_STA_GTK: The device's crypto engine supports
+ * @MAC80211_HW_SUPPORTS_PER_STA_GTK: The device's crypto engine supports
  *	per-station GTKs as used by IBSS RSN or during fast transition. If
  *	the device doesn't support per-station GTKs, but can be asked not
  *	to decrypt group addressed frames, then IBSS RSN support is still
  *	possible but software crypto will be used. Advertise the wiphy flag
  *	only in that case.
  *
- * @IEEE80211_HW_AP_LINK_PS: When operating in AP mode the device
+ * @MAC80211_HW_AP_LINK_PS: When operating in AP mode the device
  *	autonomously manages the PS status of connected stations. When
  *	this flag is set mac80211 will not trigger PS mode for connected
  *	stations based on the PM bit of incoming frames.
- *	Use ieee80211_start_ps()/ieee8021_end_ps() to manually configure
+ *	Use mac80211_start_ps()/ieee8021_end_ps() to manually configure
  *	the PS mode of connected stations.
  */
-enum ieee80211_hw_flags {
-	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
-	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
-	IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING	= 1<<2,
-	IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE		= 1<<3,
-	IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE	= 1<<4,
-	IEEE80211_HW_SIGNAL_UNSPEC			= 1<<5,
-	IEEE80211_HW_SIGNAL_DBM				= 1<<6,
-	IEEE80211_HW_NEED_DTIM_PERIOD			= 1<<7,
-	IEEE80211_HW_SPECTRUM_MGMT			= 1<<8,
-	IEEE80211_HW_AMPDU_AGGREGATION			= 1<<9,
-	IEEE80211_HW_SUPPORTS_PS			= 1<<10,
-	IEEE80211_HW_PS_NULLFUNC_STACK			= 1<<11,
-	IEEE80211_HW_SUPPORTS_DYNAMIC_PS		= 1<<12,
-	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
-	IEEE80211_HW_BEACON_FILTER			= 1<<14,
-	IEEE80211_HW_SUPPORTS_STATIC_SMPS		= 1<<15,
-	IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS		= 1<<16,
-	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
-	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
-	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
-	IEEE80211_HW_SUPPORTS_CQM_RSSI			= 1<<20,
-	IEEE80211_HW_SUPPORTS_PER_STA_GTK		= 1<<21,
-	IEEE80211_HW_AP_LINK_PS				= 1<<22,
+enum mac80211_hw_flags {
+	MAC80211_HW_HAS_RATE_CONTROL			= 1<<0,
+	MAC80211_HW_RX_INCLUDES_FCS			= 1<<1,
+	MAC80211_HW_HOST_BROADCAST_PS_BUFFERING	= 1<<2,
+	MAC80211_HW_2GHZ_SHORT_SLOT_INCAPABLE		= 1<<3,
+	MAC80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE	= 1<<4,
+	MAC80211_HW_SIGNAL_UNSPEC			= 1<<5,
+	MAC80211_HW_SIGNAL_DBM				= 1<<6,
+	MAC80211_HW_NEED_DTIM_PERIOD			= 1<<7,
+	MAC80211_HW_SPECTRUM_MGMT			= 1<<8,
+	MAC80211_HW_AMPDU_AGGREGATION			= 1<<9,
+	MAC80211_HW_SUPPORTS_PS			= 1<<10,
+	MAC80211_HW_PS_NULLFUNC_STACK			= 1<<11,
+	MAC80211_HW_SUPPORTS_DYNAMIC_PS		= 1<<12,
+	MAC80211_HW_MFP_CAPABLE			= 1<<13,
+	MAC80211_HW_BEACON_FILTER			= 1<<14,
+	MAC80211_HW_SUPPORTS_STATIC_SMPS		= 1<<15,
+	MAC80211_HW_SUPPORTS_DYNAMIC_SMPS		= 1<<16,
+	MAC80211_HW_SUPPORTS_UAPSD			= 1<<17,
+	MAC80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
+	MAC80211_HW_CONNECTION_MONITOR			= 1<<19,
+	MAC80211_HW_SUPPORTS_CQM_RSSI			= 1<<20,
+	MAC80211_HW_SUPPORTS_PER_STA_GTK		= 1<<21,
+	MAC80211_HW_AP_LINK_PS				= 1<<22,
 };
 
 /**
- * struct ieee80211_hw - hardware information and state
+ * struct mac80211_hw - hardware information and state
  *
  * This structure contains the configuration and hardware
  * information for an 802.11 PHY.
  *
  * @wiphy: This points to the &struct wiphy allocated for this
  *	802.11 PHY. You must fill in the @perm_addr and @dev
- *	members of this structure using SET_IEEE80211_DEV()
- *	and SET_IEEE80211_PERM_ADDR(). Additionally, all supported
+ *	members of this structure using SET_MAC80211_DEV()
+ *	and SET_MAC80211_PERM_ADDR(). Additionally, all supported
  *	bands (with channels, bitrates) are registered here.
  *
- * @conf: &struct ieee80211_conf, device configuration, don't use.
+ * @conf: &struct mac80211_conf, device configuration, don't use.
  *
  * @priv: pointer to private area that was allocated for driver use
  *	along with this structure.
  *
- * @flags: hardware flags, see &enum ieee80211_hw_flags.
+ * @flags: hardware flags, see &enum mac80211_hw_flags.
  *
  * @extra_tx_headroom: headroom to reserve in each transmit skb
  *	for use by the driver (e.g. for transmit headers.)
@@ -1148,7 +1150,7 @@ enum ieee80211_hw_flags {
  * @channel_change_time: time (in microseconds) it takes to change channels.
  *
  * @max_signal: Maximum value for signal (rssi) in RX information, used
- *     only when @IEEE80211_HW_SIGNAL_UNSPEC or @IEEE80211_HW_SIGNAL_DB
+ *     only when @MAC80211_HW_SIGNAL_UNSPEC or @MAC80211_HW_SIGNAL_DB
  *
  * @max_listen_interval: max listen interval in units of beacon interval
  *     that HW supports
@@ -1159,12 +1161,12 @@ enum ieee80211_hw_flags {
  *
  * @rate_control_algorithm: rate control algorithm for this hardware.
  *	If unset (NULL), the default algorithm will be used. Must be
- *	set before calling ieee80211_register_hw().
+ *	set before calling mac80211_register_hw().
  *
  * @vif_data_size: size (in bytes) of the drv_priv data area
- *	within &struct ieee80211_vif.
+ *	within &struct mac80211_vif.
  * @sta_data_size: size (in bytes) of the drv_priv data area
- *	within &struct ieee80211_sta.
+ *	within &struct mac80211_sta.
  *
  * @max_rates: maximum number of alternate rate retry stages the hw
  *	can handle.
@@ -1187,8 +1189,8 @@ enum ieee80211_hw_flags {
  *	aggregate an HT driver will transmit, used by the peer as a
  *	hint to size its reorder buffer.
  */
-struct ieee80211_hw {
-	struct ieee80211_conf conf;
+struct mac80211_hw {
+	struct mac80211_conf conf;
 	struct wiphy *wiphy;
 	const char *rate_control_algorithm;
 	void *priv;
@@ -1209,43 +1211,43 @@ struct ieee80211_hw {
 };
 
 /**
- * wiphy_to_ieee80211_hw - return a mac80211 driver hw struct from a wiphy
+ * wiphy_to_mac80211_hw - return a mac80211 driver hw struct from a wiphy
  *
  * @wiphy: the &struct wiphy which we want to query
  *
  * mac80211 drivers can use this to get to their respective
- * &struct ieee80211_hw. Drivers wishing to get to their own private
+ * &struct mac80211_hw. Drivers wishing to get to their own private
  * structure can then access it via hw->priv. Note that mac802111 drivers should
  * not use wiphy_priv() to try to get their private driver structure as this
  * is already used internally by mac80211.
  */
-struct ieee80211_hw *wiphy_to_ieee80211_hw(struct wiphy *wiphy);
+struct mac80211_hw *wiphy_to_mac80211_hw(struct wiphy *wiphy);
 
 /**
- * SET_IEEE80211_DEV - set device for 802.11 hardware
+ * SET_MAC80211_DEV - set device for 802.11 hardware
  *
- * @hw: the &struct ieee80211_hw to set the device for
+ * @hw: the &struct mac80211_hw to set the device for
  * @dev: the &struct device of this 802.11 device
  */
-static inline void SET_IEEE80211_DEV(struct ieee80211_hw *hw, struct device *dev)
+static inline void SET_MAC80211_DEV(struct mac80211_hw *hw, struct device *dev)
 {
 	set_wiphy_dev(hw->wiphy, dev);
 }
 
 /**
- * SET_IEEE80211_PERM_ADDR - set the permanent MAC address for 802.11 hardware
+ * SET_MAC80211_PERM_ADDR - set the permanent MAC address for 802.11 hardware
  *
- * @hw: the &struct ieee80211_hw to set the MAC address for
+ * @hw: the &struct mac80211_hw to set the MAC address for
  * @addr: the address to set
  */
-static inline void SET_IEEE80211_PERM_ADDR(struct ieee80211_hw *hw, u8 *addr)
+static inline void SET_MAC80211_PERM_ADDR(struct mac80211_hw *hw, u8 *addr)
 {
 	memcpy(hw->wiphy->perm_addr, addr, ETH_ALEN);
 }
 
 static inline struct ieee80211_rate *
-ieee80211_get_tx_rate(const struct ieee80211_hw *hw,
-		      const struct ieee80211_tx_info *c)
+mac80211_get_tx_rate(const struct mac80211_hw *hw,
+		      const struct mac80211_tx_info *c)
 {
 	if (WARN_ON(c->control.rates[0].idx < 0))
 		return NULL;
@@ -1253,8 +1255,8 @@ ieee80211_get_tx_rate(const struct ieee80211_hw *hw,
 }
 
 static inline struct ieee80211_rate *
-ieee80211_get_rts_cts_rate(const struct ieee80211_hw *hw,
-			   const struct ieee80211_tx_info *c)
+mac80211_get_rts_cts_rate(const struct mac80211_hw *hw,
+			   const struct mac80211_tx_info *c)
 {
 	if (c->control.rts_cts_rate_idx < 0)
 		return NULL;
@@ -1262,8 +1264,8 @@ ieee80211_get_rts_cts_rate(const struct ieee80211_hw *hw,
 }
 
 static inline struct ieee80211_rate *
-ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
-			     const struct ieee80211_tx_info *c, int idx)
+mac80211_get_alt_retry_rate(const struct mac80211_hw *hw,
+			     const struct mac80211_tx_info *c, int idx)
 {
 	if (c->control.rates[idx + 1].idx < 0)
 		return NULL;
@@ -1276,7 +1278,7 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  * mac80211 is capable of taking advantage of many hardware
  * acceleration designs for encryption and decryption operations.
  *
- * The set_key() callback in the &struct ieee80211_ops for a given
+ * The set_key() callback in the &struct mac80211_ops for a given
  * device is called to enable hardware acceleration of encryption and
  * decryption. The callback takes a @sta parameter that will be NULL
  * for default keys or keys used for transmission only, or point to
@@ -1285,7 +1287,7 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  * VLANs are configured for an access point.
  *
  * When transmitting, the TX control data will use the @hw_key_idx
- * selected by the driver by modifying the &struct ieee80211_key_conf
+ * selected by the driver by modifying the &struct mac80211_key_conf
  * pointed to by the @key parameter to the set_key() function.
  *
  * The set_key() call for the %SET_KEY command should return 0 if
@@ -1300,7 +1302,7 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  * decision based on whether a key has been uploaded or not but rather
  * based on the receive flags.
  *
- * The &struct ieee80211_key_conf structure pointed to by the @key
+ * The &struct mac80211_key_conf structure pointed to by the @key
  * parameter is guaranteed to be valid until another call to set_key()
  * removes it, but it can only be used as a cookie to differentiate
  * keys.
@@ -1322,15 +1324,15 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  * mac80211 has support for various powersave implementations.
  *
  * First, it can support hardware that handles all powersaving by itself,
- * such hardware should simply set the %IEEE80211_HW_SUPPORTS_PS hardware
+ * such hardware should simply set the %MAC80211_HW_SUPPORTS_PS hardware
  * flag. In that case, it will be told about the desired powersave mode
- * with the %IEEE80211_CONF_PS flag depending on the association status.
+ * with the %MAC80211_CONF_PS flag depending on the association status.
  * The hardware must take care of sending nullfunc frames when necessary,
  * i.e. when entering and leaving powersave mode. The hardware is required
  * to look at the AID in beacons and signal to the AP that it woke up when
  * it finds traffic directed to it.
  *
- * %IEEE80211_CONF_PS flag enabled means that the powersave mode defined in
+ * %MAC80211_CONF_PS flag enabled means that the powersave mode defined in
  * IEEE 802.11-2007 section 11.2 is enabled. This is not to be confused
  * with hardware wakeup and sleep states. Driver is responsible for waking
  * up the hardware before issuing commands to the hardware and putting it
@@ -1342,8 +1344,8 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  *
  * Other hardware designs cannot send nullfunc frames by themselves and also
  * need software support for parsing the TIM bitmap. This is also supported
- * by mac80211 by combining the %IEEE80211_HW_SUPPORTS_PS and
- * %IEEE80211_HW_PS_NULLFUNC_STACK flags. The hardware is of course still
+ * by mac80211 by combining the %MAC80211_HW_SUPPORTS_PS and
+ * %MAC80211_HW_PS_NULLFUNC_STACK flags. The hardware is of course still
  * required to pass up beacons. The hardware is still required to handle
  * waking up for multicast traffic; if it cannot the driver must handle that
  * as best as it can, mac80211 is too slow to do that.
@@ -1356,14 +1358,14 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  * periods.
  *
  * Dynamic powersave is simply supported by mac80211 enabling and disabling
- * PS based on traffic. Driver needs to only set %IEEE80211_HW_SUPPORTS_PS
+ * PS based on traffic. Driver needs to only set %MAC80211_HW_SUPPORTS_PS
  * flag and mac80211 will handle everything automatically. Additionally,
  * hardware having support for the dynamic PS feature may set the
- * %IEEE80211_HW_SUPPORTS_DYNAMIC_PS flag to indicate that it can support
+ * %MAC80211_HW_SUPPORTS_DYNAMIC_PS flag to indicate that it can support
  * dynamic PS mode itself. The driver needs to look at the
  * @dynamic_ps_timeout hardware configuration value and use it that value
- * whenever %IEEE80211_CONF_PS is set. In this case mac80211 will disable
- * dynamic PS feature in stack and will just keep %IEEE80211_CONF_PS
+ * whenever %MAC80211_CONF_PS is set. In this case mac80211 will disable
+ * dynamic PS feature in stack and will just keep %MAC80211_CONF_PS
  * enabled whenever user has enabled powersave.
  *
  * Some hardware need to toggle a single shared antenna between WLAN and
@@ -1376,14 +1378,14 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  * temporarily set to zero until the driver re-enables dynamic powersave.
  *
  * Driver informs U-APSD client support by enabling
- * %IEEE80211_HW_SUPPORTS_UAPSD flag. The mode is configured through the
+ * %MAC80211_HW_SUPPORTS_UAPSD flag. The mode is configured through the
  * uapsd paramater in conf_tx() operation. Hardware needs to send the QoS
  * Nullfunc frames and stay awake until the service period has ended. To
  * utilize U-APSD, dynamic powersave is disabled for voip AC and all frames
  * from that AC are transmitted with powersave enabled.
  *
  * Note: U-APSD client mode is not yet supported with
- * %IEEE80211_HW_PS_NULLFUNC_STACK.
+ * %MAC80211_HW_PS_NULLFUNC_STACK.
  */
 
 /**
@@ -1397,15 +1399,15 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  * way the host will only receive beacons where some relevant information
  * (for example ERP protection or WMM settings) have changed.
  *
- * Beacon filter support is advertised with the %IEEE80211_HW_BEACON_FILTER
+ * Beacon filter support is advertised with the %MAC80211_HW_BEACON_FILTER
  * hardware capability. The driver needs to enable beacon filter support
- * whenever power save is enabled, that is %IEEE80211_CONF_PS is set. When
+ * whenever power save is enabled, that is %MAC80211_CONF_PS is set. When
  * power save is enabled, the stack will not check for beacon loss and the
- * driver needs to notify about loss of beacons with ieee80211_beacon_loss().
+ * driver needs to notify about loss of beacons with mac80211_beacon_loss().
  *
  * The time (or number of beacons missed) until the firmware notifies the
  * driver of a beacon loss event (which in turn causes the driver to call
- * ieee80211_beacon_loss()) should be configurable and will be controlled
+ * mac80211_beacon_loss()) should be configurable and will be controlled
  * by mac80211 and the roaming algorithm in the future.
  *
  * Since there may be constantly changing information elements that nothing
@@ -1512,7 +1514,7 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  */
 
 /**
- * enum ieee80211_filter_flags - hardware filter flags
+ * enum mac80211_filter_flags - hardware filter flags
  *
  * These flags determine what the filter in hardware should be
  * programmed to let through and what should not be passed to the
@@ -1549,7 +1551,7 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  *
  * @FIF_PROBE_REQ: pass probe request frames
  */
-enum ieee80211_filter_flags {
+enum mac80211_filter_flags {
 	FIF_PROMISC_IN_BSS	= 1<<0,
 	FIF_ALLMULTI		= 1<<1,
 	FIF_FCSFAIL		= 1<<2,
@@ -1562,32 +1564,32 @@ enum ieee80211_filter_flags {
 };
 
 /**
- * enum ieee80211_ampdu_mlme_action - A-MPDU actions
+ * enum mac80211_ampdu_mlme_action - A-MPDU actions
  *
  * These flags are used with the ampdu_action() callback in
- * &struct ieee80211_ops to indicate which action is needed.
+ * &struct mac80211_ops to indicate which action is needed.
  *
  * Note that drivers MUST be able to deal with a TX aggregation
  * session being stopped even before they OK'ed starting it by
- * calling ieee80211_start_tx_ba_cb_irqsafe, because the peer
+ * calling mac80211_start_tx_ba_cb_irqsafe, because the peer
  * might receive the addBA frame and send a delBA right away!
  *
- * @IEEE80211_AMPDU_RX_START: start Rx aggregation
- * @IEEE80211_AMPDU_RX_STOP: stop Rx aggregation
- * @IEEE80211_AMPDU_TX_START: start Tx aggregation
- * @IEEE80211_AMPDU_TX_STOP: stop Tx aggregation
- * @IEEE80211_AMPDU_TX_OPERATIONAL: TX aggregation has become operational
- */
-enum ieee80211_ampdu_mlme_action {
-	IEEE80211_AMPDU_RX_START,
-	IEEE80211_AMPDU_RX_STOP,
-	IEEE80211_AMPDU_TX_START,
-	IEEE80211_AMPDU_TX_STOP,
-	IEEE80211_AMPDU_TX_OPERATIONAL,
+ * @MAC80211_AMPDU_RX_START: start Rx aggregation
+ * @MAC80211_AMPDU_RX_STOP: stop Rx aggregation
+ * @MAC80211_AMPDU_TX_START: start Tx aggregation
+ * @MAC80211_AMPDU_TX_STOP: stop Tx aggregation
+ * @MAC80211_AMPDU_TX_OPERATIONAL: TX aggregation has become operational
+ */
+enum mac80211_ampdu_mlme_action {
+	MAC80211_AMPDU_RX_START,
+	MAC80211_AMPDU_RX_STOP,
+	MAC80211_AMPDU_TX_START,
+	MAC80211_AMPDU_TX_STOP,
+	MAC80211_AMPDU_TX_OPERATIONAL,
 };
 
 /**
- * struct ieee80211_ops - callbacks from mac80211 to the driver
+ * struct mac80211_ops - callbacks from mac80211 to the driver
  *
  * This structure contains various callbacks that the driver may
  * handle or, in some cases, must handle, for example to configure
@@ -1691,7 +1693,7 @@ enum ieee80211_ampdu_mlme_action {
  *
  * @update_tkip_key: See the section "Hardware crypto acceleration"
  * 	This callback will be called in the context of Rx. Called for drivers
- * 	which set IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY.
+ * 	which set MAC80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY.
  *	The callback must be atomic.
  *
  * @hw_scan: Ask the hardware to service the scan request, no need to start
@@ -1703,14 +1705,14 @@ enum ieee80211_ampdu_mlme_action {
  *	entire IEs after the SSID, so that drivers need not look at these
  *	at all but just send them after the SSID -- mac80211 includes the
  *	(extended) supported rates and HT information (where applicable).
- *	When the scan finishes, ieee80211_scan_completed() must be called;
+ *	When the scan finishes, mac80211_scan_completed() must be called;
  *	note that it also must be called when the scan cannot finish due to
  *	any error unless this callback returned a negative error code.
  *	The callback can sleep.
  *
  * @sched_scan_start: Ask the hardware to start scanning repeatedly at
  *	specific intervals.  The driver must call the
- *	ieee80211_sched_scan_results() function whenever it finds results.
+ *	mac80211_sched_scan_results() function whenever it finds results.
  *	This process will continue until sched_scan_stop is called.
  *
  * @sched_scan_stop: Tell the hardware to stop an ongoing scheduled scan.
@@ -1750,7 +1752,7 @@ enum ieee80211_ampdu_mlme_action {
  * @sta_notify: Notifies low level driver about power state transition of an
  *	associated station, AP,  IBSS/WDS/mesh peer etc. For a VIF operating
  *	in AP mode, this callback will not be called when the flag
- *	%IEEE80211_HW_AP_LINK_PS is set. Must be atomic.
+ *	%MAC80211_HW_AP_LINK_PS is set. Must be atomic.
  *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
  *	bursting) for a hardware TX queue.
@@ -1782,11 +1784,11 @@ enum ieee80211_ampdu_mlme_action {
  * @ampdu_action: Perform a certain A-MPDU action
  * 	The RA/TID combination determines the destination and TID we want
  * 	the ampdu action to be performed for. The action is defined through
- * 	ieee80211_ampdu_mlme_action. Starting sequence number (@ssn)
+ * 	mac80211_ampdu_mlme_action. Starting sequence number (@ssn)
  * 	is the first frame we expect to perform the action on. Notice
  * 	that TX/RX_STOP can pass NULL for this parameter.
  *	The @buf_size parameter is only valid when the action is set to
- *	%IEEE80211_AMPDU_TX_OPERATIONAL and indicates the peer's reorder
+ *	%MAC80211_AMPDU_TX_OPERATIONAL and indicates the peer's reorder
  *	buffer size (number of subframes) for this session -- the driver
  *	may neither send aggregates containing more subframes than this
  *	nor send aggregates in a way that lost frames would exceed the
@@ -1824,7 +1826,7 @@ enum ieee80211_ampdu_mlme_action {
  *
  * @channel_switch: Drivers that need (or want) to offload the channel
  *	switch operation for CSAs received from the AP may implement this
- *	callback. They must then call ieee80211_chswitch_done() to indicate
+ *	callback. They must then call mac80211_chswitch_done() to indicate
  *	completion of the channel switch.
  *
  * @napi_poll: Poll Rx queue for incoming data frames.
@@ -1837,12 +1839,12 @@ enum ieee80211_ampdu_mlme_action {
  * @get_antenna: Get current antenna configuration from device (tx_ant, rx_ant).
  *
  * @remain_on_channel: Starts an off-channel period on the given channel, must
- *	call back to ieee80211_ready_on_channel() when on that channel. Note
+ *	call back to mac80211_ready_on_channel() when on that channel. Note
  *	that normal channel traffic is not stopped as this is intended for hw
  *	offload. Frames to transmit on the off-channel channel are transmitted
- *	normally except for the %IEEE80211_TX_CTL_TX_OFFCHAN flag. When the
+ *	normally except for the %MAC80211_TX_CTL_TX_OFFCHAN flag. When the
  *	duration (which will always be non-zero) expires, the driver must call
- *	ieee80211_remain_on_channel_expired(). This callback may sleep.
+ *	mac80211_remain_on_channel_expired(). This callback may sleep.
  * @cancel_remain_on_channel: Requests that an ongoing off-channel period is
  *	aborted before it expires. This callback may sleep.
  * @offchannel_tx: Transmit frame on another channel, wait for a response
@@ -1862,172 +1864,172 @@ enum ieee80211_ampdu_mlme_action {
  *	when transmitting a frame. Currently only legacy rates are handled.
  *	The callback can sleep.
  */
-struct ieee80211_ops {
-	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
-	int (*start)(struct ieee80211_hw *hw);
-	void (*stop)(struct ieee80211_hw *hw);
+struct mac80211_ops {
+	void (*tx)(struct mac80211_hw *hw, struct sk_buff *skb);
+	int (*start)(struct mac80211_hw *hw);
+	void (*stop)(struct mac80211_hw *hw);
 #ifdef CONFIG_PM
-	int (*suspend)(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan);
-	int (*resume)(struct ieee80211_hw *hw);
+	int (*suspend)(struct mac80211_hw *hw, struct cfg80211_wowlan *wowlan);
+	int (*resume)(struct mac80211_hw *hw);
 #endif
-	int (*add_interface)(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif);
-	int (*change_interface)(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif,
+	int (*add_interface)(struct mac80211_hw *hw,
+			     struct mac80211_vif *vif);
+	int (*change_interface)(struct mac80211_hw *hw,
+				struct mac80211_vif *vif,
 				enum nl80211_iftype new_type, bool p2p);
-	void (*remove_interface)(struct ieee80211_hw *hw,
-				 struct ieee80211_vif *vif);
-	int (*config)(struct ieee80211_hw *hw, u32 changed);
-	void (*bss_info_changed)(struct ieee80211_hw *hw,
-				 struct ieee80211_vif *vif,
-				 struct ieee80211_bss_conf *info,
+	void (*remove_interface)(struct mac80211_hw *hw,
+				 struct mac80211_vif *vif);
+	int (*config)(struct mac80211_hw *hw, u32 changed);
+	void (*bss_info_changed)(struct mac80211_hw *hw,
+				 struct mac80211_vif *vif,
+				 struct mac80211_bss_conf *info,
 				 u32 changed);
-	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
+	u64 (*prepare_multicast)(struct mac80211_hw *hw,
 				 struct netdev_hw_addr_list *mc_list);
-	void (*configure_filter)(struct ieee80211_hw *hw,
+	void (*configure_filter)(struct mac80211_hw *hw,
 				 unsigned int changed_flags,
 				 unsigned int *total_flags,
 				 u64 multicast);
-	int (*set_tim)(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+	int (*set_tim)(struct mac80211_hw *hw, struct mac80211_sta *sta,
 		       bool set);
-	int (*set_key)(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-		       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
-		       struct ieee80211_key_conf *key);
-	void (*update_tkip_key)(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif,
-				struct ieee80211_key_conf *conf,
-				struct ieee80211_sta *sta,
+	int (*set_key)(struct mac80211_hw *hw, enum set_key_cmd cmd,
+		       struct mac80211_vif *vif, struct mac80211_sta *sta,
+		       struct mac80211_key_conf *key);
+	void (*update_tkip_key)(struct mac80211_hw *hw,
+				struct mac80211_vif *vif,
+				struct mac80211_key_conf *conf,
+				struct mac80211_sta *sta,
 				u32 iv32, u16 *phase1key);
-	int (*hw_scan)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+	int (*hw_scan)(struct mac80211_hw *hw, struct mac80211_vif *vif,
 		       struct cfg80211_scan_request *req);
-	int (*sched_scan_start)(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif,
+	int (*sched_scan_start)(struct mac80211_hw *hw,
+				struct mac80211_vif *vif,
 				struct cfg80211_sched_scan_request *req,
-				struct ieee80211_sched_scan_ies *ies);
-	void (*sched_scan_stop)(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif);
-	void (*sw_scan_start)(struct ieee80211_hw *hw);
-	void (*sw_scan_complete)(struct ieee80211_hw *hw);
-	int (*get_stats)(struct ieee80211_hw *hw,
-			 struct ieee80211_low_level_stats *stats);
-	void (*get_tkip_seq)(struct ieee80211_hw *hw, u8 hw_key_idx,
+				struct mac80211_sched_scan_ies *ies);
+	void (*sched_scan_stop)(struct mac80211_hw *hw,
+			       struct mac80211_vif *vif);
+	void (*sw_scan_start)(struct mac80211_hw *hw);
+	void (*sw_scan_complete)(struct mac80211_hw *hw);
+	int (*get_stats)(struct mac80211_hw *hw,
+			 struct mac80211_low_level_stats *stats);
+	void (*get_tkip_seq)(struct mac80211_hw *hw, u8 hw_key_idx,
 			     u32 *iv32, u16 *iv16);
-	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
-	int (*set_rts_threshold)(struct ieee80211_hw *hw, u32 value);
-	int (*sta_add)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		       struct ieee80211_sta *sta);
-	int (*sta_remove)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			  struct ieee80211_sta *sta);
-	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			enum sta_notify_cmd, struct ieee80211_sta *sta);
-	int (*conf_tx)(struct ieee80211_hw *hw, u16 queue,
-		       const struct ieee80211_tx_queue_params *params);
-	u64 (*get_tsf)(struct ieee80211_hw *hw);
-	void (*set_tsf)(struct ieee80211_hw *hw, u64 tsf);
-	void (*reset_tsf)(struct ieee80211_hw *hw);
-	int (*tx_last_beacon)(struct ieee80211_hw *hw);
-	int (*ampdu_action)(struct ieee80211_hw *hw,
-			    struct ieee80211_vif *vif,
-			    enum ieee80211_ampdu_mlme_action action,
-			    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+	int (*set_frag_threshold)(struct mac80211_hw *hw, u32 value);
+	int (*set_rts_threshold)(struct mac80211_hw *hw, u32 value);
+	int (*sta_add)(struct mac80211_hw *hw, struct mac80211_vif *vif,
+		       struct mac80211_sta *sta);
+	int (*sta_remove)(struct mac80211_hw *hw, struct mac80211_vif *vif,
+			  struct mac80211_sta *sta);
+	void (*sta_notify)(struct mac80211_hw *hw, struct mac80211_vif *vif,
+			enum sta_notify_cmd, struct mac80211_sta *sta);
+	int (*conf_tx)(struct mac80211_hw *hw, u16 queue,
+		       const struct mac80211_tx_queue_params *params);
+	u64 (*get_tsf)(struct mac80211_hw *hw);
+	void (*set_tsf)(struct mac80211_hw *hw, u64 tsf);
+	void (*reset_tsf)(struct mac80211_hw *hw);
+	int (*tx_last_beacon)(struct mac80211_hw *hw);
+	int (*ampdu_action)(struct mac80211_hw *hw,
+			    struct mac80211_vif *vif,
+			    enum mac80211_ampdu_mlme_action action,
+			    struct mac80211_sta *sta, u16 tid, u16 *ssn,
 			    u8 buf_size);
-	int (*get_survey)(struct ieee80211_hw *hw, int idx,
+	int (*get_survey)(struct mac80211_hw *hw, int idx,
 		struct survey_info *survey);
-	void (*rfkill_poll)(struct ieee80211_hw *hw);
-	void (*set_coverage_class)(struct ieee80211_hw *hw, u8 coverage_class);
+	void (*rfkill_poll)(struct mac80211_hw *hw);
+	void (*set_coverage_class)(struct mac80211_hw *hw, u8 coverage_class);
 #ifdef CONFIG_NL80211_TESTMODE
-	int (*testmode_cmd)(struct ieee80211_hw *hw, void *data, int len);
-	int (*testmode_dump)(struct ieee80211_hw *hw, struct sk_buff *skb,
+	int (*testmode_cmd)(struct mac80211_hw *hw, void *data, int len);
+	int (*testmode_dump)(struct mac80211_hw *hw, struct sk_buff *skb,
 			     struct netlink_callback *cb,
 			     void *data, int len);
 #endif
-	void (*flush)(struct ieee80211_hw *hw, bool drop);
-	void (*channel_switch)(struct ieee80211_hw *hw,
-			       struct ieee80211_channel_switch *ch_switch);
-	int (*napi_poll)(struct ieee80211_hw *hw, int budget);
-	int (*set_antenna)(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant);
-	int (*get_antenna)(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant);
-
-	int (*remain_on_channel)(struct ieee80211_hw *hw,
+	void (*flush)(struct mac80211_hw *hw, bool drop);
+	void (*channel_switch)(struct mac80211_hw *hw,
+			       struct mac80211_channel_switch *ch_switch);
+	int (*napi_poll)(struct mac80211_hw *hw, int budget);
+	int (*set_antenna)(struct mac80211_hw *hw, u32 tx_ant, u32 rx_ant);
+	int (*get_antenna)(struct mac80211_hw *hw, u32 *tx_ant, u32 *rx_ant);
+
+	int (*remain_on_channel)(struct mac80211_hw *hw,
 				 struct ieee80211_channel *chan,
 				 enum nl80211_channel_type channel_type,
 				 int duration);
-	int (*cancel_remain_on_channel)(struct ieee80211_hw *hw);
-	int (*offchannel_tx)(struct ieee80211_hw *hw, struct sk_buff *skb,
+	int (*cancel_remain_on_channel)(struct mac80211_hw *hw);
+	int (*offchannel_tx)(struct mac80211_hw *hw, struct sk_buff *skb,
 			     struct ieee80211_channel *chan,
 			     enum nl80211_channel_type channel_type,
 			     unsigned int wait);
-	int (*offchannel_tx_cancel_wait)(struct ieee80211_hw *hw);
-	int (*set_ringparam)(struct ieee80211_hw *hw, u32 tx, u32 rx);
-	void (*get_ringparam)(struct ieee80211_hw *hw,
+	int (*offchannel_tx_cancel_wait)(struct mac80211_hw *hw);
+	int (*set_ringparam)(struct mac80211_hw *hw, u32 tx, u32 rx);
+	void (*get_ringparam)(struct mac80211_hw *hw,
 			      u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max);
-	bool (*tx_frames_pending)(struct ieee80211_hw *hw);
-	int (*set_bitrate_mask)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+	bool (*tx_frames_pending)(struct mac80211_hw *hw);
+	int (*set_bitrate_mask)(struct mac80211_hw *hw, struct mac80211_vif *vif,
 				const struct cfg80211_bitrate_mask *mask);
 };
 
 /**
- * ieee80211_alloc_hw -  Allocate a new hardware device
+ * mac80211_alloc_hw -  Allocate a new hardware device
  *
  * This must be called once for each hardware device. The returned pointer
  * must be used to refer to this device when calling other functions.
  * mac80211 allocates a private data area for the driver pointed to by
- * @priv in &struct ieee80211_hw, the size of this area is given as
+ * @priv in &struct mac80211_hw, the size of this area is given as
  * @priv_data_len.
  *
  * @priv_data_len: length of private data
  * @ops: callbacks for this device
  */
-struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
-					const struct ieee80211_ops *ops);
+struct mac80211_hw *mac80211_alloc_hw(size_t priv_data_len,
+					const struct mac80211_ops *ops);
 
 /**
- * ieee80211_register_hw - Register hardware device
+ * mac80211_register_hw - Register hardware device
  *
  * You must call this function before any other functions in
  * mac80211. Note that before a hardware can be registered, you
  * need to fill the contained wiphy's information.
  *
- * @hw: the device to register as returned by ieee80211_alloc_hw()
+ * @hw: the device to register as returned by mac80211_alloc_hw()
  */
-int ieee80211_register_hw(struct ieee80211_hw *hw);
+int mac80211_register_hw(struct mac80211_hw *hw);
 
 /**
- * struct ieee80211_tpt_blink - throughput blink description
+ * struct mac80211_tpt_blink - throughput blink description
  * @throughput: throughput in Kbit/sec
  * @blink_time: blink time in milliseconds
  *	(full cycle, ie. one off + one on period)
  */
-struct ieee80211_tpt_blink {
+struct mac80211_tpt_blink {
 	int throughput;
 	int blink_time;
 };
 
 /**
- * enum ieee80211_tpt_led_trigger_flags - throughput trigger flags
- * @IEEE80211_TPT_LEDTRIG_FL_RADIO: enable blinking with radio
- * @IEEE80211_TPT_LEDTRIG_FL_WORK: enable blinking when working
- * @IEEE80211_TPT_LEDTRIG_FL_CONNECTED: enable blinking when at least one
+ * enum mac80211_tpt_led_trigger_flags - throughput trigger flags
+ * @MAC80211_TPT_LEDTRIG_FL_RADIO: enable blinking with radio
+ * @MAC80211_TPT_LEDTRIG_FL_WORK: enable blinking when working
+ * @MAC80211_TPT_LEDTRIG_FL_CONNECTED: enable blinking when at least one
  *	interface is connected in some way, including being an AP
  */
-enum ieee80211_tpt_led_trigger_flags {
-	IEEE80211_TPT_LEDTRIG_FL_RADIO		= BIT(0),
-	IEEE80211_TPT_LEDTRIG_FL_WORK		= BIT(1),
-	IEEE80211_TPT_LEDTRIG_FL_CONNECTED	= BIT(2),
+enum mac80211_tpt_led_trigger_flags {
+	MAC80211_TPT_LEDTRIG_FL_RADIO		= BIT(0),
+	MAC80211_TPT_LEDTRIG_FL_WORK		= BIT(1),
+	MAC80211_TPT_LEDTRIG_FL_CONNECTED	= BIT(2),
 };
 
 #ifdef CONFIG_MAC80211_LEDS
-extern char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw);
-extern char *__ieee80211_get_rx_led_name(struct ieee80211_hw *hw);
-extern char *__ieee80211_get_assoc_led_name(struct ieee80211_hw *hw);
-extern char *__ieee80211_get_radio_led_name(struct ieee80211_hw *hw);
-extern char *__ieee80211_create_tpt_led_trigger(
-				struct ieee80211_hw *hw, unsigned int flags,
-				const struct ieee80211_tpt_blink *blink_table,
+extern char *__mac80211_get_tx_led_name(struct mac80211_hw *hw);
+extern char *__mac80211_get_rx_led_name(struct mac80211_hw *hw);
+extern char *__mac80211_get_assoc_led_name(struct mac80211_hw *hw);
+extern char *__mac80211_get_radio_led_name(struct mac80211_hw *hw);
+extern char *__mac80211_create_tpt_led_trigger(
+				struct mac80211_hw *hw, unsigned int flags,
+				const struct mac80211_tpt_blink *blink_table,
 				unsigned int blink_table_len);
 #endif
 /**
- * ieee80211_get_tx_led_name - get name of TX LED
+ * mac80211_get_tx_led_name - get name of TX LED
  *
  * mac80211 creates a transmit LED trigger for each wireless hardware
  * that can be used to drive LEDs if your driver registers a LED device.
@@ -2036,17 +2038,17 @@ extern char *__ieee80211_create_tpt_led_trigger(
  *
  * @hw: the hardware to get the LED trigger name for
  */
-static inline char *ieee80211_get_tx_led_name(struct ieee80211_hw *hw)
+static inline char *mac80211_get_tx_led_name(struct mac80211_hw *hw)
 {
 #ifdef CONFIG_MAC80211_LEDS
-	return __ieee80211_get_tx_led_name(hw);
+	return __mac80211_get_tx_led_name(hw);
 #else
 	return NULL;
 #endif
 }
 
 /**
- * ieee80211_get_rx_led_name - get name of RX LED
+ * mac80211_get_rx_led_name - get name of RX LED
  *
  * mac80211 creates a receive LED trigger for each wireless hardware
  * that can be used to drive LEDs if your driver registers a LED device.
@@ -2055,17 +2057,17 @@ static inline char *ieee80211_get_tx_led_name(struct ieee80211_hw *hw)
  *
  * @hw: the hardware to get the LED trigger name for
  */
-static inline char *ieee80211_get_rx_led_name(struct ieee80211_hw *hw)
+static inline char *mac80211_get_rx_led_name(struct mac80211_hw *hw)
 {
 #ifdef CONFIG_MAC80211_LEDS
-	return __ieee80211_get_rx_led_name(hw);
+	return __mac80211_get_rx_led_name(hw);
 #else
 	return NULL;
 #endif
 }
 
 /**
- * ieee80211_get_assoc_led_name - get name of association LED
+ * mac80211_get_assoc_led_name - get name of association LED
  *
  * mac80211 creates a association LED trigger for each wireless hardware
  * that can be used to drive LEDs if your driver registers a LED device.
@@ -2074,17 +2076,17 @@ static inline char *ieee80211_get_rx_led_name(struct ieee80211_hw *hw)
  *
  * @hw: the hardware to get the LED trigger name for
  */
-static inline char *ieee80211_get_assoc_led_name(struct ieee80211_hw *hw)
+static inline char *mac80211_get_assoc_led_name(struct mac80211_hw *hw)
 {
 #ifdef CONFIG_MAC80211_LEDS
-	return __ieee80211_get_assoc_led_name(hw);
+	return __mac80211_get_assoc_led_name(hw);
 #else
 	return NULL;
 #endif
 }
 
 /**
- * ieee80211_get_radio_led_name - get name of radio LED
+ * mac80211_get_radio_led_name - get name of radio LED
  *
  * mac80211 creates a radio change LED trigger for each wireless hardware
  * that can be used to drive LEDs if your driver registers a LED device.
@@ -2093,33 +2095,33 @@ static inline char *ieee80211_get_assoc_led_name(struct ieee80211_hw *hw)
  *
  * @hw: the hardware to get the LED trigger name for
  */
-static inline char *ieee80211_get_radio_led_name(struct ieee80211_hw *hw)
+static inline char *mac80211_get_radio_led_name(struct mac80211_hw *hw)
 {
 #ifdef CONFIG_MAC80211_LEDS
-	return __ieee80211_get_radio_led_name(hw);
+	return __mac80211_get_radio_led_name(hw);
 #else
 	return NULL;
 #endif
 }
 
 /**
- * ieee80211_create_tpt_led_trigger - create throughput LED trigger
+ * mac80211_create_tpt_led_trigger - create throughput LED trigger
  * @hw: the hardware to create the trigger for
- * @flags: trigger flags, see &enum ieee80211_tpt_led_trigger_flags
+ * @flags: trigger flags, see &enum mac80211_tpt_led_trigger_flags
  * @blink_table: the blink table -- needs to be ordered by throughput
  * @blink_table_len: size of the blink table
  *
  * This function returns %NULL (in case of error, or if no LED
  * triggers are configured) or the name of the new trigger.
- * This function must be called before ieee80211_register_hw().
+ * This function must be called before mac80211_register_hw().
  */
 static inline char *
-ieee80211_create_tpt_led_trigger(struct ieee80211_hw *hw, unsigned int flags,
-				 const struct ieee80211_tpt_blink *blink_table,
+mac80211_create_tpt_led_trigger(struct mac80211_hw *hw, unsigned int flags,
+				 const struct mac80211_tpt_blink *blink_table,
 				 unsigned int blink_table_len)
 {
 #ifdef CONFIG_MAC80211_LEDS
-	return __ieee80211_create_tpt_led_trigger(hw, flags, blink_table,
+	return __mac80211_create_tpt_led_trigger(hw, flags, blink_table,
 						  blink_table_len);
 #else
 	return NULL;
@@ -2127,28 +2129,28 @@ ieee80211_create_tpt_led_trigger(struct ieee80211_hw *hw, unsigned int flags,
 }
 
 /**
- * ieee80211_unregister_hw - Unregister a hardware device
+ * mac80211_unregister_hw - Unregister a hardware device
  *
  * This function instructs mac80211 to free allocated resources
  * and unregister netdevices from the networking subsystem.
  *
  * @hw: the hardware to unregister
  */
-void ieee80211_unregister_hw(struct ieee80211_hw *hw);
+void mac80211_unregister_hw(struct mac80211_hw *hw);
 
 /**
- * ieee80211_free_hw - free hardware descriptor
+ * mac80211_free_hw - free hardware descriptor
  *
  * This function frees everything that was allocated, including the
- * private data for the driver. You must call ieee80211_unregister_hw()
+ * private data for the driver. You must call mac80211_unregister_hw()
  * before calling this function.
  *
  * @hw: the hardware to free
  */
-void ieee80211_free_hw(struct ieee80211_hw *hw);
+void mac80211_free_hw(struct mac80211_hw *hw);
 
 /**
- * ieee80211_restart_hw - restart hardware completely
+ * mac80211_restart_hw - restart hardware completely
  *
  * Call this function when the hardware was restarted for some reason
  * (hardware error, ...) and the driver is unable to restore its state
@@ -2159,83 +2161,83 @@ void ieee80211_free_hw(struct ieee80211_hw *hw);
  *
  * @hw: the hardware to restart
  */
-void ieee80211_restart_hw(struct ieee80211_hw *hw);
+void mac80211_restart_hw(struct mac80211_hw *hw);
 
-/** ieee80211_napi_schedule - schedule NAPI poll
+/** mac80211_napi_schedule - schedule NAPI poll
  *
  * Use this function to schedule NAPI polling on a device.
  *
  * @hw: the hardware to start polling
  */
-void ieee80211_napi_schedule(struct ieee80211_hw *hw);
+void mac80211_napi_schedule(struct mac80211_hw *hw);
 
-/** ieee80211_napi_complete - complete NAPI polling
+/** mac80211_napi_complete - complete NAPI polling
  *
  * Use this function to finish NAPI polling on a device.
  *
  * @hw: the hardware to stop polling
  */
-void ieee80211_napi_complete(struct ieee80211_hw *hw);
+void mac80211_napi_complete(struct mac80211_hw *hw);
 
 /**
- * ieee80211_rx - receive frame
+ * mac80211_rx - receive frame
  *
  * Use this function to hand received frames to mac80211. The receive
  * buffer in @skb must start with an IEEE 802.11 header. In case of a
- * paged @skb is used, the driver is recommended to put the ieee80211
+ * paged @skb is used, the driver is recommended to put the mac80211
  * header of the frame on the linear part of the @skb to avoid memory
  * allocation and/or memcpy by the stack.
  *
  * This function may not be called in IRQ context. Calls to this function
  * for a single hardware must be synchronized against each other. Calls to
- * this function, ieee80211_rx_ni() and ieee80211_rx_irqsafe() may not be
+ * this function, mac80211_rx_ni() and mac80211_rx_irqsafe() may not be
  * mixed for a single hardware.
  *
- * In process context use instead ieee80211_rx_ni().
+ * In process context use instead mac80211_rx_ni().
  *
  * @hw: the hardware this frame came in on
  * @skb: the buffer to receive, owned by mac80211 after this call
  */
-void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb);
+void mac80211_rx(struct mac80211_hw *hw, struct sk_buff *skb);
 
 /**
- * ieee80211_rx_irqsafe - receive frame
+ * mac80211_rx_irqsafe - receive frame
  *
- * Like ieee80211_rx() but can be called in IRQ context
+ * Like mac80211_rx() but can be called in IRQ context
  * (internally defers to a tasklet.)
  *
- * Calls to this function, ieee80211_rx() or ieee80211_rx_ni() may not
+ * Calls to this function, mac80211_rx() or mac80211_rx_ni() may not
  * be mixed for a single hardware.
  *
  * @hw: the hardware this frame came in on
  * @skb: the buffer to receive, owned by mac80211 after this call
  */
-void ieee80211_rx_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb);
+void mac80211_rx_irqsafe(struct mac80211_hw *hw, struct sk_buff *skb);
 
 /**
- * ieee80211_rx_ni - receive frame (in process context)
+ * mac80211_rx_ni - receive frame (in process context)
  *
- * Like ieee80211_rx() but can be called in process context
+ * Like mac80211_rx() but can be called in process context
  * (internally disables bottom halves).
  *
- * Calls to this function, ieee80211_rx() and ieee80211_rx_irqsafe() may
+ * Calls to this function, mac80211_rx() and mac80211_rx_irqsafe() may
  * not be mixed for a single hardware.
  *
  * @hw: the hardware this frame came in on
  * @skb: the buffer to receive, owned by mac80211 after this call
  */
-static inline void ieee80211_rx_ni(struct ieee80211_hw *hw,
+static inline void mac80211_rx_ni(struct mac80211_hw *hw,
 				   struct sk_buff *skb)
 {
 	local_bh_disable();
-	ieee80211_rx(hw, skb);
+	mac80211_rx(hw, skb);
 	local_bh_enable();
 }
 
 /**
- * ieee80211_sta_ps_transition - PS transition for connected sta
+ * mac80211_sta_ps_transition - PS transition for connected sta
  *
- * When operating in AP mode with the %IEEE80211_HW_AP_LINK_PS
+ * When operating in AP mode with the %MAC80211_HW_AP_LINK_PS
  * flag set, use this function to inform mac80211 about a connected station
  * entering/leaving PS mode.
  *
@@ -2249,26 +2251,26 @@ static inline void ieee80211_rx_ni(struct ieee80211_hw *hw,
  * @sta: currently connected sta
  * @start: start or stop PS
  */
-int ieee80211_sta_ps_transition(struct ieee80211_sta *sta, bool start);
+int mac80211_sta_ps_transition(struct mac80211_sta *sta, bool start);
 
 /**
- * ieee80211_sta_ps_transition_ni - PS transition for connected sta
+ * mac80211_sta_ps_transition_ni - PS transition for connected sta
  *                                  (in process context)
  *
- * Like ieee80211_sta_ps_transition() but can be called in process context
+ * Like mac80211_sta_ps_transition() but can be called in process context
  * (internally disables bottom halves). Concurrent call restriction still
  * applies.
  *
  * @sta: currently connected sta
  * @start: start or stop PS
  */
-static inline int ieee80211_sta_ps_transition_ni(struct ieee80211_sta *sta,
+static inline int mac80211_sta_ps_transition_ni(struct mac80211_sta *sta,
 						  bool start)
 {
 	int ret;
 
 	local_bh_disable();
-	ret = ieee80211_sta_ps_transition(sta, start);
+	ret = mac80211_sta_ps_transition(sta, start);
 	local_bh_enable();
 
 	return ret;
@@ -2278,11 +2280,11 @@ static inline int ieee80211_sta_ps_transition_ni(struct ieee80211_sta *sta,
  * The TX headroom reserved by mac80211 for its own tx_status functions.
  * This is enough for the radiotap header.
  */
-#define IEEE80211_TX_STATUS_HEADROOM	13
+#define MAC80211_TX_STATUS_HEADROOM	13
 
 /**
- * ieee80211_sta_set_tim - set the TIM bit for a sleeping station
- * @sta: &struct ieee80211_sta pointer for the sleeping station
+ * mac80211_sta_set_tim - set the TIM bit for a sleeping station
+ * @sta: &struct mac80211_sta pointer for the sleeping station
  *
  * If a driver buffers frames for a powersave station instead of passing
  * them back to mac80211 for retransmission, the station needs to be told
@@ -2291,10 +2293,10 @@ static inline int ieee80211_sta_ps_transition_ni(struct ieee80211_sta *sta,
  * This function sets the station's TIM bit - it will be cleared when the
  * station wakes up.
  */
-void ieee80211_sta_set_tim(struct ieee80211_sta *sta);
+void mac80211_sta_set_tim(struct mac80211_sta *sta);
 
 /**
- * ieee80211_tx_status - transmit status callback
+ * mac80211_tx_status - transmit status callback
  *
  * Call this function for all transmitted frames after they have been
  * transmitted. It is permissible to not call this function for
@@ -2302,52 +2304,52 @@ void ieee80211_sta_set_tim(struct ieee80211_sta *sta);
  *
  * This function may not be called in IRQ context. Calls to this function
  * for a single hardware must be synchronized against each other. Calls
- * to this function, ieee80211_tx_status_ni() and ieee80211_tx_status_irqsafe()
+ * to this function, mac80211_tx_status_ni() and mac80211_tx_status_irqsafe()
  * may not be mixed for a single hardware.
  *
  * @hw: the hardware the frame was transmitted by
  * @skb: the frame that was transmitted, owned by mac80211 after this call
  */
-void ieee80211_tx_status(struct ieee80211_hw *hw,
+void mac80211_tx_status(struct mac80211_hw *hw,
 			 struct sk_buff *skb);
 
 /**
- * ieee80211_tx_status_ni - transmit status callback (in process context)
+ * mac80211_tx_status_ni - transmit status callback (in process context)
  *
- * Like ieee80211_tx_status() but can be called in process context.
+ * Like mac80211_tx_status() but can be called in process context.
  *
- * Calls to this function, ieee80211_tx_status() and
- * ieee80211_tx_status_irqsafe() may not be mixed
+ * Calls to this function, mac80211_tx_status() and
+ * mac80211_tx_status_irqsafe() may not be mixed
  * for a single hardware.
  *
  * @hw: the hardware the frame was transmitted by
  * @skb: the frame that was transmitted, owned by mac80211 after this call
  */
-static inline void ieee80211_tx_status_ni(struct ieee80211_hw *hw,
+static inline void mac80211_tx_status_ni(struct mac80211_hw *hw,
 					  struct sk_buff *skb)
 {
 	local_bh_disable();
-	ieee80211_tx_status(hw, skb);
+	mac80211_tx_status(hw, skb);
 	local_bh_enable();
 }
 
 /**
- * ieee80211_tx_status_irqsafe - IRQ-safe transmit status callback
+ * mac80211_tx_status_irqsafe - IRQ-safe transmit status callback
  *
- * Like ieee80211_tx_status() but can be called in IRQ context
+ * Like mac80211_tx_status() but can be called in IRQ context
  * (internally defers to a tasklet.)
  *
- * Calls to this function, ieee80211_tx_status() and
- * ieee80211_tx_status_ni() may not be mixed for a single hardware.
+ * Calls to this function, mac80211_tx_status() and
+ * mac80211_tx_status_ni() may not be mixed for a single hardware.
  *
  * @hw: the hardware the frame was transmitted by
  * @skb: the frame that was transmitted, owned by mac80211 after this call
  */
-void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
+void mac80211_tx_status_irqsafe(struct mac80211_hw *hw,
 				 struct sk_buff *skb);
 
 /**
- * ieee80211_report_low_ack - report non-responding station
+ * mac80211_report_low_ack - report non-responding station
  *
  * When operating in AP-mode, call this function to report a non-responding
  * connected STA.
@@ -2355,12 +2357,12 @@ void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
  * @sta: the non-responding connected sta
  * @num_packets: number of packets sent to @sta without a response
  */
-void ieee80211_report_low_ack(struct ieee80211_sta *sta, u32 num_packets);
+void mac80211_report_low_ack(struct mac80211_sta *sta, u32 num_packets);
 
 /**
- * ieee80211_beacon_get_tim - beacon generation function
- * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * mac80211_beacon_get_tim - beacon generation function
+ * @hw: pointer obtained from mac80211_alloc_hw().
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  * @tim_offset: pointer to variable that will receive the TIM IE offset.
  *	Set to 0 if invalid (in non-AP modes).
  * @tim_length: pointer to variable that will receive the TIM IE length,
@@ -2381,57 +2383,57 @@ void ieee80211_report_low_ack(struct ieee80211_sta *sta, u32 num_packets);
  *
  * The driver is responsible for freeing the returned skb.
  */
-struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
-					 struct ieee80211_vif *vif,
+struct sk_buff *mac80211_beacon_get_tim(struct mac80211_hw *hw,
+					 struct mac80211_vif *vif,
 					 u16 *tim_offset, u16 *tim_length);
 
 /**
- * ieee80211_beacon_get - beacon generation function
- * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * mac80211_beacon_get - beacon generation function
+ * @hw: pointer obtained from mac80211_alloc_hw().
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  *
- * See ieee80211_beacon_get_tim().
+ * See mac80211_beacon_get_tim().
  */
-static inline struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
-						   struct ieee80211_vif *vif)
+static inline struct sk_buff *mac80211_beacon_get(struct mac80211_hw *hw,
+						   struct mac80211_vif *vif)
 {
-	return ieee80211_beacon_get_tim(hw, vif, NULL, NULL);
+	return mac80211_beacon_get_tim(hw, vif, NULL, NULL);
 }
 
 /**
- * ieee80211_pspoll_get - retrieve a PS Poll template
- * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * mac80211_pspoll_get - retrieve a PS Poll template
+ * @hw: pointer obtained from mac80211_alloc_hw().
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  *
  * Creates a PS Poll a template which can, for example, uploaded to
  * hardware. The template must be updated after association so that correct
  * AID, BSSID and MAC address is used.
  *
  * Note: Caller (or hardware) is responsible for setting the
- * &IEEE80211_FCTL_PM bit.
+ * &MAC80211_FCTL_PM bit.
  */
-struct sk_buff *ieee80211_pspoll_get(struct ieee80211_hw *hw,
-				     struct ieee80211_vif *vif);
+struct sk_buff *mac80211_pspoll_get(struct mac80211_hw *hw,
+				     struct mac80211_vif *vif);
 
 /**
- * ieee80211_nullfunc_get - retrieve a nullfunc template
- * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * mac80211_nullfunc_get - retrieve a nullfunc template
+ * @hw: pointer obtained from mac80211_alloc_hw().
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  *
  * Creates a Nullfunc template which can, for example, uploaded to
  * hardware. The template must be updated after association so that correct
  * BSSID and address is used.
  *
  * Note: Caller (or hardware) is responsible for setting the
- * &IEEE80211_FCTL_PM bit as well as Duration and Sequence Control fields.
+ * &MAC80211_FCTL_PM bit as well as Duration and Sequence Control fields.
  */
-struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif);
+struct sk_buff *mac80211_nullfunc_get(struct mac80211_hw *hw,
+				       struct mac80211_vif *vif);
 
 /**
- * ieee80211_probereq_get - retrieve a Probe Request template
- * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * mac80211_probereq_get - retrieve a Probe Request template
+ * @hw: pointer obtained from mac80211_alloc_hw().
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  * @ssid: SSID buffer
  * @ssid_len: length of SSID
  * @ie: buffer containing all IEs except SSID for the template
@@ -2440,18 +2442,18 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
  * Creates a Probe Request template which can, for example, be uploaded to
  * hardware.
  */
-struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif,
+struct sk_buff *mac80211_probereq_get(struct mac80211_hw *hw,
+				       struct mac80211_vif *vif,
 				       const u8 *ssid, size_t ssid_len,
 				       const u8 *ie, size_t ie_len);
 
 /**
- * ieee80211_rts_get - RTS frame generation function
- * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * mac80211_rts_get - RTS frame generation function
+ * @hw: pointer obtained from mac80211_alloc_hw().
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  * @frame: pointer to the frame that is going to be protected by the RTS.
  * @frame_len: the frame length (in octets).
- * @frame_txctl: &struct ieee80211_tx_info of the frame.
+ * @frame_txctl: &struct mac80211_tx_info of the frame.
  * @rts: The buffer where to store the RTS frame.
  *
  * If the RTS frames are generated by the host system (i.e., not in
@@ -2459,33 +2461,33 @@ struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
  * the next RTS frame from the 802.11 code. The low-level is responsible
  * for calling this function before and RTS frame is needed.
  */
-void ieee80211_rts_get(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+void mac80211_rts_get(struct mac80211_hw *hw, struct mac80211_vif *vif,
 		       const void *frame, size_t frame_len,
-		       const struct ieee80211_tx_info *frame_txctl,
+		       const struct mac80211_tx_info *frame_txctl,
 		       struct ieee80211_rts *rts);
 
 /**
- * ieee80211_rts_duration - Get the duration field for an RTS frame
- * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * mac80211_rts_duration - Get the duration field for an RTS frame
+ * @hw: pointer obtained from mac80211_alloc_hw().
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  * @frame_len: the length of the frame that is going to be protected by the RTS.
- * @frame_txctl: &struct ieee80211_tx_info of the frame.
+ * @frame_txctl: &struct mac80211_tx_info of the frame.
  *
  * If the RTS is generated in firmware, but the host system must provide
  * the duration field, the low-level driver uses this function to receive
  * the duration field value in little-endian byteorder.
  */
-__le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
-			      struct ieee80211_vif *vif, size_t frame_len,
-			      const struct ieee80211_tx_info *frame_txctl);
+__le16 mac80211_rts_duration(struct mac80211_hw *hw,
+			      struct mac80211_vif *vif, size_t frame_len,
+			      const struct mac80211_tx_info *frame_txctl);
 
 /**
- * ieee80211_ctstoself_get - CTS-to-self frame generation function
- * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * mac80211_ctstoself_get - CTS-to-self frame generation function
+ * @hw: pointer obtained from mac80211_alloc_hw().
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  * @frame: pointer to the frame that is going to be protected by the CTS-to-self.
  * @frame_len: the frame length (in octets).
- * @frame_txctl: &struct ieee80211_tx_info of the frame.
+ * @frame_txctl: &struct mac80211_tx_info of the frame.
  * @cts: The buffer where to store the CTS-to-self frame.
  *
  * If the CTS-to-self frames are generated by the host system (i.e., not in
@@ -2493,47 +2495,47 @@ __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
  * the next CTS-to-self frame from the 802.11 code. The low-level is responsible
  * for calling this function before and CTS-to-self frame is needed.
  */
-void ieee80211_ctstoself_get(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif,
+void mac80211_ctstoself_get(struct mac80211_hw *hw,
+			     struct mac80211_vif *vif,
 			     const void *frame, size_t frame_len,
-			     const struct ieee80211_tx_info *frame_txctl,
+			     const struct mac80211_tx_info *frame_txctl,
 			     struct ieee80211_cts *cts);
 
 /**
- * ieee80211_ctstoself_duration - Get the duration field for a CTS-to-self frame
- * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * mac80211_ctstoself_duration - Get the duration field for a CTS-to-self frame
+ * @hw: pointer obtained from mac80211_alloc_hw().
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  * @frame_len: the length of the frame that is going to be protected by the CTS-to-self.
- * @frame_txctl: &struct ieee80211_tx_info of the frame.
+ * @frame_txctl: &struct mac80211_tx_info of the frame.
  *
  * If the CTS-to-self is generated in firmware, but the host system must provide
  * the duration field, the low-level driver uses this function to receive
  * the duration field value in little-endian byteorder.
  */
-__le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
-				    struct ieee80211_vif *vif,
+__le16 mac80211_ctstoself_duration(struct mac80211_hw *hw,
+				    struct mac80211_vif *vif,
 				    size_t frame_len,
-				    const struct ieee80211_tx_info *frame_txctl);
+				    const struct mac80211_tx_info *frame_txctl);
 
 /**
- * ieee80211_generic_frame_duration - Calculate the duration field for a frame
- * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * mac80211_generic_frame_duration - Calculate the duration field for a frame
+ * @hw: pointer obtained from mac80211_alloc_hw().
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  * @frame_len: the length of the frame.
  * @rate: the rate at which the frame is going to be transmitted.
  *
  * Calculate the duration field of some generic frame, given its
  * length and transmission rate (in 100kbps).
  */
-__le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
-					struct ieee80211_vif *vif,
+__le16 mac80211_generic_frame_duration(struct mac80211_hw *hw,
+					struct mac80211_vif *vif,
 					size_t frame_len,
 					struct ieee80211_rate *rate);
 
 /**
- * ieee80211_get_buffered_bc - accessing buffered broadcast and multicast frames
- * @hw: pointer as obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * mac80211_get_buffered_bc - accessing buffered broadcast and multicast frames
+ * @hw: pointer as obtained from mac80211_alloc_hw().
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  *
  * Function for accessing buffered broadcast and multicast frames. If
  * hardware/firmware does not implement buffering of broadcast/multicast
@@ -2544,17 +2546,17 @@ __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
  * buffered frames are available.
  *
  * Note: buffered frames are returned only after DTIM beacon frame was
- * generated with ieee80211_beacon_get() and the low-level driver must thus
- * call ieee80211_beacon_get() first. ieee80211_get_buffered_bc() returns
+ * generated with mac80211_beacon_get() and the low-level driver must thus
+ * call mac80211_beacon_get() first. mac80211_get_buffered_bc() returns
  * NULL if the previous generated beacon was not DTIM, so the low-level driver
  * does not need to check for DTIM beacons separately and should be able to
  * use common code for all beacons.
  */
 struct sk_buff *
-ieee80211_get_buffered_bc(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
+mac80211_get_buffered_bc(struct mac80211_hw *hw, struct mac80211_vif *vif);
 
 /**
- * ieee80211_get_tkip_key - get a TKIP rc4 for skb
+ * mac80211_get_tkip_key - get a TKIP rc4 for skb
  *
  * This function computes a TKIP rc4 key for an skb. It computes
  * a phase 1 key if needed (iv16 wraps around). This function is to
@@ -2566,55 +2568,55 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
  * @type: TBD
  * @key: a buffer to which the key will be written
  */
-void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
+void mac80211_get_tkip_key(struct mac80211_key_conf *keyconf,
 				struct sk_buff *skb,
-				enum ieee80211_tkip_key_type type, u8 *key);
+				enum mac80211_tkip_key_type type, u8 *key);
 /**
- * ieee80211_wake_queue - wake specific queue
- * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * mac80211_wake_queue - wake specific queue
+ * @hw: pointer as obtained from mac80211_alloc_hw().
  * @queue: queue number (counted from zero).
  *
  * Drivers should use this function instead of netif_wake_queue.
  */
-void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue);
+void mac80211_wake_queue(struct mac80211_hw *hw, int queue);
 
 /**
- * ieee80211_stop_queue - stop specific queue
- * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * mac80211_stop_queue - stop specific queue
+ * @hw: pointer as obtained from mac80211_alloc_hw().
  * @queue: queue number (counted from zero).
  *
  * Drivers should use this function instead of netif_stop_queue.
  */
-void ieee80211_stop_queue(struct ieee80211_hw *hw, int queue);
+void mac80211_stop_queue(struct mac80211_hw *hw, int queue);
 
 /**
- * ieee80211_queue_stopped - test status of the queue
- * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * mac80211_queue_stopped - test status of the queue
+ * @hw: pointer as obtained from mac80211_alloc_hw().
  * @queue: queue number (counted from zero).
  *
  * Drivers should use this function instead of netif_stop_queue.
  */
 
-int ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue);
+int mac80211_queue_stopped(struct mac80211_hw *hw, int queue);
 
 /**
- * ieee80211_stop_queues - stop all queues
- * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * mac80211_stop_queues - stop all queues
+ * @hw: pointer as obtained from mac80211_alloc_hw().
  *
  * Drivers should use this function instead of netif_stop_queue.
  */
-void ieee80211_stop_queues(struct ieee80211_hw *hw);
+void mac80211_stop_queues(struct mac80211_hw *hw);
 
 /**
- * ieee80211_wake_queues - wake all queues
- * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * mac80211_wake_queues - wake all queues
+ * @hw: pointer as obtained from mac80211_alloc_hw().
  *
  * Drivers should use this function instead of netif_wake_queue.
  */
-void ieee80211_wake_queues(struct ieee80211_hw *hw);
+void mac80211_wake_queues(struct mac80211_hw *hw);
 
 /**
- * ieee80211_scan_completed - completed hardware scan
+ * mac80211_scan_completed - completed hardware scan
  *
  * When hardware scan offload is used (i.e. the hw_scan() callback is
  * assigned) this function needs to be called by the driver to notify
@@ -2624,20 +2626,20 @@ void ieee80211_wake_queues(struct ieee80211_hw *hw);
  * @hw: the hardware that finished the scan
  * @aborted: set to true if scan was aborted
  */
-void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted);
+void mac80211_scan_completed(struct mac80211_hw *hw, bool aborted);
 
 /**
- * ieee80211_sched_scan_results - got results from scheduled scan
+ * mac80211_sched_scan_results - got results from scheduled scan
  *
  * When a scheduled scan is running, this function needs to be called by the
  * driver whenever there are new scan results available.
  *
  * @hw: the hardware that is performing scheduled scans
  */
-void ieee80211_sched_scan_results(struct ieee80211_hw *hw);
+void mac80211_sched_scan_results(struct mac80211_hw *hw);
 
 /**
- * ieee80211_sched_scan_stopped - inform that the scheduled scan has stopped
+ * mac80211_sched_scan_stopped - inform that the scheduled scan has stopped
  *
  * When a scheduled scan is running, this function can be called by
  * the driver if it needs to stop the scan to perform another task.
@@ -2646,15 +2648,15 @@ void ieee80211_sched_scan_results(struct ieee80211_hw *hw);
  *
  * @hw: the hardware that is performing scheduled scans
  */
-void ieee80211_sched_scan_stopped(struct ieee80211_hw *hw);
+void mac80211_sched_scan_stopped(struct mac80211_hw *hw);
 
 /**
- * ieee80211_iterate_active_interfaces - iterate active interfaces
+ * mac80211_iterate_active_interfaces - iterate active interfaces
  *
  * This function iterates over the interfaces associated with a given
  * hardware that are currently active and calls the callback for them.
  * This function allows the iterator function to sleep, when the iterator
- * function is atomic @ieee80211_iterate_active_interfaces_atomic can
+ * function is atomic @mac80211_iterate_active_interfaces_atomic can
  * be used.
  * Does not iterate over a new interface during add_interface()
  *
@@ -2662,32 +2664,32 @@ void ieee80211_sched_scan_stopped(struct ieee80211_hw *hw);
  * @iterator: the iterator function to call
  * @data: first argument of the iterator function
  */
-void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
+void mac80211_iterate_active_interfaces(struct mac80211_hw *hw,
 					 void (*iterator)(void *data, u8 *mac,
-						struct ieee80211_vif *vif),
+						struct mac80211_vif *vif),
 					 void *data);
 
 /**
- * ieee80211_iterate_active_interfaces_atomic - iterate active interfaces
+ * mac80211_iterate_active_interfaces_atomic - iterate active interfaces
  *
  * This function iterates over the interfaces associated with a given
  * hardware that are currently active and calls the callback for them.
  * This function requires the iterator callback function to be atomic,
- * if that is not desired, use @ieee80211_iterate_active_interfaces instead.
+ * if that is not desired, use @mac80211_iterate_active_interfaces instead.
  * Does not iterate over a new interface during add_interface()
  *
  * @hw: the hardware struct of which the interfaces should be iterated over
  * @iterator: the iterator function to call, cannot sleep
  * @data: first argument of the iterator function
  */
-void ieee80211_iterate_active_interfaces_atomic(struct ieee80211_hw *hw,
+void mac80211_iterate_active_interfaces_atomic(struct mac80211_hw *hw,
 						void (*iterator)(void *data,
 						    u8 *mac,
-						    struct ieee80211_vif *vif),
+						    struct mac80211_vif *vif),
 						void *data);
 
 /**
- * ieee80211_queue_work - add work onto the mac80211 workqueue
+ * mac80211_queue_work - add work onto the mac80211 workqueue
  *
  * Drivers and mac80211 use this to add work onto the mac80211 workqueue.
  * This helper ensures drivers are not queueing work when they should not be.
@@ -2695,10 +2697,10 @@ void ieee80211_iterate_active_interfaces_atomic(struct ieee80211_hw *hw,
  * @hw: the hardware struct for the interface we are adding work for
  * @work: the work we want to add onto the mac80211 workqueue
  */
-void ieee80211_queue_work(struct ieee80211_hw *hw, struct work_struct *work);
+void mac80211_queue_work(struct mac80211_hw *hw, struct work_struct *work);
 
 /**
- * ieee80211_queue_delayed_work - add work onto the mac80211 workqueue
+ * mac80211_queue_delayed_work - add work onto the mac80211 workqueue
  *
  * Drivers and mac80211 use this to queue delayed work onto the mac80211
  * workqueue.
@@ -2707,12 +2709,12 @@ void ieee80211_queue_work(struct ieee80211_hw *hw, struct work_struct *work);
  * @dwork: delayable work to queue onto the mac80211 workqueue
  * @delay: number of jiffies to wait before queueing
  */
-void ieee80211_queue_delayed_work(struct ieee80211_hw *hw,
+void mac80211_queue_delayed_work(struct mac80211_hw *hw,
 				  struct delayed_work *dwork,
 				  unsigned long delay);
 
 /**
- * ieee80211_start_tx_ba_session - Start a tx Block Ack session.
+ * mac80211_start_tx_ba_session - Start a tx Block Ack session.
  * @sta: the station for which to start a BA session
  * @tid: the TID to BA on.
  * @timeout: session timeout value (in TUs)
@@ -2723,12 +2725,12 @@ void ieee80211_queue_delayed_work(struct ieee80211_hw *hw,
  * the need to start aggregation on a certain RA/TID, the session level
  * will be managed by the mac80211.
  */
-int ieee80211_start_tx_ba_session(struct ieee80211_sta *sta, u16 tid,
+int mac80211_start_tx_ba_session(struct mac80211_sta *sta, u16 tid,
 				  u16 timeout);
 
 /**
- * ieee80211_start_tx_ba_cb_irqsafe - low level driver ready to aggregate.
- * @vif: &struct ieee80211_vif pointer from the add_interface callback
+ * mac80211_start_tx_ba_cb_irqsafe - low level driver ready to aggregate.
+ * @vif: &struct mac80211_vif pointer from the add_interface callback
  * @ra: receiver address of the BA session recipient.
  * @tid: the TID to BA on.
  *
@@ -2736,11 +2738,11 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *sta, u16 tid,
  * finished with preparations for the BA session. It can be called
  * from any context.
  */
-void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_vif *vif, const u8 *ra,
+void mac80211_start_tx_ba_cb_irqsafe(struct mac80211_vif *vif, const u8 *ra,
 				      u16 tid);
 
 /**
- * ieee80211_stop_tx_ba_session - Stop a Block Ack session.
+ * mac80211_stop_tx_ba_session - Stop a Block Ack session.
  * @sta: the station whose BA session to stop
  * @tid: the TID to stop BA.
  *
@@ -2750,11 +2752,11 @@ void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_vif *vif, const u8 *ra,
  * the need to stop aggregation on a certain RA/TID, the session level
  * will be managed by the mac80211.
  */
-int ieee80211_stop_tx_ba_session(struct ieee80211_sta *sta, u16 tid);
+int mac80211_stop_tx_ba_session(struct mac80211_sta *sta, u16 tid);
 
 /**
- * ieee80211_stop_tx_ba_cb_irqsafe - low level driver ready to stop aggregate.
- * @vif: &struct ieee80211_vif pointer from the add_interface callback
+ * mac80211_stop_tx_ba_cb_irqsafe - low level driver ready to stop aggregate.
+ * @vif: &struct mac80211_vif pointer from the add_interface callback
  * @ra: receiver address of the BA session recipient.
  * @tid: the desired TID to BA on.
  *
@@ -2762,11 +2764,11 @@ int ieee80211_stop_tx_ba_session(struct ieee80211_sta *sta, u16 tid);
  * finished with preparations for the BA session tear down. It
  * can be called from any context.
  */
-void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_vif *vif, const u8 *ra,
+void mac80211_stop_tx_ba_cb_irqsafe(struct mac80211_vif *vif, const u8 *ra,
 				     u16 tid);
 
 /**
- * ieee80211_find_sta - find a station
+ * mac80211_find_sta - find a station
  *
  * @vif: virtual interface to look for station on
  * @addr: station's address
@@ -2774,13 +2776,13 @@ void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_vif *vif, const u8 *ra,
  * This function must be called under RCU lock and the
  * resulting pointer is only valid under RCU lock as well.
  */
-struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
+struct mac80211_sta *mac80211_find_sta(struct mac80211_vif *vif,
 					 const u8 *addr);
 
 /**
- * ieee80211_find_sta_by_ifaddr - find a station on hardware
+ * mac80211_find_sta_by_ifaddr - find a station on hardware
  *
- * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @hw: pointer as obtained from mac80211_alloc_hw()
  * @addr: remote station's address
  * @localaddr: local address (vif->sdata->vif.addr). Use NULL for 'any'.
  *
@@ -2797,12 +2799,12 @@ struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
  *
  * DO NOT USE THIS FUNCTION with localaddr NULL if at all possible.
  */
-struct ieee80211_sta *ieee80211_find_sta_by_ifaddr(struct ieee80211_hw *hw,
+struct mac80211_sta *mac80211_find_sta_by_ifaddr(struct mac80211_hw *hw,
 					       const u8 *addr,
 					       const u8 *localaddr);
 
 /**
- * ieee80211_sta_block_awake - block station from waking up
+ * mac80211_sta_block_awake - block station from waking up
  * @hw: the hardware
  * @pubsta: the station
  * @block: whether to block or unblock
@@ -2830,13 +2832,13 @@ struct ieee80211_sta *ieee80211_find_sta_by_ifaddr(struct ieee80211_hw *hw,
  * it is unblocked, regardless of whether the station actually
  * woke up while blocked or not.
  */
-void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
-			       struct ieee80211_sta *pubsta, bool block);
+void mac80211_sta_block_awake(struct mac80211_hw *hw,
+			       struct mac80211_sta *pubsta, bool block);
 
 /**
- * ieee80211_ap_probereq_get - retrieve a Probe Request template
- * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * mac80211_ap_probereq_get - retrieve a Probe Request template
+ * @hw: pointer obtained from mac80211_alloc_hw().
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  *
  * Creates a Probe Request template which can, for example, be uploaded to
  * hardware. The template is filled with bssid, ssid and supported rate
@@ -2845,38 +2847,38 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
  * is only useful when the interface is associated, otherwise it will return
  * NULL.
  */
-struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
-					  struct ieee80211_vif *vif);
+struct sk_buff *mac80211_ap_probereq_get(struct mac80211_hw *hw,
+					  struct mac80211_vif *vif);
 
 /**
- * ieee80211_beacon_loss - inform hardware does not receive beacons
+ * mac80211_beacon_loss - inform hardware does not receive beacons
  *
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  *
- * When beacon filtering is enabled with %IEEE80211_HW_BEACON_FILTER and
- * %IEEE80211_CONF_PS is set, the driver needs to inform whenever the
+ * When beacon filtering is enabled with %MAC80211_HW_BEACON_FILTER and
+ * %MAC80211_CONF_PS is set, the driver needs to inform whenever the
  * hardware is not receiving beacons with this function.
  */
-void ieee80211_beacon_loss(struct ieee80211_vif *vif);
+void mac80211_beacon_loss(struct mac80211_vif *vif);
 
 /**
- * ieee80211_connection_loss - inform hardware has lost connection to the AP
+ * mac80211_connection_loss - inform hardware has lost connection to the AP
  *
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  *
- * When beacon filtering is enabled with %IEEE80211_HW_BEACON_FILTER, and
- * %IEEE80211_CONF_PS and %IEEE80211_HW_CONNECTION_MONITOR are set, the driver
+ * When beacon filtering is enabled with %MAC80211_HW_BEACON_FILTER, and
+ * %MAC80211_CONF_PS and %MAC80211_HW_CONNECTION_MONITOR are set, the driver
  * needs to inform if the connection to the AP has been lost.
  *
  * This function will cause immediate change to disassociated state,
  * without connection recovery attempts.
  */
-void ieee80211_connection_loss(struct ieee80211_vif *vif);
+void mac80211_connection_loss(struct mac80211_vif *vif);
 
 /**
- * ieee80211_disable_dyn_ps - force mac80211 to temporarily disable dynamic psm
+ * mac80211_disable_dyn_ps - force mac80211 to temporarily disable dynamic psm
  *
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  *
  * Some hardware require full power save to manage simultaneous BT traffic
  * on the WLAN frequency. Full PSM is required periodically, whenever there are
@@ -2886,63 +2888,63 @@ void ieee80211_connection_loss(struct ieee80211_vif *vif);
  * This function will only temporarily disable dynamic PS, not enable PSM if
  * it was not already enabled.
  * The driver must make sure to re-enable dynamic PS using
- * ieee80211_enable_dyn_ps() if the driver has disabled it.
+ * mac80211_enable_dyn_ps() if the driver has disabled it.
  *
  */
-void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif);
+void mac80211_disable_dyn_ps(struct mac80211_vif *vif);
 
 /**
- * ieee80211_enable_dyn_ps - restore dynamic psm after being disabled
+ * mac80211_enable_dyn_ps - restore dynamic psm after being disabled
  *
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  *
  * This function restores dynamic PS after being temporarily disabled via
- * ieee80211_disable_dyn_ps(). Each ieee80211_disable_dyn_ps() call must
+ * mac80211_disable_dyn_ps(). Each mac80211_disable_dyn_ps() call must
  * be coupled with an eventual call to this function.
  *
  */
-void ieee80211_enable_dyn_ps(struct ieee80211_vif *vif);
+void mac80211_enable_dyn_ps(struct mac80211_vif *vif);
 
 /**
- * ieee80211_cqm_rssi_notify - inform a configured connection quality monitoring
+ * mac80211_cqm_rssi_notify - inform a configured connection quality monitoring
  *	rssi threshold triggered
  *
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  * @rssi_event: the RSSI trigger event type
  * @gfp: context flags
  *
- * When the %IEEE80211_HW_SUPPORTS_CQM_RSSI is set, and a connection quality
+ * When the %MAC80211_HW_SUPPORTS_CQM_RSSI is set, and a connection quality
  * monitoring is configured with an rssi threshold, the driver will inform
  * whenever the rssi level reaches the threshold.
  */
-void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
+void mac80211_cqm_rssi_notify(struct mac80211_vif *vif,
 			       enum nl80211_cqm_rssi_threshold_event rssi_event,
 			       gfp_t gfp);
 
 /**
- * ieee80211_chswitch_done - Complete channel switch process
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * mac80211_chswitch_done - Complete channel switch process
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  * @success: make the channel switch successful or not
  *
  * Complete the channel switch post-process: set the new operational channel
  * and wake up the suspended queues.
  */
-void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success);
+void mac80211_chswitch_done(struct mac80211_vif *vif, bool success);
 
 /**
- * ieee80211_request_smps - request SM PS transition
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * mac80211_request_smps - request SM PS transition
+ * @vif: &struct mac80211_vif pointer from the add_interface callback.
  * @smps_mode: new SM PS mode
  *
  * This allows the driver to request an SM PS transition in managed
  * mode. This is useful when the driver has more information than
  * the stack about possible interference, for example by bluetooth.
  */
-void ieee80211_request_smps(struct ieee80211_vif *vif,
-			    enum ieee80211_smps_mode smps_mode);
+void mac80211_request_smps(struct mac80211_vif *vif,
+			    enum mac80211_smps_mode smps_mode);
 
 /**
- * ieee80211_key_removed - disable hw acceleration for key
+ * mac80211_key_removed - disable hw acceleration for key
  * @key_conf: The key hw acceleration should be disabled for
  *
  * This allows drivers to indicate that the given key has been
@@ -2955,19 +2957,19 @@ void ieee80211_request_smps(struct ieee80211_vif *vif,
  * @set_key. This function must be allowed to sleep, and the
  * key it tries to disable may still be used until it returns.
  */
-void ieee80211_key_removed(struct ieee80211_key_conf *key_conf);
+void mac80211_key_removed(struct mac80211_key_conf *key_conf);
 
 /**
- * ieee80211_ready_on_channel - notification of remain-on-channel start
- * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * mac80211_ready_on_channel - notification of remain-on-channel start
+ * @hw: pointer as obtained from mac80211_alloc_hw()
  */
-void ieee80211_ready_on_channel(struct ieee80211_hw *hw);
+void mac80211_ready_on_channel(struct mac80211_hw *hw);
 
 /**
- * ieee80211_remain_on_channel_expired - remain_on_channel duration expired
- * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * mac80211_remain_on_channel_expired - remain_on_channel duration expired
+ * @hw: pointer as obtained from mac80211_alloc_hw()
  */
-void ieee80211_remain_on_channel_expired(struct ieee80211_hw *hw);
+void mac80211_remain_on_channel_expired(struct mac80211_hw *hw);
 
 /**
  * ieee80211_stop_rx_ba_session - callback to stop existing BA sessions
@@ -2991,15 +2993,15 @@ void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 ba_rx_bitmap,
 /**
  * enum rate_control_changed - flags to indicate which parameter changed
  *
- * @IEEE80211_RC_HT_CHANGED: The HT parameters of the operating channel have
+ * @MAC80211_RC_HT_CHANGED: The HT parameters of the operating channel have
  *	changed, rate control algorithm can update its internal state if needed.
  */
 enum rate_control_changed {
-	IEEE80211_RC_HT_CHANGED = BIT(0)
+	MAC80211_RC_HT_CHANGED = BIT(0)
 };
 
 /**
- * struct ieee80211_tx_rate_control - rate control information for/from RC algo
+ * struct mac80211_tx_rate_control - rate control information for/from RC algo
  *
  * @hw: The hardware the algorithm is invoked for.
  * @sband: The band this frame is being transmitted on.
@@ -3019,12 +3021,12 @@ enum rate_control_changed {
  *	to be filled in
  * @bss: whether this frame is sent out in AP or IBSS mode
  */
-struct ieee80211_tx_rate_control {
-	struct ieee80211_hw *hw;
+struct mac80211_tx_rate_control {
+	struct mac80211_hw *hw;
 	struct ieee80211_supported_band *sband;
-	struct ieee80211_bss_conf *bss_conf;
+	struct mac80211_bss_conf *bss_conf;
 	struct sk_buff *skb;
-	struct ieee80211_tx_rate reported_rate;
+	struct mac80211_tx_rate reported_rate;
 	bool rts, short_preamble;
 	u8 max_rate_idx;
 	u32 rate_idx_mask;
@@ -3034,31 +3036,31 @@ struct ieee80211_tx_rate_control {
 struct rate_control_ops {
 	struct module *module;
 	const char *name;
-	void *(*alloc)(struct ieee80211_hw *hw, struct dentry *debugfsdir);
+	void *(*alloc)(struct mac80211_hw *hw, struct dentry *debugfsdir);
 	void (*free)(void *priv);
 
-	void *(*alloc_sta)(void *priv, struct ieee80211_sta *sta, gfp_t gfp);
+	void *(*alloc_sta)(void *priv, struct mac80211_sta *sta, gfp_t gfp);
 	void (*rate_init)(void *priv, struct ieee80211_supported_band *sband,
-			  struct ieee80211_sta *sta, void *priv_sta);
+			  struct mac80211_sta *sta, void *priv_sta);
 	void (*rate_update)(void *priv, struct ieee80211_supported_band *sband,
-			    struct ieee80211_sta *sta,
+			    struct mac80211_sta *sta,
 			    void *priv_sta, u32 changed,
 			    enum nl80211_channel_type oper_chan_type);
-	void (*free_sta)(void *priv, struct ieee80211_sta *sta,
+	void (*free_sta)(void *priv, struct mac80211_sta *sta,
 			 void *priv_sta);
 
 	void (*tx_status)(void *priv, struct ieee80211_supported_band *sband,
-			  struct ieee80211_sta *sta, void *priv_sta,
+			  struct mac80211_sta *sta, void *priv_sta,
 			  struct sk_buff *skb);
-	void (*get_rate)(void *priv, struct ieee80211_sta *sta, void *priv_sta,
-			 struct ieee80211_tx_rate_control *txrc);
+	void (*get_rate)(void *priv, struct mac80211_sta *sta, void *priv_sta,
+			 struct mac80211_tx_rate_control *txrc);
 
 	void (*add_sta_debugfs)(void *priv, void *priv_sta,
 				struct dentry *dir);
 	void (*remove_sta_debugfs)(void *priv, void *priv_sta);
 };
 
-static inline int rate_supported(struct ieee80211_sta *sta,
+static inline int rate_supported(struct mac80211_sta *sta,
 				 enum ieee80211_band band,
 				 int index)
 {
@@ -3078,19 +3080,19 @@ static inline int rate_supported(struct ieee80211_sta *sta,
  * Rate control algorithms wishing to do more intelligent selection of
  * rate for multicast/broadcast frames may choose to not use this.
  *
- * @sta: &struct ieee80211_sta pointer to the target destination. Note
+ * @sta: &struct mac80211_sta pointer to the target destination. Note
  * 	that this may be null.
  * @priv_sta: private rate control structure. This may be null.
  * @txrc: rate control information we sholud populate for mac80211.
  */
-bool rate_control_send_low(struct ieee80211_sta *sta,
+bool rate_control_send_low(struct mac80211_sta *sta,
 			   void *priv_sta,
-			   struct ieee80211_tx_rate_control *txrc);
+			   struct mac80211_tx_rate_control *txrc);
 
 
 static inline s8
 rate_lowest_index(struct ieee80211_supported_band *sband,
-		  struct ieee80211_sta *sta)
+		  struct mac80211_sta *sta)
 {
 	int i;
 
@@ -3106,7 +3108,7 @@ rate_lowest_index(struct ieee80211_supported_band *sband,
 
 static inline
 bool rate_usable_index_exists(struct ieee80211_supported_band *sband,
-			      struct ieee80211_sta *sta)
+			      struct mac80211_sta *sta)
 {
 	unsigned int i;
 
@@ -3116,41 +3118,41 @@ bool rate_usable_index_exists(struct ieee80211_supported_band *sband,
 	return false;
 }
 
-int ieee80211_rate_control_register(struct rate_control_ops *ops);
-void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
+int mac80211_rate_control_register(struct rate_control_ops *ops);
+void mac80211_rate_control_unregister(struct rate_control_ops *ops);
 
 static inline bool
-conf_is_ht20(struct ieee80211_conf *conf)
+conf_is_ht20(struct mac80211_conf *conf)
 {
 	return conf->channel_type == NL80211_CHAN_HT20;
 }
 
 static inline bool
-conf_is_ht40_minus(struct ieee80211_conf *conf)
+conf_is_ht40_minus(struct mac80211_conf *conf)
 {
 	return conf->channel_type == NL80211_CHAN_HT40MINUS;
 }
 
 static inline bool
-conf_is_ht40_plus(struct ieee80211_conf *conf)
+conf_is_ht40_plus(struct mac80211_conf *conf)
 {
 	return conf->channel_type == NL80211_CHAN_HT40PLUS;
 }
 
 static inline bool
-conf_is_ht40(struct ieee80211_conf *conf)
+conf_is_ht40(struct mac80211_conf *conf)
 {
 	return conf_is_ht40_minus(conf) || conf_is_ht40_plus(conf);
 }
 
 static inline bool
-conf_is_ht(struct ieee80211_conf *conf)
+conf_is_ht(struct mac80211_conf *conf)
 {
 	return conf->channel_type != NL80211_CHAN_NO_HT;
 }
 
 static inline enum nl80211_iftype
-ieee80211_iftype_p2p(enum nl80211_iftype type, bool p2p)
+mac80211_iftype_p2p(enum nl80211_iftype type, bool p2p)
 {
 	if (p2p) {
 		switch (type) {
@@ -3166,9 +3168,9 @@ ieee80211_iftype_p2p(enum nl80211_iftype type, bool p2p)
 }
 
 static inline enum nl80211_iftype
-ieee80211_vif_type_p2p(struct ieee80211_vif *vif)
+mac80211_vif_type_p2p(struct mac80211_vif *vif)
 {
-	return ieee80211_iftype_p2p(vif->type, vif->p2p);
+	return mac80211_iftype_p2p(vif->type, vif->p2p);
 }
 
 #endif /* MAC80211_H */

