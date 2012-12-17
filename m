Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:57396 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab2LQO7a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2012 09:59:30 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: qca-linux-team@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] qca-swiss-army-knife: fix build errors if ATH9K_DIR is used
Date: Mon, 17 Dec 2012 15:59:03 +0100
Message-Id: <1355756343-3406-1-git-send-email-juhosg@openwrt.org> (sfid-20121217_155934_878309_A224CC50)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some initval arrays were removed from ath9k with the
upstream commit 14fec8d9baffc026beaffa2ee9e911df9d1d4ad2
(ath9k_hw: remove duplicate initvals).

Due to the missing symbols, this causes build errors
when the ATHEROS Makefile variable is not set, and
an external ATH9K_DIR is specified:

  $ make clean all ATH9K_DIR=/devel/wireless-testing/drivers/net/wireless/ath/ath9k
  rm -f initvals
  gcc  -I"/devel/wireless-testing/drivers/net/wireless/ath/ath9k" -o initvals initvals.c sha1.c
  initvals.c: In function ‘ar9001_hw_print_initvals’:
  initvals.c:588:2: error: ‘ar5416Bank0_9100’ undeclared (first use in this function)
  initvals.c:588:2: note: each undeclared identifier is reported only once for each function it appears in
  initvals.c:589:2: error: ‘ar5416BB_RfGain_9100’ undeclared (first use in this function)
  initvals.c:590:2: error: ‘ar5416Bank1_9100’ undeclared (first use in this function)
  initvals.c:591:2: error: ‘ar5416Bank2_9100’ undeclared (first use in this function)
  initvals.c:592:2: error: ‘ar5416Bank3_9100’ undeclared (first use in this function)
  initvals.c:595:2: error: ‘ar5416Bank7_9100’ undeclared (first use in this function)
  initvals.c:599:2: error: ‘ar5416Bank0_9160’ undeclared (first use in this function)
  initvals.c:600:2: error: ‘ar5416BB_RfGain_9160’ undeclared (first use in this function)
  initvals.c:601:2: error: ‘ar5416Bank1_9160’ undeclared (first use in this function)
  initvals.c:602:2: error: ‘ar5416Bank2_9160’ undeclared (first use in this function)
  initvals.c:603:2: error: ‘ar5416Bank3_9160’ undeclared (first use in this function)
  initvals.c:604:2: error: ‘ar5416Bank6_9160’ undeclared (first use in this function)
  initvals.c:605:2: error: ‘ar5416Bank6TPC_9160’ undeclared (first use in this function)
  initvals.c:606:2: error: ‘ar5416Bank7_9160’ undeclared (first use in this function)
  initvals.c: In function ‘ar9002_hw_print_initvals’:
  initvals.c:597:2: error: ‘ar9285PciePhy_clkreq_always_on_L1_9285’ undeclared (first use in this function)
  initvals.c:598:2: error: ‘ar9285PciePhy_clkreq_off_L1_9285’ undeclared (first use in this function)
  initvals.c:605:2: error: ‘ar9285PciePhy_clkreq_always_on_L1_9285_1_2’ undeclared (first use in this function)
  initvals.c:606:2: error: ‘ar9285PciePhy_clkreq_off_L1_9285_1_2’ undeclared (first use in this function)
  initvals.c:613:2: error: ‘ar9287PciePhy_clkreq_always_on_L1_9287_1_1’ undeclared (first use in this function)
  initvals.c:614:2: error: ‘ar9287PciePhy_clkreq_off_L1_9287_1_1’ undeclared (first use in this function)
  initvals.c:617:2: error: ‘ar9271Common_normal_cck_fir_coeff_9271’ undeclared (first use in this function)
  initvals.c:618:2: error: ‘ar9271Common_japan_2484_cck_fir_coeff_9271’ undeclared (first use in this function)
  initvals.c:619:2: error: ‘ar9271Modes_9271_1_0_only’ undeclared (first use in this function)
  make: *** [initvals] Error 1
  $

Add definitions for the missing arrays to avoid
these compiler errors. Also introduce two new
macros and use those for printing the arrays.

After these changes, the initvals tool builds without
errors:

  $ make clean all ATH9K_DIR=/devel/wireless-testing/drivers/net/wireless/ath/ath9k
  rm -f initvals
  gcc  -I"/devel/wireless-testing/drivers/net/wireless/ath/ath9k" -o initvals initvals.c sha1.c
  $

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/ar9001_initvals.h |  270 --------------------------------------
 tools/initvals/ar9002_initvals.h |   90 -------------
 tools/initvals/checksums.txt     |    1 -
 tools/initvals/initvals.c        |  111 ++++++++++++----
 4 files changed, 89 insertions(+), 383 deletions(-)

diff --git a/tools/initvals/ar9001_initvals.h b/tools/initvals/ar9001_initvals.h
index 6043ea0..d432bed 100644
--- a/tools/initvals/ar9001_initvals.h
+++ b/tools/initvals/ar9001_initvals.h
@@ -460,97 +460,6 @@ static const u32 ar5416Common_9100[][2] = {
 	{0x0000a3e0, 0x000001ce},
 };
 
-static const u32 ar5416Bank0_9100[][2] = {
-	/* Addr      allmodes  */
-	{0x000098b0, 0x1e5795e5},
-	{0x000098e0, 0x02008020},
-};
-
-static const u32 ar5416BB_RfGain_9100[][3] = {
-	/* Addr      5G          2G        */
-	{0x00009a00, 0x00000000, 0x00000000},
-	{0x00009a04, 0x00000040, 0x00000040},
-	{0x00009a08, 0x00000080, 0x00000080},
-	{0x00009a0c, 0x000001a1, 0x00000141},
-	{0x00009a10, 0x000001e1, 0x00000181},
-	{0x00009a14, 0x00000021, 0x000001c1},
-	{0x00009a18, 0x00000061, 0x00000001},
-	{0x00009a1c, 0x00000168, 0x00000041},
-	{0x00009a20, 0x000001a8, 0x000001a8},
-	{0x00009a24, 0x000001e8, 0x000001e8},
-	{0x00009a28, 0x00000028, 0x00000028},
-	{0x00009a2c, 0x00000068, 0x00000068},
-	{0x00009a30, 0x00000189, 0x000000a8},
-	{0x00009a34, 0x000001c9, 0x00000169},
-	{0x00009a38, 0x00000009, 0x000001a9},
-	{0x00009a3c, 0x00000049, 0x000001e9},
-	{0x00009a40, 0x00000089, 0x00000029},
-	{0x00009a44, 0x00000170, 0x00000069},
-	{0x00009a48, 0x000001b0, 0x00000190},
-	{0x00009a4c, 0x000001f0, 0x000001d0},
-	{0x00009a50, 0x00000030, 0x00000010},
-	{0x00009a54, 0x00000070, 0x00000050},
-	{0x00009a58, 0x00000191, 0x00000090},
-	{0x00009a5c, 0x000001d1, 0x00000151},
-	{0x00009a60, 0x00000011, 0x00000191},
-	{0x00009a64, 0x00000051, 0x000001d1},
-	{0x00009a68, 0x00000091, 0x00000011},
-	{0x00009a6c, 0x000001b8, 0x00000051},
-	{0x00009a70, 0x000001f8, 0x00000198},
-	{0x00009a74, 0x00000038, 0x000001d8},
-	{0x00009a78, 0x00000078, 0x00000018},
-	{0x00009a7c, 0x00000199, 0x00000058},
-	{0x00009a80, 0x000001d9, 0x00000098},
-	{0x00009a84, 0x00000019, 0x00000159},
-	{0x00009a88, 0x00000059, 0x00000199},
-	{0x00009a8c, 0x00000099, 0x000001d9},
-	{0x00009a90, 0x000000d9, 0x00000019},
-	{0x00009a94, 0x000000f9, 0x00000059},
-	{0x00009a98, 0x000000f9, 0x00000099},
-	{0x00009a9c, 0x000000f9, 0x000000d9},
-	{0x00009aa0, 0x000000f9, 0x000000f9},
-	{0x00009aa4, 0x000000f9, 0x000000f9},
-	{0x00009aa8, 0x000000f9, 0x000000f9},
-	{0x00009aac, 0x000000f9, 0x000000f9},
-	{0x00009ab0, 0x000000f9, 0x000000f9},
-	{0x00009ab4, 0x000000f9, 0x000000f9},
-	{0x00009ab8, 0x000000f9, 0x000000f9},
-	{0x00009abc, 0x000000f9, 0x000000f9},
-	{0x00009ac0, 0x000000f9, 0x000000f9},
-	{0x00009ac4, 0x000000f9, 0x000000f9},
-	{0x00009ac8, 0x000000f9, 0x000000f9},
-	{0x00009acc, 0x000000f9, 0x000000f9},
-	{0x00009ad0, 0x000000f9, 0x000000f9},
-	{0x00009ad4, 0x000000f9, 0x000000f9},
-	{0x00009ad8, 0x000000f9, 0x000000f9},
-	{0x00009adc, 0x000000f9, 0x000000f9},
-	{0x00009ae0, 0x000000f9, 0x000000f9},
-	{0x00009ae4, 0x000000f9, 0x000000f9},
-	{0x00009ae8, 0x000000f9, 0x000000f9},
-	{0x00009aec, 0x000000f9, 0x000000f9},
-	{0x00009af0, 0x000000f9, 0x000000f9},
-	{0x00009af4, 0x000000f9, 0x000000f9},
-	{0x00009af8, 0x000000f9, 0x000000f9},
-	{0x00009afc, 0x000000f9, 0x000000f9},
-};
-
-static const u32 ar5416Bank1_9100[][2] = {
-	/* Addr      allmodes  */
-	{0x000098b0, 0x02108421},
-	{0x000098ec, 0x00000008},
-};
-
-static const u32 ar5416Bank2_9100[][2] = {
-	/* Addr      allmodes  */
-	{0x000098b0, 0x0e73ff17},
-	{0x000098e0, 0x00000420},
-};
-
-static const u32 ar5416Bank3_9100[][3] = {
-	/* Addr      5G          2G        */
-	{0x000098f0, 0x01400018, 0x01c00018},
-};
-
 static const u32 ar5416Bank6_9100[][3] = {
 	/* Addr      5G          2G        */
 	{0x0000989c, 0x00000000, 0x00000000},
@@ -625,13 +534,6 @@ static const u32 ar5416Bank6TPC_9100[][3] = {
 	{0x000098d0, 0x0000000f, 0x0010000f},
 };
 
-static const u32 ar5416Bank7_9100[][2] = {
-	/* Addr      allmodes  */
-	{0x0000989c, 0x00000500},
-	{0x0000989c, 0x00000800},
-	{0x000098cc, 0x0000000e},
-};
-
 static const u32 ar5416Addac_9100[][2] = {
 	/* Addr      allmodes  */
 	{0x0000989c, 0x00000000},
@@ -1114,178 +1016,6 @@ static const u32 ar5416Common_9160[][2] = {
 	{0x0000a3e0, 0x000001ce},
 };
 
-static const u32 ar5416Bank0_9160[][2] = {
-	/* Addr      allmodes  */
-	{0x000098b0, 0x1e5795e5},
-	{0x000098e0, 0x02008020},
-};
-
-static const u32 ar5416BB_RfGain_9160[][3] = {
-	/* Addr      5G          2G        */
-	{0x00009a00, 0x00000000, 0x00000000},
-	{0x00009a04, 0x00000040, 0x00000040},
-	{0x00009a08, 0x00000080, 0x00000080},
-	{0x00009a0c, 0x000001a1, 0x00000141},
-	{0x00009a10, 0x000001e1, 0x00000181},
-	{0x00009a14, 0x00000021, 0x000001c1},
-	{0x00009a18, 0x00000061, 0x00000001},
-	{0x00009a1c, 0x00000168, 0x00000041},
-	{0x00009a20, 0x000001a8, 0x000001a8},
-	{0x00009a24, 0x000001e8, 0x000001e8},
-	{0x00009a28, 0x00000028, 0x00000028},
-	{0x00009a2c, 0x00000068, 0x00000068},
-	{0x00009a30, 0x00000189, 0x000000a8},
-	{0x00009a34, 0x000001c9, 0x00000169},
-	{0x00009a38, 0x00000009, 0x000001a9},
-	{0x00009a3c, 0x00000049, 0x000001e9},
-	{0x00009a40, 0x00000089, 0x00000029},
-	{0x00009a44, 0x00000170, 0x00000069},
-	{0x00009a48, 0x000001b0, 0x00000190},
-	{0x00009a4c, 0x000001f0, 0x000001d0},
-	{0x00009a50, 0x00000030, 0x00000010},
-	{0x00009a54, 0x00000070, 0x00000050},
-	{0x00009a58, 0x00000191, 0x00000090},
-	{0x00009a5c, 0x000001d1, 0x00000151},
-	{0x00009a60, 0x00000011, 0x00000191},
-	{0x00009a64, 0x00000051, 0x000001d1},
-	{0x00009a68, 0x00000091, 0x00000011},
-	{0x00009a6c, 0x000001b8, 0x00000051},
-	{0x00009a70, 0x000001f8, 0x00000198},
-	{0x00009a74, 0x00000038, 0x000001d8},
-	{0x00009a78, 0x00000078, 0x00000018},
-	{0x00009a7c, 0x00000199, 0x00000058},
-	{0x00009a80, 0x000001d9, 0x00000098},
-	{0x00009a84, 0x00000019, 0x00000159},
-	{0x00009a88, 0x00000059, 0x00000199},
-	{0x00009a8c, 0x00000099, 0x000001d9},
-	{0x00009a90, 0x000000d9, 0x00000019},
-	{0x00009a94, 0x000000f9, 0x00000059},
-	{0x00009a98, 0x000000f9, 0x00000099},
-	{0x00009a9c, 0x000000f9, 0x000000d9},
-	{0x00009aa0, 0x000000f9, 0x000000f9},
-	{0x00009aa4, 0x000000f9, 0x000000f9},
-	{0x00009aa8, 0x000000f9, 0x000000f9},
-	{0x00009aac, 0x000000f9, 0x000000f9},
-	{0x00009ab0, 0x000000f9, 0x000000f9},
-	{0x00009ab4, 0x000000f9, 0x000000f9},
-	{0x00009ab8, 0x000000f9, 0x000000f9},
-	{0x00009abc, 0x000000f9, 0x000000f9},
-	{0x00009ac0, 0x000000f9, 0x000000f9},
-	{0x00009ac4, 0x000000f9, 0x000000f9},
-	{0x00009ac8, 0x000000f9, 0x000000f9},
-	{0x00009acc, 0x000000f9, 0x000000f9},
-	{0x00009ad0, 0x000000f9, 0x000000f9},
-	{0x00009ad4, 0x000000f9, 0x000000f9},
-	{0x00009ad8, 0x000000f9, 0x000000f9},
-	{0x00009adc, 0x000000f9, 0x000000f9},
-	{0x00009ae0, 0x000000f9, 0x000000f9},
-	{0x00009ae4, 0x000000f9, 0x000000f9},
-	{0x00009ae8, 0x000000f9, 0x000000f9},
-	{0x00009aec, 0x000000f9, 0x000000f9},
-	{0x00009af0, 0x000000f9, 0x000000f9},
-	{0x00009af4, 0x000000f9, 0x000000f9},
-	{0x00009af8, 0x000000f9, 0x000000f9},
-	{0x00009afc, 0x000000f9, 0x000000f9},
-};
-
-static const u32 ar5416Bank1_9160[][2] = {
-	/* Addr      allmodes  */
-	{0x000098b0, 0x02108421},
-	{0x000098ec, 0x00000008},
-};
-
-static const u32 ar5416Bank2_9160[][2] = {
-	/* Addr      allmodes  */
-	{0x000098b0, 0x0e73ff17},
-	{0x000098e0, 0x00000420},
-};
-
-static const u32 ar5416Bank3_9160[][3] = {
-	/* Addr      5G          2G        */
-	{0x000098f0, 0x01400018, 0x01c00018},
-};
-
-static const u32 ar5416Bank6_9160[][3] = {
-	/* Addr      5G          2G        */
-	{0x0000989c, 0x00000000, 0x00000000},
-	{0x0000989c, 0x00000000, 0x00000000},
-	{0x0000989c, 0x00000000, 0x00000000},
-	{0x0000989c, 0x00e00000, 0x00e00000},
-	{0x0000989c, 0x005e0000, 0x005e0000},
-	{0x0000989c, 0x00120000, 0x00120000},
-	{0x0000989c, 0x00620000, 0x00620000},
-	{0x0000989c, 0x00020000, 0x00020000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x40ff0000, 0x40ff0000},
-	{0x0000989c, 0x005f0000, 0x005f0000},
-	{0x0000989c, 0x00870000, 0x00870000},
-	{0x0000989c, 0x00f90000, 0x00f90000},
-	{0x0000989c, 0x007b0000, 0x007b0000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x00f50000, 0x00f50000},
-	{0x0000989c, 0x00dc0000, 0x00dc0000},
-	{0x0000989c, 0x00110000, 0x00110000},
-	{0x0000989c, 0x006100a8, 0x006100a8},
-	{0x0000989c, 0x004210a2, 0x004210a2},
-	{0x0000989c, 0x0014008f, 0x0014008f},
-	{0x0000989c, 0x00c40003, 0x00c40003},
-	{0x0000989c, 0x003000f2, 0x003000f2},
-	{0x0000989c, 0x00440016, 0x00440016},
-	{0x0000989c, 0x00410040, 0x00410040},
-	{0x0000989c, 0x0001805e, 0x0001805e},
-	{0x0000989c, 0x0000c0ab, 0x0000c0ab},
-	{0x0000989c, 0x000000f1, 0x000000f1},
-	{0x0000989c, 0x00002081, 0x00002081},
-	{0x0000989c, 0x000000d4, 0x000000d4},
-	{0x000098d0, 0x0000000f, 0x0010000f},
-};
-
-static const u32 ar5416Bank6TPC_9160[][3] = {
-	/* Addr      5G          2G        */
-	{0x0000989c, 0x00000000, 0x00000000},
-	{0x0000989c, 0x00000000, 0x00000000},
-	{0x0000989c, 0x00000000, 0x00000000},
-	{0x0000989c, 0x00e00000, 0x00e00000},
-	{0x0000989c, 0x005e0000, 0x005e0000},
-	{0x0000989c, 0x00120000, 0x00120000},
-	{0x0000989c, 0x00620000, 0x00620000},
-	{0x0000989c, 0x00020000, 0x00020000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x40ff0000, 0x40ff0000},
-	{0x0000989c, 0x005f0000, 0x005f0000},
-	{0x0000989c, 0x00870000, 0x00870000},
-	{0x0000989c, 0x00f90000, 0x00f90000},
-	{0x0000989c, 0x007b0000, 0x007b0000},
-	{0x0000989c, 0x00ff0000, 0x00ff0000},
-	{0x0000989c, 0x00f50000, 0x00f50000},
-	{0x0000989c, 0x00dc0000, 0x00dc0000},
-	{0x0000989c, 0x00110000, 0x00110000},
-	{0x0000989c, 0x006100a8, 0x006100a8},
-	{0x0000989c, 0x00423022, 0x00423022},
-	{0x0000989c, 0x2014008f, 0x2014008f},
-	{0x0000989c, 0x00c40002, 0x00c40002},
-	{0x0000989c, 0x003000f2, 0x003000f2},
-	{0x0000989c, 0x00440016, 0x00440016},
-	{0x0000989c, 0x00410040, 0x00410040},
-	{0x0000989c, 0x0001805e, 0x0001805e},
-	{0x0000989c, 0x0000c0ab, 0x0000c0ab},
-	{0x0000989c, 0x000000e1, 0x000000e1},
-	{0x0000989c, 0x00007080, 0x00007080},
-	{0x0000989c, 0x000000d4, 0x000000d4},
-	{0x000098d0, 0x0000000f, 0x0010000f},
-};
-
-static const u32 ar5416Bank7_9160[][2] = {
-	/* Addr      allmodes  */
-	{0x0000989c, 0x00000500},
-	{0x0000989c, 0x00000800},
-	{0x000098cc, 0x0000000e},
-};
-
 static const u32 ar5416Addac_9160[][2] = {
 	/* Addr      allmodes  */
 	{0x0000989c, 0x00000000},
diff --git a/tools/initvals/ar9002_initvals.h b/tools/initvals/ar9002_initvals.h
index d042182..7577055 100644
--- a/tools/initvals/ar9002_initvals.h
+++ b/tools/initvals/ar9002_initvals.h
@@ -926,20 +926,6 @@ static const u32 ar9280PciePhy_clkreq_always_on_L1_9280[][2] = {
 	{0x00004044, 0x00000000},
 };
 
-static const u32 ar9285PciePhy_clkreq_always_on_L1_9285[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x9248fd00},
-	{0x00004040, 0x24924924},
-	{0x00004040, 0xa8000019},
-	{0x00004040, 0x13160820},
-	{0x00004040, 0xe5980560},
-	{0x00004040, 0xc01dcffd},
-	{0x00004040, 0x1aaabe41},
-	{0x00004040, 0xbe105554},
-	{0x00004040, 0x00043007},
-	{0x00004044, 0x00000000},
-};
-
 static const u32 ar9285PciePhy_clkreq_off_L1_9285[][2] = {
 	/* Addr      allmodes  */
 	{0x00004040, 0x9248fd00},
@@ -1744,34 +1730,6 @@ static const u32 ar9285Modes_XE2_0_high_power[][5] = {
 	{0x0000a3e0, 0x000000e7, 0x000000e7, 0x000000e7, 0x000000e7},
 };
 
-static const u32 ar9285PciePhy_clkreq_always_on_L1_9285_1_2[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x9248fd00},
-	{0x00004040, 0x24924924},
-	{0x00004040, 0xa8000019},
-	{0x00004040, 0x13160820},
-	{0x00004040, 0xe5980560},
-	{0x00004040, 0xc01dcffd},
-	{0x00004040, 0x1aaabe41},
-	{0x00004040, 0xbe105554},
-	{0x00004040, 0x00043007},
-	{0x00004044, 0x00000000},
-};
-
-static const u32 ar9285PciePhy_clkreq_off_L1_9285_1_2[][2] = {
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
 static const u32 ar9287Modes_9287_1_1[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00001030, 0x00000000, 0x00000000, 0x000002c0, 0x00000160},
@@ -2513,34 +2471,6 @@ static const u32 ar9287Modes_rx_gain_9287_1_1[][5] = {
 	{0x0000a848, 0x00000000, 0x00000000, 0x00001067, 0x00001067},
 };
 
-static const u32 ar9287PciePhy_clkreq_always_on_L1_9287_1_1[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x9248fd00},
-	{0x00004040, 0x24924924},
-	{0x00004040, 0xa8000019},
-	{0x00004040, 0x13160820},
-	{0x00004040, 0xe5980560},
-	{0x00004040, 0xc01dcffd},
-	{0x00004040, 0x1aaabe41},
-	{0x00004040, 0xbe105554},
-	{0x00004040, 0x00043007},
-	{0x00004044, 0x00000000},
-};
-
-static const u32 ar9287PciePhy_clkreq_off_L1_9287_1_1[][2] = {
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
 static const u32 ar9271Modes_9271[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160},
@@ -3177,26 +3107,6 @@ static const u32 ar9271Common_9271[][2] = {
 	{0x0000d384, 0xf3307ff0},
 };
 
-static const u32 ar9271Common_normal_cck_fir_coeff_9271[][2] = {
-	/* Addr      allmodes  */
-	{0x0000a1f4, 0x00fffeff},
-	{0x0000a1f8, 0x00f5f9ff},
-	{0x0000a1fc, 0xb79f6427},
-};
-
-static const u32 ar9271Common_japan_2484_cck_fir_coeff_9271[][2] = {
-	/* Addr      allmodes  */
-	{0x0000a1f4, 0x00000000},
-	{0x0000a1f8, 0xefff0301},
-	{0x0000a1fc, 0xca9228ee},
-};
-
-static const u32 ar9271Modes_9271_1_0_only[][5] = {
-	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
-	{0x00009910, 0x30002311, 0x30002311, 0x30002311, 0x30002311},
-	{0x00009828, 0x0a020001, 0x0a020001, 0x0a020001, 0x0a020001},
-};
-
 static const u32 ar9271Modes_9271_ANI_reg[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00009850, 0x6d4000e2, 0x6d4000e2, 0x6d4000e2, 0x6d4000e2},
diff --git a/tools/initvals/checksums.txt b/tools/initvals/checksums.txt
index 837b0c8..41e346f 100644
--- a/tools/initvals/checksums.txt
+++ b/tools/initvals/checksums.txt
@@ -64,7 +64,6 @@ a6621033d7308f8c85f3bfcd84265c261cfe1ea1        ar9287PciePhy_clkreq_always_on_L
 4292a3fb0293fcd2a9d6db033b50361fb1613148        ar9271Common_9271
 bfa4da915beb8a2650d19c0ccf2ba30c407519eb        ar9271Common_normal_cck_fir_coeff_9271
 b715dc83abe8a90ca744bbc1eb9fd2a6ecc40dc9        ar9271Common_japan_2484_cck_fir_coeff_9271
-57af6387b013c34ac73e9c9001022199b1d8f077        ar9271Modes_9271_1_0_only
 10ebfd6df26b16aa336f11396a199eb73bd2ac10        ar9271Modes_9271_ANI_reg
 40dbcfce66c76461f359ec35c0800b26ea3ff7d2        ar9271Modes_normal_power_tx_gain_9271
 761c58af0d657e7029068f65e6ea85231322babe        ar9271Modes_high_power_tx_gain_9271
diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 066b06d..c74b9c2 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -29,7 +29,34 @@ struct initval_family {
 
 #include <ar5008_initvals.h>
 #include <ar9001_initvals.h>
+
+#define ar5416Bank0_9100					ar5416Bank0
+#define ar5416Bank1_9100					ar5416Bank1
+#define ar5416Bank2_9100					ar5416Bank2
+#define ar5416Bank3_9100					ar5416Bank3
+#define ar5416Bank7_9100					ar5416Bank7
+#define ar5416BB_RfGain_9100					ar5416BB_RfGain
+
+#define ar5416Bank0_9160					ar5416Bank0
+#define ar5416Bank1_9160					ar5416Bank1
+#define ar5416Bank2_9160					ar5416Bank2
+#define ar5416Bank3_9160					ar5416Bank3
+#define ar5416Bank6_9160					ar5416Bank6
+#define ar5416Bank6TPC_9160					ar5416Bank6TPC_9100
+#define ar5416Bank7_9160					ar5416Bank7
+#define ar5416BB_RfGain_9160					ar5416BB_RfGain
+
 #include <ar9002_initvals.h>
+
+#define ar9285PciePhy_clkreq_always_on_L1_9285			ar9280PciePhy_clkreq_always_on_L1_9280
+#define ar9285PciePhy_clkreq_off_L1_9285			ar9280PciePhy_clkreq_off_L1_9280
+#define ar9285PciePhy_clkreq_always_on_L1_9285_1_2		ar9280PciePhy_clkreq_always_on_L1_9280
+#define ar9285PciePhy_clkreq_off_L1_9285_1_2			ar9280PciePhy_clkreq_off_L1_9280
+#define ar9287PciePhy_clkreq_always_on_L1_9287_1_1		ar9280PciePhy_clkreq_always_on_L1_9280
+#define ar9287PciePhy_clkreq_off_L1_9287_1_1			ar9280PciePhy_clkreq_off_L1_9280
+#define ar9271Common_normal_cck_fir_coeff_9271			ar9287Common_normal_cck_fir_coeff_9287_1_1
+#define ar9271Common_japan_2484_cck_fir_coeff_9271		ar9287Common_japan_2484_cck_fir_coeff_9287_1_1
+
 #include <ar9003_2p2_initvals.h>
 #include <ar9330_1p1_initvals.h>
 #include <ar9330_1p2_initvals.h>
@@ -374,6 +401,36 @@ struct initval_family {
 	} \
     } while (0)
 
+/*
+ * For some duplicated initval arrays, ath9k directly
+ * uses the reference array instead of adding a define.
+ * Show a warning message if the given array is not a
+ * dupe of the referenced one.
+ */
+#define INI_PRINT_DUP2(_array, _ref) do { \
+	if (check) { \
+		char *sha1sum; \
+		sha1sum = ath9k_hw_check_initval(#_array, \
+						(const u32 *) &_array,\
+						ARRAY_SIZE(_array), \
+						ARRAY_SIZE((_array)[0])); \
+		printf("%s        "#_array"\n", sha1sum); \
+	} else { \
+		if (sizeof(_ref) != sizeof(_array) || \
+		    memcmp(&_ref, &_array, sizeof(_ref))) { \
+			printf("#warning " #_array " is not a dupe of " #_ref "\n\n"); \
+			break; \
+		} \
+	} \
+    } while (0)
+
+/*
+ * Some initval arrays are inlined in the ath9k
+ * sources. Keep the symbol, but don't do anything
+ * with the array,
+ */
+#define INI_PRINT_INLINE(_array) do { } while (0)
+
 #define INI_PRINT(_array) do { \
 	if (check) { \
 		char *sha1sum; \
@@ -559,25 +616,25 @@ static void ar9001_hw_print_initvals(bool check)
 {
 	INI_PRINT(ar5416Modes_9100);
 	INI_PRINT(ar5416Common_9100);
-	INI_PRINT(ar5416Bank0_9100);
-	INI_PRINT(ar5416BB_RfGain_9100);
-	INI_PRINT(ar5416Bank1_9100);
-	INI_PRINT(ar5416Bank2_9100);
-	INI_PRINT(ar5416Bank3_9100);
+	INI_PRINT_DUP2(ar5416Bank0_9100, ar5416Bank0);
+	INI_PRINT_DUP2(ar5416BB_RfGain_9100,  ar5416BB_RfGain);
+	INI_PRINT_DUP2(ar5416Bank1_9100, ar5416Bank1);
+	INI_PRINT_DUP2(ar5416Bank2_9100, ar5416Bank2);
+	INI_PRINT_DUP2(ar5416Bank3_9100, ar5416Bank3);
 	INI_PRINT(ar5416Bank6_9100);
 	INI_PRINT(ar5416Bank6TPC_9100);
-	INI_PRINT(ar5416Bank7_9100);
+	INI_PRINT_DUP2(ar5416Bank7_9100, ar5416Bank7);
 	INI_PRINT(ar5416Addac_9100);
 	INI_PRINT(ar5416Modes_9160);
 	INI_PRINT(ar5416Common_9160);
-	INI_PRINT(ar5416Bank0_9160);
-	INI_PRINT(ar5416BB_RfGain_9160);
-	INI_PRINT(ar5416Bank1_9160);
-	INI_PRINT(ar5416Bank2_9160);
-	INI_PRINT(ar5416Bank3_9160);
-	INI_PRINT(ar5416Bank6_9160);
-	INI_PRINT(ar5416Bank6TPC_9160);
-	INI_PRINT(ar5416Bank7_9160);
+	INI_PRINT_DUP2(ar5416Bank0_9160, ar5416Bank0);
+	INI_PRINT_DUP2(ar5416BB_RfGain_9160, ar5416BB_RfGain);
+	INI_PRINT_DUP2(ar5416Bank1_9160, ar5416Bank1);
+	INI_PRINT_DUP2(ar5416Bank2_9160, ar5416Bank2);
+	INI_PRINT_DUP2(ar5416Bank3_9160, ar5416Bank3);
+	INI_PRINT_DUP2(ar5416Bank6_9160, ar5416Bank6);
+	INI_PRINT_DUP2(ar5416Bank6TPC_9160, ar5416Bank6TPC_9100);
+	INI_PRINT_DUP2(ar5416Bank7_9160, ar5416Bank7);
 	INI_PRINT(ar5416Addac_9160);
 	INI_PRINT(ar5416Addac_9160_1_1);
 }
@@ -594,7 +651,9 @@ static void ar9002_hw_print_initvals(bool check)
 	INI_PRINT(ar9280Modes_original_tx_gain_9280_2);
 	INI_PRINT(ar9280PciePhy_clkreq_off_L1_9280);
 	INI_PRINT(ar9280PciePhy_clkreq_always_on_L1_9280);
-	INI_PRINT(ar9285PciePhy_clkreq_always_on_L1_9285);
+
+	INI_PRINT_DUP2(ar9285PciePhy_clkreq_always_on_L1_9285,
+		      ar9280PciePhy_clkreq_always_on_L1_9280);
 	INI_PRINT(ar9285PciePhy_clkreq_off_L1_9285);
 	INI_PRINT(ar9285Modes_9285_1_2);
 	INI_PRINT(ar9285Common_9285_1_2);
@@ -602,21 +661,29 @@ static void ar9002_hw_print_initvals(bool check)
 	INI_PRINT(ar9285Modes_original_tx_gain_9285_1_2);
 	INI_PRINT(ar9285Modes_XE2_0_normal_power);
 	INI_PRINT(ar9285Modes_XE2_0_high_power);
-	INI_PRINT(ar9285PciePhy_clkreq_always_on_L1_9285_1_2);
-	INI_PRINT(ar9285PciePhy_clkreq_off_L1_9285_1_2);
+	INI_PRINT_DUP2(ar9285PciePhy_clkreq_always_on_L1_9285_1_2,
+		      ar9280PciePhy_clkreq_always_on_L1_9280);
+	INI_PRINT_DUP2(ar9285PciePhy_clkreq_off_L1_9285_1_2,
+		      ar9280PciePhy_clkreq_off_L1_9280);
+
 	INI_PRINT(ar9287Modes_9287_1_1);
 	INI_PRINT(ar9287Common_9287_1_1);
 	INI_PRINT(ar9287Common_normal_cck_fir_coeff_9287_1_1);
 	INI_PRINT(ar9287Common_japan_2484_cck_fir_coeff_9287_1_1);
 	INI_PRINT(ar9287Modes_tx_gain_9287_1_1);
 	INI_PRINT(ar9287Modes_rx_gain_9287_1_1);
-	INI_PRINT(ar9287PciePhy_clkreq_always_on_L1_9287_1_1);
-	INI_PRINT(ar9287PciePhy_clkreq_off_L1_9287_1_1);
+	INI_PRINT_DUP2(ar9287PciePhy_clkreq_always_on_L1_9287_1_1,
+		      ar9280PciePhy_clkreq_always_on_L1_9280);
+	INI_PRINT_DUP2(ar9287PciePhy_clkreq_off_L1_9287_1_1,
+		      ar9280PciePhy_clkreq_off_L1_9280);
+
 	INI_PRINT(ar9271Modes_9271);
 	INI_PRINT(ar9271Common_9271);
-	INI_PRINT(ar9271Common_normal_cck_fir_coeff_9271);
-	INI_PRINT(ar9271Common_japan_2484_cck_fir_coeff_9271);
-	INI_PRINT(ar9271Modes_9271_1_0_only);
+	INI_PRINT_DUP2(ar9271Common_normal_cck_fir_coeff_9271,
+		      ar9287Common_normal_cck_fir_coeff_9287_1_1);
+	INI_PRINT_DUP2(ar9271Common_japan_2484_cck_fir_coeff_9271,
+		      ar9287Common_japan_2484_cck_fir_coeff_9287_1_1);
+	INI_PRINT_INLINE(ar9271Modes_9271_1_0_only);
 	INI_PRINT(ar9271Modes_9271_ANI_reg);
 	INI_PRINT(ar9271Modes_normal_power_tx_gain_9271);
 	INI_PRINT(ar9271Modes_high_power_tx_gain_9271);
-- 
1.7.10

