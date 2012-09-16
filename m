Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19753 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2IPCgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Sep 2012 22:36:37 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20565.15100.747681.965491@gargle.gargle.HOWL> (sfid-20120916_043640_355350_1C7CB61C)
Date: Sun, 16 Sep 2012 08:05:40 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/8] ath9k: Remove redundant variable assignment
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set main_gaintb and alt_gaintb once instead of zero'ing them
in every case.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/antenna.c | 51 ++------------------------------
 1 file changed, 3 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index bbcfeb3..eb61c6b 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -311,6 +311,9 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 					  struct ath_ant_comb *antcomb,
 					  int alt_ratio)
 {
+	ant_conf->main_gaintb = 0;
+	ant_conf->alt_gaintb = 0;
+
 	if (ant_conf->div_group == 0) {
 		/* Adjust the fast_div_bias based on main and alt lna conf */
 		switch ((ant_conf->main_lna_conf << 4) |
@@ -360,18 +363,12 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 			ant_conf->alt_lna_conf) {
 		case 0x01: /* A-B LNA2 */
 			ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x02: /* A-B LNA1 */
 			ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x03: /* A-B A+B */
 			ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x10: /* LNA2 A-B */
 			if (!(antcomb->scan) &&
@@ -379,13 +376,9 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 				ant_conf->fast_div_bias = 0x3f;
 			else
 				ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x12: /* LNA2 LNA1 */
 			ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x13: /* LNA2 A+B */
 			if (!(antcomb->scan) &&
@@ -393,8 +386,6 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 				ant_conf->fast_div_bias = 0x3f;
 			else
 				ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x20: /* LNA1 A-B */
 			if (!(antcomb->scan) &&
@@ -402,13 +393,9 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 				ant_conf->fast_div_bias = 0x3f;
 			else
 				ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x21: /* LNA1 LNA2 */
 			ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x23: /* LNA1 A+B */
 			if (!(antcomb->scan) &&
@@ -416,23 +403,15 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 				ant_conf->fast_div_bias = 0x3f;
 			else
 				ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x30: /* A+B A-B */
 			ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x31: /* A+B LNA2 */
 			ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x32: /* A+B LNA1 */
 			ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		default:
 			break;
@@ -443,18 +422,12 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 				ant_conf->alt_lna_conf) {
 		case 0x01: /* A-B LNA2 */
 			ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x02: /* A-B LNA1 */
 			ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x03: /* A-B A+B */
 			ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x10: /* LNA2 A-B */
 			if (!(antcomb->scan) &&
@@ -462,13 +435,9 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 				ant_conf->fast_div_bias = 0x1;
 			else
 				ant_conf->fast_div_bias = 0x2;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x12: /* LNA2 LNA1 */
 			ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x13: /* LNA2 A+B */
 			if (!(antcomb->scan) &&
@@ -476,8 +445,6 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 				ant_conf->fast_div_bias = 0x1;
 			else
 				ant_conf->fast_div_bias = 0x2;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x20: /* LNA1 A-B */
 			if (!(antcomb->scan) &&
@@ -485,13 +452,9 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 				ant_conf->fast_div_bias = 0x1;
 			else
 				ant_conf->fast_div_bias = 0x2;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x21: /* LNA1 LNA2 */
 			ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x23: /* LNA1 A+B */
 			if (!(antcomb->scan) &&
@@ -499,23 +462,15 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 				ant_conf->fast_div_bias = 0x1;
 			else
 				ant_conf->fast_div_bias = 0x2;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x30: /* A+B A-B */
 			ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x31: /* A+B LNA2 */
 			ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		case 0x32: /* A+B LNA1 */
 			ant_conf->fast_div_bias = 0x1;
-			ant_conf->main_gaintb = 0;
-			ant_conf->alt_gaintb = 0;
 			break;
 		default:
 			break;
-- 
1.7.12

