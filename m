Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33789 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752150AbeCEOtO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 09:49:14 -0500
Received: by mail-pg0-f67.google.com with SMTP id g12so6905753pgs.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2018 06:49:14 -0800 (PST)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 07/10] rsi: regulatory modifications for 'dlcar' mode
Date: Mon,  5 Mar 2018 20:06:57 +0530
Message-Id: <1520260620-4694-8-git-send-email-amitkarwar@gmail.com> (sfid-20180305_154919_936347_761757D9)
In-Reply-To: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Changes in this patch are for applying custom regulatory
rules for 'dlcar' regulatory mode. Max channel power values
are updated for 12, 13, and 14. Dlcar only has 2.4GHz band.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |  30 +++++-
 drivers/net/wireless/rsi/rsi_91x_main.c     |   2 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 140 ++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_main.h         |   3 +-
 drivers/net/wireless/rsi/rsi_mgmt.h         |   4 +
 5 files changed, 173 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index ef7cabf..a7e1f7d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1666,7 +1666,8 @@ static int rsi_mac80211_get_antenna(struct ieee80211_hw *hw,
 	return 0;	
 }
 
-static int rsi_map_region_code(enum nl80211_dfs_regions region_code)
+static enum rsi_dfs_regions rsi_map_region_code
+				(enum nl80211_dfs_regions region_code)
 {
 	switch (region_code) {
 	case NL80211_DFS_FCC:
@@ -1681,6 +1682,22 @@ static int rsi_map_region_code(enum nl80211_dfs_regions region_code)
 	return RSI_REGION_WORLD;
 }
 
+static char *dfsreg_str(enum rsi_dfs_regions reg)
+{
+	switch (reg) {
+	case RSI_REGION_FCC:
+		return "FCC";
+	case RSI_REGION_ETSI:
+		return "ETSI";
+	case RSI_REGION_TELEC:
+		return "TELEC";
+	case RSI_REGION_WORLD:
+		return "WORLD";
+	default:
+		return "INVALID";
+	}
+}
+
 static void rsi_reg_notify(struct wiphy *wiphy,
 			   struct regulatory_request *request)
 {
@@ -1693,7 +1710,8 @@ static void rsi_reg_notify(struct wiphy *wiphy,
 	
 	mutex_lock(&common->mutex);
 
-	rsi_dbg(INFO_ZONE, "country = %s dfs_region = %d\n",
+	rsi_dbg(INFO_ZONE,
+		"Regulatory notifcation: country: %s region:%d\n",
 		request->alpha2, request->dfs_region);
 
 	if (common->num_supp_bands > 1) {
@@ -1708,11 +1726,13 @@ static void rsi_reg_notify(struct wiphy *wiphy,
 				ch->flags |= IEEE80211_CHAN_NO_IR;
 		}
 	}
-	adapter->dfs_region = rsi_map_region_code(request->dfs_region);
-	rsi_dbg(INFO_ZONE, "RSI region code = %d\n", adapter->dfs_region);
-	
 	adapter->country[0] = request->alpha2[0];
 	adapter->country[1] = request->alpha2[1];
+	adapter->dfs_region = rsi_map_region_code(request->dfs_region);
+	if (adapter->reg_mode == RSI_REG_DLCAR)
+		rsi_apply_dlcar_reg_rules(adapter);
+
+	rsi_dbg(INFO_ZONE, "DFS region: %s", dfsreg_str(adapter->dfs_region));
 
 	mutex_unlock(&common->mutex);
 }
diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index e290779..7790314 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -352,6 +352,8 @@ struct rsi_hw *rsi_91x_init(u16 oper_mode)
 	common->init_done = true;
 	adapter->device_model = RSI_DEV_9113;
 	common->oper_mode = oper_mode;
+	adapter->reg_mode = rsi_reg;
+	rsi_dbg(INFO_ZONE, "Reg mode = %d\n", adapter->reg_mode);
 
 	/* Determine coex mode */
 	switch (common->oper_mode) {
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 0444025..4ba5966 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -211,6 +211,28 @@ static struct bootup_params boot_params_40 = {
 
 static u16 mcs[] = {13, 26, 39, 52, 78, 104, 117, 130};
 
+struct reg_map {
+	char country_code[2];
+	u8 region_code;
+};
+
+#define MAX_REG_COUNTRIES	30
+static struct reg_map rsi_dlcar_reg_map[MAX_REG_COUNTRIES] = {
+	{"AU", RSI_REGION_ETSI}, {"AT", RSI_REGION_ETSI},
+	{"BE", RSI_REGION_ETSI}, {"BR", RSI_REGION_WORLD},
+	{"CA", RSI_REGION_FCC}, {"CL", RSI_REGION_WORLD},
+	{"CN", RSI_REGION_WORLD}, {"CO", RSI_REGION_FCC},
+	{"CZ", RSI_REGION_ETSI}, {"DK", RSI_REGION_ETSI},
+	{"FI", RSI_REGION_ETSI}, {"FR", RSI_REGION_ETSI},
+	{"DE", RSI_REGION_ETSI}, {"HK", RSI_REGION_WORLD},
+	{"IN", RSI_REGION_WORLD}, {"ID", RSI_REGION_WORLD},
+	{"IE", RSI_REGION_ETSI}, {"IL", RSI_REGION_ETSI},
+	{"IT", RSI_REGION_ETSI}, {"JP", RSI_REGION_TELEC},
+	{"KR", RSI_REGION_WORLD}, {"LU", RSI_REGION_ETSI},
+	{"MY", RSI_REGION_WORLD}, {"MX", RSI_REGION_FCC},
+	{"MA", RSI_REGION_WORLD}, {"NL", RSI_REGION_ETSI},
+};
+
 /**
  * rsi_set_default_parameters() - This function sets default parameters.
  * @common: Pointer to the driver private structure.
@@ -986,6 +1008,120 @@ int rsi_band_check(struct rsi_common *common,
 	return status;
 }
 
+enum rsi_chan_type {
+	RSI_CHAN_11B = 0,
+	RSI_CHAN_11G,
+	RSI_CHAN_HT_20,
+	RSI_CHAN_HT_40
+};
+
+static enum rsi_chan_type rsi_get_chan_type(struct rsi_hw *adapter)
+{
+	struct ieee80211_bss_conf *bss;
+	u16 ch_type = RSI_CHAN_11B;
+	u8 i;
+
+	for (i = 0; i < adapter->sc_nvifs; i++) {
+		bss = &adapter->vifs[i]->bss_conf;
+
+		if (ch_type < RSI_CHAN_11G && !conf_is_ht(&adapter->hw->conf)) {
+			if (bss->basic_rates & 0xfff0)
+				ch_type = RSI_CHAN_11G;
+		} else {
+			if (ch_type < RSI_CHAN_HT_20 &&
+			    conf_is_ht20(&adapter->hw->conf))
+				ch_type = RSI_CHAN_HT_20;
+			else if (conf_is_ht40(&adapter->hw->conf))
+				ch_type = RSI_CHAN_HT_40;
+		}
+	}
+	return ch_type;
+}
+
+void rsi_apply_dlcar_power_values(struct rsi_hw *adapter,
+				  struct ieee80211_channel *ch)
+{
+	enum rsi_chan_type ch_type;
+
+	ch_type = rsi_get_chan_type(adapter);
+	switch (ch_type) {
+	case RSI_CHAN_11B:
+		if (ch->hw_value == 12)
+			ch->max_power = 15;
+		else if (ch->hw_value == 13)
+			ch->max_power = 7;
+		else
+			return;
+		break;
+	case RSI_CHAN_11G:
+		if (ch->hw_value == 12)
+			ch->max_power = 8;
+		else if (ch->hw_value == 13)
+			ch->max_power = 7;
+		else
+			return;
+	case RSI_CHAN_HT_20:
+		if (ch->hw_value == 12)
+			ch->max_power = 7;
+		else if (ch->hw_value == 13)
+			ch->max_power = 5;
+		else
+			return;
+	case RSI_CHAN_HT_40:
+		if (ch->hw_value == 6)
+			ch->max_power = 9;
+		else if (ch->hw_value == 9)
+			ch->max_power = 5;
+		else if (ch->hw_value == 10)
+			ch->max_power = 4;
+		else
+			return;
+	}
+	ch->max_antenna_gain = 0;
+}
+
+void rsi_apply_dlcar_reg_rules(struct rsi_hw *adapter)
+{
+	struct ieee80211_supported_band *sband =
+			adapter->hw->wiphy->bands[NL80211_BAND_2GHZ];
+	struct ieee80211_channel *ch;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(rsi_dlcar_reg_map); i++) {
+		if (!memcmp(rsi_dlcar_reg_map[i].country_code,
+			    adapter->country, 2)) {
+			adapter->dfs_region = rsi_dlcar_reg_map[i].region_code;
+			break;
+		}
+	}
+	for (i = 0; i < sband->n_channels; i++) {
+		ch = &sband->channels[i];
+
+		if (ch->hw_value < 12)
+			continue;
+
+		switch (adapter->dfs_region) {
+		case RSI_REGION_FCC:
+			if (ch->hw_value == 12 || ch->hw_value == 13) {
+				ch->flags &= ~IEEE80211_CHAN_DISABLED;
+				ch->flags &= ~IEEE80211_CHAN_NO_IR;
+				rsi_apply_dlcar_power_values(adapter, ch);
+			}
+			break;
+		case RSI_REGION_WORLD:
+		case RSI_REGION_ETSI:
+			if (ch->hw_value == 12 || ch->hw_value == 13)
+				rsi_apply_dlcar_power_values(adapter, ch);
+			break;
+		case RSI_REGION_TELEC:
+			if (ch->hw_value == 12 || ch->hw_value == 13 ||
+			    ch->hw_value == 14)
+				rsi_apply_dlcar_power_values(adapter, ch);
+			break;
+		}
+	}
+}
+
 /**
  * rsi_set_channel() - This function programs the channel.
  * @common: Pointer to the driver private structure.
@@ -1024,6 +1160,10 @@ int rsi_set_channel(struct rsi_common *common,
 	chan_cfg->antenna_gain_offset_5g = channel->max_antenna_gain;
 	chan_cfg->region_rftype = (RSI_RF_TYPE & 0xf) << 4;
 
+	if (common->priv->reg_mode == RSI_REG_DLCAR) {
+		rsi_apply_dlcar_power_values(common->priv, channel);
+		chan_cfg->flags = RSI_CHAN_FLAGS_DLCAR;
+	}
 	if ((channel->flags & IEEE80211_CHAN_NO_IR) ||
 	    (channel->flags & IEEE80211_CHAN_RADAR)) {
 		chan_cfg->antenna_gain_offset_2g |= RSI_CHAN_RADAR;
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index e2bbbbd..4521c43 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -367,8 +367,9 @@ struct rsi_hw {
 	u32 flash_capacity;
 	struct eepromrw_info eeprom;
 	u32 interrupt_status;
-	u8 dfs_region;
+	enum rsi_dfs_regions dfs_region;
 	char country[2];
+	u16 reg_mode;
 	void *rsi_dev;
 	struct rsi_host_intf_ops *host_intf_ops;
 	int (*check_hw_queue_status)(struct rsi_hw *adapter, u8 q_num);
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index f21fdd4..65ae037 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -387,6 +387,7 @@ struct rsi_bb_rf_prog {
 	__le16 flags;
 } __packed;
 
+#define RSI_CHAN_FLAGS_DLCAR	BIT(2)
 struct rsi_chan_config {
 	struct rsi_cmd_desc_dword0 desc_dword0;
 	struct rsi_cmd_desc_dword1 desc_dword1;
@@ -736,4 +737,7 @@ void rsi_fgscan_start(struct work_struct *data);
 void init_bgscan_params(struct rsi_common *common);
 int rsi_send_bgscan_params(struct rsi_common *common, int enable);
 int rsi_send_bgscan_probe_req(struct rsi_common *common);
+void rsi_apply_dlcar_power_values(struct rsi_hw *adapter,
+				  struct ieee80211_channel *ch);
+void rsi_apply_dlcar_reg_rules(struct rsi_hw *adapter);
 #endif
-- 
2.7.4
