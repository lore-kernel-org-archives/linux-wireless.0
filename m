Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:51149 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab1LSVZp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 16:25:45 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 13/15] initvals: use private chksum variables in INI_PRINT* macros
Date: Mon, 19 Dec 2011 22:24:58 +0100
Message-Id: <1324329900-3923-14-git-send-email-juhosg@openwrt.org> (sfid-20111219_222550_545092_87CBB24C)
In-Reply-To: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
References: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows to simplify *hw_print_initvals functions a bit.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 initvals.c |   18 ++----------------
 1 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/initvals.c b/initvals.c
index 9c149ef..ed7152c 100644
--- a/initvals.c
+++ b/initvals.c
@@ -254,6 +254,7 @@ typedef long long unsigned int u64;
 
 #define INI_PRINT(_array) do { \
 	if (check) { \
+		u64 chksum; \
 		chksum = ath9k_hw_check_initval((const u32 *) &_array,\
 						ARRAY_SIZE(_array), ARRAY_SIZE((_array)[0])); \
 		printf("0x%016llx        "#_array"\n", chksum); \
@@ -266,6 +267,7 @@ typedef long long unsigned int u64;
 
 #define INI_PRINT_ONEDIM(_array) do { \
 	if (check) { \
+		u64 chksum; \
 		chksum = ath9k_hw_check_initval((const u32 *) &_array,\
 						ARRAY_SIZE(_array), 1); \
 		printf("0x%016llx        "#_array"\n", chksum); \
@@ -389,8 +391,6 @@ static u64 ath9k_hw_check_initval(const u32 *array, u32 rows, u32 columns)
 
 static void ar5008_hw_print_initvals(bool check)
 {
-	u64 chksum;
-
 	INI_PRINT(ar5416Modes);
 	INI_PRINT(ar5416Common);
 	INI_PRINT(ar5416Bank0);
@@ -406,8 +406,6 @@ static void ar5008_hw_print_initvals(bool check)
 
 static void ar9001_hw_print_initvals(bool check)
 {
-	u64 chksum;
-
 	INI_PRINT(ar5416Modes_9100);
 	INI_PRINT(ar5416Common_9100);
 	INI_PRINT(ar5416Bank0_9100);
@@ -435,8 +433,6 @@ static void ar9001_hw_print_initvals(bool check)
 
 static void ar9002_hw_print_initvals(bool check)
 {
-	u64 chksum;
-
 	INI_PRINT(ar9280Modes_9280_2);
 	INI_PRINT(ar9280Common_9280_2);
 	INI_PRINT(ar9280Modes_fast_clock_9280_2);
@@ -477,8 +473,6 @@ static void ar9002_hw_print_initvals(bool check)
 
 static void ar9003_2p2_hw_print_initvals(bool check)
 {
-	u64 chksum;
-
 	INI_PRINT(ar9300_2p2_radio_postamble);
 	INI_PRINT(ar9300Modes_lowest_ob_db_tx_gain_table_2p2);
 	INI_PRINT(ar9300Modes_fast_clock_2p2);
@@ -503,8 +497,6 @@ static void ar9003_2p2_hw_print_initvals(bool check)
 
 static void ar9330_1p1_hw_print_initvals(bool check)
 {
-	u64 chksum;
-
 	INI_PRINT(ar9331_1p1_baseband_postamble);
 	INI_PRINT(ar9331_modes_lowest_ob_db_tx_gain_1p1);
 	INI_PRINT(ar9331_modes_high_ob_db_tx_gain_1p1);
@@ -528,8 +520,6 @@ static void ar9330_1p1_hw_print_initvals(bool check)
 
 static void ar9330_1p2_hw_print_initvals(bool check)
 {
-	u64 chksum;
-
 	INI_PRINT(ar9331_modes_lowest_ob_db_tx_gain_1p2);
 	INI_PRINT(ar9331_1p2_baseband_postamble);
 	INI_PRINT(ar9331_modes_high_ob_db_tx_gain_1p2);
@@ -550,8 +540,6 @@ static void ar9330_1p2_hw_print_initvals(bool check)
 
 static void ar9485_hw_print_initvals(bool check)
 {
-	u64 chksum;
-
 	INI_PRINT(ar9485Common_1_0);
 	INI_PRINT(ar9485_1_0_mac_postamble);
 	INI_PRINT(ar9485_1_0_pcie_phy_pll_on_clkreq_disable_L1);
@@ -576,8 +564,6 @@ static void ar9485_hw_print_initvals(bool check)
 
 static void ar9580_1p0_hw_print_initvals(bool check)
 {
-	u64 chksum;
-
 	INI_PRINT(ar9580_1p0_modes_fast_clock);
 	INI_PRINT(ar9580_1p0_radio_postamble);
 	INI_PRINT(ar9580_1p0_baseband_core);
-- 
1.7.2.1

