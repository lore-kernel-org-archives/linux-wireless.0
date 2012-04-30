Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:56658 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784Ab2D3VU6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 17:20:58 -0400
Received: by mail-pz0-f51.google.com with SMTP id z8so4574046dad.10
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2012 14:20:58 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	javier@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH v2 4/4] [nl,cfg,mac]80211: Allow user to see/configure HT protection mode
Date: Mon, 30 Apr 2012 14:20:32 -0700
Message-Id: <1335820832-18887-4-git-send-email-ashok@cozybit.com> (sfid-20120430_232102_143570_9D367010)
In-Reply-To: <1335820832-18887-1-git-send-email-ashok@cozybit.com>
References: <1335820832-18887-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces a new mesh configuration parameter "ht_opmode" and will
allow user to check the current HT protection mode selected. Users could
configure the protection mode by the command "iw mesh_iface set mesh_param
mesh_ht_protection_mode=2". The default protection mode of mesh is set to
non-HT mixed mode.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Reviewed-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/linux/nl80211.h   |    3 +++
 include/net/cfg80211.h    |    1 +
 net/mac80211/cfg.c        |    5 +++++
 net/mac80211/mesh.c       |    3 +++
 net/mac80211/mesh_plink.c |    1 +
 net/wireless/mesh.c       |    1 +
 net/wireless/nl80211.c    |    5 +++++
 7 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 1335084..2540e86 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2154,6 +2154,8 @@ enum nl80211_mntr_flags {
  * @NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR: maximum number of neighbors
  * to synchronize to for 11s default synchronization method (see 11C.12.2.2)
  *
+ * @NL80211_MESHCONF_HT_OPMODE: set mesh HT protection mode.
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -2179,6 +2181,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_FORWARDING,
 	NL80211_MESHCONF_RSSI_THRESHOLD,
 	NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR,
+	NL80211_MESHCONF_HT_OPMODE,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 815dc3f..1c36cb5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -821,6 +821,7 @@ struct mesh_config {
 	bool  dot11MeshGateAnnouncementProtocol;
 	bool dot11MeshForwarding;
 	s32 rssi_threshold;
+	u16 ht_opmode;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 70b2af2..3532ae0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1364,6 +1364,11 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 			return -ENOTSUPP;
 		conf->rssi_threshold = nconf->rssi_threshold;
 	}
+	if (_chg_mesh_attr(NL80211_MESHCONF_HT_OPMODE, mask)) {
+		conf->ht_opmode = nconf->ht_opmode;
+		sdata->vif.bss_conf.ht_operation_mode = nconf->ht_opmode;
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_HT);
+	}
 	return 0;
 }
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 0fabb8b..0a21e4e 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -595,12 +595,15 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
 	ieee80211_mesh_root_setup(ifmsh);
 	ieee80211_queue_work(&local->hw, &sdata->work);
+	sdata->vif.bss_conf.ht_operation_mode =
+				ifmsh->mshcfg.ht_opmode;
 	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
 	sdata->vif.bss_conf.basic_rates =
 		ieee80211_mandatory_rates(sdata->local,
 					  sdata->local->hw.conf.channel->band);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
 						BSS_CHANGED_BEACON_ENABLED |
+						BSS_CHANGED_HT |
 						BSS_CHANGED_BASIC_RATES |
 						BSS_CHANGED_BEACON_INT);
 }
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 2e0ae73..8cc8461 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -157,6 +157,7 @@ out:
 
 	if (sdata->vif.bss_conf.ht_operation_mode != ht_opmode) {
 		sdata->vif.bss_conf.ht_operation_mode = ht_opmode;
+		sdata->u.mesh.mshcfg.ht_opmode = ht_opmode;
 		changed = BSS_CHANGED_HT;
 		mpl_dbg("mesh_plink %pM: protection mode changed to %d",
 			sdata->vif.addr, ht_opmode);
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 8c747fa..2749cb8 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -61,6 +61,7 @@ const struct mesh_config default_mesh_config = {
 	.dot11MeshGateAnnouncementProtocol = false,
 	.dot11MeshForwarding = true,
 	.rssi_threshold = MESH_RSSI_THRESHOLD,
+	.ht_opmode = IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED,
 };
 
 const struct mesh_setup default_mesh_setup = {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 140c1d2..859bd66 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3335,6 +3335,8 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 			cur_params.dot11MeshForwarding);
 	NLA_PUT_U32(msg, NL80211_MESHCONF_RSSI_THRESHOLD,
 			cur_params.rssi_threshold);
+	NLA_PUT_U32(msg, NL80211_MESHCONF_HT_OPMODE,
+			cur_params.ht_opmode);
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
 	return genlmsg_reply(msg, info);
@@ -3369,6 +3371,7 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_GATE_ANNOUNCEMENTS] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_FORWARDING] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_RSSI_THRESHOLD] = { .type = NLA_U32},
+	[NL80211_MESHCONF_HT_OPMODE] = { .type = NLA_U16},
 };
 
 static const struct nla_policy
@@ -3466,6 +3469,8 @@ do {\
 			mask, NL80211_MESHCONF_FORWARDING, nla_get_u8);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, rssi_threshold,
 			mask, NL80211_MESHCONF_RSSI_THRESHOLD, nla_get_u32);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, ht_opmode,
+			mask, NL80211_MESHCONF_HT_OPMODE, nla_get_u16);
 	if (mask_out)
 		*mask_out = mask;
 
-- 
1.7.5.4

