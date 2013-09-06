Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36415 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab3IFNGK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Sep 2013 09:06:10 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 2/2] mac80211: implement support for configuring antenna gain
Date: Fri,  6 Sep 2013 15:06:03 +0200
Message-Id: <1378472763-36062-2-git-send-email-nbd@openwrt.org> (sfid-20130906_150616_741395_262EAC8C)
In-Reply-To: <1378472763-36062-1-git-send-email-nbd@openwrt.org>
References: <1378472763-36062-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Report the maximum allowable extra antenna gain to the driver to allow
it to reduce the tx power even further based on internal data

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h     |  2 ++
 net/mac80211/cfg.c         | 14 ++++++++++++++
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/main.c        | 18 ++++++++++++++++--
 4 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4be8785..c7272fe 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1019,6 +1019,7 @@ enum ieee80211_smps_mode {
  *
  * @power_level: requested transmit power (in dBm), backward compatibility
  *	value only that is set to the minimum of all interfaces
+ * @max_antenna_gain: maximum antenna gain adjusted by user config (in dBi)
  *
  * @chandef: the channel definition to tune to
  * @radar_enabled: whether radar detection is enabled
@@ -1040,6 +1041,7 @@ struct ieee80211_conf {
 	u32 flags;
 	int power_level, dynamic_ps_timeout;
 	int max_sleep_period;
+	int max_antenna_gain;
 
 	u16 listen_interval;
 	u8 ps_dtim_period;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2e7855a..4d75e73 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2284,6 +2284,19 @@ static int ieee80211_get_tx_power(struct wiphy *wiphy,
 	return 0;
 }
 
+static int ieee80211_set_antenna_gain(struct wiphy *wiphy, int dbi)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	if (dbi < 0)
+		return -EINVAL;
+
+	local->user_antenna_gain = dbi;
+	ieee80211_hw_config(local, 0);
+
+	return 0;
+}
+
 static int ieee80211_set_wds_peer(struct wiphy *wiphy, struct net_device *dev,
 				  const u8 *addr)
 {
@@ -3658,6 +3671,7 @@ struct cfg80211_ops mac80211_config_ops = {
 	.set_wiphy_params = ieee80211_set_wiphy_params,
 	.set_tx_power = ieee80211_set_tx_power,
 	.get_tx_power = ieee80211_get_tx_power,
+	.set_antenna_gain = ieee80211_set_antenna_gain,
 	.set_wds_peer = ieee80211_set_wds_peer,
 	.rfkill_poll = ieee80211_rfkill_poll,
 	CFG80211_TESTMODE_CMD(ieee80211_testmode_cmd)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b618651..c303b18 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1155,6 +1155,7 @@ struct ieee80211_local {
 	int dynamic_ps_forced_timeout;
 
 	int user_power_level; /* in dBm, for all interfaces */
+	int user_antenna_gain; /* in dBi */
 
 	enum ieee80211_smps_mode smps_mode;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 21d5d44..47312d6 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -97,7 +97,7 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 	struct ieee80211_sub_if_data *sdata;
 	struct cfg80211_chan_def chandef = {};
 	u32 changed = 0;
-	int power;
+	int power, ant_gain, max_power;
 	u32 offchannel_flag;
 
 	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
@@ -152,8 +152,21 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 	}
 	rcu_read_unlock();
 
-	if (local->hw.conf.power_level != power) {
+	max_power = chandef.chan->max_reg_power;
+	ant_gain = chandef.chan->max_antenna_gain;
+	if (local->user_antenna_gain > 0) {
+		if (local->user_antenna_gain > ant_gain) {
+			max_power -= local->user_antenna_gain - ant_gain;
+			ant_gain = 0;
+		} else
+			ant_gain -= local->user_antenna_gain;
+		power = min(power, max_power);
+	}
+
+	if (local->hw.conf.power_level != power ||
+	    local->hw.conf.max_antenna_gain != ant_gain) {
 		changed |= IEEE80211_CONF_CHANGE_POWER;
+		local->hw.conf.max_antenna_gain = ant_gain;
 		local->hw.conf.power_level = power;
 	}
 
@@ -583,6 +596,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					 IEEE80211_RADIOTAP_MCS_HAVE_BW;
 	local->hw.radiotap_vht_details = IEEE80211_RADIOTAP_VHT_KNOWN_GI |
 					 IEEE80211_RADIOTAP_VHT_KNOWN_BANDWIDTH;
+	local->user_antenna_gain = 0;
 	local->hw.uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
 	local->hw.uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
 	local->user_power_level = IEEE80211_UNSET_POWER_LEVEL;
-- 
1.8.0.2

