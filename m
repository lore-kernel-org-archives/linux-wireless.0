Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41923 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab2F1A0m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 20:26:42 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com
Subject: [PATCH 04/11] qca-swiss-army-knife: remove chansel tables from initvals
Date: Thu, 28 Jun 2012 02:26:32 +0200
Message-Id: <1340843199-49821-4-git-send-email-nbd@openwrt.org> (sfid-20120628_022648_090911_E51FDCCE)
In-Reply-To: <1340843199-49821-3-git-send-email-nbd@openwrt.org>
References: <1340843199-49821-1-git-send-email-nbd@openwrt.org>
 <1340843199-49821-2-git-send-email-nbd@openwrt.org>
 <1340843199-49821-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unused in ath9k, replaced by dynamic calculation

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 tools/initvals/ar9330_1p1_initvals.h |   34 ----------------------------------
 tools/initvals/checksums.txt         |    2 --
 tools/initvals/initvals.c            |    4 ----
 3 files changed, 0 insertions(+), 40 deletions(-)

diff --git a/tools/initvals/ar9330_1p1_initvals.h b/tools/initvals/ar9330_1p1_initvals.h
index a1135b0..c5ac755 100644
--- a/tools/initvals/ar9330_1p1_initvals.h
+++ b/tools/initvals/ar9330_1p1_initvals.h
@@ -1111,38 +1111,4 @@ static const u32 ar9331_common_tx_gain_offset1_1[][1] = {
 	{0x00000000},
 };
 
-static const u32 ar9331_1p1_chansel_xtal_25M[] = {
-	0x0101479e,
-	0x0101d027,
-	0x010258af,
-	0x0102e138,
-	0x010369c0,
-	0x0103f249,
-	0x01047ad1,
-	0x0105035a,
-	0x01058be2,
-	0x0106146b,
-	0x01069cf3,
-	0x0107257c,
-	0x0107ae04,
-	0x0108f5b2,
-};
-
-static const u32 ar9331_1p1_chansel_xtal_40M[] = {
-	0x00a0ccbe,
-	0x00a12213,
-	0x00a17769,
-	0x00a1ccbe,
-	0x00a22213,
-	0x00a27769,
-	0x00a2ccbe,
-	0x00a32213,
-	0x00a37769,
-	0x00a3ccbe,
-	0x00a42213,
-	0x00a47769,
-	0x00a4ccbe,
-	0x00a5998b,
-};
-
 #endif /* INITVALS_9330_1P1_H */
diff --git a/tools/initvals/checksums.txt b/tools/initvals/checksums.txt
index 20d978f..0570001 100644
--- a/tools/initvals/checksums.txt
+++ b/tools/initvals/checksums.txt
@@ -105,8 +105,6 @@ d087ef736d2c833de38586e754e5c5f13d7f9e36        ar9331_1p1_xtal_40M
 b7bd4501d52be3219578b47403dc7cde8178d2f9        ar9331_1p1_mac_core
 02971c3916cfe4f9824e5a507a5c3adf69be7758        ar9331_common_rx_gain_1p1
 f13c11b888039936f5a60f568190b1df2e723c4b        ar9331_common_tx_gain_offset1_1
-4682d993fc0b89591c2ef476b55af3e27f6cdb34        ar9331_1p1_chansel_xtal_25M
-3bec9cfe03c51231af72939dcf613f8c2ce7e290        ar9331_1p1_chansel_xtal_40M
 653f09d30828a40e227a420f251a21361379887e        ar9331_modes_lowest_ob_db_tx_gain_1p2
 a424400c9b4871bd42cd7730b32a23a0ed5fc808        ar9331_1p2_baseband_postamble
 653f09d30828a40e227a420f251a21361379887e        ar9331_modes_high_ob_db_tx_gain_1p2
diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 116f090..437dfc5 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -182,8 +182,6 @@ typedef long long unsigned int u64;
 #define ar9331_hornet1_1_mac_core				ar9331_1p1_mac_core
 #define ar9331_common_rx_gain_hornet1_1				ar9331_common_rx_gain_1p1
 #define ar9331_common_tx_gain_offset1_1				ar9331_common_tx_gain_offset1_1
-#define ar9331_hornet1_1_chansel_xtal_25M			ar9331_1p1_chansel_xtal_25M
-#define ar9331_hornet1_1_chansel_xtal_40M			ar9331_1p1_chansel_xtal_40M
 
 #include "ar9330_11.ini"
 
@@ -571,8 +569,6 @@ static void ar9330_1p1_hw_print_initvals(bool check)
 	INI_PRINT(ar9331_1p1_mac_core);
 	INI_PRINT(ar9331_common_rx_gain_1p1);
 	INI_PRINT(ar9331_common_tx_gain_offset1_1);
-	INI_PRINT_ONEDIM(ar9331_1p1_chansel_xtal_25M);
-	INI_PRINT_ONEDIM(ar9331_1p1_chansel_xtal_40M);
 }
 
 static void ar9330_1p2_hw_print_initvals(bool check)
-- 
1.7.3.2

