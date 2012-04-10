Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60120 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759251Ab2DJPPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 11:15:11 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [WIP 06/11] ath9k_hw: INI changes for WoW for AR9002 chipsets
Date: Tue, 10 Apr 2012 20:43:16 +0530
Message-ID: <1334070801-21708-7-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120410_171521_522228_8C6AB867)
In-Reply-To: <1334070801-21708-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1334070801-21708-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

for AR9002 family of chipsets and for WoW sleep, we reprogram
the SerDes so that the PLL and CHK REQ are both enabled. this
uses more power but in certain cases this is required as otherwise
WoW sleep is unstable and chip may disappear.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c       |    5 +++++
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h |   14 ++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h              |    3 +++
 3 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index d9a69fc..65b604a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -47,6 +47,11 @@ static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 		INIT_INI_ARRAY(&ah->iniPcieSerdes,
 			   ar9280PciePhy_clkreq_always_on_L1_9280,
 			   ARRAY_SIZE(ar9280PciePhy_clkreq_always_on_L1_9280), 2);
+#ifdef CONFIG_PM_SLEEP
+		INIT_INI_ARRAY(&ah->iniPcieSerdesWow,
+			   ar9280PciePhy_awow,
+			   ARRAY_SIZE(ar9280PciePhy_awow), 2);
+#endif
 
 	if (AR_SREV_9287_11_OR_LATER(ah)) {
 		INIT_INI_ARRAY(&ah->iniModes, ar9287Modes_9287_1_1,
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
index 4d18c66..beb6162 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
@@ -925,6 +925,20 @@ static const u32 ar9280PciePhy_clkreq_always_on_L1_9280[][2] = {
 	{0x00004044, 0x00000000},
 };
 
+static const u32 ar9280PciePhy_awow[][2] = {
+	/* Addr      allmodes  */
+	{0x00004040, 0x9248fd00},
+	{0x00004040, 0x24924924},
+	{0x00004040, 0xa8000019},
+	{0x00004040, 0x13160820},
+	{0x00004040, 0xe5980560},
+	{0x00004040, 0xc01dcffd},
+	{0x00004040, 0x1aaabe41},
+	{0x00004040, 0xbe105554},
+	{0x00004040, 0x00043007},
+	{0x00004044, 0x00000000},
+};
+
 static const u32 ar9285Modes_9285_1_2[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160},
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index ce97b1e..ca770e4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -862,6 +862,9 @@ struct ath_hw {
 	struct ar5416IniArray iniBank7;
 	struct ar5416IniArray iniAddac;
 	struct ar5416IniArray iniPcieSerdes;
+#ifdef CONFIG_PM_SLEEP
+	struct ar5416IniArray iniPcieSerdesWow;
+#endif
 	struct ar5416IniArray iniPcieSerdesLowPower;
 	struct ar5416IniArray iniModesFastClock;
 	struct ar5416IniArray iniAdditional;
-- 
1.7.0.4

