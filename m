Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:50219 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab1HLCyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 22:54:14 -0400
Received: by iye16 with SMTP id 16so634961iye.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 19:54:13 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v2 1/8] mac80211: improve mpath debugging
Date: Thu, 11 Aug 2011 19:53:54 -0700
Message-Id: <1313117641-27351-1-git-send-email-thomas@cozybit.com> (sfid-20110812_045422_502616_15FC89DE)
In-Reply-To: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

make hwmp_dbg print the relevant sdata->name by default and improve
formatting. Also add mpath_dbg function for debugging of mesh path
operations.

Signed-off-by: Javier Cardona <javier@cozybit.com>

---
v2:
	- make mpath_dbg a function (Johannes)

 net/mac80211/Kconfig        |   13 +++++++++++++
 net/mac80211/mesh_hwmp.c    |   23 ++++++++++++-----------
 net/mac80211/mesh_pathtbl.c |   22 ++++++++++++++++++++++
 3 files changed, 47 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index f5fdfcb..d1886b5 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -199,6 +199,19 @@ config MAC80211_VERBOSE_MPL_DEBUG
 
 	  Do not select this option.
 
+config MAC80211_VERBOSE_MPATH_DEBUG
+	bool "Verbose mesh path debugging"
+	depends on MAC80211_DEBUG_MENU
+	depends on MAC80211_MESH
+	---help---
+	  Selecting this option causes mac80211 to print out very
+	  verbose mesh path selection debugging messages (when mac80211
+	  is taking part in a mesh network).
+	  It should not be selected on production systems as those
+	  messages are remotely triggerable.
+
+	  Do not select this option.
+
 config MAC80211_VERBOSE_MHWMP_DEBUG
 	bool "Verbose mesh HWMP routing debugging"
 	depends on MAC80211_DEBUG_MENU
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 9c3c0b8..abd0347 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -11,7 +11,8 @@
 #include "mesh.h"
 
 #ifdef CONFIG_MAC80211_VERBOSE_MHWMP_DEBUG
-#define mhwmp_dbg(fmt, args...)   printk(KERN_DEBUG "Mesh HWMP: " fmt, ##args)
+#define mhwmp_dbg(fmt, args...) \
+	printk(KERN_DEBUG "Mesh HWMP (%s): " fmt "\n", sdata->name, ##args)
 #else
 #define mhwmp_dbg(fmt, args...)   do { (void)(0); } while (0)
 #endif
@@ -138,19 +139,19 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 
 	switch (action) {
 	case MPATH_PREQ:
-		mhwmp_dbg("sending PREQ to %pM\n", target);
+		mhwmp_dbg("sending PREQ to %pM", target);
 		ie_len = 37;
 		pos = skb_put(skb, 2 + ie_len);
 		*pos++ = WLAN_EID_PREQ;
 		break;
 	case MPATH_PREP:
-		mhwmp_dbg("sending PREP to %pM\n", target);
+		mhwmp_dbg("sending PREP to %pM", target);
 		ie_len = 31;
 		pos = skb_put(skb, 2 + ie_len);
 		*pos++ = WLAN_EID_PREP;
 		break;
 	case MPATH_RANN:
-		mhwmp_dbg("sending RANN from %pM\n", orig_addr);
+		mhwmp_dbg("sending RANN from %pM", orig_addr);
 		ie_len = sizeof(struct ieee80211_rann_ie);
 		pos = skb_put(skb, 2 + ie_len);
 		*pos++ = WLAN_EID_RANN;
@@ -494,10 +495,10 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 	orig_sn = PREQ_IE_ORIG_SN(preq_elem);
 	target_flags = PREQ_IE_TARGET_F(preq_elem);
 
-	mhwmp_dbg("received PREQ from %pM\n", orig_addr);
+	mhwmp_dbg("received PREQ from %pM", orig_addr);
 
 	if (memcmp(target_addr, sdata->vif.addr, ETH_ALEN) == 0) {
-		mhwmp_dbg("PREQ is for us\n");
+		mhwmp_dbg("PREQ is for us");
 		forward = false;
 		reply = true;
 		metric = 0;
@@ -533,7 +534,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		lifetime = PREQ_IE_LIFETIME(preq_elem);
 		ttl = ifmsh->mshcfg.element_ttl;
 		if (ttl != 0) {
-			mhwmp_dbg("replying to the PREQ\n");
+			mhwmp_dbg("replying to the PREQ");
 			mesh_path_sel_frame_tx(MPATH_PREP, 0, target_addr,
 				cpu_to_le32(target_sn), 0, orig_addr,
 				cpu_to_le32(orig_sn), mgmt->sa, 0, ttl,
@@ -553,7 +554,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 			ifmsh->mshstats.dropped_frames_ttl++;
 			return;
 		}
-		mhwmp_dbg("forwarding the PREQ from %pM\n", orig_addr);
+		mhwmp_dbg("forwarding the PREQ from %pM", orig_addr);
 		--ttl;
 		flags = PREQ_IE_FLAGS(preq_elem);
 		preq_id = PREQ_IE_PREQ_ID(preq_elem);
@@ -588,7 +589,7 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 	u8 next_hop[ETH_ALEN];
 	u32 target_sn, orig_sn, lifetime;
 
-	mhwmp_dbg("received PREP from %pM\n", PREP_IE_ORIG_ADDR(prep_elem));
+	mhwmp_dbg("received PREP from %pM", PREP_IE_ORIG_ADDR(prep_elem));
 
 	/* Note that we divert from the draft nomenclature and denominate
 	 * destination to what the draft refers to as origininator. So in this
@@ -799,7 +800,7 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 
 	preq_node = kmalloc(sizeof(struct mesh_preq_queue), GFP_ATOMIC);
 	if (!preq_node) {
-		mhwmp_dbg("could not allocate PREQ node\n");
+		mhwmp_dbg("could not allocate PREQ node");
 		return;
 	}
 
@@ -808,7 +809,7 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 		spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
 		kfree(preq_node);
 		if (printk_ratelimit())
-			mhwmp_dbg("PREQ node queue full\n");
+			mhwmp_dbg("PREQ node queue full");
 		return;
 	}
 
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 6ffcd53..3ce6c85 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -17,6 +17,28 @@
 #include "ieee80211_i.h"
 #include "mesh.h"
 
+#ifdef CONFIG_MAC80211_VERBOSE_MPATH_DEBUG
+static inline void mpath_dbg(const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_DEBUG "%pV", &vaf);
+	va_end(args);
+	return;
+}
+#else
+static inline void mpath_dbg(const char *fmt, ...)
+{
+	return;
+}
+#endif
+
 /* There will be initially 2^INIT_PATHS_SIZE_ORDER buckets */
 #define INIT_PATHS_SIZE_ORDER	2
 
-- 
1.7.4.1

