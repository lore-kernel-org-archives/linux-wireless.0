Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:47376 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270Ab2LQWRt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2012 17:17:49 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: qca-linux-team@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/2] qca-swiss-army-knife: print ar9280PciePhy_awow array
Date: Mon, 17 Dec 2012 23:17:41 +0100
Message-Id: <1355782661-19059-2-git-send-email-juhosg@openwrt.org> (sfid-20121217_231754_785641_4C6CE68B)
In-Reply-To: <1355782661-19059-1-git-send-email-juhosg@openwrt.org>
References: <1355782661-19059-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This array has been introduced by commit
3b604b6cf811ba14e4c2bb3005e29bb2fba77af0
(ath9k_hw: INI changes for WoW for AR9002
chipsets) in linux, but it is not printed
from initvals.

Add it, and update ar9002_initvals.h and
checksums.txt.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/ar9002_initvals.h |   14 ++++++++++++++
 tools/initvals/checksums.txt     |    1 +
 tools/initvals/initvals.c        |    3 ++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/initvals/ar9002_initvals.h b/tools/initvals/ar9002_initvals.h
index 3adae42..c7c456a 100644
--- a/tools/initvals/ar9002_initvals.h
+++ b/tools/initvals/ar9002_initvals.h
@@ -926,6 +926,20 @@ static const u32 ar9280PciePhy_clkreq_always_on_L1_9280[][2] = {
 	{0x00004044, 0x00000000},
 };
 
+static const u32 ar9280PciePhy_awow[][2] = {
+	/* Addr      allmodes  */
+	{0x00004040, 0x9248fd00},
+	{0x00004040, 0x24924924},
+	{0x00004040, 0xa8000019},
+	{0x00004040, 0x13160820},
+	{0x00004040, 0xe5980560},
+	{0x00004040, 0xc01dcffd},
+	{0x00004040, 0x1aaabe41},
+	{0x00004040, 0xbe105554},
+	{0x00004040, 0x00043007},
+	{0x00004044, 0x00000000},
+};
+
 static const u32 ar9285Modes_9285_1_2[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160},
diff --git a/tools/initvals/checksums.txt b/tools/initvals/checksums.txt
index 41e346f..e28e338 100644
--- a/tools/initvals/checksums.txt
+++ b/tools/initvals/checksums.txt
@@ -42,6 +42,7 @@ aa88585259661a6a85cd78ca2c86cee13286d124        ar9280Common_9280_2
 67dab1c3ca3ebe1bb4997f0e076bded4496b5b0c        ar9280Modes_original_tx_gain_9280_2
 706b82bcdcf19a094a02eed21ed64dbd1f3a85b0        ar9280PciePhy_clkreq_off_L1_9280
 a6621033d7308f8c85f3bfcd84265c261cfe1ea1        ar9280PciePhy_clkreq_always_on_L1_9280
+a6621033d7308f8c85f3bfcd84265c261cfe1ea1        ar9280PciePhy_awow
 a6621033d7308f8c85f3bfcd84265c261cfe1ea1        ar9285PciePhy_clkreq_always_on_L1_9285
 706b82bcdcf19a094a02eed21ed64dbd1f3a85b0        ar9285PciePhy_clkreq_off_L1_9285
 f668583c3777247a8fc7e316555270a94852ddb1        ar9285Modes_9285_1_2
diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 5461ad7..9b23b8e 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -126,7 +126,7 @@ struct initval_family {
 #define ar9280Modes_mixed_power_tx_gain_merlin2			ar9280Modes_mixed_power_tx_gain_9280_2
 #define ar9280PciePhy_clkreq_off_L1_merlin			ar9280PciePhy_clkreq_off_L1_9280
 #define ar9280PciePhy_clkreq_always_on_L1_merlin		ar9280PciePhy_clkreq_always_on_L1_9280
-#define ar9280PciePhy_AWOW_merlin				ar9280PciePhy_AWOW_9280
+#define ar9280PciePhy_AWOW_merlin				ar9280PciePhy_awow
 
 #include "ar9280_merlin2.ini"
 
@@ -651,6 +651,7 @@ static void ar9002_hw_print_initvals(bool check)
 	INI_PRINT(ar9280Modes_original_tx_gain_9280_2);
 	INI_PRINT(ar9280PciePhy_clkreq_off_L1_9280);
 	INI_PRINT(ar9280PciePhy_clkreq_always_on_L1_9280);
+	INI_PRINT(ar9280PciePhy_awow);
 
 	INI_PRINT_DUP2(ar9285PciePhy_clkreq_always_on_L1_9285,
 		      ar9280PciePhy_clkreq_always_on_L1_9280);
-- 
1.7.10

