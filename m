Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34341 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750846AbcJKNPC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Oct 2016 09:15:02 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] docs-rst: sphinxify 802.11 documentation
Date: Tue, 11 Oct 2016 14:56:53 +0200
Message-Id: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net> (sfid-20161011_151523_491883_72A17CEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is just a very basic conversion, I've split up the original
multi-book template, and also split up the multi-part mac80211
part in the original book; neither of those were handled by the
automatic pandoc conversion.

Fix errors that showed up, resulting in a much nicer rendering,
at least for the interface combinations documentation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Jon, unless you have strong objections, I'd like to take this
through my tree due to the header file changes.
---
 Documentation/80211/cfg80211.rst          | 345 ++++++++++++++++++
 Documentation/80211/conf.py               |   5 +
 Documentation/80211/index.rst             |  17 +
 Documentation/80211/introduction.rst      |  17 +
 Documentation/80211/mac80211-advanced.rst | 295 +++++++++++++++
 Documentation/80211/mac80211.rst          | 216 +++++++++++
 Documentation/DocBook/80211.tmpl          | 584 ------------------------------
 Documentation/DocBook/Makefile            |   2 +-
 Documentation/index.rst                   |   1 +
 include/net/cfg80211.h                    |  77 ++--
 10 files changed, 939 insertions(+), 620 deletions(-)
 create mode 100644 Documentation/80211/cfg80211.rst
 create mode 100644 Documentation/80211/conf.py
 create mode 100644 Documentation/80211/index.rst
 create mode 100644 Documentation/80211/introduction.rst
 create mode 100644 Documentation/80211/mac80211-advanced.rst
 create mode 100644 Documentation/80211/mac80211.rst
 delete mode 100644 Documentation/DocBook/80211.tmpl

diff --git a/Documentation/80211/cfg80211.rst b/Documentation/80211/cfg80211.rst
new file mode 100644
index 000000000000..b1e149ea6fee
--- /dev/null
+++ b/Documentation/80211/cfg80211.rst
@@ -0,0 +1,345 @@
+==================
+cfg80211 subsystem
+==================
+
+Device registration
+===================
+
+.. kernel-doc:: include/net/cfg80211.h
+   :doc: Device registration
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_channel_flags
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_channel
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_rate_flags
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_rate
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_sta_ht_cap
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_supported_band
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_signal_type
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: wiphy_params_flags
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: wiphy_flags
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: wiphy
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: wireless_dev
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: wiphy_new
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: wiphy_register
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: wiphy_unregister
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: wiphy_free
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: wiphy_name
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: wiphy_dev
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: wiphy_priv
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: priv_to_wiphy
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: set_wiphy_dev
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: wdev_priv
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_iface_limit
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_iface_combination
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_check_combinations
+
+Actions and configuration
+=========================
+
+.. kernel-doc:: include/net/cfg80211.h
+   :doc: Actions and configuration
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_ops
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: vif_params
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: key_params
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: survey_info_flags
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: survey_info
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_beacon_data
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_ap_settings
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: station_parameters
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: rate_info_flags
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: rate_info
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: station_info
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: monitor_flags
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: mpath_info_flags
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: mpath_info
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: bss_parameters
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_txq_params
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_crypto_settings
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_auth_request
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_assoc_request
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_deauth_request
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_disassoc_request
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_ibss_params
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_connect_params
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_pmksa
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_rx_mlme_mgmt
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_auth_timeout
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_rx_assoc_resp
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_assoc_timeout
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_tx_mlme_mgmt
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_ibss_joined
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_connect_result
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_connect_bss
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_connect_timeout
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_roamed
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_disconnected
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_ready_on_channel
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_remain_on_channel_expired
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_new_sta
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_rx_mgmt
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_mgmt_tx_status
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_cqm_rssi_notify
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_cqm_pktloss_notify
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_michael_mic_failure
+
+Scanning and BSS list handling
+==============================
+
+.. kernel-doc:: include/net/cfg80211.h
+   :doc: Scanning and BSS list handling
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_ssid
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_scan_request
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_scan_done
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_bss
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_inform_bss
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_inform_bss_frame_data
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_inform_bss_data
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_unlink_bss
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_find_ie
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_bss_get_ie
+
+Utility functions
+=================
+
+.. kernel-doc:: include/net/cfg80211.h
+   :doc: Utility functions
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_channel_to_frequency
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_frequency_to_channel
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_get_channel
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_get_response_rate
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_hdrlen
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_get_hdrlen_from_skb
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_radiotap_iterator
+
+Data path helpers
+=================
+
+.. kernel-doc:: include/net/cfg80211.h
+   :doc: Data path helpers
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_data_to_8023
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_data_from_8023
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: ieee80211_amsdu_to_8023s
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_classify8021d
+
+Regulatory enforcement infrastructure
+=====================================
+
+.. kernel-doc:: include/net/cfg80211.h
+   :doc: Regulatory enforcement infrastructure
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: regulatory_hint
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: wiphy_apply_custom_regulatory
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: freq_reg_info
+
+RFkill integration
+==================
+
+.. kernel-doc:: include/net/cfg80211.h
+   :doc: RFkill integration
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: wiphy_rfkill_set_hw_state
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: wiphy_rfkill_start_polling
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: wiphy_rfkill_stop_polling
+
+Test mode
+=========
+
+.. kernel-doc:: include/net/cfg80211.h
+   :doc: Test mode
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_testmode_alloc_reply_skb
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_testmode_reply
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_testmode_alloc_event_skb
+
+.. kernel-doc:: include/net/cfg80211.h
+   :functions: cfg80211_testmode_event
diff --git a/Documentation/80211/conf.py b/Documentation/80211/conf.py
new file mode 100644
index 000000000000..20c7c275ef4a
--- /dev/null
+++ b/Documentation/80211/conf.py
@@ -0,0 +1,5 @@
+# -*- coding: utf-8; mode: python -*-
+
+project = "Linux 802.11 Driver Developer's Guide"
+
+tags.add("subproject")
diff --git a/Documentation/80211/index.rst b/Documentation/80211/index.rst
new file mode 100644
index 000000000000..90bba476f442
--- /dev/null
+++ b/Documentation/80211/index.rst
@@ -0,0 +1,17 @@
+=====================================
+Linux 802.11 Driver Developer's Guide
+=====================================
+
+.. toctree::
+
+   introduction
+   cfg80211
+   mac80211
+   mac80211-advanced
+
+.. only::  subproject
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/80211/introduction.rst b/Documentation/80211/introduction.rst
new file mode 100644
index 000000000000..4938fa87691c
--- /dev/null
+++ b/Documentation/80211/introduction.rst
@@ -0,0 +1,17 @@
+============
+Introduction
+============
+
+Explaining wireless 802.11 networking in the Linux kernel
+
+Copyright 2007-2009 Johannes Berg
+
+These books attempt to give a description of the various subsystems
+that play a role in 802.11 wireless networking in Linux. Since these
+books are for kernel developers they attempts to document the
+structures and functions used in the kernel as well as giving a
+higher-level overview.
+
+The reader is expected to be familiar with the 802.11 standard as
+published by the IEEE in 802.11-2007 (or possibly later versions).
+References to this standard will be given as "802.11-2007 8.1.5".
diff --git a/Documentation/80211/mac80211-advanced.rst b/Documentation/80211/mac80211-advanced.rst
new file mode 100644
index 000000000000..70a89b2163c2
--- /dev/null
+++ b/Documentation/80211/mac80211-advanced.rst
@@ -0,0 +1,295 @@
+=============================
+mac80211 subsystem (advanced)
+=============================
+
+Information contained within this part of the book is of interest only
+for advanced interaction of mac80211 with drivers to exploit more
+hardware capabilities and improve performance.
+
+LED support
+===========
+
+Mac80211 supports various ways of blinking LEDs. Wherever possible,
+device LEDs should be exposed as LED class devices and hooked up to the
+appropriate trigger, which will then be triggered appropriately by
+mac80211.
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_get_tx_led_name
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_get_rx_led_name
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_get_assoc_led_name
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_get_radio_led_name
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_tpt_blink
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_tpt_led_trigger_flags
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_create_tpt_led_trigger
+
+Hardware crypto acceleration
+============================
+
+.. kernel-doc:: include/net/mac80211.h
+   :doc: Hardware crypto acceleration
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: set_key_cmd
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_key_conf
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_key_flags
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_get_tkip_p1k
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_get_tkip_p1k_iv
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_get_tkip_p2k
+
+Powersave support
+=================
+
+.. kernel-doc:: include/net/mac80211.h
+   :doc: Powersave support
+
+Beacon filter support
+=====================
+
+.. kernel-doc:: include/net/mac80211.h
+   :doc: Beacon filter support
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_beacon_loss
+
+Multiple queues and QoS support
+===============================
+
+TBD
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_tx_queue_params
+
+Access point mode support
+=========================
+
+TBD
+
+Some parts of the if_conf should be discussed here instead
+
+Insert notes about VLAN interfaces with hw crypto here or in the hw
+crypto chapter.
+
+support for powersaving clients
+-------------------------------
+
+.. kernel-doc:: include/net/mac80211.h
+   :doc: AP support for powersaving clients
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_get_buffered_bc
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_beacon_get
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_sta_eosp
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_frame_release_type
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_sta_ps_transition
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_sta_ps_transition_ni
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_sta_set_buffered
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_sta_block_awake
+
+Supporting multiple virtual interfaces
+======================================
+
+TBD
+
+Note: WDS with identical MAC address should almost always be OK
+
+Insert notes about having multiple virtual interfaces with different MAC
+addresses here, note which configurations are supported by mac80211, add
+notes about supporting hw crypto with it.
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_iterate_active_interfaces
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_iterate_active_interfaces_atomic
+
+Station handling
+================
+
+TODO
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_sta
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: sta_notify_cmd
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_find_sta
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_find_sta_by_ifaddr
+
+Hardware scan offload
+=====================
+
+TBD
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_scan_completed
+
+Aggregation
+===========
+
+TX A-MPDU aggregation
+---------------------
+
+.. kernel-doc:: net/mac80211/agg-tx.c
+   :doc: TX A-MPDU aggregation
+
+.. WARNING: DOCPROC directive not supported: !Cnet/mac80211/agg-tx.c
+
+RX A-MPDU aggregation
+---------------------
+
+.. kernel-doc:: net/mac80211/agg-rx.c
+   :doc: RX A-MPDU aggregation
+
+.. WARNING: DOCPROC directive not supported: !Cnet/mac80211/agg-rx.c
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_ampdu_mlme_action
+
+Spatial Multiplexing Powersave (SMPS)
+=====================================
+
+.. kernel-doc:: include/net/mac80211.h
+   :doc: Spatial multiplexing power save
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_request_smps
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_smps_mode
+
+TBD
+
+This part of the book describes the rate control algorithm interface and
+how it relates to mac80211 and drivers.
+
+Rate Control API
+================
+
+TBD
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_start_tx_ba_session
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_start_tx_ba_cb_irqsafe
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_stop_tx_ba_session
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_stop_tx_ba_cb_irqsafe
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_rate_control_changed
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_tx_rate_control
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: rate_control_send_low
+
+TBD
+
+This part of the book describes mac80211 internals.
+
+Key handling
+============
+
+Key handling basics
+-------------------
+
+.. kernel-doc:: net/mac80211/key.c
+   :doc: Key handling basics
+
+MORE TBD
+--------
+
+TBD
+
+Receive processing
+==================
+
+TBD
+
+Transmit processing
+===================
+
+TBD
+
+Station info handling
+=====================
+
+Programming information
+-----------------------
+
+.. kernel-doc:: net/mac80211/sta_info.h
+   :functions: sta_info
+
+.. kernel-doc:: net/mac80211/sta_info.h
+   :functions: ieee80211_sta_info_flags
+
+STA information lifetime rules
+------------------------------
+
+.. kernel-doc:: net/mac80211/sta_info.c
+   :doc: STA information lifetime rules
+
+Aggregation
+===========
+
+.. kernel-doc:: net/mac80211/sta_info.h
+   :functions: sta_ampdu_mlme
+
+.. kernel-doc:: net/mac80211/sta_info.h
+   :functions: tid_ampdu_tx
+
+.. kernel-doc:: net/mac80211/sta_info.h
+   :functions: tid_ampdu_rx
+
+Synchronisation
+===============
+
+TBD
+
+Locking, lots of RCU
diff --git a/Documentation/80211/mac80211.rst b/Documentation/80211/mac80211.rst
new file mode 100644
index 000000000000..85a8335e80b6
--- /dev/null
+++ b/Documentation/80211/mac80211.rst
@@ -0,0 +1,216 @@
+===========================
+mac80211 subsystem (basics)
+===========================
+
+You should read and understand the information contained within this
+part of the book while implementing a mac80211 driver. In some chapters,
+advanced usage is noted, those may be skipped if this isn't needed.
+
+This part of the book only covers station and monitor mode
+functionality, additional information required to implement the other
+modes is covered in the second part of the book.
+
+Basic hardware handling
+=======================
+
+TBD
+
+This chapter shall contain information on getting a hw struct allocated
+and registered with mac80211.
+
+Since it is required to allocate rates/modes before registering a hw
+struct, this chapter shall also contain information on setting up the
+rate/mode structs.
+
+Additionally, some discussion about the callbacks and the general
+programming model should be in here, including the definition of
+ieee80211_ops which will be referred to a lot.
+
+Finally, a discussion of hardware capabilities should be done with
+references to other parts of the book.
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_hw
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_hw_flags
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: SET_IEEE80211_DEV
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: SET_IEEE80211_PERM_ADDR
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_ops
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_alloc_hw
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_register_hw
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_unregister_hw
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_free_hw
+
+PHY configuration
+=================
+
+TBD
+
+This chapter should describe PHY handling including start/stop callbacks
+and the various structures used.
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_conf
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_conf_flags
+
+Virtual interfaces
+==================
+
+TBD
+
+This chapter should describe virtual interface basics that are relevant
+to the driver (VLANs, MGMT etc are not.) It should explain the use of
+the add_iface/remove_iface callbacks as well as the interface
+configuration callbacks.
+
+Things related to AP mode should be discussed there.
+
+Things related to supporting multiple interfaces should be in the
+appropriate chapter, a BIG FAT note should be here about this though and
+the recommendation to allow only a single interface in STA mode at
+first!
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_vif
+
+Receive and transmit processing
+===============================
+
+what should be here
+-------------------
+
+TBD
+
+This should describe the receive and transmit paths in mac80211/the
+drivers as well as transmit status handling.
+
+Frame format
+------------
+
+.. kernel-doc:: include/net/mac80211.h
+   :doc: Frame format
+
+Packet alignment
+----------------
+
+.. kernel-doc:: net/mac80211/rx.c
+   :doc: Packet alignment
+
+Calling into mac80211 from interrupts
+-------------------------------------
+
+.. kernel-doc:: include/net/mac80211.h
+   :doc: Calling mac80211 from interrupts
+
+functions/definitions
+---------------------
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_rx_status
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: mac80211_rx_flags
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: mac80211_tx_info_flags
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: mac80211_tx_control_flags
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: mac80211_rate_control_flags
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_tx_rate
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_tx_info
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_tx_info_clear_status
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_rx
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_rx_ni
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_rx_irqsafe
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_tx_status
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_tx_status_ni
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_tx_status_irqsafe
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_rts_get
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_rts_duration
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_ctstoself_get
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_ctstoself_duration
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_generic_frame_duration
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_wake_queue
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_stop_queue
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_wake_queues
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_stop_queues
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_queue_stopped
+
+Frame filtering
+===============
+
+.. kernel-doc:: include/net/mac80211.h
+   :doc: Frame filtering
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_filter_flags
+
+The mac80211 workqueue
+======================
+
+.. kernel-doc:: include/net/mac80211.h
+   :doc: mac80211 workqueue
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_queue_work
+
+.. kernel-doc:: include/net/mac80211.h
+   :functions: ieee80211_queue_delayed_work
diff --git a/Documentation/DocBook/80211.tmpl b/Documentation/DocBook/80211.tmpl
deleted file mode 100644
index 800fe7a9024c..000000000000
--- a/Documentation/DocBook/80211.tmpl
+++ /dev/null
@@ -1,584 +0,0 @@
-<?xml version="1.0" encoding="UTF-8"?>
-<!DOCTYPE set PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
-	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" []>
-<set>
-  <setinfo>
-    <title>The 802.11 subsystems &ndash; for kernel developers</title>
-    <subtitle>
-      Explaining wireless 802.11 networking in the Linux kernel
-    </subtitle>
-
-    <copyright>
-      <year>2007-2009</year>
-      <holder>Johannes Berg</holder>
-    </copyright>
-
-    <authorgroup>
-      <author>
-        <firstname>Johannes</firstname>
-        <surname>Berg</surname>
-        <affiliation>
-          <address><email>johannes@sipsolutions.net</email></address>
-        </affiliation>
-      </author>
-    </authorgroup>
-
-    <legalnotice>
-      <para>
-        This documentation is free software; you can redistribute
-        it and/or modify it under the terms of the GNU General Public
-        License version 2 as published by the Free Software Foundation.
-      </para>
-      <para>
-        This documentation is distributed in the hope that it will be
-        useful, but WITHOUT ANY WARRANTY; without even the implied
-        warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-        See the GNU General Public License for more details.
-      </para>
-      <para>
-        You should have received a copy of the GNU General Public
-        License along with this documentation; if not, write to the Free
-        Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
-        MA 02111-1307 USA
-      </para>
-      <para>
-        For more details see the file COPYING in the source
-        distribution of Linux.
-      </para>
-    </legalnotice>
-
-    <abstract>
-      <para>
-        These books attempt to give a description of the
-        various subsystems that play a role in 802.11 wireless
-        networking in Linux. Since these books are for kernel
-        developers they attempts to document the structures
-        and functions used in the kernel as well as giving a
-        higher-level overview.
-      </para>
-      <para>
-	The reader is expected to be familiar with the 802.11
-	standard as published by the IEEE in 802.11-2007 (or
-	possibly later versions). References to this standard
-	will be given as "802.11-2007 8.1.5".
-      </para>
-    </abstract>
-  </setinfo>
-  <book id="cfg80211-developers-guide">
-    <bookinfo>
-      <title>The cfg80211 subsystem</title>
-
-      <abstract>
-!Pinclude/net/cfg80211.h Introduction
-      </abstract>
-    </bookinfo>
-      <chapter>
-      <title>Device registration</title>
-!Pinclude/net/cfg80211.h Device registration
-!Finclude/net/cfg80211.h ieee80211_channel_flags
-!Finclude/net/cfg80211.h ieee80211_channel
-!Finclude/net/cfg80211.h ieee80211_rate_flags
-!Finclude/net/cfg80211.h ieee80211_rate
-!Finclude/net/cfg80211.h ieee80211_sta_ht_cap
-!Finclude/net/cfg80211.h ieee80211_supported_band
-!Finclude/net/cfg80211.h cfg80211_signal_type
-!Finclude/net/cfg80211.h wiphy_params_flags
-!Finclude/net/cfg80211.h wiphy_flags
-!Finclude/net/cfg80211.h wiphy
-!Finclude/net/cfg80211.h wireless_dev
-!Finclude/net/cfg80211.h wiphy_new
-!Finclude/net/cfg80211.h wiphy_register
-!Finclude/net/cfg80211.h wiphy_unregister
-!Finclude/net/cfg80211.h wiphy_free
-
-!Finclude/net/cfg80211.h wiphy_name
-!Finclude/net/cfg80211.h wiphy_dev
-!Finclude/net/cfg80211.h wiphy_priv
-!Finclude/net/cfg80211.h priv_to_wiphy
-!Finclude/net/cfg80211.h set_wiphy_dev
-!Finclude/net/cfg80211.h wdev_priv
-!Finclude/net/cfg80211.h ieee80211_iface_limit
-!Finclude/net/cfg80211.h ieee80211_iface_combination
-!Finclude/net/cfg80211.h cfg80211_check_combinations
-      </chapter>
-      <chapter>
-      <title>Actions and configuration</title>
-!Pinclude/net/cfg80211.h Actions and configuration
-!Finclude/net/cfg80211.h cfg80211_ops
-!Finclude/net/cfg80211.h vif_params
-!Finclude/net/cfg80211.h key_params
-!Finclude/net/cfg80211.h survey_info_flags
-!Finclude/net/cfg80211.h survey_info
-!Finclude/net/cfg80211.h cfg80211_beacon_data
-!Finclude/net/cfg80211.h cfg80211_ap_settings
-!Finclude/net/cfg80211.h station_parameters
-!Finclude/net/cfg80211.h rate_info_flags
-!Finclude/net/cfg80211.h rate_info
-!Finclude/net/cfg80211.h station_info
-!Finclude/net/cfg80211.h monitor_flags
-!Finclude/net/cfg80211.h mpath_info_flags
-!Finclude/net/cfg80211.h mpath_info
-!Finclude/net/cfg80211.h bss_parameters
-!Finclude/net/cfg80211.h ieee80211_txq_params
-!Finclude/net/cfg80211.h cfg80211_crypto_settings
-!Finclude/net/cfg80211.h cfg80211_auth_request
-!Finclude/net/cfg80211.h cfg80211_assoc_request
-!Finclude/net/cfg80211.h cfg80211_deauth_request
-!Finclude/net/cfg80211.h cfg80211_disassoc_request
-!Finclude/net/cfg80211.h cfg80211_ibss_params
-!Finclude/net/cfg80211.h cfg80211_connect_params
-!Finclude/net/cfg80211.h cfg80211_pmksa
-!Finclude/net/cfg80211.h cfg80211_rx_mlme_mgmt
-!Finclude/net/cfg80211.h cfg80211_auth_timeout
-!Finclude/net/cfg80211.h cfg80211_rx_assoc_resp
-!Finclude/net/cfg80211.h cfg80211_assoc_timeout
-!Finclude/net/cfg80211.h cfg80211_tx_mlme_mgmt
-!Finclude/net/cfg80211.h cfg80211_ibss_joined
-!Finclude/net/cfg80211.h cfg80211_connect_result
-!Finclude/net/cfg80211.h cfg80211_connect_bss
-!Finclude/net/cfg80211.h cfg80211_connect_timeout
-!Finclude/net/cfg80211.h cfg80211_roamed
-!Finclude/net/cfg80211.h cfg80211_disconnected
-!Finclude/net/cfg80211.h cfg80211_ready_on_channel
-!Finclude/net/cfg80211.h cfg80211_remain_on_channel_expired
-!Finclude/net/cfg80211.h cfg80211_new_sta
-!Finclude/net/cfg80211.h cfg80211_rx_mgmt
-!Finclude/net/cfg80211.h cfg80211_mgmt_tx_status
-!Finclude/net/cfg80211.h cfg80211_cqm_rssi_notify
-!Finclude/net/cfg80211.h cfg80211_cqm_pktloss_notify
-!Finclude/net/cfg80211.h cfg80211_michael_mic_failure
-      </chapter>
-      <chapter>
-      <title>Scanning and BSS list handling</title>
-!Pinclude/net/cfg80211.h Scanning and BSS list handling
-!Finclude/net/cfg80211.h cfg80211_ssid
-!Finclude/net/cfg80211.h cfg80211_scan_request
-!Finclude/net/cfg80211.h cfg80211_scan_done
-!Finclude/net/cfg80211.h cfg80211_bss
-!Finclude/net/cfg80211.h cfg80211_inform_bss
-!Finclude/net/cfg80211.h cfg80211_inform_bss_frame_data
-!Finclude/net/cfg80211.h cfg80211_inform_bss_data
-!Finclude/net/cfg80211.h cfg80211_unlink_bss
-!Finclude/net/cfg80211.h cfg80211_find_ie
-!Finclude/net/cfg80211.h ieee80211_bss_get_ie
-      </chapter>
-      <chapter>
-      <title>Utility functions</title>
-!Pinclude/net/cfg80211.h Utility functions
-!Finclude/net/cfg80211.h ieee80211_channel_to_frequency
-!Finclude/net/cfg80211.h ieee80211_frequency_to_channel
-!Finclude/net/cfg80211.h ieee80211_get_channel
-!Finclude/net/cfg80211.h ieee80211_get_response_rate
-!Finclude/net/cfg80211.h ieee80211_hdrlen
-!Finclude/net/cfg80211.h ieee80211_get_hdrlen_from_skb
-!Finclude/net/cfg80211.h ieee80211_radiotap_iterator
-      </chapter>
-      <chapter>
-      <title>Data path helpers</title>
-!Pinclude/net/cfg80211.h Data path helpers
-!Finclude/net/cfg80211.h ieee80211_data_to_8023
-!Finclude/net/cfg80211.h ieee80211_data_from_8023
-!Finclude/net/cfg80211.h ieee80211_amsdu_to_8023s
-!Finclude/net/cfg80211.h cfg80211_classify8021d
-      </chapter>
-      <chapter>
-      <title>Regulatory enforcement infrastructure</title>
-!Pinclude/net/cfg80211.h Regulatory enforcement infrastructure
-!Finclude/net/cfg80211.h regulatory_hint
-!Finclude/net/cfg80211.h wiphy_apply_custom_regulatory
-!Finclude/net/cfg80211.h freq_reg_info
-      </chapter>
-      <chapter>
-      <title>RFkill integration</title>
-!Pinclude/net/cfg80211.h RFkill integration
-!Finclude/net/cfg80211.h wiphy_rfkill_set_hw_state
-!Finclude/net/cfg80211.h wiphy_rfkill_start_polling
-!Finclude/net/cfg80211.h wiphy_rfkill_stop_polling
-      </chapter>
-      <chapter>
-      <title>Test mode</title>
-!Pinclude/net/cfg80211.h Test mode
-!Finclude/net/cfg80211.h cfg80211_testmode_alloc_reply_skb
-!Finclude/net/cfg80211.h cfg80211_testmode_reply
-!Finclude/net/cfg80211.h cfg80211_testmode_alloc_event_skb
-!Finclude/net/cfg80211.h cfg80211_testmode_event
-      </chapter>
-  </book>
-  <book id="mac80211-developers-guide">
-    <bookinfo>
-      <title>The mac80211 subsystem</title>
-      <abstract>
-!Pinclude/net/mac80211.h Introduction
-!Pinclude/net/mac80211.h Warning
-      </abstract>
-    </bookinfo>
-
-    <toc></toc>
-
-  <!--
-  Generally, this document shall be ordered by increasing complexity.
-  It is important to note that readers should be able to read only
-  the first few sections to get a working driver and only advanced
-  usage should require reading the full document.
-  -->
-
-    <part>
-      <title>The basic mac80211 driver interface</title>
-      <partintro>
-        <para>
-          You should read and understand the information contained
-          within this part of the book while implementing a driver.
-          In some chapters, advanced usage is noted, that may be
-          skipped at first.
-        </para>
-        <para>
-          This part of the book only covers station and monitor mode
-          functionality, additional information required to implement
-          the other modes is covered in the second part of the book.
-        </para>
-      </partintro>
-
-      <chapter id="basics">
-        <title>Basic hardware handling</title>
-        <para>TBD</para>
-        <para>
-          This chapter shall contain information on getting a hw
-          struct allocated and registered with mac80211.
-        </para>
-        <para>
-          Since it is required to allocate rates/modes before registering
-          a hw struct, this chapter shall also contain information on setting
-          up the rate/mode structs.
-        </para>
-        <para>
-          Additionally, some discussion about the callbacks and
-          the general programming model should be in here, including
-          the definition of ieee80211_ops which will be referred to
-          a lot.
-        </para>
-        <para>
-          Finally, a discussion of hardware capabilities should be done
-          with references to other parts of the book.
-        </para>
-  <!-- intentionally multiple !F lines to get proper order -->
-!Finclude/net/mac80211.h ieee80211_hw
-!Finclude/net/mac80211.h ieee80211_hw_flags
-!Finclude/net/mac80211.h SET_IEEE80211_DEV
-!Finclude/net/mac80211.h SET_IEEE80211_PERM_ADDR
-!Finclude/net/mac80211.h ieee80211_ops
-!Finclude/net/mac80211.h ieee80211_alloc_hw
-!Finclude/net/mac80211.h ieee80211_register_hw
-!Finclude/net/mac80211.h ieee80211_unregister_hw
-!Finclude/net/mac80211.h ieee80211_free_hw
-      </chapter>
-
-      <chapter id="phy-handling">
-        <title>PHY configuration</title>
-        <para>TBD</para>
-        <para>
-          This chapter should describe PHY handling including
-          start/stop callbacks and the various structures used.
-        </para>
-!Finclude/net/mac80211.h ieee80211_conf
-!Finclude/net/mac80211.h ieee80211_conf_flags
-      </chapter>
-
-      <chapter id="iface-handling">
-        <title>Virtual interfaces</title>
-        <para>TBD</para>
-        <para>
-          This chapter should describe virtual interface basics
-          that are relevant to the driver (VLANs, MGMT etc are not.)
-          It should explain the use of the add_iface/remove_iface
-          callbacks as well as the interface configuration callbacks.
-        </para>
-        <para>Things related to AP mode should be discussed there.</para>
-        <para>
-          Things related to supporting multiple interfaces should be
-          in the appropriate chapter, a BIG FAT note should be here about
-          this though and the recommendation to allow only a single
-          interface in STA mode at first!
-        </para>
-!Finclude/net/mac80211.h ieee80211_vif
-      </chapter>
-
-      <chapter id="rx-tx">
-        <title>Receive and transmit processing</title>
-        <sect1>
-          <title>what should be here</title>
-          <para>TBD</para>
-          <para>
-            This should describe the receive and transmit
-            paths in mac80211/the drivers as well as
-            transmit status handling.
-          </para>
-        </sect1>
-        <sect1>
-          <title>Frame format</title>
-!Pinclude/net/mac80211.h Frame format
-        </sect1>
-        <sect1>
-          <title>Packet alignment</title>
-!Pnet/mac80211/rx.c Packet alignment
-        </sect1>
-        <sect1>
-          <title>Calling into mac80211 from interrupts</title>
-!Pinclude/net/mac80211.h Calling mac80211 from interrupts
-        </sect1>
-        <sect1>
-          <title>functions/definitions</title>
-!Finclude/net/mac80211.h ieee80211_rx_status
-!Finclude/net/mac80211.h mac80211_rx_flags
-!Finclude/net/mac80211.h mac80211_tx_info_flags
-!Finclude/net/mac80211.h mac80211_tx_control_flags
-!Finclude/net/mac80211.h mac80211_rate_control_flags
-!Finclude/net/mac80211.h ieee80211_tx_rate
-!Finclude/net/mac80211.h ieee80211_tx_info
-!Finclude/net/mac80211.h ieee80211_tx_info_clear_status
-!Finclude/net/mac80211.h ieee80211_rx
-!Finclude/net/mac80211.h ieee80211_rx_ni
-!Finclude/net/mac80211.h ieee80211_rx_irqsafe
-!Finclude/net/mac80211.h ieee80211_tx_status
-!Finclude/net/mac80211.h ieee80211_tx_status_ni
-!Finclude/net/mac80211.h ieee80211_tx_status_irqsafe
-!Finclude/net/mac80211.h ieee80211_rts_get
-!Finclude/net/mac80211.h ieee80211_rts_duration
-!Finclude/net/mac80211.h ieee80211_ctstoself_get
-!Finclude/net/mac80211.h ieee80211_ctstoself_duration
-!Finclude/net/mac80211.h ieee80211_generic_frame_duration
-!Finclude/net/mac80211.h ieee80211_wake_queue
-!Finclude/net/mac80211.h ieee80211_stop_queue
-!Finclude/net/mac80211.h ieee80211_wake_queues
-!Finclude/net/mac80211.h ieee80211_stop_queues
-!Finclude/net/mac80211.h ieee80211_queue_stopped
-        </sect1>
-      </chapter>
-
-      <chapter id="filters">
-        <title>Frame filtering</title>
-!Pinclude/net/mac80211.h Frame filtering
-!Finclude/net/mac80211.h ieee80211_filter_flags
-      </chapter>
-
-      <chapter id="workqueue">
-        <title>The mac80211 workqueue</title>
-!Pinclude/net/mac80211.h mac80211 workqueue
-!Finclude/net/mac80211.h ieee80211_queue_work
-!Finclude/net/mac80211.h ieee80211_queue_delayed_work
-      </chapter>
-    </part>
-
-    <part id="advanced">
-      <title>Advanced driver interface</title>
-      <partintro>
-        <para>
-         Information contained within this part of the book is
-         of interest only for advanced interaction of mac80211
-         with drivers to exploit more hardware capabilities and
-         improve performance.
-        </para>
-      </partintro>
-
-      <chapter id="led-support">
-        <title>LED support</title>
-        <para>
-         Mac80211 supports various ways of blinking LEDs. Wherever possible,
-         device LEDs should be exposed as LED class devices and hooked up to
-         the appropriate trigger, which will then be triggered appropriately
-         by mac80211.
-        </para>
-!Finclude/net/mac80211.h ieee80211_get_tx_led_name
-!Finclude/net/mac80211.h ieee80211_get_rx_led_name
-!Finclude/net/mac80211.h ieee80211_get_assoc_led_name
-!Finclude/net/mac80211.h ieee80211_get_radio_led_name
-!Finclude/net/mac80211.h ieee80211_tpt_blink
-!Finclude/net/mac80211.h ieee80211_tpt_led_trigger_flags
-!Finclude/net/mac80211.h ieee80211_create_tpt_led_trigger
-      </chapter>
-
-      <chapter id="hardware-crypto-offload">
-        <title>Hardware crypto acceleration</title>
-!Pinclude/net/mac80211.h Hardware crypto acceleration
-  <!-- intentionally multiple !F lines to get proper order -->
-!Finclude/net/mac80211.h set_key_cmd
-!Finclude/net/mac80211.h ieee80211_key_conf
-!Finclude/net/mac80211.h ieee80211_key_flags
-!Finclude/net/mac80211.h ieee80211_get_tkip_p1k
-!Finclude/net/mac80211.h ieee80211_get_tkip_p1k_iv
-!Finclude/net/mac80211.h ieee80211_get_tkip_p2k
-      </chapter>
-
-      <chapter id="powersave">
-        <title>Powersave support</title>
-!Pinclude/net/mac80211.h Powersave support
-      </chapter>
-
-      <chapter id="beacon-filter">
-        <title>Beacon filter support</title>
-!Pinclude/net/mac80211.h Beacon filter support
-!Finclude/net/mac80211.h ieee80211_beacon_loss
-      </chapter>
-
-      <chapter id="qos">
-        <title>Multiple queues and QoS support</title>
-        <para>TBD</para>
-!Finclude/net/mac80211.h ieee80211_tx_queue_params
-      </chapter>
-
-      <chapter id="AP">
-        <title>Access point mode support</title>
-        <para>TBD</para>
-        <para>Some parts of the if_conf should be discussed here instead</para>
-        <para>
-          Insert notes about VLAN interfaces with hw crypto here or
-          in the hw crypto chapter.
-        </para>
-      <section id="ps-client">
-        <title>support for powersaving clients</title>
-!Pinclude/net/mac80211.h AP support for powersaving clients
-!Finclude/net/mac80211.h ieee80211_get_buffered_bc
-!Finclude/net/mac80211.h ieee80211_beacon_get
-!Finclude/net/mac80211.h ieee80211_sta_eosp
-!Finclude/net/mac80211.h ieee80211_frame_release_type
-!Finclude/net/mac80211.h ieee80211_sta_ps_transition
-!Finclude/net/mac80211.h ieee80211_sta_ps_transition_ni
-!Finclude/net/mac80211.h ieee80211_sta_set_buffered
-!Finclude/net/mac80211.h ieee80211_sta_block_awake
-      </section>
-      </chapter>
-
-      <chapter id="multi-iface">
-        <title>Supporting multiple virtual interfaces</title>
-        <para>TBD</para>
-        <para>
-          Note: WDS with identical MAC address should almost always be OK
-        </para>
-        <para>
-          Insert notes about having multiple virtual interfaces with
-          different MAC addresses here, note which configurations are
-          supported by mac80211, add notes about supporting hw crypto
-          with it.
-        </para>
-!Finclude/net/mac80211.h ieee80211_iterate_active_interfaces
-!Finclude/net/mac80211.h ieee80211_iterate_active_interfaces_atomic
-      </chapter>
-
-      <chapter id="station-handling">
-        <title>Station handling</title>
-        <para>TODO</para>
-!Finclude/net/mac80211.h ieee80211_sta
-!Finclude/net/mac80211.h sta_notify_cmd
-!Finclude/net/mac80211.h ieee80211_find_sta
-!Finclude/net/mac80211.h ieee80211_find_sta_by_ifaddr
-      </chapter>
-
-      <chapter id="hardware-scan-offload">
-        <title>Hardware scan offload</title>
-        <para>TBD</para>
-!Finclude/net/mac80211.h ieee80211_scan_completed
-      </chapter>
-
-      <chapter id="aggregation">
-        <title>Aggregation</title>
-        <sect1>
-          <title>TX A-MPDU aggregation</title>
-!Pnet/mac80211/agg-tx.c TX A-MPDU aggregation
-!Cnet/mac80211/agg-tx.c
-        </sect1>
-        <sect1>
-          <title>RX A-MPDU aggregation</title>
-!Pnet/mac80211/agg-rx.c RX A-MPDU aggregation
-!Cnet/mac80211/agg-rx.c
-!Finclude/net/mac80211.h ieee80211_ampdu_mlme_action
-        </sect1>
-      </chapter>
-
-      <chapter id="smps">
-        <title>Spatial Multiplexing Powersave (SMPS)</title>
-!Pinclude/net/mac80211.h Spatial multiplexing power save
-!Finclude/net/mac80211.h ieee80211_request_smps
-!Finclude/net/mac80211.h ieee80211_smps_mode
-      </chapter>
-    </part>
-
-    <part id="rate-control">
-      <title>Rate control interface</title>
-      <partintro>
-        <para>TBD</para>
-        <para>
-         This part of the book describes the rate control algorithm
-         interface and how it relates to mac80211 and drivers.
-        </para>
-      </partintro>
-      <chapter id="ratecontrol-api">
-        <title>Rate Control API</title>
-        <para>TBD</para>
-!Finclude/net/mac80211.h ieee80211_start_tx_ba_session
-!Finclude/net/mac80211.h ieee80211_start_tx_ba_cb_irqsafe
-!Finclude/net/mac80211.h ieee80211_stop_tx_ba_session
-!Finclude/net/mac80211.h ieee80211_stop_tx_ba_cb_irqsafe
-!Finclude/net/mac80211.h ieee80211_rate_control_changed
-!Finclude/net/mac80211.h ieee80211_tx_rate_control
-!Finclude/net/mac80211.h rate_control_send_low
-      </chapter>
-    </part>
-
-    <part id="internal">
-      <title>Internals</title>
-      <partintro>
-        <para>TBD</para>
-        <para>
-         This part of the book describes mac80211 internals.
-        </para>
-      </partintro>
-
-      <chapter id="key-handling">
-        <title>Key handling</title>
-        <sect1>
-          <title>Key handling basics</title>
-!Pnet/mac80211/key.c Key handling basics
-        </sect1>
-        <sect1>
-          <title>MORE TBD</title>
-          <para>TBD</para>
-        </sect1>
-      </chapter>
-
-      <chapter id="rx-processing">
-        <title>Receive processing</title>
-        <para>TBD</para>
-      </chapter>
-
-      <chapter id="tx-processing">
-        <title>Transmit processing</title>
-        <para>TBD</para>
-      </chapter>
-
-      <chapter id="sta-info">
-        <title>Station info handling</title>
-        <sect1>
-          <title>Programming information</title>
-!Fnet/mac80211/sta_info.h sta_info
-!Fnet/mac80211/sta_info.h ieee80211_sta_info_flags
-        </sect1>
-        <sect1>
-          <title>STA information lifetime rules</title>
-!Pnet/mac80211/sta_info.c STA information lifetime rules
-        </sect1>
-      </chapter>
-
-      <chapter id="aggregation-internals">
-        <title>Aggregation</title>
-!Fnet/mac80211/sta_info.h sta_ampdu_mlme
-!Fnet/mac80211/sta_info.h tid_ampdu_tx
-!Fnet/mac80211/sta_info.h tid_ampdu_rx
-      </chapter>
-
-      <chapter id="synchronisation">
-        <title>Synchronisation</title>
-        <para>TBD</para>
-        <para>Locking, lots of RCU</para>
-      </chapter>
-    </part>
-  </book>
-</set>
diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 736f5916daea..fdf8232d0eeb 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -12,7 +12,7 @@ DOCBOOKS := z8530book.xml  \
 	    kernel-api.xml filesystems.xml lsm.xml usb.xml kgdb.xml \
 	    gadget.xml libata.xml mtdnand.xml librs.xml rapidio.xml \
 	    genericirq.xml s390-drivers.xml uio-howto.xml scsi.xml \
-	    80211.xml debugobjects.xml sh.xml regulator.xml \
+	    debugobjects.xml sh.xml regulator.xml \
 	    alsa-driver-api.xml writing-an-alsa-driver.xml \
 	    tracepoint.xml w1.xml \
 	    writing_musb_glue_layer.xml crypto-API.xml iio.xml
diff --git a/Documentation/index.rst b/Documentation/index.rst
index d9ccb94fca95..c53d089455a4 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -17,6 +17,7 @@ Contents:
    driver-api/index
    media/index
    gpu/index
+   80211/index
 
 Indices and tables
 ==================
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7df600c463eb..14b51d739c3b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -796,9 +796,9 @@ enum station_parameters_apply_mask {
  *	(or NULL for no change)
  * @supported_rates_len: number of supported rates
  * @sta_flags_mask: station flags that changed
- *	(bitmask of BIT(NL80211_STA_FLAG_...))
+ *	(bitmask of BIT(%NL80211_STA_FLAG_...))
  * @sta_flags_set: station flags values
- *	(bitmask of BIT(NL80211_STA_FLAG_...))
+ *	(bitmask of BIT(%NL80211_STA_FLAG_...))
  * @listen_interval: listen interval or -1 for no change
  * @aid: AID or zero for no change
  * @peer_aid: mesh peer AID or zero for no change
@@ -3088,47 +3088,54 @@ struct ieee80211_iface_limit {
  *
  * 1. Allow #STA <= 1, #AP <= 1, matching BI, channels = 1, 2 total:
  *
- *  struct ieee80211_iface_limit limits1[] = {
- *	{ .max = 1, .types = BIT(NL80211_IFTYPE_STATION), },
- *	{ .max = 1, .types = BIT(NL80211_IFTYPE_AP}, },
- *  };
- *  struct ieee80211_iface_combination combination1 = {
- *	.limits = limits1,
- *	.n_limits = ARRAY_SIZE(limits1),
- *	.max_interfaces = 2,
- *	.beacon_int_infra_match = true,
- *  };
+ *    .. code-block:: c
+ *
+ *	struct ieee80211_iface_limit limits1[] = {
+ *		{ .max = 1, .types = BIT(NL80211_IFTYPE_STATION), },
+ *		{ .max = 1, .types = BIT(NL80211_IFTYPE_AP}, },
+ *	};
+ *	struct ieee80211_iface_combination combination1 = {
+ *		.limits = limits1,
+ *		.n_limits = ARRAY_SIZE(limits1),
+ *		.max_interfaces = 2,
+ *		.beacon_int_infra_match = true,
+ *	};
  *
  *
  * 2. Allow #{AP, P2P-GO} <= 8, channels = 1, 8 total:
  *
- *  struct ieee80211_iface_limit limits2[] = {
- *	{ .max = 8, .types = BIT(NL80211_IFTYPE_AP) |
- *			     BIT(NL80211_IFTYPE_P2P_GO), },
- *  };
- *  struct ieee80211_iface_combination combination2 = {
- *	.limits = limits2,
- *	.n_limits = ARRAY_SIZE(limits2),
- *	.max_interfaces = 8,
- *	.num_different_channels = 1,
- *  };
+ *    .. code-block:: c
+ *
+ *	struct ieee80211_iface_limit limits2[] = {
+ *		{ .max = 8, .types = BIT(NL80211_IFTYPE_AP) |
+ *				     BIT(NL80211_IFTYPE_P2P_GO), },
+ *	};
+ *	struct ieee80211_iface_combination combination2 = {
+ *		.limits = limits2,
+ *		.n_limits = ARRAY_SIZE(limits2),
+ *		.max_interfaces = 8,
+ *		.num_different_channels = 1,
+ *	};
  *
  *
  * 3. Allow #STA <= 1, #{P2P-client,P2P-GO} <= 3 on two channels, 4 total.
  *
- * This allows for an infrastructure connection and three P2P connections.
- *
- *  struct ieee80211_iface_limit limits3[] = {
- *	{ .max = 1, .types = BIT(NL80211_IFTYPE_STATION), },
- *	{ .max = 3, .types = BIT(NL80211_IFTYPE_P2P_GO) |
- *			     BIT(NL80211_IFTYPE_P2P_CLIENT), },
- *  };
- *  struct ieee80211_iface_combination combination3 = {
- *	.limits = limits3,
- *	.n_limits = ARRAY_SIZE(limits3),
- *	.max_interfaces = 4,
- *	.num_different_channels = 2,
- *  };
+ *    This allows for an infrastructure connection and three P2P connections.
+ *
+ *    .. code-block:: c
+ *
+ *	struct ieee80211_iface_limit limits3[] = {
+ *		{ .max = 1, .types = BIT(NL80211_IFTYPE_STATION), },
+ *		{ .max = 3, .types = BIT(NL80211_IFTYPE_P2P_GO) |
+ *				     BIT(NL80211_IFTYPE_P2P_CLIENT), },
+ *	};
+ *	struct ieee80211_iface_combination combination3 = {
+ *		.limits = limits3,
+ *		.n_limits = ARRAY_SIZE(limits3),
+ *		.max_interfaces = 4,
+ *		.num_different_channels = 2,
+ *	};
+ *
  */
 struct ieee80211_iface_combination {
 	const struct ieee80211_iface_limit *limits;
-- 
2.8.1
