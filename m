Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:60915 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbaBJNXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 08:23:09 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211_hwsim: allow creation of single-channel radios with chanctx
Date: Mon, 10 Feb 2014 15:23:03 +0200
Message-Id: <1392038583-12941-1-git-send-email-luca@coelho.fi> (sfid-20140210_142313_636226_E9CB6FB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Add a new HWSIM_ATTR_USE_CHANCTX attribute to the
HWSIM_CMD_CREATE_RADIO command to allow the creation of radios with
one channel that use channel contexts.  If this attribute is not
present, the behaviour is the same as before (ie. single channel
radios don't use channel contexts and multi channel radios do).

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 29 +++++++++++++++++++++--------
 drivers/net/wireless/mac80211_hwsim.h |  4 ++++
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 771b8c5..719badb 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -411,6 +411,7 @@ struct mac80211_hwsim_data {
 
 	struct mac_address addresses[2];
 	int channels, idx;
+	bool use_chanctx;
 
 	struct ieee80211_channel *tmp_chan;
 	struct delayed_work roc_done;
@@ -1088,7 +1089,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 		return;
 	}
 
-	if (data->channels == 1) {
+	if (!data->use_chanctx) {
 		channel = data->channel;
 	} else if (txi->hw_queue == 4) {
 		channel = data->tmp_chan;
@@ -1354,7 +1355,7 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 
 	data->channel = conf->chandef.chan;
 
-	WARN_ON(data->channel && data->channels > 1);
+	WARN_ON(data->channel && data->use_chanctx);
 
 	data->power_level = conf->power_level;
 	if (!data->started || !data->beacon_int)
@@ -1940,7 +1941,8 @@ static struct ieee80211_ops mac80211_hwsim_mchan_ops;
 
 static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 				       const struct ieee80211_regdomain *regd,
-				       bool reg_strict, bool p2p_device)
+				       bool reg_strict, bool p2p_device,
+				       bool use_chanctx)
 {
 	int err;
 	u8 addr[ETH_ALEN];
@@ -1950,11 +1952,14 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 	const struct ieee80211_ops *ops = &mac80211_hwsim_ops;
 	int idx;
 
+	if (WARN_ON(channels > 1 && !use_chanctx))
+		return -EINVAL;
+
 	spin_lock_bh(&hwsim_radio_lock);
 	idx = hwsim_radio_idx++;
 	spin_unlock_bh(&hwsim_radio_lock);
 
-	if (channels > 1)
+	if (use_chanctx)
 		ops = &mac80211_hwsim_mchan_ops;
 	hw = ieee80211_alloc_hw(sizeof(*data), ops);
 	if (!hw) {
@@ -1995,9 +2000,10 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 	hw->wiphy->addresses = data->addresses;
 
 	data->channels = channels;
+	data->use_chanctx = use_chanctx;
 	data->idx = idx;
 
-	if (data->channels > 1) {
+	if (data->use_chanctx) {
 		hw->wiphy->max_scan_ssids = 255;
 		hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
 		hw->wiphy->max_remain_on_channel_duration = 1000;
@@ -2156,7 +2162,7 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 	debugfs_create_file("ps", 0666, data->debugfs, data, &hwsim_fops_ps);
 	debugfs_create_file("group", 0666, data->debugfs, data,
 			    &hwsim_fops_group);
-	if (data->channels == 1)
+	if (!data->use_chanctx)
 		debugfs_create_file("dfs_simulate_radar", 0222,
 				    data->debugfs,
 				    data, &hwsim_simulate_radar);
@@ -2423,10 +2429,16 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	const struct ieee80211_regdomain *regd = NULL;
 	bool reg_strict = info->attrs[HWSIM_ATTR_REG_STRICT_REG];
 	bool p2p_device = info->attrs[HWSIM_ATTR_SUPPORT_P2P_DEVICE];
+	bool use_chanctx;
 
 	if (info->attrs[HWSIM_ATTR_CHANNELS])
 		chans = nla_get_u32(info->attrs[HWSIM_ATTR_CHANNELS]);
 
+	if(info->attrs[HWSIM_ATTR_USE_CHANCTX])
+		use_chanctx = true;
+	else
+		use_chanctx = (chans > 1);
+
 	if (info->attrs[HWSIM_ATTR_REG_HINT_ALPHA2])
 		alpha2 = nla_data(info->attrs[HWSIM_ATTR_REG_HINT_ALPHA2]);
 
@@ -2439,7 +2451,7 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	}
 
 	return mac80211_hwsim_create_radio(chans, alpha2, regd, reg_strict,
-					   p2p_device);
+					   p2p_device, use_chanctx);
 }
 
 static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
@@ -2658,7 +2670,8 @@ static int __init init_mac80211_hwsim(void)
 
 		err = mac80211_hwsim_create_radio(channels, reg_alpha2,
 						  regd, reg_strict,
-						  support_p2p_device);
+						  support_p2p_device,
+						  channels > 1);
 		if (err < 0)
 			goto out_free_radios;
 	}
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 6e72996..c9d0315 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -108,6 +108,9 @@ enum {
  * @HWSIM_ATTR_REG_CUSTOM_REG: custom regulatory domain index (u32 attribute)
  * @HWSIM_ATTR_REG_STRICT_REG: request REGULATORY_STRICT_REG (flag attribute)
  * @HWSIM_ATTR_SUPPORT_P2P_DEVICE: support P2P Device virtual interface (flag)
+ * @HWSIM_ATTR_USE_CHANCTX: used with the %HWSIM_CMD_CREATE_RADIO
+ *	command to force use of channel contexts even when only a
+ *	single channel is supported
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -128,6 +131,7 @@ enum {
 	HWSIM_ATTR_REG_CUSTOM_REG,
 	HWSIM_ATTR_REG_STRICT_REG,
 	HWSIM_ATTR_SUPPORT_P2P_DEVICE,
+	HWSIM_ATTR_USE_CHANCTX,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
1.8.5.3

