Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:52520 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaK0NjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 08:39:10 -0500
Received: by mail-wg0-f45.google.com with SMTP id b13so6543532wgh.18
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2014 05:39:09 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de, adrian@freebsd.org
Subject: [PATCH] mac80211: enable TPC through mac80211 stack
Date: Thu, 27 Nov 2014 14:39:07 +0100
Message-Id: <1417095547-12197-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141127_143914_356282_629B2B45)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure per packet Transmit Power Control (TPC) in lower drivers checking
if user_power_level has been set to IEEE80211_UNSET_POWER_LEVEL

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 include/net/mac80211.h | 5 +++++
 net/mac80211/iface.c   | 7 ++++++-
 net/mac80211/main.c    | 8 +++++++-
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cff3a26..233626d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -376,6 +376,7 @@ enum ieee80211_rssi_event {
  * @ssid_len: Length of SSID given in @ssid.
  * @hidden_ssid: The SSID of the current vif is hidden. Only valid in AP-mode.
  * @txpower: TX power in dBm
+ * @tpc_enabled: enable/disable per packet Transmit Power Control (TPC)
  * @p2p_noa_attr: P2P NoA attribute for P2P powersave
  */
 struct ieee80211_bss_conf {
@@ -411,6 +412,7 @@ struct ieee80211_bss_conf {
 	size_t ssid_len;
 	bool hidden_ssid;
 	int txpower;
+	bool tpc_enabled;
 	struct ieee80211_p2p_noa_attr p2p_noa_attr;
 };
 
@@ -1115,6 +1117,8 @@ enum ieee80211_smps_mode {
  *
  * @power_level: requested transmit power (in dBm), backward compatibility
  *	value only that is set to the minimum of all interfaces
+ * @tpc_enabled: enable/disable per packet Transmit Power Control (TPC) in
+ *	lower driver
  *
  * @chandef: the channel definition to tune to
  * @radar_enabled: whether radar detection is enabled
@@ -1135,6 +1139,7 @@ enum ieee80211_smps_mode {
 struct ieee80211_conf {
 	u32 flags;
 	int power_level, dynamic_ps_timeout;
+	bool tpc_enabled;
 	int max_sleep_period;
 
 	u16 listen_interval;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 538fe4e..70c94a3 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -47,6 +47,7 @@ bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	int power;
+	bool tpc_enabled;
 
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
@@ -64,8 +65,12 @@ bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
 	if (sdata->ap_power_level != IEEE80211_UNSET_POWER_LEVEL)
 		power = min(power, sdata->ap_power_level);
 
-	if (power != sdata->vif.bss_conf.txpower) {
+	tpc_enabled = (sdata->user_power_level == IEEE80211_UNSET_POWER_LEVEL);
+
+	if (power != sdata->vif.bss_conf.txpower ||
+	    tpc_enabled != sdata->vif.bss_conf.tpc_enabled) {
 		sdata->vif.bss_conf.txpower = power;
+		sdata->vif.bss_conf.tpc_enabled = tpc_enabled;
 		ieee80211_hw_config(sdata->local, 0);
 		return true;
 	}
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6ab99da..bfcaeee 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -100,6 +100,7 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 	u32 changed = 0;
 	int power;
 	u32 offchannel_flag;
+	bool tpc_enabled = false;
 
 	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
 
@@ -152,12 +153,17 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 			continue;
 		power = min(power, sdata->vif.bss_conf.txpower);
+
+		if (!tpc_enabled && sdata->vif.bss_conf.tpc_enabled)
+			tpc_enabled = true;
 	}
 	rcu_read_unlock();
 
-	if (local->hw.conf.power_level != power) {
+	if (local->hw.conf.power_level != power ||
+	    local->hw.conf.tpc_enabled != tpc_enabled) {
 		changed |= IEEE80211_CONF_CHANGE_POWER;
 		local->hw.conf.power_level = power;
+		local->hw.conf.tpc_enabled = tpc_enabled;
 	}
 
 	return changed;
-- 
2.1.0

