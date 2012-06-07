Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44642 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab2FGEju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 00:39:50 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so304475dad.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 21:39:50 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v2 2/4] mac80211: implement the proactive PREQ generation
Date: Thu,  7 Jun 2012 12:39:21 +0800
Message-Id: <1339043963-2043-3-git-send-email-yeohchunyeow@gmail.com> (sfid-20120607_063956_838988_BE0A3FF1)
In-Reply-To: <1339043963-2043-1-git-send-email-yeohchunyeow@gmail.com>
References: <1339043963-2043-1-git-send-email-yeohchunyeow@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Generate the proactive PREQ element as defined in Sec. 13.10.9.3 (Case C) of IEEE Std. 802.11-2012
based on the selection of dot11MeshHWMPRootMode as follow:
dot11MeshHWMPRootMode (2) is proactivePREQnoPREP
dot11MeshHWMPRootMode (3) is proactivePREQwithPREP

The proactive PREQ is generated based on the interval defined by dot11MeshHWMProotInterval.

With this change, proactive RANN element is now generated if the dot11MeshHWMPRootMode is set to
(4) instead of (1).

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
v2: redefine the root mesh STA mode identifier (Johannes)

 include/linux/ieee80211.h |   17 +++++++++++++++++
 net/mac80211/mesh.c       |    7 +++++--
 net/mac80211/mesh_hwmp.c  |   30 ++++++++++++++++++++++++++----
 3 files changed, 48 insertions(+), 6 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ce9af89..1d6a807 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1474,6 +1474,23 @@ enum {
 	IEEE80211_PATH_METRIC_VENDOR = 255,
 };
 
+/**
+ * enum - root mesh STA mode identifier used by dot11MeshHWMPRootMode
+ *
+ * @IEEE80211_NO_ROOT: the mesh STA is not a root mesh STA (default)
+ * @IEEE80211_PROACTIVE_PREQ_NO_PREP: the mesh STA is a root mesh STA
+ * supports the proactive PREQ with proactive PREP subfield set to 0
+ * @IEEE80211_PROACTIVE_PREQ_WITH_PREP: the mesh STA is a root mesh STA
+ * supports the proactive PREQ with proactive PREP subfield set to 1
+ * @IEEE80211_PROACTIVE_RANN: the mesh STA is a root mesh STA supports
+ * the proactive RANN
+ */
+enum {
+	IEEE80211_NO_ROOT = 0,
+	IEEE80211_PROACTIVE_PREQ_NO_PREP = 2,
+	IEEE80211_PROACTIVE_PREQ_WITH_PREP = 3,
+	IEEE80211_PROACTIVE_RANN = 4,
+};
 
 /*
  * IEEE 802.11-2007 7.3.2.9 Country information element
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 7cf1950..b690144 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -541,11 +541,14 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
 static void ieee80211_mesh_rootpath(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	u32 interval;
 
 	mesh_path_tx_root_frame(sdata);
+	interval = (ifmsh->mshcfg.dot11MeshHWMPRootMode ==
+	    IEEE80211_PROACTIVE_RANN) ? ifmsh->mshcfg.dot11MeshHWMPRannInterval
+	    : ifmsh->mshcfg.dot11MeshHWMProotInterval;
 	mod_timer(&ifmsh->mesh_path_root_timer,
-		  round_jiffies(TU_TO_EXP_TIME(
-				  ifmsh->mshcfg.dot11MeshHWMPRannInterval)));
+		  round_jiffies(TU_TO_EXP_TIME(interval)));
 }
 
 #ifdef CONFIG_PM
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index fa7c580..999db08 100644
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
 
@@ -1157,13 +1159,33 @@ mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata)
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
+	case IEEE80211_PROACTIVE_RANN:
+		mesh_path_sel_frame_tx(MPATH_RANN, flags, sdata->vif.addr,
 			       cpu_to_le32(++ifmsh->sn),
 			       0, NULL, 0, broadcast_addr,
-			       0, sdata->u.mesh.mshcfg.element_ttl,
+			       0, ifmsh->mshcfg.element_ttl,
 			       cpu_to_le32(interval), 0, 0, sdata);
+		break;
+	case IEEE80211_PROACTIVE_PREQ_WITH_PREP:
+		flags |= PREQ_F_PREP;
+	case IEEE80211_PROACTIVE_PREQ_NO_PREP:
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

