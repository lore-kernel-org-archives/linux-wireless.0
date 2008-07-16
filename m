Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13302 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbYGPLrV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2008 07:47:21 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: make listen_interval be limited by low level driver
Date: Wed, 16 Jul 2008 14:46:54 +0300
Message-Id: <1216208814-26314-1-git-send-email-tomas.winkler@intel.com> (sfid-20080716_134725_236004_4BC87549)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes possible for a driver to specify maximal listen interval
The possibility for user to configure listen interval is not implemented
yet, currently the maximum provided by the driver or 1 is used.
Mac80211 uses config handler to set listen interval for to the driver.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h |    9 ++++++++-
 net/mac80211/main.c    |    5 +++++
 net/mac80211/mlme.c    |    6 ++++--
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e0e4cd9..612634f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -438,6 +438,7 @@ enum ieee80211_conf_flags {
  * @radio_enabled: when zero, driver is required to switch off the radio.
  *	TODO make a flag
  * @beacon_int: beacon interval (TODO make interface config)
+ * @listen_interval: listen interval in units of beacon interval
  * @flags: configuration flags defined above
  * @power_level: requested transmit power (in dBm)
  * @max_antenna_gain: maximum antenna gain (in dBi)
@@ -452,6 +453,7 @@ struct ieee80211_conf {
 	int radio_enabled;
 
 	int beacon_int;
+	u16 listen_interval;
 	u32 flags;
 	int power_level;
 	int max_antenna_gain;
@@ -794,6 +796,9 @@ enum ieee80211_hw_flags {
  * @max_signal: Maximum value for signal (rssi) in RX information, used
  *     only when @IEEE80211_HW_SIGNAL_UNSPEC or @IEEE80211_HW_SIGNAL_DB
  *
+ * @max_listen_interval: max listen interval in units of beacon interval
+ *     that HW supports
+ *
  * @queues: number of available hardware transmit queues for
  *	data packets. WMM/QoS requires at least four, these
  *	queues need to have configurable access parameters.
@@ -821,7 +826,9 @@ struct ieee80211_hw {
 	unsigned int extra_tx_headroom;
 	int channel_change_time;
 	int vif_data_size;
-	u16 queues, ampdu_queues;
+	u16 queues;
+	u16 ampdu_queues;
+	u16 max_listen_interval;
 	s8 max_signal;
 };
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 10533bf..6fa2336 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1712,6 +1712,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (local->hw.conf.beacon_int < 10)
 		local->hw.conf.beacon_int = 100;
 
+	if (local->hw.max_listen_interval == 0)
+		local->hw.max_listen_interval = 1;
+
+	local->hw.conf.listen_interval = local->hw.max_listen_interval;
+
 	local->wstats_flags |= local->hw.flags & (IEEE80211_HW_SIGNAL_UNSPEC |
 						  IEEE80211_HW_SIGNAL_DB |
 						  IEEE80211_HW_SIGNAL_DBM) ?
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b2403dc..0b25ee1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -807,7 +807,8 @@ static void ieee80211_send_assoc(struct net_device *dev,
 		mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
 						   IEEE80211_STYPE_REASSOC_REQ);
 		mgmt->u.reassoc_req.capab_info = cpu_to_le16(capab);
-		mgmt->u.reassoc_req.listen_interval = cpu_to_le16(1);
+		mgmt->u.reassoc_req.listen_interval =
+				cpu_to_le16(local->hw.conf.listen_interval);
 		memcpy(mgmt->u.reassoc_req.current_ap, ifsta->prev_bssid,
 		       ETH_ALEN);
 	} else {
@@ -815,7 +816,8 @@ static void ieee80211_send_assoc(struct net_device *dev,
 		mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
 						   IEEE80211_STYPE_ASSOC_REQ);
 		mgmt->u.assoc_req.capab_info = cpu_to_le16(capab);
-		mgmt->u.assoc_req.listen_interval = cpu_to_le16(1);
+		mgmt->u.reassoc_req.listen_interval =
+				cpu_to_le16(local->hw.conf.listen_interval);
 	}
 
 	/* SSID */
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

