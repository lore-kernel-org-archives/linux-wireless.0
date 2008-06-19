Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63691 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724AbYFSSfR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 14:35:17 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>
Subject: [RFC PATCH 1/2] mac80211: 11d Handling - Country Information Element
Date: Thu, 19 Jun 2008 21:35:11 +0300
Message-Id: <1213900512-21565-1-git-send-email-tomas.winkler@intel.com> (sfid-20080619_203522_707475_11B0D11D)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

    This patch handles country information elements incoming from
    the AP. In order to do that, there is a need to keeping track of
    txpower inputs.
    This patch adds a distinction between 3 types of txpower inputs:
    1. hw support - max txpower allowed by hw on each channel
    2. user - max txpower supplied by user
    3. 11d - max txpower allowed by currently associated AP, as given
             in country information elements.
    Each time there is a association/disassociation, changing of channel,
    or changing of user txpower, the tx power limit is recalculated and
    passed to the underlying driver.

    Country element:
            The mac80211 identifies the current channel in the element,
            and, if required, propogates the request to reduce the tx
            power to the driver.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
---
 include/net/mac80211.h     |    7 ++-
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/main.c        |   21 ++++++---
 net/mac80211/mlme.c        |  110 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/wext.c        |   26 +++++------
 5 files changed, 143 insertions(+), 22 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8382fc6..693534e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -159,12 +159,14 @@ struct ieee80211_low_level_stats {
  * @BSS_CHANGED_ERP_CTS_PROT: CTS protection changed
  * @BSS_CHANGED_ERP_PREAMBLE: preamble changed
  * @BSS_CHANGED_HT: 802.11n parameters changed
+ * @BSS_CHANGED_PWR: power constrains has changed
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
 	BSS_CHANGED_ERP_CTS_PROT	= 1<<1,
 	BSS_CHANGED_ERP_PREAMBLE	= 1<<2,
 	BSS_CHANGED_HT                  = 1<<4,
+	BSS_CHANGED_PWR                 = 1<<5,
 };
 
 /**
@@ -412,7 +414,8 @@ enum ieee80211_conf_flags {
  *	TODO make a flag
  * @beacon_int: beacon interval (TODO make interface config)
  * @flags: configuration flags defined above
- * @power_level: requested transmit power (in dBm)
+ * @power_level: requested transmit power in operational channel (in dBm)
+ * @user_power_level: global power maximum (limits hw scan)
  * @max_antenna_gain: maximum antenna gain (in dBi)
  * @antenna_sel_tx: transmit antenna selection, 0: default/diversity,
  *	1/2: antenna 0/1
@@ -427,6 +430,8 @@ struct ieee80211_conf {
 	int beacon_int;
 	u32 flags;
 	int power_level;
+	int user_pwr_limit;
+	int tpc_pwr_limit;
 	int max_antenna_gain;
 	u8 antenna_sel_tx;
 	u8 antenna_sel_rx;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index defcc4d..f718f75 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -377,6 +377,7 @@ struct ieee80211_if_sta {
 
 	int wmm_last_param_set;
 	int num_beacons; /* number of TXed beacon frames by this STA */
+	u8 country_max_pwr; /* max power obtained from country ie (11d) */
 };
 
 static inline void ieee80211_if_sta_set_mesh_id(struct ieee80211_if_sta *ifsta,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5c5396e..3f62a44 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1028,6 +1028,19 @@ int ieee80211_if_config_beacon(struct net_device *dev)
 	return __ieee80211_if_config(dev, skb);
 }
 
+static void ieee80211_calculate_power_level(struct ieee80211_local *local)
+{
+	struct ieee80211_channel *chan = local->hw.conf.channel;
+
+	local->hw.conf.power_level = chan->max_power;
+	if (local->hw.conf.user_pwr_limit)
+		local->hw.conf.power_level = min(local->hw.conf.user_pwr_limit,
+			local->hw.conf.power_level);
+	if (local->hw.conf.tpc_pwr_limit)
+		local->hw.conf.power_level = min(local->hw.conf.tpc_pwr_limit,
+			local->hw.conf.power_level);
+}
+
 int ieee80211_hw_config(struct ieee80211_local *local)
 {
 	struct ieee80211_channel *chan;
@@ -1040,13 +1053,7 @@ int ieee80211_hw_config(struct ieee80211_local *local)
 
 	local->hw.conf.channel = chan;
 
-	if (!local->hw.conf.power_level)
-		local->hw.conf.power_level = chan->max_power;
-	else
-		local->hw.conf.power_level = min(chan->max_power,
-					       local->hw.conf.power_level);
-
-	local->hw.conf.max_antenna_gain = chan->max_antenna_gain;
+	ieee80211_calculate_power_level(local);
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: HW CONFIG: freq=%d\n",
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 79b31de..313b02a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -469,6 +469,97 @@ int ieee80211_ht_addt_info_ie_to_ht_bss_info(
 	return 0;
 }
 
+struct ieee80211_subband_triplet {
+	u8 first_channel;
+	u8 num_of_channels;
+	u8 max_power;
+} __attribute__ ((packed));
+
+struct ieee80211_reg_triplet {
+	u8 extension_id;
+	u8 class;
+	u8 coverage;
+} __attribute__ ((packed));
+
+
+#define IEEE80211_COUNTRY_EXTENSION_ID	201
+
+/* returns 0 if no change was made, or BSS_CHANGED_PWR if new country
+   txpower was defined */
+static u32 ieee80211_sta_process_country(struct ieee80211_if_sta *ifsta,
+					  struct ieee80211_local *local,
+					  u8 *country_ie, u8 country_ie_len)
+{
+	int channel = ieee80211_frequency_to_channel(
+				local->hw.conf.channel->center_freq);
+
+	if (country_ie_len < 6) {
+		printk(KERN_ERR "%s: country information element shorter (%d)"
+			" than expected.\n", __func__, country_ie_len);
+		return 0;
+	}
+
+#ifdef CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG
+	printk(KERN_DEBUG "countryString=%c%c%c\n",
+		country_ie[0], country_ie[1], country_ie[2]);
+#endif
+	/* skip country strings */
+	country_ie += 3;
+	country_ie_len -= 3;
+
+	/* search element for current channel */
+	while (country_ie_len >= sizeof(struct ieee80211_subband_triplet)) {
+		struct ieee80211_subband_triplet *triplet =
+			(struct ieee80211_subband_triplet *)country_ie;
+
+		if (triplet->first_channel >= IEEE80211_COUNTRY_EXTENSION_ID) {
+#ifdef CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG
+			printk(KERN_DEBUG "Regulatory triplet not supported\n");
+#endif
+			country_ie += sizeof(struct ieee80211_reg_triplet);
+			country_ie_len -= sizeof(struct ieee80211_reg_triplet);
+			continue;
+		}
+
+		if (channel >= triplet->first_channel &&
+		    channel < triplet->first_channel
+					+ triplet->num_of_channels) {
+			/* found our channel! */
+#ifdef CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG
+			printk(KERN_DEBUG "found current channel (%d) "
+					  "in country ie\n", channel);
+#endif
+			if (ifsta->country_max_pwr != triplet->max_power) {
+#ifdef CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG
+				printk(KERN_DEBUG "changing country max "
+					"power from %d to %d.\n",
+					ifsta->country_max_pwr,
+					triplet->max_power);
+#endif
+				ifsta->country_max_pwr = triplet->max_power;
+				local->hw.conf.tpc_pwr_limit =
+					ifsta->country_max_pwr;
+				return BSS_CHANGED_PWR;
+			}
+#ifdef CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG
+			printk(KERN_DEBUG "no need to change country power\n");
+#endif
+			return 0;
+		}
+
+		country_ie += sizeof(struct ieee80211_subband_triplet);
+		country_ie_len -= sizeof(struct ieee80211_subband_triplet);
+	}
+
+#ifdef CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG
+	/* NOTE: this could be a good reason to disable tx completely! */
+	printk(KERN_DEBUG
+		"match for current channel (%d) not found in country ie.\n",
+		channel);
+#endif
+	return 0;
+}
+
 static void ieee80211_sta_send_associnfo(struct net_device *dev,
 					 struct ieee80211_if_sta *ifsta)
 {
@@ -587,6 +678,16 @@ static void ieee80211_set_associated(struct net_device *dev,
 static void ieee80211_set_disassoc(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta, int deauth)
 {
+	/* Reset power level.
+	   Get the tx power from the current channel/user. */
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+
+	if (ifsta->country_max_pwr || local->hw.conf.tpc_pwr_limit) {
+		ifsta->country_max_pwr = 0;
+		local->hw.conf.tpc_pwr_limit = 0;
+		ieee80211_hw_config(local);
+	}
+
 	if (deauth)
 		ifsta->auth_tries = 0;
 	ifsta->assoc_tries = 0;
@@ -3049,6 +3150,13 @@ static void ieee80211_rx_mgmt_beacon(struct net_device *dev,
 					       &bss_info);
 	}
 
+	if (elems.country_elem)
+		changed |= ieee80211_sta_process_country(ifsta, local,
+				 elems.country_elem, elems.country_elem_len);
+
+	if (changed & BSS_CHANGED_PWR)
+		ieee80211_hw_config(local);
+
 	ieee80211_bss_info_change_notify(sdata, changed);
 }
 
@@ -4053,6 +4161,8 @@ void ieee80211_sta_scan_work(struct work_struct *work)
 
 		if (!skip) {
 			local->scan_channel = chan;
+			local->hw.conf.tpc_pwr_limit = 0;
+			sdata->u.sta.country_max_pwr = 0;
 			if (ieee80211_hw_config(local)) {
 				printk(KERN_DEBUG "%s: failed to set freq to "
 				       "%d MHz for scan\n", dev->name,
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 5af3862..8862303 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -322,9 +322,11 @@ int ieee80211_set_freq(struct net_device *dev, int freqMHz)
 
 		if (local->sta_sw_scanning || local->sta_hw_scanning)
 			ret = 0;
-		else
+		else {
+			local->hw.conf.tpc_pwr_limit = 0;
+			sdata->u.sta.country_max_pwr = 0;
 			ret = ieee80211_hw_config(local);
-
+		}
 		rate_control_clear(local);
 	}
 
@@ -657,7 +659,6 @@ static int ieee80211_ioctl_siwtxpower(struct net_device *dev,
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	bool need_reconfig = 0;
-	int new_power_level;
 
 	if ((data->txpower.flags & IW_TXPOW_TYPE) != IW_TXPOW_DBM)
 		return -EINVAL;
@@ -665,21 +666,18 @@ static int ieee80211_ioctl_siwtxpower(struct net_device *dev,
 		return -EINVAL;
 
 	if (data->txpower.fixed) {
-		new_power_level = data->txpower.value;
-	} else {
+		if (data->txpower.value <= 0)
+			return -EINVAL;
+		if (local->hw.conf.user_pwr_limit != data->txpower.value) {
+			local->hw.conf.user_pwr_limit = data->txpower.value;
+			need_reconfig = 1;
+		}
+	} else if (local->hw.conf.user_pwr_limit != 0) {
 		/*
 		 * Automatic power level. Use maximum power for the current
 		 * channel. Should be part of rate control.
 		 */
-		struct ieee80211_channel* chan = local->hw.conf.channel;
-		if (!chan)
-			return -EINVAL;
-
-		new_power_level = chan->max_power;
-	}
-
-	if (local->hw.conf.power_level != new_power_level) {
-		local->hw.conf.power_level = new_power_level;
+		 local->hw.conf.user_pwr_limit = 0;
 		need_reconfig = 1;
 	}
 
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

