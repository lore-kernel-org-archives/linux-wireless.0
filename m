Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33884 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbcF3JBP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 05:01:15 -0400
Received: by mail-pf0-f194.google.com with SMTP id 66so6855094pfy.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2016 02:01:15 -0700 (PDT)
From: Masashi Honma <masashi.honma@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, j@w1.fi, me@bobcopeland.com,
	Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH] cfg80211: Add mesh peer AID setting API
Date: Thu, 30 Jun 2016 18:00:58 +0900
Message-Id: <1467277258-2331-1-git-send-email-masashi.honma@gmail.com> (sfid-20160630_110121_286142_AEC5CA34)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, mesh peer AID is not reported to kernel when local mesh
STA is created without iw command. The mesh peer AID is needed by
mesh peer power management functionality to identify a AID in a TIM
element.

This patch creates mesh peer AID setting API.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 include/net/cfg80211.h       | 1 +
 include/uapi/linux/nl80211.h | 5 +++++
 net/mac80211/cfg.c           | 1 +
 net/wireless/nl80211.c       | 3 +++
 4 files changed, 10 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7bbb00d..2fa5896 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -805,6 +805,7 @@ struct station_parameters {
 	u32 sta_modify_mask;
 	int listen_interval;
 	u16 aid;
+	u16 mesh_aid;
 	u8 supported_rates_len;
 	u8 plink_action;
 	u8 plink_state;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 53c8278..f8c454e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1829,6 +1829,9 @@ enum nl80211_commands {
  *	%NL80211_ATTR_EXT_CAPA_MASK, to specify the extended capabilities per
  *	interface type.
  *
+ * @NL80211_ATTR_MESH_PEER_AID: Association ID for the mesh peer (u16). This is
+ *	used to pull the stored data for mesh peer in power save state.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2213,6 +2216,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_IFTYPE_EXT_CAPA,
 
+	NL80211_ATTR_MESH_PEER_AID,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0c12e40..08802f7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -997,6 +997,7 @@ static void sta_apply_mesh_params(struct ieee80211_local *local,
 			if (sta->mesh->plink_state != NL80211_PLINK_ESTAB)
 				changed = mesh_plink_inc_estab_count(sdata);
 			sta->mesh->plink_state = params->plink_state;
+			sta->mesh->aid = params->mesh_aid;
 
 			ieee80211_mps_sta_status_update(sta);
 			changed |= ieee80211_mps_set_sta_local_pm(sta,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c503e96..f41fb61 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4410,6 +4410,9 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_STATE]);
 		if (params.plink_state >= NUM_NL80211_PLINK_STATES)
 			return -EINVAL;
+		if (info->attrs[NL80211_ATTR_MESH_PEER_AID])
+			params.mesh_aid = nla_get_u16(
+				info->attrs[NL80211_ATTR_MESH_PEER_AID]);
 		params.sta_modify_mask |= STATION_PARAM_APPLY_PLINK_STATE;
 	}
 
-- 
2.5.0

