Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43036 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732Ab2INPpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 11:45:05 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <mcgrof@do-not-panic.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] compat-driver: Add new next-pending patches
Date: Fri, 14 Sep 2012 21:11:01 +0530
Message-ID: <1347637262-27782-3-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120914_174510_913341_7D866EBA)
In-Reply-To: <1347637262-27782-1-git-send-email-bkamatch@qca.qualcomm.com>
References: <1347637262-27782-1-git-send-email-bkamatch@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 ...9k_hw-move-2g5g-switch-before-nfcal-start.patch |   31 ++++++
 ...241-ath9k_hw-fix-ar9462-selfgen-chainmask.patch |   37 +++++++
 ...flush-bt-profile-whenever-it-is-requested.patch |   88 ++++++++++++++++
 ...-move-coex-param-updation-within-mci-work.patch |   57 ++++++++++
 .../0244-ath9k-fill-led_pin-before-drv_start.patch |  109 ++++++++++++++++++++
 .../0245-ath9k-fix-queuing-MCI-work-twice.patch    |  109 ++++++++++++++++++++
 6 files changed, 431 insertions(+), 0 deletions(-)
 create mode 100644 linux-next-pending/0240-ath9k_hw-move-2g5g-switch-before-nfcal-start.patch
 create mode 100644 linux-next-pending/0241-ath9k_hw-fix-ar9462-selfgen-chainmask.patch
 create mode 100644 linux-next-pending/0242-ath9k-flush-bt-profile-whenever-it-is-requested.patch
 create mode 100644 linux-next-pending/0243-ath9k-move-coex-param-updation-within-mci-work.patch
 create mode 100644 linux-next-pending/0244-ath9k-fill-led_pin-before-drv_start.patch
 create mode 100644 linux-next-pending/0245-ath9k-fix-queuing-MCI-work-twice.patch

diff --git a/linux-next-pending/0240-ath9k_hw-move-2g5g-switch-before-nfcal-start.patch b/linux-next-pending/0240-ath9k_hw-move-2g5g-switch-before-nfcal-start.patch
new file mode 100644
index 0000000..c1d8f4f
--- /dev/null
+++ b/linux-next-pending/0240-ath9k_hw-move-2g5g-switch-before-nfcal-start.patch
@@ -0,0 +1,31 @@
+From 59307ae7d510bc6fab0c19404938e7c3e5d83415 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Wed, 12 Sep 2012 18:59:19 +0530
+Subject: [PATCH 240/245] ath9k_hw: move 2g5g switch before nfcal start
+
+During fast channel change, perform 2g5g_switch before starting
+noisefloor calibration to avoid nfload timeout.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/hw.c | 6 +++---
+ 1 file changed, 3 insertions(+), 3 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/hw.c
++++ b/drivers/net/wireless/ath/ath9k/hw.c
+@@ -1720,12 +1720,12 @@ static int ath9k_hw_do_fastcc(struct ath
+ 	if (!ret)
+ 		goto fail;
+ 
+-	ath9k_hw_loadnf(ah, ah->curchan);
+-	ath9k_hw_start_nfcal(ah, true);
+-
+ 	if (ath9k_hw_mci_is_enabled(ah))
+ 		ar9003_mci_2g5g_switch(ah, false);
+ 
++	ath9k_hw_loadnf(ah, ah->curchan);
++	ath9k_hw_start_nfcal(ah, true);
++
+ 	if (AR_SREV_9271(ah))
+ 		ar9002_hw_load_ani_reg(ah, chan);
+ 
diff --git a/linux-next-pending/0241-ath9k_hw-fix-ar9462-selfgen-chainmask.patch b/linux-next-pending/0241-ath9k_hw-fix-ar9462-selfgen-chainmask.patch
new file mode 100644
index 0000000..1f0477f
--- /dev/null
+++ b/linux-next-pending/0241-ath9k_hw-fix-ar9462-selfgen-chainmask.patch
@@ -0,0 +1,37 @@
+From 0b3c2f3de6004b210c785aafcd91d4a3cf7051a5 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Wed, 12 Sep 2012 18:59:20 +0530
+Subject: [PATCH 241/245] ath9k_hw: fix ar9462 selfgen chainmask
+
+When the 9462 is operating in 2G mode and MCI is enabled then
+reduce the selfgen chain mask to chain 1. Otherwise poor performance
+was reported at short range at Rx side when COEX is enabled.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c | 1 +
+ drivers/net/wireless/ath/ath9k/ar9003_phy.c | 3 ---
+ 2 files changed, 1 insertion(+), 3 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -1027,6 +1027,7 @@ void ar9003_mci_2g5g_switch(struct ath_h
+ 
+ 		if (!(mci->config & ATH_MCI_CONFIG_DISABLE_OSLA))
+ 			ar9003_mci_osla_setup(ah, true);
++		REG_WRITE(ah, AR_SELFGEN_MASK, 0x02);
+ 	} else {
+ 		ar9003_mci_send_lna_take(ah, true);
+ 		udelay(5);
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+@@ -549,9 +549,6 @@ static void ar9003_hw_set_chain_masks(st
+ 
+ 	if ((ah->caps.hw_caps & ATH9K_HW_CAP_APM) && (tx == 0x7))
+ 		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
+-	else if (AR_SREV_9462(ah))
+-		/* xxx only when MCI support is enabled */
+-		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
+ 	else
+ 		REG_WRITE(ah, AR_SELFGEN_MASK, tx);
+ 
diff --git a/linux-next-pending/0242-ath9k-flush-bt-profile-whenever-it-is-requested.patch b/linux-next-pending/0242-ath9k-flush-bt-profile-whenever-it-is-requested.patch
new file mode 100644
index 0000000..9df943c
--- /dev/null
+++ b/linux-next-pending/0242-ath9k-flush-bt-profile-whenever-it-is-requested.patch
@@ -0,0 +1,88 @@
+From 9fead6950c0f9684122b1ae83d653b65e3603eb6 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Wed, 12 Sep 2012 18:59:21 +0530
+Subject: [PATCH 242/245] ath9k: flush bt profile whenever it is requested
+
+Before processing BT profiles or status messages, check whether
+it is requested to flush BT profile. Otherwise it might increase
+number of BT profiles that affects the WLAN performance. Also
+flush the profiles when MCI is recovering from broken rx. After
+flushing BT profiles, query BT topology to refetch them.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c |  4 ++++
+ drivers/net/wireless/ath/ath9k/ar9003_mci.h |  4 +++-
+ drivers/net/wireless/ath/ath9k/mci.c        | 12 +++++++++++-
+ 3 files changed, 18 insertions(+), 2 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -1242,6 +1242,10 @@ u32 ar9003_mci_state(struct ath_hw *ah,
+ 	case MCI_STATE_NEED_FTP_STOMP:
+ 		value = !(mci->config & ATH_MCI_CONFIG_DISABLE_FTP_STOMP);
+ 		break;
++	case MCI_STATE_NEED_FLUSH_BT_INFO:
++		value = (!mci->unhalt_bt_gpm && mci->need_flush_btinfo) ? 1 : 0;
++		mci->need_flush_btinfo = false;
++		break;
+ 	default:
+ 		break;
+ 	}
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+@@ -202,6 +202,7 @@ enum mci_state_type {
+ 	MCI_STATE_RECOVER_RX,
+ 	MCI_STATE_NEED_FTP_STOMP,
+ 	MCI_STATE_DEBUG,
++	MCI_STATE_NEED_FLUSH_BT_INFO,
+ 	MCI_STATE_MAX
+ };
+ 
+@@ -213,7 +214,8 @@ enum mci_gpm_coex_opcode {
+ 	MCI_GPM_COEX_WLAN_CHANNELS,
+ 	MCI_GPM_COEX_BT_PROFILE_INFO,
+ 	MCI_GPM_COEX_BT_STATUS_UPDATE,
+-	MCI_GPM_COEX_BT_UPDATE_FLAGS
++	MCI_GPM_COEX_BT_UPDATE_FLAGS,
++	MCI_GPM_COEX_NOOP,
+ };
+ 
+ #define MCI_GPM_NOMORE  0
+--- a/drivers/net/wireless/ath/ath9k/mci.c
++++ b/drivers/net/wireless/ath/ath9k/mci.c
+@@ -80,6 +80,7 @@ void ath_mci_flush_profile(struct ath_mc
+ 	struct ath_mci_profile_info *info, *tinfo;
+ 
+ 	mci->aggr_limit = 0;
++	mci->num_mgmt = 0;
+ 
+ 	if (list_empty(&mci->info))
+ 		return;
+@@ -328,6 +329,13 @@ static void ath_mci_msg(struct ath_softc
+ 	u8 major, minor;
+ 	u32 seq_num;
+ 
++	if (ar9003_mci_state(ah, MCI_STATE_NEED_FLUSH_BT_INFO) &&
++	    ar9003_mci_state(ah, MCI_STATE_ENABLE)) {
++		ath_dbg(common, MCI, "(MCI) Need to flush BT profiles\n");
++		ath_mci_flush_profile(&sc->btcoex.mci);
++		ar9003_mci_state(ah, MCI_STATE_SEND_STATUS_QUERY);
++	}
++
+ 	switch (opcode) {
+ 	case MCI_GPM_COEX_VERSION_QUERY:
+ 		ar9003_mci_state(ah, MCI_STATE_SEND_WLAN_COEX_VERSION);
+@@ -568,9 +576,11 @@ void ath_mci_intr(struct ath_softc *sc)
+ 	}
+ 
+ 	if ((mci_int & AR_MCI_INTERRUPT_RX_INVALID_HDR) ||
+-	    (mci_int & AR_MCI_INTERRUPT_CONT_INFO_TIMEOUT))
++	    (mci_int & AR_MCI_INTERRUPT_CONT_INFO_TIMEOUT)) {
+ 		mci_int &= ~(AR_MCI_INTERRUPT_RX_INVALID_HDR |
+ 			     AR_MCI_INTERRUPT_CONT_INFO_TIMEOUT);
++		ath_mci_msg(sc, MCI_GPM_COEX_NOOP, NULL);
++	}
+ }
+ 
+ void ath_mci_enable(struct ath_softc *sc)
diff --git a/linux-next-pending/0243-ath9k-move-coex-param-updation-within-mci-work.patch b/linux-next-pending/0243-ath9k-move-coex-param-updation-within-mci-work.patch
new file mode 100644
index 0000000..1b7e13e
--- /dev/null
+++ b/linux-next-pending/0243-ath9k-move-coex-param-updation-within-mci-work.patch
@@ -0,0 +1,57 @@
+From 59264356c4cf5eb8f4224b3beb0f8c1c11b5714b Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Wed, 12 Sep 2012 18:59:22 +0530
+Subject: [PATCH 243/245] ath9k: move coex param updation within mci work
+
+Update all coex parameters in sigle place. So that we can avoid
+redoing the same operation in mutiple places and it eases debugging.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/mci.c | 20 +++++++++-----------
+ 1 file changed, 9 insertions(+), 11 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/mci.c
++++ b/drivers/net/wireless/ath/ath9k/mci.c
+@@ -121,7 +121,14 @@ static void ath_mci_update_scheme(struct
+ 	if (mci_hw->config & ATH_MCI_CONFIG_DISABLE_TUNING)
+ 		goto skip_tuning;
+ 
++	mci->aggr_limit = 0;
+ 	btcoex->duty_cycle = ath_mci_duty_cycle[num_profile];
++	btcoex->btcoex_period = ATH_MCI_DEF_BT_PERIOD;
++	if (NUM_PROF(mci))
++		btcoex->bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
++	else
++		btcoex->bt_stomp_type = mci->num_mgmt ? ATH_BTCOEX_STOMP_ALL :
++							ATH_BTCOEX_STOMP_LOW;
+ 
+ 	if (num_profile == 1) {
+ 		info = list_first_entry(&mci->info,
+@@ -133,7 +140,8 @@ static void ath_mci_update_scheme(struct
+ 			else if (info->T == 6) {
+ 				mci->aggr_limit = 6;
+ 				btcoex->duty_cycle = 30;
+-			}
++			} else
++				mci->aggr_limit = 6;
+ 			ath_dbg(common, MCI,
+ 				"Single SCO, aggregation limit %d 1/4 ms\n",
+ 				mci->aggr_limit);
+@@ -273,16 +281,6 @@ static void ath_mci_process_profile(stru
+ 	} else
+ 		ath_mci_del_profile(common, mci, entry);
+ 
+-	btcoex->btcoex_period = ATH_MCI_DEF_BT_PERIOD;
+-	mci->aggr_limit = mci->num_sco ? 6 : 0;
+-
+-	btcoex->duty_cycle = ath_mci_duty_cycle[NUM_PROF(mci)];
+-	if (NUM_PROF(mci))
+-		btcoex->bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
+-	else
+-		btcoex->bt_stomp_type = mci->num_mgmt ? ATH_BTCOEX_STOMP_ALL :
+-							ATH_BTCOEX_STOMP_LOW;
+-
+ 	ieee80211_queue_work(sc->hw, &sc->mci_work);
+ }
+ 
diff --git a/linux-next-pending/0244-ath9k-fill-led_pin-before-drv_start.patch b/linux-next-pending/0244-ath9k-fill-led_pin-before-drv_start.patch
new file mode 100644
index 0000000..2a1ac83
--- /dev/null
+++ b/linux-next-pending/0244-ath9k-fill-led_pin-before-drv_start.patch
@@ -0,0 +1,109 @@
+From f6446b38add0a6520d70bf776603c4c83a175392 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Fri, 14 Sep 2012 12:36:02 +0530
+Subject: [PATCH 244/245] ath9k: fill led_pin before drv_start
+
+Ensure that led pin is filled and set to OFF before starting
+the driver. With recent changes, drv_start is being called even
+before led_init is being completed. This is causing led is always
+OFF on driver load when the interface is UP. This patch splits the
+led init and fills the led pin before register hw.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ath9k.h |  4 +++
+ drivers/net/wireless/ath/ath9k/gpio.c  | 45 ++++++++++++++++++++--------------
+ drivers/net/wireless/ath/ath9k/init.c  |  1 +
+ 3 files changed, 31 insertions(+), 19 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ath9k.h
++++ b/drivers/net/wireless/ath/ath9k/ath9k.h
+@@ -528,6 +528,7 @@ static inline void ath9k_btcoex_stop_gen
+ #ifdef CONFIG_MAC80211_LEDS
+ void ath_init_leds(struct ath_softc *sc);
+ void ath_deinit_leds(struct ath_softc *sc);
++void ath_fill_led_pin(struct ath_softc *sc);
+ #else
+ static inline void ath_init_leds(struct ath_softc *sc)
+ {
+@@ -536,6 +537,9 @@ static inline void ath_init_leds(struct
+ static inline void ath_deinit_leds(struct ath_softc *sc)
+ {
+ }
++static inline void ath_fill_led_pin(struct ath_softc *sc)
++{
++}
+ #endif
+ 
+ /*******************************/
+--- a/drivers/net/wireless/ath/ath9k/gpio.c
++++ b/drivers/net/wireless/ath/ath9k/gpio.c
+@@ -44,25 +44,6 @@ void ath_init_leds(struct ath_softc *sc)
+ 	if (AR_SREV_9100(sc->sc_ah))
+ 		return;
+ 
+-	if (sc->sc_ah->led_pin < 0) {
+-		if (AR_SREV_9287(sc->sc_ah))
+-			sc->sc_ah->led_pin = ATH_LED_PIN_9287;
+-		else if (AR_SREV_9485(sc->sc_ah))
+-			sc->sc_ah->led_pin = ATH_LED_PIN_9485;
+-		else if (AR_SREV_9300(sc->sc_ah))
+-			sc->sc_ah->led_pin = ATH_LED_PIN_9300;
+-		else if (AR_SREV_9462(sc->sc_ah))
+-			sc->sc_ah->led_pin = ATH_LED_PIN_9462;
+-		else
+-			sc->sc_ah->led_pin = ATH_LED_PIN_DEF;
+-	}
+-
+-	/* Configure gpio 1 for output */
+-	ath9k_hw_cfg_output(sc->sc_ah, sc->sc_ah->led_pin,
+-			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
+-	/* LED off, active low */
+-	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
+-
+ 	if (!led_blink)
+ 		sc->led_cdev.default_trigger =
+ 			ieee80211_get_radio_led_name(sc->hw);
+@@ -78,6 +59,32 @@ void ath_init_leds(struct ath_softc *sc)
+ 
+ 	sc->led_registered = true;
+ }
++
++void ath_fill_led_pin(struct ath_softc *sc)
++{
++	struct ath_hw *ah = sc->sc_ah;
++
++	if (AR_SREV_9100(ah) || (ah->led_pin >= 0))
++		return;
++
++	if (AR_SREV_9287(ah))
++		ah->led_pin = ATH_LED_PIN_9287;
++	else if (AR_SREV_9485(sc->sc_ah))
++		ah->led_pin = ATH_LED_PIN_9485;
++	else if (AR_SREV_9300(sc->sc_ah))
++		ah->led_pin = ATH_LED_PIN_9300;
++	else if (AR_SREV_9462(sc->sc_ah))
++		ah->led_pin = ATH_LED_PIN_9462;
++	else
++		ah->led_pin = ATH_LED_PIN_DEF;
++
++	/* Configure gpio 1 for output */
++	ath9k_hw_cfg_output(ah, ah->led_pin, AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
++
++	/* LED off, active low */
++	ath9k_hw_set_gpio(ah, ah->led_pin, 1);
++}
++
+ #endif
+ 
+ /*******************/
+--- a/drivers/net/wireless/ath/ath9k/init.c
++++ b/drivers/net/wireless/ath/ath9k/init.c
+@@ -598,6 +598,7 @@ static int ath9k_init_softc(u16 devid, s
+ 
+ 	ath9k_cmn_init_crypto(sc->sc_ah);
+ 	ath9k_init_misc(sc);
++	ath_fill_led_pin(sc);
+ 
+ 	if (common->bus_ops->aspm_init)
+ 		common->bus_ops->aspm_init(common);
diff --git a/linux-next-pending/0245-ath9k-fix-queuing-MCI-work-twice.patch b/linux-next-pending/0245-ath9k-fix-queuing-MCI-work-twice.patch
new file mode 100644
index 0000000..d2d24cf
--- /dev/null
+++ b/linux-next-pending/0245-ath9k-fix-queuing-MCI-work-twice.patch
@@ -0,0 +1,109 @@
+From 2d5811f3d1a8047b86be4251f1979c96ca710b33 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Wed, 12 Sep 2012 18:59:24 +0530
+Subject: [PATCH 245/245] ath9k: fix queuing MCI work twice
+
+Right now MCI work is being queued twice by profile and status
+updation. Queue MCI work once when it is needed.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/mci.c | 30 +++++++++++++++++-------------
+ 1 file changed, 17 insertions(+), 13 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/mci.c
++++ b/drivers/net/wireless/ath/ath9k/mci.c
+@@ -250,8 +250,8 @@ static void ath9k_mci_work(struct work_s
+ 	ath_mci_update_scheme(sc);
+ }
+ 
+-static void ath_mci_process_profile(struct ath_softc *sc,
+-				    struct ath_mci_profile_info *info)
++static u8 ath_mci_process_profile(struct ath_softc *sc,
++				  struct ath_mci_profile_info *info)
+ {
+ 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+ 	struct ath_btcoex *btcoex = &sc->btcoex;
+@@ -277,15 +277,15 @@ static void ath_mci_process_profile(stru
+ 
+ 	if (info->start) {
+ 		if (!entry && !ath_mci_add_profile(common, mci, info))
+-			return;
++			return 0;
+ 	} else
+ 		ath_mci_del_profile(common, mci, entry);
+ 
+-	ieee80211_queue_work(sc->hw, &sc->mci_work);
++	return 1;
+ }
+ 
+-static void ath_mci_process_status(struct ath_softc *sc,
+-				   struct ath_mci_profile_status *status)
++static u8 ath_mci_process_status(struct ath_softc *sc,
++				 struct ath_mci_profile_status *status)
+ {
+ 	struct ath_btcoex *btcoex = &sc->btcoex;
+ 	struct ath_mci_profile *mci = &btcoex->mci;
+@@ -294,14 +294,14 @@ static void ath_mci_process_status(struc
+ 
+ 	/* Link status type are not handled */
+ 	if (status->is_link)
+-		return;
++		return 0;
+ 
+ 	info.conn_handle = status->conn_handle;
+ 	if (ath_mci_find_profile(mci, &info))
+-		return;
++		return 0;
+ 
+ 	if (status->conn_handle >= ATH_MCI_MAX_PROFILE)
+-		return;
++		return 0;
+ 
+ 	if (status->is_critical)
+ 		__set_bit(status->conn_handle, mci->status);
+@@ -315,7 +315,9 @@ static void ath_mci_process_status(struc
+ 	} while (++i < ATH_MCI_MAX_PROFILE);
+ 
+ 	if (old_num_mgmt != mci->num_mgmt)
+-		ieee80211_queue_work(sc->hw, &sc->mci_work);
++		return 1;
++
++	return 0;
+ }
+ 
+ static void ath_mci_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
+@@ -324,7 +326,7 @@ static void ath_mci_msg(struct ath_softc
+ 	struct ath_mci_profile_info profile_info;
+ 	struct ath_mci_profile_status profile_status;
+ 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+-	u8 major, minor;
++	u8 major, minor, update_scheme = 0;
+ 	u32 seq_num;
+ 
+ 	if (ar9003_mci_state(ah, MCI_STATE_NEED_FLUSH_BT_INFO) &&
+@@ -359,7 +361,7 @@ static void ath_mci_msg(struct ath_softc
+ 			break;
+ 		}
+ 
+-		ath_mci_process_profile(sc, &profile_info);
++		update_scheme += ath_mci_process_profile(sc, &profile_info);
+ 		break;
+ 	case MCI_GPM_COEX_BT_STATUS_UPDATE:
+ 		profile_status.is_link = *(rx_payload +
+@@ -375,12 +377,14 @@ static void ath_mci_msg(struct ath_softc
+ 			profile_status.is_link, profile_status.conn_handle,
+ 			profile_status.is_critical, seq_num);
+ 
+-		ath_mci_process_status(sc, &profile_status);
++		update_scheme += ath_mci_process_status(sc, &profile_status);
+ 		break;
+ 	default:
+ 		ath_dbg(common, MCI, "Unknown GPM COEX message = 0x%02x\n", opcode);
+ 		break;
+ 	}
++	if (update_scheme)
++		ieee80211_queue_work(sc->hw, &sc->mci_work);
+ }
+ 
+ int ath_mci_setup(struct ath_softc *sc)
-- 
1.7.4.1

