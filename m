Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E51F5C43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 08:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A3E6205C9
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 08:00:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A3E6205C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbeJBOmY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 10:42:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:42182 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbeJBOmY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 10:42:24 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g7FbT-0002Kl-By; Tue, 02 Oct 2018 10:00:23 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] nl80211: use policy range validation where applicable
Date:   Tue,  2 Oct 2018 10:00:07 +0200
Message-Id: <20181002080008.26434-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Many range checks can be done in the policy, move them
there. A few in mesh are added in the code (taken out of
the macros) because they don't fit into the s16 range in
the policy validation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 469 +++++++++++++++++++------------------------------
 1 file changed, 180 insertions(+), 289 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b0a5ce8dbb5c..d894f78e6b0a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -222,14 +222,14 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_CENTER_FREQ1] = { .type = NLA_U32 },
 	[NL80211_ATTR_CENTER_FREQ2] = { .type = NLA_U32 },
 
-	[NL80211_ATTR_WIPHY_RETRY_SHORT] = { .type = NLA_U8 },
-	[NL80211_ATTR_WIPHY_RETRY_LONG] = { .type = NLA_U8 },
+	[NL80211_ATTR_WIPHY_RETRY_SHORT] = NLA_POLICY_MIN(NLA_U8, 1),
+	[NL80211_ATTR_WIPHY_RETRY_LONG] = NLA_POLICY_MIN(NLA_U8, 1),
 	[NL80211_ATTR_WIPHY_FRAG_THRESHOLD] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_RTS_THRESHOLD] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_COVERAGE_CLASS] = { .type = NLA_U8 },
 	[NL80211_ATTR_WIPHY_DYN_ACK] = { .type = NLA_FLAG },
 
-	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
+	[NL80211_ATTR_IFTYPE] = NLA_POLICY_MAX(NLA_U32, NL80211_IFTYPE_MAX),
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFNAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ-1 },
 
@@ -239,11 +239,12 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_KEY] = { .type = NLA_NESTED, },
 	[NL80211_ATTR_KEY_DATA] = { .type = NLA_BINARY,
 				    .len = WLAN_MAX_KEY_LEN },
-	[NL80211_ATTR_KEY_IDX] = { .type = NLA_U8 },
+	[NL80211_ATTR_KEY_IDX] = NLA_POLICY_MAX(NLA_U8, 5),
 	[NL80211_ATTR_KEY_CIPHER] = { .type = NLA_U32 },
 	[NL80211_ATTR_KEY_DEFAULT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_KEY_SEQ] = { .type = NLA_BINARY, .len = 16 },
-	[NL80211_ATTR_KEY_TYPE] = { .type = NLA_U32 },
+	[NL80211_ATTR_KEY_TYPE] =
+		NLA_POLICY_MAX(NLA_U32, NUM_NL80211_KEYTYPES),
 
 	[NL80211_ATTR_BEACON_INTERVAL] = { .type = NLA_U32 },
 	[NL80211_ATTR_DTIM_PERIOD] = { .type = NLA_U32 },
@@ -251,12 +252,14 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 				       .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_BEACON_TAIL] = { .type = NLA_BINARY,
 				       .len = IEEE80211_MAX_DATA_LEN },
-	[NL80211_ATTR_STA_AID] = { .type = NLA_U16 },
+	[NL80211_ATTR_STA_AID] =
+		NLA_POLICY_RANGE(NLA_U16, 1, IEEE80211_MAX_AID),
 	[NL80211_ATTR_STA_FLAGS] = { .type = NLA_NESTED },
 	[NL80211_ATTR_STA_LISTEN_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_ATTR_STA_SUPPORTED_RATES] = { .type = NLA_BINARY,
 					       .len = NL80211_MAX_SUPP_RATES },
-	[NL80211_ATTR_STA_PLINK_ACTION] = { .type = NLA_U8 },
+	[NL80211_ATTR_STA_PLINK_ACTION] =
+		NLA_POLICY_MAX(NLA_U8, NUM_NL80211_PLINK_ACTIONS - 1),
 	[NL80211_ATTR_STA_VLAN] = { .type = NLA_U32 },
 	[NL80211_ATTR_MNTR_FLAGS] = { /* NLA_NESTED can't be empty */ },
 	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
@@ -290,7 +293,9 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_REASON_CODE] = { .type = NLA_U16 },
 	[NL80211_ATTR_FREQ_FIXED] = { .type = NLA_FLAG },
 	[NL80211_ATTR_TIMED_OUT] = { .type = NLA_FLAG },
-	[NL80211_ATTR_USE_MFP] = { .type = NLA_U32 },
+	[NL80211_ATTR_USE_MFP] = NLA_POLICY_RANGE(NLA_U32,
+						  NL80211_MFP_NO,
+						  NL80211_MFP_OPTIONAL),
 	[NL80211_ATTR_STA_FLAGS2] = {
 		.len = sizeof(struct nl80211_sta_flag_update),
 	},
@@ -310,7 +315,9 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_FRAME] = { .type = NLA_BINARY,
 				 .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_FRAME_MATCH] = { .type = NLA_BINARY, },
-	[NL80211_ATTR_PS_STATE] = { .type = NLA_U32 },
+	[NL80211_ATTR_PS_STATE] = NLA_POLICY_RANGE(NLA_U32,
+						   NL80211_PS_DISABLED,
+						   NL80211_PS_ENABLED),
 	[NL80211_ATTR_CQM] = { .type = NLA_NESTED, },
 	[NL80211_ATTR_LOCAL_STATE_CHANGE] = { .type = NLA_FLAG },
 	[NL80211_ATTR_AP_ISOLATE] = { .type = NLA_U8 },
@@ -323,11 +330,17 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_OFFCHANNEL_TX_OK] = { .type = NLA_FLAG },
 	[NL80211_ATTR_KEY_DEFAULT_TYPES] = { .type = NLA_NESTED },
 	[NL80211_ATTR_WOWLAN_TRIGGERS] = { .type = NLA_NESTED },
-	[NL80211_ATTR_STA_PLINK_STATE] = { .type = NLA_U8 },
+	[NL80211_ATTR_STA_PLINK_STATE] =
+		NLA_POLICY_MAX(NLA_U8, NUM_NL80211_PLINK_STATES - 1),
+	[NL80211_ATTR_MESH_PEER_AID] =
+		NLA_POLICY_RANGE(NLA_U16, 1, IEEE80211_MAX_AID),
 	[NL80211_ATTR_SCHED_SCAN_INTERVAL] = { .type = NLA_U32 },
 	[NL80211_ATTR_REKEY_DATA] = { .type = NLA_NESTED },
 	[NL80211_ATTR_SCAN_SUPP_RATES] = { .type = NLA_NESTED },
-	[NL80211_ATTR_HIDDEN_SSID] = { .type = NLA_U32 },
+	[NL80211_ATTR_HIDDEN_SSID] =
+		NLA_POLICY_RANGE(NLA_U32,
+				 NL80211_HIDDEN_SSID_NOT_IN_USE,
+				 NL80211_HIDDEN_SSID_ZERO_CONTENTS),
 	[NL80211_ATTR_IE_PROBE_RESP] = { .type = NLA_BINARY,
 					 .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_IE_ASSOC_RESP] = { .type = NLA_BINARY,
@@ -357,9 +370,12 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_AUTH_DATA] = { .type = NLA_BINARY, },
 	[NL80211_ATTR_VHT_CAPABILITY] = { .len = NL80211_VHT_CAPABILITY_LEN },
 	[NL80211_ATTR_SCAN_FLAGS] = { .type = NLA_U32 },
-	[NL80211_ATTR_P2P_CTWINDOW] = { .type = NLA_U8 },
-	[NL80211_ATTR_P2P_OPPPS] = { .type = NLA_U8 },
-	[NL80211_ATTR_LOCAL_MESH_POWER_MODE] = {. type = NLA_U32 },
+	[NL80211_ATTR_P2P_CTWINDOW] = NLA_POLICY_MAX(NLA_U8, 127),
+	[NL80211_ATTR_P2P_OPPPS] = NLA_POLICY_MAX(NLA_U8, 1),
+	[NL80211_ATTR_LOCAL_MESH_POWER_MODE] =
+		NLA_POLICY_RANGE(NLA_U32,
+				 NL80211_MESH_POWER_UNKNOWN + 1,
+				 NL80211_MESH_POWER_MAX),
 	[NL80211_ATTR_ACL_POLICY] = {. type = NLA_U32 },
 	[NL80211_ATTR_MAC_ADDRS] = { .type = NLA_NESTED },
 	[NL80211_ATTR_STA_CAPABILITY] = { .type = NLA_U16 },
@@ -372,7 +388,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_MDID] = { .type = NLA_U16 },
 	[NL80211_ATTR_IE_RIC] = { .type = NLA_BINARY,
 				  .len = IEEE80211_MAX_DATA_LEN },
-	[NL80211_ATTR_PEER_AID] = { .type = NLA_U16 },
+	[NL80211_ATTR_PEER_AID] =
+		NLA_POLICY_RANGE(NLA_U16, 1, IEEE80211_MAX_AID),
 	[NL80211_ATTR_CH_SWITCH_COUNT] = { .type = NLA_U32 },
 	[NL80211_ATTR_CH_SWITCH_BLOCK_TX] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CSA_IES] = { .type = NLA_NESTED },
@@ -393,8 +410,9 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_SOCKET_OWNER] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CSA_C_OFFSETS_TX] = { .type = NLA_BINARY },
 	[NL80211_ATTR_USE_RRM] = { .type = NLA_FLAG },
-	[NL80211_ATTR_TSID] = { .type = NLA_U8 },
-	[NL80211_ATTR_USER_PRIO] = { .type = NLA_U8 },
+	[NL80211_ATTR_TSID] = NLA_POLICY_MAX(NLA_U8, IEEE80211_NUM_TIDS - 1),
+	[NL80211_ATTR_USER_PRIO] =
+		NLA_POLICY_MAX(NLA_U8, IEEE80211_NUM_UPS - 1),
 	[NL80211_ATTR_ADMITTED_TIME] = { .type = NLA_U16 },
 	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
 	[NL80211_ATTR_MAC_MASK] = { .len = ETH_ALEN },
@@ -404,12 +422,13 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_REG_INDOOR] = { .type = NLA_FLAG },
 	[NL80211_ATTR_PBSS] = { .type = NLA_FLAG },
 	[NL80211_ATTR_BSS_SELECT] = { .type = NLA_NESTED },
-	[NL80211_ATTR_STA_SUPPORT_P2P_PS] = { .type = NLA_U8 },
+	[NL80211_ATTR_STA_SUPPORT_P2P_PS] =
+		NLA_POLICY_MAX(NLA_U8, NUM_NL80211_P2P_PS_STATUS - 1),
 	[NL80211_ATTR_MU_MIMO_GROUP_DATA] = {
 		.len = VHT_MUMIMO_GROUPS_DATA_LEN
 	},
 	[NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR] = { .len = ETH_ALEN },
-	[NL80211_ATTR_NAN_MASTER_PREF] = { .type = NLA_U8 },
+	[NL80211_ATTR_NAN_MASTER_PREF] = NLA_POLICY_MIN(NLA_U8, 1),
 	[NL80211_ATTR_BANDS] = { .type = NLA_U32 },
 	[NL80211_ATTR_NAN_FUNC] = { .type = NLA_NESTED },
 	[NL80211_ATTR_FILS_KEK] = { .type = NLA_BINARY,
@@ -454,7 +473,7 @@ static const struct nla_policy nl80211_key_policy[NL80211_KEY_MAX + 1] = {
 	[NL80211_KEY_SEQ] = { .type = NLA_BINARY, .len = 16 },
 	[NL80211_KEY_DEFAULT] = { .type = NLA_FLAG },
 	[NL80211_KEY_DEFAULT_MGMT] = { .type = NLA_FLAG },
-	[NL80211_KEY_TYPE] = { .type = NLA_U32 },
+	[NL80211_KEY_TYPE] = NLA_POLICY_MAX(NLA_U32, NUM_NL80211_KEYTYPES - 1),
 	[NL80211_KEY_DEFAULT_TYPES] = { .type = NLA_NESTED },
 };
 
@@ -505,7 +524,10 @@ nl80211_wowlan_tcp_policy[NUM_NL80211_WOWLAN_TCP] = {
 static const struct nla_policy
 nl80211_coalesce_policy[NUM_NL80211_ATTR_COALESCE_RULE] = {
 	[NL80211_ATTR_COALESCE_RULE_DELAY] = { .type = NLA_U32 },
-	[NL80211_ATTR_COALESCE_RULE_CONDITION] = { .type = NLA_U32 },
+	[NL80211_ATTR_COALESCE_RULE_CONDITION] =
+		NLA_POLICY_RANGE(NLA_U32,
+				 NL80211_COALESCE_CONDITION_MATCH,
+				 NL80211_COALESCE_CONDITION_NO_MATCH),
 	[NL80211_ATTR_COALESCE_RULE_PKT_PATTERN] = { .type = NLA_NESTED },
 };
 
@@ -871,12 +893,8 @@ static int nl80211_parse_key_new(struct genl_info *info, struct nlattr *key,
 	if (tb[NL80211_KEY_CIPHER])
 		k->p.cipher = nla_get_u32(tb[NL80211_KEY_CIPHER]);
 
-	if (tb[NL80211_KEY_TYPE]) {
+	if (tb[NL80211_KEY_TYPE])
 		k->type = nla_get_u32(tb[NL80211_KEY_TYPE]);
-		if (k->type < 0 || k->type >= NUM_NL80211_KEYTYPES)
-			return genl_err_attr(info, -EINVAL,
-					     tb[NL80211_KEY_TYPE]);
-	}
 
 	if (tb[NL80211_KEY_DEFAULT_TYPES]) {
 		struct nlattr *kdt[NUM_NL80211_KEY_DEFAULT_TYPES];
@@ -923,13 +941,8 @@ static int nl80211_parse_key_old(struct genl_info *info, struct key_parse *k)
 	if (k->defmgmt)
 		k->def_multi = true;
 
-	if (info->attrs[NL80211_ATTR_KEY_TYPE]) {
+	if (info->attrs[NL80211_ATTR_KEY_TYPE])
 		k->type = nla_get_u32(info->attrs[NL80211_ATTR_KEY_TYPE]);
-		if (k->type < 0 || k->type >= NUM_NL80211_KEYTYPES) {
-			GENL_SET_ERR_MSG(info, "key type out of range");
-			return -EINVAL;
-		}
-	}
 
 	if (info->attrs[NL80211_ATTR_KEY_DEFAULT_TYPES]) {
 		struct nlattr *kdt[NUM_NL80211_KEY_DEFAULT_TYPES];
@@ -2648,8 +2661,6 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_WIPHY_RETRY_SHORT]) {
 		retry_short = nla_get_u8(
 			info->attrs[NL80211_ATTR_WIPHY_RETRY_SHORT]);
-		if (retry_short == 0)
-			return -EINVAL;
 
 		changed |= WIPHY_PARAM_RETRY_SHORT;
 	}
@@ -2657,8 +2668,6 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_WIPHY_RETRY_LONG]) {
 		retry_long = nla_get_u8(
 			info->attrs[NL80211_ATTR_WIPHY_RETRY_LONG]);
-		if (retry_long == 0)
-			return -EINVAL;
 
 		changed |= WIPHY_PARAM_RETRY_LONG;
 	}
@@ -3150,8 +3159,6 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 		ntype = nla_get_u32(info->attrs[NL80211_ATTR_IFTYPE]);
 		if (otype != ntype)
 			change = true;
-		if (ntype > NL80211_IFTYPE_MAX)
-			return -EINVAL;
 	}
 
 	if (info->attrs[NL80211_ATTR_MESH_ID]) {
@@ -3216,11 +3223,8 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[NL80211_ATTR_IFNAME])
 		return -EINVAL;
 
-	if (info->attrs[NL80211_ATTR_IFTYPE]) {
+	if (info->attrs[NL80211_ATTR_IFTYPE])
 		type = nla_get_u32(info->attrs[NL80211_ATTR_IFTYPE]);
-		if (type > NL80211_IFTYPE_MAX)
-			return -EINVAL;
-	}
 
 	if (!rdev->ops->add_virtual_intf ||
 	    !(rdev->wiphy.interface_modes & (1 << type)))
@@ -3400,9 +3404,6 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_KEY_IDX])
 		key_idx = nla_get_u8(info->attrs[NL80211_ATTR_KEY_IDX]);
 
-	if (key_idx > 5)
-		return -EINVAL;
-
 	if (info->attrs[NL80211_ATTR_MAC])
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
@@ -3410,8 +3411,6 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_KEY_TYPE]) {
 		u32 kt = nla_get_u32(info->attrs[NL80211_ATTR_KEY_TYPE]);
 
-		if (kt >= NUM_NL80211_KEYTYPES)
-			return -EINVAL;
 		if (kt != NL80211_KEYTYPE_GROUP &&
 		    kt != NL80211_KEYTYPE_PAIRWISE)
 			return -EINVAL;
@@ -4272,14 +4271,9 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
-	if (info->attrs[NL80211_ATTR_HIDDEN_SSID]) {
+	if (info->attrs[NL80211_ATTR_HIDDEN_SSID])
 		params.hidden_ssid = nla_get_u32(
 			info->attrs[NL80211_ATTR_HIDDEN_SSID]);
-		if (params.hidden_ssid != NL80211_HIDDEN_SSID_NOT_IN_USE &&
-		    params.hidden_ssid != NL80211_HIDDEN_SSID_ZERO_LEN &&
-		    params.hidden_ssid != NL80211_HIDDEN_SSID_ZERO_CONTENTS)
-			return -EINVAL;
-	}
 
 	params.privacy = !!info->attrs[NL80211_ATTR_PRIVACY];
 
@@ -4309,8 +4303,6 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 		params.p2p_ctwindow =
 			nla_get_u8(info->attrs[NL80211_ATTR_P2P_CTWINDOW]);
-		if (params.p2p_ctwindow > 127)
-			return -EINVAL;
 		if (params.p2p_ctwindow != 0 &&
 		    !(rdev->wiphy.features & NL80211_FEATURE_P2P_GO_CTWIN))
 			return -EINVAL;
@@ -4322,8 +4314,6 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
 			return -EINVAL;
 		tmp = nla_get_u8(info->attrs[NL80211_ATTR_P2P_OPPPS]);
-		if (tmp > 1)
-			return -EINVAL;
 		params.p2p_opp_ps = tmp;
 		if (params.p2p_opp_ps != 0 &&
 		    !(rdev->wiphy.features & NL80211_FEATURE_P2P_GO_OPPPS))
@@ -5260,17 +5250,11 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 	else
 		params.listen_interval = -1;
 
-	if (info->attrs[NL80211_ATTR_STA_SUPPORT_P2P_PS]) {
-		u8 tmp;
-
-		tmp = nla_get_u8(info->attrs[NL80211_ATTR_STA_SUPPORT_P2P_PS]);
-		if (tmp >= NUM_NL80211_P2P_PS_STATUS)
-			return -EINVAL;
-
-		params.support_p2p_ps = tmp;
-	} else {
+	if (info->attrs[NL80211_ATTR_STA_SUPPORT_P2P_PS])
+		params.support_p2p_ps =
+			nla_get_u8(info->attrs[NL80211_ATTR_STA_SUPPORT_P2P_PS]);
+	else
 		params.support_p2p_ps = -1;
-	}
 
 	if (!info->attrs[NL80211_ATTR_MAC])
 		return -EINVAL;
@@ -5300,38 +5284,23 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 	if (parse_station_flags(info, dev->ieee80211_ptr->iftype, &params))
 		return -EINVAL;
 
-	if (info->attrs[NL80211_ATTR_STA_PLINK_ACTION]) {
+	if (info->attrs[NL80211_ATTR_STA_PLINK_ACTION])
 		params.plink_action =
 			nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_ACTION]);
-		if (params.plink_action >= NUM_NL80211_PLINK_ACTIONS)
-			return -EINVAL;
-	}
 
 	if (info->attrs[NL80211_ATTR_STA_PLINK_STATE]) {
 		params.plink_state =
 			nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_STATE]);
-		if (params.plink_state >= NUM_NL80211_PLINK_STATES)
-			return -EINVAL;
-		if (info->attrs[NL80211_ATTR_MESH_PEER_AID]) {
+		if (info->attrs[NL80211_ATTR_MESH_PEER_AID])
 			params.peer_aid = nla_get_u16(
 				info->attrs[NL80211_ATTR_MESH_PEER_AID]);
-			if (params.peer_aid > IEEE80211_MAX_AID)
-				return -EINVAL;
-		}
 		params.sta_modify_mask |= STATION_PARAM_APPLY_PLINK_STATE;
 	}
 
-	if (info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE]) {
-		enum nl80211_mesh_power_mode pm = nla_get_u32(
+	if (info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE])
+		params.local_pm = nla_get_u32(
 			info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE]);
 
-		if (pm <= NL80211_MESH_POWER_UNKNOWN ||
-		    pm > NL80211_MESH_POWER_MAX)
-			return -EINVAL;
-
-		params.local_pm = pm;
-	}
-
 	if (info->attrs[NL80211_ATTR_OPMODE_NOTIF]) {
 		params.opmode_notif_used = true;
 		params.opmode_notif =
@@ -5408,13 +5377,8 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		nla_get_u16(info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL]);
 
 	if (info->attrs[NL80211_ATTR_STA_SUPPORT_P2P_PS]) {
-		u8 tmp;
-
-		tmp = nla_get_u8(info->attrs[NL80211_ATTR_STA_SUPPORT_P2P_PS]);
-		if (tmp >= NUM_NL80211_P2P_PS_STATUS)
-			return -EINVAL;
-
-		params.support_p2p_ps = tmp;
+		params.support_p2p_ps =
+			nla_get_u8(info->attrs[NL80211_ATTR_STA_SUPPORT_P2P_PS]);
 	} else {
 		/*
 		 * if not specified, assume it's supported for P2P GO interface,
@@ -5428,8 +5392,6 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		params.aid = nla_get_u16(info->attrs[NL80211_ATTR_PEER_AID]);
 	else
 		params.aid = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
-	if (!params.aid || params.aid > IEEE80211_MAX_AID)
-		return -EINVAL;
 
 	if (info->attrs[NL80211_ATTR_STA_CAPABILITY]) {
 		params.capability =
@@ -5469,12 +5431,9 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 			nla_get_u8(info->attrs[NL80211_ATTR_OPMODE_NOTIF]);
 	}
 
-	if (info->attrs[NL80211_ATTR_STA_PLINK_ACTION]) {
+	if (info->attrs[NL80211_ATTR_STA_PLINK_ACTION])
 		params.plink_action =
 			nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_ACTION]);
-		if (params.plink_action >= NUM_NL80211_PLINK_ACTIONS)
-			return -EINVAL;
-	}
 
 	err = nl80211_parse_sta_channel_info(info, &params);
 	if (err)
@@ -5984,9 +5943,7 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 		if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
 			return -EINVAL;
 		params.p2p_ctwindow =
-			nla_get_s8(info->attrs[NL80211_ATTR_P2P_CTWINDOW]);
-		if (params.p2p_ctwindow < 0)
-			return -EINVAL;
+			nla_get_u8(info->attrs[NL80211_ATTR_P2P_CTWINDOW]);
 		if (params.p2p_ctwindow != 0 &&
 		    !(rdev->wiphy.features & NL80211_FEATURE_P2P_GO_CTWIN))
 			return -EINVAL;
@@ -5998,8 +5955,6 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 		if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
 			return -EINVAL;
 		tmp = nla_get_u8(info->attrs[NL80211_ATTR_P2P_OPPPS]);
-		if (tmp > 1)
-			return -EINVAL;
 		params.p2p_opp_ps = tmp;
 		if (params.p2p_opp_ps &&
 		    !(rdev->wiphy.features & NL80211_FEATURE_P2P_GO_OPPPS))
@@ -6178,33 +6133,49 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 	return -ENOBUFS;
 }
 
-static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_ATTR_MAX+1] = {
-	[NL80211_MESHCONF_RETRY_TIMEOUT] = { .type = NLA_U16 },
-	[NL80211_MESHCONF_CONFIRM_TIMEOUT] = { .type = NLA_U16 },
-	[NL80211_MESHCONF_HOLDING_TIMEOUT] = { .type = NLA_U16 },
-	[NL80211_MESHCONF_MAX_PEER_LINKS] = { .type = NLA_U16 },
-	[NL80211_MESHCONF_MAX_RETRIES] = { .type = NLA_U8 },
-	[NL80211_MESHCONF_TTL] = { .type = NLA_U8 },
-	[NL80211_MESHCONF_ELEMENT_TTL] = { .type = NLA_U8 },
-	[NL80211_MESHCONF_AUTO_OPEN_PLINKS] = { .type = NLA_U8 },
-	[NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR] = { .type = NLA_U32 },
+static const struct nla_policy
+nl80211_meshconf_params_policy[NL80211_MESHCONF_ATTR_MAX+1] = {
+	[NL80211_MESHCONF_RETRY_TIMEOUT] =
+		NLA_POLICY_RANGE(NLA_U16, 1, 255),
+	[NL80211_MESHCONF_CONFIRM_TIMEOUT] =
+		NLA_POLICY_RANGE(NLA_U16, 1, 255),
+	[NL80211_MESHCONF_HOLDING_TIMEOUT] =
+		NLA_POLICY_RANGE(NLA_U16, 1, 255),
+	[NL80211_MESHCONF_MAX_PEER_LINKS] =
+		NLA_POLICY_RANGE(NLA_U16, 0, 255),
+	[NL80211_MESHCONF_MAX_RETRIES] = NLA_POLICY_MAX(NLA_U8, 16),
+	[NL80211_MESHCONF_TTL] = NLA_POLICY_MIN(NLA_U8, 1),
+	[NL80211_MESHCONF_ELEMENT_TTL] = NLA_POLICY_MIN(NLA_U8, 1),
+	[NL80211_MESHCONF_AUTO_OPEN_PLINKS] = NLA_POLICY_MAX(NLA_U8, 1),
+	[NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR] =
+		NLA_POLICY_RANGE(NLA_U32, 1, 255),
 	[NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_PATH_REFRESH_TIME] = { .type = NLA_U32 },
-	[NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT] = NLA_POLICY_MIN(NLA_U16, 1),
 	[NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT] = { .type = NLA_U32 },
-	[NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL] = { .type = NLA_U16 },
-	[NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL] = { .type = NLA_U16 },
-	[NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME] = { .type = NLA_U16 },
-	[NL80211_MESHCONF_HWMP_ROOTMODE] = { .type = NLA_U8 },
-	[NL80211_MESHCONF_HWMP_RANN_INTERVAL] = { .type = NLA_U16 },
-	[NL80211_MESHCONF_GATE_ANNOUNCEMENTS] = { .type = NLA_U8 },
-	[NL80211_MESHCONF_FORWARDING] = { .type = NLA_U8 },
-	[NL80211_MESHCONF_RSSI_THRESHOLD] = { .type = NLA_U32 },
+	[NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL] =
+		NLA_POLICY_MIN(NLA_U16, 1),
+	[NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL] =
+		NLA_POLICY_MIN(NLA_U16, 1),
+	[NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME] =
+		NLA_POLICY_MIN(NLA_U16, 1),
+	[NL80211_MESHCONF_HWMP_ROOTMODE] = NLA_POLICY_MAX(NLA_U8, 4),
+	[NL80211_MESHCONF_HWMP_RANN_INTERVAL] =
+		NLA_POLICY_MIN(NLA_U16, 1),
+	[NL80211_MESHCONF_GATE_ANNOUNCEMENTS] = NLA_POLICY_MAX(NLA_U8, 1),
+	[NL80211_MESHCONF_FORWARDING] = NLA_POLICY_MAX(NLA_U8, 1),
+	[NL80211_MESHCONF_RSSI_THRESHOLD] =
+		NLA_POLICY_RANGE(NLA_U32, -255, 0),
 	[NL80211_MESHCONF_HT_OPMODE] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT] = { .type = NLA_U32 },
-	[NL80211_MESHCONF_HWMP_ROOT_INTERVAL] = { .type = NLA_U16 },
-	[NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL] = { .type = NLA_U16 },
-	[NL80211_MESHCONF_POWER_MODE] = { .type = NLA_U32 },
+	[NL80211_MESHCONF_HWMP_ROOT_INTERVAL] =
+		NLA_POLICY_MIN(NLA_U16, 1),
+	[NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL] =
+		NLA_POLICY_MIN(NLA_U16, 1),
+	[NL80211_MESHCONF_POWER_MODE] =
+		NLA_POLICY_RANGE(NLA_U32,
+				 NL80211_MESH_POWER_ACTIVE,
+				 NL80211_MESH_POWER_MAX),
 	[NL80211_MESHCONF_AWAKE_WINDOW] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_PLINK_TIMEOUT] = { .type = NLA_U32 },
 };
@@ -6222,63 +6193,6 @@ static const struct nla_policy
 	[NL80211_MESH_SETUP_USERSPACE_AMPE] = { .type = NLA_FLAG },
 };
 
-static int nl80211_check_bool(const struct nlattr *nla, u8 min, u8 max, bool *out)
-{
-	u8 val = nla_get_u8(nla);
-	if (val < min || val > max)
-		return -EINVAL;
-	*out = val;
-	return 0;
-}
-
-static int nl80211_check_u8(const struct nlattr *nla, u8 min, u8 max, u8 *out)
-{
-	u8 val = nla_get_u8(nla);
-	if (val < min || val > max)
-		return -EINVAL;
-	*out = val;
-	return 0;
-}
-
-static int nl80211_check_u16(const struct nlattr *nla, u16 min, u16 max, u16 *out)
-{
-	u16 val = nla_get_u16(nla);
-	if (val < min || val > max)
-		return -EINVAL;
-	*out = val;
-	return 0;
-}
-
-static int nl80211_check_u32(const struct nlattr *nla, u32 min, u32 max, u32 *out)
-{
-	u32 val = nla_get_u32(nla);
-	if (val < min || val > max)
-		return -EINVAL;
-	*out = val;
-	return 0;
-}
-
-static int nl80211_check_s32(const struct nlattr *nla, s32 min, s32 max, s32 *out)
-{
-	s32 val = nla_get_s32(nla);
-	if (val < min || val > max)
-		return -EINVAL;
-	*out = val;
-	return 0;
-}
-
-static int nl80211_check_power_mode(const struct nlattr *nla,
-				    enum nl80211_mesh_power_mode min,
-				    enum nl80211_mesh_power_mode max,
-				    enum nl80211_mesh_power_mode *out)
-{
-	u32 val = nla_get_u32(nla);
-	if (val < min || val > max)
-		return -EINVAL;
-	*out = val;
-	return 0;
-}
-
 static int nl80211_parse_mesh_config(struct genl_info *info,
 				     struct mesh_config *cfg,
 				     u32 *mask_out)
@@ -6287,13 +6201,12 @@ static int nl80211_parse_mesh_config(struct genl_info *info,
 	u32 mask = 0;
 	u16 ht_opmode;
 
-#define FILL_IN_MESH_PARAM_IF_SET(tb, cfg, param, min, max, mask, attr, fn) \
-do {									    \
-	if (tb[attr]) {							    \
-		if (fn(tb[attr], min, max, &cfg->param))		    \
-			return -EINVAL;					    \
-		mask |= (1 << (attr - 1));				    \
-	}								    \
+#define FILL_IN_MESH_PARAM_IF_SET(tb, cfg, param, mask, attr, fn)	\
+do {									\
+	if (tb[attr]) {							\
+		cfg->param = fn(tb[attr]);				\
+		mask |= BIT((attr) - 1);				\
+	}								\
 } while (0)
 
 	if (!info->attrs[NL80211_ATTR_MESH_CONFIG])
@@ -6308,75 +6221,73 @@ do {									    \
 	BUILD_BUG_ON(NL80211_MESHCONF_ATTR_MAX > 32);
 
 	/* Fill in the params struct */
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshRetryTimeout, 1, 255,
-				  mask, NL80211_MESHCONF_RETRY_TIMEOUT,
-				  nl80211_check_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshConfirmTimeout, 1, 255,
-				  mask, NL80211_MESHCONF_CONFIRM_TIMEOUT,
-				  nl80211_check_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHoldingTimeout, 1, 255,
-				  mask, NL80211_MESHCONF_HOLDING_TIMEOUT,
-				  nl80211_check_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshMaxPeerLinks, 0, 255,
-				  mask, NL80211_MESHCONF_MAX_PEER_LINKS,
-				  nl80211_check_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshMaxRetries, 0, 16,
-				  mask, NL80211_MESHCONF_MAX_RETRIES,
-				  nl80211_check_u8);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshTTL, 1, 255,
-				  mask, NL80211_MESHCONF_TTL, nl80211_check_u8);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, element_ttl, 1, 255,
-				  mask, NL80211_MESHCONF_ELEMENT_TTL,
-				  nl80211_check_u8);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, auto_open_plinks, 0, 1,
-				  mask, NL80211_MESHCONF_AUTO_OPEN_PLINKS,
-				  nl80211_check_bool);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshRetryTimeout, mask,
+				  NL80211_MESHCONF_RETRY_TIMEOUT, nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshConfirmTimeout, mask,
+				  NL80211_MESHCONF_CONFIRM_TIMEOUT,
+				  nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHoldingTimeout, mask,
+				  NL80211_MESHCONF_HOLDING_TIMEOUT,
+				  nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshMaxPeerLinks, mask,
+				  NL80211_MESHCONF_MAX_PEER_LINKS,
+				  nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshMaxRetries, mask,
+				  NL80211_MESHCONF_MAX_RETRIES, nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshTTL, mask,
+				  NL80211_MESHCONF_TTL, nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, element_ttl, mask,
+				  NL80211_MESHCONF_ELEMENT_TTL, nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, auto_open_plinks, mask,
+				  NL80211_MESHCONF_AUTO_OPEN_PLINKS,
+				  nla_get_u8);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshNbrOffsetMaxNeighbor,
-				  1, 255, mask,
+				  mask,
 				  NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR,
-				  nl80211_check_u32);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPmaxPREQretries, 0, 255,
-				  mask, NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES,
-				  nl80211_check_u8);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, path_refresh_time, 1, 65535,
-				  mask, NL80211_MESHCONF_PATH_REFRESH_TIME,
-				  nl80211_check_u32);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, min_discovery_timeout, 1, 65535,
-				  mask, NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT,
-				  nl80211_check_u16);
+				  nla_get_u32);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPmaxPREQretries, mask,
+				  NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES,
+				  nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, path_refresh_time, mask,
+				  NL80211_MESHCONF_PATH_REFRESH_TIME,
+				  nla_get_u32);
+	if (mask & BIT(NL80211_MESHCONF_PATH_REFRESH_TIME) &&
+	    (cfg->path_refresh_time < 1 || cfg->path_refresh_time > 65535))
+		return -EINVAL;
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, min_discovery_timeout, mask,
+				  NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT,
+				  nla_get_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPactivePathTimeout,
-				  1, 65535, mask,
+				  mask,
 				  NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
-				  nl80211_check_u32);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPpreqMinInterval,
-				  1, 65535, mask,
+				  nla_get_u32);
+	if (mask & BIT(NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT) &&
+	    (cfg->dot11MeshHWMPactivePathTimeout < 1 ||
+	     cfg->dot11MeshHWMPactivePathTimeout > 65535))
+		return -EINVAL;
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPpreqMinInterval, mask,
 				  NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
-				  nl80211_check_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPperrMinInterval,
-				  1, 65535, mask,
+				  nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPperrMinInterval, mask,
 				  NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL,
-				  nl80211_check_u16);
+				  nla_get_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
-				  dot11MeshHWMPnetDiameterTraversalTime,
-				  1, 65535, mask,
+				  dot11MeshHWMPnetDiameterTraversalTime, mask,
 				  NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
-				  nl80211_check_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPRootMode, 0, 4,
-				  mask, NL80211_MESHCONF_HWMP_ROOTMODE,
-				  nl80211_check_u8);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPRannInterval, 1, 65535,
-				  mask, NL80211_MESHCONF_HWMP_RANN_INTERVAL,
-				  nl80211_check_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
-				  dot11MeshGateAnnouncementProtocol, 0, 1,
+				  nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPRootMode, mask,
+				  NL80211_MESHCONF_HWMP_ROOTMODE, nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPRannInterval, mask,
+				  NL80211_MESHCONF_HWMP_RANN_INTERVAL,
+				  nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshGateAnnouncementProtocol,
 				  mask, NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
-				  nl80211_check_bool);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshForwarding, 0, 1,
-				  mask, NL80211_MESHCONF_FORWARDING,
-				  nl80211_check_bool);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, rssi_threshold, -255, 0,
-				  mask, NL80211_MESHCONF_RSSI_THRESHOLD,
-				  nl80211_check_s32);
+				  nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshForwarding, mask,
+				  NL80211_MESHCONF_FORWARDING, nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, rssi_threshold, mask,
+				  NL80211_MESHCONF_RSSI_THRESHOLD,
+				  nla_get_s32);
 	/*
 	 * Check HT operation mode based on
 	 * IEEE 802.11-2016 9.4.2.57 HT Operation element.
@@ -6395,29 +6306,27 @@ do {									    \
 		cfg->ht_opmode = ht_opmode;
 		mask |= (1 << (NL80211_MESHCONF_HT_OPMODE - 1));
 	}
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPactivePathToRootTimeout,
-				  1, 65535, mask,
-				  NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT,
-				  nl80211_check_u32);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMProotInterval, 1, 65535,
-				  mask, NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
-				  nl80211_check_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
-				  dot11MeshHWMPconfirmationInterval,
-				  1, 65535, mask,
+				  dot11MeshHWMPactivePathToRootTimeout, mask,
+				  NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT,
+				  nla_get_u32);
+	if (mask & BIT(NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT) &&
+	    (cfg->dot11MeshHWMPactivePathToRootTimeout < 1 ||
+	     cfg->dot11MeshHWMPactivePathToRootTimeout > 65535))
+		return -EINVAL;
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMProotInterval, mask,
+				  NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
+				  nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPconfirmationInterval,
+				  mask,
 				  NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
-				  nl80211_check_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, power_mode,
-				  NL80211_MESH_POWER_ACTIVE,
-				  NL80211_MESH_POWER_MAX,
-				  mask, NL80211_MESHCONF_POWER_MODE,
-				  nl80211_check_power_mode);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshAwakeWindowDuration,
-				  0, 65535, mask,
-				  NL80211_MESHCONF_AWAKE_WINDOW, nl80211_check_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, plink_timeout, 0, 0xffffffff,
-				  mask, NL80211_MESHCONF_PLINK_TIMEOUT,
-				  nl80211_check_u32);
+				  nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, power_mode, mask,
+				  NL80211_MESHCONF_POWER_MODE, nla_get_u32);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshAwakeWindowDuration, mask,
+				  NL80211_MESHCONF_AWAKE_WINDOW, nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, plink_timeout, mask,
+				  NL80211_MESHCONF_PLINK_TIMEOUT, nla_get_u32);
 	if (mask_out)
 		*mask_out = mask;
 
@@ -9416,11 +9325,6 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 		    !wiphy_ext_feature_isset(&rdev->wiphy,
 					     NL80211_EXT_FEATURE_MFP_OPTIONAL))
 			return -EOPNOTSUPP;
-
-		if (connect.mfp != NL80211_MFP_REQUIRED &&
-		    connect.mfp != NL80211_MFP_NO &&
-		    connect.mfp != NL80211_MFP_OPTIONAL)
-			return -EINVAL;
 	} else {
 		connect.mfp = NL80211_MFP_NO;
 	}
@@ -10179,9 +10083,6 @@ static int nl80211_set_power_save(struct sk_buff *skb, struct genl_info *info)
 
 	ps_state = nla_get_u32(info->attrs[NL80211_ATTR_PS_STATE]);
 
-	if (ps_state != NL80211_PS_DISABLED && ps_state != NL80211_PS_ENABLED)
-		return -EINVAL;
-
 	wdev = dev->ieee80211_ptr;
 
 	if (!rdev->ops->set_power_mgmt)
@@ -11333,9 +11234,6 @@ static int nl80211_parse_coalesce_rule(struct cfg80211_registered_device *rdev,
 	if (tb[NL80211_ATTR_COALESCE_RULE_CONDITION])
 		new_rule->condition =
 			nla_get_u32(tb[NL80211_ATTR_COALESCE_RULE_CONDITION]);
-	if (new_rule->condition != NL80211_COALESCE_CONDITION_MATCH &&
-	    new_rule->condition != NL80211_COALESCE_CONDITION_NO_MATCH)
-		return -EINVAL;
 
 	if (!tb[NL80211_ATTR_COALESCE_RULE_PKT_PATTERN])
 		return -EINVAL;
@@ -11688,8 +11586,6 @@ static int nl80211_start_nan(struct sk_buff *skb, struct genl_info *info)
 
 	conf.master_pref =
 		nla_get_u8(info->attrs[NL80211_ATTR_NAN_MASTER_PREF]);
-	if (!conf.master_pref)
-		return -EINVAL;
 
 	if (info->attrs[NL80211_ATTR_BANDS]) {
 		u32 bands = nla_get_u32(info->attrs[NL80211_ATTR_BANDS]);
@@ -12674,12 +12570,7 @@ static int nl80211_add_tx_ts(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	tsid = nla_get_u8(info->attrs[NL80211_ATTR_TSID]);
-	if (tsid >= IEEE80211_NUM_TIDS)
-		return -EINVAL;
-
 	up = nla_get_u8(info->attrs[NL80211_ATTR_USER_PRIO]);
-	if (up >= IEEE80211_NUM_UPS)
-		return -EINVAL;
 
 	/* WMM uses TIDs 0-7 even for TSPEC */
 	if (tsid >= IEEE80211_FIRST_TSPEC_TSID) {
-- 
2.14.4

