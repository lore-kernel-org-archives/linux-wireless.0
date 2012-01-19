Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47584 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab2ASIbh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jan 2012 03:31:37 -0500
Message-Id: <20120119083102.737136632@sipsolutions.net> (sfid-20120119_093144_336585_45436F61)
Date: Thu, 19 Jan 2012 09:29:57 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mac80211: make beacon filtering per virtual interface
References: <20120119082956.486569312@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Due to firmware limitations, we may not be able to
support beacon filtering on all virtual interfaces.
To allow this in mac80211, introduce per-interface
driver capability flags that the driver sets when
an interface is added.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/p54/main.c     |    3 ++-
 drivers/net/wireless/rtlwifi/base.c |    1 -
 drivers/net/wireless/rtlwifi/core.c |    2 ++
 drivers/net/wireless/wl1251/main.c  |    3 ++-
 drivers/net/wireless/wl12xx/main.c  |    3 ++-
 include/net/mac80211.h              |   29 ++++++++++++++++++++---------
 net/mac80211/debugfs.c              |    2 --
 net/mac80211/mlme.c                 |    2 +-
 8 files changed, 29 insertions(+), 16 deletions(-)

--- a/include/net/mac80211.h	2012-01-19 09:10:33.000000000 +0100
+++ b/include/net/mac80211.h	2012-01-19 09:22:06.000000000 +0100
@@ -852,6 +852,16 @@ struct ieee80211_channel_switch {
 };
 
 /**
+ * enum ieee80211_vif_flags - virtual interface flags
+ *
+ * @IEEE80211_VIF_BEACON_FILTER: the device performs beacon filtering
+ *	on this virtual interface to avoid unnecessary CPU wakeups
+ */
+enum ieee80211_vif_flags {
+	IEEE80211_VIF_BEACON_FILTER		= BIT(0),
+};
+
+/**
  * struct ieee80211_vif - per-interface data
  *
  * Data in this structure is continually present for driver
@@ -863,6 +873,10 @@ struct ieee80211_channel_switch {
  * @addr: address of this interface
  * @p2p: indicates whether this AP or STA interface is a p2p
  *	interface, i.e. a GO or p2p-sta respectively
+ * @driver_flags: flags/capabilities the driver has for this interface,
+ *	these need to be set (or cleared) when the interface is added
+ *	or, if supported by the driver, the interface type is changed
+ *	at runtime, mac80211 will never touch this field
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *).
  */
@@ -871,6 +885,7 @@ struct ieee80211_vif {
 	struct ieee80211_bss_conf bss_conf;
 	u8 addr[ETH_ALEN];
 	bool p2p;
+	u32 driver_flags;
 	/* must be last */
 	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
 };
@@ -1079,10 +1094,6 @@ enum sta_notify_cmd {
  * @IEEE80211_HW_MFP_CAPABLE:
  *	Hardware supports management frame protection (MFP, IEEE 802.11w).
  *
- * @IEEE80211_HW_BEACON_FILTER:
- *	Hardware supports dropping of irrelevant beacon frames to
- *	avoid waking up cpu.
- *
  * @IEEE80211_HW_SUPPORTS_STATIC_SMPS:
  *	Hardware supports static spatial multiplexing powersave,
  *	ie. can turn off all but one chain even on HT connections
@@ -1150,7 +1161,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_PS_NULLFUNC_STACK			= 1<<11,
 	IEEE80211_HW_SUPPORTS_DYNAMIC_PS		= 1<<12,
 	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
-	IEEE80211_HW_BEACON_FILTER			= 1<<14,
+	/* reuse bit 14 */
 	IEEE80211_HW_SUPPORTS_STATIC_SMPS		= 1<<15,
 	IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS		= 1<<16,
 	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
@@ -1446,8 +1457,8 @@ void ieee80211_free_txskb(struct ieee802
  * way the host will only receive beacons where some relevant information
  * (for example ERP protection or WMM settings) have changed.
  *
- * Beacon filter support is advertised with the %IEEE80211_HW_BEACON_FILTER
- * hardware capability. The driver needs to enable beacon filter support
+ * Beacon filter support is advertised with the %IEEE80211_VIF_BEACON_FILTER
+ * interface capability. The driver needs to enable beacon filter support
  * whenever power save is enabled, that is %IEEE80211_CONF_PS is set. When
  * power save is enabled, the stack will not check for beacon loss and the
  * driver needs to notify about loss of beacons with ieee80211_beacon_loss().
@@ -3316,7 +3327,7 @@ struct sk_buff *ieee80211_ap_probereq_ge
  *
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  *
- * When beacon filtering is enabled with %IEEE80211_HW_BEACON_FILTER and
+ * When beacon filtering is enabled with %IEEE80211_VIF_BEACON_FILTER and
  * %IEEE80211_CONF_PS is set, the driver needs to inform whenever the
  * hardware is not receiving beacons with this function.
  */
@@ -3327,7 +3338,7 @@ void ieee80211_beacon_loss(struct ieee80
  *
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  *
- * When beacon filtering is enabled with %IEEE80211_HW_BEACON_FILTER, and
+ * When beacon filtering is enabled with %IEEE80211_VIF_BEACON_FILTER, and
  * %IEEE80211_CONF_PS and %IEEE80211_HW_CONNECTION_MONITOR are set, the driver
  * needs to inform if the connection to the AP has been lost.
  *
--- a/net/mac80211/debugfs.c	2012-01-19 09:10:33.000000000 +0100
+++ b/net/mac80211/debugfs.c	2012-01-19 09:22:06.000000000 +0100
@@ -247,8 +247,6 @@ static ssize_t hwflags_read(struct file
 		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_DYNAMIC_PS\n");
 	if (local->hw.flags & IEEE80211_HW_MFP_CAPABLE)
 		sf += snprintf(buf + sf, mxln - sf, "MFP_CAPABLE\n");
-	if (local->hw.flags & IEEE80211_HW_BEACON_FILTER)
-		sf += snprintf(buf + sf, mxln - sf, "BEACON_FILTER\n");
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_STATIC_SMPS)
 		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_STATIC_SMPS\n");
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS)
--- a/net/mac80211/mlme.c	2012-01-19 09:10:33.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-01-19 09:22:06.000000000 +0100
@@ -127,7 +127,7 @@ static void run_again(struct ieee80211_i
 
 void ieee80211_sta_reset_beacon_monitor(struct ieee80211_sub_if_data *sdata)
 {
-	if (sdata->local->hw.flags & IEEE80211_HW_BEACON_FILTER)
+	if (sdata->vif.driver_flags & IEEE80211_VIF_BEACON_FILTER)
 		return;
 
 	mod_timer(&sdata->u.mgd.bcn_mon_timer,
--- a/drivers/net/wireless/p54/main.c	2012-01-19 09:10:33.000000000 +0100
+++ b/drivers/net/wireless/p54/main.c	2012-01-19 09:10:34.000000000 +0100
@@ -228,6 +228,8 @@ static int p54_add_interface(struct ieee
 {
 	struct p54_common *priv = dev->priv;
 
+	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
+
 	mutex_lock(&priv->conf_mutex);
 	if (priv->mode != NL80211_IFTYPE_MONITOR) {
 		mutex_unlock(&priv->conf_mutex);
@@ -734,7 +736,6 @@ struct ieee80211_hw *p54_init_common(siz
 		     IEEE80211_HW_SIGNAL_DBM |
 		     IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_PS_NULLFUNC_STACK |
-		     IEEE80211_HW_BEACON_FILTER |
 		     IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
--- a/drivers/net/wireless/rtlwifi/base.c	2012-01-19 09:10:33.000000000 +0100
+++ b/drivers/net/wireless/rtlwifi/base.c	2012-01-19 09:10:34.000000000 +0100
@@ -310,7 +310,6 @@ static void _rtl_init_mac80211(struct ie
 	/* <5> set hw caps */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 	    IEEE80211_HW_RX_INCLUDES_FCS |
-	    IEEE80211_HW_BEACON_FILTER |
 	    IEEE80211_HW_AMPDU_AGGREGATION |
 	    IEEE80211_HW_CONNECTION_MONITOR |
 	    /* IEEE80211_HW_SUPPORTS_CQM_RSSI | */
--- a/drivers/net/wireless/rtlwifi/core.c	2012-01-19 09:10:33.000000000 +0100
+++ b/drivers/net/wireless/rtlwifi/core.c	2012-01-19 09:22:03.000000000 +0100
@@ -112,6 +112,8 @@ static int rtl_op_add_interface(struct i
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	int err = 0;
 
+	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
+
 	if (mac->vif) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 ("vif has been set!! mac->vif = 0x%p\n", mac->vif));
--- a/drivers/net/wireless/wl1251/main.c	2012-01-19 09:10:33.000000000 +0100
+++ b/drivers/net/wireless/wl1251/main.c	2012-01-19 09:22:06.000000000 +0100
@@ -514,6 +514,8 @@ static int wl1251_op_add_interface(struc
 	struct wl1251 *wl = hw->priv;
 	int ret = 0;
 
+	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
+
 	wl1251_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %pM",
 		     vif->type, vif->addr);
 
@@ -1338,7 +1340,6 @@ int wl1251_init_ieee80211(struct wl1251
 
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_SUPPORTS_PS |
-		IEEE80211_HW_BEACON_FILTER |
 		IEEE80211_HW_SUPPORTS_UAPSD |
 		IEEE80211_HW_SUPPORTS_CQM_RSSI;
 
--- a/drivers/net/wireless/wl12xx/main.c	2012-01-19 09:10:33.000000000 +0100
+++ b/drivers/net/wireless/wl12xx/main.c	2012-01-19 09:22:06.000000000 +0100
@@ -2060,6 +2060,8 @@ static int wl1271_op_add_interface(struc
 	u8 role_type;
 	bool booted = false;
 
+	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
+
 	wl1271_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %pM",
 		     ieee80211_vif_type_p2p(vif), vif->addr);
 
@@ -4898,7 +4900,6 @@ static int wl1271_init_ieee80211(struct
 	wl->hw->max_listen_interval = wl->conf.conn.max_listen_interval;
 
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_BEACON_FILTER |
 		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_SUPPORTS_UAPSD |
 		IEEE80211_HW_HAS_RATE_CONTROL |


