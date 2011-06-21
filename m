Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41714 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab1FUJZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 05:25:00 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 26/32] ath9k: add fast_div_bias configuration for diversity group 1
Date: Tue, 21 Jun 2011 11:23:46 +0200
Message-Id: <1308648232-9906-27-git-send-email-juhosg@openwrt.org> (sfid-20110621_112543_983127_7F412E70)
In-Reply-To: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
References: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch adds the missing configuration code for diversity
group 1.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/recv.c |   83 +++++++++++++++++++++++++++++++++
 1 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 99f55b3..80bb04f 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1364,6 +1364,89 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 		default:
 			break;
 		}
+	} else if (ant_conf->div_group == 1) {
+		/* Adjust the fast_div_bias based on main and alt_lna_conf */
+		switch ((ant_conf->main_lna_conf << 4) |
+			ant_conf->alt_lna_conf) {
+		case 0x01: /* A-B LNA2 */
+			ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case 0x02: /* A-B LNA1 */
+			ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case 0x03: /* A-B A+B */
+			ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case 0x10: /* LNA2 A-B */
+			if (!(antcomb->scan) &&
+			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO))
+				ant_conf->fast_div_bias = 0x3f;
+			else
+				ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case 0x12: /* LNA2 LNA1 */
+			ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case 0x13: /* LNA2 A+B */
+			if (!(antcomb->scan) &&
+			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO))
+				ant_conf->fast_div_bias = 0x3f;
+			else
+				ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case 0x20: /* LNA1 A-B */
+			if (!(antcomb->scan) &&
+			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO))
+				ant_conf->fast_div_bias = 0x3f;
+			else
+				ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case 0x21: /* LNA1 LNA2 */
+			ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case 0x23: /* LNA1 A+B */
+			if (!(antcomb->scan) &&
+			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO))
+				ant_conf->fast_div_bias = 0x3f;
+			else
+				ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case 0x30: /* A+B A-B */
+			ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case 0x31: /* A+B LNA2 */
+			ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		case 0x32: /* A+B LNA1 */
+			ant_conf->fast_div_bias = 0x1;
+			ant_conf->main_gaintb = 0;
+			ant_conf->alt_gaintb = 0;
+			break;
+		default:
+			break;
+		}
 	} else if (ant_conf->div_group == 2) {
 		/* Adjust the fast_div_bias based on main and alt_lna_conf */
 		switch ((ant_conf->main_lna_conf << 4) |
-- 
1.7.2.1

