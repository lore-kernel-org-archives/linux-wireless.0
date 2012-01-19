Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47588 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab2ASIbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jan 2012 03:31:39 -0500
Message-Id: <20120119083102.873553392@sipsolutions.net> (sfid-20120119_093143_713988_6A1D8336)
Date: Thu, 19 Jan 2012 09:29:58 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mac80211: make CQM RSSI support per virtual interface
References: <20120119082956.486569312@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Similar to the previous beacon filtering patch,
make CQM RSSI support depend on the flags that
the driver set for virtual interfaces.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/wl1251/main.c |    6 +++---
 drivers/net/wireless/wl12xx/main.c |    4 ++--
 include/net/mac80211.h             |   14 +++++++-------
 net/mac80211/cfg.c                 |   10 ++--------
 net/mac80211/debugfs.c             |    2 --
 net/mac80211/mlme.c                |    4 ++--
 6 files changed, 16 insertions(+), 24 deletions(-)

--- a/include/net/mac80211.h	2012-01-19 09:22:06.000000000 +0100
+++ b/include/net/mac80211.h	2012-01-19 09:24:42.000000000 +0100
@@ -856,9 +856,14 @@ struct ieee80211_channel_switch {
  *
  * @IEEE80211_VIF_BEACON_FILTER: the device performs beacon filtering
  *	on this virtual interface to avoid unnecessary CPU wakeups
+ * @IEEE80211_VIF_SUPPORTS_CQM_RSSI: the device can do connection quality
+ *	monitoring on this virtual interface -- i.e. it can monitor
+ *	connection quality related parameters, such as the RSSI level and
+ *	provide notifications if configured trigger levels are reached.
  */
 enum ieee80211_vif_flags {
 	IEEE80211_VIF_BEACON_FILTER		= BIT(0),
+	IEEE80211_VIF_SUPPORTS_CQM_RSSI		= BIT(1),
 };
 
 /**
@@ -1119,11 +1124,6 @@ enum sta_notify_cmd {
  *      When this flag is set, signaling beacon-loss will cause an immediate
  *      change to disassociated state.
  *
- * @IEEE80211_HW_SUPPORTS_CQM_RSSI:
- *	Hardware can do connection quality monitoring - i.e. it can monitor
- *	connection quality related parameters, such as the RSSI level and
- *	provide notifications if configured trigger levels are reached.
- *
  * @IEEE80211_HW_NEED_DTIM_PERIOD:
  *	This device needs to know the DTIM period for the BSS before
  *	associating.
@@ -1167,7 +1167,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
 	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
 	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
-	IEEE80211_HW_SUPPORTS_CQM_RSSI			= 1<<20,
+	/* reuse bit 20 */
 	IEEE80211_HW_SUPPORTS_PER_STA_GTK		= 1<<21,
 	IEEE80211_HW_AP_LINK_PS				= 1<<22,
 	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
@@ -3408,7 +3408,7 @@ void ieee80211_enable_dyn_ps(struct ieee
  * @rssi_event: the RSSI trigger event type
  * @gfp: context flags
  *
- * When the %IEEE80211_HW_SUPPORTS_CQM_RSSI is set, and a connection quality
+ * When the %IEEE80211_VIF_SUPPORTS_CQM_RSSI is set, and a connection quality
  * monitoring is configured with an rssi threshold, the driver will inform
  * whenever the rssi level reaches the threshold.
  */
--- a/net/mac80211/cfg.c	2012-01-19 09:22:06.000000000 +0100
+++ b/net/mac80211/cfg.c	2012-01-19 09:24:42.000000000 +0100
@@ -1862,7 +1862,6 @@ static int ieee80211_set_cqm_rssi_config
 					 s32 rssi_thold, u32 rssi_hyst)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_vif *vif = &sdata->vif;
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 
@@ -1873,14 +1872,9 @@ static int ieee80211_set_cqm_rssi_config
 	bss_conf->cqm_rssi_thold = rssi_thold;
 	bss_conf->cqm_rssi_hyst = rssi_hyst;
 
-	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_RSSI)) {
-		if (sdata->vif.type != NL80211_IFTYPE_STATION)
-			return -EOPNOTSUPP;
-		return 0;
-	}
-
 	/* tell the driver upon association, unless already associated */
-	if (sdata->u.mgd.associated)
+	if (sdata->u.mgd.associated &&
+	    sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI)
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_CQM);
 
 	return 0;
--- a/net/mac80211/debugfs.c	2012-01-19 09:22:06.000000000 +0100
+++ b/net/mac80211/debugfs.c	2012-01-19 09:24:42.000000000 +0100
@@ -257,8 +257,6 @@ static ssize_t hwflags_read(struct file
 		sf += snprintf(buf + sf, mxln - sf, "REPORTS_TX_ACK_STATUS\n");
 	if (local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
 		sf += snprintf(buf + sf, mxln - sf, "CONNECTION_MONITOR\n");
-	if (local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_RSSI)
-		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_CQM_RSSI\n");
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_PER_STA_GTK)
 		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_PER_STA_GTK\n");
 	if (local->hw.flags & IEEE80211_HW_AP_LINK_PS)
--- a/net/mac80211/mlme.c	2012-01-19 09:22:06.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-01-19 09:24:42.000000000 +0100
@@ -1043,7 +1043,7 @@ static void ieee80211_set_associated(str
 	bss_info_changed |= BSS_CHANGED_BSSID;
 
 	/* Tell the driver to monitor connection quality (if supported) */
-	if ((local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_RSSI) &&
+	if (sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI &&
 	    bss_conf->cqm_rssi_thold)
 		bss_info_changed |= BSS_CHANGED_CQM;
 
@@ -1891,7 +1891,7 @@ static void ieee80211_rx_mgmt_beacon(str
 
 	if (bss_conf->cqm_rssi_thold &&
 	    ifmgd->count_beacon_signal >= IEEE80211_SIGNAL_AVE_MIN_COUNT &&
-	    !(local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_RSSI)) {
+	    !(sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI)) {
 		int sig = ifmgd->ave_beacon_signal / 16;
 		int last_event = ifmgd->last_cqm_event_signal;
 		int thold = bss_conf->cqm_rssi_thold;
--- a/drivers/net/wireless/wl1251/main.c	2012-01-19 09:22:06.000000000 +0100
+++ b/drivers/net/wireless/wl1251/main.c	2012-01-19 09:24:42.000000000 +0100
@@ -514,7 +514,8 @@ static int wl1251_op_add_interface(struc
 	struct wl1251 *wl = hw->priv;
 	int ret = 0;
 
-	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
+	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER |
+			     IEEE80211_VIF_SUPPORTS_CQM_RSSI;
 
 	wl1251_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %pM",
 		     vif->type, vif->addr);
@@ -1340,8 +1341,7 @@ int wl1251_init_ieee80211(struct wl1251
 
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_SUPPORTS_PS |
-		IEEE80211_HW_SUPPORTS_UAPSD |
-		IEEE80211_HW_SUPPORTS_CQM_RSSI;
+		IEEE80211_HW_SUPPORTS_UAPSD;
 
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 					 BIT(NL80211_IFTYPE_ADHOC);
--- a/drivers/net/wireless/wl12xx/main.c	2012-01-19 09:22:06.000000000 +0100
+++ b/drivers/net/wireless/wl12xx/main.c	2012-01-19 09:24:42.000000000 +0100
@@ -2060,7 +2060,8 @@ static int wl1271_op_add_interface(struc
 	u8 role_type;
 	bool booted = false;
 
-	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
+	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER |
+			     IEEE80211_VIF_SUPPORTS_CQM_RSSI;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %pM",
 		     ieee80211_vif_type_p2p(vif), vif->addr);
@@ -4904,7 +4905,6 @@ static int wl1271_init_ieee80211(struct
 		IEEE80211_HW_SUPPORTS_UAPSD |
 		IEEE80211_HW_HAS_RATE_CONTROL |
 		IEEE80211_HW_CONNECTION_MONITOR |
-		IEEE80211_HW_SUPPORTS_CQM_RSSI |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		IEEE80211_HW_SPECTRUM_MGMT |
 		IEEE80211_HW_AP_LINK_PS |


