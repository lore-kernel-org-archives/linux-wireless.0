Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:47371 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627Ab2LQWRs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2012 17:17:48 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: qca-linux-team@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/2] qca-swiss-army-knife: don't print ar9285PciePhy_clkreq_off_L1_9285 array
Date: Mon, 17 Dec 2012 23:17:40 +0100
Message-Id: <1355782661-19059-1-git-send-email-juhosg@openwrt.org> (sfid-20121217_231753_060219_A46A9114)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is a dupe of 'ar9280PciePhy_clkreq_off_L1_9280', and
it is not used in ath9k. I forgot to remove it in commit
'qca-swiss-army-knife: fix build errors if ATH9K_DIR is used'

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/ar9002_initvals.h |   14 --------------
 tools/initvals/initvals.c        |    3 ++-
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/tools/initvals/ar9002_initvals.h b/tools/initvals/ar9002_initvals.h
index 7577055..3adae42 100644
--- a/tools/initvals/ar9002_initvals.h
+++ b/tools/initvals/ar9002_initvals.h
@@ -926,20 +926,6 @@ static const u32 ar9280PciePhy_clkreq_always_on_L1_9280[][2] = {
 	{0x00004044, 0x00000000},
 };
 
-static const u32 ar9285PciePhy_clkreq_off_L1_9285[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x9248fd00},
-	{0x00004040, 0x24924924},
-	{0x00004040, 0xa8000019},
-	{0x00004040, 0x13160820},
-	{0x00004040, 0xe5980560},
-	{0x00004040, 0xc01dcffc},
-	{0x00004040, 0x1aaabe41},
-	{0x00004040, 0xbe105554},
-	{0x00004040, 0x00043007},
-	{0x00004044, 0x00000000},
-};
-
 static const u32 ar9285Modes_9285_1_2[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160},
diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index c74b9c2..5461ad7 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -654,7 +654,8 @@ static void ar9002_hw_print_initvals(bool check)
 
 	INI_PRINT_DUP2(ar9285PciePhy_clkreq_always_on_L1_9285,
 		      ar9280PciePhy_clkreq_always_on_L1_9280);
-	INI_PRINT(ar9285PciePhy_clkreq_off_L1_9285);
+	INI_PRINT_DUP2(ar9285PciePhy_clkreq_off_L1_9285,
+		       ar9280PciePhy_clkreq_off_L1_9280);
 	INI_PRINT(ar9285Modes_9285_1_2);
 	INI_PRINT(ar9285Common_9285_1_2);
 	INI_PRINT(ar9285Modes_high_power_tx_gain_9285_1_2);
-- 
1.7.10

