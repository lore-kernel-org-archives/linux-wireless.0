Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22EBDC64EB5
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 08:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4C152089A
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 08:00:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4C152089A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbeJBOmZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 10:42:25 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:42186 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbeJBOmY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 10:42:24 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g7FbT-0002Kl-SV; Tue, 02 Oct 2018 10:00:24 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] nl80211: use netlink policy validation function for elements
Date:   Tue,  2 Oct 2018 10:00:08 +0200
Message-Id: <20181002080008.26434-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
In-Reply-To: <20181002080008.26434-1-johannes@sipsolutions.net>
References: <20181002080008.26434-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Instead of open-coding a lot of calls to is_valid_ie_attr(),
add this validation directly to the policy, now that we can.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 122 +++++++++++++++++++------------------------------
 1 file changed, 46 insertions(+), 76 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d894f78e6b0a..36e26ac20638 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -200,6 +200,36 @@ cfg80211_get_dev_from_info(struct net *netns, struct genl_info *info)
 	return __cfg80211_rdev_from_attrs(netns, info->attrs);
 }
 
+static int validate_ie_attr(const struct nlattr *attr,
+			    struct netlink_ext_ack *extack)
+{
+	const u8 *pos;
+	int len;
+
+	pos = nla_data(attr);
+	len = nla_len(attr);
+
+	while (len) {
+		u8 elemlen;
+
+		if (len < 2)
+			goto error;
+		len -= 2;
+
+		elemlen = pos[1];
+		if (elemlen > len)
+			goto error;
+
+		len -= elemlen;
+		pos += 2 + elemlen;
+	}
+
+	return 0;
+error:
+	NL_SET_ERR_MSG_ATTR(extack, attr, "malformed information elements");
+	return -EINVAL;
+}
+
 /* policy for the attributes */
 static const struct nla_policy
 nl80211_ftm_responder_policy[NL80211_FTM_RESP_ATTR_MAX + 1] = {
@@ -250,8 +280,9 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_DTIM_PERIOD] = { .type = NLA_U32 },
 	[NL80211_ATTR_BEACON_HEAD] = { .type = NLA_BINARY,
 				       .len = IEEE80211_MAX_DATA_LEN },
-	[NL80211_ATTR_BEACON_TAIL] = { .type = NLA_BINARY,
-				       .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_BEACON_TAIL] =
+		NLA_POLICY_VALIDATE_FN(NLA_BINARY, validate_ie_attr,
+				       IEEE80211_MAX_DATA_LEN),
 	[NL80211_ATTR_STA_AID] =
 		NLA_POLICY_RANGE(NLA_U16, 1, IEEE80211_MAX_AID),
 	[NL80211_ATTR_STA_FLAGS] = { .type = NLA_NESTED },
@@ -282,8 +313,9 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_HT_CAPABILITY] = { .len = NL80211_HT_CAPABILITY_LEN },
 
 	[NL80211_ATTR_MGMT_SUBTYPE] = { .type = NLA_U8 },
-	[NL80211_ATTR_IE] = { .type = NLA_BINARY,
-			      .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_IE] = NLA_POLICY_VALIDATE_FN(NLA_BINARY,
+						   validate_ie_attr,
+						   IEEE80211_MAX_DATA_LEN),
 	[NL80211_ATTR_SCAN_FREQUENCIES] = { .type = NLA_NESTED },
 	[NL80211_ATTR_SCAN_SSIDS] = { .type = NLA_NESTED },
 
@@ -341,10 +373,12 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 		NLA_POLICY_RANGE(NLA_U32,
 				 NL80211_HIDDEN_SSID_NOT_IN_USE,
 				 NL80211_HIDDEN_SSID_ZERO_CONTENTS),
-	[NL80211_ATTR_IE_PROBE_RESP] = { .type = NLA_BINARY,
-					 .len = IEEE80211_MAX_DATA_LEN },
-	[NL80211_ATTR_IE_ASSOC_RESP] = { .type = NLA_BINARY,
-					 .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_IE_PROBE_RESP] =
+		NLA_POLICY_VALIDATE_FN(NLA_BINARY, validate_ie_attr,
+				       IEEE80211_MAX_DATA_LEN),
+	[NL80211_ATTR_IE_ASSOC_RESP] =
+		NLA_POLICY_VALIDATE_FN(NLA_BINARY, validate_ie_attr,
+				       IEEE80211_MAX_DATA_LEN),
 	[NL80211_ATTR_ROAM_SUPPORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_SCHED_SCAN_MATCH] = { .type = NLA_NESTED },
 	[NL80211_ATTR_TX_NO_CCK_RATE] = { .type = NLA_FLAG },
@@ -649,36 +683,6 @@ static int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
 	return 0;
 }
 
-/* IE validation */
-static bool is_valid_ie_attr(const struct nlattr *attr)
-{
-	const u8 *pos;
-	int len;
-
-	if (!attr)
-		return true;
-
-	pos = nla_data(attr);
-	len = nla_len(attr);
-
-	while (len) {
-		u8 elemlen;
-
-		if (len < 2)
-			return false;
-		len -= 2;
-
-		elemlen = pos[1];
-		if (elemlen > len)
-			return false;
-
-		len -= elemlen;
-		pos += 2 + elemlen;
-	}
-
-	return true;
-}
-
 /* message building helper */
 static inline void *nl80211hdr_put(struct sk_buff *skb, u32 portid, u32 seq,
 				   int flags, u8 cmd)
@@ -4017,12 +4021,6 @@ static int nl80211_parse_beacon(struct cfg80211_registered_device *rdev,
 	bool haveinfo = false;
 	int err;
 
-	if (!is_valid_ie_attr(attrs[NL80211_ATTR_BEACON_TAIL]) ||
-	    !is_valid_ie_attr(attrs[NL80211_ATTR_IE]) ||
-	    !is_valid_ie_attr(attrs[NL80211_ATTR_IE_PROBE_RESP]) ||
-	    !is_valid_ie_attr(attrs[NL80211_ATTR_IE_ASSOC_RESP]))
-		return -EINVAL;
-
 	memset(bcn, 0, sizeof(*bcn));
 
 	if (attrs[NL80211_ATTR_BEACON_HEAD]) {
@@ -6188,8 +6186,9 @@ static const struct nla_policy
 	[NL80211_MESH_SETUP_USERSPACE_AUTH] = { .type = NLA_FLAG },
 	[NL80211_MESH_SETUP_AUTH_PROTOCOL] = { .type = NLA_U8 },
 	[NL80211_MESH_SETUP_USERSPACE_MPM] = { .type = NLA_FLAG },
-	[NL80211_MESH_SETUP_IE] = { .type = NLA_BINARY,
-				    .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_MESH_SETUP_IE] =
+		NLA_POLICY_VALIDATE_FN(NLA_BINARY, validate_ie_attr,
+				       IEEE80211_MAX_DATA_LEN),
 	[NL80211_MESH_SETUP_USERSPACE_AMPE] = { .type = NLA_FLAG },
 };
 
@@ -6369,8 +6368,6 @@ static int nl80211_parse_mesh_setup(struct genl_info *info,
 	if (tb[NL80211_MESH_SETUP_IE]) {
 		struct nlattr *ieattr =
 			tb[NL80211_MESH_SETUP_IE];
-		if (!is_valid_ie_attr(ieattr))
-			return -EINVAL;
 		setup->ie = nla_data(ieattr);
 		setup->ie_len = nla_len(ieattr);
 	}
@@ -7003,9 +7000,6 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	int err, tmp, n_ssids = 0, n_channels, i;
 	size_t ie_len;
 
-	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
-		return -EINVAL;
-
 	wiphy = &rdev->wiphy;
 
 	if (wdev->iftype == NL80211_IFTYPE_NAN)
@@ -7359,9 +7353,6 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 	struct nlattr *tb[NL80211_SCHED_SCAN_MATCH_ATTR_MAX + 1];
 	s32 default_match_rssi = NL80211_SCAN_RSSI_THOLD_OFF;
 
-	if (!is_valid_ie_attr(attrs[NL80211_ATTR_IE]))
-		return ERR_PTR(-EINVAL);
-
 	if (attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
 		n_channels = validate_scan_freqs(
 				attrs[NL80211_ATTR_SCAN_FREQUENCIES]);
@@ -8329,9 +8320,6 @@ static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 	struct key_parse key;
 	bool local_state_change;
 
-	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
-		return -EINVAL;
-
 	if (!info->attrs[NL80211_ATTR_MAC])
 		return -EINVAL;
 
@@ -8570,9 +8558,6 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 	    dev->ieee80211_ptr->conn_owner_nlportid != info->snd_portid)
 		return -EPERM;
 
-	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
-		return -EINVAL;
-
 	if (!info->attrs[NL80211_ATTR_MAC] ||
 	    !info->attrs[NL80211_ATTR_SSID] ||
 	    !info->attrs[NL80211_ATTR_WIPHY_FREQ])
@@ -8696,9 +8681,6 @@ static int nl80211_deauthenticate(struct sk_buff *skb, struct genl_info *info)
 	    dev->ieee80211_ptr->conn_owner_nlportid != info->snd_portid)
 		return -EPERM;
 
-	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
-		return -EINVAL;
-
 	if (!info->attrs[NL80211_ATTR_MAC])
 		return -EINVAL;
 
@@ -8747,9 +8729,6 @@ static int nl80211_disassociate(struct sk_buff *skb, struct genl_info *info)
 	    dev->ieee80211_ptr->conn_owner_nlportid != info->snd_portid)
 		return -EPERM;
 
-	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
-		return -EINVAL;
-
 	if (!info->attrs[NL80211_ATTR_MAC])
 		return -EINVAL;
 
@@ -8824,9 +8803,6 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 
 	memset(&ibss, 0, sizeof(ibss));
 
-	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
-		return -EINVAL;
-
 	if (!info->attrs[NL80211_ATTR_SSID] ||
 	    !nla_len(info->attrs[NL80211_ATTR_SSID]))
 		return -EINVAL;
@@ -9264,9 +9240,6 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 
 	memset(&connect, 0, sizeof(connect));
 
-	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
-		return -EINVAL;
-
 	if (!info->attrs[NL80211_ATTR_SSID] ||
 	    !nla_len(info->attrs[NL80211_ATTR_SSID]))
 		return -EINVAL;
@@ -9497,8 +9470,6 @@ static int nl80211_update_connect_params(struct sk_buff *skb,
 		return -EOPNOTSUPP;
 
 	if (info->attrs[NL80211_ATTR_IE]) {
-		if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
-			return -EINVAL;
 		connect.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
 		connect.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 		changed |= UPDATE_ASSOC_IES;
@@ -12149,8 +12120,7 @@ static int nl80211_update_ft_ies(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 
 	if (!info->attrs[NL80211_ATTR_MDID] ||
-	    !info->attrs[NL80211_ATTR_IE] ||
-	    !is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
+	    !info->attrs[NL80211_ATTR_IE])
 		return -EINVAL;
 
 	memset(&ft_params, 0, sizeof(ft_params));
-- 
2.14.4

