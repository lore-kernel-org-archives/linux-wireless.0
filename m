Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:39729 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab2KQGsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 01:48:47 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>
Subject: [RFC 07/14] {cfg,nl}80211: set local link-specific power mode
Date: Fri, 16 Nov 2012 22:47:59 -0800
Message-Id: <1353134886-13256-8-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121117_074900_013719_C2B74D65)
In-Reply-To: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The local link-specific power mode defines the mesh power mode in which
the local STA operates towards the peer STA of the corresponding mesh
peering.
This commit adds the possibility of setting the local link-specific
power mode.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
---
 include/net/cfg80211.h       |    2 ++
 include/uapi/linux/nl80211.h |    5 +++++
 net/mac80211/cfg.c           |    4 ++++
 net/wireless/nl80211.c       |    8 ++++++++
 4 files changed, 19 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9488782..efec888 100644
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
index a6b2886..0e7528f 100644
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
index 4454aa1..d0f936d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1184,6 +1184,10 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 				mesh_plink_block(sta);
 				break;
 			}
+
+		if (params->local_ps_mode)
+			ieee80211_set_local_ps_mode(sta,
+				params->local_ps_mode, 0);
 #endif
 	}
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0312d74..d3ebdc6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3100,6 +3100,10 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		params.plink_state =
 		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_STATE]);
 
+	if (info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE])
+		params.local_ps_mode =
+			nla_get_u8(info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE]);
+
 	switch (dev->ieee80211_ptr->iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
@@ -3107,6 +3111,8 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		/* disallow mesh-specific things */
 		if (params.plink_action)
 			return -EINVAL;
+		if (params.local_ps_mode)
+			err = -EINVAL;
 
 		/* TDLS can't be set, ... */
 		if (params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
@@ -3149,6 +3155,8 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
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

