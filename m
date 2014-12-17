Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36832 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbaLQN6K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 08:58:10 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 9/9] nl80211: clarify packet statistics descriptions
Date: Wed, 17 Dec 2014 14:57:59 +0100
Message-Id: <1418824679-31530-10-git-send-email-johannes@sipsolutions.net> (sfid-20141217_145818_030088_B70B0EF4)
In-Reply-To: <1418824679-31530-1-git-send-email-johannes@sipsolutions.net>
References: <1418824679-31530-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The current statistics we keep aren't very clear, some are on
MPDUs and some on MSDUs/MMPDUs. Clarify the descriptions based
on the counters mac80211 keeps.

Change-Id: I277c545f4fc5496713bf7d6148c4711d56d5bf5e
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 12 ++++++------
 include/uapi/linux/nl80211.h | 24 +++++++++++++++---------
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1c77d02efc06..bb14dcfb3c89 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -949,8 +949,8 @@ struct sta_bss_parameters {
  *	indicate the relevant values in this struct for them
  * @connected_time: time(in secs) since a station is last connected
  * @inactive_time: time since last station activity (tx/rx) in milliseconds
- * @rx_bytes: bytes received from this station
- * @tx_bytes: bytes transmitted to this station
+ * @rx_bytes: bytes (size of MPDUs) received from this station
+ * @tx_bytes: bytes (size of MPDUs) transmitted to this station
  * @llid: mesh local link id
  * @plid: mesh peer link id
  * @plink_state: mesh peer link state
@@ -963,10 +963,10 @@ struct sta_bss_parameters {
  * @chain_signal_avg: per-chain signal strength average in dBm
  * @txrate: current unicast bitrate from this station
  * @rxrate: current unicast bitrate to this station
- * @rx_packets: packets received from this station
- * @tx_packets: packets transmitted to this station
- * @tx_retries: cumulative retry counts
- * @tx_failed: number of failed transmissions (retries exceeded, no ACK)
+ * @rx_packets: packets (MSDUs & MMPDUs) received from this station
+ * @tx_packets: packets (MSDUs & MMPDUs) transmitted to this station
+ * @tx_retries: cumulative retry counts (MPDUs)
+ * @tx_failed: number of failed transmissions (MPDUs) (retries exceeded, no ACK)
  * @rx_dropped_misc:  Dropped for un-specified reason.
  * @bss_param: current BSS parameters
  * @generation: generation number for nl80211 dumps.
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b1b00164de9a..9e5797d00096 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2319,18 +2319,24 @@ enum nl80211_sta_bss_param {
  *
  * @__NL80211_STA_INFO_INVALID: attribute number 0 is reserved
  * @NL80211_STA_INFO_INACTIVE_TIME: time since last activity (u32, msecs)
- * @NL80211_STA_INFO_RX_BYTES: total received bytes (u32, from this station)
- * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this station)
- * @NL80211_STA_INFO_RX_BYTES64: total received bytes (u64, from this station)
- * @NL80211_STA_INFO_TX_BYTES64: total transmitted bytes (u64, to this station)
+ * @NL80211_STA_INFO_RX_BYTES: total received bytes (MPDU length)
+ *	(u32, from this station)
+ * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (MPDU length)
+ *	(u32, to this station)
+ * @NL80211_STA_INFO_RX_BYTES64: total received bytes (MPDU length)
+ *	(u64, from this station)
+ * @NL80211_STA_INFO_TX_BYTES64: total transmitted bytes (MPDU length)
+ *	(u64, to this station)
  * @NL80211_STA_INFO_SIGNAL: signal strength of last received PPDU (u8, dBm)
  * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested attribute
  * 	containing info as possible, see &enum nl80211_rate_info
- * @NL80211_STA_INFO_RX_PACKETS: total received packet (u32, from this station)
- * @NL80211_STA_INFO_TX_PACKETS: total transmitted packets (u32, to this
- *	station)
- * @NL80211_STA_INFO_TX_RETRIES: total retries (u32, to this station)
- * @NL80211_STA_INFO_TX_FAILED: total failed packets (u32, to this station)
+ * @NL80211_STA_INFO_RX_PACKETS: total received packet (MSDUs and MMPDUs)
+ *	(u32, from this station)
+ * @NL80211_STA_INFO_TX_PACKETS: total transmitted packets (MSDUs and MMPDUs)
+ *	(u32, to this station)
+ * @NL80211_STA_INFO_TX_RETRIES: total retries (MPDUs) (u32, to this station)
+ * @NL80211_STA_INFO_TX_FAILED: total failed packets (MPDUs)
+ *	(u32, to this station)
  * @NL80211_STA_INFO_SIGNAL_AVG: signal strength average (u8, dBm)
  * @NL80211_STA_INFO_LLID: the station's mesh LLID
  * @NL80211_STA_INFO_PLID: the station's mesh PLID
-- 
2.1.1

