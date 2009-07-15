Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42331 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbZGOAO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:14:29 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 19/21] ath9k: Remove unused members from rate control structure
Date: Tue, 14 Jul 2009 20:14:11 -0400
Message-Id: <1247616853-11221-20-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
References: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |  216 +++++++++++++++++-----------------
 drivers/net/wireless/ath/ath9k/rc.h |   21 ----
 2 files changed, 108 insertions(+), 129 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index a39b1a7..731967c 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -22,130 +22,130 @@ static const struct ath_rate_table ar5416_11na_ratetable = {
 	{
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
 			5400, 0x0b, 0x00, 12,
-			0, 2, 1, 0, 0, 0, 0, 0 },
+			0, 0, 0, 0, 0, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
 			7800,  0x0f, 0x00, 18,
-			0, 3, 1, 1, 1, 1, 1, 0 },
+			0, 1, 1, 1, 1, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
 			10000, 0x0a, 0x00, 24,
-			2, 4, 2, 2, 2, 2, 2, 0 },
+			2, 2, 2, 2, 2, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
 			13900, 0x0e, 0x00, 36,
-			2, 6,  2, 3, 3, 3, 3, 0 },
+			2,  3, 3, 3, 3, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
 			17300, 0x09, 0x00, 48,
-			4, 10, 3, 4, 4, 4, 4, 0 },
+			4,  4, 4, 4, 4, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
 			23000, 0x0d, 0x00, 72,
-			4, 14, 3, 5, 5, 5, 5, 0 },
+			4,  5, 5, 5, 5, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
 			27400, 0x08, 0x00, 96,
-			4, 20, 3, 6, 6, 6, 6, 0 },
+			4,  6, 6, 6, 6, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
 			29300, 0x0c, 0x00, 108,
-			4, 23, 3, 7, 7, 7, 7, 0 },
+			4,  7, 7, 7, 7, 0 },
 		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 6500, /* 6.5 Mb */
 			6400, 0x80, 0x00, 0,
-			0, 2, 3, 8, 24, 8, 24, 3216 },
+			0, 8, 24, 8, 24, 3216 },
 		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 13000, /* 13 Mb */
 			12700, 0x81, 0x00, 1,
-			2, 4, 3, 9, 25, 9, 25, 6434 },
+			2, 9, 25, 9, 25, 6434 },
 		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 19500, /* 19.5 Mb */
 			18800, 0x82, 0x00, 2,
-			2, 6, 3, 10, 26, 10, 26, 9650 },
+			2, 10, 26, 10, 26, 9650 },
 		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 26000, /* 26 Mb */
 			25000, 0x83, 0x00, 3,
-			4, 10, 3, 11, 27, 11, 27, 12868 },
+			4,  11, 27, 11, 27, 12868 },
 		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 39000, /* 39 Mb */
 			36700, 0x84, 0x00, 4,
-			4, 14, 3, 12, 28, 12, 28, 19304 },
+			4,  12, 28, 12, 28, 19304 },
 		{ INVALID, VALID_20, WLAN_RC_PHY_HT_20_SS, 52000, /* 52 Mb */
 			48100, 0x85, 0x00, 5,
-			4, 20, 3, 13, 29, 13, 29, 25740 },
+			4,  13, 29, 13, 29, 25740 },
 		{ INVALID, VALID_20, WLAN_RC_PHY_HT_20_SS, 58500, /* 58.5 Mb */
 			53500, 0x86, 0x00, 6,
-			4, 23, 3, 14, 30, 14, 30,  28956 },
+			4,  14, 30, 14, 30,  28956 },
 		{ INVALID, VALID_20, WLAN_RC_PHY_HT_20_SS, 65000, /* 65 Mb */
 			59000, 0x87, 0x00, 7,
-			4, 25, 3, 15, 31, 15, 32, 32180 },
+			4,  15, 31, 15, 32, 32180 },
 		{ INVALID, INVALID, WLAN_RC_PHY_HT_20_DS, 13000, /* 13 Mb */
 			12700, 0x88, 0x00,
-			8, 0, 2, 3, 16, 33, 16, 33, 6430 },
+			8, 3, 16, 33, 16, 33, 6430 },
 		{ INVALID, INVALID, WLAN_RC_PHY_HT_20_DS, 26000, /* 26 Mb */
 			24800, 0x89, 0x00, 9,
-			2, 4, 3, 17, 34, 17, 34, 12860 },
+			2, 17, 34, 17, 34, 12860 },
 		{ INVALID, INVALID, WLAN_RC_PHY_HT_20_DS, 39000, /* 39 Mb */
 			36600, 0x8a, 0x00, 10,
-			2, 6, 3, 18, 35, 18, 35, 19300 },
+			2, 18, 35, 18, 35, 19300 },
 		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 52000, /* 52 Mb */
 			48100, 0x8b, 0x00, 11,
-			4, 10, 3, 19, 36, 19, 36, 25736 },
+			4,  19, 36, 19, 36, 25736 },
 		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 78000, /* 78 Mb */
 			69500, 0x8c, 0x00, 12,
-			4, 14, 3, 20, 37, 20, 37, 38600 },
+			4,  20, 37, 20, 37, 38600 },
 		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 104000, /* 104 Mb */
 			89500, 0x8d, 0x00, 13,
-			4, 20, 3, 21, 38, 21, 38, 51472 },
+			4,  21, 38, 21, 38, 51472 },
 		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 117000, /* 117 Mb */
 			98900, 0x8e, 0x00, 14,
-			4, 23, 3, 22, 39, 22, 39, 57890 },
+			4,  22, 39, 22, 39, 57890 },
 		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 130000, /* 130 Mb */
 			108300, 0x8f, 0x00, 15,
-			4, 25, 3, 23, 40, 23, 41, 64320 },
+			4,  23, 40, 23, 41, 64320 },
 		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 13500, /* 13.5 Mb */
 			13200, 0x80, 0x00, 0,
-			0, 2, 3, 8, 24, 24, 24, 6684 },
+			0, 8, 24, 24, 24, 6684 },
 		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 27500, /* 27.0 Mb */
 			25900, 0x81, 0x00, 1,
-			2, 4, 3, 9, 25, 25, 25, 13368 },
+			2, 9, 25, 25, 25, 13368 },
 		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 40500, /* 40.5 Mb */
 			38600, 0x82, 0x00, 2,
-			2, 6, 3, 10, 26, 26, 26, 20052 },
+			2, 10, 26, 26, 26, 20052 },
 		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 54000, /* 54 Mb */
 			49800, 0x83, 0x00, 3,
-			4, 10, 3, 11, 27, 27, 27, 26738 },
+			4,  11, 27, 27, 27, 26738 },
 		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 81500, /* 81 Mb */
 			72200, 0x84, 0x00, 4,
-			4, 14, 3, 12, 28, 28, 28, 40104 },
+			4,  12, 28, 28, 28, 40104 },
 		{ INVALID, VALID_40, WLAN_RC_PHY_HT_40_SS, 108000, /* 108 Mb */
 			92900, 0x85, 0x00, 5,
-			4, 20, 3, 13, 29, 29, 29, 53476 },
+			4,  13, 29, 29, 29, 53476 },
 		{ INVALID, VALID_40, WLAN_RC_PHY_HT_40_SS, 121500, /* 121.5 Mb */
 			102700, 0x86, 0x00, 6,
-			4, 23, 3, 14, 30, 30, 30, 60156 },
+			4,  14, 30, 30, 30, 60156 },
 		{ INVALID, VALID_40, WLAN_RC_PHY_HT_40_SS, 135000, /* 135 Mb */
 			112000, 0x87, 0x00, 7,
-			4, 25, 3, 15, 31, 32, 32, 66840 },
+			4,  15, 31, 32, 32, 66840 },
 		{ INVALID, VALID_40, WLAN_RC_PHY_HT_40_SS_HGI, 150000, /* 150 Mb */
 			122000, 0x87, 0x00, 7,
-			4, 25, 3, 15, 31, 32, 32, 74200 },
+			4,  15, 31, 32, 32, 74200 },
 		{ INVALID, INVALID, WLAN_RC_PHY_HT_40_DS, 27000, /* 27 Mb */
 			25800, 0x88, 0x00, 8,
-			0, 2, 3, 16, 33, 33, 33, 13360 },
+			0, 16, 33, 33, 33, 13360 },
 		{ INVALID, INVALID, WLAN_RC_PHY_HT_40_DS, 54000, /* 54 Mb */
 			49800, 0x89, 0x00, 9,
-			2, 4, 3, 17, 34, 34, 34, 26720 },
+			2, 17, 34, 34, 34, 26720 },
 		{ INVALID, INVALID, WLAN_RC_PHY_HT_40_DS, 81000, /* 81 Mb */
 			71900, 0x8a, 0x00, 10,
-			2, 6, 3, 18, 35, 35, 35, 40080 },
+			2, 18, 35, 35, 35, 40080 },
 		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 108000, /* 108 Mb */
 			92500, 0x8b, 0x00, 11,
-			4, 10, 3, 19, 36, 36, 36, 53440 },
+			4,  19, 36, 36, 36, 53440 },
 		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 162000, /* 162 Mb */
 			130300, 0x8c, 0x00, 12,
-			4, 14, 3, 20, 37, 37, 37, 80160 },
+			4,  20, 37, 37, 37, 80160 },
 		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 216000, /* 216 Mb */
 			162800, 0x8d, 0x00, 13,
-			4, 20, 3, 21, 38, 38, 38, 106880 },
+			4,  21, 38, 38, 38, 106880 },
 		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 243000, /* 243 Mb */
 			178200, 0x8e, 0x00, 14,
-			4, 23, 3, 22, 39, 39, 39, 120240 },
+			4,  22, 39, 39, 39, 120240 },
 		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 270000, /* 270 Mb */
 			192100, 0x8f, 0x00, 15,
-			4, 25, 3, 23, 40, 41, 41, 133600 },
+			4,  23, 40, 41, 41, 133600 },
 		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS_HGI, 300000, /* 300 Mb */
 			207000, 0x8f, 0x00, 15,
-			4, 25, 3, 23, 40, 41, 41, 148400 },
+			4,  23, 40, 41, 41, 148400 },
 	},
 	50,  /* probe interval */
 	50,  /* rssi reduce interval */
@@ -160,142 +160,142 @@ static const struct ath_rate_table ar5416_11ng_ratetable = {
 	{
 		{ VALID_ALL, VALID_ALL, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
 			900, 0x1b, 0x00, 2,
-			0, 0, 1, 0, 0, 0, 0, 0 },
+			0, 0, 0, 0, 0, 0 },
 		{ VALID_ALL, VALID_ALL, WLAN_RC_PHY_CCK, 2000, /* 2 Mb */
 			1900, 0x1a, 0x04, 4,
-			1, 1, 1, 1, 1, 1, 1, 0 },
+			1, 1, 1, 1, 1, 0 },
 		{ VALID_ALL, VALID_ALL, WLAN_RC_PHY_CCK, 5500, /* 5.5 Mb */
 			4900, 0x19, 0x04, 11,
-			2, 2, 2, 2, 2, 2, 2, 0 },
+			2, 2, 2, 2, 2, 0 },
 		{ VALID_ALL, VALID_ALL, WLAN_RC_PHY_CCK, 11000, /* 11 Mb */
 			8100, 0x18, 0x04, 22,
-			3, 3, 2, 3, 3, 3, 3, 0 },
+			3, 3, 3, 3, 3, 0 },
 		{ INVALID, INVALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
 			5400, 0x0b, 0x00, 12,
-			4, 2, 1, 4, 4, 4, 4, 0 },
+			4, 4, 4, 4, 4, 0 },
 		{ INVALID, INVALID, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
 			7800, 0x0f, 0x00, 18,
-			4, 3, 1, 5, 5, 5, 5, 0 },
+			4, 5, 5, 5, 5, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
 			10100, 0x0a, 0x00, 24,
-			6, 4, 1, 6, 6, 6, 6, 0 },
+			6, 6, 6, 6, 6, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
 			14100,  0x0e, 0x00, 36,
-			6, 6, 2, 7, 7, 7, 7, 0 },
+			6, 7, 7, 7, 7, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
 			17700, 0x09, 0x00, 48,
-			8, 10, 3, 8, 8, 8, 8, 0 },
+			8,  8, 8, 8, 8, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
 			23700, 0x0d, 0x00, 72,
-			8, 14, 3, 9, 9, 9, 9, 0 },
+			8,  9, 9, 9, 9, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
 			27400, 0x08, 0x00, 96,
-			8, 20, 3, 10, 10, 10, 10, 0 },
+			8,  10, 10, 10, 10, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
 			30900, 0x0c, 0x00, 108,
-			8, 23, 3, 11, 11, 11, 11, 0 },
+			8,  11, 11, 11, 11, 0 },
 		{ INVALID, INVALID, WLAN_RC_PHY_HT_20_SS, 6500, /* 6.5 Mb */
 			6400, 0x80, 0x00, 0,
-			4, 2, 3, 12, 28, 12, 28, 3216 },
+			4, 12, 28, 12, 28, 3216 },
 		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 13000, /* 13 Mb */
 			12700, 0x81, 0x00, 1,
-			6, 4, 3, 13, 29, 13, 29, 6434 },
+			6, 13, 29, 13, 29, 6434 },
 		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 19500, /* 19.5 Mb */
 			18800, 0x82, 0x00, 2,
-			6, 6, 3, 14, 30, 14, 30, 9650 },
+			6, 14, 30, 14, 30, 9650 },
 		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 26000, /* 26 Mb */
 			25000, 0x83, 0x00, 3,
-			8, 10, 3, 15, 31, 15, 31, 12868 },
+			8,  15, 31, 15, 31, 12868 },
 		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 39000, /* 39 Mb */
 			36700, 0x84, 0x00, 4,
-			8, 14, 3, 16, 32, 16, 32, 19304 },
+			8,  16, 32, 16, 32, 19304 },
 		{ INVALID, VALID_20, WLAN_RC_PHY_HT_20_SS, 52000, /* 52 Mb */
 			48100, 0x85, 0x00, 5,
-			8, 20, 3, 17, 33, 17, 33, 25740 },
+			8,  17, 33, 17, 33, 25740 },
 		{ INVALID,  VALID_20, WLAN_RC_PHY_HT_20_SS, 58500, /* 58.5 Mb */
 			53500, 0x86, 0x00, 6,
-			8, 23, 3, 18, 34, 18, 34, 28956 },
+			8,  18, 34, 18, 34, 28956 },
 		{ INVALID, VALID_20, WLAN_RC_PHY_HT_20_SS, 65000, /* 65 Mb */
 			59000, 0x87, 0x00, 7,
-			8, 25, 3, 19, 35, 19, 36, 32180 },
+			8,  19, 35, 19, 36, 32180 },
 		{ INVALID, INVALID, WLAN_RC_PHY_HT_20_DS, 13000, /* 13 Mb */
 			12700, 0x88, 0x00, 8,
-			4, 2, 3, 20, 37, 20, 37, 6430 },
+			4, 20, 37, 20, 37, 6430 },
 		{ INVALID, INVALID, WLAN_RC_PHY_HT_20_DS, 26000, /* 26 Mb */
 			24800, 0x89, 0x00, 9,
-			6, 4, 3, 21, 38, 21, 38, 12860 },
+			6, 21, 38, 21, 38, 12860 },
 		{ INVALID, INVALID, WLAN_RC_PHY_HT_20_DS, 39000, /* 39 Mb */
 			36600, 0x8a, 0x00, 10,
-			6, 6, 3, 22, 39, 22, 39, 19300 },
+			6, 22, 39, 22, 39, 19300 },
 		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 52000, /* 52 Mb */
 			48100, 0x8b, 0x00, 11,
-			8, 10, 3, 23, 40, 23, 40, 25736 },
+			8,  23, 40, 23, 40, 25736 },
 		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 78000, /* 78 Mb */
 			69500, 0x8c, 0x00, 12,
-			8, 14, 3, 24, 41, 24, 41, 38600 },
+			8,  24, 41, 24, 41, 38600 },
 		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 104000, /* 104 Mb */
 			89500, 0x8d, 0x00, 13,
-			8, 20, 3, 25, 42, 25, 42, 51472 },
+			8,  25, 42, 25, 42, 51472 },
 		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 117000, /* 117 Mb */
 			98900, 0x8e, 0x00, 14,
-			8, 23, 3, 26, 43, 26, 44, 57890 },
+			8,  26, 43, 26, 44, 57890 },
 		{ VALID_20, INVALID, WLAN_RC_PHY_HT_20_DS, 130000, /* 130 Mb */
 			108300, 0x8f, 0x00, 15,
-			8, 25, 3, 27, 44, 27, 45, 64320 },
+			8,  27, 44, 27, 45, 64320 },
 		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 13500, /* 13.5 Mb */
 			13200, 0x80, 0x00, 0,
-			8, 2, 3, 12, 28, 28, 28, 6684 },
+			8, 12, 28, 28, 28, 6684 },
 		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 27500, /* 27.0 Mb */
 			25900, 0x81, 0x00, 1,
-			8, 4, 3, 13, 29, 29, 29, 13368 },
+			8, 13, 29, 29, 29, 13368 },
 		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 40500, /* 40.5 Mb */
 			38600, 0x82, 0x00, 2,
-			8, 6, 3, 14, 30, 30, 30, 20052 },
+			8, 14, 30, 30, 30, 20052 },
 		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 54000, /* 54 Mb */
 			49800, 0x83, 0x00, 3,
-			8, 10, 3, 15, 31, 31, 31, 26738 },
+			8,  15, 31, 31, 31, 26738 },
 		{ VALID_40, VALID_40, WLAN_RC_PHY_HT_40_SS, 81500, /* 81 Mb */
 			72200, 0x84, 0x00, 4,
-			8, 14, 3, 16, 32, 32, 32, 40104 },
+			8,  16, 32, 32, 32, 40104 },
 		{ INVALID, VALID_40, WLAN_RC_PHY_HT_40_SS, 108000, /* 108 Mb */
 			92900, 0x85, 0x00, 5,
-			8, 20, 3, 17, 33, 33, 33, 53476 },
+			8,  17, 33, 33, 33, 53476 },
 		{ INVALID,  VALID_40, WLAN_RC_PHY_HT_40_SS, 121500, /* 121.5 Mb */
 			102700, 0x86, 0x00, 6,
-			8, 23, 3, 18, 34, 34, 34, 60156 },
+			8,  18, 34, 34, 34, 60156 },
 		{ INVALID, VALID_40, WLAN_RC_PHY_HT_40_SS, 135000, /* 135 Mb */
 			112000, 0x87, 0x00, 7,
-			8, 23, 3, 19, 35, 36, 36, 66840 },
+			8,  19, 35, 36, 36, 66840 },
 		{ INVALID, VALID_40, WLAN_RC_PHY_HT_40_SS_HGI, 150000, /* 150 Mb */
 			122000, 0x87, 0x00, 7,
-			8, 25, 3, 19, 35, 36, 36, 74200 },
+			8,  19, 35, 36, 36, 74200 },
 		{ INVALID, INVALID, WLAN_RC_PHY_HT_40_DS, 27000, /* 27 Mb */
 			25800, 0x88, 0x00, 8,
-			8, 2, 3, 20, 37, 37, 37, 13360 },
+			8, 20, 37, 37, 37, 13360 },
 		{ INVALID, INVALID, WLAN_RC_PHY_HT_40_DS, 54000, /* 54 Mb */
 			49800, 0x89, 0x00, 9,
-			8, 4, 3, 21, 38, 38, 38, 26720 },
+			8, 21, 38, 38, 38, 26720 },
 		{ INVALID, INVALID, WLAN_RC_PHY_HT_40_DS, 81000, /* 81 Mb */
 			71900, 0x8a, 0x00, 10,
-			8, 6, 3, 22, 39, 39, 39, 40080 },
+			8, 22, 39, 39, 39, 40080 },
 		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 108000, /* 108 Mb */
 			92500, 0x8b, 0x00, 11,
-			8, 10, 3, 23, 40, 40, 40, 53440 },
+			8,  23, 40, 40, 40, 53440 },
 		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 162000, /* 162 Mb */
 			130300, 0x8c, 0x00, 12,
-			8, 14, 3, 24, 41, 41, 41, 80160 },
+			8,  24, 41, 41, 41, 80160 },
 		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 216000, /* 216 Mb */
 			162800, 0x8d, 0x00, 13,
-			8, 20, 3, 25, 42, 42, 42, 106880 },
+			8,  25, 42, 42, 42, 106880 },
 		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 243000, /* 243 Mb */
 			178200, 0x8e, 0x00, 14,
-			8, 23, 3, 26, 43, 43, 43, 120240 },
+			8,  26, 43, 43, 43, 120240 },
 		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS, 270000, /* 270 Mb */
 			192100, 0x8f, 0x00, 15,
-			8, 23, 3, 27, 44, 45, 45, 133600 },
+			8,  27, 44, 45, 45, 133600 },
 		{ VALID_40, INVALID, WLAN_RC_PHY_HT_40_DS_HGI, 300000, /* 300 Mb */
 			207000, 0x8f, 0x00, 15,
-			8, 25, 3, 27, 44, 45, 45, 148400 },
+			8,  27, 44, 45, 45, 148400 },
 		},
 	50,  /* probe interval */
 	50,  /* rssi reduce interval */
@@ -307,28 +307,28 @@ static const struct ath_rate_table ar5416_11a_ratetable = {
 	{
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
 			5400, 0x0b, 0x00, (0x80|12),
-			0, 2, 1, 0, 0 },
+			0, 0, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
 			7800, 0x0f, 0x00, 18,
-			0, 3, 1, 1, 0 },
+			0, 1, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
 			10000, 0x0a, 0x00, (0x80|24),
-			2, 4, 2, 2, 0 },
+			2, 2, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
 			13900, 0x0e, 0x00, 36,
-			2, 6, 2, 3, 0 },
+			2, 3, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
 			17300, 0x09, 0x00, (0x80|48),
-			4, 10, 3, 4, 0 },
+			4,  4, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
 			23000, 0x0d, 0x00, 72,
-			4, 14, 3, 5, 0 },
+			4,  5, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
 			27400, 0x08, 0x00, 96,
-			4, 19, 3, 6, 0 },
+			4,  6, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
 			29300, 0x0c, 0x00, 108,
-			4, 23, 3, 7, 0 },
+			4,  7, 0 },
 	},
 	50,  /* probe interval */
 	50,  /* rssi reduce interval */
@@ -340,40 +340,40 @@ static const struct ath_rate_table ar5416_11g_ratetable = {
 	{
 		{ VALID, VALID, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
 			900, 0x1b, 0x00, 2,
-			0, 0, 1, 0, 0 },
+			0, 0, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_CCK, 2000, /* 2 Mb */
 			1900, 0x1a, 0x04, 4,
-			1, 1, 1, 1, 0 },
+			1, 1, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_CCK, 5500, /* 5.5 Mb */
 			4900, 0x19, 0x04, 11,
-			2, 2, 2, 2, 0 },
+			2, 2, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_CCK, 11000, /* 11 Mb */
 			8100, 0x18, 0x04, 22,
-			3, 3, 2, 3, 0 },
+			3, 3, 0 },
 		{ INVALID, INVALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
 			5400, 0x0b, 0x00, 12,
-			4, 2, 1, 4, 0 },
+			4, 4, 0 },
 		{ INVALID, INVALID, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
 			7800, 0x0f, 0x00, 18,
-			4, 3, 1, 5, 0 },
+			4, 5, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
 			10000, 0x0a, 0x00, 24,
-			6, 4, 1, 6, 0 },
+			6, 6, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
 			13900, 0x0e, 0x00, 36,
-			6, 6, 2, 7, 0 },
+			6, 7, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
 			17300, 0x09, 0x00, 48,
-			8, 10, 3, 8, 0 },
+			8,  8, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
 			23000, 0x0d, 0x00, 72,
-			8, 14, 3, 9, 0 },
+			8,  9, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
 			27400, 0x08, 0x00, 96,
-			8, 19, 3, 10, 0 },
+			8,  10, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
 			29300, 0x0c, 0x00, 108,
-			8, 23, 3, 11, 0 },
+			8,  11, 0 },
 	},
 	50,  /* probe interval */
 	50,  /* rssi reduce interval */
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index e3abd76..6797df0 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -112,8 +112,6 @@ struct ath_rate_table {
 		u8 short_preamble;
 		u8 dot11rate;
 		u8 ctrl_rate;
-		int8_t rssi_ack_validmin;
-		int8_t rssi_ack_deltamin;
 		u8 base_index;
 		u8 cw40index;
 		u8 sgi_index;
@@ -126,7 +124,6 @@ struct ath_rate_table {
 };
 
 struct ath_tx_ratectrl_state {
-	int8_t rssi_thres;	/* required rssi for this rate (dB) */
 	u8 per;			/* recent estimate of packet error rate (%) */
 };
 
@@ -138,16 +135,7 @@ struct ath_rateset {
 /**
  * struct ath_rate_priv - Rate Control priv data
  * @state: RC state
- * @rssi_last: last ACK rssi
- * @rssi_last_lookup: last ACK rssi used for lookup
- * @rssi_last_prev: previous last ACK rssi
- * @rssi_last_prev2: 2nd previous last ACK rssi
- * @rssi_sum_cnt: count of rssi_sum for averaging
- * @rssi_sum_rate: rate that we are averaging
- * @rssi_sum: running sum of rssi for averaging
  * @probe_rate: rate we are probing at
- * @rssi_time: msec timestamp for last ack rssi
- * @rssi_down_time: msec timestamp for last down step
  * @probe_time: msec timestamp for last probe
  * @hw_maxretry_pktcnt: num of packets since we got HW max retry error
  * @max_valid_rate: maximum number of valid rate
@@ -161,13 +149,6 @@ struct ath_rateset {
  * @neg_ht_rates: Negotiated HT rates
  */
 struct ath_rate_priv {
-	int8_t rssi_last;
-	int8_t rssi_last_lookup;
-	int8_t rssi_last_prev;
-	int8_t rssi_last_prev2;
-	int32_t rssi_sum_cnt;
-	int32_t rssi_sum_rate;
-	int32_t rssi_sum;
 	u8 rate_table_size;
 	u8 probe_rate;
 	u8 hw_maxretry_pktcnt;
@@ -177,8 +158,6 @@ struct ath_rate_priv {
 	u8 valid_phy_ratecnt[WLAN_RC_PHY_MAX];
 	u8 valid_phy_rateidx[WLAN_RC_PHY_MAX][RATE_TABLE_SIZE];
 	u8 rate_max_phy;
-	u32 rssi_time;
-	u32 rssi_down_time;
 	u32 probe_time;
 	u32 per_down_time;
 	u32 probe_interval;
-- 
1.6.0.6

