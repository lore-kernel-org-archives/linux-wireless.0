Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42376 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbZISUzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2009 16:55:43 -0400
Date: Sat, 19 Sep 2009 16:55:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: Greg KH <greg@kroah.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Tim Gardner <tim.gardner@canonical.com>
Subject: [RFC] compat-2.6: mangle symbols for driver-select
Message-ID: <20090919205545.GA18080@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Today at the summit we spoke about mangling symbols for driver-slect.
Here's a quick nasty take on this but without doing this for driver-select
specifically just for testing. It seems to compile, but someone more motivated
may want to test and make this apply somehow only for driver-select or perhaps
when a -D define is used.

Reason for this is to help distributions / OEMs / ODMs who want to replace
just *one* driver with compat-wireless.

diff --git a/compat/compat.h b/compat/compat.h
index 05612b2..711a511 100644
--- a/compat/compat.h
+++ b/compat/compat.h
@@ -22,4 +22,159 @@
 #include <net/compat-2.6.31.h>
 #include <net/compat-2.6.32.h>
 
+#ifdef CONFIG_COMPAT_WIRELESS_MANGLE
+
+/* cfg80211 */
+
+#define wiphy_new					backport_wiphy_new
+#define wiphy_register					backport_wiphy_register
+#define wiphy_rfkill_start_polling			backport_wiphy_rfkill_start_polling
+#define wiphy_rfkill_stop_polling			backport_wiphy_rfkill_stop_polling
+#define wiphy_unregister				backport_wiphy_unregister
+#define wiphy_free					backport_wiphy_free
+#define wiphy_rfkill_set_hw_state			backport_wiphy_rfkill_set_hw_state
+#define cfg80211_ibss_joined				backport_cfg80211_ibss_joined
+#define print_ssid					backport_print_ssid
+#define lib80211_crypt_info_init			backport_lib80211_crypt_info_init
+#define lib80211_crypt_info_free			backport_lib80211_crypt_info_free
+#define lib80211_crypt_deinit_entries			backport_lib80211_crypt_deinit_entries
+#define lib80211_crypt_quiescing			backport_lib80211_crypt_quiescing
+#define lib80211_crypt_deinit_handler			backport_lib80211_crypt_deinit_handler
+#define lib80211_crypt_delayed_deinit			backport_lib80211_crypt_delayed_deinit
+#define lib80211_register_crypto_ops			backport_lib80211_register_crypto_ops
+#define lib80211_unregister_crypto_ops			backport_lib80211_unregister_crypto_ops
+#define lib80211_get_crypto_ops				backport_lib80211_get_crypto_ops
+#define cfg80211_send_rx_auth				backport_cfg80211_send_rx_auth
+#define cfg80211_send_rx_assoc				backport_cfg80211_send_rx_assoc
+#define cfg80211_send_deauth				backport_cfg80211_send_deauth
+#define cfg80211_send_disassoc				backport_cfg80211_send_disassoc
+#define cfg80211_send_auth_timeout			backport_cfg80211_send_auth_timeout
+#define cfg80211_send_assoc_timeout			backport_cfg80211_send_assoc_timeout
+#define cfg80211_michael_mic_failure			backport_cfg80211_michael_mic_failure
+#define cfg80211_testmode_alloc_reply_skb		backport_cfg80211_testmode_alloc_reply_skb
+#define cfg80211_testmode_reply				backport_cfg80211_testmode_reply
+#define cfg80211_testmode_alloc_event_skb		backport_cfg80211_testmode_alloc_event_skb
+#define cfg80211_testmode_event				backport_cfg80211_testmode_event
+#define ieee80211_radiotap_iterator_init		backport_ieee80211_radiotap_iterator_init
+#define ieee80211_radiotap_iterator_next		backport_ieee80211_radiotap_iterator_next
+#define freq_reg_info					backport_freq_reg_info
+#define wiphy_apply_custom_regulatory			backport_wiphy_apply_custom_regulatory
+#define regulatory_hint					backport_regulatory_hint
+#define cfg80211_scan_done				backport_cfg80211_scan_done
+#define cfg80211_get_bss				backport_cfg80211_get_bss
+#define cfg80211_get_mesh				backport_cfg80211_get_mesh
+#define cfg80211_inform_bss				backport_cfg80211_inform_bss
+#define cfg80211_inform_bss_frame			backport_cfg80211_inform_bss_frame
+#define cfg80211_put_bss				backport_cfg80211_put_bss
+#define cfg80211_unlink_bss				backport_cfg80211_unlink_bss
+#define cfg80211_wext_siwscan				backport_cfg80211_wext_siwscan
+#define cfg80211_wext_giwscan				backport_cfg80211_wext_giwscan
+#define cfg80211_connect_result				backport_cfg80211_connect_result
+#define cfg80211_roamed					backport_cfg80211_roamed
+#define cfg80211_disconnected				backport_cfg80211_disconnected
+#define ieee80211_get_response_rate			backport_ieee80211_get_response_rate
+#define ieee80211_channel_to_frequency			backport_ieee80211_channel_to_frequency
+#define ieee80211_frequency_to_channel			backport_ieee80211_frequency_to_channel
+#define __ieee80211_get_channel				backport___ieee80211_get_channel
+#define rfc1042_header					backport_rfc1042_header
+#define bridge_tunnel_header				backport_bridge_tunnel_header
+#define ieee80211_hdrlen				backport_ieee80211_hdrlen
+#define ieee80211_get_hdrlen_from_skb			backport_ieee80211_get_hdrlen_from_skb
+#define ieee80211_data_to_8023				backport_ieee80211_data_to_8023
+#define ieee80211_data_from_8023			backport_ieee80211_data_from_8023
+#define cfg80211_classify8021d				backport_cfg80211_classify8021d
+#define ieee80211_bss_get_ie				backport_ieee80211_bss_get_ie
+#define wireless_send_event				backport_wireless_send_event
+#define iw_handler_set_spy				backport_iw_handler_set_spy
+#define iw_handler_get_spy				backport_iw_handler_get_spy
+#define iw_handler_set_thrspy				backport_iw_handler_set_thrspy
+#define iw_handler_get_thrspy				backport_iw_handler_get_thrspy
+#define wireless_spy_update				backport_wireless_spy_update
+#define cfg80211_wext_giwname				backport_cfg80211_wext_giwname
+#define cfg80211_wext_siwmode				backport_cfg80211_wext_siwmode
+#define cfg80211_wext_giwmode				backport_cfg80211_wext_giwmode
+#define cfg80211_wext_giwrange				backport_cfg80211_wext_giwrange
+#define cfg80211_wext_siwrts				backport_cfg80211_wext_siwrts
+#define cfg80211_wext_giwrts				backport_cfg80211_wext_giwrts
+#define cfg80211_wext_siwfrag				backport_cfg80211_wext_siwfrag
+#define cfg80211_wext_giwfrag				backport_cfg80211_wext_giwfrag
+#define cfg80211_wext_siwretry				backport_cfg80211_wext_siwretry
+#define cfg80211_wext_giwretry				backport_cfg80211_wext_giwretry
+#define cfg80211_wext_siwencode				backport_cfg80211_wext_siwencode
+#define cfg80211_wext_siwencodeext			backport_cfg80211_wext_siwencodeext
+#define cfg80211_wext_giwencode				backport_cfg80211_wext_giwencode
+#define cfg80211_wext_siwfreq				backport_cfg80211_wext_siwfreq
+#define cfg80211_wext_giwfreq				backport_cfg80211_wext_giwfreq
+#define cfg80211_wext_siwtxpower			backport_cfg80211_wext_siwtxpower
+#define cfg80211_wext_giwtxpower			backport_cfg80211_wext_giwtxpower
+#define cfg80211_wext_siwauth				backport_cfg80211_wext_siwauth
+#define cfg80211_wext_giwauth				backport_cfg80211_wext_giwauth
+#define cfg80211_wext_siwpower				backport_cfg80211_wext_siwpower
+#define cfg80211_wext_giwpower				backport_cfg80211_wext_giwpower
+#define cfg80211_wext_siwrate				backport_cfg80211_wext_siwrate
+#define cfg80211_wext_giwrate				backport_cfg80211_wext_giwrate
+#define cfg80211_wireless_stats				backport_cfg80211_wireless_stats
+#define cfg80211_wext_siwap				backport_cfg80211_wext_siwap
+#define cfg80211_wext_giwap				backport_cfg80211_wext_giwap
+#define cfg80211_wext_siwessid				backport_cfg80211_wext_siwessid
+#define cfg80211_wext_giwessid				backport_cfg80211_wext_giwessid
+#define cfg80211_wext_siwgenie				backport_cfg80211_wext_siwgenie
+#define cfg80211_wext_siwmlme				backport_cfg80211_wext_siwmlme
+
+/* mac80211 */
+
+#define ieee80211_start_tx_ba_session			backport_ieee80211_start_tx_ba_session
+#define ieee80211_start_tx_ba_cb			backport_ieee80211_start_tx_ba_cb
+#define ieee80211_start_tx_ba_cb_irqsafe		backport_ieee80211_start_tx_ba_cb_irqsafe
+#define ieee80211_stop_tx_ba_session			backport_ieee80211_stop_tx_ba_session
+#define ieee80211_stop_tx_ba_cb				backport_ieee80211_stop_tx_ba_cb
+#define ieee80211_stop_tx_ba_cb_irqsafe			backport_ieee80211_stop_tx_ba_cb_irqsafe
+#define __ieee80211_get_radio_led_name			backport___ieee80211_get_radio_led_name
+#define __ieee80211_get_assoc_led_name			backport___ieee80211_get_assoc_led_name
+#define __ieee80211_get_tx_led_name			backport___ieee80211_get_tx_led_name
+#define __ieee80211_get_rx_led_name			backport___ieee80211_get_rx_led_name
+#define ieee80211_tx_status_irqsafe			backport_ieee80211_tx_status_irqsafe
+#define ieee80211_tx_status				backport_ieee80211_tx_status
+#define ieee80211_restart_hw				backport_ieee80211_restart_hw
+#define ieee80211_alloc_hw				backport_ieee80211_alloc_hw
+#define ieee80211_register_hw				backport_ieee80211_register_hw
+#define ieee80211_unregister_hw				backport_ieee80211_unregister_hw
+#define ieee80211_free_hw				backport_ieee80211_free_hw
+#define ieee80211_beacon_loss				backport_ieee80211_beacon_loss
+#define ieee80211_rate_control_register			backport_ieee80211_rate_control_register
+#define ieee80211_rate_control_unregister		backport_ieee80211_rate_control_unregister
+#define rate_control_send_low				backport_rate_control_send_low
+#define ieee80211_rx					backport_ieee80211_rx
+#define ieee80211_rx_irqsafe				backport_ieee80211_rx_irqsafe
+#define ieee80211_scan_completed			backport_ieee80211_scan_completed
+#define ieee80211_find_sta				backport_ieee80211_find_sta
+#define ieee80211_get_tkip_key				backport_ieee80211_get_tkip_key
+#define ieee80211_beacon_get				backport_ieee80211_beacon_get
+#define ieee80211_rts_get				backport_ieee80211_rts_get
+#define ieee80211_ctstoself_get				backport_ieee80211_ctstoself_get
+#define ieee80211_get_buffered_bc			backport_ieee80211_get_buffered_bc
+#define wiphy_to_ieee80211_hw				backport_wiphy_to_ieee80211_hw
+#define ieee80211_generic_frame_duration		backport_ieee80211_generic_frame_duration
+#define ieee80211_rts_duration				backport_ieee80211_rts_duration
+#define ieee80211_ctstoself_duration			backport_ieee80211_ctstoself_duration
+#define ieee80211_wake_queue				backport_ieee80211_wake_queue
+#define ieee80211_stop_queue				backport_ieee80211_stop_queue
+#define ieee80211_stop_queues				backport_ieee80211_stop_queues
+#define ieee80211_queue_stopped				backport_ieee80211_queue_stopped
+#define ieee80211_wake_queues				backport_ieee80211_wake_queues
+#define ieee80211_iterate_active_interfaces		backport_ieee80211_iterate_active_interfaces
+#define ieee80211_iterate_active_interfaces_atomic	backport_ieee80211_iterate_active_interfaces_atomic
+#define ieee80211_queue_work				backport_ieee80211_queue_work
+#define ieee80211_queue_delayed_work			backport_ieee80211_queue_delayed_work
+
+#endif /* CONFIG_COMPAT_WIRELESS_MANGLE */
+
+/* Atheros */
+
+#define ath_regd_init					backport_ath_regd_init
+#define ath_is_world_regd				backport_ath_is_world_regd
+#define ath_reg_notifier_apply				backport_ath_reg_notifier_apply
+#define ath_regd_get_band_ctl				backport_ath_regd_get_band_ctl
+#define ath_hw_setbssidmask				backport_ath_hw_setbssidmask
+
 #endif /* LINUX_26_COMPAT_H */
diff --git a/config.mk b/config.mk
index b482b68..2de37a1 100644
--- a/config.mk
+++ b/config.mk
@@ -4,6 +4,8 @@ export
 ## Make sure to have each variable declaration start
 ## in the first column, no whitespace allowed.
 
+CONFIG_COMPAT_WIRELESS_MANGLE=y
+
 ifeq ($(wildcard $(KLIB_BUILD)/.config),)
 # These will be ignored by compat autoconf
  CONFIG_PCI=y
