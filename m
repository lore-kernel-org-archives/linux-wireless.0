Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:55186 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752255AbdEPJXa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 05:23:30 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, benjamin@sipsolutions.net,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4/7] mac80211: Allow following CSA to DFS channels if userspace handles it
Date: Tue, 16 May 2017 11:23:13 +0200
Message-Id: <20170516092316.15636-5-sw@simonwunderlich.de> (sfid-20170516_112814_517463_AF28D14A)
In-Reply-To: <20170516092316.15636-1-sw@simonwunderlich.de>
References: <20170516092316.15636-1-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benjamin Berg <benjamin@sipsolutions.net>

If userspace has flagged support for DFS earlier, then we can follow CSA
to DFS channels. So instead of rejecting the switch, allow it to happen
if the flag has been set during mesh setup.

Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/mac80211/cfg.c         |  1 +
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/mesh.c        | 15 ++++++++++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6c2e6060cd54..6980a936a437 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1874,6 +1874,7 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 	ifmsh->user_mpm = setup->user_mpm;
 	ifmsh->mesh_auth_id = setup->auth_id;
 	ifmsh->security = IEEE80211_MESH_SEC_NONE;
+	ifmsh->userspace_handles_dfs = setup->userspace_handles_dfs;
 	if (setup->is_authenticated)
 		ifmsh->security |= IEEE80211_MESH_SEC_AUTHED;
 	if (setup->is_secure)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 60bed6c69801..c960e4999380 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -643,6 +643,8 @@ struct ieee80211_if_mesh {
 	unsigned long wrkq_flags;
 	unsigned long mbss_changed;
 
+	bool userspace_handles_dfs;
+
 	u8 mesh_id[IEEE80211_MAX_MESH_ID_LEN];
 	size_t mesh_id_len;
 	/* Active Path Selection Protocol Identifier */
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 3702e3d9141d..4807a5d77572 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -979,7 +979,9 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 	params.count = csa_ie.count;
 
 	if (!cfg80211_chandef_usable(sdata->local->hw.wiphy, &params.chandef,
-				     IEEE80211_CHAN_DISABLED)) {
+				     IEEE80211_CHAN_DISABLED) ||
+	    !cfg80211_reg_can_beacon(sdata->local->hw.wiphy, &params.chandef,
+				     NL80211_IFTYPE_MESH_POINT)) {
 		sdata_info(sdata,
 			   "mesh STA %pM switches to unsupported channel (%d MHz, width:%d, CF1/2: %d/%d MHz), aborting\n",
 			   sdata->vif.addr,
@@ -995,9 +997,16 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 					    NL80211_IFTYPE_MESH_POINT);
 	if (err < 0)
 		return false;
-	if (err > 0)
-		/* TODO: DFS not (yet) supported */
+	if (err > 0 && !ifmsh->userspace_handles_dfs) {
+		sdata_info(sdata,
+			   "mesh STA %pM switches to channel requiring DFS (%d MHz, width:%d, CF1/2: %d/%d MHz), aborting\n",
+			   sdata->vif.addr,
+			   params.chandef.chan->center_freq,
+			   params.chandef.width,
+			   params.chandef.center_freq1,
+			   params.chandef.center_freq2);
 		return false;
+	}
 
 	params.radar_required = err;
 
-- 
2.11.0
