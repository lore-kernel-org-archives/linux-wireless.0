Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:45741 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424717Ab2LGWOp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 17:14:45 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so370032dak.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 14:14:44 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Marco Porsch <marco@cozybit.com>,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>
Subject: [RFCv3 5/5] nl80211: allow userspace to access mesh power mode parameters
Date: Fri,  7 Dec 2012 14:14:03 -0800
Message-Id: <1354918443-3076-6-git-send-email-marco@cozybit.com> (sfid-20121207_231457_966789_90C31A38)
In-Reply-To: <1354918443-3076-1-git-send-email-marco@cozybit.com>
References: <1354918443-3076-1-git-send-email-marco@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add access routines to:
get/set local link-specific power mode (STA)
get remote STA's link-specific power mode (STA)
get remote STA's non-peer power mode (STA)

get/set default mesh power mode (mesh config)
get/set mesh awake window duration (mesh config)

All config changes may be done at mesh runtime and take effect immediately.

Signed-off-by: Marco Porsch <marco@cozybit.com>
Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
---
 include/uapi/linux/nl80211.h |   12 ++++++++++++
 net/wireless/nl80211.c       |   43 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 78e37ad..9d04576 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1303,6 +1303,9 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_SCAN_FLAGS: scan request control flags (u32)
  *
+ * @NL80211_ATTR_LOCAL_MESH_POWER_MODE: local mesh STA link-specific power mode
+ *	defined in &enum nl80211_mesh_power_mode.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1570,6 +1573,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_CENTER_FREQ1,
 	NL80211_ATTR_CENTER_FREQ2,
 
+	NL80211_ATTR_LOCAL_MESH_POWER_MODE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1824,6 +1829,10 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_STA_FLAGS: Contains a struct nl80211_sta_flag_update.
  * @NL80211_STA_INFO_BEACON_LOSS: count of times beacon loss was detected (u32)
  * @NL80211_STA_INFO_T_OFFSET: timing offset with respect to this STA (s64)
+ * @NL80211_STA_INFO_LOCAL_PM: local mesh STA link-specific power mode
+ * @NL80211_STA_INFO_PEER_PM: peer mesh STA link-specific power mode
+ * @NL80211_STA_INFO_NONPEER_PM: neighbor mesh STA power save mode towards
+ *	non-peer STA
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -1848,6 +1857,9 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_STA_FLAGS,
 	NL80211_STA_INFO_BEACON_LOSS,
 	NL80211_STA_INFO_T_OFFSET,
+	NL80211_STA_INFO_LOCAL_PM,
+	NL80211_STA_INFO_PEER_PM,
+	NL80211_STA_INFO_NONPEER_PM,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dd179ad..f7945d0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3029,6 +3029,18 @@ static int nl80211_send_station(struct sk_buff *msg, u32 portid, u32 seq,
 	    nla_put_u32(msg, NL80211_STA_INFO_BEACON_LOSS,
 			sinfo->beacon_loss_count))
 		goto nla_put_failure;
+	if ((sinfo->filled & STATION_INFO_LOCAL_PM) &&
+	    nla_put_u8(msg, NL80211_STA_INFO_LOCAL_PM,
+			sinfo->local_pm))
+		goto nla_put_failure;
+	if ((sinfo->filled & STATION_INFO_PEER_PM) &&
+	    nla_put_u8(msg, NL80211_STA_INFO_PEER_PM,
+			sinfo->peer_pm))
+		goto nla_put_failure;
+	if ((sinfo->filled & STATION_INFO_NONPEER_PM) &&
+	    nla_put_u8(msg, NL80211_STA_INFO_NONPEER_PM,
+			sinfo->nonpeer_pm))
+		goto nla_put_failure;
 	if (sinfo->filled & STATION_INFO_BSS_PARAM) {
 		bss_param = nla_nest_start(msg, NL80211_STA_INFO_BSS_PARAM);
 		if (!bss_param)
@@ -3238,6 +3250,17 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		params.plink_state =
 		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_STATE]);
 
+	if (info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE]) {
+		enum nl80211_mesh_power_mode pm = nla_get_u8(
+			info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE]);
+
+		if (pm <= NL80211_MESH_POWER_UNKNOWN ||
+		    pm > NL80211_MESH_POWER_MAX)
+			return -EINVAL;
+
+		params.local_pm = pm;
+	}
+
 	switch (dev->ieee80211_ptr->iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
@@ -3245,6 +3268,8 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		/* disallow mesh-specific things */
 		if (params.plink_action)
 			return -EINVAL;
+		if (params.local_pm)
+			err = -EINVAL;
 
 		/* TDLS can't be set, ... */
 		if (params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
@@ -3287,6 +3312,8 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 		if (params.listen_interval >= 0)
 			return -EINVAL;
+		if (params.local_pm)
+			err = -EINVAL;
 		/* reject any changes other than AUTHORIZED */
 		if (params.sta_flags_mask & ~BIT(NL80211_STA_FLAG_AUTHORIZED))
 			return -EINVAL;
@@ -3908,7 +3935,11 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 	    nla_put_u16(msg, NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
 			cur_params.dot11MeshHWMProotInterval) ||
 	    nla_put_u16(msg, NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
-			cur_params.dot11MeshHWMPconfirmationInterval))
+			cur_params.dot11MeshHWMPconfirmationInterval) ||
+	    nla_put_u8(msg, NL80211_MESHCONF_POWER_MODE,
+		       cur_params.power_mode) ||
+	    nla_put_u16(msg, NL80211_MESHCONF_AWAKE_WINDOW,
+			cur_params.dot11MeshAwakeWindowDuration))
 		goto nla_put_failure;
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
@@ -3947,6 +3978,8 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT] = { .type = NLA_U32 },
 	[NL80211_MESHCONF_HWMP_ROOT_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_POWER_MODE] = { .type = NLA_U8 },
+	[NL80211_MESHCONF_AWAKE_WINDOW] = { .type = NLA_U16 },
 };
 
 static const struct nla_policy
@@ -4074,6 +4107,14 @@ do { \
 				  1, 65535, mask,
 				  NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
 				  nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, power_mode,
+				  NL80211_MESH_POWER_ACTIVE,
+				  NL80211_MESH_POWER_DEEP_SLEEP,
+				  mask, NL80211_MESHCONF_POWER_MODE,
+				  nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshAwakeWindowDuration,
+				  0, 65535, mask,
+				  NL80211_MESHCONF_AWAKE_WINDOW, nla_get_u16);
 	if (mask_out)
 		*mask_out = mask;
 
-- 
1.7.9.5

