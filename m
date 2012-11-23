Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:40050 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab2KWUTT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 15:19:19 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>
Subject: [RFCv2 06/13] {cfg,nl}80211: allow userspace to set the local link-specific power mode
Date: Fri, 23 Nov 2012 12:18:47 -0800
Message-Id: <1353701934-12752-7-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121123_211925_215376_982ABBF8)
In-Reply-To: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The local link-specific power mode defines the mesh power mode in which the
local STA operates towards the peer STA of the corresponding mesh peering.

The idea behind link-specific power modes it that a node in low power mode may
set a single link to active mode to transport data, without having to notify
the surrounding peers (+ following routing updates, ...). This commit allows
userspace to set these local per-link power modes.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
---
 include/net/cfg80211.h       |    2 ++
 include/uapi/linux/nl80211.h |    5 +++++
 net/mac80211/cfg.c           |    4 ++++
 net/wireless/nl80211.c       |   16 ++++++++++++++++
 4 files changed, 27 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index cc61b4b..6eb0a6b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -506,6 +506,7 @@ enum station_parameters_apply_mask {
  * @sta_modify_mask: bitmap indicating which parameters changed
  *	(for those that don't have a natural "no change" value),
  *	see &enum station_parameters_apply_mask
+ * @local_ps_mode: local link-specific mesh power save mode
  */
 struct station_parameters {
 	u8 *supported_rates;
@@ -521,6 +522,7 @@ struct station_parameters {
 	struct ieee80211_vht_cap *vht_capa;
 	u8 uapsd_queues;
 	u8 max_sp;
+	enum nl80211_mesh_power_mode local_ps_mode;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index d0efa1e..bd54f21 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1281,6 +1281,9 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_SCAN_FLAGS: scan request control flags (u32)
  *
+ * @NL80211_ATTR_LOCAL_MESH_POWER_MODE: local mesh STA link-specific power mode
+ *	defined in &enum nl80211_mesh_power_mode.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1544,6 +1547,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SCAN_FLAGS,
 
+	NL80211_ATTR_LOCAL_MESH_POWER_MODE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 62564e9..2ed111f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1184,6 +1184,10 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 				mesh_plink_block(sta);
 				break;
 			}
+
+		if (params->local_ps_mode)
+			ieee80211_set_sta_mesh_local_ps_mode(sta,
+				params->local_ps_mode, 0);
 #endif
 	}
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3e2aa63..8749d3c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3100,6 +3100,18 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		params.plink_state =
 		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_STATE]);
 
+	if (info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE]) {
+		enum nl80211_mesh_power_mode pm = nla_get_u8(
+			info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE]);
+
+		if (pm <= NL80211_MESH_POWER_UNKNOWN ||
+		    pm >= __NL80211_MESH_POWER_AFTER_LAST)
+			return -EINVAL;
+
+		params.local_ps_mode =
+			nla_get_u8(info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE]);
+	}
+
 	switch (dev->ieee80211_ptr->iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
@@ -3107,6 +3119,8 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		/* disallow mesh-specific things */
 		if (params.plink_action)
 			return -EINVAL;
+		if (params.local_ps_mode)
+			err = -EINVAL;
 
 		/* TDLS can't be set, ... */
 		if (params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
@@ -3149,6 +3163,8 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 		if (params.listen_interval >= 0)
 			return -EINVAL;
+		if (params.local_ps_mode)
+			err = -EINVAL;
 		/* reject any changes other than AUTHORIZED */
 		if (params.sta_flags_mask & ~BIT(NL80211_STA_FLAG_AUTHORIZED))
 			return -EINVAL;
-- 
1.7.9.5

