Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.188]:11472 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYCCUUO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 15:20:14 -0500
Received: by gv-out-0910.google.com with SMTP id s4so170480gve.37
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2008 12:20:12 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Fri, 29 Feb 2008 12:13:38 -0800
Subject: [PATCH 01/10] mac80211: fix mesh endianness sparse warnings and unmark it as broken
Message-ID: <47cc5d79.01f6600a.48b7.ffff8587@mx.google.com> (sfid-20080303_202055_232267_CB2FA3C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes all the mesh related endianness warnings reported by sparse. As
they were the reason why Johannes marked mesh as BROKEN, that flag has been
removed.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/Kconfig      |    2 +-
 net/mac80211/mesh_hwmp.c  |   24 ++++++++++++------------
 net/mac80211/mesh_plink.c |    5 +++--
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 5ca576e..3c3f62f 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -83,7 +83,7 @@ endmenu
 
 config MAC80211_MESH
 	bool "Enable mac80211 mesh networking (pre-802.11s) support"
-	depends on MAC80211 && EXPERIMENTAL && BROKEN
+	depends on MAC80211 && EXPERIMENTAL
 	---help---
 	 This options enables support of Draft 802.11s mesh networking.
 	 The implementation is based on Draft 1.08 of the Mesh Networking
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index d8530fe..3ee46e4 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -30,16 +30,16 @@
 #define PREQ_IE_FLAGS(x) (*(x))
 #define PREQ_IE_HOPCOUNT(x) (*(x + 1))
 #define PREQ_IE_TTL(x) (*(x + 2))
-#define PREQ_IE_PREQ_ID(x) le32_to_cpu(*((u32 *) (x + 3)))
+#define PREQ_IE_PREQ_ID(x) le32_to_cpu(*((__le32 *) (x + 3)))
 #define PREQ_IE_ORIG_ADDR(x) (x + 7)
-#define PREQ_IE_ORIG_DSN(x) le32_to_cpu(*((u32 *) (x + 13)))
-#define PREQ_IE_LIFETIME(x) le32_to_cpu(*((u32 *) \
+#define PREQ_IE_ORIG_DSN(x) le32_to_cpu(*((__le32 *) (x + 13)))
+#define PREQ_IE_LIFETIME(x) le32_to_cpu(*((__le32 *) \
 			(AE_F_SET(x) ? x + 23 : x + 17)))
-#define PREQ_IE_METRIC(x) le32_to_cpu(*((u32 *) \
+#define PREQ_IE_METRIC(x) le32_to_cpu(*((__le32 *) \
 			(AE_F_SET(x) ? x + 27 : x + 21)))
 #define PREQ_IE_DST_F(x) (*(AE_F_SET(x) ? x + 32 : x + 26))
 #define PREQ_IE_DST_ADDR(x) (AE_F_SET(x) ? x + 33 : x + 27)
-#define PREQ_IE_DST_DSN(x) le32_to_cpu(*((u32 *) \
+#define PREQ_IE_DST_DSN(x) le32_to_cpu(*((__le32 *) \
 			(AE_F_SET(x) ? x + 39 : x + 33)))
 
 
@@ -47,17 +47,17 @@
 #define PREP_IE_HOPCOUNT(x) PREQ_IE_HOPCOUNT(x)
 #define PREP_IE_TTL(x) PREQ_IE_TTL(x)
 #define PREP_IE_ORIG_ADDR(x) (x + 3)
-#define PREP_IE_ORIG_DSN(x) le32_to_cpu(*((u32 *) (x + 9)))
-#define PREP_IE_LIFETIME(x) le32_to_cpu(*((u32 *) \
+#define PREP_IE_ORIG_DSN(x) le32_to_cpu(*((__le32 *) (x + 9)))
+#define PREP_IE_LIFETIME(x) le32_to_cpu(*((__le32 *) \
 			(AE_F_SET(x) ? x + 19 : x + 13)))
-#define PREP_IE_METRIC(x) le32_to_cpu(*((u32 *) \
+#define PREP_IE_METRIC(x) le32_to_cpu(*((__le32 *) \
 			(AE_F_SET(x) ? x + 23 : x + 17)))
 #define PREP_IE_DST_ADDR(x) (AE_F_SET(x) ? x + 27 : x + 21)
-#define PREP_IE_DST_DSN(x) le32_to_cpu(*((u32 *) \
+#define PREP_IE_DST_DSN(x) le32_to_cpu(*((__le32 *) \
 			(AE_F_SET(x) ? x + 33 : x + 27)))
 
 #define PERR_IE_DST_ADDR(x) (x + 2)
-#define PERR_IE_DST_DSN(x) le32_to_cpu(*((u32 *) (x + 8)))
+#define PERR_IE_DST_DSN(x) le32_to_cpu(*((__le32 *) (x + 8)))
 
 #define TU_TO_EXP_TIME(x) (jiffies + msecs_to_jiffies(x * 1024 / 1000))
 #define MSEC_TO_TU(x) (x*1000/1024)
@@ -566,8 +566,8 @@ static void hwmp_perr_frame_process(struct net_device *dev,
 			mpath->flags &= ~MESH_PATH_ACTIVE;
 			mpath->dsn = dst_dsn;
 			spin_unlock_bh(&mpath->state_lock);
-			mesh_path_error_tx(dst_addr, dst_dsn, dev->broadcast,
-					dev);
+			mesh_path_error_tx(dst_addr, __cpu_to_le32(dst_dsn),
+					   dev->broadcast, dev);
 		} else
 			spin_unlock_bh(&mpath->state_lock);
 	}
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 7f02ae8..307c90e 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -85,7 +85,8 @@ void mesh_plink_dec_estab_count(struct ieee80211_sub_if_data *sdata)
 static inline void mesh_plink_fsm_restart(struct sta_info *sta)
 {
 	sta->plink_state = LISTEN;
-	sta->llid = sta->plid = sta->reason = sta->plink_retries = 0;
+	sta->llid = sta->plid = sta->reason = 0;
+	sta->plink_retries = 0;
 }
 
 static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
@@ -373,7 +374,7 @@ void mesh_plink_block(struct sta_info *sta)
 int mesh_plink_close(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	int llid, plid, reason;
+	__le16 llid, plid, reason;
 #ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
 	DECLARE_MAC_BUF(mac);
 #endif
-- 
1.5.2.5



