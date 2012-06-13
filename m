Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36449 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab2FMJxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 05:53:20 -0400
Received: by pbbrp8 with SMTP id rp8so2063204pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 02:53:19 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v4 2/4] mac80211: implement the proactive PREQ generation
Date: Wed, 13 Jun 2012 17:52:22 +0800
Message-Id: <1339581144-9343-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120613_115323_811224_098DDDE2)
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
v3: redefine PREQ flag and target flag identifier (Johannes)
v4: add prefixes, fix and rename the enumerated types (Johannes)

 include/linux/ieee80211.h |   42 ++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/mesh.c       |   10 ++++++++--
 net/mac80211/mesh_hwmp.c  |   27 ++++++++++++++++++++++++---
 3 files changed, 74 insertions(+), 5 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ce9af89..b9ba3f8 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -568,6 +568,26 @@ struct ieee80211s_hdr {
 #define MESH_FLAGS_PS_DEEP	0x4
 
 /**
+ * enum ieee80211_preq_flags - mesh PREQ element flags
+ *
+ * @IEEE80211_PREQ_PROACTIVE_PREP_FLAG: proactive PREP subfield
+ */
+enum ieee80211_preq_flags {
+	IEEE80211_PREQ_PROACTIVE_PREP_FLAG	= 1<<2,
+};
+
+/**
+ * enum ieee80211_preq_target_flags - mesh PREQ element per target flags
+ *
+ * @IEEE80211_PREQ_TO_FLAG: target only subfield
+ * @IEEE80211_PREQ_USN_FLAG: unknown target HWMP sequence number subfield
+ */
+enum ieee80211_preq_target_flags {
+	IEEE80211_PREQ_TO_FLAG	= 1<<0,
+	IEEE80211_PREQ_USN_FLAG	= 1<<2,
+};
+
+/**
  * struct ieee80211_quiet_ie
  *
  * This structure refers to "Quiet information element"
@@ -1474,6 +1494,28 @@ enum {
 	IEEE80211_PATH_METRIC_VENDOR = 255,
 };
 
+/**
+ * enum ieee80211_root_mode_identifier - root mesh STA mode identifier
+ *
+ * These attribute are used by dot11MeshHWMPRootMode to set root mesh STA mode
+ *
+ * @IEEE80211_ROOTMODE_NO_ROOT: the mesh STA is not a root mesh STA (default)
+ * @IEEE80211_ROOTMODE_ROOT: the mesh STA is a root mesh STA if greater than
+ *	this value
+ * @IEEE80211_PROACTIVE_PREQ_NO_PREP: the mesh STA is a root mesh STA supports
+ *	the proactive PREQ with proactive PREP subfield set to 0
+ * @IEEE80211_PROACTIVE_PREQ_WITH_PREP: the mesh STA is a root mesh STA
+ *	supports the proactive PREQ with proactive PREP subfield set to 1
+ * @IEEE80211_PROACTIVE_RANN: the mesh STA is a root mesh STA supports
+ *	the proactive RANN
+ */
+enum ieee80211_root_mode_identifier {
+	IEEE80211_ROOTMODE_NO_ROOT = 0,
+	IEEE80211_ROOTMODE_ROOT = 1,
+	IEEE80211_PROACTIVE_PREQ_NO_PREP = 2,
+	IEEE80211_PROACTIVE_PREQ_WITH_PREP = 3,
+	IEEE80211_PROACTIVE_RANN = 4,
+};
 
 /*
  * IEEE 802.11-2007 7.3.2.9 Country information element
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 7cf1950..6bff3c4 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -541,11 +541,17 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
 static void ieee80211_mesh_rootpath(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	u32 interval;
 
 	mesh_path_tx_root_frame(sdata);
+
+	if (ifmsh->mshcfg.dot11MeshHWMPRootMode == IEEE80211_PROACTIVE_RANN)
+		interval = ifmsh->mshcfg.dot11MeshHWMPRannInterval;
+	else
+		interval = ifmsh->mshcfg.dot11MeshHWMProotInterval;
+
 	mod_timer(&ifmsh->mesh_path_root_timer,
-		  round_jiffies(TU_TO_EXP_TIME(
-				  ifmsh->mshcfg.dot11MeshHWMPRannInterval)));
+		  round_jiffies(TU_TO_EXP_TIME(interval)));
 }
 
 #ifdef CONFIG_PM
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index fa7c580..82031bb 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1157,13 +1157,34 @@ mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata)
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
+		flags |= IEEE80211_PREQ_PROACTIVE_PREP_FLAG;
+	case IEEE80211_PROACTIVE_PREQ_NO_PREP:
+		interval = ifmsh->mshcfg.dot11MeshHWMPactivePathToRootTimeout;
+		target_flags |= IEEE80211_PREQ_TO_FLAG |
+				IEEE80211_PREQ_USN_FLAG;
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

