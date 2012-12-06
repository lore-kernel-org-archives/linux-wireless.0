Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37200 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946365Ab2LFSRc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 13:17:32 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 02/13] qca-swiss-army-knife: fix ar9330_1p2_initvals.h
Date: Thu,  6 Dec 2012 19:17:16 +0100
Message-Id: <1354817847-23440-3-git-send-email-juhosg@openwrt.org> (sfid-20121206_192413_380353_BA0BB2F4)
In-Reply-To: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
References: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 'ar9331_common_rx_gain_1p2' array was a dupe
of 'ar9485_common_rx_gain_1_1'. Since commit
8a72181377fb544e675114d9b500f6bcb877f9d1 (Update
AR9485 initvals) this is no longer the case.

Because the SHA1 values of the two arrays are
different now, verify_checksum.sh complains:

  $./verify_checksums.sh
  ar5008         7340125997ffffe26a3bfc854c5b9dce74b86152 pass
  ar9001         8a4557f6a4e5ad2b01a40ca0519940ab775572aa pass
  ar9002         67813ac6decf14f5221dd3c41126f23f4d333fc4 pass
  ar9003-2p2     fdcc27a4327c6bb5e82bc7ded7387e06a2c82bb0 pass
  ar9330-1p1     e01b965b87c98d865b43e5febf37cb067644e56b pass
  ar9330-1p2     ab7e2aa014d2a9bd5cefad261999868888fc570e fail
  +1d9e632b3fdcb2db52f95dd75ff2eac31fcac0d6	ar9331_common_rx_gain_1p2
  ar9485         bbe34977a5de7a913333149ff322e767b53ec9e3 pass
  ar9580-1p0     cbdf2a5efad22be6694b586f8bd9c6605697cb9f pass
  $

Use the INI_PRINT macro for the 'ar9331_common_rx_gain_1p2'
array and refresh the 'ar9330_1p2_initvals.h' header.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/ar9330_1p2_initvals.h |  132 +++++++++++++++++++++++++++++++++-
 tools/initvals/initvals.c            |    3 +-
 2 files changed, 132 insertions(+), 3 deletions(-)

diff --git a/tools/initvals/ar9330_1p2_initvals.h b/tools/initvals/ar9330_1p2_initvals.h
index 57ed8a1..1c31f61 100644
--- a/tools/initvals/ar9330_1p2_initvals.h
+++ b/tools/initvals/ar9330_1p2_initvals.h
@@ -237,6 +237,136 @@ static const u32 ar9331_1p2_radio_core[][2] = {
 
 #define ar9331_common_wo_xlna_rx_gain_1p2 ar9331_common_wo_xlna_rx_gain_1p1
 
-#define ar9331_common_rx_gain_1p2 ar9485_common_rx_gain_1_1
+static const u32 ar9331_common_rx_gain_1p2[][2] = {
+	/* Addr      allmodes  */
+	{0x0000a000, 0x00010000},
+	{0x0000a004, 0x00030002},
+	{0x0000a008, 0x00050004},
+	{0x0000a00c, 0x00810080},
+	{0x0000a010, 0x01800082},
+	{0x0000a014, 0x01820181},
+	{0x0000a018, 0x01840183},
+	{0x0000a01c, 0x01880185},
+	{0x0000a020, 0x018a0189},
+	{0x0000a024, 0x02850284},
+	{0x0000a028, 0x02890288},
+	{0x0000a02c, 0x03850384},
+	{0x0000a030, 0x03890388},
+	{0x0000a034, 0x038b038a},
+	{0x0000a038, 0x038d038c},
+	{0x0000a03c, 0x03910390},
+	{0x0000a040, 0x03930392},
+	{0x0000a044, 0x03950394},
+	{0x0000a048, 0x00000396},
+	{0x0000a04c, 0x00000000},
+	{0x0000a050, 0x00000000},
+	{0x0000a054, 0x00000000},
+	{0x0000a058, 0x00000000},
+	{0x0000a05c, 0x00000000},
+	{0x0000a060, 0x00000000},
+	{0x0000a064, 0x00000000},
+	{0x0000a068, 0x00000000},
+	{0x0000a06c, 0x00000000},
+	{0x0000a070, 0x00000000},
+	{0x0000a074, 0x00000000},
+	{0x0000a078, 0x00000000},
+	{0x0000a07c, 0x00000000},
+	{0x0000a080, 0x28282828},
+	{0x0000a084, 0x28282828},
+	{0x0000a088, 0x28282828},
+	{0x0000a08c, 0x28282828},
+	{0x0000a090, 0x28282828},
+	{0x0000a094, 0x21212128},
+	{0x0000a098, 0x171c1c1c},
+	{0x0000a09c, 0x02020212},
+	{0x0000a0a0, 0x00000202},
+	{0x0000a0a4, 0x00000000},
+	{0x0000a0a8, 0x00000000},
+	{0x0000a0ac, 0x00000000},
+	{0x0000a0b0, 0x00000000},
+	{0x0000a0b4, 0x00000000},
+	{0x0000a0b8, 0x00000000},
+	{0x0000a0bc, 0x00000000},
+	{0x0000a0c0, 0x001f0000},
+	{0x0000a0c4, 0x111f1100},
+	{0x0000a0c8, 0x111d111e},
+	{0x0000a0cc, 0x111b111c},
+	{0x0000a0d0, 0x22032204},
+	{0x0000a0d4, 0x22012202},
+	{0x0000a0d8, 0x221f2200},
+	{0x0000a0dc, 0x221d221e},
+	{0x0000a0e0, 0x33013302},
+	{0x0000a0e4, 0x331f3300},
+	{0x0000a0e8, 0x4402331e},
+	{0x0000a0ec, 0x44004401},
+	{0x0000a0f0, 0x441e441f},
+	{0x0000a0f4, 0x55015502},
+	{0x0000a0f8, 0x551f5500},
+	{0x0000a0fc, 0x6602551e},
+	{0x0000a100, 0x66006601},
+	{0x0000a104, 0x661e661f},
+	{0x0000a108, 0x7703661d},
+	{0x0000a10c, 0x77017702},
+	{0x0000a110, 0x00007700},
+	{0x0000a114, 0x00000000},
+	{0x0000a118, 0x00000000},
+	{0x0000a11c, 0x00000000},
+	{0x0000a120, 0x00000000},
+	{0x0000a124, 0x00000000},
+	{0x0000a128, 0x00000000},
+	{0x0000a12c, 0x00000000},
+	{0x0000a130, 0x00000000},
+	{0x0000a134, 0x00000000},
+	{0x0000a138, 0x00000000},
+	{0x0000a13c, 0x00000000},
+	{0x0000a140, 0x001f0000},
+	{0x0000a144, 0x111f1100},
+	{0x0000a148, 0x111d111e},
+	{0x0000a14c, 0x111b111c},
+	{0x0000a150, 0x22032204},
+	{0x0000a154, 0x22012202},
+	{0x0000a158, 0x221f2200},
+	{0x0000a15c, 0x221d221e},
+	{0x0000a160, 0x33013302},
+	{0x0000a164, 0x331f3300},
+	{0x0000a168, 0x4402331e},
+	{0x0000a16c, 0x44004401},
+	{0x0000a170, 0x441e441f},
+	{0x0000a174, 0x55015502},
+	{0x0000a178, 0x551f5500},
+	{0x0000a17c, 0x6602551e},
+	{0x0000a180, 0x66006601},
+	{0x0000a184, 0x661e661f},
+	{0x0000a188, 0x7703661d},
+	{0x0000a18c, 0x77017702},
+	{0x0000a190, 0x00007700},
+	{0x0000a194, 0x00000000},
+	{0x0000a198, 0x00000000},
+	{0x0000a19c, 0x00000000},
+	{0x0000a1a0, 0x00000000},
+	{0x0000a1a4, 0x00000000},
+	{0x0000a1a8, 0x00000000},
+	{0x0000a1ac, 0x00000000},
+	{0x0000a1b0, 0x00000000},
+	{0x0000a1b4, 0x00000000},
+	{0x0000a1b8, 0x00000000},
+	{0x0000a1bc, 0x00000000},
+	{0x0000a1c0, 0x00000000},
+	{0x0000a1c4, 0x00000000},
+	{0x0000a1c8, 0x00000000},
+	{0x0000a1cc, 0x00000000},
+	{0x0000a1d0, 0x00000000},
+	{0x0000a1d4, 0x00000000},
+	{0x0000a1d8, 0x00000000},
+	{0x0000a1dc, 0x00000000},
+	{0x0000a1e0, 0x00000000},
+	{0x0000a1e4, 0x00000000},
+	{0x0000a1e8, 0x00000000},
+	{0x0000a1ec, 0x00000000},
+	{0x0000a1f0, 0x00000396},
+	{0x0000a1f4, 0x00000396},
+	{0x0000a1f8, 0x00000396},
+	{0x0000a1fc, 0x00000296},
+};
 
 #endif /* INITVALS_9330_1P2_H */
diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 9f4e22b..5dd54f3 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -654,8 +654,7 @@ static void ar9330_1p2_hw_print_initvals(bool check)
 	INI_PRINT_DUP(ar9331_common_wo_xlna_rx_gain_1p2,
 		      ar9331_common_wo_xlna_rx_gain_1p1);
 
-	INI_PRINT_DUP(ar9331_common_rx_gain_1p2,
-		      ar9485_common_rx_gain_1_1);
+	INI_PRINT(ar9331_common_rx_gain_1p2);
 }
 
 static void ar9340_hw_print_initvals(bool check)
-- 
1.7.10

