Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53076 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab1DGXJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 19:09:28 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so2939043iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 16:09:28 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes.berg@sipsolutions.net, linville@tuxdriver.com,
	javier@cozybit.com
Subject: [PATCH v8 3/9] mac80211: ignore peers if security is enabled for this mesh
Date: Thu,  7 Apr 2011 15:08:29 -0700
Message-Id: <1302214115-3688-4-git-send-email-thomas@cozybit.com>
In-Reply-To: <1302214115-3688-1-git-send-email-thomas@cozybit.com>
References: <1302214115-3688-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/cfg.c         |    1 +
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mesh.c        |    4 ++++
 net/mac80211/mesh_plink.c  |    4 ++++
 net/wireless/mesh.c        |    1 +
 5 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7f5d3b0..4f16f66 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1042,6 +1042,7 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 	memcpy(ifmsh->mesh_id, setup->mesh_id, ifmsh->mesh_id_len);
 	ifmsh->mesh_pp_id = setup->path_sel_proto;
 	ifmsh->mesh_pm_id = setup->path_metric;
+	ifmsh->is_secure = setup->is_secure;
 
 	return 0;
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6450100..8d6d6e3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -490,6 +490,7 @@ struct ieee80211_if_mesh {
 	bool accepting_plinks;
 	const u8 *ie;
 	u8 ie_len;
+	bool is_secure;
 };
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 1c244c0..47a26c0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -573,6 +573,10 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
 			       &elems);
 
+	/* ignore beacons from secure mesh peers if our security is off */
+	if (elems.rsn_len && !sdata->u.mesh.is_secure)
+		return;
+
 	if (elems.ds_params && elems.ds_params_len == 1)
 		freq = ieee80211_channel_to_frequency(elems.ds_params[0], band);
 	else
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index c705b20..bafe255 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -449,6 +449,10 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		mpl_dbg("Mesh plink: missing necessary peer link ie\n");
 		return;
 	}
+	if (elems.rsn_len && !sdata->u.mesh.is_secure) {
+		mpl_dbg("Mesh plink: can't establish link with secure peer\n");
+		return;
+	}
 
 	ftype = mgmt->u.action.u.plink_action.action_code;
 	ie_len = elems.peer_link_len;
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 0e5c122..e0226e8 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -55,6 +55,7 @@ const struct mesh_setup default_mesh_setup = {
 	.path_metric = IEEE80211_PATH_METRIC_AIRTIME,
 	.ie = NULL,
 	.ie_len = 0,
+	.is_secure = false,
 };
 
 int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
-- 
1.7.4.4

