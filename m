Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63510 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2FFKVF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:21:05 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so8594095dad.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 03:21:05 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH 2/4] mac80211: implement the proactive PREQ generation
Date: Wed,  6 Jun 2012 18:20:37 +0800
Message-Id: <1338978039-4269-3-git-send-email-yeohchunyeow@gmail.com> (sfid-20120606_122110_005478_22EC6B2C)
In-Reply-To: <1338978039-4269-1-git-send-email-yeohchunyeow@gmail.com>
References: <1338978039-4269-1-git-send-email-yeohchunyeow@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Generate the proactive PREQ element as defined in Sec. 13.10.9.3 (Case C) of IEEE Std. 802.11-2012
based on the setting of dot11MeshHWMPRootMode as follow:
dot11MeshHWMPRootMode (2) is proactivePREQnoPREP
dot11MeshHWMPRootMode (3) is proactivePREQwithPREP

The proactive PREQ is generated based on the interval defined by dot11MeshHWMProotInterval.

With this change, proactive RANN element is now generated if the dot11MeshHWMPRootMode is set to
(4) instead of (1).

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh.c      |    7 +++++--
 net/mac80211/mesh_hwmp.c |   38 ++++++++++++++++++++++++++++++++++----
 2 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 7cf1950..5e19e0d 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -541,11 +541,14 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
 static void ieee80211_mesh_rootpath(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	u32 interval;
 
 	mesh_path_tx_root_frame(sdata);
+	interval = (ifmsh->mshcfg.dot11MeshHWMPRootMode == 4) ?
+			ifmsh->mshcfg.dot11MeshHWMPRannInterval :
+				ifmsh->mshcfg.dot11MeshHWMProotInterval;
 	mod_timer(&ifmsh->mesh_path_root_timer,
-		  round_jiffies(TU_TO_EXP_TIME(
-				  ifmsh->mshcfg.dot11MeshHWMPRannInterval)));
+		  round_jiffies(TU_TO_EXP_TIME(interval)));
 }
 
 #ifdef CONFIG_PM
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index fa7c580..b1e4399 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -33,9 +33,11 @@
 /* Reply and forward */
 #define MP_F_RF	0x2
 /* Unknown Sequence Number */
-#define MP_F_USN    0x01
+#define MP_F_USN    0x04
 /* Reason code Present */
 #define MP_F_RCODE  0x02
+/* Proactive PREQ with PREP */
+#define PREQ_F_PREP 0x04
 
 static void mesh_queue_preq(struct mesh_path *, u8);
 
@@ -106,6 +108,14 @@ enum mpath_frame_type {
 	MPATH_RANN
 };
 
+enum mesh_hwmp_rootmode {
+	noRoot = 0,
+	notavailable,
+	proactivePREQnoPREP,
+	proactivePREQwithPREP,
+	rann
+};
+
 static const u8 broadcast_addr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
 static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
@@ -1157,13 +1167,33 @@ mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u32 interval = ifmsh->mshcfg.dot11MeshHWMPRannInterval;
-	u8 flags;
+	u8 flags, target_flags = 0;
 
 	flags = (ifmsh->mshcfg.dot11MeshGateAnnouncementProtocol)
 			? RANN_FLAG_IS_GATE : 0;
-	mesh_path_sel_frame_tx(MPATH_RANN, flags, sdata->vif.addr,
+
+	switch (ifmsh->mshcfg.dot11MeshHWMPRootMode) {
+	case rann:
+		mesh_path_sel_frame_tx(MPATH_RANN, flags, sdata->vif.addr,
 			       cpu_to_le32(++ifmsh->sn),
 			       0, NULL, 0, broadcast_addr,
-			       0, sdata->u.mesh.mshcfg.element_ttl,
+			       0, ifmsh->mshcfg.element_ttl,
 			       cpu_to_le32(interval), 0, 0, sdata);
+		break;
+	case proactivePREQwithPREP:
+		flags |= PREQ_F_PREP;
+	case proactivePREQnoPREP:
+		interval = ifmsh->mshcfg.dot11MeshHWMPactivePathToRootTimeout;
+		target_flags |= MP_F_DO | MP_F_USN;
+		mesh_path_sel_frame_tx(MPATH_PREQ, flags, sdata->vif.addr,
+				cpu_to_le32(++ifmsh->sn), target_flags,
+				(u8 *) broadcast_addr, 0, broadcast_addr,
+				0, ifmsh->mshcfg.element_ttl,
+				cpu_to_le32(interval),
+				0, cpu_to_le32(ifmsh->preq_id++), sdata);
+		break;
+	default:
+		mhwmp_dbg("Proactive mechanism not supported");
+		return;
+	}
 }
-- 
1.7.0.4

