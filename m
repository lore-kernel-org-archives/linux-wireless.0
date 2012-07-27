Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:58279 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752707Ab2G0QA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 12:00:28 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
	thomas@net.t-labs.tu-berlin.de, nbd@openwrt.org
Subject: [PATCH 2/2] mac80211: Add transmit power control support (TPC) for ACK packets
Date: Fri, 27 Jul 2012 18:00:09 +0200
Message-Id: <1343404809-70329-3-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120727_180038_027363_C1B333FB)
In-Reply-To: <1343404809-70329-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1343404809-70329-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support to annotate and change the power-level of ACK
packets. To map hardware specific ack power capabilities to mac80211
one new hw flag is defined:

@IEEE80211_HW_SUPPORTS_TPC_ACK_GLOBAL:
	Power level of ack packets is adjustable and processed in a
	global manner, per hw rather than per ack packet or link.

The struct hw_config is extended by ack_power a global power level in
dBm to be used for all acknowledgement_packets. A new config change
event IEEE80211_CONF_CHANGE_ACK_POWER is defined to reacte with driver
specific function calls to ack_power changes from the mac80211.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h | 11 +++++++++++
 net/mac80211/rate.c    |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 27ef037..bb0ac22a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -772,6 +772,7 @@ enum ieee80211_conf_flags {
  * @IEEE80211_CONF_CHANGE_RETRY_LIMITS: retry limits changed
  * @IEEE80211_CONF_CHANGE_IDLE: Idle flag changed
  * @IEEE80211_CONF_CHANGE_SMPS: Spatial multiplexing powersave mode changed
+ * @IEEE80211_CONF_CHANGE_ACK_POWER: Global ACK power level (in dBm) changed
  */
 enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_SMPS		= BIT(1),
@@ -782,6 +783,7 @@ enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
 	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
 	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
+	IEEE80211_CONF_CHANGE_ACK_POWER		= BIT(9),
 };
 
 /**
@@ -838,6 +840,8 @@ enum ieee80211_smps_mode {
  * @smps_mode: spatial multiplexing powersave mode; note that
  *	%IEEE80211_SMPS_STATIC is used when the device is not
  *	configured for an HT channel
+ * @ack_power: global power level in dBm to use for all
+ * 	mac80211 acknowledgement_packets
  */
 struct ieee80211_conf {
 	u32 flags;
@@ -852,6 +856,8 @@ struct ieee80211_conf {
 	struct ieee80211_channel *channel;
 	enum nl80211_channel_type channel_type;
 	enum ieee80211_smps_mode smps_mode;
+
+	u8 ack_power;
 };
 
 /**
@@ -1227,6 +1233,10 @@ struct ieee80211_tx_control {
  * @IEEE80211_HW_SUPPORTS_TPC_DATA_MRR: One power levels per multi-rate-retry
  *	stage can be processed. Each retry stage of a data packet is send out
  *	using its specified power level.
+ *
+ * @IEEE80211_HW_SUPPORTS_TPC_ACK_GLOBAL: Power level of ack packets is
+ *	adjustable and processed in a global setting, per hardware rather
+ *	than per ack packet and link.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1256,6 +1266,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SCAN_WHILE_IDLE			= 1<<24,
 	IEEE80211_HW_SUPPORTS_TPC_DATA_PACKET		= 1<<25,
 	IEEE80211_HW_SUPPORTS_TPC_DATA_MRR		= 1<<26,
+	IEEE80211_HW_SUPPORTS_TPC_ACK_GLOBAL            = 1<<27,
 };
 
 /**
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 98bde93..aab4333 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -260,6 +260,7 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(txrc->skb);
 	struct ieee80211_supported_band *sband = txrc->sband;
 	int mcast_rate;
+	int i;
 
 	if (!sta || !priv_sta || rc_no_data_or_no_ack_use_min(txrc)) {
 		if ((sband->band != IEEE80211_BAND_2GHZ) ||
@@ -283,6 +284,9 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
 					      txrc->bss_conf->basic_rates,
 					      sband);
 		}
+		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
+			info->control.rates[i].tpc = txrc->hw->conf.power_level;
+		}
 		return true;
 	}
 	return false;
-- 
1.7.11.1

