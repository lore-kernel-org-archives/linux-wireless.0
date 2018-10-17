Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473A6ECDE3B
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 19:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E3E1213A2
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 19:29:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E3E1213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbeJRD0l (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 23:26:41 -0400
Received: from mga17.intel.com ([192.55.52.151]:10315 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728135AbeJRD0l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 23:26:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2018 12:29:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,393,1534834800"; 
   d="scan'208";a="266547714"
Received: from jprestwo.jf.intel.com ([10.54.74.38])
  by orsmga005.jf.intel.com with ESMTP; 17 Oct 2018 12:29:29 -0700
From:   James Prestwood <james.prestwood@linux.intel.com>
To:     linux-wireless@vger.kernel.org
Cc:     James Prestwood <james.prestwood@linux.intel.com>
Subject: [PATCH v2 1/2] mac80211_hwsim: allow setting iftype support
Date:   Wed, 17 Oct 2018 12:33:06 -0700
Message-Id: <20181017193307.1780-2-james.prestwood@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181017193307.1780-1-james.prestwood@linux.intel.com>
References: <20181017193307.1780-1-james.prestwood@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The mac80211_hwsim driver hard codes its supported interface types. For
testing purposes it would be valuable to allow changing these supported
types in order to simulate actual drivers than support a limited set of
iftypes. A new attribute was added to allow this:

- HWSIM_ATTR_IFTYPE_SUPPORT
	A u32 bit field of supported NL80211_IFTYPE_* bits

This will only enable/disable iftypes that mac80211_hwsim already
supports.

In order to accomplish this, the ieee80211_iface_limit structure needed
to be built dynamically to only include limit rules for iftypes that
the user requested to enable.

Signed-off-by: James Prestwood <james.prestwood@linux.intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 154 +++++++++++++++-----------
 drivers/net/wireless/mac80211_hwsim.h |   2 +
 2 files changed, 90 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 18e819d964f1..2e4dac2de187 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -448,48 +448,6 @@ static const struct nl80211_vendor_cmd_info mac80211_hwsim_vendor_events[] = {
 	{ .vendor_id = OUI_QCA, .subcmd = 1 },
 };
 
-static const struct ieee80211_iface_limit hwsim_if_limits[] = {
-	{ .max = 1, .types = BIT(NL80211_IFTYPE_ADHOC) },
-	{ .max = 2048,  .types = BIT(NL80211_IFTYPE_STATION) |
-				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
-#ifdef CONFIG_MAC80211_MESH
-				 BIT(NL80211_IFTYPE_MESH_POINT) |
-#endif
-				 BIT(NL80211_IFTYPE_AP) |
-				 BIT(NL80211_IFTYPE_P2P_GO) },
-	/* must be last, see hwsim_if_comb */
-	{ .max = 1, .types = BIT(NL80211_IFTYPE_P2P_DEVICE) }
-};
-
-static const struct ieee80211_iface_combination hwsim_if_comb[] = {
-	{
-		.limits = hwsim_if_limits,
-		/* remove the last entry which is P2P_DEVICE */
-		.n_limits = ARRAY_SIZE(hwsim_if_limits) - 1,
-		.max_interfaces = 2048,
-		.num_different_channels = 1,
-		.radar_detect_widths = BIT(NL80211_CHAN_WIDTH_20_NOHT) |
-				       BIT(NL80211_CHAN_WIDTH_20) |
-				       BIT(NL80211_CHAN_WIDTH_40) |
-				       BIT(NL80211_CHAN_WIDTH_80) |
-				       BIT(NL80211_CHAN_WIDTH_160),
-	},
-};
-
-static const struct ieee80211_iface_combination hwsim_if_comb_p2p_dev[] = {
-	{
-		.limits = hwsim_if_limits,
-		.n_limits = ARRAY_SIZE(hwsim_if_limits),
-		.max_interfaces = 2048,
-		.num_different_channels = 1,
-		.radar_detect_widths = BIT(NL80211_CHAN_WIDTH_20_NOHT) |
-				       BIT(NL80211_CHAN_WIDTH_20) |
-				       BIT(NL80211_CHAN_WIDTH_40) |
-				       BIT(NL80211_CHAN_WIDTH_80) |
-				       BIT(NL80211_CHAN_WIDTH_160),
-	},
-};
-
 static spinlock_t hwsim_radio_lock;
 static LIST_HEAD(hwsim_radios);
 static struct workqueue_struct *hwsim_wq;
@@ -513,6 +471,8 @@ struct mac80211_hwsim_data {
 	struct ieee80211_channel channels_5ghz[ARRAY_SIZE(hwsim_channels_5ghz)];
 	struct ieee80211_rate rates[ARRAY_SIZE(hwsim_rates)];
 	struct ieee80211_iface_combination if_combination;
+	struct ieee80211_iface_limit if_limits[3];
+	int n_if_limits;
 
 	struct mac_address addresses[2];
 	int channels, idx;
@@ -641,6 +601,7 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 	[HWSIM_ATTR_NO_VIF] = { .type = NLA_FLAG },
 	[HWSIM_ATTR_FREQ] = { .type = NLA_U32 },
 	[HWSIM_ATTR_PERM_ADDR] = { .type = NLA_UNSPEC, .len = ETH_ALEN },
+	[HWSIM_ATTR_IFTYPE_SUPPORT] = { .type = NLA_U32 },
 };
 
 static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
@@ -2413,6 +2374,7 @@ struct hwsim_new_radio_params {
 	const char *hwname;
 	bool no_vif;
 	const u8 *perm_addr;
+	u32 iftypes;
 };
 
 static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
@@ -2517,6 +2479,29 @@ static void hwsim_mcast_new_radio(int id, struct genl_info *info,
 	nlmsg_free(mcast_skb);
 }
 
+#ifdef CONFIG_MAC80211_MESH
+#define HWSIM_MESH_BIT BIT(NL80211_IFTYPE_MESH_POINT)
+#else
+#define HWSIM_MESH_BIT 0
+#endif
+
+#define HWSIM_DEFAULT_IF_LIMIT \
+	( \
+		BIT(NL80211_IFTYPE_STATION) | \
+		BIT(NL80211_IFTYPE_P2P_CLIENT) | \
+		BIT(NL80211_IFTYPE_AP) | \
+		BIT(NL80211_IFTYPE_P2P_GO) | \
+		HWSIM_MESH_BIT \
+	)
+
+#define HWSIM_IFTYPE_SUPPORT_MASK \
+	BIT(NL80211_IFTYPE_STATION) | \
+	BIT(NL80211_IFTYPE_AP) | \
+	BIT(NL80211_IFTYPE_P2P_CLIENT) | \
+	BIT(NL80211_IFTYPE_P2P_GO) | \
+	BIT(NL80211_IFTYPE_ADHOC) | \
+	BIT(NL80211_IFTYPE_MESH_POINT)
+
 static int mac80211_hwsim_new_radio(struct genl_info *info,
 				    struct hwsim_new_radio_params *param)
 {
@@ -2528,6 +2513,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	const struct ieee80211_ops *ops = &mac80211_hwsim_ops;
 	struct net *net;
 	int idx;
+	int n_limits = 0;
 
 	if (WARN_ON(param->channels > 1 && !param->use_chanctx))
 		return -EINVAL;
@@ -2603,43 +2589,60 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	if (info)
 		data->portid = info->snd_portid;
 
+	/* setup interface limits, only on interface types we support */
+	if (param->iftypes & BIT(NL80211_IFTYPE_ADHOC)) {
+		data->if_limits[n_limits].max = 1;
+		data->if_limits[n_limits].types = BIT(NL80211_IFTYPE_ADHOC);
+		n_limits++;
+	}
+
+	if (param->iftypes & HWSIM_DEFAULT_IF_LIMIT) {
+		data->if_limits[n_limits].max = 2048;
+		/*
+		 * For this case, we may only support a subset of
+		 * HWSIM_DEFAULT_IF_LIMIT, therefore we only want to add the
+		 * bits that both param->iftype & HWSIM_DEFAULT_IF_LIMIT have.
+		 */
+		data->if_limits[n_limits].types =
+					HWSIM_DEFAULT_IF_LIMIT & param->iftypes;
+		n_limits++;
+	}
+
+	if (param->iftypes & BIT(NL80211_IFTYPE_P2P_DEVICE)) {
+		data->if_limits[n_limits].max = 1;
+		data->if_limits[n_limits].types =
+						BIT(NL80211_IFTYPE_P2P_DEVICE);
+		n_limits++;
+	}
+
 	if (data->use_chanctx) {
 		hw->wiphy->max_scan_ssids = 255;
 		hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
 		hw->wiphy->max_remain_on_channel_duration = 1000;
-		hw->wiphy->iface_combinations = &data->if_combination;
-		if (param->p2p_device)
-			data->if_combination = hwsim_if_comb_p2p_dev[0];
-		else
-			data->if_combination = hwsim_if_comb[0];
-		hw->wiphy->n_iface_combinations = 1;
-		/* For channels > 1 DFS is not allowed */
 		data->if_combination.radar_detect_widths = 0;
 		data->if_combination.num_different_channels = data->channels;
-	} else if (param->p2p_device) {
-		hw->wiphy->iface_combinations = hwsim_if_comb_p2p_dev;
-		hw->wiphy->n_iface_combinations =
-			ARRAY_SIZE(hwsim_if_comb_p2p_dev);
-	} else {
-		hw->wiphy->iface_combinations = hwsim_if_comb;
-		hw->wiphy->n_iface_combinations = ARRAY_SIZE(hwsim_if_comb);
 	}
 
+	data->if_combination.n_limits = n_limits;
+	data->if_combination.max_interfaces = 2048;
+	data->if_combination.num_different_channels = 1;
+	data->if_combination.radar_detect_widths =
+					BIT(NL80211_CHAN_WIDTH_20_NOHT) |
+					BIT(NL80211_CHAN_WIDTH_20) |
+					BIT(NL80211_CHAN_WIDTH_40) |
+					BIT(NL80211_CHAN_WIDTH_80) |
+					BIT(NL80211_CHAN_WIDTH_160);
+	data->if_combination.limits = data->if_limits;
+
+	hw->wiphy->iface_combinations = &data->if_combination;
+	hw->wiphy->n_iface_combinations = 1;
+
 	INIT_DELAYED_WORK(&data->roc_start, hw_roc_start);
 	INIT_DELAYED_WORK(&data->roc_done, hw_roc_done);
 	INIT_DELAYED_WORK(&data->hw_scan, hw_scan_work);
 
 	hw->queues = 5;
 	hw->offchannel_tx_hw_queue = 4;
-	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-				     BIT(NL80211_IFTYPE_AP) |
-				     BIT(NL80211_IFTYPE_P2P_CLIENT) |
-				     BIT(NL80211_IFTYPE_P2P_GO) |
-				     BIT(NL80211_IFTYPE_ADHOC) |
-				     BIT(NL80211_IFTYPE_MESH_POINT);
-
-	if (param->p2p_device)
-		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_P2P_DEVICE);
 
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
 	ieee80211_hw_set(hw, CHANCTX_STA_CSA);
@@ -2665,6 +2668,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			       NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
 	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
 
+	hw->wiphy->interface_modes = param->iftypes;
+
 	/* ask mac80211 to reserve space for magic */
 	hw->vif_data_size = sizeof(struct hwsim_vif_priv);
 	hw->sta_data_size = sizeof(struct hwsim_sta_priv);
@@ -3240,10 +3245,27 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 			return -EINVAL;
 		}
 
-
 		param.perm_addr = nla_data(info->attrs[HWSIM_ATTR_PERM_ADDR]);
 	}
 
+	if (info->attrs[HWSIM_ATTR_IFTYPE_SUPPORT]) {
+		param.iftypes = nla_get_u32(
+					info->attrs[HWSIM_ATTR_IFTYPE_SUPPORT]);
+		if (param.iftypes & ~(HWSIM_IFTYPE_SUPPORT_MASK)) {
+			NL_SET_BAD_ATTR(info->extack,
+					info->attrs[HWSIM_ATTR_IFTYPE_SUPPORT]);
+			return -EINVAL;
+		}
+	} else
+		param.iftypes = HWSIM_IFTYPE_SUPPORT_MASK;
+
+	/* ensure both flag and iftype support is honored */
+	if (param.p2p_device ||
+			param.iftypes & BIT(NL80211_IFTYPE_P2P_DEVICE)) {
+		param.iftypes |= BIT(NL80211_IFTYPE_P2P_DEVICE);
+		param.p2p_device = true;
+	}
+
 	ret = mac80211_hwsim_new_radio(info, &param);
 	kfree(hwname);
 	return ret;
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 0fe3199f8c72..3f6b670116d0 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -132,6 +132,7 @@ enum {
  * @HWSIM_ATTR_TX_INFO_FLAGS: additional flags for corresponding
  *	rates of %HWSIM_ATTR_TX_INFO
  * @HWSIM_ATTR_PERM_ADDR: permanent mac address of new radio
+ * @HWSIM_ATTR_IFTYPE_SUPPORT: u32 attribute of supported interface types bits
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -160,6 +161,7 @@ enum {
 	HWSIM_ATTR_PAD,
 	HWSIM_ATTR_TX_INFO_FLAGS,
 	HWSIM_ATTR_PERM_ADDR,
+	HWSIM_ATTR_IFTYPE_SUPPORT,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
2.17.1

