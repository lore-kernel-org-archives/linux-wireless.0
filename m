Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:53428 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab3JNJGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 05:06:19 -0400
Received: by mail-ea0-f181.google.com with SMTP id d10so3263631eaj.12
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 02:06:18 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 1/4] ath9k: dfs kill ath9k specyfic code
Date: Mon, 14 Oct 2013 11:06:03 +0200
Message-Id: <1381741566-2330-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131014_110623_011443_6CBF38A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kill of using ath9k_hw_common() function
in dfs detector code.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 .../net/wireless/ath/ath9k/dfs_pattern_detector.c  |   13 ++++++-------
 .../net/wireless/ath/ath9k/dfs_pattern_detector.h  |    8 +++++---
 drivers/net/wireless/ath/ath9k/init.c              |    4 ++--
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
index 491305c..c839a78 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
@@ -19,7 +19,7 @@
 
 #include "dfs_pattern_detector.h"
 #include "dfs_pri_detector.h"
-#include "ath9k.h"
+#include "../ath.h"
 
 /*
  * tolerated deviation of radar time stamp in usecs on both sides
@@ -143,7 +143,6 @@ channel_detector_create(struct dfs_pattern_detector *dpd, u16 freq)
 {
 	u32 sz, i;
 	struct channel_detector *cd;
-	struct ath_common *common = ath9k_hw_common(dpd->ah);
 
 	cd = kmalloc(sizeof(*cd), GFP_ATOMIC);
 	if (cd == NULL)
@@ -167,7 +166,7 @@ channel_detector_create(struct dfs_pattern_detector *dpd, u16 freq)
 	return cd;
 
 fail:
-	ath_dbg(common, DFS,
+	ath_dbg(dpd->common, DFS,
 		"failed to allocate channel_detector for freq=%d\n", freq);
 	channel_detector_exit(dpd, cd);
 	return NULL;
@@ -242,7 +241,7 @@ dpd_add_pulse(struct dfs_pattern_detector *dpd, struct pulse_event *event)
 		struct pri_detector *pd = cd->detectors[i];
 		struct pri_sequence *ps = pd->add_pulse(pd, event);
 		if (ps != NULL) {
-			ath_dbg(ath9k_hw_common(dpd->ah), DFS,
+			ath_dbg(dpd->common, DFS,
 				"DFS: radar found on freq=%d: id=%d, pri=%d, "
 				"count=%d, count_false=%d\n",
 				event->freq, pd->rs->type_id,
@@ -288,10 +287,10 @@ static struct dfs_pattern_detector default_dpd = {
 };
 
 struct dfs_pattern_detector *
-dfs_pattern_detector_init(struct ath_hw *ah, enum nl80211_dfs_regions region)
+dfs_pattern_detector_init(struct ath_common *common,
+			  enum nl80211_dfs_regions region)
 {
 	struct dfs_pattern_detector *dpd;
-	struct ath_common *common = ath9k_hw_common(ah);
 
 	dpd = kmalloc(sizeof(*dpd), GFP_KERNEL);
 	if (dpd == NULL)
@@ -300,7 +299,7 @@ dfs_pattern_detector_init(struct ath_hw *ah, enum nl80211_dfs_regions region)
 	*dpd = default_dpd;
 	INIT_LIST_HEAD(&dpd->channel_detectors);
 
-	dpd->ah = ah;
+	dpd->common = common;
 	if (dpd->set_dfs_domain(dpd, region))
 		return dpd;
 
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
index 90a5abc..b09946f 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
+++ b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
@@ -81,7 +81,7 @@ struct dfs_pattern_detector {
 	u8 num_radar_types;
 	u64 last_pulse_ts;
 	/* needed for ath_dbg() */
-	struct ath_hw *ah;
+	struct ath_common *common;
 
 	const struct radar_detector_specs *radar_spec;
 	struct list_head channel_detectors;
@@ -94,10 +94,12 @@ struct dfs_pattern_detector {
  */
 #if defined(CONFIG_ATH9K_DFS_CERTIFIED)
 extern struct dfs_pattern_detector *
-dfs_pattern_detector_init(struct ath_hw *ah, enum nl80211_dfs_regions region);
+dfs_pattern_detector_init(struct ath_common *common,
+			  enum nl80211_dfs_regions region);
 #else
 static inline struct dfs_pattern_detector *
-dfs_pattern_detector_init(struct ath_hw *ah, enum nl80211_dfs_regions region)
+dfs_pattern_detector_init(struct ath_common *common,
+			  enum nl80211_dfs_regions region)
 {
 	return NULL;
 }
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index e3d11c4..42758ce 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -647,7 +647,8 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	sc->sc_ah = ah;
 	pCap = &ah->caps;
 
-	sc->dfs_detector = dfs_pattern_detector_init(ah, NL80211_DFS_UNSET);
+	common = ath9k_hw_common(ah);
+	sc->dfs_detector = dfs_pattern_detector_init(common, NL80211_DFS_UNSET);
 
 	if (!pdata) {
 		ah->ah_flags |= AH_USE_EEPROM;
@@ -661,7 +662,6 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 		ah->external_reset = pdata->external_reset;
 	}
 
-	common = ath9k_hw_common(ah);
 	common->ops = &ah->reg_ops;
 	common->bus_ops = bus_ops;
 	common->ah = ah;
-- 
1.7.9.5

