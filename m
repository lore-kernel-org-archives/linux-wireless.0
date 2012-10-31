Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:54750 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965467Ab2JaLXJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 07:23:09 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath9k: [DFS] add pulse width tolerance for ETSI
Date: Wed, 31 Oct 2012 12:23:01 +0100
Message-Id: <1351682581-30683-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20121031_122354_107130_4F3C2F5C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add 5% width tolerance for radar patterns defined by ETSI.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 .../net/wireless/ath/ath9k/dfs_pattern_detector.c  |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
index 3b12914..24877b0 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
@@ -42,10 +42,15 @@ struct radar_types {
 #define MIN_PPB_THRESH	50
 #define PPB_THRESH(PPB) ((PPB * MIN_PPB_THRESH + 50) / 100)
 #define PRF2PRI(PRF) ((1000000 + PRF / 2) / PRF)
+/* percentage of pulse width tolerance */
+#define WIDTH_TOLERANCE 5
+#define WIDTH_LOWER(X) ((X*(100-WIDTH_TOLERANCE)+50)/100)
+#define WIDTH_UPPER(X) ((X*(100+WIDTH_TOLERANCE)+50)/100)
 
 #define ETSI_PATTERN(ID, WMIN, WMAX, PMIN, PMAX, PRF, PPB)	\
 {								\
-	ID, WMIN, WMAX, (PRF2PRI(PMAX) - PRI_TOLERANCE),	\
+	ID, WIDTH_LOWER(WMIN), WIDTH_UPPER(WMAX),		\
+	(PRF2PRI(PMAX) - PRI_TOLERANCE),			\
 	(PRF2PRI(PMIN) * PRF + PRI_TOLERANCE), PRF, PPB * PRF,	\
 	PPB_THRESH(PPB), PRI_TOLERANCE,				\
 }
-- 
1.7.4.1

