Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:36982 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933781AbcJUM5g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 08:57:36 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 2/2] mac80211: use inline kernel-doc for struct ieee80211_hw
Date: Fri, 21 Oct 2016 15:57:24 +0300
Message-Id: <1477054644-5945-2-git-send-email-jani.nikula@intel.com> (sfid-20161021_145828_211535_54617949)
In-Reply-To: <1477054644-5945-1-git-send-email-jani.nikula@intel.com>
References: <1477054644-5945-1-git-send-email-jani.nikula@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's easier to manage the kernel-doc for the fields when they
documentation is next to the field.

Signed-off-by: Jani Nikula <jani.nikula@intel.com>

---

The same treatment is sorely needed for struct ieee80211_ops also, but I
don't have the time... this would get rid of the rest of the warnings in
mac80211.h.
---
 include/net/mac80211.h | 280 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 173 insertions(+), 107 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e2dba93e374f..7f659c21ffba 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2078,147 +2078,213 @@ enum ieee80211_hw_flags {
 /**
  * struct ieee80211_hw - hardware information and state
  *
- * This structure contains the configuration and hardware
- * information for an 802.11 PHY.
- *
- * @wiphy: This points to the &struct wiphy allocated for this
- *	802.11 PHY. You must fill in the @perm_addr and @dev
- *	members of this structure using SET_IEEE80211_DEV()
- *	and SET_IEEE80211_PERM_ADDR(). Additionally, all supported
- *	bands (with channels, bitrates) are registered here.
- *
- * @conf: &struct ieee80211_conf, device configuration, don't use.
- *
- * @priv: pointer to private area that was allocated for driver use
- *	along with this structure.
- *
- * @flags: hardware flags, see &enum ieee80211_hw_flags.
- *
- * @extra_tx_headroom: headroom to reserve in each transmit skb
- *	for use by the driver (e.g. for transmit headers.)
- *
- * @extra_beacon_tailroom: tailroom to reserve in each beacon tx skb.
- *	Can be used by drivers to add extra IEs.
- *
- * @max_signal: Maximum value for signal (rssi) in RX information, used
- *	only when @IEEE80211_HW_SIGNAL_UNSPEC or @IEEE80211_HW_SIGNAL_DB
- *
- * @max_listen_interval: max listen interval in units of beacon interval
- *	that HW supports
- *
- * @queues: number of available hardware transmit queues for
- *	data packets. WMM/QoS requires at least four, these
- *	queues need to have configurable access parameters.
- *
- * @rate_control_algorithm: rate control algorithm for this hardware.
- *	If unset (NULL), the default algorithm will be used. Must be
- *	set before calling ieee80211_register_hw().
- *
- * @vif_data_size: size (in bytes) of the drv_priv data area
- *	within &struct ieee80211_vif.
- * @sta_data_size: size (in bytes) of the drv_priv data area
- *	within &struct ieee80211_sta.
- * @chanctx_data_size: size (in bytes) of the drv_priv data area
- *	within &struct ieee80211_chanctx_conf.
- * @txq_data_size: size (in bytes) of the drv_priv data area
- *	within @struct ieee80211_txq.
- *
- * @max_rates: maximum number of alternate rate retry stages the hw
- *	can handle.
- * @max_report_rates: maximum number of alternate rate retry stages
- *	the hw can report back.
- * @max_rate_tries: maximum number of tries for each stage
- *
- * @max_rx_aggregation_subframes: maximum buffer size (number of
- *	sub-frames) to be used for A-MPDU block ack receiver
- *	aggregation.
- *	This is only relevant if the device has restrictions on the
- *	number of subframes, if it relies on mac80211 to do reordering
- *	it shouldn't be set.
- *
- * @max_tx_aggregation_subframes: maximum number of subframes in an
- *	aggregate an HT driver will transmit. Though ADDBA will advertise
- *	a constant value of 64 as some older APs can crash if the window
- *	size is smaller (an example is LinkSys WRT120N with FW v1.0.07
- *	build 002 Jun 18 2012).
- *
- * @max_tx_fragments: maximum number of tx buffers per (A)-MSDU, sum
- *	of 1 + skb_shinfo(skb)->nr_frags for each skb in the frag_list.
- *
- * @offchannel_tx_hw_queue: HW queue ID to use for offchannel TX
- *	(if %IEEE80211_HW_QUEUE_CONTROL is set)
- *
- * @radiotap_mcs_details: lists which MCS information can the HW
- *	reports, by default it is set to _MCS, _GI and _BW but doesn't
- *	include _FMT. Use %IEEE80211_RADIOTAP_MCS_HAVE_\* values, only
- *	adding _BW is supported today.
- *
- * @radiotap_vht_details: lists which VHT MCS information the HW reports,
- *	the default is _GI | _BANDWIDTH.
- *	Use the %IEEE80211_RADIOTAP_VHT_KNOWN_\* values.
- *
- * @radiotap_timestamp: Information for the radiotap timestamp field; if the
- *	'units_pos' member is set to a non-negative value it must be set to
- *	a combination of a IEEE80211_RADIOTAP_TIMESTAMP_UNIT_* and a
- *	IEEE80211_RADIOTAP_TIMESTAMP_SPOS_* value, and then the timestamp
- *	field will be added and populated from the &struct ieee80211_rx_status
- *	device_timestamp. If the 'accuracy' member is non-negative, it's put
- *	into the accuracy radiotap field and the accuracy known flag is set.
- *
- * @netdev_features: netdev features to be set in each netdev created
- *	from this HW. Note that not all features are usable with mac80211,
- *	other features will be rejected during HW registration.
- *
- * @uapsd_queues: This bitmap is included in (re)association frame to indicate
- *	for each access category if it is uAPSD trigger-enabled and delivery-
- *	enabled. Use IEEE80211_WMM_IE_STA_QOSINFO_AC_* to set this bitmap.
- *	Each bit corresponds to different AC. Value '1' in specific bit means
- *	that corresponding AC is both trigger- and delivery-enabled. '0' means
- *	neither enabled.
- *
- * @uapsd_max_sp_len: maximum number of total buffered frames the WMM AP may
- *	deliver to a WMM STA during any Service Period triggered by the WMM STA.
- *	Use IEEE80211_WMM_IE_STA_QOSINFO_SP_* for correct values.
- *
- * @n_cipher_schemes: a size of an array of cipher schemes definitions.
- * @cipher_schemes: a pointer to an array of cipher scheme definitions
- *	supported by HW.
- * @max_nan_de_entries: maximum number of NAN DE functions supported by the
- *	device.
+ * This structure contains the configuration and hardware information for an
+ * 802.11 PHY.
  */
 struct ieee80211_hw {
+	/**
+	 * @conf: &struct ieee80211_conf, device configuration, don't use.
+	 */
 	struct ieee80211_conf conf;
+
+	/**
+	 * @wiphy: This points to the &struct wiphy allocated for this 802.11
+	 * PHY. You must fill in the @perm_addr and @dev members of this
+	 * structure using SET_IEEE80211_DEV() and
+	 * SET_IEEE80211_PERM_ADDR(). Additionally, all supported bands (with
+	 * channels, bitrates) are registered here.
+	 */
 	struct wiphy *wiphy;
+
+	/**
+	 * @rate_control_algorithm: rate control algorithm for this hardware.
+	 * If unset (NULL), the default algorithm will be used. Must be set
+	 * before calling ieee80211_register_hw().
+	 */
 	const char *rate_control_algorithm;
+
+	/**
+	 * @priv: pointer to private area that was allocated for driver use
+	 * along with this structure.
+	 */
 	void *priv;
+
+	/**
+	 * @flags: hardware flags, see &enum ieee80211_hw_flags.
+	 */
 	unsigned long flags[BITS_TO_LONGS(NUM_IEEE80211_HW_FLAGS)];
+
+	/**
+	 * @extra_tx_headroom: headroom to reserve in each transmit skb for use
+	 * by the driver (e.g. for transmit headers.)
+	 */
 	unsigned int extra_tx_headroom;
+
+	/**
+	 * @extra_beacon_tailroom: tailroom to reserve in each beacon tx skb.
+	 * Can be used by drivers to add extra IEs.
+	 */
 	unsigned int extra_beacon_tailroom;
+
+	/**
+	 * @vif_data_size: size (in bytes) of the drv_priv data area
+	 * within &struct ieee80211_vif.
+	 */
 	int vif_data_size;
+
+	/**
+	 * @sta_data_size: size (in bytes) of the drv_priv data area within
+	 * &struct ieee80211_sta.
+	 */
 	int sta_data_size;
+
+	/**
+	 * @chanctx_data_size: size (in bytes) of the drv_priv data area within
+	 * &struct ieee80211_chanctx_conf.
+	 */
 	int chanctx_data_size;
+
+	/**
+	 * @txq_data_size: size (in bytes) of the drv_priv data area
+	 * within @struct ieee80211_txq.
+	 */
 	int txq_data_size;
+
+	/**
+	 * @queues: number of available hardware transmit queues for data
+	 * packets. WMM/QoS requires at least four, these queues need to have
+	 * configurable access parameters.
+	 */
 	u16 queues;
+
+	/**
+	 * @max_listen_interval: max listen interval in units of beacon interval
+	 * that HW supports
+	 */
 	u16 max_listen_interval;
+
+	/**
+	 * @max_signal: Maximum value for signal (rssi) in RX information, used
+	 * only when @IEEE80211_HW_SIGNAL_UNSPEC or @IEEE80211_HW_SIGNAL_DB
+	 */
 	s8 max_signal;
+
+	/**
+	 * @max_rates: maximum number of alternate rate retry stages the hw can
+	 * handle.
+	 */
 	u8 max_rates;
+
+	/**
+	 * @max_report_rates: maximum number of alternate rate retry stages
+	 * the hw can report back.
+	 */
 	u8 max_report_rates;
+
+	/**
+	 * @max_rate_tries: maximum number of tries for each stage
+	 */
 	u8 max_rate_tries;
+
+	/**
+	 * @max_rx_aggregation_subframes: maximum buffer size (number of
+	 * sub-frames) to be used for A-MPDU block ack receiver aggregation.
+	 * This is only relevant if the device has restrictions on the number of
+	 * subframes, if it relies on mac80211 to do reordering it shouldn't be
+	 * set.
+	 */
 	u8 max_rx_aggregation_subframes;
+
+	/**
+	 * @max_tx_aggregation_subframes: maximum number of subframes in an
+	 * aggregate an HT driver will transmit. Though ADDBA will advertise a
+	 * constant value of 64 as some older APs can crash if the window size
+	 * is smaller (an example is LinkSys WRT120N with FW v1.0.07 build 002
+	 * Jun 18 2012).
+	 */
 	u8 max_tx_aggregation_subframes;
+
+	/**
+	 * @max_tx_fragments: maximum number of tx buffers per (A)-MSDU, sum of
+	 * 1 + skb_shinfo(skb)->nr_frags for each skb in the frag_list.
+	 */
 	u8 max_tx_fragments;
+
+	/**
+	 * @offchannel_tx_hw_queue: HW queue ID to use for offchannel TX (if
+	 * %IEEE80211_HW_QUEUE_CONTROL is set)
+	 */
 	u8 offchannel_tx_hw_queue;
+
+	/**
+	 * @radiotap_mcs_details: lists which MCS information can the HW
+	 * reports, by default it is set to _MCS, _GI and _BW but doesn't
+	 * include _FMT. Use %IEEE80211_RADIOTAP_MCS_HAVE_\* values, only adding
+	 * _BW is supported today.
+	 */
 	u8 radiotap_mcs_details;
+
+	/**
+	 * @radiotap_vht_details: lists which VHT MCS information the HW
+	 * reports, the default is _GI | _BANDWIDTH.  Use the
+	 * %IEEE80211_RADIOTAP_VHT_KNOWN_\* values.
+	 */
 	u16 radiotap_vht_details;
+
+	/**
+	 * @radiotap_timestamp: Information for the radiotap timestamp field; if
+	 * the 'units_pos' member is set to a non-negative value it must be set
+	 * to a combination of a IEEE80211_RADIOTAP_TIMESTAMP_UNIT_* and a
+	 * IEEE80211_RADIOTAP_TIMESTAMP_SPOS_* value, and then the timestamp
+	 * field will be added and populated from the &struct
+	 * ieee80211_rx_status device_timestamp. If the 'accuracy' member is
+	 * non-negative, it's put into the accuracy radiotap field and the
+	 * accuracy known flag is set.
+	 */
 	struct {
 		int units_pos;
 		s16 accuracy;
 	} radiotap_timestamp;
+
+	/**
+	 * @netdev_features: netdev features to be set in each netdev created
+	 * from this HW. Note that not all features are usable with mac80211,
+	 * other features will be rejected during HW registration.
+	 */
 	netdev_features_t netdev_features;
+
+	/**
+	 * @uapsd_queues: This bitmap is included in (re)association frame to
+	 * indicate for each access category if it is uAPSD trigger-enabled and
+	 * delivery- enabled. Use IEEE80211_WMM_IE_STA_QOSINFO_AC_* to set this
+	 * bitmap.  Each bit corresponds to different AC. Value '1' in specific
+	 * bit means that corresponding AC is both trigger- and
+	 * delivery-enabled. '0' means neither enabled.
+	 */
 	u8 uapsd_queues;
+
+	/**
+	 * @uapsd_max_sp_len: maximum number of total buffered frames the WMM AP
+	 * may deliver to a WMM STA during any Service Period triggered by the
+	 * WMM STA. Use IEEE80211_WMM_IE_STA_QOSINFO_SP_* for correct values.
+	 */
 	u8 uapsd_max_sp_len;
+
+	/**
+	 * @n_cipher_schemes: a size of an array of cipher schemes definitions.
+	 */
 	u8 n_cipher_schemes;
+
+	/**
+	 * @cipher_schemes: a pointer to an array of cipher scheme definitions
+	 * supported by HW.
+	 */
 	const struct ieee80211_cipher_scheme *cipher_schemes;
+
+	/**
+	 * @max_nan_de_entries: maximum number of NAN DE functions supported by
+	 * the device.
+	 */
 	u8 max_nan_de_entries;
 };
 
-- 
2.1.4
