Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:21758 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964798AbaJ3PgM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 11:36:12 -0400
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/2] mac80211-hwsim: Provide multicast event for HWSIM_CMD_NEW_RADIO
Date: Thu, 30 Oct 2014 17:34:25 +0200
Message-Id: <1414683266-28427-2-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141030_163618_234793_64735621)
In-Reply-To: <1414683266-28427-1-git-send-email-jukka.rissanen@linux.intel.com>
References: <1414683266-28427-1-git-send-email-jukka.rissanen@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When adding new radio via HWSIM_CMD_NEW_RADIO then listeners on the
multicast group "config" are informed.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 242 +++++++++++++++++++++++++---------
 1 file changed, 179 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index babbdc1..ff187fe 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -476,6 +476,14 @@ static struct genl_family hwsim_genl_family = {
 	.maxattr = HWSIM_ATTR_MAX,
 };
 
+enum hwsim_multicast_groups {
+	HWSIM_MCGRP_CONFIG,
+};
+
+static const struct genl_multicast_group hwsim_mcgrps[] = {
+	[HWSIM_MCGRP_CONFIG] = { .name = "config", },
+};
+
 /* MAC80211_HWSIM netlink policy */
 
 static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
@@ -1943,10 +1951,114 @@ static const struct ieee80211_ops mac80211_hwsim_ops = {
 
 static struct ieee80211_ops mac80211_hwsim_mchan_ops;
 
-static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
-				       const struct ieee80211_regdomain *regd,
-				       bool reg_strict, bool p2p_device,
-				       bool use_chanctx)
+struct hwsim_new_radio_params {
+	unsigned int channels;
+	const char *reg_alpha2;
+	const struct ieee80211_regdomain *regd;
+	bool reg_strict;
+	bool p2p_device;
+	bool use_chanctx;
+};
+
+static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
+				   struct genl_info *info)
+{
+	if (info)
+		genl_notify(&hwsim_genl_family, mcast_skb,
+			    genl_info_net(info), info->snd_portid,
+			    HWSIM_MCGRP_CONFIG, info->nlhdr, GFP_KERNEL);
+	else
+		genlmsg_multicast(&hwsim_genl_family, mcast_skb, 0,
+				  HWSIM_MCGRP_CONFIG, GFP_KERNEL);
+}
+
+static struct sk_buff *build_radio_msg(int cmd, int id,
+				       struct hwsim_new_radio_params *param)
+{
+	struct sk_buff *skb;
+	void *data;
+	int ret;
+
+	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!skb)
+		return NULL;
+
+	data = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0, cmd);
+	if (!data)
+		goto error;
+
+	ret = nla_put_u32(skb, HWSIM_ATTR_RADIO_ID, id);
+	if (ret < 0)
+		goto error;
+
+	if (param->channels) {
+		ret = nla_put_u32(skb, HWSIM_ATTR_CHANNELS, param->channels);
+		if (ret < 0)
+			goto error;
+	}
+
+	if (param->reg_alpha2) {
+		ret = nla_put(skb, HWSIM_ATTR_REG_HINT_ALPHA2, 2,
+			      param->reg_alpha2);
+		if (ret < 0)
+			goto error;
+	}
+
+	if (param->regd) {
+		int i;
+
+		for (i = 0; hwsim_world_regdom_custom[i] != param->regd &&
+		     i < ARRAY_SIZE(hwsim_world_regdom_custom); i++)
+			;
+
+		if (i < ARRAY_SIZE(hwsim_world_regdom_custom)) {
+			ret = nla_put_u32(skb, HWSIM_ATTR_REG_CUSTOM_REG, i);
+			if (ret < 0)
+				goto error;
+		}
+	}
+
+	if (param->reg_strict) {
+		ret = nla_put_flag(skb, HWSIM_ATTR_REG_STRICT_REG);
+		if (ret < 0)
+			goto error;
+	}
+
+	if (param->p2p_device) {
+		ret = nla_put_flag(skb, HWSIM_ATTR_SUPPORT_P2P_DEVICE);
+		if (ret < 0)
+			goto error;
+	}
+
+	if (param->use_chanctx) {
+		ret = nla_put_flag(skb, HWSIM_ATTR_USE_CHANCTX);
+		if (ret < 0)
+			goto error;
+	}
+
+	genlmsg_end(skb, data);
+
+	return skb;
+
+error:
+	nlmsg_free(skb);
+	return NULL;
+}
+
+static void hswim_mcast_new_radio(int id, struct genl_info *info,
+				  struct hwsim_new_radio_params *param)
+{
+	struct sk_buff *mcast_skb;
+
+	mcast_skb = build_radio_msg(HWSIM_CMD_NEW_RADIO, id, param);
+	if (!mcast_skb)
+		return;
+
+	hwsim_mcast_config_msg(mcast_skb, info);
+}
+
+static int mac80211_hwsim_new_radio(struct genl_info *info,
+				    struct hwsim_new_radio_params *param)
 {
 	int err;
 	u8 addr[ETH_ALEN];
@@ -1956,14 +2068,14 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 	const struct ieee80211_ops *ops = &mac80211_hwsim_ops;
 	int idx;
 
-	if (WARN_ON(channels > 1 && !use_chanctx))
+	if (WARN_ON(param->channels > 1 && !param->use_chanctx))
 		return -EINVAL;
 
 	spin_lock_bh(&hwsim_radio_lock);
 	idx = hwsim_radio_idx++;
 	spin_unlock_bh(&hwsim_radio_lock);
 
-	if (use_chanctx)
+	if (param->use_chanctx)
 		ops = &mac80211_hwsim_mchan_ops;
 	hw = ieee80211_alloc_hw(sizeof(*data), ops);
 	if (!hw) {
@@ -2003,8 +2115,8 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 	hw->wiphy->n_addresses = 2;
 	hw->wiphy->addresses = data->addresses;
 
-	data->channels = channels;
-	data->use_chanctx = use_chanctx;
+	data->channels = param->channels;
+	data->use_chanctx = param->use_chanctx;
 	data->idx = idx;
 
 	if (data->use_chanctx) {
@@ -2014,12 +2126,12 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 		/* For channels > 1 DFS is not allowed */
 		hw->wiphy->n_iface_combinations = 1;
 		hw->wiphy->iface_combinations = &data->if_combination;
-		if (p2p_device)
+		if (param->p2p_device)
 			data->if_combination = hwsim_if_comb_p2p_dev[0];
 		else
 			data->if_combination = hwsim_if_comb[0];
 		data->if_combination.num_different_channels = data->channels;
-	} else if (p2p_device) {
+	} else if (param->p2p_device) {
 		hw->wiphy->iface_combinations = hwsim_if_comb_p2p_dev;
 		hw->wiphy->n_iface_combinations =
 			ARRAY_SIZE(hwsim_if_comb_p2p_dev);
@@ -2040,7 +2152,7 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 				     BIT(NL80211_IFTYPE_ADHOC) |
 				     BIT(NL80211_IFTYPE_MESH_POINT);
 
-	if (p2p_device)
+	if (param->p2p_device)
 		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_P2P_DEVICE);
 
 	hw->flags = IEEE80211_HW_MFP_CAPABLE |
@@ -2142,11 +2254,11 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 	hw->max_rates = 4;
 	hw->max_rate_tries = 11;
 
-	if (reg_strict)
+	if (param->reg_strict)
 		hw->wiphy->regulatory_flags |= REGULATORY_STRICT_REG;
-	if (regd) {
+	if (param->regd) {
 		hw->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
-		wiphy_apply_custom_regulatory(hw->wiphy, regd);
+		wiphy_apply_custom_regulatory(hw->wiphy, param->regd);
 		/* give the regulatory workqueue a chance to run */
 		schedule_timeout_interruptible(1);
 	}
@@ -2160,8 +2272,8 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 
 	wiphy_debug(hw->wiphy, "hwaddr %pM registered\n", hw->wiphy->perm_addr);
 
-	if (reg_alpha2)
-		regulatory_hint(hw->wiphy, reg_alpha2);
+	if (param->reg_alpha2)
+		regulatory_hint(hw->wiphy, param->reg_alpha2);
 
 	data->debugfs = debugfs_create_dir("hwsim", hw->wiphy->debugfsdir);
 	debugfs_create_file("ps", 0666, data->debugfs, data, &hwsim_fops_ps);
@@ -2180,6 +2292,9 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 	list_add_tail(&data->list, &hwsim_radios);
 	spin_unlock_bh(&hwsim_radio_lock);
 
+	if (idx > 0)
+		hswim_mcast_new_radio(idx, info, param);
+
 	return idx;
 
 failed_hw:
@@ -2427,36 +2542,35 @@ static int hwsim_register_received_nl(struct sk_buff *skb_2,
 	return 0;
 }
 
-static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
+static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 {
-	unsigned int chans = channels;
-	const char *alpha2 = NULL;
-	const struct ieee80211_regdomain *regd = NULL;
-	bool reg_strict = info->attrs[HWSIM_ATTR_REG_STRICT_REG];
-	bool p2p_device = info->attrs[HWSIM_ATTR_SUPPORT_P2P_DEVICE];
-	bool use_chanctx;
+	struct hwsim_new_radio_params param =  { 0 };
+
+	param.reg_strict = info->attrs[HWSIM_ATTR_REG_STRICT_REG];
+	param.p2p_device = info->attrs[HWSIM_ATTR_SUPPORT_P2P_DEVICE];
+	param.channels = channels;
 
 	if (info->attrs[HWSIM_ATTR_CHANNELS])
-		chans = nla_get_u32(info->attrs[HWSIM_ATTR_CHANNELS]);
+		param.channels = nla_get_u32(info->attrs[HWSIM_ATTR_CHANNELS]);
 
 	if (info->attrs[HWSIM_ATTR_USE_CHANCTX])
-		use_chanctx = true;
+		param.use_chanctx = true;
 	else
-		use_chanctx = (chans > 1);
+		param.use_chanctx = (param.channels > 1);
 
 	if (info->attrs[HWSIM_ATTR_REG_HINT_ALPHA2])
-		alpha2 = nla_data(info->attrs[HWSIM_ATTR_REG_HINT_ALPHA2]);
+		param.reg_alpha2 =
+			nla_data(info->attrs[HWSIM_ATTR_REG_HINT_ALPHA2]);
 
 	if (info->attrs[HWSIM_ATTR_REG_CUSTOM_REG]) {
 		u32 idx = nla_get_u32(info->attrs[HWSIM_ATTR_REG_CUSTOM_REG]);
 
 		if (idx >= ARRAY_SIZE(hwsim_world_regdom_custom))
 			return -EINVAL;
-		regd = hwsim_world_regdom_custom[idx];
+		param.regd = hwsim_world_regdom_custom[idx];
 	}
 
-	return mac80211_hwsim_create_radio(chans, alpha2, regd, reg_strict,
-					   p2p_device, use_chanctx);
+	return mac80211_hwsim_new_radio(info, &param);
 }
 
 static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
@@ -2501,9 +2615,9 @@ static const struct genl_ops hwsim_ops[] = {
 		.doit = hwsim_tx_info_frame_received_nl,
 	},
 	{
-		.cmd = HWSIM_CMD_CREATE_RADIO,
+		.cmd = HWSIM_CMD_NEW_RADIO,
 		.policy = hwsim_genl_policy,
-		.doit = hwsim_create_radio_nl,
+		.doit = hwsim_new_radio_nl,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
@@ -2542,7 +2656,9 @@ static int hwsim_init_netlink(void)
 
 	printk(KERN_INFO "mac80211_hwsim: initializing netlink\n");
 
-	rc = genl_register_family_with_ops(&hwsim_genl_family, hwsim_ops);
+	rc = genl_register_family_with_ops_groups(&hwsim_genl_family,
+						  hwsim_ops,
+						  hwsim_mcgrps);
 	if (rc)
 		goto failure;
 
@@ -2603,69 +2719,73 @@ static int __init init_mac80211_hwsim(void)
 		goto out_unregister_driver;
 	}
 
+	err = hwsim_init_netlink();
+	if (err < 0)
+		goto out_unregister_driver;
+
 	for (i = 0; i < radios; i++) {
-		const char *reg_alpha2 = NULL;
-		const struct ieee80211_regdomain *regd = NULL;
-		bool reg_strict = false;
+		struct hwsim_new_radio_params param =  { 0 };
+
+		param.channels = channels;
 
 		switch (regtest) {
 		case HWSIM_REGTEST_DIFF_COUNTRY:
 			if (i < ARRAY_SIZE(hwsim_alpha2s))
-				reg_alpha2 = hwsim_alpha2s[i];
+				param.reg_alpha2 = hwsim_alpha2s[i];
 			break;
 		case HWSIM_REGTEST_DRIVER_REG_FOLLOW:
 			if (!i)
-				reg_alpha2 = hwsim_alpha2s[0];
+				param.reg_alpha2 = hwsim_alpha2s[0];
 			break;
 		case HWSIM_REGTEST_STRICT_ALL:
-			reg_strict = true;
+			param.reg_strict = true;
 		case HWSIM_REGTEST_DRIVER_REG_ALL:
-			reg_alpha2 = hwsim_alpha2s[0];
+			param.reg_alpha2 = hwsim_alpha2s[0];
 			break;
 		case HWSIM_REGTEST_WORLD_ROAM:
 			if (i == 0)
-				regd = &hwsim_world_regdom_custom_01;
+				param.regd = &hwsim_world_regdom_custom_01;
 			break;
 		case HWSIM_REGTEST_CUSTOM_WORLD:
-			regd = &hwsim_world_regdom_custom_01;
+			param.regd = &hwsim_world_regdom_custom_01;
 			break;
 		case HWSIM_REGTEST_CUSTOM_WORLD_2:
 			if (i == 0)
-				regd = &hwsim_world_regdom_custom_01;
+				param.regd = &hwsim_world_regdom_custom_01;
 			else if (i == 1)
-				regd = &hwsim_world_regdom_custom_02;
+				param.regd = &hwsim_world_regdom_custom_02;
 			break;
 		case HWSIM_REGTEST_STRICT_FOLLOW:
 			if (i == 0) {
-				reg_strict = true;
-				reg_alpha2 = hwsim_alpha2s[0];
+				param.reg_strict = true;
+				param.reg_alpha2 = hwsim_alpha2s[0];
 			}
 			break;
 		case HWSIM_REGTEST_STRICT_AND_DRIVER_REG:
 			if (i == 0) {
-				reg_strict = true;
-				reg_alpha2 = hwsim_alpha2s[0];
+				param.reg_strict = true;
+				param.reg_alpha2 = hwsim_alpha2s[0];
 			} else if (i == 1) {
-				reg_alpha2 = hwsim_alpha2s[1];
+				param.reg_alpha2 = hwsim_alpha2s[1];
 			}
 			break;
 		case HWSIM_REGTEST_ALL:
 			switch (i) {
 			case 0:
-				regd = &hwsim_world_regdom_custom_01;
+				param.regd = &hwsim_world_regdom_custom_01;
 				break;
 			case 1:
-				regd = &hwsim_world_regdom_custom_02;
+				param.regd = &hwsim_world_regdom_custom_02;
 				break;
 			case 2:
-				reg_alpha2 = hwsim_alpha2s[0];
+				param.reg_alpha2 = hwsim_alpha2s[0];
 				break;
 			case 3:
-				reg_alpha2 = hwsim_alpha2s[1];
+				param.reg_alpha2 = hwsim_alpha2s[1];
 				break;
 			case 4:
-				reg_strict = true;
-				reg_alpha2 = hwsim_alpha2s[2];
+				param.reg_strict = true;
+				param.reg_alpha2 = hwsim_alpha2s[2];
 				break;
 			}
 			break;
@@ -2673,10 +2793,10 @@ static int __init init_mac80211_hwsim(void)
 			break;
 		}
 
-		err = mac80211_hwsim_create_radio(channels, reg_alpha2,
-						  regd, reg_strict,
-						  support_p2p_device,
-						  channels > 1);
+		param.p2p_device = support_p2p_device;
+		param.use_chanctx = channels > 1;
+
+		err = mac80211_hwsim_new_radio(NULL, &param);
 		if (err < 0)
 			goto out_free_radios;
 	}
@@ -2702,10 +2822,6 @@ static int __init init_mac80211_hwsim(void)
 	}
 	rtnl_unlock();
 
-	err = hwsim_init_netlink();
-	if (err < 0)
-		goto out_free_mon;
-
 	return 0;
 
 out_free_mon:
-- 
1.8.3.1

