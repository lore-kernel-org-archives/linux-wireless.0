Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33359 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967722Ab2EROHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 10:07:10 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 05/10] ath9k_hw: add AR9462 initval for Global WLAN, BT settings
Date: Fri, 18 May 2012 19:37:28 +0530
Message-ID: <1337350053-15491-5-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120518_160717_117187_32162F43)
In-Reply-To: <1337350053-15491-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1337350053-15491-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c           |    3 +++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c          |    3 +++
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h |    5 +++++
 drivers/net/wireless/ath/ath9k/hw.h                  |    2 +-
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index a0e3394..17e3703 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -305,6 +305,9 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 				ar9462_common_rx_gain_table_2p0,
 				ARRAY_SIZE(ar9462_common_rx_gain_table_2p0), 2);
 
+		INIT_INI_ARRAY(&ah->ini_glb_wlan_bt, ar9462_2p0_glb_wlan_bt,
+				ARRAY_SIZE(ar9462_2p0_glb_wlan_bt), 2);
+
 		/* Awake -> Sleep Setting */
 		INIT_INI_ARRAY(&ah->iniPcieSerdes,
 				PCIE_PLL_ON_CREQ_DIS_L1_2P0,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 11abb97..02dee90 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -676,6 +676,9 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 	if (chan->channel == 2484)
 		ar9003_hw_prog_ini(ah, &ah->ini_japan2484, 1);
 
+	if (AR_SREV_9462(ah))
+		ar9003_hw_prog_ini(ah, &ah->ini_glb_wlan_bt, 1);
+
 	ah->modes_index = modesIndex;
 	ar9003_hw_override_ini(ah);
 	ar9003_hw_set_channel_regs(ah, chan);
diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
index a10ece0..89032bb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -358,6 +358,11 @@ static const u32 ar9462_common_rx_gain_table_2p0[][2] = {
 	{0x0000b1fc, 0x00000196},
 };
 
+static const u32 ar9462_2p0_glb_wlan_bt[][2] = {
+	/* Addr      allmodes  */
+	{0x0002002c, 0x00000003},
+};
+
 static const u32 ar9462_pciephy_clkreq_disable_L1_2p0[][2] = {
 	/* Addr      allmodes  */
 	{0x00018c00, 0x18213ede},
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 3740aab..f807442 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -824,7 +824,7 @@ struct ath_hw {
 	struct ar5416IniArray ini_japan2484;
 	struct ar5416IniArray iniModes_9271_ANI_reg;
 	struct ar5416IniArray ini_radio_post_sys2ant;
-	struct ar5416IniArray ini_BTCOEX_MAX_TXPWR;
+	struct ar5416IniArray ini_glb_wlan_bt;
 
 	struct ar5416IniArray iniMac[ATH_INI_NUM_SPLIT];
 	struct ar5416IniArray iniBB[ATH_INI_NUM_SPLIT];
-- 
1.7.10.2

