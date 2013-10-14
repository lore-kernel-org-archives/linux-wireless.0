Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:57274 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab3JNJGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 05:06:21 -0400
Received: by mail-ea0-f177.google.com with SMTP id f15so3142844eak.8
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 02:06:20 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 3/4] ath9k: dfs use CFG80211_CERTIFICATION_ONUS flag
Date: Mon, 14 Oct 2013 11:06:05 +0200
Message-Id: <1381741566-2330-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131014_110626_153445_CA02EB10)
In-Reply-To: <1381741566-2330-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1381741566-2330-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use CFG80211_CERTIFICATION_ONUS flag in the DFS
detector code. This is required as a preparation
for moving DFS detector code from ath9k to ath
module.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 .../net/wireless/ath/ath9k/dfs_pattern_detector.c  |    3 +++
 .../net/wireless/ath/ath9k/dfs_pattern_detector.h  |   10 ----------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
index b0dcd1b..c230ffc 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
@@ -299,6 +299,9 @@ dfs_pattern_detector_init(struct ath_common *common,
 {
 	struct dfs_pattern_detector *dpd;
 
+	if (!config_enabled(CONFIG_CFG80211_CERTIFICATION_ONUS))
+		return NULL;
+
 	dpd = kmalloc(sizeof(*dpd), GFP_KERNEL);
 	if (dpd == NULL)
 		return NULL;
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
index 9c75297..dde2652 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
+++ b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
@@ -106,17 +106,7 @@ struct dfs_pattern_detector {
  * @param region: DFS domain to be used, can be NL80211_DFS_UNSET at creation
  * @return instance pointer on success, NULL otherwise
  */
-#if defined(CONFIG_ATH9K_DFS_CERTIFIED)
 extern struct dfs_pattern_detector *
 dfs_pattern_detector_init(struct ath_common *common,
 			  enum nl80211_dfs_regions region);
-#else
-static inline struct dfs_pattern_detector *
-dfs_pattern_detector_init(struct ath_common *common,
-			  enum nl80211_dfs_regions region)
-{
-	return NULL;
-}
-#endif /* CONFIG_ATH9K_DFS_CERTIFIED */
-
 #endif /* DFS_PATTERN_DETECTOR_H */
-- 
1.7.9.5

