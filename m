Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbaJ0Kpe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 06:45:34 -0400
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] mac80211-hwsim: Provide multicast event for HWSIM_CMD_NEW_RADIO
Date: Mon, 27 Oct 2014 12:44:47 +0200
Message-Id: <1414406688-3827-3-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141027_114540_063766_7C3E5B4A)
In-Reply-To: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com>
References: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When adding new radio via HWSIM_CMD_NEW_RADIO then listeners on the
multicast group "config" are informed.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 141 +++++++++++++++++++++++++++++-----
 1 file changed, 123 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index babbdc1..74bc1db 100644
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
@@ -1943,10 +1951,101 @@ static const struct ieee80211_ops mac80211_hwsim_ops = {
 
 static struct ieee80211_ops mac80211_hwsim_mchan_ops;
 
-static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
-				       const struct ieee80211_regdomain *regd,
-				       bool reg_strict, bool p2p_device,
-				       bool use_chanctx)
+static void mcast_msg(struct sk_buff *mcast_skb, struct genl_info *info)
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
+static void mcast_new_radio(int id, struct genl_info *info,
+			    int channels, const char *reg_alpha2,
+			    const struct ieee80211_regdomain *regd,
+			    bool reg_strict, bool p2p_device,
+			    bool use_chanctx)
+{
+	struct sk_buff *mcast_skb;
+	void *data;
+	int ret;
+
+	mcast_skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!mcast_skb)
+		return;
+
+	data = genlmsg_put(mcast_skb, 0, 0, &hwsim_genl_family, 0,
+			   HWSIM_CMD_NEW_RADIO);
+	if (!data)
+		goto error;
+
+	ret = nla_put_u32(mcast_skb, HWSIM_ATTR_RADIO_ID, id);
+	if (ret < 0)
+		goto error;
+
+	if (channels) {
+		ret = nla_put_u32(mcast_skb, HWSIM_ATTR_CHANNELS, channels);
+		if (ret < 0)
+			goto error;
+	}
+
+	if (reg_alpha2) {
+		ret = nla_put(mcast_skb, HWSIM_ATTR_REG_HINT_ALPHA2, 2,
+			      reg_alpha2);
+		if (ret < 0)
+			goto error;
+	}
+
+	if (regd) {
+		int i;
+
+		for (i = 0; hwsim_world_regdom_custom[i] != regd &&
+		     i < ARRAY_SIZE(hwsim_world_regdom_custom); i++)
+			;
+
+		if (i < ARRAY_SIZE(hwsim_world_regdom_custom)) {
+			ret = nla_put_u32(mcast_skb, HWSIM_ATTR_REG_CUSTOM_REG,
+					  i);
+			if (ret < 0)
+				goto error;
+		}
+	}
+
+	if (reg_strict) {
+		ret = nla_put_flag(mcast_skb, HWSIM_ATTR_REG_STRICT_REG);
+		if (ret < 0)
+			goto error;
+	}
+
+	if (p2p_device) {
+		ret = nla_put_flag(mcast_skb, HWSIM_ATTR_SUPPORT_P2P_DEVICE);
+		if (ret < 0)
+			goto error;
+	}
+
+	if (use_chanctx) {
+		ret = nla_put_flag(mcast_skb, HWSIM_ATTR_USE_CHANCTX);
+		if (ret < 0)
+			goto error;
+	}
+
+	genlmsg_end(mcast_skb, data);
+
+	mcast_msg(mcast_skb, info);
+
+	return;
+
+error:
+	nlmsg_free(mcast_skb);
+}
+
+static int mac80211_hwsim_new_radio(struct genl_info *info,
+				    int channels, const char *reg_alpha2,
+				    const struct ieee80211_regdomain *regd,
+				    bool reg_strict, bool p2p_device,
+				    bool use_chanctx)
 {
 	int err;
 	u8 addr[ETH_ALEN];
@@ -2180,6 +2279,10 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 	list_add_tail(&data->list, &hwsim_radios);
 	spin_unlock_bh(&hwsim_radio_lock);
 
+	if (idx > 0)
+		mcast_new_radio(idx, info, channels, reg_alpha2,
+				regd, reg_strict, p2p_device, use_chanctx);
+
 	return idx;
 
 failed_hw:
@@ -2427,7 +2530,7 @@ static int hwsim_register_received_nl(struct sk_buff *skb_2,
 	return 0;
 }
 
-static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
+static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 {
 	unsigned int chans = channels;
 	const char *alpha2 = NULL;
@@ -2455,8 +2558,8 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		regd = hwsim_world_regdom_custom[idx];
 	}
 
-	return mac80211_hwsim_create_radio(chans, alpha2, regd, reg_strict,
-					   p2p_device, use_chanctx);
+	return mac80211_hwsim_new_radio(info, chans, alpha2, regd, reg_strict,
+					p2p_device, use_chanctx);
 }
 
 static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
@@ -2501,9 +2604,9 @@ static const struct genl_ops hwsim_ops[] = {
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
@@ -2542,7 +2645,9 @@ static int hwsim_init_netlink(void)
 
 	printk(KERN_INFO "mac80211_hwsim: initializing netlink\n");
 
-	rc = genl_register_family_with_ops(&hwsim_genl_family, hwsim_ops);
+	rc = genl_register_family_with_ops_groups(&hwsim_genl_family,
+						  hwsim_ops,
+						  hwsim_mcgrps);
 	if (rc)
 		goto failure;
 
@@ -2603,6 +2708,10 @@ static int __init init_mac80211_hwsim(void)
 		goto out_unregister_driver;
 	}
 
+	err = hwsim_init_netlink();
+	if (err < 0)
+		goto out_unregister_driver;
+
 	for (i = 0; i < radios; i++) {
 		const char *reg_alpha2 = NULL;
 		const struct ieee80211_regdomain *regd = NULL;
@@ -2673,10 +2782,10 @@ static int __init init_mac80211_hwsim(void)
 			break;
 		}
 
-		err = mac80211_hwsim_create_radio(channels, reg_alpha2,
-						  regd, reg_strict,
-						  support_p2p_device,
-						  channels > 1);
+		err = mac80211_hwsim_new_radio(NULL, channels, reg_alpha2,
+					       regd, reg_strict,
+					       support_p2p_device,
+					       channels > 1);
 		if (err < 0)
 			goto out_free_radios;
 	}
@@ -2702,10 +2811,6 @@ static int __init init_mac80211_hwsim(void)
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

