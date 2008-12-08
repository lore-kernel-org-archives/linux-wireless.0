Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23963 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbYLHON4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 09:13:56 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2008 06:13:55 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 1/5] ath9k: Adding AR9285 chipset register information.
Date: Mon, 8 Dec 2008 19:43:46 +0530
Message-ID: <1228745630-6928-1-git-send-email-senthilkumar@atheros.com> (sfid-20081208_151359_712141_BB95AFEF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding AR9285 register information.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/reg.h |  109 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 108 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/reg.h b/drivers/net/wireless/ath9k/reg.h
index 60617ae..9fedb49 100644
--- a/drivers/net/wireless/ath9k/reg.h
+++ b/drivers/net/wireless/ath9k/reg.h
@@ -671,7 +671,11 @@
 #define AR_RC_APB            0x00000002
 #define AR_RC_HOSTIF         0x00000100
 
-#define AR_WA                0x4004
+#define AR_WA                		0x4004
+#define AR9285_WA_DEFAULT 		0x004a05cb
+#define AR9280_WA_DEFAULT           	0x0040073f
+#define AR_WA_DEFAULT               	0x0000073f
+
 
 #define AR_PM_STATE                 0x4008
 #define AR_PM_STATE_PME_D3COLD_VAUX 0x00100000
@@ -738,6 +742,8 @@
 #define AR_SREV_REVISION_9280_21            2
 #define AR_SREV_VERSION_9285                  0xC0
 #define AR_SREV_REVISION_9285_10              0
+#define AR_SREV_REVISION_9285_11              1
+#define AR_SREV_REVISION_9285_12              2
 
 #define AR_SREV_9100_OR_LATER(_ah) \
 	(((_ah)->ah_macVersion >= AR_SREV_VERSION_5416_PCIE))
@@ -768,6 +774,16 @@
 #define AR_SREV_9285(_ah) (((_ah)->ah_macVersion == AR_SREV_VERSION_9285))
 #define AR_SREV_9285_10_OR_LATER(_ah) \
 	(((_ah)->ah_macVersion >= AR_SREV_VERSION_9285))
+#define AR_SREV_9285_11(_ah) \
+	(AR_SREV_9280(ah) && ((_ah)->ah_macRev == AR_SREV_REVISION_9285_11))
+#define AR_SREV_9285_11_OR_LATER(_ah) \
+	(((_ah)->ah_macVersion > AR_SREV_VERSION_9285) || \
+	 (AR_SREV_9285(ah) && ((_ah)->ah_macRev >= AR_SREV_REVISION_9285_11)))
+#define AR_SREV_9285_12(_ah) \
+	(AR_SREV_9280(ah) && ((_ah)->ah_macRev == AR_SREV_REVISION_9285_12))
+#define AR_SREV_9285_12_OR_LATER(_ah) \
+	(((_ah)->ah_macVersion > AR_SREV_VERSION_9285) || \
+	 (AR_SREV_9285(ah) && ((_ah)->ah_macRev >= AR_SREV_REVISION_9285_12)))
 
 #define AR_RADIO_SREV_MAJOR                   0xf0
 #define AR_RAD5133_SREV_MAJOR                 0xc0
@@ -1017,6 +1033,97 @@ enum {
 #define AR_AN_SYNTH9_REFDIVA    0xf8000000
 #define AR_AN_SYNTH9_REFDIVA_S  27
 
+#define AR9285_AN_RF2G1              0x7820
+#define AR9285_AN_RF2G1_ENPACAL      0x00000800
+#define AR9285_AN_RF2G1_ENPACAL_S    11
+#define AR9285_AN_RF2G1_PDPADRV1     0x02000000
+#define AR9285_AN_RF2G1_PDPADRV1_S   25
+#define AR9285_AN_RF2G1_PDPADRV2     0x01000000
+#define AR9285_AN_RF2G1_PDPADRV2_S   24
+#define AR9285_AN_RF2G1_PDPAOUT      0x00800000
+#define AR9285_AN_RF2G1_PDPAOUT_S    23
+
+
+#define AR9285_AN_RF2G2              0x7824
+#define AR9285_AN_RF2G2_OFFCAL       0x00001000
+#define AR9285_AN_RF2G2_OFFCAL_S     12
+
+#define AR9285_AN_RF2G3             0x7828
+#define AR9285_AN_RF2G3_PDVCCOMP    0x02000000
+#define AR9285_AN_RF2G3_PDVCCOMP_S  25
+#define AR9285_AN_RF2G3_OB_0    0x00E00000
+#define AR9285_AN_RF2G3_OB_0_S    21
+#define AR9285_AN_RF2G3_OB_1    0x001C0000
+#define AR9285_AN_RF2G3_OB_1_S    18
+#define AR9285_AN_RF2G3_OB_2    0x00038000
+#define AR9285_AN_RF2G3_OB_2_S    15
+#define AR9285_AN_RF2G3_OB_3    0x00007000
+#define AR9285_AN_RF2G3_OB_3_S    12
+#define AR9285_AN_RF2G3_OB_4    0x00000E00
+#define AR9285_AN_RF2G3_OB_4_S    9
+
+#define AR9285_AN_RF2G3_DB1_0    0x000001C0
+#define AR9285_AN_RF2G3_DB1_0_S    6
+#define AR9285_AN_RF2G3_DB1_1    0x00000038
+#define AR9285_AN_RF2G3_DB1_1_S    3
+#define AR9285_AN_RF2G3_DB1_2    0x00000007
+#define AR9285_AN_RF2G3_DB1_2_S    0
+#define AR9285_AN_RF2G4         0x782C
+#define AR9285_AN_RF2G4_DB1_3    0xE0000000
+#define AR9285_AN_RF2G4_DB1_3_S    29
+#define AR9285_AN_RF2G4_DB1_4    0x1C000000
+#define AR9285_AN_RF2G4_DB1_4_S    26
+
+#define AR9285_AN_RF2G4_DB2_0    0x03800000
+#define AR9285_AN_RF2G4_DB2_0_S    23
+#define AR9285_AN_RF2G4_DB2_1    0x00700000
+#define AR9285_AN_RF2G4_DB2_1_S    20
+#define AR9285_AN_RF2G4_DB2_2    0x000E0000
+#define AR9285_AN_RF2G4_DB2_2_S    17
+#define AR9285_AN_RF2G4_DB2_3    0x0001C000
+#define AR9285_AN_RF2G4_DB2_3_S    14
+#define AR9285_AN_RF2G4_DB2_4    0x00003800
+#define AR9285_AN_RF2G4_DB2_4_S    11
+
+#define AR9285_AN_RF2G6                 0x7834
+#define AR9285_AN_RF2G6_CCOMP           0x00007800
+#define AR9285_AN_RF2G6_CCOMP_S         11
+#define AR9285_AN_RF2G6_OFFS            0x03f00000
+#define AR9285_AN_RF2G6_OFFS_S          20
+
+#define AR9285_AN_RF2G7                 0x7838
+#define AR9285_AN_RF2G7_PWDDB           0x00000002
+#define AR9285_AN_RF2G7_PWDDB_S         1
+#define AR9285_AN_RF2G7_PADRVGN2TAB0    0xE0000000
+#define AR9285_AN_RF2G7_PADRVGN2TAB0_S  29
+
+#define AR9285_AN_RF2G8                  0x783C
+#define AR9285_AN_RF2G8_PADRVGN2TAB0     0x0001C000
+#define AR9285_AN_RF2G8_PADRVGN2TAB0_S   14
+
+
+#define AR9285_AN_RF2G9          0x7840
+#define AR9285_AN_RXTXBB1              0x7854
+#define AR9285_AN_RXTXBB1_PDRXTXBB1    0x00000020
+#define AR9285_AN_RXTXBB1_PDRXTXBB1_S  5
+#define AR9285_AN_RXTXBB1_PDV2I        0x00000080
+#define AR9285_AN_RXTXBB1_PDV2I_S      7
+#define AR9285_AN_RXTXBB1_PDDACIF      0x00000100
+#define AR9285_AN_RXTXBB1_PDDACIF_S    8
+#define AR9285_AN_RXTXBB1_SPARE9       0x00000001
+#define AR9285_AN_RXTXBB1_SPARE9_S     0
+
+#define AR9285_AN_TOP2           0x7868
+
+#define AR9285_AN_TOP3                  0x786c
+#define AR9285_AN_TOP3_XPABIAS_LVL      0x0000000C
+#define AR9285_AN_TOP3_XPABIAS_LVL_S    2
+#define AR9285_AN_TOP3_PWDDAC           0x00800000
+#define AR9285_AN_TOP3_PWDDAC_S    23
+
+#define AR9285_AN_TOP4           0x7870
+#define AR9285_AN_TOP4_DEFAULT   0x10142c00
+
 #define AR_STA_ID0                 0x8000
 #define AR_STA_ID1                 0x8004
 #define AR_STA_ID1_SADH_MASK       0x0000FFFF
-- 
1.6.0.4

