Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:54738 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965333Ab2JaLWo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 07:22:44 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath9k: fix memory leak in DFS pattern detector
Date: Wed, 31 Oct 2012 12:22:34 +0100
Message-Id: <1351682554-30645-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20121031_122458_706956_43067E97)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Free instance of pattern detector if requested DFS domain is
not supported.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 .../net/wireless/ath/ath9k/dfs_pattern_detector.c  |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
index f66da35d..3b12914 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
@@ -295,6 +295,7 @@ dfs_pattern_detector_init(enum nl80211_dfs_regions region)
 		return dpd;
 
 	pr_err("Could not set DFS domain to %d. ", region);
+	kfree(dpd);
 	return NULL;
 }
 EXPORT_SYMBOL(dfs_pattern_detector_init);
-- 
1.7.4.1

