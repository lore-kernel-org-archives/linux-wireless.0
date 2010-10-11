Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50176 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab0JKSma (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 14:42:30 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] ath5k:  Support wiphy_renamed operation.
Date: Mon, 11 Oct 2010 11:42:17 -0700
Message-Id: <1286822537-28756-2-git-send-email-greearb@candelatech.com>
In-Reply-To: <1286822537-28756-1-git-send-email-greearb@candelatech.com>
References: <1286822537-28756-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This allows the debugfs phy directory to remain up to
date if someone renames the phy.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 c9732a6... dc73615... M	drivers/net/wireless/ath/ath5k/base.c
:100644 100644 a342a9d... e361d16... M	drivers/net/wireless/ath/ath5k/debug.c
:100644 100644 4f078b1... 3de6f62... M	drivers/net/wireless/ath/ath5k/debug.h
 drivers/net/wireless/ath/ath5k/base.c  |    7 +++++++
 drivers/net/wireless/ath/ath5k/debug.c |    9 +++++++++
 drivers/net/wireless/ath/ath5k/debug.h |    7 +++++++
 3 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index c9732a6..dc73615 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -3359,6 +3359,12 @@ static void ath5k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 	mutex_unlock(&sc->lock);
 }
 
+static int ath5k_wiphy_renamed(struct ieee80211_hw *hw, const char* newname)
+{
+	struct ath5k_softc *sc = hw->priv;
+	return ath5k_debug_wiphy_renamed(sc, newname);
+}
+
 static int ath5k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			 const struct ieee80211_tx_queue_params *params)
 {
@@ -3417,6 +3423,7 @@ static const struct ieee80211_ops ath5k_hw_ops = {
 	.sw_scan_start	= ath5k_sw_scan_start,
 	.sw_scan_complete = ath5k_sw_scan_complete,
 	.set_coverage_class = ath5k_set_coverage_class,
+	.wiphy_renamed = ath5k_wiphy_renamed,
 };
 
 /********************\
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index a342a9d..e361d16 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -897,6 +897,15 @@ ath5k_debug_init(void)
 	ath5k_global_debugfs = debugfs_create_dir("ath5k", NULL);
 }
 
+int
+ath5k_debug_wiphy_renamed(struct ath5k_softc *sc, const char *newname)
+{
+	if (!debugfs_rename(ath5k_global_debugfs, sc->debug.debugfs_phydir,
+			    ath5k_global_debugfs, newname))
+		return EINVAL;
+	return 0;
+}
+
 void
 ath5k_debug_init_device(struct ath5k_softc *sc)
 {
diff --git a/drivers/net/wireless/ath/ath5k/debug.h b/drivers/net/wireless/ath/ath5k/debug.h
index 4f078b1..3de6f62 100644
--- a/drivers/net/wireless/ath/ath5k/debug.h
+++ b/drivers/net/wireless/ath/ath5k/debug.h
@@ -162,6 +162,9 @@ ath5k_debug_dump_skb(struct ath5k_softc *sc,
 void
 ath5k_debug_printtxbuf(struct ath5k_softc *sc, struct ath5k_buf *bf);
 
+int
+ath5k_debug_wiphy_renamed(struct ath5k_softc *sc, const char *newname);
+
 #else /* no debugging */
 
 #include <linux/compiler.h>
@@ -198,6 +201,10 @@ ath5k_debug_dump_skb(struct ath5k_softc *sc,
 static inline void
 ath5k_debug_printtxbuf(struct ath5k_softc *sc, struct ath5k_buf *bf) {}
 
+static inline int
+ath5k_debug_wiphy_renamed(struct ath5k_softc *sc,
+			  const char *newname) { return 0; }
+
 #endif /* ifdef CONFIG_ATH5K_DEBUG */
 
 #endif /* ifndef _ATH5K_DEBUG_H */
-- 
1.7.2.2

