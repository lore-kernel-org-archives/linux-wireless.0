Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14345 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab2INHpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 03:45:13 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20562.57426.927069.184092@gargle.gargle.HOWL> (sfid-20120914_094517_786691_AAD5C144)
Date: Fri, 14 Sep 2012 13:14:18 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFC 4/8] ath9k_hw: Add antenna diversity group for AR9565
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/antenna.c    | 62 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |  3 ++
 2 files changed, 65 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index eb61c6b..8eb274f 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -475,6 +475,68 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 		default:
 			break;
 		}
+	} else if (ant_conf->div_group == 3) {
+		switch ((ant_conf->main_lna_conf << 4) |
+			ant_conf->alt_lna_conf) {
+		case 0x01: /* A-B LNA2 */
+			ant_conf->fast_div_bias = 0x1;
+			break;
+		case 0x02: /* A-B LNA1 */
+			ant_conf->fast_div_bias = 0x39;
+			break;
+		case 0x03: /* A-B A+B */
+			ant_conf->fast_div_bias = 0x1;
+			break;
+		case 0x10: /* LNA2 A-B */
+			if ((antcomb->scan == 0) &&
+			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)) {
+				ant_conf->fast_div_bias = 0x3f;
+			} else {
+				ant_conf->fast_div_bias = 0x1;
+			}
+			break;
+		case 0x12: /* LNA2 LNA1 */
+			ant_conf->fast_div_bias = 0x39;
+			break;
+		case 0x13: /* LNA2 A+B */
+			if ((antcomb->scan == 0) &&
+			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)) {
+				ant_conf->fast_div_bias = 0x3f;
+			} else {
+				ant_conf->fast_div_bias = 0x1;
+			}
+			break;
+		case 0x20: /* LNA1 A-B */
+			if ((antcomb->scan == 0) &&
+			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)) {
+				ant_conf->fast_div_bias = 0x3f;
+			} else {
+				ant_conf->fast_div_bias = 0x4;
+			}
+			break;
+		case 0x21: /* LNA1 LNA2 */
+			ant_conf->fast_div_bias = 0x6;
+			break;
+		case 0x23: /* LNA1 A+B */
+			if ((antcomb->scan == 0) &&
+			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)) {
+				ant_conf->fast_div_bias = 0x3f;
+			} else {
+				ant_conf->fast_div_bias = 0x6;
+			}
+			break;
+		case 0x30: /* A+B A-B */
+			ant_conf->fast_div_bias = 0x1;
+			break;
+		case 0x31: /* A+B LNA2 */
+			ant_conf->fast_div_bias = 0x6;
+			break;
+		case 0x32: /* A+B LNA1 */
+			ant_conf->fast_div_bias = 0x1;
+			break;
+		default:
+			break;
+		}
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 0d800c6..4b503ee 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1294,6 +1294,9 @@ static void ar9003_hw_antdiv_comb_conf_get(struct ath_hw *ah,
 	} else if (AR_SREV_9485(ah)) {
 		antconf->lna1_lna2_delta = -9;
 		antconf->div_group = 2;
+	} else if (AR_SREV_9565(ah)) {
+		antconf->lna1_lna2_delta = -3;
+		antconf->div_group = 3;
 	} else {
 		antconf->lna1_lna2_delta = -3;
 		antconf->div_group = 0;
-- 
1.7.12

