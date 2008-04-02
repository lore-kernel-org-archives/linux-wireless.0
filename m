Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:2085 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbYDBUJT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 16:09:19 -0400
Received: by yw-out-2324.google.com with SMTP id 5so366720ywb.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Apr 2008 13:09:16 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Wed, 2 Apr 2008 12:33:35 -0700
Subject: [PATCH] Revert "mac80211: use a struct for bss->mesh_config"
Message-ID: <47f3e7eb.20038e0a.7994.ffffdbf9@mx.google.com> (sfid-20080402_211123_436217_13C6D1B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 2349f76c3987da12f737bbba4be78f23002477b6.

That patch breaks mesh config comparison between beacons/probe reponses, so
every beacon from a mesh network would be added as a new bss. Since the
comparison has to be performed for every received beacon I believe it is best to
save the mesh config in a format easy to compare, rather than do a bunch of
unaligned accesses to compare field by field.

---
 net/mac80211/ieee80211_i.h   |   13 ++-----------
 net/mac80211/ieee80211_sta.c |   32 ++++++++++++--------------------
 net/mac80211/mesh.c          |    4 ++++
 net/mac80211/mesh.h          |   10 ----------
 4 files changed, 18 insertions(+), 41 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6c62dd4..0997a0f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -69,14 +69,6 @@ struct ieee80211_fragment_entry {
 	u8 last_pn[6]; /* PN of the last fragment if CCMP was used */
 };
 
-struct bss_mesh_config {
-	u32 path_proto_id;
-	u32 path_metric_id;
-	u32 cong_control_id;
-	u32 channel_precedence;
-	u8 mesh_version;
-};
-
 
 struct ieee80211_sta_bss {
 	struct list_head list;
@@ -102,7 +94,7 @@ struct ieee80211_sta_bss {
 #ifdef CONFIG_MAC80211_MESH
 	u8 *mesh_id;
 	size_t mesh_id_len;
-	struct bss_mesh_config *mesh_cfg;
+	u8 *mesh_cfg;
 #endif
 #define IEEE80211_MAX_SUPP_RATES 32
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
@@ -121,8 +113,7 @@ struct ieee80211_sta_bss {
 	u8 erp_value;
 };
 
-static inline
-struct bss_mesh_config *bss_mesh_cfg(struct ieee80211_sta_bss *bss)
+static inline u8 *bss_mesh_cfg(struct ieee80211_sta_bss *bss)
 {
 #ifdef CONFIG_MAC80211_MESH
 	return bss->mesh_cfg;
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index c20ef89..1ee07f0 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -27,7 +27,6 @@
 #include <linux/rtnetlink.h>
 #include <net/iw_handler.h>
 #include <asm/types.h>
-#include <asm/unaligned.h>
 
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
@@ -2123,11 +2122,6 @@ ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int freq,
 }
 
 #ifdef CONFIG_MAC80211_MESH
-static inline u32 bss_mesh_cfg_get(u8 *mesh_cfg, u8 offset)
-{
-	return be32_to_cpu(get_unaligned((__be32 *) (mesh_cfg + offset)));
-}
-
 static struct ieee80211_sta_bss *
 ieee80211_rx_mesh_bss_get(struct net_device *dev, u8 *mesh_id, int mesh_id_len,
 			  u8 *mesh_cfg, int freq)
@@ -2167,7 +2161,7 @@ ieee80211_rx_mesh_bss_add(struct net_device *dev, u8 *mesh_id, int mesh_id_len,
 	if (!bss)
 		return NULL;
 
-	bss->mesh_cfg = kmalloc(sizeof(struct bss_mesh_config), GFP_ATOMIC);
+	bss->mesh_cfg = kmalloc(MESH_CFG_CMP_LEN, GFP_ATOMIC);
 	if (!bss->mesh_cfg) {
 		kfree(bss);
 		return NULL;
@@ -2185,12 +2179,7 @@ ieee80211_rx_mesh_bss_add(struct net_device *dev, u8 *mesh_id, int mesh_id_len,
 
 	atomic_inc(&bss->users);
 	atomic_inc(&bss->users);
-	bss->mesh_cfg->mesh_version = mesh_cfg[0];
-	bss->mesh_cfg->path_proto_id = bss_mesh_cfg_get(mesh_cfg, PP_OFFSET);
-	bss->mesh_cfg->path_metric_id = bss_mesh_cfg_get(mesh_cfg, PM_OFFSET);
-	bss->mesh_cfg->cong_control_id = bss_mesh_cfg_get(mesh_cfg, CC_OFFSET);
-	bss->mesh_cfg->channel_precedence = bss_mesh_cfg_get(mesh_cfg,
-							     CP_OFFSET);
+	memcpy(bss->mesh_cfg, mesh_cfg, MESH_CFG_CMP_LEN);
 	bss->mesh_id_len = mesh_id_len;
 	bss->freq = freq;
 	spin_lock_bh(&local->sta_bss_lock);
@@ -4067,33 +4056,36 @@ ieee80211_sta_scan_result(struct net_device *dev,
 
 	if (bss_mesh_cfg(bss)) {
 		char *buf;
-		struct bss_mesh_config *cfg = bss_mesh_cfg(bss);
+		u8 *cfg = bss_mesh_cfg(bss);
 		buf = kmalloc(50, GFP_ATOMIC);
 		if (buf) {
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = IWEVCUSTOM;
-			sprintf(buf, "Mesh network (version %d)",
-				cfg->mesh_version);
+			sprintf(buf, "Mesh network (version %d)", cfg[0]);
 			iwe.u.data.length = strlen(buf);
 			current_ev = iwe_stream_add_point(current_ev, end_buf,
 							  &iwe, buf);
 			sprintf(buf, "Path Selection Protocol ID: "
-				"0x%08X", cfg->path_proto_id);
+				"0x%02X%02X%02X%02X", cfg[1], cfg[2], cfg[3],
+							cfg[4]);
 			iwe.u.data.length = strlen(buf);
 			current_ev = iwe_stream_add_point(current_ev, end_buf,
 							  &iwe, buf);
 			sprintf(buf, "Path Selection Metric ID: "
-				"0x%08X", cfg->path_metric_id);
+				"0x%02X%02X%02X%02X", cfg[5], cfg[6], cfg[7],
+							cfg[8]);
 			iwe.u.data.length = strlen(buf);
 			current_ev = iwe_stream_add_point(current_ev, end_buf,
 							  &iwe, buf);
 			sprintf(buf, "Congestion Control Mode ID: "
-				"0x%08X", cfg->cong_control_id);
+				"0x%02X%02X%02X%02X", cfg[9], cfg[10],
+							cfg[11], cfg[12]);
 			iwe.u.data.length = strlen(buf);
 			current_ev = iwe_stream_add_point(current_ev, end_buf,
 							  &iwe, buf);
 			sprintf(buf, "Channel Precedence: "
-				"0x%08X", cfg->channel_precedence);
+				"0x%02X%02X%02X%02X", cfg[13], cfg[14],
+							cfg[15], cfg[16]);
 			iwe.u.data.length = strlen(buf);
 			current_ev = iwe_stream_add_point(current_ev, end_buf,
 							  &iwe, buf);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index b10f1e5..594a335 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -11,6 +11,10 @@
 #include "ieee80211_i.h"
 #include "mesh.h"
 
+#define PP_OFFSET 	1		/* Path Selection Protocol */
+#define PM_OFFSET	5		/* Path Selection Metric   */
+#define CC_OFFSET	9		/* Congestion Control Mode */
+#define CAPAB_OFFSET 17
 #define ACCEPT_PLINKS 0x80
 
 int mesh_allocated;
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 8ff46ea..742003d 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -157,16 +157,6 @@ struct mesh_rmc {
  */
 #define MESH_CFG_CMP_LEN 	17
 
-/*
- * Components offset within the mesh configuration IE
- */
-#define PP_OFFSET	1		/* Path Selection Protocol */
-#define PM_OFFSET	5		/* Path Selection Metric   */
-#define CC_OFFSET	9		/* Congestion Control Mode */
-#define CP_OFFSET	13		/* Channel Precedence */
-#define CAPAB_OFFSET	17		/* Mesh Capabilities */
-
-
 /* Default values, timeouts in ms */
 #define MESH_TTL 		5
 #define MESH_MAX_RETR	 	3
-- 
1.5.4.3



