Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD35ECDFAC
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 17:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41CBE2064E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 17:44:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41CBE2064E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbeJJBCw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 21:02:52 -0400
Received: from mga07.intel.com ([134.134.136.100]:52517 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbeJJBCw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 21:02:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2018 10:44:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,361,1534834800"; 
   d="scan'208";a="77459756"
Received: from jprestwo.jf.intel.com ([10.54.74.38])
  by fmsmga008.fm.intel.com with ESMTP; 09 Oct 2018 10:44:46 -0700
From:   James Prestwood <james.prestwood@linux.intel.com>
To:     linux-wireless@vger.kernel.org
Cc:     James Prestwood <james.prestwood@linux.intel.com>
Subject: [PATCH] mac80211_hwsim: allow setting custom features/iftypes
Date:   Tue,  9 Oct 2018 10:48:29 -0700
Message-Id: <20181009174829.15163-1-james.prestwood@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The current driver hard codes various features, ext features and supported
interface types when a new radio is created. This patch adds several new
hwsim attributes so user space can specify specific features the radio should
have:

- HWSIM_ATTR_FEATURE_SUPPORT
	Bit field of nl80211_feature_flags flags
- HWSIM_ATTR_EXT_FEATURE_SUPPORT
	Variable length bit field where bits map to nl80211_ext_feature_index
	values.
- HWSIM_ATTR_IFTYPE_SUPPORT
	Nested attribute of flags containing all supported interface types.
	Each flag attribute sets support for an interface type.

Each attribute data format matches a corresponding NL80211 attribute:

HWSIM_ATTR_FEATURE_SUPPORT --> NL80211_ATTR_FEATURE_FLAGS
HWSIM_ATTR_EXT_FEATURE_SUPPORT --> NL80211_ATTR_EXT_FEATURES
HWSIM_ATTR_IFTYPE_SUPPORT --> NL80211_ATTR_SUPPORTED_IFTYPES
---
 drivers/net/wireless/mac80211_hwsim.c | 95 +++++++++++++++++++++++----
 drivers/net/wireless/mac80211_hwsim.h | 10 +++
 2 files changed, 91 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 18e819d964f1..727e61cf154c 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -641,8 +641,30 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 	[HWSIM_ATTR_NO_VIF] = { .type = NLA_FLAG },
 	[HWSIM_ATTR_FREQ] = { .type = NLA_U32 },
 	[HWSIM_ATTR_PERM_ADDR] = { .type = NLA_UNSPEC, .len = ETH_ALEN },
+	[HWSIM_ATTR_FEATURE_SUPPORT] = { .type = NLA_U32 },
+	[HWSIM_ATTR_EXT_FEATURE_SUPPORT] = { .type = NLA_BINARY },
+	[HWSIM_ATTR_IFTYPE_SUPPORT] = { .type = NLA_NESTED },
 };
 
+/* policy for iftype support flags */
+static const struct nla_policy
+hwsim_iftype_support_policy[NUM_NL80211_IFTYPES] = {
+	[NL80211_IFTYPE_UNSPECIFIED] = { .type = NLA_FLAG },
+	[NL80211_IFTYPE_ADHOC] = { .type = NLA_FLAG },
+	[NL80211_IFTYPE_STATION] = { .type = NLA_FLAG },
+	[NL80211_IFTYPE_AP] = { .type = NLA_FLAG },
+	[NL80211_IFTYPE_AP_VLAN] = { .type = NLA_FLAG },
+	[NL80211_IFTYPE_WDS] = { .type = NLA_FLAG },
+	[NL80211_IFTYPE_MONITOR] = { .type = NLA_FLAG },
+	[NL80211_IFTYPE_MESH_POINT] = { .type = NLA_FLAG },
+	[NL80211_IFTYPE_P2P_CLIENT] = { .type = NLA_FLAG },
+	[NL80211_IFTYPE_P2P_GO] = { .type = NLA_FLAG },
+	[NL80211_IFTYPE_P2P_DEVICE] = { .type = NLA_FLAG },
+	[NL80211_IFTYPE_OCB] = { .type = NLA_FLAG },
+	[NL80211_IFTYPE_NAN] = { .type = NLA_FLAG },
+};
+
+
 static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 				    struct sk_buff *skb,
 				    struct ieee80211_channel *chan);
@@ -2413,6 +2435,9 @@ struct hwsim_new_radio_params {
 	const char *hwname;
 	bool no_vif;
 	const u8 *perm_addr;
+	u32 features;
+	u8 ext_features[DIV_ROUND_UP(NUM_NL80211_EXT_FEATURES, 8)];
+	u32 iftypes;
 };
 
 static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
@@ -2631,12 +2656,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 
 	hw->queues = 5;
 	hw->offchannel_tx_hw_queue = 4;
-	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-				     BIT(NL80211_IFTYPE_AP) |
-				     BIT(NL80211_IFTYPE_P2P_CLIENT) |
-				     BIT(NL80211_IFTYPE_P2P_GO) |
-				     BIT(NL80211_IFTYPE_ADHOC) |
-				     BIT(NL80211_IFTYPE_MESH_POINT);
+
+	hw->wiphy->interface_modes = param->iftypes;
 
 	if (param->p2p_device)
 		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_P2P_DEVICE);
@@ -2658,12 +2679,10 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
 			    WIPHY_FLAG_AP_UAPSD |
 			    WIPHY_FLAG_HAS_CHANNEL_SWITCH;
-	hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR |
-			       NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE |
-			       NL80211_FEATURE_STATIC_SMPS |
-			       NL80211_FEATURE_DYNAMIC_SMPS |
-			       NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
-	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
+
+	hw->wiphy->features |= param->features;
+	memcpy(hw->wiphy->ext_features, param->ext_features,
+				DIV_ROUND_UP(NUM_NL80211_EXT_FEATURES, 8));
 
 	/* ask mac80211 to reserve space for magic */
 	hw->vif_data_size = sizeof(struct hwsim_vif_priv);
@@ -2767,8 +2786,6 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	if (param->no_vif)
 		ieee80211_hw_set(hw, NO_AUTO_VIF);
 
-	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
-
 	err = ieee80211_register_hw(hw);
 	if (err < 0) {
 		pr_debug("mac80211_hwsim: ieee80211_register_hw failed (%d)\n",
@@ -3244,6 +3261,56 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		param.perm_addr = nla_data(info->attrs[HWSIM_ATTR_PERM_ADDR]);
 	}
 
+	if (info->attrs[HWSIM_ATTR_FEATURE_SUPPORT])
+		param.features = nla_get_u32(
+				info->attrs[HWSIM_ATTR_FEATURE_SUPPORT]);
+	else
+		param.features = NL80211_FEATURE_ACTIVE_MONITOR |
+				NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE |
+				NL80211_FEATURE_STATIC_SMPS |
+				NL80211_FEATURE_DYNAMIC_SMPS |
+				NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
+
+	if (info->attrs[HWSIM_ATTR_EXT_FEATURE_SUPPORT]) {
+		if (nla_len(info->attrs[HWSIM_ATTR_EXT_FEATURE_SUPPORT]) !=
+				DIV_ROUND_UP(NUM_NL80211_EXT_FEATURES, 8))
+			return -EINVAL;
+
+		memcpy(param.ext_features,
+			nla_data(info->attrs[HWSIM_ATTR_EXT_FEATURE_SUPPORT]),
+			DIV_ROUND_UP(NUM_NL80211_EXT_FEATURES, 8));
+	} else {
+		param.ext_features[NL80211_EXT_FEATURE_VHT_IBSS / 8] |=
+				BIT(NL80211_EXT_FEATURE_VHT_IBSS % 8);
+		param.ext_features[NL80211_EXT_FEATURE_CQM_RSSI_LIST / 8] |=
+				BIT(NL80211_EXT_FEATURE_CQM_RSSI_LIST % 8);
+	}
+
+	if (info->attrs[HWSIM_ATTR_IFTYPE_SUPPORT]) {
+		int i;
+		struct nlattr *types[NUM_NL80211_IFTYPES];
+		int err = nla_parse_nested(types,
+					NUM_NL80211_IFTYPES - 1,
+					info->attrs[HWSIM_ATTR_IFTYPE_SUPPORT],
+					hwsim_iftype_support_policy,
+					info->extack);
+		if (err) {
+			kfree(hwname);
+			return err;
+		}
+
+		for (i = 0; i < NUM_NL80211_IFTYPES; i++) {
+			if (nla_get_flag(types[i]))
+				param.iftypes |= BIT(i);
+		}
+	} else
+		param.iftypes = BIT(NL80211_IFTYPE_STATION) |
+				BIT(NL80211_IFTYPE_AP) |
+				BIT(NL80211_IFTYPE_P2P_CLIENT) |
+				BIT(NL80211_IFTYPE_P2P_GO) |
+				BIT(NL80211_IFTYPE_ADHOC) |
+				BIT(NL80211_IFTYPE_MESH_POINT);
+
 	ret = mac80211_hwsim_new_radio(info, &param);
 	kfree(hwname);
 	return ret;
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 0fe3199f8c72..aea242eb4746 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -132,6 +132,13 @@ enum {
  * @HWSIM_ATTR_TX_INFO_FLAGS: additional flags for corresponding
  *	rates of %HWSIM_ATTR_TX_INFO
  * @HWSIM_ATTR_PERM_ADDR: permanent mac address of new radio
+ * @HWSIM_ATTR_FEATURE_SUPPORT: bit mask of supported features (u32 attribute)
+ * 	Matches data format of %NL80211_ATTR_FEATURE_FLAGS
+ * @HWSIM_ATTR_EXT_FEATURE_SUPPORT: variable length bit field. Matches data
+ * 	format of %NL80211_ATTR_EXT_FEATURES
+ * @HWSIM_ATTR_IFTYPE_SUPPORT: nested attribute containing flag attributes.
+ * 	Each flag either sets the support for each iftype. Matches format of
+ * 	%NL80211_ATTR_SUPPORTED_IFTYPES
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -160,6 +167,9 @@ enum {
 	HWSIM_ATTR_PAD,
 	HWSIM_ATTR_TX_INFO_FLAGS,
 	HWSIM_ATTR_PERM_ADDR,
+	HWSIM_ATTR_FEATURE_SUPPORT,
+	HWSIM_ATTR_EXT_FEATURE_SUPPORT,
+	HWSIM_ATTR_IFTYPE_SUPPORT,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
2.17.1

