Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40890 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab0HSOL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Aug 2010 10:11:29 -0400
Subject: [PATCH v2] cfg80211: add some documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1282227014.4507.5.camel@jlt3.sipsolutions.net>
References: <1282227014.4507.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 16:11:27 +0200
Message-ID: <1282227087.4507.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add some documentation for cfg80211. I'm hoping some of
the regulatory documentation will be filled by somebody
more familiar with it, hint hint! :)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl |  136 +++++++++++++++++++++++++++++++++++++--
 include/net/cfg80211.h           |  121 ++++++++++++++++++++++++++++++++--
 2 files changed, 246 insertions(+), 11 deletions(-)

--- wireless-testing.orig/Documentation/DocBook/80211.tmpl	2010-08-19 16:10:27.000000000 +0200
+++ wireless-testing/Documentation/DocBook/80211.tmpl	2010-08-19 16:10:31.000000000 +0200
@@ -65,18 +65,144 @@
     </abstract>
   </setinfo>
   <book id="cfg80211-developers-guide">
+!Ainclude/net/cfg80211.h
     <bookinfo>
       <title>The cfg80211 subsystem</title>
 
       <abstract>
-        <para>
-MISSING
-        </para>
+!Pinclude/net/cfg80211.h Introduction
       </abstract>
     </bookinfo>
-    <part><chapter>
+      <chapter>
+      <title>Device registration</title>
+!Pinclude/net/cfg80211.h Device registration
 !Finclude/net/cfg80211.h ieee80211_band
-    </chapter></part>
+!Finclude/net/cfg80211.h ieee80211_channel_flags
+!Finclude/net/cfg80211.h ieee80211_channel
+!Finclude/net/cfg80211.h ieee80211_rate_flags
+!Finclude/net/cfg80211.h ieee80211_rate
+!Finclude/net/cfg80211.h ieee80211_sta_ht_cap
+!Finclude/net/cfg80211.h ieee80211_supported_band
+!Finclude/net/cfg80211.h cfg80211_signal_type
+!Finclude/net/cfg80211.h wiphy_params_flags
+!Finclude/net/cfg80211.h wiphy_flags
+!Finclude/net/cfg80211.h wiphy
+!Finclude/net/cfg80211.h wireless_dev
+!Finclude/net/cfg80211.h wiphy_new
+!Finclude/net/cfg80211.h wiphy_register
+!Finclude/net/cfg80211.h wiphy_unregister
+!Finclude/net/cfg80211.h wiphy_free
+
+!Finclude/net/cfg80211.h wiphy_name
+!Finclude/net/cfg80211.h wiphy_dev
+!Finclude/net/cfg80211.h wiphy_priv
+!Finclude/net/cfg80211.h priv_to_wiphy
+!Finclude/net/cfg80211.h set_wiphy_dev
+!Finclude/net/cfg80211.h wdev_priv
+      </chapter>
+      <chapter>
+      <title>Actions and configuration</title>
+!Pinclude/net/cfg80211.h Actions and configuration
+!Finclude/net/cfg80211.h cfg80211_ops
+!Finclude/net/cfg80211.h vif_params
+!Finclude/net/cfg80211.h key_params
+!Finclude/net/cfg80211.h survey_info_flags
+!Finclude/net/cfg80211.h survey_info
+!Finclude/net/cfg80211.h beacon_parameters
+!Finclude/net/cfg80211.h plink_actions
+!Finclude/net/cfg80211.h station_parameters
+!Finclude/net/cfg80211.h station_info_flags
+!Finclude/net/cfg80211.h rate_info_flags
+!Finclude/net/cfg80211.h rate_info
+!Finclude/net/cfg80211.h station_info
+!Finclude/net/cfg80211.h monitor_flags
+!Finclude/net/cfg80211.h mpath_info_flags
+!Finclude/net/cfg80211.h mpath_info
+!Finclude/net/cfg80211.h bss_parameters
+!Finclude/net/cfg80211.h ieee80211_txq_params
+!Finclude/net/cfg80211.h cfg80211_crypto_settings
+!Finclude/net/cfg80211.h cfg80211_auth_request
+!Finclude/net/cfg80211.h cfg80211_assoc_request
+!Finclude/net/cfg80211.h cfg80211_deauth_request
+!Finclude/net/cfg80211.h cfg80211_disassoc_request
+!Finclude/net/cfg80211.h cfg80211_ibss_params
+!Finclude/net/cfg80211.h cfg80211_connect_params
+!Finclude/net/cfg80211.h cfg80211_pmksa
+!Finclude/net/cfg80211.h cfg80211_send_rx_auth
+!Finclude/net/cfg80211.h cfg80211_send_auth_timeout
+!Finclude/net/cfg80211.h __cfg80211_auth_canceled
+!Finclude/net/cfg80211.h cfg80211_send_rx_assoc
+!Finclude/net/cfg80211.h cfg80211_send_assoc_timeout
+!Finclude/net/cfg80211.h cfg80211_send_deauth
+!Finclude/net/cfg80211.h __cfg80211_send_deauth
+!Finclude/net/cfg80211.h cfg80211_send_disassoc
+!Finclude/net/cfg80211.h __cfg80211_send_disassoc
+!Finclude/net/cfg80211.h cfg80211_ibss_joined
+!Finclude/net/cfg80211.h cfg80211_connect_result
+!Finclude/net/cfg80211.h cfg80211_roamed
+!Finclude/net/cfg80211.h cfg80211_disconnected
+!Finclude/net/cfg80211.h cfg80211_ready_on_channel
+!Finclude/net/cfg80211.h cfg80211_remain_on_channel_expired
+!Finclude/net/cfg80211.h cfg80211_new_sta
+!Finclude/net/cfg80211.h cfg80211_rx_mgmt
+!Finclude/net/cfg80211.h cfg80211_mgmt_tx_status
+!Finclude/net/cfg80211.h cfg80211_cqm_rssi_notify
+!Finclude/net/cfg80211.h cfg80211_michael_mic_failure
+      </chapter>
+      <chapter>
+      <title>Scanning and BSS list handling</title>
+!Pinclude/net/cfg80211.h Scanning and BSS list handling
+!Finclude/net/cfg80211.h cfg80211_ssid
+!Finclude/net/cfg80211.h cfg80211_scan_request
+!Finclude/net/cfg80211.h cfg80211_scan_done
+!Finclude/net/cfg80211.h cfg80211_bss
+!Finclude/net/cfg80211.h cfg80211_inform_bss_frame
+!Finclude/net/cfg80211.h cfg80211_inform_bss
+!Finclude/net/cfg80211.h cfg80211_unlink_bss
+!Finclude/net/cfg80211.h cfg80211_find_ie
+!Finclude/net/cfg80211.h ieee80211_bss_get_ie
+      </chapter>
+      <chapter>
+      <title>Utility functions</title>
+!Pinclude/net/cfg80211.h Utility functions
+!Finclude/net/cfg80211.h ieee80211_channel_to_frequency
+!Finclude/net/cfg80211.h ieee80211_frequency_to_channel
+!Finclude/net/cfg80211.h ieee80211_get_channel
+!Finclude/net/cfg80211.h ieee80211_get_response_rate
+!Finclude/net/cfg80211.h ieee80211_hdrlen
+!Finclude/net/cfg80211.h ieee80211_get_hdrlen_from_skb
+!Finclude/net/cfg80211.h ieee80211_radiotap_iterator
+      </chapter>
+      <chapter>
+      <title>Data path helpers</title>
+!Pinclude/net/cfg80211.h Data path helpers
+!Finclude/net/cfg80211.h ieee80211_data_to_8023
+!Finclude/net/cfg80211.h ieee80211_data_from_8023
+!Finclude/net/cfg80211.h ieee80211_amsdu_to_8023s
+!Finclude/net/cfg80211.h cfg80211_classify8021d
+      </chapter>
+      <chapter>
+      <title>Regulatory enforcement infrastructure</title>
+!Pinclude/net/cfg80211.h Regulatory enforcement infrastructure
+!Finclude/net/cfg80211.h regulatory_hint
+!Finclude/net/cfg80211.h wiphy_apply_custom_regulatory
+!Finclude/net/cfg80211.h freq_reg_info
+      </chapter>
+      <chapter>
+      <title>RFkill integration</title>
+!Pinclude/net/cfg80211.h RFkill integration
+!Finclude/net/cfg80211.h wiphy_rfkill_set_hw_state
+!Finclude/net/cfg80211.h wiphy_rfkill_start_polling
+!Finclude/net/cfg80211.h wiphy_rfkill_stop_polling
+      </chapter>
+      <chapter>
+      <title>Test mode</title>
+!Pinclude/net/cfg80211.h Test mode
+!Finclude/net/cfg80211.h cfg80211_testmode_alloc_reply_skb
+!Finclude/net/cfg80211.h cfg80211_testmode_reply
+!Finclude/net/cfg80211.h cfg80211_testmode_alloc_event_skb
+!Finclude/net/cfg80211.h cfg80211_testmode_event
+      </chapter>
   </book>
   <book id="mac80211-developers-guide">
     <bookinfo>
--- wireless-testing.orig/include/net/cfg80211.h	2010-08-19 16:10:27.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2010-08-19 16:10:31.000000000 +0200
@@ -25,6 +25,43 @@
 #include <linux/wireless.h>
 
 
+/**
+ * DOC: Introduction
+ *
+ * cfg80211 is the configuration API for 802.11 devices in Linux. It bridges
+ * userspace and drivers, and offers some utility functionality associated
+ * with 802.11. cfg80211 must, directly or indirectly via mac80211, be used
+ * by all modern wireless drivers in Linux, so that they offer a consistent
+ * API through nl80211. For backward compatibility, cfg80211 also offers
+ * wireless extensions to userspace, but hides them from drivers completely.
+ *
+ * Additionally, cfg80211 contains code to help enforce regulatory spectrum
+ * use restrictions.
+ */
+
+
+/**
+ * DOC: Device registration
+ *
+ * In order for a driver to use cfg80211, it must register the hardware device
+ * with cfg80211. This happens through a number of hardware capability structs
+ * described below.
+ *
+ * The fundamental structure for each device is the 'wiphy', of which each
+ * instance describes a physical wireless device connected to the system. Each
+ * such wiphy can have zero, one, or many virtual interfaces associated with
+ * it, which need to be identified as such by pointing the network interface's
+ * @ieee80211_ptr pointer to a &struct wireless_dev which further describes
+ * the wireless part of the interface, normally this struct is embedded in the
+ * network interface's private data area. Drivers can optionally allow creating
+ * or destroying virtual interfaces on the fly, but without at least one or the
+ * ability to create some the wireless device isn't useful.
+ *
+ * Each wiphy structure contains device capability information, and also has
+ * a pointer to the various operations the driver offers. The definitions and
+ * structures here describe these capabilities in detail.
+ */
+
 /*
  * wireless hardware capability structures
  */
@@ -205,6 +242,21 @@ struct ieee80211_supported_band {
  */
 
 /**
+ * DOC: Actions and configuration
+ *
+ * Each wireless device and each virtual interface offer a set of configuration
+ * operations and other actions that are invoked by userspace. Each of these
+ * actions is described in the operations structure, and the parameters these
+ * operations use are described separately.
+ *
+ * Additionally, some operations are asynchronous and expect to get status
+ * information via some functions that drivers need to call.
+ *
+ * Scanning and BSS list handling with its associated functionality is described
+ * in a separate chapter.
+ */
+
+/**
  * struct vif_params - describes virtual interface parameters
  * @mesh_id: mesh ID to use
  * @mesh_id_len: length of the mesh ID
@@ -570,8 +622,28 @@ struct ieee80211_txq_params {
 /* from net/wireless.h */
 struct wiphy;
 
-/* from net/ieee80211.h */
-struct ieee80211_channel;
+/**
+ * DOC: Scanning and BSS list handling
+ *
+ * The scanning process itself is fairly simple, but cfg80211 offers quite
+ * a bit of helper functionality. To start a scan, the scan operation will
+ * be invoked with a scan definition. This scan definition contains the
+ * channels to scan, and the SSIDs to send probe requests for (including the
+ * wildcard, if desired). A passive scan is indicated by having no SSIDs to
+ * probe. Additionally, a scan request may contain extra information elements
+ * that should be added to the probe request. The IEs are guaranteed to be
+ * well-formed, and will not exceed the maximum length the driver advertised
+ * in the wiphy structure.
+ *
+ * When scanning finds a BSS, cfg80211 needs to be notified of that, because
+ * it is responsible for maintaining the BSS list; the driver should not
+ * maintain a list itself. For this notification, various functions exist.
+ *
+ * Since drivers do not maintain a BSS list, there are also a number of
+ * functions to search for a BSS and obtain information about it from the
+ * BSS structure cfg80211 maintains. The BSS list is also made available
+ * to userspace.
+ */
 
 /**
  * struct cfg80211_ssid - SSID description
@@ -1574,8 +1646,10 @@ static inline void *wdev_priv(struct wir
 	return wiphy_priv(wdev->wiphy);
 }
 
-/*
- * Utility functions
+/**
+ * DOC: Utility functions
+ *
+ * cfg80211 offers a number of utility functions that can be useful.
  */
 
 /**
@@ -1729,6 +1803,14 @@ unsigned int ieee80211_get_hdrlen_from_s
 unsigned int __attribute_const__ ieee80211_hdrlen(__le16 fc);
 
 /**
+ * DOC: Data path helpers
+ *
+ * In addition to generic utilities, cfg80211 also offers
+ * functions that help implement the data path for devices
+ * that do not do the 802.11/802.3 conversion on the device.
+ */
+
+/**
  * ieee80211_data_to_8023 - convert an 802.11 data frame to 802.3
  * @skb: the 802.11 data frame
  * @addr: the device MAC address
@@ -1788,8 +1870,10 @@ unsigned int cfg80211_classify8021d(stru
  */
 const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len);
 
-/*
- * Regulatory helper functions for wiphys
+/**
+ * DOC: Regulatory enforcement infrastructure
+ *
+ * TODO
  */
 
 /**
@@ -2192,6 +2276,20 @@ void cfg80211_michael_mic_failure(struct
 void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid, gfp_t gfp);
 
 /**
+ * DOC: RFkill integration
+ *
+ * RFkill integration in cfg80211 is almost invisible to drivers,
+ * as cfg80211 automatically registers an rfkill instance for each
+ * wireless device it knows about. Soft kill is also translated
+ * into disconnecting and turning all interfaces off, drivers are
+ * expected to turn off the device when all interfaces are down.
+ *
+ * However, devices may have a hard RFkill line, in which case they
+ * also need to interact with the rfkill subsystem, via cfg80211.
+ * They can do this with a few helper functions documented here.
+ */
+
+/**
  * wiphy_rfkill_set_hw_state - notify cfg80211 about hw block state
  * @wiphy: the wiphy
  * @blocked: block status
@@ -2212,6 +2310,17 @@ void wiphy_rfkill_stop_polling(struct wi
 
 #ifdef CONFIG_NL80211_TESTMODE
 /**
+ * DOC: Test mode
+ *
+ * Test mode is a set of utility functions to allow drivers to
+ * interact with driver-specific tools to aid, for instance,
+ * factory programming.
+ *
+ * This chapter describes how drivers interact with it, for more
+ * information see the nl80211 book's chapter on it.
+ */
+
+/**
  * cfg80211_testmode_alloc_reply_skb - allocate testmode reply
  * @wiphy: the wiphy
  * @approxlen: an upper bound of the length of the data that will


