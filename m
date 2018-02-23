Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44764 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750910AbeBWLg2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 06:36:28 -0500
From: srirrama@codeaurora.org
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>
Subject: [PATCH] ath: fix false radar detection in JP region
Date: Fri, 23 Feb 2018 17:06:19 +0530
Message-Id: <1519385779-25816-1-git-send-email-srirrama@codeaurora.org> (sfid-20180223_123632_985258_0133CD7B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sriram R <srirrama@codeaurora.org>

This fixes false radar detection (of radar type 7)
in Japan region by correcting the radar pulse type
to Chirp as per specification.

Signed-off-by: Sriram R <srirrama@codeaurora.org>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index 4100ffd..448b83e 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -115,7 +115,7 @@ static const struct radar_detector_specs jp_radar_ref_types[] = {
 	JP_PATTERN(4, 0, 5, 150, 230, 1, 23, 50, false),
 	JP_PATTERN(5, 6, 10, 200, 500, 1, 16, 50, false),
 	JP_PATTERN(6, 11, 20, 200, 500, 1, 12, 50, false),
-	JP_PATTERN(7, 50, 100, 1000, 2000, 1, 3, 50, false),
+	JP_PATTERN(7, 50, 100, 1000, 2000, 1, 3, 50, true),
 	JP_PATTERN(5, 0, 1, 333, 333, 1, 9, 50, false),
 };
 
-- 
2.7.4
