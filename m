Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23332 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab0G0NrD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 09:47:03 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 06:47:03 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 2/4] ath9k: Add three stream rate control support for AR938X.
Date: Tue, 27 Jul 2010 19:16:32 +0530
Message-ID: <1280238394-2565-2-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1280238394-2565-1-git-send-email-senthilkumar@atheros.com>
References: <1280238394-2565-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds 3 stream rate control support for AR938X family
chipsets which supports 3 streams.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |  528 +++++++++++++++++++++--------------
 drivers/net/wireless/ath/ath9k/rc.h |   63 +++--
 2 files changed, 366 insertions(+), 225 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index f8a4c39..7b63958 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -20,95 +20,145 @@
 #include "ath9k.h"
 
 static const struct ath_rate_table ar5416_11na_ratetable = {
-	43,
+	68,
 	8, /* MCS start */
 	{
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
-			5400, 0, 12, 0, 0, 0, 0, 0 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
-			7800,  1, 18, 0, 1, 1, 1, 1 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
-			10000, 2, 24, 2, 2, 2, 2, 2 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
-			13900, 3, 36, 2, 3, 3, 3, 3 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
-			17300, 4, 48, 4, 4, 4, 4, 4 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
-			23000, 5, 72, 4, 5, 5, 5, 5 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
-			27400, 6, 96, 4, 6, 6, 6, 6 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
-			29300, 7, 108, 4, 7, 7, 7, 7 },
-		{ RC_HT_SD_2040, WLAN_RC_PHY_HT_20_SS, 6500, /* 6.5 Mb */
-			6400, 0, 0, 0, 8, 25, 8, 25 },
-		{ RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 13000, /* 13 Mb */
-			12700, 1, 1, 2, 9, 26, 9, 26 },
-		{ RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 19500, /* 19.5 Mb */
-			18800, 2, 2, 2, 10, 27, 10, 27 },
-		{ RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 26000, /* 26 Mb */
-			25000, 3, 3, 4, 11, 28, 11, 28 },
-		{ RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 39000, /* 39 Mb */
-			36700, 4, 4, 4, 12, 29, 12, 29 },
-		{ RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 52000, /* 52 Mb */
-			48100, 5, 5, 4, 13, 30, 13, 30 },
-		{ RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 58500, /* 58.5 Mb */
-			53500, 6, 6, 4, 14, 31, 14, 31 },
-		{ RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 65000, /* 65 Mb */
-			59000, 7, 7, 4, 15, 32, 15, 33 },
-		{ RC_INVALID, WLAN_RC_PHY_HT_20_DS, 13000, /* 13 Mb */
-			12700, 8, 8, 3, 16, 34, 16, 34 },
-		{ RC_INVALID, WLAN_RC_PHY_HT_20_DS, 26000, /* 26 Mb */
-			24800, 9, 9, 2, 17, 35, 17, 35 },
-		{ RC_INVALID, WLAN_RC_PHY_HT_20_DS, 39000, /* 39 Mb */
-			36600, 10, 10, 2, 18, 36, 18, 36 },
-		{ RC_HT_D_20, WLAN_RC_PHY_HT_20_DS, 52000, /* 52 Mb */
-			48100, 11, 11, 4, 19, 37, 19, 37 },
-		{ RC_HT_D_20, WLAN_RC_PHY_HT_20_DS, 78000, /* 78 Mb */
-			69500, 12, 12, 4, 20, 38, 20, 38 },
-		{ RC_HT_D_20, WLAN_RC_PHY_HT_20_DS, 104000, /* 104 Mb */
-			89500, 13, 13, 4, 21, 39, 21, 39 },
-		{ RC_HT_D_20, WLAN_RC_PHY_HT_20_DS, 117000, /* 117 Mb */
-			98900, 14, 14, 4, 22, 40, 22, 40 },
-		{ RC_HT_D_20, WLAN_RC_PHY_HT_20_DS, 130000, /* 130 Mb */
-			108300, 15, 15, 4, 23, 41, 24, 42 },
-		{ RC_HT_D_20, WLAN_RC_PHY_HT_20_DS_HGI, 144400, /* 144.4 Mb */
-			12000, 15, 15, 4, 23, 41, 24, 42 },
-		{ RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 13500, /* 13.5 Mb */
-			13200, 0, 0, 0, 8, 25, 25, 25 },
-		{ RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 27500, /* 27.0 Mb */
-			25900, 1, 1, 2, 9, 26, 26, 26 },
-		{ RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 40500, /* 40.5 Mb */
-			38600, 2, 2, 2, 10, 27, 27, 27 },
-		{ RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 54000, /* 54 Mb */
-			49800, 3, 3, 4, 11, 28, 28, 28 },
-		{ RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 81500, /* 81 Mb */
-			72200, 4, 4, 4, 12, 29, 29, 29 },
-		{ RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 108000, /* 108 Mb */
-			92900, 5, 5, 4, 13, 30, 30, 30 },
-		{ RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 121500, /* 121.5 Mb */
-			102700, 6, 6, 4, 14, 31, 31, 31 },
-		{ RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 135000, /* 135 Mb */
-			112000, 7, 7, 4, 15, 32, 33, 33 },
-		{ RC_HT_S_40, WLAN_RC_PHY_HT_40_SS_HGI, 150000, /* 150 Mb */
-			122000, 7, 7, 4, 15, 32, 33, 33 },
-		{ RC_INVALID, WLAN_RC_PHY_HT_40_DS, 27000, /* 27 Mb */
-			25800, 8, 8, 0, 16, 34, 34, 34 },
-		{ RC_INVALID, WLAN_RC_PHY_HT_40_DS, 54000, /* 54 Mb */
-			49800, 9, 9, 2, 17, 35, 35, 35 },
-		{ RC_INVALID, WLAN_RC_PHY_HT_40_DS, 81000, /* 81 Mb */
-			71900, 10, 10, 2, 18, 36, 36, 36 },
-		{ RC_HT_D_40, WLAN_RC_PHY_HT_40_DS, 108000, /* 108 Mb */
-			92500, 11, 11, 4, 19, 37, 37, 37 },
-		{ RC_HT_D_40, WLAN_RC_PHY_HT_40_DS, 162000, /* 162 Mb */
-			130300, 12, 12, 4, 20, 38, 38, 38 },
-		{ RC_HT_D_40, WLAN_RC_PHY_HT_40_DS, 216000, /* 216 Mb */
-			162800, 13, 13, 4, 21, 39, 39, 39 },
-		{ RC_HT_D_40, WLAN_RC_PHY_HT_40_DS, 243000, /* 243 Mb */
-			178200, 14, 14, 4, 22, 40, 40, 40 },
-		{ RC_HT_D_40, WLAN_RC_PHY_HT_40_DS, 270000, /* 270 Mb */
-			192100, 15, 15, 4, 23, 41, 42, 42 },
-		{ RC_HT_D_40, WLAN_RC_PHY_HT_40_DS_HGI, 300000, /* 300 Mb */
-			207000, 15, 15, 4, 23, 41, 42, 42 },
+		[0] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 6000,
+			5400, 0, 12, 0, 0, 0, 0, 0 }, /* 6 Mb */
+		[1] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 9000,
+			7800,  1, 18, 0, 1, 1, 1, 1 }, /* 9 Mb */
+		[2] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 12000,
+			10000, 2, 24, 2, 2, 2, 2, 2 }, /* 12 Mb */
+		[3] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 18000,
+			13900, 3, 36, 2, 3, 3, 3, 3 }, /* 18 Mb */
+		[4] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 24000,
+			17300, 4, 48, 4, 4, 4, 4, 4 }, /* 24 Mb */
+		[5] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 36000,
+			23000, 5, 72, 4, 5, 5, 5, 5 }, /* 36 Mb */
+		[6] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 48000,
+			27400, 6, 96, 4, 6, 6, 6, 6 }, /* 48 Mb */
+		[7] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 54000,
+			29300, 7, 108, 4, 7, 7, 7, 7 }, /* 54 Mb */
+		[8] = { RC_HT_SDT_2040, WLAN_RC_PHY_HT_20_SS, 6500,
+			6400, 0, 0, 0, 8, 38, 8, 38 }, /* 6.5 Mb */
+		[9] = { RC_HT_SDT_20, WLAN_RC_PHY_HT_20_SS, 13000,
+			12700, 1, 1, 2, 9, 39, 9, 39 }, /* 13 Mb */
+		[10] = { RC_HT_SDT_20, WLAN_RC_PHY_HT_20_SS, 19500,
+			18800, 2, 2, 2, 10, 40, 10, 40 }, /* 19.5 Mb */
+		[11] = { RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 26000,
+			25000, 3, 3, 4, 11, 41, 11, 41 }, /* 26 Mb */
+		[12] = { RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 39000,
+			36700, 4, 4, 4, 12, 42, 12, 42 }, /* 39 Mb */
+		[13] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 52000,
+			48100, 5, 5, 4, 13, 43, 13, 43 }, /* 52 Mb */
+		[14] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 58500,
+			53500, 6, 6, 4, 14, 44, 14, 44 }, /* 58.5 Mb */
+		[15] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 65000,
+			59000, 7, 7, 4, 15, 45, 16, 46 }, /* 65 Mb */
+		[16] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS_HGI, 72200,
+			65400, 7, 7, 4, 15, 45, 16, 46 }, /* 75 Mb */
+		[17] = { RC_INVALID, WLAN_RC_PHY_HT_20_DS, 13000,
+			12700, 8, 8, 0, 16, 47, 17, 47 }, /* 13 Mb */
+		[18] = { RC_HT_T_20, WLAN_RC_PHY_HT_20_DS, 26000,
+			24800, 9, 9, 2, 17, 48, 18, 48 }, /* 26 Mb */
+		[19] = { RC_HT_T_20, WLAN_RC_PHY_HT_20_DS, 39000,
+			36600, 10, 10, 2, 18, 49, 19, 49 }, /* 39 Mb */
+		[20] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 52000,
+			48100, 11, 11, 4, 19, 50, 20, 50 }, /* 52 Mb */
+		[21] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 78000,
+			69500, 12, 12, 4, 20, 51, 21, 51 }, /* 78 Mb */
+		[22] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 104000,
+			89500, 13, 13, 4, 21, 52, 22, 52 }, /* 104 Mb */
+		[23] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 117000,
+			98900, 14, 14, 4, 22, 53, 23, 53 }, /* 117 Mb */
+		[24] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 130000,
+			108300, 15, 15, 4, 23, 54, 25, 55 }, /* 130 Mb */
+		[25] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS_HGI, 144400,
+			12000, 15, 15, 4, 23, 54, 25, 55 }, /* 144.4 Mb */
+		[26] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 19500,
+			17400, 16, 16, 0, 24, 56, 26, 56 }, /* 19.5 Mb */
+		[27] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 39000,
+			35100, 17, 17, 2, 25, 57, 27, 57 }, /* 39 Mb */
+		[28] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 58500,
+			52600, 18, 18, 2, 26, 58, 28, 58 }, /* 58.5 Mb */
+		[29] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 78000,
+			70400, 19, 19, 4, 27, 59, 29, 59 }, /* 78 Mb */
+		[30] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 117000,
+			104900, 20, 20, 4, 28, 60, 31, 61 }, /* 117 Mb */
+		[31] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS_HGI, 130000,
+			115800, 20, 20, 4, 28, 60, 31, 61 }, /* 130 Mb*/
+		[32] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 156000,
+			137200, 21, 21, 4, 29, 62, 33, 63 }, /* 156 Mb */
+		[33] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 173300,
+			151100, 21, 21, 4, 29, 62, 33, 63 }, /* 173.3 Mb */
+		[34] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 175500,
+			152800, 22, 22, 4, 30, 64, 35, 65 }, /* 175.5 Mb */
+		[35] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 195000,
+			168400, 22, 22, 4, 30, 64, 35, 65 }, /* 195 Mb*/
+		[36] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 195000,
+			168400, 23, 23, 4, 31, 66, 37, 67 }, /* 195 Mb */
+		[37] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 216700,
+			185000, 23, 23, 4, 31, 66, 37, 67 }, /* 216.7 Mb */
+		[38] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 13500,
+			13200, 0, 0, 0, 8, 38, 38, 38 }, /* 13.5 Mb*/
+		[39] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 27500,
+			25900, 1, 1, 2, 9, 39, 39, 39 }, /* 27.0 Mb*/
+		[40] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 40500,
+			38600, 2, 2, 2, 10, 40, 40, 40 }, /* 40.5 Mb*/
+		[41] = { RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 54000,
+			49800, 3, 3, 4, 11, 41, 41, 41 }, /* 54 Mb */
+		[42] = { RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 81500,
+			72200, 4, 4, 4, 12, 42, 42, 42 }, /* 81 Mb */
+		[43] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 108000,
+			92900, 5, 5, 4, 13, 43, 43, 43 }, /* 108 Mb */
+		[44] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 121500,
+			102700, 6, 6, 4, 14, 44, 44, 44 }, /* 121.5 Mb*/
+		[45] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 135000,
+			112000, 7, 7, 4, 15, 45, 46, 46 }, /* 135 Mb */
+		[46] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS_HGI, 150000,
+			122000, 7, 7, 4, 15, 45, 46, 46 }, /* 150 Mb */
+		[47] = { RC_INVALID, WLAN_RC_PHY_HT_40_DS, 27000,
+			25800, 8, 8, 0, 16, 47, 47, 47 }, /* 27 Mb */
+		[48] = { RC_HT_T_40, WLAN_RC_PHY_HT_40_DS, 54000,
+			49800, 9, 9, 2, 17, 48, 48, 48 }, /* 54 Mb */
+		[49] = { RC_HT_T_40, WLAN_RC_PHY_HT_40_DS, 81000,
+			71900, 10, 10, 2, 18, 49, 49, 49 }, /* 81 Mb */
+		[50] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 108000,
+			92500, 11, 11, 4, 19, 50, 50, 50 }, /* 108 Mb */
+		[51] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 162000,
+			130300, 12, 12, 4, 20, 51, 51, 51 }, /* 162 Mb */
+		[52] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 216000,
+			162800, 13, 13, 4, 21, 52, 52, 52 }, /* 216 Mb */
+		[53] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 243000,
+			178200, 14, 14, 4, 22, 53, 53, 53 }, /* 243 Mb */
+		[54] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 270000,
+			192100, 15, 15, 4, 23, 54, 55, 55 }, /* 270 Mb */
+		[55] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS_HGI, 300000,
+			207000, 15, 15, 4, 23, 54, 55, 55 }, /* 300 Mb */
+		[56] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 40500,
+			36100, 16, 16, 0, 24, 56, 56, 56 }, /* 40.5 Mb */
+		[57] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 81000,
+			72900, 17, 17, 2, 25, 57, 57, 57 }, /* 81 Mb */
+		[58] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 121500,
+			108300, 18, 18, 2, 26, 58, 58, 58 }, /* 121.5 Mb */
+		[59] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 162000,
+			142000, 19, 19, 4, 27, 59, 59, 59 }, /*  162 Mb */
+		[60] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 243000,
+			205100, 20, 20, 4, 28, 60, 61, 61 }, /*  243 Mb */
+		[61] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS_HGI, 270000,
+			224700, 20, 20, 4, 28, 60, 61, 61 }, /*  270 Mb */
+		[62] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 324000,
+			263100, 21, 21, 4, 29, 62, 63, 63 }, /*  324 Mb */
+		[63] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 360000,
+			288000, 21, 21, 4, 29, 62, 63, 63 }, /*  360 Mb */
+		[64] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 364500,
+			290700, 22, 22, 4, 30, 64, 65, 65 }, /* 364.5 Mb */
+		[65] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 405000,
+			317200, 22, 22, 4, 30, 64, 65, 65 }, /* 405 Mb */
+		[66] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 405000,
+			317200, 23, 23, 4, 31, 66, 67, 67 }, /* 405 Mb */
+		[67] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 450000,
+			346400, 23, 23, 4, 31, 66, 67, 67 }, /* 450 Mb */
 	},
 	50,  /* probe interval */
 	WLAN_RC_HT_FLAG,  /* Phy rates allowed initially */
@@ -118,103 +168,153 @@ static const struct ath_rate_table ar5416_11na_ratetable = {
  * for HT are the 64K max aggregate limit */
 
 static const struct ath_rate_table ar5416_11ng_ratetable = {
-	47,
+	72,
 	12, /* MCS start */
 	{
-		{ RC_ALL, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
-			900, 0, 2, 0, 0, 0, 0, 0 },
-		{ RC_ALL, WLAN_RC_PHY_CCK, 2000, /* 2 Mb */
-			1900, 1, 4, 1, 1, 1, 1, 1 },
-		{ RC_ALL, WLAN_RC_PHY_CCK, 5500, /* 5.5 Mb */
-			4900, 2, 11, 2, 2, 2, 2, 2 },
-		{ RC_ALL, WLAN_RC_PHY_CCK, 11000, /* 11 Mb */
-			8100, 3, 22, 3, 3, 3, 3, 3 },
-		{ RC_INVALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
-			5400, 4, 12, 4, 4, 4, 4, 4 },
-		{ RC_INVALID, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
-			7800, 5, 18, 4, 5, 5, 5, 5 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
-			10100, 6, 24, 6, 6, 6, 6, 6 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
-			14100, 7, 36, 6, 7, 7, 7, 7 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
-			17700, 8, 48, 8, 8, 8, 8, 8 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
-			23700, 9, 72, 8, 9, 9, 9, 9 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
-			27400, 10, 96, 8, 10, 10, 10, 10 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
-			30900, 11, 108, 8, 11, 11, 11, 11 },
-		{ RC_INVALID, WLAN_RC_PHY_HT_20_SS, 6500, /* 6.5 Mb */
-			6400, 0, 0, 4, 12, 29, 12, 29 },
-		{ RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 13000, /* 13 Mb */
-			12700, 1, 1, 6, 13, 30, 13, 30 },
-		{ RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 19500, /* 19.5 Mb */
-			18800, 2, 2, 6, 14, 31, 14, 31 },
-		{ RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 26000, /* 26 Mb */
-			25000, 3, 3, 8, 15, 32, 15, 32 },
-		{ RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 39000, /* 39 Mb */
-			36700, 4, 4, 8, 16, 33, 16, 33 },
-		{ RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 52000, /* 52 Mb */
-			48100, 5, 5, 8, 17, 34, 17, 34 },
-		{ RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 58500, /* 58.5 Mb */
-			53500, 6, 6, 8, 18, 35, 18, 35 },
-		{ RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 65000, /* 65 Mb */
-			59000, 7, 7, 8, 19, 36, 19, 37 },
-		{ RC_INVALID, WLAN_RC_PHY_HT_20_DS, 13000, /* 13 Mb */
-			12700, 8, 8, 4, 20, 38, 20, 38 },
-		{ RC_INVALID, WLAN_RC_PHY_HT_20_DS, 26000, /* 26 Mb */
-			24800, 9, 9, 6, 21, 39, 21, 39 },
-		{ RC_INVALID, WLAN_RC_PHY_HT_20_DS, 39000, /* 39 Mb */
-			36600, 10, 10, 6, 22, 40, 22, 40 },
-		{ RC_HT_D_20, WLAN_RC_PHY_HT_20_DS, 52000, /* 52 Mb */
-			48100, 11, 11, 8, 23, 41, 23, 41 },
-		{ RC_HT_D_20, WLAN_RC_PHY_HT_20_DS, 78000, /* 78 Mb */
-			69500, 12, 12, 8, 24, 42, 24, 42 },
-		{ RC_HT_D_20, WLAN_RC_PHY_HT_20_DS, 104000, /* 104 Mb */
-			89500, 13, 13, 8, 25, 43, 25, 43 },
-		{ RC_HT_D_20, WLAN_RC_PHY_HT_20_DS, 117000, /* 117 Mb */
-			98900, 14, 14, 8, 26, 44, 26, 44 },
-		{ RC_HT_D_20, WLAN_RC_PHY_HT_20_DS, 130000, /* 130 Mb */
-			108300, 15, 15, 8, 27, 45, 28, 46 },
-		{ RC_HT_D_20, WLAN_RC_PHY_HT_20_DS_HGI, 144400, /* 130 Mb */
-			120000, 15, 15, 8, 27, 45, 28, 46 },
-		{ RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 13500, /* 13.5 Mb */
-			13200, 0, 0, 8, 12, 29, 29, 29 },
-		{ RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 27500, /* 27.0 Mb */
-			25900, 1, 1, 8, 13, 30, 30, 30 },
-		{ RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 40500, /* 40.5 Mb */
-			38600, 2, 2, 8, 14, 31, 31, 31 },
-		{ RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 54000, /* 54 Mb */
-			49800, 3, 3, 8,  15, 32, 32, 32 },
-		{ RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 81500, /* 81 Mb */
-			72200, 4, 4, 8, 16, 33, 33, 33 },
-		{ RC_HT_S_40 , WLAN_RC_PHY_HT_40_SS, 108000, /* 108 Mb */
-			92900, 5, 5, 8, 17, 34, 34, 34 },
-		{ RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 121500, /* 121.5 Mb */
-			102700, 6, 6, 8, 18, 35, 35, 35 },
-		{ RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 135000, /* 135 Mb */
-			112000, 7, 7, 8, 19, 36, 37, 37 },
-		{ RC_HT_S_40, WLAN_RC_PHY_HT_40_SS_HGI, 150000, /* 150 Mb */
-			122000, 7, 7, 8, 19, 36, 37, 37 },
-		{ RC_INVALID, WLAN_RC_PHY_HT_40_DS, 27000, /* 27 Mb */
-			25800, 8, 8, 8, 20, 38, 38, 38 },
-		{ RC_INVALID, WLAN_RC_PHY_HT_40_DS, 54000, /* 54 Mb */
-			49800, 9, 9, 8, 21, 39, 39, 39 },
-		{ RC_INVALID, WLAN_RC_PHY_HT_40_DS, 81000, /* 81 Mb */
-			71900, 10, 10, 8, 22, 40, 40, 40 },
-		{ RC_HT_D_40, WLAN_RC_PHY_HT_40_DS, 108000, /* 108 Mb */
-			92500, 11, 11, 8, 23, 41, 41, 41 },
-		{ RC_HT_D_40, WLAN_RC_PHY_HT_40_DS, 162000, /* 162 Mb */
-			130300, 12, 12, 8, 24, 42, 42, 42 },
-		{ RC_HT_D_40, WLAN_RC_PHY_HT_40_DS, 216000, /* 216 Mb */
-			162800, 13, 13, 8, 25, 43, 43, 43 },
-		{ RC_HT_D_40, WLAN_RC_PHY_HT_40_DS, 243000, /* 243 Mb */
-			178200, 14, 14, 8, 26, 44, 44, 44 },
-		{ RC_HT_D_40, WLAN_RC_PHY_HT_40_DS, 270000, /* 270 Mb */
-			192100, 15, 15, 8, 27, 45, 46, 46 },
-		{ RC_HT_D_40, WLAN_RC_PHY_HT_40_DS_HGI, 300000, /* 300 Mb */
-			207000, 15, 15, 8, 27, 45, 46, 46 },
+		[0] = { RC_ALL, WLAN_RC_PHY_CCK, 1000,
+			900, 0, 2, 0, 0, 0, 0, 0 }, /* 1 Mb */
+		[1] = { RC_ALL, WLAN_RC_PHY_CCK, 2000,
+			1900, 1, 4, 1, 1, 1, 1, 1 }, /* 2 Mb */
+		[2] = { RC_ALL, WLAN_RC_PHY_CCK, 5500,
+			4900, 2, 11, 2, 2, 2, 2, 2 }, /* 5.5 Mb */
+		[3] = { RC_ALL, WLAN_RC_PHY_CCK, 11000,
+			8100, 3, 22, 3, 3, 3, 3, 3 }, /* 11 Mb */
+		[4] = { RC_INVALID, WLAN_RC_PHY_OFDM, 6000,
+			5400, 4, 12, 4, 4, 4, 4, 4 }, /* 6 Mb */
+		[5] = { RC_INVALID, WLAN_RC_PHY_OFDM, 9000,
+			7800, 5, 18, 4, 5, 5, 5, 5 }, /* 9 Mb */
+		[6] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 12000,
+			10100, 6, 24, 6, 6, 6, 6, 6 }, /* 12 Mb */
+		[7] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 18000,
+			14100, 7, 36, 6, 7, 7, 7, 7 }, /* 18 Mb */
+		[8] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 24000,
+			17700, 8, 48, 8, 8, 8, 8, 8 }, /* 24 Mb */
+		[9] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 36000,
+			23700, 9, 72, 8, 9, 9, 9, 9 }, /* 36 Mb */
+		[10] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 48000,
+			27400, 10, 96, 8, 10, 10, 10, 10 }, /* 48 Mb */
+		[11] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 54000,
+			30900, 11, 108, 8, 11, 11, 11, 11 }, /* 54 Mb */
+		[12] = { RC_INVALID, WLAN_RC_PHY_HT_20_SS, 6500,
+			6400, 0, 0, 4, 12, 42, 12, 42 }, /* 6.5 Mb */
+		[13] = { RC_HT_SDT_20, WLAN_RC_PHY_HT_20_SS, 13000,
+			12700, 1, 1, 6, 13, 43, 13, 43 }, /* 13 Mb */
+		[14] = { RC_HT_SDT_20, WLAN_RC_PHY_HT_20_SS, 19500,
+			18800, 2, 2, 6, 14, 44, 14, 44 }, /* 19.5 Mb*/
+		[15] = { RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 26000,
+			25000, 3, 3, 8, 15, 45, 15, 45 }, /* 26 Mb */
+		[16] = { RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 39000,
+			36700, 4, 4, 8, 16, 46, 16, 46 }, /* 39 Mb */
+		[17] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 52000,
+			48100, 5, 5, 8, 17, 47, 17, 47 }, /* 52 Mb */
+		[18] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 58500,
+			53500, 6, 6, 8, 18, 48, 18, 48 }, /* 58.5 Mb */
+		[19] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 65000,
+			59000, 7, 7, 8, 19, 49, 20, 50 }, /* 65 Mb */
+		[20] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS_HGI, 72200,
+			65400, 7, 7, 8, 19, 49, 20, 50 }, /* 65 Mb*/
+		[21] = { RC_INVALID, WLAN_RC_PHY_HT_20_DS, 13000,
+			12700, 8, 8, 4, 20, 51, 21, 51 }, /* 13 Mb */
+		[22] = { RC_HT_T_20, WLAN_RC_PHY_HT_20_DS, 26000,
+			24800, 9, 9, 6, 21, 52, 22, 52 }, /* 26 Mb */
+		[23] = { RC_HT_T_20, WLAN_RC_PHY_HT_20_DS, 39000,
+			36600, 10, 10, 6, 22, 53, 23, 53 }, /* 39 Mb */
+		[24] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 52000,
+			48100, 11, 11, 8, 23, 54, 24, 54 }, /* 52 Mb */
+		[25] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 78000,
+			69500, 12, 12, 8, 24, 55, 25, 55 }, /* 78 Mb */
+		[26] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 104000,
+			89500, 13, 13, 8, 25, 56, 26, 56 }, /* 104 Mb */
+		[27] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 117000,
+			98900, 14, 14, 8, 26, 57, 27, 57 }, /* 117 Mb */
+		[28] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 130000,
+			108300, 15, 15, 8, 27, 58, 29, 59 }, /* 130 Mb */
+		[29] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS_HGI, 144400,
+			120000, 15, 15, 8, 27, 58, 29, 59 }, /* 144.4 Mb */
+		[30] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 19500,
+			17400, 16, 16, 4, 28, 60, 30, 60 }, /* 19.5 Mb */
+		[31] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 39000,
+			35100, 17, 17, 6, 29, 61, 31, 61 }, /* 39 Mb */
+		[32] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 58500,
+			52600, 18, 18, 6, 30, 62, 32, 62 }, /* 58.5 Mb */
+		[33] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 78000,
+			70400, 19, 19, 8, 31, 63, 33, 63 }, /* 78 Mb */
+		[34] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 117000,
+			104900, 20, 20, 8, 32, 64, 35, 65 }, /* 117 Mb */
+		[35] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS_HGI, 130000,
+			115800, 20, 20, 8, 32, 64, 35, 65 }, /* 130 Mb */
+		[36] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 156000,
+			137200, 21, 21, 8, 33, 66, 37, 67 }, /* 156 Mb */
+		[37] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 173300,
+			151100, 21, 21, 8, 33, 66, 37, 67 }, /* 173.3 Mb */
+		[38] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 175500,
+			152800, 22, 22, 8, 34, 68, 39, 69 }, /* 175.5 Mb */
+		[39] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 195000,
+			168400, 22, 22, 8, 34, 68, 39, 69 }, /* 195 Mb */
+		[40] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 195000,
+			168400, 23, 23, 8, 35, 70, 41, 71 }, /* 195 Mb */
+		[41] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 216700,
+			185000, 23, 23, 8, 35, 70, 41, 71 }, /* 216.7 Mb */
+		[42] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 13500,
+			13200, 0, 0, 8, 12, 42, 42, 42 }, /* 13.5 Mb */
+		[43] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 27500,
+			25900, 1, 1, 8, 13, 43, 43, 43 }, /* 27.0 Mb */
+		[44] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 40500,
+			38600, 2, 2, 8, 14, 44, 44, 44 }, /* 40.5 Mb */
+		[45] = { RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 54000,
+			49800, 3, 3, 8,  15, 45, 45, 45 }, /* 54 Mb */
+		[46] = { RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 81500,
+			72200, 4, 4, 8, 16, 46, 46, 46 }, /* 81 Mb */
+		[47] = { RC_HT_S_40 , WLAN_RC_PHY_HT_40_SS, 108000,
+			92900, 5, 5, 8, 17, 47, 47, 47 }, /* 108 Mb */
+		[48] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 121500,
+			102700, 6, 6, 8, 18, 48, 48, 48 }, /* 121.5 Mb */
+		[49] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 135000,
+			112000, 7, 7, 8, 19, 49, 50, 50 }, /* 135 Mb */
+		[50] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS_HGI, 150000,
+			122000, 7, 7, 8, 19, 49, 50, 50 }, /* 150 Mb */
+		[51] = { RC_INVALID, WLAN_RC_PHY_HT_40_DS, 27000,
+			25800, 8, 8, 8, 20, 51, 51, 51 }, /* 27 Mb */
+		[52] = { RC_HT_T_40, WLAN_RC_PHY_HT_40_DS, 54000,
+			49800, 9, 9, 8, 21, 52, 52, 52 }, /* 54 Mb */
+		[53] = { RC_HT_T_40, WLAN_RC_PHY_HT_40_DS, 81000,
+			71900, 10, 10, 8, 22, 53, 53, 53 }, /* 81 Mb */
+		[54] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 108000,
+			92500, 11, 11, 8, 23, 54, 54, 54 }, /* 108 Mb */
+		[55] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 162000,
+			130300, 12, 12, 8, 24, 55, 55, 55 }, /* 162 Mb */
+		[56] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 216000,
+			162800, 13, 13, 8, 25, 56, 56, 56 }, /* 216 Mb */
+		[57] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 243000,
+			178200, 14, 14, 8, 26, 57, 57, 57 }, /* 243 Mb */
+		[58] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 270000,
+			192100, 15, 15, 8, 27, 58, 59, 59 }, /* 270 Mb */
+		[59] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS_HGI, 300000,
+			207000, 15, 15, 8, 27, 58, 59, 59 }, /* 300 Mb */
+		[60] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 40500,
+			36100, 16, 16, 8, 28, 60, 60, 60 }, /* 40.5 Mb */
+		[61] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 81000,
+			72900, 17, 17, 8, 29, 61, 61, 61 }, /* 81 Mb */
+		[62] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 121500,
+			108300, 18, 18, 8, 30, 62, 62, 62 }, /* 121.5 Mb */
+		[63] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 162000,
+			142000, 19, 19, 8, 31, 63, 63, 63 }, /* 162 Mb */
+		[64] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 243000,
+			205100, 20, 20, 8, 32, 64, 65, 65 }, /* 243 Mb */
+		[65] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS_HGI, 270000,
+			224700, 20, 20, 8, 32, 64, 65, 65 }, /* 170 Mb */
+		[66] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 324000,
+			263100, 21, 21, 8, 33, 66, 67, 67 }, /* 324 Mb */
+		[67] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 360000,
+			288000, 21, 21, 8, 33, 66, 67, 67 }, /* 360 Mb */
+		[68] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 364500,
+			290700, 22, 22, 8, 34, 68, 69, 69 }, /* 364.5 Mb */
+		[69] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 405000,
+			317200, 22, 22, 8, 34, 68, 69, 69 }, /* 405 Mb */
+		[70] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 405000,
+			317200, 23, 23, 8, 35, 70, 71, 71 }, /* 405 Mb */
+		[71] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 450000,
+			346400, 23, 23, 8, 35, 70, 71, 71 }, /* 450 Mb */
 	},
 	50,  /* probe interval */
 	WLAN_RC_HT_FLAG,  /* Phy rates allowed initially */
@@ -224,21 +324,21 @@ static const struct ath_rate_table ar5416_11a_ratetable = {
 	8,
 	0,
 	{
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
+		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
 			5400, 0, 12, 0, 0, 0 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
+		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
 			7800,  1, 18, 0, 1, 0 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
+		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
 			10000, 2, 24, 2, 2, 0 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
+		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
 			13900, 3, 36, 2, 3, 0 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
+		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
 			17300, 4, 48, 4, 4, 0 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
+		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
 			23000, 5, 72, 4, 5, 0 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
+		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
 			27400, 6, 96, 4, 6, 0 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
+		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
 			29300, 7, 108, 4, 7, 0 },
 	},
 	50,  /* probe interval */
@@ -249,29 +349,29 @@ static const struct ath_rate_table ar5416_11g_ratetable = {
 	12,
 	0,
 	{
-		{ RC_L_SD, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
+		{ RC_L_SDT, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
 			900, 0, 2, 0, 0, 0 },
-		{ RC_L_SD, WLAN_RC_PHY_CCK, 2000, /* 2 Mb */
+		{ RC_L_SDT, WLAN_RC_PHY_CCK, 2000, /* 2 Mb */
 			1900, 1, 4, 1, 1, 0 },
-		{ RC_L_SD, WLAN_RC_PHY_CCK, 5500, /* 5.5 Mb */
+		{ RC_L_SDT, WLAN_RC_PHY_CCK, 5500, /* 5.5 Mb */
 			4900, 2, 11, 2, 2, 0 },
-		{ RC_L_SD, WLAN_RC_PHY_CCK, 11000, /* 11 Mb */
+		{ RC_L_SDT, WLAN_RC_PHY_CCK, 11000, /* 11 Mb */
 			8100, 3, 22, 3, 3, 0 },
 		{ RC_INVALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
 			5400, 4, 12, 4, 4, 0 },
 		{ RC_INVALID, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
 			7800, 5, 18, 4, 5, 0 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
+		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
 			10000, 6, 24, 6, 6, 0 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
+		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
 			13900, 7, 36, 6, 7, 0 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
+		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
 			17300, 8, 48, 8, 8, 0 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
+		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
 			23000, 9, 72, 8, 9, 0 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
+		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
 			27400, 10, 96, 8, 10, 0 },
-		{ RC_L_SD, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
+		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
 			29300, 11, 108, 8, 11, 0 },
 	},
 	50,  /* probe interval */
@@ -374,6 +474,8 @@ static int ath_rc_valid_phyrate(u32 phy, u32 capflag, int ignore_cw)
 		return 0;
 	if (WLAN_RC_PHY_DS(phy) && !(capflag & WLAN_RC_DS_FLAG))
 		return 0;
+	if (WLAN_RC_PHY_TS(phy) && !(capflag & WLAN_RC_TS_FLAG))
+		return 0;
 	if (WLAN_RC_PHY_SGI(phy) && !(capflag & WLAN_RC_SGI_FLAG))
 		return 0;
 	if (!ignore_cw && WLAN_RC_PHY_HT(phy))
@@ -583,8 +685,12 @@ static u8 ath_rc_get_highest_rix(struct ath_softc *sc,
 	if (rate > (ath_rc_priv->rate_table_size - 1))
 		rate = ath_rc_priv->rate_table_size - 1;
 
-	if (rate_table->info[rate].rate_flags & RC_DS &&
-	    (ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG))
+	if (RC_TS_ONLY(rate_table->info[rate].rate_flags) &&
+	    (ath_rc_priv->ht_cap & WLAN_RC_TS_FLAG))
+		return rate;
+
+	if (RC_DS_OR_LATER(rate_table->info[rate].rate_flags) &&
+	    (ath_rc_priv->ht_cap & (WLAN_RC_DS_FLAG | WLAN_RC_TS_FLAG)))
 		return rate;
 
 	if (RC_SS_OR_LEGACY(rate_table->info[rate].rate_flags))
@@ -1000,12 +1106,19 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 static int ath_rc_get_rateindex(const struct ath_rate_table *rate_table,
 				struct ieee80211_tx_rate *rate)
 {
-	int rix;
+	int rix = 0, i = 0;
+	int mcs_rix_off[] = { 7, 15, 20, 21, 22, 23 };
 
 	if (!(rate->flags & IEEE80211_TX_RC_MCS))
 		return rate->idx;
 
-	rix = rate->idx + rate_table->mcs_start;
+	while (rate->idx > mcs_rix_off[i] &&
+	      i < sizeof(mcs_rix_off)/sizeof(int)) {
+		rix++; i++;
+	}
+
+	rix += rate->idx + rate_table->mcs_start;
+
 	if ((rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
 	    (rate->flags & IEEE80211_TX_RC_SHORT_GI))
 		rix = rate_table->info[rix].ht_index;
@@ -1013,8 +1126,6 @@ static int ath_rc_get_rateindex(const struct ath_rate_table *rate_table,
 		rix = rate_table->info[rix].sgi_index;
 	else if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
 		rix = rate_table->info[rix].cw40index;
-	else
-		rix = rate_table->info[rix].base_index;
 
 	return rix;
 }
@@ -1196,13 +1307,14 @@ static u8 ath_rc_build_ht_caps(struct ath_softc *sc, struct ieee80211_sta *sta,
 
 	if (sta->ht_cap.ht_supported) {
 		caps = WLAN_RC_HT_FLAG;
-		if (sta->ht_cap.mcs.rx_mask[1])
+		if (sta->ht_cap.mcs.rx_mask[1] && sta->ht_cap.mcs.rx_mask[2])
+			caps |= WLAN_RC_TS_FLAG | WLAN_RC_DS_FLAG;
+		else if (sta->ht_cap.mcs.rx_mask[1])
 			caps |= WLAN_RC_DS_FLAG;
 		if (is_cw40)
 			caps |= WLAN_RC_40_FLAG;
 		if (is_sgi)
 			caps |= WLAN_RC_SGI_FLAG;
-
 	}
 
 	return caps;
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 601803a..e914c33 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -24,7 +24,7 @@
 struct ath_softc;
 
 #define ATH_RATE_MAX     30
-#define RATE_TABLE_SIZE  64
+#define RATE_TABLE_SIZE  72
 #define MAX_TX_RATE_PHY  48
 
 
@@ -36,19 +36,34 @@ struct ath_softc;
 #define RC_HT_20	0x0010
 #define RC_HT_40	0x0020
 
-#define RC_SS_OR_LEGACY(f)     ((f) & (RC_SS | RC_LEGACY))
+#define RC_STREAM_MASK	0xe
+#define RC_DS_OR_LATER(f)	((((f) & RC_STREAM_MASK) == RC_DS) || \
+				(((f) & RC_STREAM_MASK) == (RC_DS | RC_TS)))
+#define RC_TS_ONLY(f)		(((f) & RC_STREAM_MASK) == RC_TS)
+#define RC_SS_OR_LEGACY(f)	((f) & (RC_SS | RC_LEGACY))
 
 #define RC_HT_2040		(RC_HT_20 | RC_HT_40)
-#define RC_ALL_STREAM		(RC_SS | RC_DS)
+#define RC_ALL_STREAM		(RC_SS | RC_DS | RC_TS)
 #define RC_L_SD			(RC_LEGACY | RC_SS | RC_DS)
-#define RC_HT_SD_2040		(RC_HT_2040 | RC_SS | RC_DS)
+#define RC_L_SDT		(RC_LEGACY | RC_SS | RC_DS | RC_TS)
 #define RC_HT_S_20		(RC_HT_20 | RC_SS)
-#define RC_HT_SD_20		(RC_HT_20 | RC_SS | RC_DS)
-#define RC_HT_SD_40		(RC_HT_40 | RC_SS | RC_DS)
-#define RC_HT_S_20		(RC_HT_20 | RC_SS)
-#define RC_HT_S_40		(RC_HT_40 | RC_SS)
 #define RC_HT_D_20		(RC_HT_20 | RC_DS)
+#define RC_HT_T_20		(RC_HT_20 | RC_TS)
+#define RC_HT_S_40		(RC_HT_40 | RC_SS)
 #define RC_HT_D_40		(RC_HT_40 | RC_DS)
+#define RC_HT_T_40		(RC_HT_40 | RC_TS)
+
+#define RC_HT_SD_20		(RC_HT_20 | RC_SS | RC_DS)
+#define RC_HT_DT_20		(RC_HT_20 | RC_DS | RC_TS)
+#define RC_HT_SD_40		(RC_HT_40 | RC_SS | RC_DS)
+#define RC_HT_DT_40		(RC_HT_40 | RC_DS | RC_TS)
+
+#define RC_HT_SD_2040		(RC_HT_2040 | RC_SS | RC_DS)
+#define RC_HT_SDT_2040		(RC_HT_2040 | RC_SS | RC_DS | RC_TS)
+
+#define RC_HT_SDT_20		(RC_HT_20 | RC_SS | RC_DS | RC_TS)
+#define RC_HT_SDT_40		(RC_HT_40 | RC_SS | RC_DS | RC_TS)
+
 #define RC_ALL			(RC_LEGACY | RC_HT_2040 | RC_ALL_STREAM)
 
 enum {
@@ -56,12 +71,16 @@ enum {
 	WLAN_RC_PHY_CCK,
 	WLAN_RC_PHY_HT_20_SS,
 	WLAN_RC_PHY_HT_20_DS,
+	WLAN_RC_PHY_HT_20_TS,
 	WLAN_RC_PHY_HT_40_SS,
 	WLAN_RC_PHY_HT_40_DS,
+	WLAN_RC_PHY_HT_40_TS,
 	WLAN_RC_PHY_HT_20_SS_HGI,
 	WLAN_RC_PHY_HT_20_DS_HGI,
+	WLAN_RC_PHY_HT_20_TS_HGI,
 	WLAN_RC_PHY_HT_40_SS_HGI,
 	WLAN_RC_PHY_HT_40_DS_HGI,
+	WLAN_RC_PHY_HT_40_TS_HGI,
 	WLAN_RC_PHY_MAX
 };
 
@@ -69,27 +88,36 @@ enum {
 				|| (_phy == WLAN_RC_PHY_HT_40_DS)	\
 				|| (_phy == WLAN_RC_PHY_HT_20_DS_HGI)	\
 				|| (_phy == WLAN_RC_PHY_HT_40_DS_HGI))
+#define WLAN_RC_PHY_TS(_phy)   ((_phy == WLAN_RC_PHY_HT_20_TS)		\
+				|| (_phy == WLAN_RC_PHY_HT_40_TS)	\
+				|| (_phy == WLAN_RC_PHY_HT_20_TS_HGI)	\
+				|| (_phy == WLAN_RC_PHY_HT_40_TS_HGI))
 #define WLAN_RC_PHY_20(_phy)   ((_phy == WLAN_RC_PHY_HT_20_SS)		\
 				|| (_phy == WLAN_RC_PHY_HT_20_DS)	\
+				|| (_phy == WLAN_RC_PHY_HT_20_TS)	\
 				|| (_phy == WLAN_RC_PHY_HT_20_SS_HGI)	\
-				|| (_phy == WLAN_RC_PHY_HT_20_DS_HGI))
+				|| (_phy == WLAN_RC_PHY_HT_20_DS_HGI)	\
+				|| (_phy == WLAN_RC_PHY_HT_20_TS_HGI))
 #define WLAN_RC_PHY_40(_phy)   ((_phy == WLAN_RC_PHY_HT_40_SS)		\
 				|| (_phy == WLAN_RC_PHY_HT_40_DS)	\
+				|| (_phy == WLAN_RC_PHY_HT_40_TS)	\
 				|| (_phy == WLAN_RC_PHY_HT_40_SS_HGI)	\
-				|| (_phy == WLAN_RC_PHY_HT_40_DS_HGI))
+				|| (_phy == WLAN_RC_PHY_HT_40_DS_HGI)	\
+				|| (_phy == WLAN_RC_PHY_HT_40_TS_HGI))
 #define WLAN_RC_PHY_SGI(_phy)  ((_phy == WLAN_RC_PHY_HT_20_SS_HGI)      \
 				|| (_phy == WLAN_RC_PHY_HT_20_DS_HGI)   \
+				|| (_phy == WLAN_RC_PHY_HT_20_TS_HGI)   \
 				|| (_phy == WLAN_RC_PHY_HT_40_SS_HGI)   \
-				|| (_phy == WLAN_RC_PHY_HT_40_DS_HGI))
+				|| (_phy == WLAN_RC_PHY_HT_40_DS_HGI)   \
+				|| (_phy == WLAN_RC_PHY_HT_40_TS_HGI))
 
 #define WLAN_RC_PHY_HT(_phy)    (_phy >= WLAN_RC_PHY_HT_20_SS)
 
 #define WLAN_RC_CAP_MODE(capflag) (((capflag & WLAN_RC_HT_FLAG) ?	\
 	((capflag & WLAN_RC_40_FLAG) ? RC_HT_40 : RC_HT_20) : RC_LEGACY))
 
-#define WLAN_RC_CAP_STREAM(capflag) \
-	(((capflag) & WLAN_RC_DS_FLAG) ? RC_DS : RC_SS)
-
+#define WLAN_RC_CAP_STREAM(capflag) (((capflag & WLAN_RC_TS_FLAG) ?	\
+	(RC_TS) : ((capflag & WLAN_RC_DS_FLAG) ? RC_DS : RC_SS)))
 
 /* Return TRUE if flag supports HT20 && client supports HT20 or
  * return TRUE if flag supports HT40 && client supports HT40.
@@ -100,9 +128,10 @@ enum {
 	 ((flag & RC_HT_40) && (capflag & WLAN_RC_40_FLAG)))
 
 #define WLAN_RC_DS_FLAG         (0x01)
-#define WLAN_RC_40_FLAG         (0x02)
-#define WLAN_RC_SGI_FLAG        (0x04)
-#define WLAN_RC_HT_FLAG         (0x08)
+#define WLAN_RC_TS_FLAG         (0x02)
+#define WLAN_RC_40_FLAG         (0x04)
+#define WLAN_RC_SGI_FLAG        (0x08)
+#define WLAN_RC_HT_FLAG         (0x10)
 
 /**
  * struct ath_rate_table - Rate Control table
-- 
1.7.1

