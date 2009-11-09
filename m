Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35804 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbZKIMkQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:40:16 -0500
Received: by mail-bw0-f227.google.com with SMTP id 27so3395312bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 04:40:21 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH 07/21] mac80211: add MAC80211_VERBOSE_MHWMP_DEBUG
Date: Mon,  9 Nov 2009 12:39:27 +0000
Message-Id: <1257770381-7680-8-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
References: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add MAC80211_VERBOSE_MHWMP_DEBUG, a debugging option for HWMP
frame processing.

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 net/mac80211/Kconfig     |   13 +++++++++++++
 net/mac80211/mesh_hwmp.c |   19 +++++++++++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 4d5543a..a10d508 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -194,6 +194,19 @@ config MAC80211_VERBOSE_MPL_DEBUG
 
 	  Do not select this option.
 
+config MAC80211_VERBOSE_MHWMP_DEBUG
+	bool "Verbose mesh HWMP routing debugging"
+	depends on MAC80211_DEBUG_MENU
+	depends on MAC80211_MESH
+	---help---
+	  Selecting this option causes mac80211 to print out very
+	  verbose mesh routing (HWMP) debugging messages (when mac80211
+	  is taking part in a mesh network).
+	  It should not be selected on production systems as those
+	  messages are remotely triggerable.
+
+	  Do not select this option.
+
 config MAC80211_DEBUG_COUNTERS
 	bool "Extra statistics for TX/RX debugging"
 	depends on MAC80211_DEBUG_MENU
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index c291cdb..6dbaec5 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -9,6 +9,12 @@
 
 #include "mesh.h"
 
+#ifdef CONFIG_MAC80211_VERBOSE_MHWMP_DEBUG
+#define mhwmp_dbg(fmt, args...)   printk(KERN_DEBUG "Mesh HWMP: " fmt, ##args)
+#else
+#define mhwmp_dbg(fmt, args...)   do { (void)(0); } while (0)
+#endif
+
 #define TEST_FRAME_LEN	8192
 #define MAX_METRIC	0xffffffff
 #define ARITH_SHIFT	8
@@ -109,11 +115,13 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 
 	switch (action) {
 	case MPATH_PREQ:
+		mhwmp_dbg("sending PREQ\n");
 		ie_len = 37;
 		pos = skb_put(skb, 2 + ie_len);
 		*pos++ = WLAN_EID_PREQ;
 		break;
 	case MPATH_PREP:
+		mhwmp_dbg("sending PREP\n");
 		ie_len = 31;
 		pos = skb_put(skb, 2 + ie_len);
 		*pos++ = WLAN_EID_PREP;
@@ -432,6 +440,8 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 	orig_dsn = PREQ_IE_ORIG_DSN(preq_elem);
 	dst_flags = PREQ_IE_DST_F(preq_elem);
 
+	mhwmp_dbg("received PREQ\n");
+
 	if (memcmp(dst_addr, sdata->dev->dev_addr, ETH_ALEN) == 0) {
 		forward = false;
 		reply = true;
@@ -467,13 +477,14 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 	if (reply) {
 		lifetime = PREQ_IE_LIFETIME(preq_elem);
 		ttl = ifmsh->mshcfg.dot11MeshTTL;
-		if (ttl != 0)
+		if (ttl != 0) {
+			mhwmp_dbg("replying to the PREQ\n");
 			mesh_path_sel_frame_tx(MPATH_PREP, 0, dst_addr,
 				cpu_to_le32(dst_dsn), 0, orig_addr,
 				cpu_to_le32(orig_dsn), mgmt->sa, 0, ttl,
 				cpu_to_le32(lifetime), cpu_to_le32(metric),
 				0, sdata);
-		else
+		} else
 			ifmsh->mshstats.dropped_frames_ttl++;
 	}
 
@@ -661,7 +672,7 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 
 	preq_node = kmalloc(sizeof(struct mesh_preq_queue), GFP_ATOMIC);
 	if (!preq_node) {
-		printk(KERN_DEBUG "Mesh HWMP: could not allocate PREQ node\n");
+		mhwmp_dbg("could not allocate PREQ node\n");
 		return;
 	}
 
@@ -670,7 +681,7 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 		spin_unlock(&ifmsh->mesh_preq_queue_lock);
 		kfree(preq_node);
 		if (printk_ratelimit())
-			printk(KERN_DEBUG "Mesh HWMP: PREQ node queue full\n");
+			mhwmp_dbg("PREQ node queue full\n");
 		return;
 	}
 
-- 
1.5.6.5

