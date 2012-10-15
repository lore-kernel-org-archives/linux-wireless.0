Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48799 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab2JONYD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 09:24:03 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <backports@vger.kernel.org>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>
Subject: [PATCH 3/3] compat-drivers: Add new cherry-pick and next-pending  patches
Date: Mon, 15 Oct 2012 18:52:18 +0530
Message-ID: <1350307338-8133-4-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20121015_152416_234533_92970C90)
In-Reply-To: <1350307338-8133-1-git-send-email-bkamatch@qca.qualcomm.com>
References: <1350307338-8133-1-git-send-email-bkamatch@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 ...81-ath9k-Fix-BTCOEX-weight-initialization.patch | 176 +++++++++++++++++++++
 ...01-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch |  34 ++++
 ...2-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch |  28 ++++
 ...ppropriate-bit-for-AR9565-in-btc-control-.patch |  33 ++++
 ...off-RXIQ-calibration-while-re-calibrating.patch |  46 ++++++
 ...sable-MCI-stat-counter-by-default-for-AR9.patch |  34 ++++
 ...0006-ath9k_hw-Fix-frequent-BT-rx-recovery.patch |  66 ++++++++
 ...-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch |  28 ++++
 ...nfigure-new-switch-table-for-AR9565-BTCOE.patch |  47 ++++++
 ...th9k_hw-Set-default-MCI-config-for-AR9565.patch |  21 +++
 ...ust-duty-cycle-for-FTP-profile-for-AR9565.patch |  21 +++
 ...-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch |  44 ++++++
 ...012-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch |  63 ++++++++
 13 files changed, 641 insertions(+)
 create mode 100644 linux-next-cherry-picks/0081-ath9k-Fix-BTCOEX-weight-initialization.patch
 create mode 100644 linux-next-pending/0001-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch
 create mode 100644 linux-next-pending/0002-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch
 create mode 100644 linux-next-pending/0003-ath9k-Set-appropriate-bit-for-AR9565-in-btc-control-.patch
 create mode 100644 linux-next-pending/0004-ath9k-turn-off-RXIQ-calibration-while-re-calibrating.patch
 create mode 100644 linux-next-pending/0005-ath9k_hw-Disable-MCI-stat-counter-by-default-for-AR9.patch
 create mode 100644 linux-next-pending/0006-ath9k_hw-Fix-frequent-BT-rx-recovery.patch
 create mode 100644 linux-next-pending/0007-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch
 create mode 100644 linux-next-pending/0008-ath9k_hw-Configure-new-switch-table-for-AR9565-BTCOE.patch
 create mode 100644 linux-next-pending/0009-ath9k_hw-Set-default-MCI-config-for-AR9565.patch
 create mode 100644 linux-next-pending/0010-ath9k-adjust-duty-cycle-for-FTP-profile-for-AR9565.patch
 create mode 100644 linux-next-pending/0011-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch
 create mode 100644 linux-next-pending/0012-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch

diff --git a/linux-next-cherry-picks/0081-ath9k-Fix-BTCOEX-weight-initialization.patch b/linux-next-cherry-picks/0081-ath9k-Fix-BTCOEX-weight-initialization.patch
new file mode 100644
index 0000000..037da36
--- /dev/null
+++ b/linux-next-cherry-picks/0081-ath9k-Fix-BTCOEX-weight-initialization.patch
@@ -0,0 +1,176 @@
+From 5160b46f3e53c41c4c6b9e7cdbe0401d3afbfb63 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Fri, 28 Sep 2012 11:13:51 +0530
+Subject: [PATCH] ath9k: Fix BTCOEX weight initialization
+
+The WLAN/BT weights have to set correctly before BTCOEX
+is initialized. Currently, this is not done for all chips
+in the AR9003 family. This patch fixes this issue by setting
+the weights in the init path. While at it, rename ar9462_wlan_weights
+to mci_wlan_weights since it is common to both AR9462 and AR9565.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/btcoex.c       | 61 ++++++++++++++-------------
+ drivers/net/wireless/ath/ath9k/btcoex.h       |  3 +-
+ drivers/net/wireless/ath/ath9k/gpio.c         |  5 ++-
+ drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |  2 +-
+ 4 files changed, 39 insertions(+), 32 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
+index 4ef610e..419e9a3 100644
+--- a/drivers/net/wireless/ath/ath9k/btcoex.c
++++ b/drivers/net/wireless/ath/ath9k/btcoex.c
+@@ -43,8 +43,8 @@ static const u32 ar9003_wlan_weights[ATH_BTCOEX_STOMP_MAX]
+ 	{ 0x00000000, 0x00000000, 0x00000000, 0x00000000 }, /* STOMP_NONE */
+ };
+ 
+-static const u32 ar9462_wlan_weights[ATH_BTCOEX_STOMP_MAX]
+-				    [AR9300_NUM_WLAN_WEIGHTS] = {
++static const u32 mci_wlan_weights[ATH_BTCOEX_STOMP_MAX]
++				 [AR9300_NUM_WLAN_WEIGHTS] = {
+ 	{ 0x01017d01, 0x41414101, 0x41414101, 0x41414141 }, /* STOMP_ALL */
+ 	{ 0x01017d01, 0x3b3b3b01, 0x3b3b3b01, 0x3b3b3b3b }, /* STOMP_LOW */
+ 	{ 0x01017d01, 0x01010101, 0x01010101, 0x01010101 }, /* STOMP_NONE */
+@@ -208,14 +208,37 @@ static void ath9k_hw_btcoex_enable_2wire(struct ath_hw *ah)
+ 			    AR_GPIO_OUTPUT_MUX_AS_TX_FRAME);
+ }
+ 
++/*
++ * For AR9002, bt_weight/wlan_weight are used.
++ * For AR9003 and above, stomp_type is used.
++ */
+ void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
+ 				u32 bt_weight,
+-				u32 wlan_weight)
++				u32 wlan_weight,
++				enum ath_stomp_type stomp_type)
+ {
+ 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+ 
+-	btcoex_hw->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
+-				     SM(wlan_weight, AR_BTCOEX_WL_WGHT);
++	if (AR_SREV_9300_20_OR_LATER(ah)) {
++		const u32 *weight = ar9003_wlan_weights[stomp_type];
++		int i;
++
++		if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
++			if ((stomp_type == ATH_BTCOEX_STOMP_LOW) &&
++			    btcoex_hw->mci.stomp_ftp)
++				stomp_type = ATH_BTCOEX_STOMP_LOW_FTP;
++			weight = mci_wlan_weights[stomp_type];
++		}
++
++		for (i = 0; i < AR9300_NUM_WLAN_WEIGHTS; i++) {
++			btcoex_hw->bt_weight[i] = AR9300_BT_WGHT;
++			btcoex_hw->wlan_weight[i] = weight[i];
++		}
++	} else {
++		btcoex_hw->bt_coex_weights =
++			SM(bt_weight, AR_BTCOEX_BT_WGHT) |
++			SM(wlan_weight, AR_BTCOEX_WL_WGHT);
++	}
+ }
+ EXPORT_SYMBOL(ath9k_hw_btcoex_set_weight);
+ 
+@@ -332,26 +355,6 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
+ }
+ EXPORT_SYMBOL(ath9k_hw_btcoex_disable);
+ 
+-static void ar9003_btcoex_bt_stomp(struct ath_hw *ah,
+-			 enum ath_stomp_type stomp_type)
+-{
+-	struct ath_btcoex_hw *btcoex = &ah->btcoex_hw;
+-	const u32 *weight = ar9003_wlan_weights[stomp_type];
+-	int i;
+-
+-	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
+-		if ((stomp_type == ATH_BTCOEX_STOMP_LOW) &&
+-		    btcoex->mci.stomp_ftp)
+-			stomp_type = ATH_BTCOEX_STOMP_LOW_FTP;
+-		weight = ar9462_wlan_weights[stomp_type];
+-	}
+-
+-	for (i = 0; i < AR9300_NUM_WLAN_WEIGHTS; i++) {
+-		btcoex->bt_weight[i] = AR9300_BT_WGHT;
+-		btcoex->wlan_weight[i] = weight[i];
+-	}
+-}
+-
+ /*
+  * Configures appropriate weight based on stomp type.
+  */
+@@ -359,22 +362,22 @@ void ath9k_hw_btcoex_bt_stomp(struct ath_hw *ah,
+ 			      enum ath_stomp_type stomp_type)
+ {
+ 	if (AR_SREV_9300_20_OR_LATER(ah)) {
+-		ar9003_btcoex_bt_stomp(ah, stomp_type);
++		ath9k_hw_btcoex_set_weight(ah, 0, 0, stomp_type);
+ 		return;
+ 	}
+ 
+ 	switch (stomp_type) {
+ 	case ATH_BTCOEX_STOMP_ALL:
+ 		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+-				AR_STOMP_ALL_WLAN_WGHT);
++					   AR_STOMP_ALL_WLAN_WGHT, 0);
+ 		break;
+ 	case ATH_BTCOEX_STOMP_LOW:
+ 		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+-				AR_STOMP_LOW_WLAN_WGHT);
++					   AR_STOMP_LOW_WLAN_WGHT, 0);
+ 		break;
+ 	case ATH_BTCOEX_STOMP_NONE:
+ 		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+-				AR_STOMP_NONE_WLAN_WGHT);
++					   AR_STOMP_NONE_WLAN_WGHT, 0);
+ 		break;
+ 	default:
+ 		ath_dbg(ath9k_hw_common(ah), BTCOEX, "Invalid Stomptype\n");
+diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
+index 20092f9..385197a 100644
+--- a/drivers/net/wireless/ath/ath9k/btcoex.h
++++ b/drivers/net/wireless/ath/ath9k/btcoex.h
+@@ -107,7 +107,8 @@ void ath9k_hw_btcoex_init_mci(struct ath_hw *ah);
+ void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum);
+ void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
+ 				u32 bt_weight,
+-				u32 wlan_weight);
++				u32 wlan_weight,
++				enum ath_stomp_type stomp_type);
+ void ath9k_hw_btcoex_disable(struct ath_hw *ah);
+ void ath9k_hw_btcoex_bt_stomp(struct ath_hw *ah,
+ 			      enum ath_stomp_type stomp_type);
+diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
+index 5faa4f7..d9ed141 100644
+--- a/drivers/net/wireless/ath/ath9k/gpio.c
++++ b/drivers/net/wireless/ath/ath9k/gpio.c
+@@ -395,7 +395,10 @@ void ath9k_start_btcoex(struct ath_softc *sc)
+ 	    !ah->btcoex_hw.enabled) {
+ 		if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
+ 			ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+-						   AR_STOMP_LOW_WLAN_WGHT);
++						   AR_STOMP_LOW_WLAN_WGHT, 0);
++		else
++			ath9k_hw_btcoex_set_weight(ah, 0, 0,
++						   ATH_BTCOEX_STOMP_NONE);
+ 		ath9k_hw_btcoex_enable(ah);
+ 
+ 		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
+diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+index 8fd64a6..0eacfc1 100644
+--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
++++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+@@ -161,7 +161,7 @@ void ath9k_htc_start_btcoex(struct ath9k_htc_priv *priv)
+ 
+ 	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE) {
+ 		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+-					   AR_STOMP_LOW_WLAN_WGHT);
++					   AR_STOMP_LOW_WLAN_WGHT, 0);
+ 		ath9k_hw_btcoex_enable(ah);
+ 		ath_htc_resume_btcoex_work(priv);
+ 	}
+-- 
+1.7.11.4
+
diff --git a/linux-next-pending/0001-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch b/linux-next-pending/0001-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch
new file mode 100644
index 0000000..8f3e87c
--- /dev/null
+++ b/linux-next-pending/0001-ath9k_hw-Enable-OSLA-hw-fix-for-AR9565.patch
@@ -0,0 +1,34 @@
+From 09504f1ccb52e865e1be861db9c7c1adbf206614 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:45 +0530
+Subject: [PATCH 01/11] ath9k_hw: Enable OSLA hw fix for AR9565
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c |    3 +++
+ drivers/net/wireless/ath/ath9k/reg.h        |    4 ++++
+ 2 files changed, 7 insertions(+), 0 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -799,6 +799,9 @@ static void ar9003_mci_osla_setup(struct
+ 	REG_RMW_FIELD(ah, AR_MCI_SCHD_TABLE_2,
+ 		      AR_MCI_SCHD_TABLE_2_MEM_BASED, 1);
+ 
++	if (AR_SREV_9565(ah))
++		REG_RMW_FIELD(ah, AR_MCI_MISC, AR_MCI_MISC_HW_FIX_EN, 1);
++
+ 	if (!(mci->config & ATH_MCI_CONFIG_DISABLE_AGGR_THRESH)) {
+ 		thresh = MS(mci->config, ATH_MCI_CONFIG_AGGR_THRESH);
+ 		REG_RMW_FIELD(ah, AR_BTCOEX_CTRL,
+--- a/drivers/net/wireless/ath/ath9k/reg.h
++++ b/drivers/net/wireless/ath/ath9k/reg.h
+@@ -2360,4 +2360,8 @@ enum {
+ #define AR_GLB_SWREG_DISCONT_MODE         0x2002c
+ #define AR_GLB_SWREG_DISCONT_EN_BT_WLAN   0x3
+ 
++#define AR_MCI_MISC                    0x1a74
++#define AR_MCI_MISC_HW_FIX_EN          0x00000001
++#define AR_MCI_MISC_HW_FIX_EN_S        0
++
+ #endif
diff --git a/linux-next-pending/0002-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch b/linux-next-pending/0002-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch
new file mode 100644
index 0000000..84f3447
--- /dev/null
+++ b/linux-next-pending/0002-ath9k_hw-Fix-selfgen-chainmask-for-9565.patch
@@ -0,0 +1,28 @@
+From 9f477777f199e21ecdeea4df1244f55495827ffe Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:46 +0530
+Subject: [PATCH 02/11] ath9k_hw: Fix selfgen chainmask for 9565
+
+Self generated MCI messages is configured to use chain 1. As
+ar9565 is 1x1 solution, It can not use Chain 1. Hence fix
+Chain 1 for ar9462 alone. Not doing so, could affect WLAN
+connectivity in ar9565 as LNA sharing is not informed by BT.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c |    4 +++-
+ 1 files changed, 3 insertions(+), 1 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -1031,7 +1031,9 @@ void ar9003_mci_2g5g_switch(struct ath_h
+ 
+ 		if (!(mci->config & ATH_MCI_CONFIG_DISABLE_OSLA))
+ 			ar9003_mci_osla_setup(ah, true);
+-		REG_WRITE(ah, AR_SELFGEN_MASK, 0x02);
++
++		if (AR_SREV_9462(ah))
++			REG_WRITE(ah, AR_SELFGEN_MASK, 0x02);
+ 	} else {
+ 		ar9003_mci_send_lna_take(ah, true);
+ 		udelay(5);
diff --git a/linux-next-pending/0003-ath9k-Set-appropriate-bit-for-AR9565-in-btc-control-.patch b/linux-next-pending/0003-ath9k-Set-appropriate-bit-for-AR9565-in-btc-control-.patch
new file mode 100644
index 0000000..329a901
--- /dev/null
+++ b/linux-next-pending/0003-ath9k-Set-appropriate-bit-for-AR9565-in-btc-control-.patch
@@ -0,0 +1,33 @@
+From cd8098a5ee084ea3b41f2891e0a5340271988f0d Mon Sep 17 00:00:00 2001
+From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:47 +0530
+Subject: [PATCH 03/11] ath9k: Set appropriate bit for AR9565 in btc control register
+
+Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c |   11 +++++++++--
+ 1 files changed, 9 insertions(+), 2 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -850,11 +850,18 @@ int ar9003_mci_reset(struct ath_hw *ah,
+ 		 SM(1, AR_BTCOEX_CTRL_WBTIMER_EN) |
+ 		 SM(1, AR_BTCOEX_CTRL_PA_SHARED) |
+ 		 SM(1, AR_BTCOEX_CTRL_LNA_SHARED) |
+-		 SM(2, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
+-		 SM(3, AR_BTCOEX_CTRL_RX_CHAIN_MASK) |
+ 		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_ACK) |
+ 		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_BCN) |
+ 		 SM(0, AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
++	if (AR_SREV_9565(ah)) {
++		regval |= SM(1, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
++			  SM(1, AR_BTCOEX_CTRL_RX_CHAIN_MASK);
++		REG_RMW_FIELD(ah, AR_BTCOEX_CTRL2,
++			      AR_BTCOEX_CTRL2_TX_CHAIN_MASK, 0x1);
++	} else {
++		regval |= SM(2, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
++			  SM(3, AR_BTCOEX_CTRL_RX_CHAIN_MASK);
++	}
+ 
+ 	REG_WRITE(ah, AR_BTCOEX_CTRL, regval);
+ 
diff --git a/linux-next-pending/0004-ath9k-turn-off-RXIQ-calibration-while-re-calibrating.patch b/linux-next-pending/0004-ath9k-turn-off-RXIQ-calibration-while-re-calibrating.patch
new file mode 100644
index 0000000..9e9819a
--- /dev/null
+++ b/linux-next-pending/0004-ath9k-turn-off-RXIQ-calibration-while-re-calibrating.patch
@@ -0,0 +1,46 @@
+From f090327eec6875ce4302173f1638a37b9a5d47b8 Mon Sep 17 00:00:00 2001
+From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:48 +0530
+Subject: [PATCH 04/11] ath9k: turn off RXIQ calibration while re-calibrating radio
+
+TXIQ and RXIQ share the same data path to upload the measurement
+result, we should turn off RXIQ calibration while re-calibrating radio
+
+Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c |    6 ++++++
+ drivers/net/wireless/ath/ath9k/ar9003_phy.h |    1 +
+ 2 files changed, 7 insertions(+), 0 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -750,6 +750,9 @@ int ar9003_mci_end_reset(struct ath_hw *
+ 
+ 	mci_hw->bt_state = MCI_BT_AWAKE;
+ 
++	REG_CLR_BIT(ah, AR_PHY_TIMING4,
++		    1 << AR_PHY_TIMING_CONTROL4_DO_GAIN_DC_IQ_CAL_SHIFT);
++
+ 	if (caldata) {
+ 		caldata->done_txiqcal_once = false;
+ 		caldata->done_txclcal_once = false;
+@@ -759,6 +762,9 @@ int ar9003_mci_end_reset(struct ath_hw *
+ 	if (!ath9k_hw_init_cal(ah, chan))
+ 		return -EIO;
+ 
++	REG_SET_BIT(ah, AR_PHY_TIMING4,
++		    1 << AR_PHY_TIMING_CONTROL4_DO_GAIN_DC_IQ_CAL_SHIFT);
++
+ exit:
+ 	ar9003_mci_enable_interrupt(ah);
+ 	return 0;
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+@@ -32,6 +32,7 @@
+ #define AR_PHY_SPUR_REG     (AR_CHAN_BASE + 0x1c)
+ #define AR_PHY_RX_IQCAL_CORR_B0    (AR_CHAN_BASE + 0xdc)
+ #define AR_PHY_TX_IQCAL_CONTROL_3  (AR_CHAN_BASE + 0xb0)
++#define AR_PHY_TIMING_CONTROL4_DO_GAIN_DC_IQ_CAL_SHIFT 16
+ 
+ #define AR_PHY_TIMING11_SPUR_FREQ_SD    0x3FF00000
+ #define AR_PHY_TIMING11_SPUR_FREQ_SD_S  20
diff --git a/linux-next-pending/0005-ath9k_hw-Disable-MCI-stat-counter-by-default-for-AR9.patch b/linux-next-pending/0005-ath9k_hw-Disable-MCI-stat-counter-by-default-for-AR9.patch
new file mode 100644
index 0000000..1d59f1f
--- /dev/null
+++ b/linux-next-pending/0005-ath9k_hw-Disable-MCI-stat-counter-by-default-for-AR9.patch
@@ -0,0 +1,34 @@
+From 7b608d7a012d967f08e8500c3e38b94d28daa4c6 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:49 +0530
+Subject: [PATCH 05/11] ath9k_hw: Disable MCI stat counter by default for AR9565
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c |    3 +++
+ drivers/net/wireless/ath/ath9k/reg.h        |    3 +++
+ 2 files changed, 6 insertions(+), 0 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -926,6 +926,9 @@ int ar9003_mci_reset(struct ath_hw *ah,
+ 	mci->ready = true;
+ 	ar9003_mci_prep_interface(ah);
+ 
++	if (AR_SREV_9565(ah))
++		REG_RMW_FIELD(ah, AR_MCI_DBG_CNT_CTRL,
++			      AR_MCI_DBG_CNT_CTRL_ENABLE, 0);
+ 	if (en_int)
+ 		ar9003_mci_enable_interrupt(ah);
+ 
+--- a/drivers/net/wireless/ath/ath9k/reg.h
++++ b/drivers/net/wireless/ath/ath9k/reg.h
+@@ -2363,5 +2363,8 @@ enum {
+ #define AR_MCI_MISC                    0x1a74
+ #define AR_MCI_MISC_HW_FIX_EN          0x00000001
+ #define AR_MCI_MISC_HW_FIX_EN_S        0
++#define AR_MCI_DBG_CNT_CTRL            0x1a78
++#define AR_MCI_DBG_CNT_CTRL_ENABLE     0x00000001
++#define AR_MCI_DBG_CNT_CTRL_ENABLE_S   0
+ 
+ #endif
diff --git a/linux-next-pending/0006-ath9k_hw-Fix-frequent-BT-rx-recovery.patch b/linux-next-pending/0006-ath9k_hw-Fix-frequent-BT-rx-recovery.patch
new file mode 100644
index 0000000..0067334
--- /dev/null
+++ b/linux-next-pending/0006-ath9k_hw-Fix-frequent-BT-rx-recovery.patch
@@ -0,0 +1,66 @@
+From 56e95424248ae3a3f5dd92bdd7ae0446ea3776ba Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 17:31:41 +0530
+Subject: [PATCH 06/11] ath9k_hw: Fix frequent BT rx recovery
+
+While resuming from S3, BT host issues HCI reset command and it
+causes BT firmware to busy with security key calculation. At this
+movement, WLAN detects MCI hardware error of MCI_CONT_INFO_TIMEOUT
+and then it starts the recovery sequence repeatedly. Too many
+recovery sequences would exhaust the BT kernel message pool. This
+patch imposes a duration between consecutive BT recovery procedure.
+Thus it solves BT firmware panic issue reported in AR9565.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c |   10 +++++++++-
+ drivers/net/wireless/ath/ath9k/ar9003_mci.h |    1 +
+ drivers/net/wireless/ath/ath9k/btcoex.h     |    1 +
+ 3 files changed, 11 insertions(+), 1 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -1191,7 +1191,7 @@ EXPORT_SYMBOL(ar9003_mci_cleanup);
+ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type)
+ {
+ 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
+-	u32 value = 0;
++	u32 value = 0, tsf;
+ 	u8 query_type;
+ 
+ 	switch (state_type) {
+@@ -1249,6 +1249,14 @@ u32 ar9003_mci_state(struct ath_hw *ah,
+ 		ar9003_mci_send_coex_bt_status_query(ah, true, query_type);
+ 		break;
+ 	case MCI_STATE_RECOVER_RX:
++		tsf = ath9k_hw_gettsf32(ah);
++		if ((tsf - mci->last_recovery) <= MCI_RECOVERY_DUR_TSF) {
++			ath_dbg(ath9k_hw_common(ah), MCI,
++				"(MCI) ignore Rx recovery\n");
++			break;
++		}
++		ath_dbg(ath9k_hw_common(ah), MCI, "(MCI) RECOVER RX\n");
++		mci->last_recovery = tsf;
+ 		ar9003_mci_prep_interface(ah);
+ 		mci->query_bt = true;
+ 		mci->need_flush_btinfo = true;
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+@@ -18,6 +18,7 @@
+ #define AR9003_MCI_H
+ 
+ #define MCI_FLAG_DISABLE_TIMESTAMP      0x00000001      /* Disable time stamp */
++#define MCI_RECOVERY_DUR_TSF		(100 * 1000)    /* 100 ms */
+ 
+ /* Default remote BT device MCI COEX version */
+ #define MCI_GPM_COEX_MAJOR_VERSION_DEFAULT  3
+--- a/drivers/net/wireless/ath/ath9k/btcoex.h
++++ b/drivers/net/wireless/ath/ath9k/btcoex.h
+@@ -84,6 +84,7 @@ struct ath9k_hw_mci {
+ 	u8 bt_ver_minor;
+ 	u8 bt_state;
+ 	u8 stomp_ftp;
++	u32 last_recovery;
+ };
+ 
+ struct ath_btcoex_hw {
diff --git a/linux-next-pending/0007-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch b/linux-next-pending/0007-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch
new file mode 100644
index 0000000..1ac6f84
--- /dev/null
+++ b/linux-next-pending/0007-ath9k_hw-Fix-max-rx-rate-drop-for-AR9565.patch
@@ -0,0 +1,28 @@
+From f02b45dc2aa6022765a18cea7ce6acff31f59897 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:51 +0530
+Subject: [PATCH 07/11] ath9k_hw: Fix max rx rate drop for AR9565
+
+Whenever i_coff of IQ calibration is too high, AR9565 drops max
+rx rate to MCS4. Skipping IQ update at this time can avoid this
+problem for AR9565.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_calib.c |    5 +++++
+ 1 files changed, 5 insertions(+), 0 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+@@ -276,6 +276,11 @@ static void ar9003_hw_iqcalibrate(struct
+ 				offset_array[i],
+ 				REG_READ(ah, offset_array[i]));
+ 
++			if (AR_SREV_9565(ah) &&
++			    (iCoff == 63 || qCoff == 63 ||
++			     iCoff == -63 || qCoff == -63))
++				return;
++
+ 			REG_RMW_FIELD(ah, offset_array[i],
+ 				      AR_PHY_RX_IQCAL_CORR_IQCORR_Q_I_COFF,
+ 				      iCoff);
diff --git a/linux-next-pending/0008-ath9k_hw-Configure-new-switch-table-for-AR9565-BTCOE.patch b/linux-next-pending/0008-ath9k_hw-Configure-new-switch-table-for-AR9565-BTCOE.patch
new file mode 100644
index 0000000..2ae2a1d
--- /dev/null
+++ b/linux-next-pending/0008-ath9k_hw-Configure-new-switch-table-for-AR9565-BTCOE.patch
@@ -0,0 +1,47 @@
+From 2413be8ff29842ba6404dc69e353f481aa7e6f87 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:52 +0530
+Subject: [PATCH 08/11] ath9k_hw: Configure new switch table for AR9565 BTCOEX
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
+ drivers/net/wireless/ath/ath9k/reg.h           |    4 ----
+ drivers/net/wireless/ath/ath9k/wow.c           |    2 +-
+ 3 files changed, 2 insertions(+), 6 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+@@ -3601,7 +3601,7 @@ static void ar9003_hw_ant_ctrl_apply(str
+ 	 *   7:4 R/W  SWITCH_TABLE_COM_SPDT_WLAN_IDLE
+ 	 * SWITCH_TABLE_COM_SPDT_WLAN_IDLE
+ 	 */
+-	if (AR_SREV_9462_20_OR_LATER(ah)) {
++	if (AR_SREV_9462_20(ah) || AR_SREV_9565(ah)) {
+ 		value = ar9003_switch_com_spdt_get(ah, is2ghz);
+ 		REG_RMW_FIELD(ah, AR_PHY_GLB_CONTROL,
+ 				AR_SWITCH_TABLE_COM_SPDT_ALL, value);
+--- a/drivers/net/wireless/ath/ath9k/reg.h
++++ b/drivers/net/wireless/ath/ath9k/reg.h
+@@ -907,10 +907,6 @@
+ 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
+ 	((_ah)->hw_version.macRev == AR_SREV_REVISION_9462_20))
+ 
+-#define AR_SREV_9462_20_OR_LATER(_ah) \
+-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
+-	((_ah)->hw_version.macRev >= AR_SREV_REVISION_9462_20))
+-
+ #define AR_SREV_9565(_ah) \
+ 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565))
+ 
+--- a/drivers/net/wireless/ath/ath9k/wow.c
++++ b/drivers/net/wireless/ath/ath9k/wow.c
+@@ -118,7 +118,7 @@ static void ath9k_wow_create_keep_alive_
+ 		       (ap_mac_addr[1] << 8) | (ap_mac_addr[0]);
+ 	data_word[5] = (ap_mac_addr[5] << 8) | (ap_mac_addr[4]);
+ 
+-	if (AR_SREV_9462_20_OR_LATER(ah)) {
++	if (AR_SREV_9462_20(ah)) {
+ 		/* AR9462 2.0 has an extra descriptor word (time based
+ 		 * discard) compared to other chips */
+ 		REG_WRITE(ah, (AR_WOW_KA_DESC_WORD2 + (12 * 4)), 0);
diff --git a/linux-next-pending/0009-ath9k_hw-Set-default-MCI-config-for-AR9565.patch b/linux-next-pending/0009-ath9k_hw-Set-default-MCI-config-for-AR9565.patch
new file mode 100644
index 0000000..687c8db
--- /dev/null
+++ b/linux-next-pending/0009-ath9k_hw-Set-default-MCI-config-for-AR9565.patch
@@ -0,0 +1,21 @@
+From 1e902624bc2de514eb4931950fb0533010246ae8 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:53 +0530
+Subject: [PATCH 09/11] ath9k_hw: Set default MCI config for AR9565
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/btcoex.c |    2 +-
+ 1 files changed, 1 insertions(+), 1 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/btcoex.c
++++ b/drivers/net/wireless/ath/ath9k/btcoex.c
+@@ -195,7 +195,7 @@ void ath9k_hw_btcoex_init_mci(struct ath
+ 	ah->btcoex_hw.mci.need_flush_btinfo = false;
+ 	ah->btcoex_hw.mci.wlan_cal_seq = 0;
+ 	ah->btcoex_hw.mci.wlan_cal_done = 0;
+-	ah->btcoex_hw.mci.config = 0x2201;
++	ah->btcoex_hw.mci.config = (AR_SREV_9462(ah)) ? 0x2201 : 0xa4c1;
+ }
+ EXPORT_SYMBOL(ath9k_hw_btcoex_init_mci);
+ 
diff --git a/linux-next-pending/0010-ath9k-adjust-duty-cycle-for-FTP-profile-for-AR9565.patch b/linux-next-pending/0010-ath9k-adjust-duty-cycle-for-FTP-profile-for-AR9565.patch
new file mode 100644
index 0000000..24bfd02
--- /dev/null
+++ b/linux-next-pending/0010-ath9k-adjust-duty-cycle-for-FTP-profile-for-AR9565.patch
@@ -0,0 +1,21 @@
+From 31a829f68f4d5f36ea5513b3d4924c5ba372dfc8 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:54 +0530
+Subject: [PATCH 10/11] ath9k: adjust duty cycle for FTP profile for AR9565
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/mci.c |    2 +-
+ 1 files changed, 1 insertions(+), 1 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/mci.c
++++ b/drivers/net/wireless/ath/ath9k/mci.c
+@@ -150,7 +150,7 @@ static void ath_mci_update_scheme(struct
+ 			 * For single PAN/FTP profile, allocate 35% for BT
+ 			 * to improve WLAN throughput.
+ 			 */
+-			btcoex->duty_cycle = 35;
++			btcoex->duty_cycle = AR_SREV_9565(sc->sc_ah) ? 40 : 35;
+ 			btcoex->btcoex_period = 53;
+ 			ath_dbg(common, MCI,
+ 				"Single PAN/FTP bt period %d ms dutycycle %d\n",
diff --git a/linux-next-pending/0011-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch b/linux-next-pending/0011-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch
new file mode 100644
index 0000000..2d4d4f1
--- /dev/null
+++ b/linux-next-pending/0011-ath9k-Add-new-BT-profile-info-A2DP_Voice.patch
@@ -0,0 +1,44 @@
+From 2b175a64f5daa777c6509542e38a48dd15f8e1b4 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 15 Oct 2012 15:29:55 +0530
+Subject: [PATCH 11/11] ath9k: Add new BT profile info A2DP_Voice
+
+When the BT connection is initiated by headset, it's possible that headset
+requests to make one A2DP and one Voice connection over the same link.
+BT firmware will send a new profile A2DP_Voice in this case. So WLAN
+has to take care of this new profile for tuning BTCOEX parameters.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.h |    1 +
+ drivers/net/wireless/ath/ath9k/mci.h        |    2 ++
+ 2 files changed, 3 insertions(+), 0 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+@@ -126,6 +126,7 @@ enum ath_mci_gpm_coex_profile_type {
+ 	MCI_GPM_COEX_PROFILE_HID,
+ 	MCI_GPM_COEX_PROFILE_BNEP,
+ 	MCI_GPM_COEX_PROFILE_VOICE,
++	MCI_GPM_COEX_PROFILE_A2DPVO,
+ 	MCI_GPM_COEX_PROFILE_MAX
+ };
+ 
+--- a/drivers/net/wireless/ath/ath9k/mci.h
++++ b/drivers/net/wireless/ath/ath9k/mci.h
+@@ -49,6 +49,7 @@
+ 			_mci->num_pan++;	 \
+ 			break;			 \
+ 		case MCI_GPM_COEX_PROFILE_VOICE: \
++		case MCI_GPM_COEX_PROFILE_A2DPVO:\
+ 			_mci->num_sco++;	 \
+ 			break;			 \
+ 		default:			 \
+@@ -73,6 +74,7 @@
+ 			_mci->num_pan--;	 \
+ 			break;			 \
+ 		case MCI_GPM_COEX_PROFILE_VOICE: \
++		case MCI_GPM_COEX_PROFILE_A2DPVO:\
+ 			_mci->num_sco--;	 \
+ 			break;			 \
+ 		default:			 \
diff --git a/linux-next-pending/0012-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch b/linux-next-pending/0012-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch
new file mode 100644
index 0000000..e4a39e9
--- /dev/null
+++ b/linux-next-pending/0012-cfg80211-Disallow-HT-WEP-in-IBSS-mode.patch
@@ -0,0 +1,63 @@
+From 19888b7ee52ffee74a874ad622f44ed5f9706e51 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qti.qualcomm.com>
+Date: Mon, 15 Oct 2012 16:43:41 +0530
+Subject: [PATCH] cfg80211: Disallow HT/WEP in IBSS mode
+
+Signed-off-by: Sujith Manoharan <c_manoha@qti.qualcomm.com>
+---
+ net/wireless/nl80211.c | 20 +++++++++++++++++---
+ 1 file changed, 17 insertions(+), 3 deletions(-)
+
+--- a/net/wireless/nl80211.c
++++ b/net/wireless/nl80211.c
+@@ -690,7 +690,7 @@ static int nl80211_parse_key(struct genl
+ 
+ static struct cfg80211_cached_keys *
+ nl80211_parse_connkeys(struct cfg80211_registered_device *rdev,
+-		       struct nlattr *keys)
++		       struct nlattr *keys, bool *no_ht)
+ {
+ 	struct key_parse parse;
+ 	struct nlattr *key;
+@@ -733,6 +733,12 @@ nl80211_parse_connkeys(struct cfg80211_r
+ 		result->params[parse.idx].key_len = parse.p.key_len;
+ 		result->params[parse.idx].key = result->data[parse.idx];
+ 		memcpy(result->data[parse.idx], parse.p.key, parse.p.key_len);
++
++		if (result->params[parse.idx].cipher == WLAN_CIPHER_SUITE_WEP40 ||
++		    result->params[parse.idx].cipher == WLAN_CIPHER_SUITE_WEP104) {
++			if (no_ht)
++				*no_ht = true;
++		}
+ 	}
+ 
+ 	return result;
+@@ -5318,10 +5324,18 @@ static int nl80211_join_ibss(struct sk_b
+ 		return -EINVAL;
+ 
+ 	if (ibss.privacy && info->attrs[NL80211_ATTR_KEYS]) {
++		bool no_ht = false;
++
+ 		connkeys = nl80211_parse_connkeys(rdev,
+-					info->attrs[NL80211_ATTR_KEYS]);
++					  info->attrs[NL80211_ATTR_KEYS],
++					  &no_ht);
+ 		if (IS_ERR(connkeys))
+ 			return PTR_ERR(connkeys);
++
++		if ((ibss.channel_type != NL80211_CHAN_NO_HT) && no_ht) {
++			kfree(connkeys);
++			return -EINVAL;
++		}
+ 	}
+ 
+ 	ibss.control_port =
+@@ -5621,7 +5635,7 @@ static int nl80211_connect(struct sk_buf
+ 
+ 	if (connect.privacy && info->attrs[NL80211_ATTR_KEYS]) {
+ 		connkeys = nl80211_parse_connkeys(rdev,
+-					info->attrs[NL80211_ATTR_KEYS]);
++					  info->attrs[NL80211_ATTR_KEYS], NULL);
+ 		if (IS_ERR(connkeys))
+ 			return PTR_ERR(connkeys);
+ 	}
-- 
1.7.11.4

