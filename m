Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:54707 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964984Ab2JaLWR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 07:22:17 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath9k: resolve name collision in DFS detector
Date: Wed, 31 Oct 2012 12:21:56 +0100
Message-Id: <1351682516-30608-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20121031_122517_799980_89BE9DCE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

set_domain() is already defined in /arch/arm/asm/domain.h

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 .../net/wireless/ath/ath9k/dfs_pattern_detector.c  |    4 ++--
 .../net/wireless/ath/ath9k/dfs_pattern_detector.h  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
index ea2a6cf..f66da35d 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
@@ -274,7 +274,7 @@ static bool dpd_set_domain(struct dfs_pattern_detector *dpd,
 
 static struct dfs_pattern_detector default_dpd = {
 	.exit		= dpd_exit,
-	.set_domain	= dpd_set_domain,
+	.set_dfs_domain	= dpd_set_domain,
 	.add_pulse	= dpd_add_pulse,
 	.region		= NL80211_DFS_UNSET,
 };
@@ -291,7 +291,7 @@ dfs_pattern_detector_init(enum nl80211_dfs_regions region)
 	*dpd = default_dpd;
 	INIT_LIST_HEAD(&dpd->channel_detectors);
 
-	if (dpd->set_domain(dpd, region))
+	if (dpd->set_dfs_domain(dpd, region))
 		return dpd;
 
 	pr_err("Could not set DFS domain to %d. ", region);
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
index fd0328a..cda52f3 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
+++ b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
@@ -62,7 +62,7 @@ struct radar_detector_specs {
 /**
  * struct dfs_pattern_detector - DFS pattern detector
  * @exit(): destructor
- * @set_domain(): set DFS domain, resets detector lines upon domain changes
+ * @set_dfs_domain(): set DFS domain, resets detector lines upon domain changes
  * @add_pulse(): add radar pulse to detector, returns true on detection
  * @region: active DFS region, NL80211_DFS_UNSET until set
  * @num_radar_types: number of different radar types
@@ -72,7 +72,7 @@ struct radar_detector_specs {
  */
 struct dfs_pattern_detector {
 	void (*exit)(struct dfs_pattern_detector *dpd);
-	bool (*set_domain)(struct dfs_pattern_detector *dpd,
+	bool (*set_dfs_domain)(struct dfs_pattern_detector *dpd,
 			   enum nl80211_dfs_regions region);
 	bool (*add_pulse)(struct dfs_pattern_detector *dpd,
 			  struct pulse_event *pe);
-- 
1.7.4.1

