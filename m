Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:9027 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab2KZM3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 07:29:50 -0500
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <backports@vger.kernel.org>
Subject: [PATCH 3/3] compat-drivers: Add a crap patch for AR9565
Date: Mon, 26 Nov 2012 17:59:57 +0530
Message-ID: <1353932997-8051-4-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20121126_132953_715792_D2C8990A)
In-Reply-To: <1353932997-8051-1-git-send-email-bkamatch@qca.qualcomm.com>
References: <1353932997-8051-1-git-send-email-bkamatch@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is required to improve BT throughput to
meet customer requirement.  This patch is a workaround
to put WLAN to sleep during BT cycle and cannot be
upstreamed.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 ...9k-Improve-BT-PAN-FTP-profile-performance.patch |  140 ++++++++++++++++++++
 1 files changed, 140 insertions(+), 0 deletions(-)
 create mode 100644 crap/0005-ath9k-Improve-BT-PAN-FTP-profile-performance.patch

diff --git a/crap/0005-ath9k-Improve-BT-PAN-FTP-profile-performance.patch b/crap/0005-ath9k-Improve-BT-PAN-FTP-profile-performance.patch
new file mode 100644
index 0000000..a566351
--- /dev/null
+++ b/crap/0005-ath9k-Improve-BT-PAN-FTP-profile-performance.patch
@@ -0,0 +1,140 @@
+From 6c4e8baa270c00e16a606bf0ad4a686bd5c0300c Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Fri, 23 Nov 2012 14:17:59 +0530
+Subject: [PATCH] ath9k: Improve BT PAN/FTP profile performance
+
+As AR9565 shares LNA and antenna for both BT & WLAN, there
+are some degrade in BT performance. In order to improve BT PAN/FTP
+profile performance, this change puts WLAN into sleep state
+whenever BT gets its slot during BTCOEX period. It improves
+BT performance at the cost of WLAN throughout. Hence this change
+is applied only for AR9565 and BT FTP/PAN profiles.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/btcoex.c | 13 +++++++++++++
+ drivers/net/wireless/ath/ath9k/btcoex.h |  1 +
+ drivers/net/wireless/ath/ath9k/gpio.c   |  5 ++++-
+ drivers/net/wireless/ath/ath9k/mci.c    | 13 +++++++++++++
+ drivers/net/wireless/ath/ath9k/mci.h    |  1 +
+ drivers/net/wireless/ath/ath9k/reg.h    |  5 ++++-
+ 6 files changed, 36 insertions(+), 2 deletions(-)
+
+diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
+index 9963b0b..40a9761 100644
+--- a/drivers/net/wireless/ath/ath9k/btcoex.c
++++ b/drivers/net/wireless/ath/ath9k/btcoex.c
+@@ -414,3 +414,16 @@ void ath9k_hw_btcoex_set_concur_txprio(struct ath_hw *ah, u8 *stomp_txprio)
+ 		btcoex->tx_prio[i] = stomp_txprio[i];
+ }
+ EXPORT_SYMBOL(ath9k_hw_btcoex_set_concur_txprio);
++
++void ath9k_hw_btcoex_set_sleep(struct ath_hw *ah, u8 state)
++{
++	REG_RMW_FIELD(ah, AR_PCU_MISC_MODE2,
++		      AR_PCU_MISC_MODE2_PM_FIELD_FOR_DAT, state);
++	REG_RMW_FIELD(ah, AR_PCU_MISC_MODE3,
++		      AR_PCU_MISC_MODE3_PM_FIELD_FOR_MGT, state);
++	if (state)
++		REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
++	else
++		REG_CLR_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
++}
++EXPORT_SYMBOL(ath9k_hw_btcoex_set_sleep);
+diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
+index 6de26ea..5e82cca 100644
+--- a/drivers/net/wireless/ath/ath9k/btcoex.h
++++ b/drivers/net/wireless/ath/ath9k/btcoex.h
+@@ -120,5 +120,6 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah);
+ void ath9k_hw_btcoex_bt_stomp(struct ath_hw *ah,
+ 			      enum ath_stomp_type stomp_type);
+ void ath9k_hw_btcoex_set_concur_txprio(struct ath_hw *ah, u8 *stomp_txprio);
++void ath9k_hw_btcoex_set_sleep(struct ath_hw *ah, u8 state);
+ 
+ #endif
+diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
+index 4b412aa..6599f76 100644
+--- a/drivers/net/wireless/ath/ath9k/gpio.c
++++ b/drivers/net/wireless/ath/ath9k/gpio.c
+@@ -234,8 +234,10 @@ static void ath_btcoex_period_timer(unsigned long data)
+ 	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
+ 		ath_detect_bt_priority(sc);
+ 
+-	if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
++	if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI) {
++		ath9k_mci_set_sleep(sc, 0);
+ 		ath_mci_ftp_adjust(sc);
++	}
+ 
+ 	spin_lock_bh(&btcoex->btcoex_lock);
+ 
+@@ -303,6 +305,7 @@ static void ath_btcoex_no_stomp_timer(void *arg)
+ 
+ 	ath9k_hw_btcoex_enable(ah);
+ 	spin_unlock_bh(&btcoex->btcoex_lock);
++	ath9k_mci_set_sleep(sc, 1);
+ 	ath9k_ps_restore(sc);
+ }
+ 
+diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
+index 706378e..419c11f 100644
+--- a/drivers/net/wireless/ath/ath9k/mci.c
++++ b/drivers/net/wireless/ath/ath9k/mci.c
+@@ -745,6 +745,7 @@ static void ath9k_mci_stomp_audio(struct ath_softc *sc)
+ 
+ 	btcoex->stomp_audio++;
+ }
++
+ void ath9k_mci_update_rssi(struct ath_softc *sc)
+ {
+ 	struct ath_hw *ah = sc->sc_ah;
+@@ -772,3 +773,15 @@ void ath9k_mci_update_rssi(struct ath_softc *sc)
+ 		}
+ 	}
+ }
++
++void ath9k_mci_set_sleep(struct ath_softc *sc, u8 state)
++{
++	struct ath_mci_profile *mci = &sc->btcoex.mci;
++
++	if (!AR_SREV_9565(sc->sc_ah))
++		return;
++
++	state = (state && (mci->num_pan || mci->num_other_acl)) ? 1 : 0;
++
++	ath9k_hw_btcoex_set_sleep(sc->sc_ah, state);
++}
+diff --git a/drivers/net/wireless/ath/ath9k/mci.h b/drivers/net/wireless/ath/ath9k/mci.h
+index 0695883..4f39730 100644
+--- a/drivers/net/wireless/ath/ath9k/mci.h
++++ b/drivers/net/wireless/ath/ath9k/mci.h
+@@ -155,6 +155,7 @@ int ath_mci_setup(struct ath_softc *sc);
+ void ath_mci_cleanup(struct ath_softc *sc);
+ void ath_mci_intr(struct ath_softc *sc);
+ void ath9k_mci_update_rssi(struct ath_softc *sc);
++void ath9k_mci_set_sleep(struct ath_softc *sc, u8 state);
+ 
+ #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+ void ath_mci_enable(struct ath_softc *sc);
+diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
+index ad3c82c..69277f2 100644
+--- a/drivers/net/wireless/ath/ath9k/reg.h
++++ b/drivers/net/wireless/ath/ath9k/reg.h
+@@ -1897,10 +1897,13 @@ enum {
+ #define AR_PCU_MISC_MODE2_ENABLE_AGGWEP                0x00020000
+ #define AR_PCU_MISC_MODE2_HWWAR1                       0x00100000
+ #define AR_PCU_MISC_MODE2_HWWAR2                       0x02000000
++#define AR_PCU_MISC_MODE2_PM_FIELD_FOR_DAT             0x04000000
++#define AR_PCU_MISC_MODE2_PM_FIELD_FOR_DAT_S           26
+ #define AR_PCU_MISC_MODE2_RESERVED2                    0xFFFE0000
+ 
+ #define AR_PCU_MISC_MODE3			       0x83d0
+-
++#define AR_PCU_MISC_MODE3_PM_FIELD_FOR_MGT	       0x00400000
++#define AR_PCU_MISC_MODE3_PM_FIELD_FOR_MGT_S	       22
+ #define AR_MAC_PCU_ASYNC_FIFO_REG3			0x8358
+ #define AR_MAC_PCU_ASYNC_FIFO_REG3_DATAPATH_SEL		0x00000400
+ #define AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET		0x80000000
+-- 
+1.8.0
+
-- 
1.7.4.1

