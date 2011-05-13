Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:31010 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759070Ab1EMPBc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 11:01:32 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 08:01:03 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<Jouni.Malinen@Atheros.com>, <Vasanth.Thiagarajan@Atheros.com>,
	<Kent.Chuang@Atheros.com>, <Ming-Yi.Lin@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	Gabriel Tseng <Gabriel.Tseng@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: [PATCH 8/9] ath9k: configure fast_div_bias based on diversity group
Date: Fri, 13 May 2011 20:31:23 +0530
Message-ID: <1305298883-3581-1-git-send-email-mshajakhan@atheros.com> (sfid-20110513_170136_447241_42E8D006)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

configure fast diversity bias based on the antenna diversity group and
based on main/alt LNA configurations. also configure main antenna and
alternate antenna to gain-table 0 for diversity group 2(AR9485)

Cc: Gabriel Tseng <Gabriel.Tseng@Atheros.com>
Cc: Senthilkumar Balasubramanian <Senthilkumar.Balasubramanian@Atheros.com>
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |  174 +++++++++++++++++++++++++--------
 1 files changed, 131 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 47e0fc1..2fecfcb 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1317,49 +1317,138 @@ static void ath_select_ant_div_from_quick_scan(struct ath_ant_comb *antcomb,
 	}
 }
 
-static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf)
+static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
+		struct ath_ant_comb *antcomb, int alt_ratio)
 {
-	/* Adjust the fast_div_bias based on main and alt lna conf */
-	switch ((ant_conf->main_lna_conf << 4) | ant_conf->alt_lna_conf) {
-	case (0x01): /* A-B LNA2 */
-		ant_conf->fast_div_bias = 0x3b;
-		break;
-	case (0x02): /* A-B LNA1 */
-		ant_conf->fast_div_bias = 0x3d;
-		break;
-	case (0x03): /* A-B A+B */
-		ant_conf->fast_div_bias = 0x1;
-		break;
-	case (0x10): /* LNA2 A-B */
-		ant_conf->fast_div_bias = 0x7;
-		break;
-	case (0x12): /* LNA2 LNA1 */
-		ant_conf->fast_div_bias = 0x2;
-		break;
-	case (0x13): /* LNA2 A+B */
-		ant_conf->fast_div_bias = 0x7;
-		break;
-	case (0x20): /* LNA1 A-B */
-		ant_conf->fast_div_bias = 0x6;
-		break;
-	case (0x21): /* LNA1 LNA2 */
-		ant_conf->fast_div_bias = 0x0;
-		break;
-	case (0x23): /* LNA1 A+B */
-		ant_conf->fast_div_bias = 0x6;
-		break;
-	case (0x30): /* A+B A-B */
-		ant_conf->fast_div_bias = 0x1;
-		break;
-	case (0x31): /* A+B LNA2 */
-		ant_conf->fast_div_bias = 0x3b;
-		break;
-	case (0x32): /* A+B LNA1 */
-		ant_conf->fast_div_bias = 0x3d;
-		break;
-	default:
-		break;
+	if (ant_conf->div_group == 0) {
+		/* Adjust the fast_div_bias based on main and alt lna conf */
+		switch ((ant_conf->main_lna_conf << 4) |
+				ant_conf->alt_lna_conf) {
+		case (0x01): /* A-B LNA2 */
+			ant_conf->fast_div_bias = 0x3b;
+			break;
+		case (0x02): /* A-B LNA1 */
+			ant_conf->fast_div_bias = 0x3d;
+			break;
+		case (0x03): /* A-B A+B */
+			ant_conf->fast_div_bias = 0x1;
+			break;
+		case (0x10): /* LNA2 A-B */
+			ant_conf->fast_div_bias = 0x7;
+			break;
+		case (0x12): /* LNA2 LNA1 */
+			ant_conf->fast_div_bias = 0x2;
+			break;
+		case (0x13): /* LNA2 A+B */
+			ant_conf->fast_div_bias = 0x7;
+			break;
+		case (0x20): /* LNA1 A-B */
+			ant_conf->fast_div_bias = 0x6;
+			break;
+		case (0x21): /* LNA1 LNA2 */
+			ant_conf->fast_div_bias = 0x0;
+			break;
+		case (0x23): /* LNA1 A+B */
+			ant_conf->fast_div_bias = 0x6;
+			break;
+		case (0x30): /* A+B A-B */
+			ant_conf->fast_div_bias = 0x1;
+			break;
+		case (0x31): /* A+B LNA2 */
+			ant_conf->fast_div_bias = 0x3b;
+			break;
+		case (0x32): /* A+B LNA1 */
+			ant_conf->fast_div_bias = 0x3d;
+			break;
+		default:
+			break;
+		}
+	} else if (ant_conf->div_group == 2) {
+		/* Adjust the fast_div_bias based on main and alt_lna_conf */
+		switch ((ant_conf->main_lna_conf << 4) |
+				ant_conf->alt_lna_conf) {
+		case (0x01): /* A-B LNA2 */
+			ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case (0x02): /* A-B LNA1 */
+			ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case (0x03): /* A-B A+B */
+			ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case (0x10): /* LNA2 A-B */
+			if (!(antcomb->scan) &&
+				(alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO))
+				ant_conf->fast_div_bias = 0x1;
+			else
+				ant_conf->fast_div_bias = 0x2;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case (0x12): /* LNA2 LNA1 */
+			ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case (0x13): /* LNA2 A+B */
+			if (!(antcomb->scan) &&
+				(alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO))
+				ant_conf->fast_div_bias = 0x1;
+			else
+				ant_conf->fast_div_bias = 0x2;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case (0x20): /* LNA1 A-B */
+			if (!(antcomb->scan) &&
+				(alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO))
+				ant_conf->fast_div_bias = 0x1;
+			else
+				ant_conf->fast_div_bias = 0x2;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case (0x21): /* LNA1 LNA2 */
+			ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case (0x23): /* LNA1 A+B */
+			if (!(antcomb->scan) &&
+				(alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO))
+				ant_conf->fast_div_bias = 0x1;
+			else
+				ant_conf->fast_div_bias = 0x2;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case (0x30): /* A+B A-B */
+			ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case (0x31): /* A+B LNA2 */
+			ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case (0x32): /* A+B LNA1 */
+			ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		default:
+			break;
+		}
+
 	}
+
 }
 
 /* Antenna diversity and combining */
@@ -1585,8 +1674,7 @@ static void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 	antcomb->quick_scan_cnt++;
 
 div_comb_done:
-	ath_ant_div_conf_fast_divbias(&div_ant_conf);
-
+	ath_ant_div_conf_fast_divbias(&div_ant_conf, antcomb, alt_ratio);
 	ath9k_hw_antdiv_comb_conf_set(sc->sc_ah, &div_ant_conf);
 
 	antcomb->scan_start_time = jiffies;
-- 
1.7.0.4

