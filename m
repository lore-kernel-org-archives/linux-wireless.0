Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10741 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab2I0GwY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 02:52:24 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20579.63334.450496.287004@gargle.gargle.HOWL> (sfid-20120927_085229_473538_0983DF66)
Date: Thu, 27 Sep 2012 12:21:18 +0530
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <backports@vger.kernel.org>
Subject: [PATCH 4/5] compat-drivers: Move patches to cherry-picks
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All of the pending patches have been merged in linux-next,
move them to the linux-next-cherry-picks/ directory.

Also, two new patches are added:
0066-ath9k-update-hw_timer_enabled-to-false-when-we-stop-.patch
0076-ath9k_hw-fix-BT-sleep-state-on-chip-wakeup.patch

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 .../0058-ath9k-Enable-SGI-correctly.patch          |  35 ++++
 ...9k_hw-move-2g5g-switch-before-nfcal-start.patch |  32 +++
 ...060-ath9k_hw-fix-ar9462-selfgen-chainmask.patch |  38 ++++
 ...flush-bt-profile-whenever-it-is-requested.patch |  89 +++++++++
 ...-move-coex-param-updation-within-mci-work.patch |  58 ++++++
 .../0063-ath9k-fill-led_pin-before-drv_start.patch | 109 +++++++++++
 .../0064-ath9k-fix-queuing-MCI-work-twice.patch    | 110 +++++++++++
 ...e-hw_timer_enabled-to-false-when-we-stop-.patch |  55 ++++++
 ...k_hw-Use-HW-cap-ATH9K_HW_CAP_ANT_DIV_COMB.patch |  51 +++++
 ...th9k-Remove-redundant-variable-assignment.patch | 186 ++++++++++++++++++
 ...ath9k-Remove-a-couple-of-unused-variables.patch |  22 +++
 ...hw-Add-antenna-diversity-group-for-AR9565.patch |  95 +++++++++
 .../0071-ath9k_hw-Update-AR9565-initvals.patch     | 173 +++++++++++++++++
 ...h9k_hw-Add-a-HW-callback-to-set-diversity.patch | 214 +++++++++++++++++++++
 ...dd-a-module-parameter-to-enable-diversity.patch |  69 +++++++
 ...9k_hw-Enable-WLAN-RX-diversity-for-AR9565.patch |  22 +++
 ...th9k_hw-fix-BT-sleep-state-on-chip-wakeup.patch |  34 ++++
 ...9k_hw-move-2g5g-switch-before-nfcal-start.patch |  31 ---
 ...002-ath9k_hw-fix-ar9462-selfgen-chainmask.patch |  37 ----
 ...flush-bt-profile-whenever-it-is-requested.patch |  88 ---------
 ...-move-coex-param-updation-within-mci-work.patch |  57 ------
 .../0005-ath9k-fill-led_pin-before-drv_start.patch | 108 -----------
 .../0006-ath9k-fix-queuing-MCI-work-twice.patch    | 109 -----------
 .../0007-ath9k-Enable-SGI-correctly.patch          |  34 ----
 ...k_hw-Use-HW-cap-ATH9K_HW_CAP_ANT_DIV_COMB.patch |  50 -----
 ...th9k-Remove-redundant-variable-assignment.patch | 185 ------------------
 ...ath9k-Remove-a-couple-of-unused-variables.patch |  21 --
 ...hw-Add-antenna-diversity-group-for-AR9565.patch |  94 ---------
 .../0012-ath9k_hw-Update-AR9565-initvals.patch     | 172 -----------------
 ...h9k_hw-Add-a-HW-callback-to-set-diversity.patch | 213 --------------------
 ...dd-a-module-parameter-to-enable-diversity.patch |  68 -------
 ...9k_hw-Enable-WLAN-RX-diversity-for-AR9565.patch |  21 --
 32 files changed, 1392 insertions(+), 1288 deletions(-)
 create mode 100644 linux-next-cherry-picks/0058-ath9k-Enable-SGI-correctly.patch
 create mode 100644 linux-next-cherry-picks/0059-ath9k_hw-move-2g5g-switch-before-nfcal-start.patch
 create mode 100644 linux-next-cherry-picks/0060-ath9k_hw-fix-ar9462-selfgen-chainmask.patch
 create mode 100644 linux-next-cherry-picks/0061-ath9k-flush-bt-profile-whenever-it-is-requested.patch
 create mode 100644 linux-next-cherry-picks/0062-ath9k-move-coex-param-updation-within-mci-work.patch
 create mode 100644 linux-next-cherry-picks/0063-ath9k-fill-led_pin-before-drv_start.patch
 create mode 100644 linux-next-cherry-picks/0064-ath9k-fix-queuing-MCI-work-twice.patch
 create mode 100644 linux-next-cherry-picks/0066-ath9k-update-hw_timer_enabled-to-false-when-we-stop-.patch
 create mode 100644 linux-next-cherry-picks/0067-ath9k_hw-Use-HW-cap-ATH9K_HW_CAP_ANT_DIV_COMB.patch
 create mode 100644 linux-next-cherry-picks/0068-ath9k-Remove-redundant-variable-assignment.patch
 create mode 100644 linux-next-cherry-picks/0069-ath9k-Remove-a-couple-of-unused-variables.patch
 create mode 100644 linux-next-cherry-picks/0070-ath9k_hw-Add-antenna-diversity-group-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0071-ath9k_hw-Update-AR9565-initvals.patch
 create mode 100644 linux-next-cherry-picks/0072-ath9k_hw-Add-a-HW-callback-to-set-diversity.patch
 create mode 100644 linux-next-cherry-picks/0073-ath9k-Add-a-module-parameter-to-enable-diversity.patch
 create mode 100644 linux-next-cherry-picks/0074-ath9k_hw-Enable-WLAN-RX-diversity-for-AR9565.patch
 create mode 100644 linux-next-cherry-picks/0076-ath9k_hw-fix-BT-sleep-state-on-chip-wakeup.patch
 delete mode 100644 linux-next-pending/0001-ath9k_hw-move-2g5g-switch-before-nfcal-start.patch
 delete mode 100644 linux-next-pending/0002-ath9k_hw-fix-ar9462-selfgen-chainmask.patch
 delete mode 100644 linux-next-pending/0003-ath9k-flush-bt-profile-whenever-it-is-requested.patch
 delete mode 100644 linux-next-pending/0004-ath9k-move-coex-param-updation-within-mci-work.patch
 delete mode 100644 linux-next-pending/0005-ath9k-fill-led_pin-before-drv_start.patch
 delete mode 100644 linux-next-pending/0006-ath9k-fix-queuing-MCI-work-twice.patch
 delete mode 100644 linux-next-pending/0007-ath9k-Enable-SGI-correctly.patch
 delete mode 100644 linux-next-pending/0008-ath9k_hw-Use-HW-cap-ATH9K_HW_CAP_ANT_DIV_COMB.patch
 delete mode 100644 linux-next-pending/0009-ath9k-Remove-redundant-variable-assignment.patch
 delete mode 100644 linux-next-pending/0010-ath9k-Remove-a-couple-of-unused-variables.patch
 delete mode 100644 linux-next-pending/0011-ath9k_hw-Add-antenna-diversity-group-for-AR9565.patch
 delete mode 100644 linux-next-pending/0012-ath9k_hw-Update-AR9565-initvals.patch
 delete mode 100644 linux-next-pending/0013-ath9k_hw-Add-a-HW-callback-to-set-diversity.patch
 delete mode 100644 linux-next-pending/0014-ath9k-Add-a-module-parameter-to-enable-diversity.patch
 delete mode 100644 linux-next-pending/0015-ath9k_hw-Enable-WLAN-RX-diversity-for-AR9565.patch

diff --git a/linux-next-cherry-picks/0058-ath9k-Enable-SGI-correctly.patch b/linux-next-cherry-picks/0058-ath9k-Enable-SGI-correctly.patch
new file mode 100644
index 0000000..445bf75
--- /dev/null
+++ b/linux-next-cherry-picks/0058-ath9k-Enable-SGI-correctly.patch
@@ -0,0 +1,35 @@
+From 215999f38017e8e26791fafc60631b4099ee04ea Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Wed, 12 Sep 2012 14:59:58 +0530
+Subject: [PATCH] ath9k: Enable SGI correctly
+
+Set the driver specific SGI flag based on the station's
+HT capabilities, otherwise rate control uses the wrong rate.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 11 +++++++----
+ 1 file changed, 7 insertions(+), 4 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -1222,11 +1222,14 @@ static u8 ath_rc_build_ht_caps(struct at
+ 			caps |= WLAN_RC_TS_FLAG | WLAN_RC_DS_FLAG;
+ 		else if (sta->ht_cap.mcs.rx_mask[1])
+ 			caps |= WLAN_RC_DS_FLAG;
+-		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
++		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
+ 			caps |= WLAN_RC_40_FLAG;
+-		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40 ||
+-		    sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20)
+-			caps |= WLAN_RC_SGI_FLAG;
++			if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40)
++				caps |= WLAN_RC_SGI_FLAG;
++		} else {
++			if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20)
++				caps |= WLAN_RC_SGI_FLAG;
++		}
+ 	}
+ 
+ 	return caps;
diff --git a/linux-next-cherry-picks/0059-ath9k_hw-move-2g5g-switch-before-nfcal-start.patch b/linux-next-cherry-picks/0059-ath9k_hw-move-2g5g-switch-before-nfcal-start.patch
new file mode 100644
index 0000000..1f7c6f6
--- /dev/null
+++ b/linux-next-cherry-picks/0059-ath9k_hw-move-2g5g-switch-before-nfcal-start.patch
@@ -0,0 +1,32 @@
+From 88033318e119bbf4647db4d50ad549fc86e0acf0 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Wed, 12 Sep 2012 18:59:19 +0530
+Subject: [PATCH] ath9k_hw: move 2g5g switch before nfcal start
+
+During fast channel change, perform 2g5g_switch before starting
+noisefloor calibration to avoid nfload timeout.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/hw.c | 6 +++---
+ 1 file changed, 3 insertions(+), 3 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/hw.c
++++ b/drivers/net/wireless/ath/ath9k/hw.c
+@@ -1733,12 +1733,12 @@ static int ath9k_hw_do_fastcc(struct ath
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
diff --git a/linux-next-cherry-picks/0060-ath9k_hw-fix-ar9462-selfgen-chainmask.patch b/linux-next-cherry-picks/0060-ath9k_hw-fix-ar9462-selfgen-chainmask.patch
new file mode 100644
index 0000000..d5c7c75
--- /dev/null
+++ b/linux-next-cherry-picks/0060-ath9k_hw-fix-ar9462-selfgen-chainmask.patch
@@ -0,0 +1,38 @@
+From bfbee42793a564762d2681d88dc19f4c2d8ee6fd Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Wed, 12 Sep 2012 18:59:20 +0530
+Subject: [PATCH] ath9k_hw: fix ar9462 selfgen chainmask
+
+When the 9462 is operating in 2G mode and MCI is enabled then
+reduce the selfgen chain mask to chain 1. Otherwise poor performance
+was reported at short range at Rx side when COEX is enabled.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
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
+@@ -605,9 +605,6 @@ static void ar9003_hw_set_chain_masks(st
+ 
+ 	if ((ah->caps.hw_caps & ATH9K_HW_CAP_APM) && (tx == 0x7))
+ 		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
+-	else if (AR_SREV_9462(ah))
+-		/* xxx only when MCI support is enabled */
+-		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
+ 	else
+ 		REG_WRITE(ah, AR_SELFGEN_MASK, tx);
+ 
diff --git a/linux-next-cherry-picks/0061-ath9k-flush-bt-profile-whenever-it-is-requested.patch b/linux-next-cherry-picks/0061-ath9k-flush-bt-profile-whenever-it-is-requested.patch
new file mode 100644
index 0000000..fbb5a8c
--- /dev/null
+++ b/linux-next-cherry-picks/0061-ath9k-flush-bt-profile-whenever-it-is-requested.patch
@@ -0,0 +1,89 @@
+From d92bb98f0c13f711bb04f447f7e19da0163eded2 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Wed, 12 Sep 2012 18:59:21 +0530
+Subject: [PATCH] ath9k: flush bt profile whenever it is requested
+
+Before processing BT profiles or status messages, check whether
+it is requested to flush BT profile. Otherwise it might increase
+number of BT profiles that affects the WLAN performance. Also
+flush the profiles when MCI is recovering from broken rx. After
+flushing BT profiles, query BT topology to refetch them.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c |  4 ++++
+ drivers/net/wireless/ath/ath9k/ar9003_mci.h |  4 +++-
+ drivers/net/wireless/ath/ath9k/mci.c        | 12 +++++++++++-
+ 3 files changed, 18 insertions(+), 2 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -1236,6 +1236,10 @@ u32 ar9003_mci_state(struct ath_hw *ah,
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
+@@ -200,6 +200,7 @@ enum mci_state_type {
+ 	MCI_STATE_RECOVER_RX,
+ 	MCI_STATE_NEED_FTP_STOMP,
+ 	MCI_STATE_DEBUG,
++	MCI_STATE_NEED_FLUSH_BT_INFO,
+ 	MCI_STATE_MAX
+ };
+ 
+@@ -211,7 +212,8 @@ enum mci_gpm_coex_opcode {
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
diff --git a/linux-next-cherry-picks/0062-ath9k-move-coex-param-updation-within-mci-work.patch b/linux-next-cherry-picks/0062-ath9k-move-coex-param-updation-within-mci-work.patch
new file mode 100644
index 0000000..48f3931
--- /dev/null
+++ b/linux-next-cherry-picks/0062-ath9k-move-coex-param-updation-within-mci-work.patch
@@ -0,0 +1,58 @@
+From 9e62817b9faee8d286580673b8eafb05e778ec1d Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Wed, 12 Sep 2012 18:59:22 +0530
+Subject: [PATCH] ath9k: move coex param updation within mci work
+
+Update all coex parameters in sigle place. So that we can avoid
+redoing the same operation in mutiple places and it eases debugging.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
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
diff --git a/linux-next-cherry-picks/0063-ath9k-fill-led_pin-before-drv_start.patch b/linux-next-cherry-picks/0063-ath9k-fill-led_pin-before-drv_start.patch
new file mode 100644
index 0000000..f80cb9e
--- /dev/null
+++ b/linux-next-cherry-picks/0063-ath9k-fill-led_pin-before-drv_start.patch
@@ -0,0 +1,109 @@
+From 8f176a3a16d124285cecd6c53b70689eb3b9ba36 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Wed, 12 Sep 2012 18:59:23 +0530
+Subject: [PATCH] ath9k: fill led_pin before drv_start
+
+Ensure that led pin is filled and set to OFF before starting
+the driver. With recent changes, drv_start is being called even
+before led_init is being completed. This is causing led is always
+OFF on driver load when the interface is UP. This patch splits the
+led init and fills the led pin before register hw.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ath9k.h |  4 ++++
+ drivers/net/wireless/ath/ath9k/gpio.c  | 44 +++++++++++++++++++---------------
+ drivers/net/wireless/ath/ath9k/init.c  |  1 +
+ 3 files changed, 30 insertions(+), 19 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ath9k.h
++++ b/drivers/net/wireless/ath/ath9k/ath9k.h
+@@ -537,6 +537,7 @@ struct ath9k_wow_pattern {
+ #ifdef CONFIG_MAC80211_LEDS
+ void ath_init_leds(struct ath_softc *sc);
+ void ath_deinit_leds(struct ath_softc *sc);
++void ath_fill_led_pin(struct ath_softc *sc);
+ #else
+ static inline void ath_init_leds(struct ath_softc *sc)
+ {
+@@ -545,6 +546,9 @@ static inline void ath_init_leds(struct
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
+-		else if (AR_SREV_9462(sc->sc_ah) || AR_SREV_9565(sc->sc_ah))
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
+@@ -78,6 +59,31 @@ void ath_init_leds(struct ath_softc *sc)
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
++	else if (AR_SREV_9462(sc->sc_ah) || AR_SREV_9565(sc->sc_ah))
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
+ #endif
+ 
+ /*******************/
+--- a/drivers/net/wireless/ath/ath9k/init.c
++++ b/drivers/net/wireless/ath/ath9k/init.c
+@@ -599,6 +599,7 @@ static int ath9k_init_softc(u16 devid, s
+ 
+ 	ath9k_cmn_init_crypto(sc->sc_ah);
+ 	ath9k_init_misc(sc);
++	ath_fill_led_pin(sc);
+ 
+ 	if (common->bus_ops->aspm_init)
+ 		common->bus_ops->aspm_init(common);
diff --git a/linux-next-cherry-picks/0064-ath9k-fix-queuing-MCI-work-twice.patch b/linux-next-cherry-picks/0064-ath9k-fix-queuing-MCI-work-twice.patch
new file mode 100644
index 0000000..40cf720
--- /dev/null
+++ b/linux-next-cherry-picks/0064-ath9k-fix-queuing-MCI-work-twice.patch
@@ -0,0 +1,110 @@
+From 7a03414686d8e01c660bf69df22cafcfd2753626 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Wed, 12 Sep 2012 18:59:24 +0530
+Subject: [PATCH] ath9k: fix queuing MCI work twice
+
+Right now MCI work is being queued twice by profile and status
+updation. Queue MCI work once when it is needed.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
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
diff --git a/linux-next-cherry-picks/0066-ath9k-update-hw_timer_enabled-to-false-when-we-stop-.patch b/linux-next-cherry-picks/0066-ath9k-update-hw_timer_enabled-to-false-when-we-stop-.patch
new file mode 100644
index 0000000..31e332e
--- /dev/null
+++ b/linux-next-cherry-picks/0066-ath9k-update-hw_timer_enabled-to-false-when-we-stop-.patch
@@ -0,0 +1,55 @@
+From 5418b0f0ad389989037d5ed700bcd8b67dbdf018 Mon Sep 17 00:00:00 2001
+From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Date: Fri, 14 Sep 2012 18:43:58 +0530
+Subject: [PATCH] ath9k: update hw_timer_enabled to false when we stop generic
+ timers
+
+Update the 'hw_timer_enabled' to 'false' wherever we are stopping
+hardware generic timers, excecpt the case where we start them
+again immediately.
+
+Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/gpio.c | 14 +++++++++-----
+ 1 file changed, 9 insertions(+), 5 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/gpio.c
++++ b/drivers/net/wireless/ath/ath9k/gpio.c
+@@ -320,8 +320,10 @@ void ath9k_btcoex_timer_resume(struct at
+ 	ath_dbg(ath9k_hw_common(ah), BTCOEX, "Starting btcoex timers\n");
+ 
+ 	/* make sure duty cycle timer is also stopped when resuming */
+-	if (btcoex->hw_timer_enabled)
++	if (btcoex->hw_timer_enabled) {
+ 		ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
++		btcoex->hw_timer_enabled = false;
++	}
+ 
+ 	btcoex->bt_priority_cnt = 0;
+ 	btcoex->bt_priority_time = jiffies;
+@@ -342,18 +344,20 @@ void ath9k_btcoex_timer_pause(struct ath
+ 
+ 	del_timer_sync(&btcoex->period_timer);
+ 
+-	if (btcoex->hw_timer_enabled)
++	if (btcoex->hw_timer_enabled) {
+ 		ath9k_gen_timer_stop(ah, btcoex->no_stomp_timer);
+-
+-	btcoex->hw_timer_enabled = false;
++		btcoex->hw_timer_enabled = false;
++	}
+ }
+ 
+ void ath9k_btcoex_stop_gen_timer(struct ath_softc *sc)
+ {
+ 	struct ath_btcoex *btcoex = &sc->btcoex;
+ 
+-	if (btcoex->hw_timer_enabled)
++	if (btcoex->hw_timer_enabled) {
+ 		ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
++		btcoex->hw_timer_enabled = false;
++	}
+ }
+ 
+ u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc, u32 max_4ms_framelen)
diff --git a/linux-next-cherry-picks/0067-ath9k_hw-Use-HW-cap-ATH9K_HW_CAP_ANT_DIV_COMB.patch b/linux-next-cherry-picks/0067-ath9k_hw-Use-HW-cap-ATH9K_HW_CAP_ANT_DIV_COMB.patch
new file mode 100644
index 0000000..c27ad79
--- /dev/null
+++ b/linux-next-cherry-picks/0067-ath9k_hw-Use-HW-cap-ATH9K_HW_CAP_ANT_DIV_COMB.patch
@@ -0,0 +1,51 @@
+From 915154b62bfe09102498b12e323b77dc762e5bec Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Sun, 16 Sep 2012 08:05:23 +0530
+Subject: [PATCH] ath9k_hw: Use HW cap ATH9K_HW_CAP_ANT_DIV_COMB
+
+Instead of trying to determine whether antenna diversity is
+enabled by parsing eeprom data, use ATH9K_HW_CAP_ANT_DIV_COMB
+which is already filled at init time.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 10 +++-------
+ 1 file changed, 3 insertions(+), 7 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+@@ -3566,9 +3566,9 @@ static u16 ar9003_hw_ant_ctrl_chain_get(
+ 
+ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
+ {
++	struct ath9k_hw_capabilities *pCap = &ah->caps;
+ 	int chain;
+ 	u32 regval;
+-	u32 ant_div_ctl1;
+ 	static const u32 switch_chain_reg[AR9300_MAX_CHAINS] = {
+ 			AR_PHY_SWITCH_CHAIN_0,
+ 			AR_PHY_SWITCH_CHAIN_1,
+@@ -3640,9 +3640,8 @@ static void ar9003_hw_ant_ctrl_apply(str
+ 		regval &= (~AR_FAST_DIV_ENABLE);
+ 		regval |= ((value >> 7) & 0x1) << AR_FAST_DIV_ENABLE_S;
+ 		REG_WRITE(ah, AR_PHY_CCK_DETECT, regval);
+-		ant_div_ctl1 = ah->eep_ops->get_eeprom(ah, EEP_ANT_DIV_CTL1);
+-		/* check whether antenna diversity is enabled */
+-		if ((ant_div_ctl1 >> 0x6) == 0x3) {
++
++		if (pCap->hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) {
+ 			regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
+ 			/*
+ 			 * clear bits 25-30 main_lnaconf, alt_lnaconf,
+@@ -3659,10 +3658,7 @@ static void ar9003_hw_ant_ctrl_apply(str
+ 				   AR_PHY_ANT_DIV_ALT_LNACONF_S);
+ 			REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
+ 		}
+-
+-
+ 	}
+-
+ }
+ 
+ static void ar9003_hw_drive_strength_apply(struct ath_hw *ah)
diff --git a/linux-next-cherry-picks/0068-ath9k-Remove-redundant-variable-assignment.patch b/linux-next-cherry-picks/0068-ath9k-Remove-redundant-variable-assignment.patch
new file mode 100644
index 0000000..7e785c5
--- /dev/null
+++ b/linux-next-cherry-picks/0068-ath9k-Remove-redundant-variable-assignment.patch
@@ -0,0 +1,186 @@
+From d85ed4196ebb065906eacfdc4b1cec824a3799dd Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Sun, 16 Sep 2012 08:05:40 +0530
+Subject: [PATCH] ath9k: Remove redundant variable assignment
+
+Set main_gaintb and alt_gaintb once instead of zero'ing them
+in every case.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/antenna.c | 51 ++------------------------------
+ 1 file changed, 3 insertions(+), 48 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/antenna.c
++++ b/drivers/net/wireless/ath/ath9k/antenna.c
+@@ -311,6 +311,9 @@ static void ath_ant_div_conf_fast_divbia
+ 					  struct ath_ant_comb *antcomb,
+ 					  int alt_ratio)
+ {
++	ant_conf->main_gaintb = 0;
++	ant_conf->alt_gaintb = 0;
++
+ 	if (ant_conf->div_group == 0) {
+ 		/* Adjust the fast_div_bias based on main and alt lna conf */
+ 		switch ((ant_conf->main_lna_conf << 4) |
+@@ -360,18 +363,12 @@ static void ath_ant_div_conf_fast_divbia
+ 			ant_conf->alt_lna_conf) {
+ 		case 0x01: /* A-B LNA2 */
+ 			ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x02: /* A-B LNA1 */
+ 			ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x03: /* A-B A+B */
+ 			ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x10: /* LNA2 A-B */
+ 			if (!(antcomb->scan) &&
+@@ -379,13 +376,9 @@ static void ath_ant_div_conf_fast_divbia
+ 				ant_conf->fast_div_bias = 0x3f;
+ 			else
+ 				ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x12: /* LNA2 LNA1 */
+ 			ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x13: /* LNA2 A+B */
+ 			if (!(antcomb->scan) &&
+@@ -393,8 +386,6 @@ static void ath_ant_div_conf_fast_divbia
+ 				ant_conf->fast_div_bias = 0x3f;
+ 			else
+ 				ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x20: /* LNA1 A-B */
+ 			if (!(antcomb->scan) &&
+@@ -402,13 +393,9 @@ static void ath_ant_div_conf_fast_divbia
+ 				ant_conf->fast_div_bias = 0x3f;
+ 			else
+ 				ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x21: /* LNA1 LNA2 */
+ 			ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x23: /* LNA1 A+B */
+ 			if (!(antcomb->scan) &&
+@@ -416,23 +403,15 @@ static void ath_ant_div_conf_fast_divbia
+ 				ant_conf->fast_div_bias = 0x3f;
+ 			else
+ 				ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x30: /* A+B A-B */
+ 			ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x31: /* A+B LNA2 */
+ 			ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x32: /* A+B LNA1 */
+ 			ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		default:
+ 			break;
+@@ -443,18 +422,12 @@ static void ath_ant_div_conf_fast_divbia
+ 				ant_conf->alt_lna_conf) {
+ 		case 0x01: /* A-B LNA2 */
+ 			ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x02: /* A-B LNA1 */
+ 			ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x03: /* A-B A+B */
+ 			ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x10: /* LNA2 A-B */
+ 			if (!(antcomb->scan) &&
+@@ -462,13 +435,9 @@ static void ath_ant_div_conf_fast_divbia
+ 				ant_conf->fast_div_bias = 0x1;
+ 			else
+ 				ant_conf->fast_div_bias = 0x2;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x12: /* LNA2 LNA1 */
+ 			ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x13: /* LNA2 A+B */
+ 			if (!(antcomb->scan) &&
+@@ -476,8 +445,6 @@ static void ath_ant_div_conf_fast_divbia
+ 				ant_conf->fast_div_bias = 0x1;
+ 			else
+ 				ant_conf->fast_div_bias = 0x2;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x20: /* LNA1 A-B */
+ 			if (!(antcomb->scan) &&
+@@ -485,13 +452,9 @@ static void ath_ant_div_conf_fast_divbia
+ 				ant_conf->fast_div_bias = 0x1;
+ 			else
+ 				ant_conf->fast_div_bias = 0x2;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x21: /* LNA1 LNA2 */
+ 			ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x23: /* LNA1 A+B */
+ 			if (!(antcomb->scan) &&
+@@ -499,23 +462,15 @@ static void ath_ant_div_conf_fast_divbia
+ 				ant_conf->fast_div_bias = 0x1;
+ 			else
+ 				ant_conf->fast_div_bias = 0x2;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x30: /* A+B A-B */
+ 			ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x31: /* A+B LNA2 */
+ 			ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		case 0x32: /* A+B LNA1 */
+ 			ant_conf->fast_div_bias = 0x1;
+-			ant_conf->main_gaintb = 0;
+-			ant_conf->alt_gaintb = 0;
+ 			break;
+ 		default:
+ 			break;
diff --git a/linux-next-cherry-picks/0069-ath9k-Remove-a-couple-of-unused-variables.patch b/linux-next-cherry-picks/0069-ath9k-Remove-a-couple-of-unused-variables.patch
new file mode 100644
index 0000000..bc632de
--- /dev/null
+++ b/linux-next-cherry-picks/0069-ath9k-Remove-a-couple-of-unused-variables.patch
@@ -0,0 +1,22 @@
+From 9b460d77e715b5b774ff927a1925b80b483283b1 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Sun, 16 Sep 2012 08:05:54 +0530
+Subject: [PATCH] ath9k: Remove a couple of unused variables
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ath9k.h | 2 --
+ 1 file changed, 2 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ath9k.h
++++ b/drivers/net/wireless/ath/ath9k/ath9k.h
+@@ -600,8 +600,6 @@ struct ath_ant_comb {
+ 	int main_conf;
+ 	enum ath9k_ant_div_comb_lna_conf first_quick_scan_conf;
+ 	enum ath9k_ant_div_comb_lna_conf second_quick_scan_conf;
+-	int first_bias;
+-	int second_bias;
+ 	bool first_ratio;
+ 	bool second_ratio;
+ 	unsigned long scan_start_time;
diff --git a/linux-next-cherry-picks/0070-ath9k_hw-Add-antenna-diversity-group-for-AR9565.patch b/linux-next-cherry-picks/0070-ath9k_hw-Add-antenna-diversity-group-for-AR9565.patch
new file mode 100644
index 0000000..89678eb
--- /dev/null
+++ b/linux-next-cherry-picks/0070-ath9k_hw-Add-antenna-diversity-group-for-AR9565.patch
@@ -0,0 +1,95 @@
+From 5317c9c3e9258b326c076d372e2eabf565d9a462 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Sun, 16 Sep 2012 08:06:08 +0530
+Subject: [PATCH] ath9k_hw: Add antenna diversity group for AR9565
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/antenna.c    | 62 +++++++++++++++++++++++++++++
+ drivers/net/wireless/ath/ath9k/ar9003_phy.c |  3 ++
+ 2 files changed, 65 insertions(+)
+
+--- a/drivers/net/wireless/ath/ath9k/antenna.c
++++ b/drivers/net/wireless/ath/ath9k/antenna.c
+@@ -475,6 +475,68 @@ static void ath_ant_div_conf_fast_divbia
+ 		default:
+ 			break;
+ 		}
++	} else if (ant_conf->div_group == 3) {
++		switch ((ant_conf->main_lna_conf << 4) |
++			ant_conf->alt_lna_conf) {
++		case 0x01: /* A-B LNA2 */
++			ant_conf->fast_div_bias = 0x1;
++			break;
++		case 0x02: /* A-B LNA1 */
++			ant_conf->fast_div_bias = 0x39;
++			break;
++		case 0x03: /* A-B A+B */
++			ant_conf->fast_div_bias = 0x1;
++			break;
++		case 0x10: /* LNA2 A-B */
++			if ((antcomb->scan == 0) &&
++			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)) {
++				ant_conf->fast_div_bias = 0x3f;
++			} else {
++				ant_conf->fast_div_bias = 0x1;
++			}
++			break;
++		case 0x12: /* LNA2 LNA1 */
++			ant_conf->fast_div_bias = 0x39;
++			break;
++		case 0x13: /* LNA2 A+B */
++			if ((antcomb->scan == 0) &&
++			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)) {
++				ant_conf->fast_div_bias = 0x3f;
++			} else {
++				ant_conf->fast_div_bias = 0x1;
++			}
++			break;
++		case 0x20: /* LNA1 A-B */
++			if ((antcomb->scan == 0) &&
++			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)) {
++				ant_conf->fast_div_bias = 0x3f;
++			} else {
++				ant_conf->fast_div_bias = 0x4;
++			}
++			break;
++		case 0x21: /* LNA1 LNA2 */
++			ant_conf->fast_div_bias = 0x6;
++			break;
++		case 0x23: /* LNA1 A+B */
++			if ((antcomb->scan == 0) &&
++			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)) {
++				ant_conf->fast_div_bias = 0x3f;
++			} else {
++				ant_conf->fast_div_bias = 0x6;
++			}
++			break;
++		case 0x30: /* A+B A-B */
++			ant_conf->fast_div_bias = 0x1;
++			break;
++		case 0x31: /* A+B LNA2 */
++			ant_conf->fast_div_bias = 0x6;
++			break;
++		case 0x32: /* A+B LNA1 */
++			ant_conf->fast_div_bias = 0x1;
++			break;
++		default:
++			break;
++		}
+ 	}
+ }
+ 
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+@@ -1291,6 +1291,9 @@ static void ar9003_hw_antdiv_comb_conf_g
+ 	} else if (AR_SREV_9485(ah)) {
+ 		antconf->lna1_lna2_delta = -9;
+ 		antconf->div_group = 2;
++	} else if (AR_SREV_9565(ah)) {
++		antconf->lna1_lna2_delta = -3;
++		antconf->div_group = 3;
+ 	} else {
+ 		antconf->lna1_lna2_delta = -3;
+ 		antconf->div_group = 0;
diff --git a/linux-next-cherry-picks/0071-ath9k_hw-Update-AR9565-initvals.patch b/linux-next-cherry-picks/0071-ath9k_hw-Update-AR9565-initvals.patch
new file mode 100644
index 0000000..1fac818
--- /dev/null
+++ b/linux-next-cherry-picks/0071-ath9k_hw-Update-AR9565-initvals.patch
@@ -0,0 +1,173 @@
+From 68f7586c7b2c471750f11ccb3e5ac8f57b1b953e Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Sun, 16 Sep 2012 08:06:22 +0530
+Subject: [PATCH] ath9k_hw: Update AR9565 initvals
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ .../net/wireless/ath/ath9k/ar9565_1p0_initvals.h   | 100 ++++++++++-----------
+ 1 file changed, 49 insertions(+), 51 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
++++ b/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
+@@ -58,8 +58,6 @@ static const u32 ar9565_1p0_mac_core[][2
+ 	{0x00008040, 0x00000000},
+ 	{0x00008044, 0x00000000},
+ 	{0x00008048, 0x00000000},
+-	{0x0000804c, 0xffffffff},
+-	{0x00008050, 0xffffffff},
+ 	{0x00008054, 0x00000000},
+ 	{0x00008058, 0x00000000},
+ 	{0x0000805c, 0x000fc78f},
+@@ -246,7 +244,7 @@ static const u32 ar9565_1p0_baseband_cor
+ 	{0x00009e50, 0x00ff03f1},
+ 	{0x00009e54, 0xe4c355c7},
+ 	{0x00009e5c, 0xe9198724},
+-	{0x00009fc0, 0x823e4788},
++	{0x00009fc0, 0x823e4fc8},
+ 	{0x00009fc4, 0x0001efb5},
+ 	{0x00009fcc, 0x40000014},
+ 	{0x0000a20c, 0x00000000},
+@@ -291,7 +289,7 @@ static const u32 ar9565_1p0_baseband_cor
+ 	{0x0000a3ec, 0x20202020},
+ 	{0x0000a3f0, 0x00000000},
+ 	{0x0000a3f4, 0x00000006},
+-	{0x0000a3f8, 0x0cdbd380},
++	{0x0000a3f8, 0x0c9bd380},
+ 	{0x0000a3fc, 0x000f0f01},
+ 	{0x0000a400, 0x8fa91f01},
+ 	{0x0000a404, 0x00000000},
+@@ -355,11 +353,11 @@ static const u32 ar9565_1p0_baseband_pos
+ 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
+ 	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
+ 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
+-	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcf946222, 0xcf946222},
++	{0x00009e3c, 0xcf946222, 0xcf946222, 0xcf946222, 0xcf946222},
+ 	{0x00009e44, 0xfe321e27, 0xfe321e27, 0xfe291e27, 0xfe291e27},
+ 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
+ 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
+-	{0x0000a204, 0x033187c0, 0x033187c4, 0x033187c4, 0x033187c0},
++	{0x0000a204, 0x07318fc0, 0x07318fc4, 0x07318fc4, 0x07318fc0},
+ 	{0x0000a208, 0x00000104, 0x00000104, 0x00000004, 0x00000004},
+ 	{0x0000a22c, 0x01026a2f, 0x01026a27, 0x01026a2f, 0x01026a2f},
+ 	{0x0000a230, 0x0000400a, 0x00004014, 0x00004016, 0x0000400b},
+@@ -375,9 +373,9 @@ static const u32 ar9565_1p0_baseband_pos
+ 	{0x0000a284, 0x00000000, 0x00000000, 0x00000150, 0x00000150},
+ 	{0x0000a288, 0x00100510, 0x00100510, 0x00100510, 0x00100510},
+ 	{0x0000a28c, 0x00021551, 0x00021551, 0x00021551, 0x00021551},
+-	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
++	{0x0000a2c4, 0x00058d18, 0x00058d18, 0x00058d18, 0x00058d18},
+ 	{0x0000a2d0, 0x00071982, 0x00071982, 0x00071982, 0x00071982},
+-	{0x0000a2d8, 0x7999a83a, 0x7999a83a, 0x7999a83a, 0x7999a83a},
++	{0x0000a2d8, 0x7999a83b, 0x7999a83b, 0x7999a83b, 0x7999a83b},
+ 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+ 	{0x0000ae04, 0x00800000, 0x00800000, 0x00800000, 0x00800000},
+ 	{0x0000ae18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+@@ -417,7 +415,7 @@ static const u32 ar9565_1p0_radio_core[]
+ 	{0x00016144, 0x02084080},
+ 	{0x00016148, 0x000080c0},
+ 	{0x00016280, 0x050a0001},
+-	{0x00016284, 0x3d841400},
++	{0x00016284, 0x3d841440},
+ 	{0x00016288, 0x00000000},
+ 	{0x0001628c, 0xe3000000},
+ 	{0x00016290, 0xa1004080},
+@@ -840,27 +838,27 @@ static const u32 ar9565_1p0_common_wo_xl
+ 	{0x0000a0b4, 0x00000000},
+ 	{0x0000a0b8, 0x00000000},
+ 	{0x0000a0bc, 0x00000000},
+-	{0x0000a0c0, 0x301f3000},
+-	{0x0000a0c4, 0x41004101},
+-	{0x0000a0c8, 0x411e411f},
+-	{0x0000a0cc, 0x411c411d},
+-	{0x0000a0d0, 0x42434244},
+-	{0x0000a0d4, 0x42414242},
+-	{0x0000a0d8, 0x425f4240},
+-	{0x0000a0dc, 0x5342425e},
+-	{0x0000a0e0, 0x53405341},
+-	{0x0000a0e4, 0x535e535f},
+-	{0x0000a0e8, 0x7402535d},
+-	{0x0000a0ec, 0x74007401},
+-	{0x0000a0f0, 0x741e741f},
+-	{0x0000a0f4, 0x7522741d},
+-	{0x0000a0f8, 0x75207521},
+-	{0x0000a0fc, 0x753e753f},
+-	{0x0000a100, 0x76617662},
+-	{0x0000a104, 0x767f7660},
+-	{0x0000a108, 0x767d767e},
+-	{0x0000a10c, 0x77e277e3},
+-	{0x0000a110, 0x77e077e1},
++	{0x0000a0c0, 0x00bf00a0},
++	{0x0000a0c4, 0x11a011a1},
++	{0x0000a0c8, 0x11be11bf},
++	{0x0000a0cc, 0x11bc11bd},
++	{0x0000a0d0, 0x22632264},
++	{0x0000a0d4, 0x22612262},
++	{0x0000a0d8, 0x227f2260},
++	{0x0000a0dc, 0x4322227e},
++	{0x0000a0e0, 0x43204321},
++	{0x0000a0e4, 0x433e433f},
++	{0x0000a0e8, 0x4462433d},
++	{0x0000a0ec, 0x44604461},
++	{0x0000a0f0, 0x447e447f},
++	{0x0000a0f4, 0x5582447d},
++	{0x0000a0f8, 0x55805581},
++	{0x0000a0fc, 0x559e559f},
++	{0x0000a100, 0x66816682},
++	{0x0000a104, 0x669f6680},
++	{0x0000a108, 0x669d669e},
++	{0x0000a10c, 0x77627763},
++	{0x0000a110, 0x77607761},
+ 	{0x0000a114, 0x00000000},
+ 	{0x0000a118, 0x00000000},
+ 	{0x0000a11c, 0x00000000},
+@@ -872,27 +870,27 @@ static const u32 ar9565_1p0_common_wo_xl
+ 	{0x0000a134, 0x00000000},
+ 	{0x0000a138, 0x00000000},
+ 	{0x0000a13c, 0x00000000},
+-	{0x0000a140, 0x301f3000},
+-	{0x0000a144, 0x41004101},
+-	{0x0000a148, 0x411e411f},
+-	{0x0000a14c, 0x411c411d},
+-	{0x0000a150, 0x42434244},
+-	{0x0000a154, 0x42414242},
+-	{0x0000a158, 0x425f4240},
+-	{0x0000a15c, 0x5342425e},
+-	{0x0000a160, 0x53405341},
+-	{0x0000a164, 0x535e535f},
+-	{0x0000a168, 0x7402535d},
+-	{0x0000a16c, 0x74007401},
+-	{0x0000a170, 0x741e741f},
+-	{0x0000a174, 0x7522741d},
+-	{0x0000a178, 0x75207521},
+-	{0x0000a17c, 0x753e753f},
+-	{0x0000a180, 0x76617662},
+-	{0x0000a184, 0x767f7660},
+-	{0x0000a188, 0x767d767e},
+-	{0x0000a18c, 0x77e277e3},
+-	{0x0000a190, 0x77e077e1},
++	{0x0000a140, 0x00bf00a0},
++	{0x0000a144, 0x11a011a1},
++	{0x0000a148, 0x11be11bf},
++	{0x0000a14c, 0x11bc11bd},
++	{0x0000a150, 0x22632264},
++	{0x0000a154, 0x22612262},
++	{0x0000a158, 0x227f2260},
++	{0x0000a15c, 0x4322227e},
++	{0x0000a160, 0x43204321},
++	{0x0000a164, 0x433e433f},
++	{0x0000a168, 0x4462433d},
++	{0x0000a16c, 0x44604461},
++	{0x0000a170, 0x447e447f},
++	{0x0000a174, 0x5582447d},
++	{0x0000a178, 0x55805581},
++	{0x0000a17c, 0x559e559f},
++	{0x0000a180, 0x66816682},
++	{0x0000a184, 0x669f6680},
++	{0x0000a188, 0x669d669e},
++	{0x0000a18c, 0x77627763},
++	{0x0000a190, 0x77607761},
+ 	{0x0000a194, 0x00000000},
+ 	{0x0000a198, 0x00000000},
+ 	{0x0000a19c, 0x00000000},
diff --git a/linux-next-cherry-picks/0072-ath9k_hw-Add-a-HW-callback-to-set-diversity.patch b/linux-next-cherry-picks/0072-ath9k_hw-Add-a-HW-callback-to-set-diversity.patch
new file mode 100644
index 0000000..f92cd37
--- /dev/null
+++ b/linux-next-cherry-picks/0072-ath9k_hw-Add-a-HW-callback-to-set-diversity.patch
@@ -0,0 +1,214 @@
+From 362cd03fd828af38327fb448416c07a7c7a8e3cb Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Sun, 16 Sep 2012 08:06:36 +0530
+Subject: [PATCH] ath9k_hw: Add a HW callback to set diversity
+
+This patch adds a new callback to handle WLAN RX diversity for
+AR9565.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 10 +++++
+ drivers/net/wireless/ath/ath9k/ar9003_phy.c    | 60 ++++++++++++++++++++++++++
+ drivers/net/wireless/ath/ath9k/ar9003_phy.h    | 24 +++++++++++
+ drivers/net/wireless/ath/ath9k/hw-ops.h        |  7 +++
+ drivers/net/wireless/ath/ath9k/hw.c            |  4 ++
+ drivers/net/wireless/ath/ath9k/hw.h            |  3 +-
+ 6 files changed, 107 insertions(+), 1 deletion(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+@@ -3633,6 +3633,16 @@ static void ar9003_hw_ant_ctrl_apply(str
+ 		/* enable_lnadiv */
+ 		regval &= (~AR_PHY_ANT_DIV_LNADIV);
+ 		regval |= ((value >> 6) & 0x1) << AR_PHY_ANT_DIV_LNADIV_S;
++
++		if (AR_SREV_9565(ah)) {
++			if (ah->shared_chain_lnadiv) {
++				regval |= (1 << AR_PHY_ANT_SW_RX_PROT_S);
++			} else {
++				regval &= ~(1 << AR_PHY_ANT_DIV_LNADIV_S);
++				regval &= ~(1 << AR_PHY_ANT_SW_RX_PROT_S);
++			}
++		}
++
+ 		REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
+ 
+ 		/*enable fast_div */
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+@@ -1325,6 +1325,65 @@ static void ar9003_hw_antdiv_comb_conf_s
+ 	REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
+ }
+ 
++static void ar9003_hw_antctrl_shared_chain_lnadiv(struct ath_hw *ah,
++						  bool enable)
++{
++	u8 ant_div_ctl1;
++	u32 regval;
++
++	if (!AR_SREV_9565(ah))
++		return;
++
++	ah->shared_chain_lnadiv = enable;
++	ant_div_ctl1 = ah->eep_ops->get_eeprom(ah, EEP_ANT_DIV_CTL1);
++
++	regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
++	regval &= (~AR_ANT_DIV_CTRL_ALL);
++	regval |= (ant_div_ctl1 & 0x3f) << AR_ANT_DIV_CTRL_ALL_S;
++	regval &= ~AR_PHY_ANT_DIV_LNADIV;
++	regval |= ((ant_div_ctl1 >> 6) & 0x1) << AR_PHY_ANT_DIV_LNADIV_S;
++
++	if (enable)
++		regval |= AR_ANT_DIV_ENABLE;
++
++	REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
++
++	regval = REG_READ(ah, AR_PHY_CCK_DETECT);
++	regval &= ~AR_FAST_DIV_ENABLE;
++	regval |= ((ant_div_ctl1 >> 7) & 0x1) << AR_FAST_DIV_ENABLE_S;
++
++	if (enable)
++		regval |= AR_FAST_DIV_ENABLE;
++
++	REG_WRITE(ah, AR_PHY_CCK_DETECT, regval);
++
++	if (enable) {
++		REG_SET_BIT(ah, AR_PHY_MC_GAIN_CTRL,
++			    (1 << AR_PHY_ANT_SW_RX_PROT_S));
++		if (IS_CHAN_2GHZ(ah->curchan))
++			REG_SET_BIT(ah, AR_PHY_RESTART,
++				    AR_PHY_RESTART_ENABLE_DIV_M2FLAG);
++		REG_SET_BIT(ah, AR_BTCOEX_WL_LNADIV,
++			    AR_BTCOEX_WL_LNADIV_FORCE_ON);
++	} else {
++		REG_CLR_BIT(ah, AR_PHY_MC_GAIN_CTRL, AR_ANT_DIV_ENABLE);
++		REG_CLR_BIT(ah, AR_PHY_MC_GAIN_CTRL,
++			    (1 << AR_PHY_ANT_SW_RX_PROT_S));
++		REG_CLR_BIT(ah, AR_PHY_CCK_DETECT, AR_FAST_DIV_ENABLE);
++		REG_CLR_BIT(ah, AR_BTCOEX_WL_LNADIV,
++			    AR_BTCOEX_WL_LNADIV_FORCE_ON);
++
++		regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
++		regval &= ~(AR_PHY_ANT_DIV_MAIN_LNACONF |
++			AR_PHY_ANT_DIV_ALT_LNACONF |
++			AR_PHY_ANT_DIV_MAIN_GAINTB |
++			AR_PHY_ANT_DIV_ALT_GAINTB);
++		regval |= (AR_PHY_ANT_DIV_LNA1 << AR_PHY_ANT_DIV_MAIN_LNACONF_S);
++		regval |= (AR_PHY_ANT_DIV_LNA2 << AR_PHY_ANT_DIV_ALT_LNACONF_S);
++		REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
++	}
++}
++
+ static int ar9003_hw_fast_chan_change(struct ath_hw *ah,
+ 				      struct ath9k_channel *chan,
+ 				      u8 *ini_reloaded)
+@@ -1423,6 +1482,7 @@ void ar9003_hw_attach_phy_ops(struct ath
+ 
+ 	ops->antdiv_comb_conf_get = ar9003_hw_antdiv_comb_conf_get;
+ 	ops->antdiv_comb_conf_set = ar9003_hw_antdiv_comb_conf_set;
++	ops->antctrl_shared_chain_lnadiv = ar9003_hw_antctrl_shared_chain_lnadiv;
+ 
+ 	ar9003_hw_set_nf_limits(ah);
+ 	ar9003_hw_set_radar_conf(ah);
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+@@ -282,6 +282,8 @@
+ 
+ #define AR_PHY_ANT_FAST_DIV_BIAS                0x00007e00
+ #define AR_PHY_ANT_FAST_DIV_BIAS_S              9
++#define AR_PHY_ANT_SW_RX_PROT                   0x00800000
++#define AR_PHY_ANT_SW_RX_PROT_S                 23
+ #define AR_PHY_ANT_DIV_LNADIV                   0x01000000
+ #define AR_PHY_ANT_DIV_LNADIV_S                 24
+ #define AR_PHY_ANT_DIV_ALT_LNACONF              0x06000000
+@@ -422,6 +424,8 @@
+ #define AR_PHY_FIND_SIG_RELSTEP        0x1f
+ #define AR_PHY_FIND_SIG_RELSTEP_S         0
+ #define AR_PHY_FIND_SIG_RELSTEP_SIGN_BIT  5
++#define AR_PHY_RESTART_ENABLE_DIV_M2FLAG 0x00200000
++#define AR_PHY_RESTART_ENABLE_DIV_M2FLAG_S 21
+ #define AR_PHY_RESTART_DIV_GC   0x001C0000
+ #define AR_PHY_RESTART_DIV_GC_S 18
+ #define AR_PHY_RESTART_ENA      0x01
+@@ -1261,4 +1265,24 @@
+ #define AR_PHY_CL_TAB_CL_GAIN_MOD		0x1f
+ #define AR_PHY_CL_TAB_CL_GAIN_MOD_S		0
+ 
++#define AR_BTCOEX_WL_LNADIV                                0x1a64
++#define AR_BTCOEX_WL_LNADIV_PREDICTED_PERIOD               0x00003FFF
++#define AR_BTCOEX_WL_LNADIV_PREDICTED_PERIOD_S             0
++#define AR_BTCOEX_WL_LNADIV_DPDT_IGNORE_PRIORITY           0x00004000
++#define AR_BTCOEX_WL_LNADIV_DPDT_IGNORE_PRIORITY_S         14
++#define AR_BTCOEX_WL_LNADIV_FORCE_ON                       0x00008000
++#define AR_BTCOEX_WL_LNADIV_FORCE_ON_S                     15
++#define AR_BTCOEX_WL_LNADIV_MODE_OPTION                    0x00030000
++#define AR_BTCOEX_WL_LNADIV_MODE_OPTION_S                  16
++#define AR_BTCOEX_WL_LNADIV_MODE                           0x007c0000
++#define AR_BTCOEX_WL_LNADIV_MODE_S                         18
++#define AR_BTCOEX_WL_LNADIV_ALLOWED_TX_ANTDIV_WL_TX_REQ    0x00800000
++#define AR_BTCOEX_WL_LNADIV_ALLOWED_TX_ANTDIV_WL_TX_REQ_S  23
++#define AR_BTCOEX_WL_LNADIV_DISABLE_TX_ANTDIV_ENABLE       0x01000000
++#define AR_BTCOEX_WL_LNADIV_DISABLE_TX_ANTDIV_ENABLE_S     24
++#define AR_BTCOEX_WL_LNADIV_CONTINUOUS_BT_ACTIVE_PROTECT   0x02000000
++#define AR_BTCOEX_WL_LNADIV_CONTINUOUS_BT_ACTIVE_PROTECT_S 25
++#define AR_BTCOEX_WL_LNADIV_BT_INACTIVE_THRESHOLD          0xFC000000
++#define AR_BTCOEX_WL_LNADIV_BT_INACTIVE_THRESHOLD_S        26
++
+ #endif  /* AR9003_PHY_H */
+--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
++++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
+@@ -78,6 +78,13 @@ static inline void ath9k_hw_antdiv_comb_
+ 	ath9k_hw_ops(ah)->antdiv_comb_conf_set(ah, antconf);
+ }
+ 
++static inline void ath9k_hw_antctrl_shared_chain_lnadiv(struct ath_hw *ah,
++							bool enable)
++{
++	if (ath9k_hw_ops(ah)->antctrl_shared_chain_lnadiv)
++		ath9k_hw_ops(ah)->antctrl_shared_chain_lnadiv(ah, enable);
++}
++
+ /* Private hardware call ops */
+ 
+ /* PHY ops */
+--- a/drivers/net/wireless/ath/ath9k/hw.c
++++ b/drivers/net/wireless/ath/ath9k/hw.c
+@@ -24,6 +24,7 @@
+ #include "rc.h"
+ #include "ar9003_mac.h"
+ #include "ar9003_mci.h"
++#include "ar9003_phy.h"
+ #include "debug.h"
+ #include "ath9k.h"
+ 
+@@ -2025,6 +2026,9 @@ int ath9k_hw_reset(struct ath_hw *ah, st
+ 
+ 	ath9k_hw_apply_gpio_override(ah);
+ 
++	if (AR_SREV_9565(ah) && ah->shared_chain_lnadiv)
++		REG_SET_BIT(ah, AR_BTCOEX_WL_LNADIV, AR_BTCOEX_WL_LNADIV_FORCE_ON);
++
+ 	return 0;
+ }
+ EXPORT_SYMBOL(ath9k_hw_reset);
+--- a/drivers/net/wireless/ath/ath9k/hw.h
++++ b/drivers/net/wireless/ath/ath9k/hw.h
+@@ -686,7 +686,7 @@ struct ath_hw_ops {
+ 			struct ath_hw_antcomb_conf *antconf);
+ 	void (*antdiv_comb_conf_set)(struct ath_hw *ah,
+ 			struct ath_hw_antcomb_conf *antconf);
+-
++	void (*antctrl_shared_chain_lnadiv)(struct ath_hw *hw, bool enable);
+ };
+ 
+ struct ath_nf_limits {
+@@ -730,6 +730,7 @@ struct ath_hw {
+ 	bool aspm_enabled;
+ 	bool is_monitoring;
+ 	bool need_an_top2_fixup;
++	bool shared_chain_lnadiv;
+ 	u16 tx_trig_level;
+ 
+ 	u32 nf_regs[6];
diff --git a/linux-next-cherry-picks/0073-ath9k-Add-a-module-parameter-to-enable-diversity.patch b/linux-next-cherry-picks/0073-ath9k-Add-a-module-parameter-to-enable-diversity.patch
new file mode 100644
index 0000000..3bdef0f
--- /dev/null
+++ b/linux-next-cherry-picks/0073-ath9k-Add-a-module-parameter-to-enable-diversity.patch
@@ -0,0 +1,69 @@
+From e09f2dc73c5c4927cbc55d9c29bef4209c2d866d Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Sun, 16 Sep 2012 08:06:56 +0530
+Subject: [PATCH] ath9k: Add a module parameter to enable diversity
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath.h           |  1 +
+ drivers/net/wireless/ath/ath9k/antenna.c |  4 ++++
+ drivers/net/wireless/ath/ath9k/init.c    | 12 ++++++++++++
+ 3 files changed, 17 insertions(+)
+
+--- a/drivers/net/wireless/ath/ath.h
++++ b/drivers/net/wireless/ath/ath.h
+@@ -159,6 +159,7 @@ struct ath_common {
+ 
+ 	bool btcoex_enabled;
+ 	bool disable_ani;
++	bool antenna_diversity;
+ };
+ 
+ struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
+--- a/drivers/net/wireless/ath/ath9k/antenna.c
++++ b/drivers/net/wireless/ath/ath9k/antenna.c
+@@ -776,6 +776,7 @@ div_comb_done:
+ void ath_ant_comb_update(struct ath_softc *sc)
+ {
+ 	struct ath_hw *ah = sc->sc_ah;
++	struct ath_common *common = ath9k_hw_common(ah);
+ 	struct ath_hw_antcomb_conf div_ant_conf;
+ 	u8 lna_conf;
+ 
+@@ -790,4 +791,7 @@ void ath_ant_comb_update(struct ath_soft
+ 	div_ant_conf.alt_lna_conf = lna_conf;
+ 
+ 	ath9k_hw_antdiv_comb_conf_set(ah, &div_ant_conf);
++
++	if (common->antenna_diversity)
++		ath9k_hw_antctrl_shared_chain_lnadiv(ah, true);
+ }
+--- a/drivers/net/wireless/ath/ath9k/init.c
++++ b/drivers/net/wireless/ath/ath9k/init.c
+@@ -48,6 +48,10 @@ static int ath9k_btcoex_enable;
+ module_param_named(btcoex_enable, ath9k_btcoex_enable, int, 0444);
+ MODULE_PARM_DESC(btcoex_enable, "Enable wifi-BT coexistence");
+ 
++static int ath9k_enable_diversity;
++module_param_named(enable_diversity, ath9k_enable_diversity, int, 0444);
++MODULE_PARM_DESC(enable_diversity, "Enable Antenna diversity for AR9565");
++
+ bool is_ath9k_unloaded;
+ /* We use the hw_value as an index into our private channel structure */
+ 
+@@ -548,6 +552,14 @@ static int ath9k_init_softc(u16 devid, s
+ 	common->debug_mask = ath9k_debug;
+ 	common->btcoex_enabled = ath9k_btcoex_enable == 1;
+ 	common->disable_ani = false;
++
++	/*
++	 * Enable Antenna diversity only when BTCOEX is disabled
++	 * and the user manually requests the feature.
++	 */
++	if (!common->btcoex_enabled && ath9k_enable_diversity)
++		common->antenna_diversity = 1;
++
+ 	spin_lock_init(&common->cc_lock);
+ 
+ 	spin_lock_init(&sc->sc_serial_rw);
diff --git a/linux-next-cherry-picks/0074-ath9k_hw-Enable-WLAN-RX-diversity-for-AR9565.patch b/linux-next-cherry-picks/0074-ath9k_hw-Enable-WLAN-RX-diversity-for-AR9565.patch
new file mode 100644
index 0000000..0673dca
--- /dev/null
+++ b/linux-next-cherry-picks/0074-ath9k_hw-Enable-WLAN-RX-diversity-for-AR9565.patch
@@ -0,0 +1,22 @@
+From 06236e53ce83d9f770a25a5305b8651544ff8b67 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qualcomm.com>
+Date: Sun, 16 Sep 2012 08:07:12 +0530
+Subject: [PATCH] ath9k_hw: Enable WLAN RX diversity for AR9565
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/hw.c | 2 +-
+ 1 file changed, 1 insertion(+), 1 deletion(-)
+
+--- a/drivers/net/wireless/ath/ath9k/hw.c
++++ b/drivers/net/wireless/ath/ath9k/hw.c
+@@ -2539,7 +2539,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw
+ 	}
+ 
+ 
+-	if (AR_SREV_9330(ah) || AR_SREV_9485(ah)) {
++	if (AR_SREV_9330(ah) || AR_SREV_9485(ah) || AR_SREV_9565(ah)) {
+ 		ant_div_ctl1 = ah->eep_ops->get_eeprom(ah, EEP_ANT_DIV_CTL1);
+ 		/*
+ 		 * enable the diversity-combining algorithm only when
diff --git a/linux-next-cherry-picks/0076-ath9k_hw-fix-BT-sleep-state-on-chip-wakeup.patch b/linux-next-cherry-picks/0076-ath9k_hw-fix-BT-sleep-state-on-chip-wakeup.patch
new file mode 100644
index 0000000..6ddd141
--- /dev/null
+++ b/linux-next-cherry-picks/0076-ath9k_hw-fix-BT-sleep-state-on-chip-wakeup.patch
@@ -0,0 +1,34 @@
+From a50d1fd4525162732b45db7a372e868933746a4e Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 24 Sep 2012 14:04:24 +0530
+Subject: [PATCH] ath9k_hw: fix BT sleep state on chip wakeup
+
+Whenever both WLAN and BT in/out sleep mode, sometimes WLAN
+is not able to take back the shared LNA control after resumes
+from sleep mode. The idea is that for WLAN to check if BT owns
+LNA control and BT is in sleep mode when WLAN just resumes from
+sleep mode. If the condition is true, do a BTCOEX_RC_WARM_RESET
+for WLAN to take back the control of shared LNA.
+Now the issue is the BT sleep value read from MCI register is
+overlooked by assigning u32 into u8. Hence the above condition never
+be met so that WLAN used to report beacon losses and frequent
+connection drops.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Tested-by: Paul Stewart <pstew@chromium.org>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c | 2 +-
+ 1 file changed, 1 insertion(+), 1 deletion(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -1289,7 +1289,7 @@ void ar9003_mci_set_power_awake(struct a
+ 	}
+ 	REG_WRITE(ah, AR_DIAG_SW, (diag_sw | BIT(27) | BIT(19) | BIT(18)));
+ 	lna_ctrl = REG_READ(ah, AR_OBS_BUS_CTRL) & 0x3;
+-	bt_sleep = REG_READ(ah, AR_MCI_RX_STATUS) & AR_MCI_RX_REMOTE_SLEEP;
++	bt_sleep = MS(REG_READ(ah, AR_MCI_RX_STATUS), AR_MCI_RX_REMOTE_SLEEP);
+ 
+ 	REG_WRITE(ah, AR_BTCOEX_CTRL2, btcoex_ctrl2);
+ 	REG_WRITE(ah, AR_DIAG_SW, diag_sw);
diff --git a/linux-next-pending/0001-ath9k_hw-move-2g5g-switch-before-nfcal-start.patch b/linux-next-pending/0001-ath9k_hw-move-2g5g-switch-before-nfcal-start.patch
deleted file mode 100644
index bb18563..0000000
--- a/linux-next-pending/0001-ath9k_hw-move-2g5g-switch-before-nfcal-start.patch
+++ /dev/null
@@ -1,31 +0,0 @@
-From 5d88e01b76d37789e84b1018ed83f9f9885c58e7 Mon Sep 17 00:00:00 2001
-From: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
-Date: Wed, 12 Sep 2012 13:29:19 +0000
-Subject: [PATCH] ath9k_hw: move 2g5g switch before nfcal start
-
-During fast channel change, perform 2g5g_switch before starting
-noisefloor calibration to avoid nfload timeout.
-
-Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/hw.c | 6 +++---
- 1 file changed, 3 insertions(+), 3 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/hw.c
-+++ b/drivers/net/wireless/ath/ath9k/hw.c
-@@ -1733,12 +1733,12 @@ static int ath9k_hw_do_fastcc(struct ath
- 	if (!ret)
- 		goto fail;
- 
--	ath9k_hw_loadnf(ah, ah->curchan);
--	ath9k_hw_start_nfcal(ah, true);
--
- 	if (ath9k_hw_mci_is_enabled(ah))
- 		ar9003_mci_2g5g_switch(ah, false);
- 
-+	ath9k_hw_loadnf(ah, ah->curchan);
-+	ath9k_hw_start_nfcal(ah, true);
-+
- 	if (AR_SREV_9271(ah))
- 		ar9002_hw_load_ani_reg(ah, chan);
- 
diff --git a/linux-next-pending/0002-ath9k_hw-fix-ar9462-selfgen-chainmask.patch b/linux-next-pending/0002-ath9k_hw-fix-ar9462-selfgen-chainmask.patch
deleted file mode 100644
index 24e0edb..0000000
--- a/linux-next-pending/0002-ath9k_hw-fix-ar9462-selfgen-chainmask.patch
+++ /dev/null
@@ -1,37 +0,0 @@
-From 7d0a5ba513d0b3119b887c6cedb67d35ae5ffa24 Mon Sep 17 00:00:00 2001
-From: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
-Date: Wed, 12 Sep 2012 13:29:20 +0000
-Subject: [PATCH] ath9k_hw: fix ar9462 selfgen chainmask
-
-When the 9462 is operating in 2G mode and MCI is enabled then
-reduce the selfgen chain mask to chain 1. Otherwise poor performance
-was reported at short range at Rx side when COEX is enabled.
-
-Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/ar9003_mci.c | 1 +
- drivers/net/wireless/ath/ath9k/ar9003_phy.c | 3 ---
- 2 files changed, 1 insertion(+), 3 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
-@@ -1027,6 +1027,7 @@ void ar9003_mci_2g5g_switch(struct ath_h
- 
- 		if (!(mci->config & ATH_MCI_CONFIG_DISABLE_OSLA))
- 			ar9003_mci_osla_setup(ah, true);
-+		REG_WRITE(ah, AR_SELFGEN_MASK, 0x02);
- 	} else {
- 		ar9003_mci_send_lna_take(ah, true);
- 		udelay(5);
---- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
-@@ -605,9 +605,6 @@ static void ar9003_hw_set_chain_masks(st
- 
- 	if ((ah->caps.hw_caps & ATH9K_HW_CAP_APM) && (tx == 0x7))
- 		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
--	else if (AR_SREV_9462(ah))
--		/* xxx only when MCI support is enabled */
--		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
- 	else
- 		REG_WRITE(ah, AR_SELFGEN_MASK, tx);
- 
diff --git a/linux-next-pending/0003-ath9k-flush-bt-profile-whenever-it-is-requested.patch b/linux-next-pending/0003-ath9k-flush-bt-profile-whenever-it-is-requested.patch
deleted file mode 100644
index e14ba44..0000000
--- a/linux-next-pending/0003-ath9k-flush-bt-profile-whenever-it-is-requested.patch
+++ /dev/null
@@ -1,88 +0,0 @@
-From 124cd270cecfefaa4150a9b889dd5d74affbf9c5 Mon Sep 17 00:00:00 2001
-From: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
-Date: Wed, 12 Sep 2012 13:29:21 +0000
-Subject: [PATCH] ath9k: flush bt profile whenever it is requested
-
-Before processing BT profiles or status messages, check whether
-it is requested to flush BT profile. Otherwise it might increase
-number of BT profiles that affects the WLAN performance. Also
-flush the profiles when MCI is recovering from broken rx. After
-flushing BT profiles, query BT topology to refetch them.
-
-Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/ar9003_mci.c |  4 ++++
- drivers/net/wireless/ath/ath9k/ar9003_mci.h |  4 +++-
- drivers/net/wireless/ath/ath9k/mci.c        | 12 +++++++++++-
- 3 files changed, 18 insertions(+), 2 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
-@@ -1236,6 +1236,10 @@ u32 ar9003_mci_state(struct ath_hw *ah,
- 	case MCI_STATE_NEED_FTP_STOMP:
- 		value = !(mci->config & ATH_MCI_CONFIG_DISABLE_FTP_STOMP);
- 		break;
-+	case MCI_STATE_NEED_FLUSH_BT_INFO:
-+		value = (!mci->unhalt_bt_gpm && mci->need_flush_btinfo) ? 1 : 0;
-+		mci->need_flush_btinfo = false;
-+		break;
- 	default:
- 		break;
- 	}
---- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
-@@ -200,6 +200,7 @@ enum mci_state_type {
- 	MCI_STATE_RECOVER_RX,
- 	MCI_STATE_NEED_FTP_STOMP,
- 	MCI_STATE_DEBUG,
-+	MCI_STATE_NEED_FLUSH_BT_INFO,
- 	MCI_STATE_MAX
- };
- 
-@@ -211,7 +212,8 @@ enum mci_gpm_coex_opcode {
- 	MCI_GPM_COEX_WLAN_CHANNELS,
- 	MCI_GPM_COEX_BT_PROFILE_INFO,
- 	MCI_GPM_COEX_BT_STATUS_UPDATE,
--	MCI_GPM_COEX_BT_UPDATE_FLAGS
-+	MCI_GPM_COEX_BT_UPDATE_FLAGS,
-+	MCI_GPM_COEX_NOOP,
- };
- 
- #define MCI_GPM_NOMORE  0
---- a/drivers/net/wireless/ath/ath9k/mci.c
-+++ b/drivers/net/wireless/ath/ath9k/mci.c
-@@ -80,6 +80,7 @@ void ath_mci_flush_profile(struct ath_mc
- 	struct ath_mci_profile_info *info, *tinfo;
- 
- 	mci->aggr_limit = 0;
-+	mci->num_mgmt = 0;
- 
- 	if (list_empty(&mci->info))
- 		return;
-@@ -328,6 +329,13 @@ static void ath_mci_msg(struct ath_softc
- 	u8 major, minor;
- 	u32 seq_num;
- 
-+	if (ar9003_mci_state(ah, MCI_STATE_NEED_FLUSH_BT_INFO) &&
-+	    ar9003_mci_state(ah, MCI_STATE_ENABLE)) {
-+		ath_dbg(common, MCI, "(MCI) Need to flush BT profiles\n");
-+		ath_mci_flush_profile(&sc->btcoex.mci);
-+		ar9003_mci_state(ah, MCI_STATE_SEND_STATUS_QUERY);
-+	}
-+
- 	switch (opcode) {
- 	case MCI_GPM_COEX_VERSION_QUERY:
- 		ar9003_mci_state(ah, MCI_STATE_SEND_WLAN_COEX_VERSION);
-@@ -568,9 +576,11 @@ void ath_mci_intr(struct ath_softc *sc)
- 	}
- 
- 	if ((mci_int & AR_MCI_INTERRUPT_RX_INVALID_HDR) ||
--	    (mci_int & AR_MCI_INTERRUPT_CONT_INFO_TIMEOUT))
-+	    (mci_int & AR_MCI_INTERRUPT_CONT_INFO_TIMEOUT)) {
- 		mci_int &= ~(AR_MCI_INTERRUPT_RX_INVALID_HDR |
- 			     AR_MCI_INTERRUPT_CONT_INFO_TIMEOUT);
-+		ath_mci_msg(sc, MCI_GPM_COEX_NOOP, NULL);
-+	}
- }
- 
- void ath_mci_enable(struct ath_softc *sc)
diff --git a/linux-next-pending/0004-ath9k-move-coex-param-updation-within-mci-work.patch b/linux-next-pending/0004-ath9k-move-coex-param-updation-within-mci-work.patch
deleted file mode 100644
index 63af3c3..0000000
--- a/linux-next-pending/0004-ath9k-move-coex-param-updation-within-mci-work.patch
+++ /dev/null
@@ -1,57 +0,0 @@
-From ce52066d32a154921baea678d2886e8b495f55dc Mon Sep 17 00:00:00 2001
-From: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
-Date: Wed, 12 Sep 2012 13:29:22 +0000
-Subject: [PATCH] ath9k: move coex param updation within mci work
-
-Update all coex parameters in sigle place. So that we can avoid
-redoing the same operation in mutiple places and it eases debugging.
-
-Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/mci.c | 20 +++++++++-----------
- 1 file changed, 9 insertions(+), 11 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/mci.c
-+++ b/drivers/net/wireless/ath/ath9k/mci.c
-@@ -121,7 +121,14 @@ static void ath_mci_update_scheme(struct
- 	if (mci_hw->config & ATH_MCI_CONFIG_DISABLE_TUNING)
- 		goto skip_tuning;
- 
-+	mci->aggr_limit = 0;
- 	btcoex->duty_cycle = ath_mci_duty_cycle[num_profile];
-+	btcoex->btcoex_period = ATH_MCI_DEF_BT_PERIOD;
-+	if (NUM_PROF(mci))
-+		btcoex->bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
-+	else
-+		btcoex->bt_stomp_type = mci->num_mgmt ? ATH_BTCOEX_STOMP_ALL :
-+							ATH_BTCOEX_STOMP_LOW;
- 
- 	if (num_profile == 1) {
- 		info = list_first_entry(&mci->info,
-@@ -133,7 +140,8 @@ static void ath_mci_update_scheme(struct
- 			else if (info->T == 6) {
- 				mci->aggr_limit = 6;
- 				btcoex->duty_cycle = 30;
--			}
-+			} else
-+				mci->aggr_limit = 6;
- 			ath_dbg(common, MCI,
- 				"Single SCO, aggregation limit %d 1/4 ms\n",
- 				mci->aggr_limit);
-@@ -273,16 +281,6 @@ static void ath_mci_process_profile(stru
- 	} else
- 		ath_mci_del_profile(common, mci, entry);
- 
--	btcoex->btcoex_period = ATH_MCI_DEF_BT_PERIOD;
--	mci->aggr_limit = mci->num_sco ? 6 : 0;
--
--	btcoex->duty_cycle = ath_mci_duty_cycle[NUM_PROF(mci)];
--	if (NUM_PROF(mci))
--		btcoex->bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
--	else
--		btcoex->bt_stomp_type = mci->num_mgmt ? ATH_BTCOEX_STOMP_ALL :
--							ATH_BTCOEX_STOMP_LOW;
--
- 	ieee80211_queue_work(sc->hw, &sc->mci_work);
- }
- 
diff --git a/linux-next-pending/0005-ath9k-fill-led_pin-before-drv_start.patch b/linux-next-pending/0005-ath9k-fill-led_pin-before-drv_start.patch
deleted file mode 100644
index 8d6f57d..0000000
--- a/linux-next-pending/0005-ath9k-fill-led_pin-before-drv_start.patch
+++ /dev/null
@@ -1,108 +0,0 @@
-From be7ca23abe8efbf955c731e4326b8046046adeee Mon Sep 17 00:00:00 2001
-From: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
-Date: Wed, 12 Sep 2012 13:29:23 +0000
-Subject: [PATCH] ath9k: fill led_pin before drv_start
-
-Ensure that led pin is filled and set to OFF before starting
-the driver. With recent changes, drv_start is being called even
-before led_init is being completed. This is causing led is always
-OFF on driver load when the interface is UP. This patch splits the
-led init and fills the led pin before register hw.
-
-Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/ath9k.h |  4 ++++
- drivers/net/wireless/ath/ath9k/gpio.c  | 44 +++++++++++++++++++---------------
- drivers/net/wireless/ath/ath9k/init.c  |  1 +
- 3 files changed, 30 insertions(+), 19 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/ath9k.h
-+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
-@@ -537,6 +537,7 @@ struct ath9k_wow_pattern {
- #ifdef CONFIG_MAC80211_LEDS
- void ath_init_leds(struct ath_softc *sc);
- void ath_deinit_leds(struct ath_softc *sc);
-+void ath_fill_led_pin(struct ath_softc *sc);
- #else
- static inline void ath_init_leds(struct ath_softc *sc)
- {
-@@ -545,6 +546,9 @@ static inline void ath_init_leds(struct
- static inline void ath_deinit_leds(struct ath_softc *sc)
- {
- }
-+static inline void ath_fill_led_pin(struct ath_softc *sc)
-+{
-+}
- #endif
- 
- /*******************************/
---- a/drivers/net/wireless/ath/ath9k/gpio.c
-+++ b/drivers/net/wireless/ath/ath9k/gpio.c
-@@ -44,25 +44,6 @@ void ath_init_leds(struct ath_softc *sc)
- 	if (AR_SREV_9100(sc->sc_ah))
- 		return;
- 
--	if (sc->sc_ah->led_pin < 0) {
--		if (AR_SREV_9287(sc->sc_ah))
--			sc->sc_ah->led_pin = ATH_LED_PIN_9287;
--		else if (AR_SREV_9485(sc->sc_ah))
--			sc->sc_ah->led_pin = ATH_LED_PIN_9485;
--		else if (AR_SREV_9300(sc->sc_ah))
--			sc->sc_ah->led_pin = ATH_LED_PIN_9300;
--		else if (AR_SREV_9462(sc->sc_ah) || AR_SREV_9565(sc->sc_ah))
--			sc->sc_ah->led_pin = ATH_LED_PIN_9462;
--		else
--			sc->sc_ah->led_pin = ATH_LED_PIN_DEF;
--	}
--
--	/* Configure gpio 1 for output */
--	ath9k_hw_cfg_output(sc->sc_ah, sc->sc_ah->led_pin,
--			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
--	/* LED off, active low */
--	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
--
- 	if (!led_blink)
- 		sc->led_cdev.default_trigger =
- 			ieee80211_get_radio_led_name(sc->hw);
-@@ -78,6 +59,31 @@ void ath_init_leds(struct ath_softc *sc)
- 
- 	sc->led_registered = true;
- }
-+
-+void ath_fill_led_pin(struct ath_softc *sc)
-+{
-+	struct ath_hw *ah = sc->sc_ah;
-+
-+	if (AR_SREV_9100(ah) || (ah->led_pin >= 0))
-+		return;
-+
-+	if (AR_SREV_9287(ah))
-+		ah->led_pin = ATH_LED_PIN_9287;
-+	else if (AR_SREV_9485(sc->sc_ah))
-+		ah->led_pin = ATH_LED_PIN_9485;
-+	else if (AR_SREV_9300(sc->sc_ah))
-+		ah->led_pin = ATH_LED_PIN_9300;
-+	else if (AR_SREV_9462(sc->sc_ah) || AR_SREV_9565(sc->sc_ah))
-+		ah->led_pin = ATH_LED_PIN_9462;
-+	else
-+		ah->led_pin = ATH_LED_PIN_DEF;
-+
-+	/* Configure gpio 1 for output */
-+	ath9k_hw_cfg_output(ah, ah->led_pin, AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-+
-+	/* LED off, active low */
-+	ath9k_hw_set_gpio(ah, ah->led_pin, 1);
-+}
- #endif
- 
- /*******************/
---- a/drivers/net/wireless/ath/ath9k/init.c
-+++ b/drivers/net/wireless/ath/ath9k/init.c
-@@ -599,6 +599,7 @@ static int ath9k_init_softc(u16 devid, s
- 
- 	ath9k_cmn_init_crypto(sc->sc_ah);
- 	ath9k_init_misc(sc);
-+	ath_fill_led_pin(sc);
- 
- 	if (common->bus_ops->aspm_init)
- 		common->bus_ops->aspm_init(common);
diff --git a/linux-next-pending/0006-ath9k-fix-queuing-MCI-work-twice.patch b/linux-next-pending/0006-ath9k-fix-queuing-MCI-work-twice.patch
deleted file mode 100644
index 74201bc..0000000
--- a/linux-next-pending/0006-ath9k-fix-queuing-MCI-work-twice.patch
+++ /dev/null
@@ -1,109 +0,0 @@
-From c288389223d0a72577c3b266de1ee1d32ecb6c84 Mon Sep 17 00:00:00 2001
-From: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
-Date: Wed, 12 Sep 2012 13:29:24 +0000
-Subject: [PATCH] ath9k: fix queuing MCI work twice
-
-Right now MCI work is being queued twice by profile and status
-updation. Queue MCI work once when it is needed.
-
-Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/mci.c | 30 +++++++++++++++++-------------
- 1 file changed, 17 insertions(+), 13 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/mci.c
-+++ b/drivers/net/wireless/ath/ath9k/mci.c
-@@ -250,8 +250,8 @@ static void ath9k_mci_work(struct work_s
- 	ath_mci_update_scheme(sc);
- }
- 
--static void ath_mci_process_profile(struct ath_softc *sc,
--				    struct ath_mci_profile_info *info)
-+static u8 ath_mci_process_profile(struct ath_softc *sc,
-+				  struct ath_mci_profile_info *info)
- {
- 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
- 	struct ath_btcoex *btcoex = &sc->btcoex;
-@@ -277,15 +277,15 @@ static void ath_mci_process_profile(stru
- 
- 	if (info->start) {
- 		if (!entry && !ath_mci_add_profile(common, mci, info))
--			return;
-+			return 0;
- 	} else
- 		ath_mci_del_profile(common, mci, entry);
- 
--	ieee80211_queue_work(sc->hw, &sc->mci_work);
-+	return 1;
- }
- 
--static void ath_mci_process_status(struct ath_softc *sc,
--				   struct ath_mci_profile_status *status)
-+static u8 ath_mci_process_status(struct ath_softc *sc,
-+				 struct ath_mci_profile_status *status)
- {
- 	struct ath_btcoex *btcoex = &sc->btcoex;
- 	struct ath_mci_profile *mci = &btcoex->mci;
-@@ -294,14 +294,14 @@ static void ath_mci_process_status(struc
- 
- 	/* Link status type are not handled */
- 	if (status->is_link)
--		return;
-+		return 0;
- 
- 	info.conn_handle = status->conn_handle;
- 	if (ath_mci_find_profile(mci, &info))
--		return;
-+		return 0;
- 
- 	if (status->conn_handle >= ATH_MCI_MAX_PROFILE)
--		return;
-+		return 0;
- 
- 	if (status->is_critical)
- 		__set_bit(status->conn_handle, mci->status);
-@@ -315,7 +315,9 @@ static void ath_mci_process_status(struc
- 	} while (++i < ATH_MCI_MAX_PROFILE);
- 
- 	if (old_num_mgmt != mci->num_mgmt)
--		ieee80211_queue_work(sc->hw, &sc->mci_work);
-+		return 1;
-+
-+	return 0;
- }
- 
- static void ath_mci_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
-@@ -324,7 +326,7 @@ static void ath_mci_msg(struct ath_softc
- 	struct ath_mci_profile_info profile_info;
- 	struct ath_mci_profile_status profile_status;
- 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
--	u8 major, minor;
-+	u8 major, minor, update_scheme = 0;
- 	u32 seq_num;
- 
- 	if (ar9003_mci_state(ah, MCI_STATE_NEED_FLUSH_BT_INFO) &&
-@@ -359,7 +361,7 @@ static void ath_mci_msg(struct ath_softc
- 			break;
- 		}
- 
--		ath_mci_process_profile(sc, &profile_info);
-+		update_scheme += ath_mci_process_profile(sc, &profile_info);
- 		break;
- 	case MCI_GPM_COEX_BT_STATUS_UPDATE:
- 		profile_status.is_link = *(rx_payload +
-@@ -375,12 +377,14 @@ static void ath_mci_msg(struct ath_softc
- 			profile_status.is_link, profile_status.conn_handle,
- 			profile_status.is_critical, seq_num);
- 
--		ath_mci_process_status(sc, &profile_status);
-+		update_scheme += ath_mci_process_status(sc, &profile_status);
- 		break;
- 	default:
- 		ath_dbg(common, MCI, "Unknown GPM COEX message = 0x%02x\n", opcode);
- 		break;
- 	}
-+	if (update_scheme)
-+		ieee80211_queue_work(sc->hw, &sc->mci_work);
- }
- 
- int ath_mci_setup(struct ath_softc *sc)
diff --git a/linux-next-pending/0007-ath9k-Enable-SGI-correctly.patch b/linux-next-pending/0007-ath9k-Enable-SGI-correctly.patch
deleted file mode 100644
index d31ae45..0000000
--- a/linux-next-pending/0007-ath9k-Enable-SGI-correctly.patch
+++ /dev/null
@@ -1,34 +0,0 @@
-From 9cb4cd6d3ea2c1400cbd371b9af7651c6d8a484a Mon Sep 17 00:00:00 2001
-From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
-Date: Wed, 12 Sep 2012 14:47:40 +0530
-Subject: [PATCH] ath9k: Enable SGI correctly
-
-Set the driver specific SGI flag based on the station's
-HT capabilities, otherwise rate control uses the wrong rate.
-
-Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/rc.c | 11 +++++++----
- 1 file changed, 7 insertions(+), 4 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/rc.c
-+++ b/drivers/net/wireless/ath/ath9k/rc.c
-@@ -1222,11 +1222,14 @@ static u8 ath_rc_build_ht_caps(struct at
- 			caps |= WLAN_RC_TS_FLAG | WLAN_RC_DS_FLAG;
- 		else if (sta->ht_cap.mcs.rx_mask[1])
- 			caps |= WLAN_RC_DS_FLAG;
--		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
-+		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
- 			caps |= WLAN_RC_40_FLAG;
--		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40 ||
--		    sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20)
--			caps |= WLAN_RC_SGI_FLAG;
-+			if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40)
-+				caps |= WLAN_RC_SGI_FLAG;
-+		} else {
-+			if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20)
-+				caps |= WLAN_RC_SGI_FLAG;
-+		}
- 	}
- 
- 	return caps;
diff --git a/linux-next-pending/0008-ath9k_hw-Use-HW-cap-ATH9K_HW_CAP_ANT_DIV_COMB.patch b/linux-next-pending/0008-ath9k_hw-Use-HW-cap-ATH9K_HW_CAP_ANT_DIV_COMB.patch
deleted file mode 100644
index cdfb43b..0000000
--- a/linux-next-pending/0008-ath9k_hw-Use-HW-cap-ATH9K_HW_CAP_ANT_DIV_COMB.patch
+++ /dev/null
@@ -1,50 +0,0 @@
-From 50c4d94a2a2fa2eef71a0cb2756d2822d408ac8e Mon Sep 17 00:00:00 2001
-From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
-Date: Tue, 11 Sep 2012 09:40:33 +0530
-Subject: [PATCH] ath9k_hw: Use HW cap ATH9K_HW_CAP_ANT_DIV_COMB
-
-Instead of trying to determine whether antenna diversity is
-enabled by parsing eeprom data, use ATH9K_HW_CAP_ANT_DIV_COMB
-which is already filled at init time.
-
-Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 10 +++-------
- 1 file changed, 3 insertions(+), 7 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
-@@ -3562,9 +3562,9 @@ static u16 ar9003_hw_ant_ctrl_chain_get(
- 
- static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
- {
-+	struct ath9k_hw_capabilities *pCap = &ah->caps;
- 	int chain;
- 	u32 regval;
--	u32 ant_div_ctl1;
- 	static const u32 switch_chain_reg[AR9300_MAX_CHAINS] = {
- 			AR_PHY_SWITCH_CHAIN_0,
- 			AR_PHY_SWITCH_CHAIN_1,
-@@ -3636,9 +3636,8 @@ static void ar9003_hw_ant_ctrl_apply(str
- 		regval &= (~AR_FAST_DIV_ENABLE);
- 		regval |= ((value >> 7) & 0x1) << AR_FAST_DIV_ENABLE_S;
- 		REG_WRITE(ah, AR_PHY_CCK_DETECT, regval);
--		ant_div_ctl1 = ah->eep_ops->get_eeprom(ah, EEP_ANT_DIV_CTL1);
--		/* check whether antenna diversity is enabled */
--		if ((ant_div_ctl1 >> 0x6) == 0x3) {
-+
-+		if (pCap->hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) {
- 			regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
- 			/*
- 			 * clear bits 25-30 main_lnaconf, alt_lnaconf,
-@@ -3655,10 +3654,7 @@ static void ar9003_hw_ant_ctrl_apply(str
- 				   AR_PHY_ANT_DIV_ALT_LNACONF_S);
- 			REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
- 		}
--
--
- 	}
--
- }
- 
- static void ar9003_hw_drive_strength_apply(struct ath_hw *ah)
diff --git a/linux-next-pending/0009-ath9k-Remove-redundant-variable-assignment.patch b/linux-next-pending/0009-ath9k-Remove-redundant-variable-assignment.patch
deleted file mode 100644
index bab8624..0000000
--- a/linux-next-pending/0009-ath9k-Remove-redundant-variable-assignment.patch
+++ /dev/null
@@ -1,185 +0,0 @@
-From 5a11a1181c98f473eb19a96c4078891495562768 Mon Sep 17 00:00:00 2001
-From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
-Date: Wed, 12 Sep 2012 09:50:46 +0530
-Subject: [PATCH] ath9k: Remove redundant variable assignment
-
-Set main_gaintb and alt_gaintb once instead of zero'ing them
-in every case.
-
-Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/antenna.c | 51 ++------------------------------
- 1 file changed, 3 insertions(+), 48 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/antenna.c
-+++ b/drivers/net/wireless/ath/ath9k/antenna.c
-@@ -311,6 +311,9 @@ static void ath_ant_div_conf_fast_divbia
- 					  struct ath_ant_comb *antcomb,
- 					  int alt_ratio)
- {
-+	ant_conf->main_gaintb = 0;
-+	ant_conf->alt_gaintb = 0;
-+
- 	if (ant_conf->div_group == 0) {
- 		/* Adjust the fast_div_bias based on main and alt lna conf */
- 		switch ((ant_conf->main_lna_conf << 4) |
-@@ -360,18 +363,12 @@ static void ath_ant_div_conf_fast_divbia
- 			ant_conf->alt_lna_conf) {
- 		case 0x01: /* A-B LNA2 */
- 			ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x02: /* A-B LNA1 */
- 			ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x03: /* A-B A+B */
- 			ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x10: /* LNA2 A-B */
- 			if (!(antcomb->scan) &&
-@@ -379,13 +376,9 @@ static void ath_ant_div_conf_fast_divbia
- 				ant_conf->fast_div_bias = 0x3f;
- 			else
- 				ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x12: /* LNA2 LNA1 */
- 			ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x13: /* LNA2 A+B */
- 			if (!(antcomb->scan) &&
-@@ -393,8 +386,6 @@ static void ath_ant_div_conf_fast_divbia
- 				ant_conf->fast_div_bias = 0x3f;
- 			else
- 				ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x20: /* LNA1 A-B */
- 			if (!(antcomb->scan) &&
-@@ -402,13 +393,9 @@ static void ath_ant_div_conf_fast_divbia
- 				ant_conf->fast_div_bias = 0x3f;
- 			else
- 				ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x21: /* LNA1 LNA2 */
- 			ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x23: /* LNA1 A+B */
- 			if (!(antcomb->scan) &&
-@@ -416,23 +403,15 @@ static void ath_ant_div_conf_fast_divbia
- 				ant_conf->fast_div_bias = 0x3f;
- 			else
- 				ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x30: /* A+B A-B */
- 			ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x31: /* A+B LNA2 */
- 			ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x32: /* A+B LNA1 */
- 			ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		default:
- 			break;
-@@ -443,18 +422,12 @@ static void ath_ant_div_conf_fast_divbia
- 				ant_conf->alt_lna_conf) {
- 		case 0x01: /* A-B LNA2 */
- 			ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x02: /* A-B LNA1 */
- 			ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x03: /* A-B A+B */
- 			ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x10: /* LNA2 A-B */
- 			if (!(antcomb->scan) &&
-@@ -462,13 +435,9 @@ static void ath_ant_div_conf_fast_divbia
- 				ant_conf->fast_div_bias = 0x1;
- 			else
- 				ant_conf->fast_div_bias = 0x2;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x12: /* LNA2 LNA1 */
- 			ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x13: /* LNA2 A+B */
- 			if (!(antcomb->scan) &&
-@@ -476,8 +445,6 @@ static void ath_ant_div_conf_fast_divbia
- 				ant_conf->fast_div_bias = 0x1;
- 			else
- 				ant_conf->fast_div_bias = 0x2;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x20: /* LNA1 A-B */
- 			if (!(antcomb->scan) &&
-@@ -485,13 +452,9 @@ static void ath_ant_div_conf_fast_divbia
- 				ant_conf->fast_div_bias = 0x1;
- 			else
- 				ant_conf->fast_div_bias = 0x2;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x21: /* LNA1 LNA2 */
- 			ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x23: /* LNA1 A+B */
- 			if (!(antcomb->scan) &&
-@@ -499,23 +462,15 @@ static void ath_ant_div_conf_fast_divbia
- 				ant_conf->fast_div_bias = 0x1;
- 			else
- 				ant_conf->fast_div_bias = 0x2;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x30: /* A+B A-B */
- 			ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x31: /* A+B LNA2 */
- 			ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		case 0x32: /* A+B LNA1 */
- 			ant_conf->fast_div_bias = 0x1;
--			ant_conf->main_gaintb = 0;
--			ant_conf->alt_gaintb = 0;
- 			break;
- 		default:
- 			break;
diff --git a/linux-next-pending/0010-ath9k-Remove-a-couple-of-unused-variables.patch b/linux-next-pending/0010-ath9k-Remove-a-couple-of-unused-variables.patch
deleted file mode 100644
index e422dd9..0000000
--- a/linux-next-pending/0010-ath9k-Remove-a-couple-of-unused-variables.patch
+++ /dev/null
@@ -1,21 +0,0 @@
-From 26dfde87c3d2396aa0d0850419c517c9d2c1079b Mon Sep 17 00:00:00 2001
-From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
-Date: Wed, 12 Sep 2012 10:14:40 +0530
-Subject: [PATCH] ath9k: Remove a couple of unused variables
-
-Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/ath9k.h | 2 --
- 1 file changed, 2 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/ath9k.h
-+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
-@@ -600,8 +600,6 @@ struct ath_ant_comb {
- 	int main_conf;
- 	enum ath9k_ant_div_comb_lna_conf first_quick_scan_conf;
- 	enum ath9k_ant_div_comb_lna_conf second_quick_scan_conf;
--	int first_bias;
--	int second_bias;
- 	bool first_ratio;
- 	bool second_ratio;
- 	unsigned long scan_start_time;
diff --git a/linux-next-pending/0011-ath9k_hw-Add-antenna-diversity-group-for-AR9565.patch b/linux-next-pending/0011-ath9k_hw-Add-antenna-diversity-group-for-AR9565.patch
deleted file mode 100644
index c39e7f9..0000000
--- a/linux-next-pending/0011-ath9k_hw-Add-antenna-diversity-group-for-AR9565.patch
+++ /dev/null
@@ -1,94 +0,0 @@
-From b05e2d65d397b36b22a2dc9080d5c8305c503140 Mon Sep 17 00:00:00 2001
-From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
-Date: Tue, 11 Sep 2012 09:25:40 +0530
-Subject: [PATCH] ath9k_hw: Add antenna diversity group for AR9565
-
-Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/antenna.c    | 62 +++++++++++++++++++++++++++++
- drivers/net/wireless/ath/ath9k/ar9003_phy.c |  3 ++
- 2 files changed, 65 insertions(+)
-
---- a/drivers/net/wireless/ath/ath9k/antenna.c
-+++ b/drivers/net/wireless/ath/ath9k/antenna.c
-@@ -475,6 +475,68 @@ static void ath_ant_div_conf_fast_divbia
- 		default:
- 			break;
- 		}
-+	} else if (ant_conf->div_group == 3) {
-+		switch ((ant_conf->main_lna_conf << 4) |
-+			ant_conf->alt_lna_conf) {
-+		case 0x01: /* A-B LNA2 */
-+			ant_conf->fast_div_bias = 0x1;
-+			break;
-+		case 0x02: /* A-B LNA1 */
-+			ant_conf->fast_div_bias = 0x39;
-+			break;
-+		case 0x03: /* A-B A+B */
-+			ant_conf->fast_div_bias = 0x1;
-+			break;
-+		case 0x10: /* LNA2 A-B */
-+			if ((antcomb->scan == 0) &&
-+			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)) {
-+				ant_conf->fast_div_bias = 0x3f;
-+			} else {
-+				ant_conf->fast_div_bias = 0x1;
-+			}
-+			break;
-+		case 0x12: /* LNA2 LNA1 */
-+			ant_conf->fast_div_bias = 0x39;
-+			break;
-+		case 0x13: /* LNA2 A+B */
-+			if ((antcomb->scan == 0) &&
-+			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)) {
-+				ant_conf->fast_div_bias = 0x3f;
-+			} else {
-+				ant_conf->fast_div_bias = 0x1;
-+			}
-+			break;
-+		case 0x20: /* LNA1 A-B */
-+			if ((antcomb->scan == 0) &&
-+			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)) {
-+				ant_conf->fast_div_bias = 0x3f;
-+			} else {
-+				ant_conf->fast_div_bias = 0x4;
-+			}
-+			break;
-+		case 0x21: /* LNA1 LNA2 */
-+			ant_conf->fast_div_bias = 0x6;
-+			break;
-+		case 0x23: /* LNA1 A+B */
-+			if ((antcomb->scan == 0) &&
-+			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)) {
-+				ant_conf->fast_div_bias = 0x3f;
-+			} else {
-+				ant_conf->fast_div_bias = 0x6;
-+			}
-+			break;
-+		case 0x30: /* A+B A-B */
-+			ant_conf->fast_div_bias = 0x1;
-+			break;
-+		case 0x31: /* A+B LNA2 */
-+			ant_conf->fast_div_bias = 0x6;
-+			break;
-+		case 0x32: /* A+B LNA1 */
-+			ant_conf->fast_div_bias = 0x1;
-+			break;
-+		default:
-+			break;
-+		}
- 	}
- }
- 
---- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
-@@ -1291,6 +1291,9 @@ static void ar9003_hw_antdiv_comb_conf_g
- 	} else if (AR_SREV_9485(ah)) {
- 		antconf->lna1_lna2_delta = -9;
- 		antconf->div_group = 2;
-+	} else if (AR_SREV_9565(ah)) {
-+		antconf->lna1_lna2_delta = -3;
-+		antconf->div_group = 3;
- 	} else {
- 		antconf->lna1_lna2_delta = -3;
- 		antconf->div_group = 0;
diff --git a/linux-next-pending/0012-ath9k_hw-Update-AR9565-initvals.patch b/linux-next-pending/0012-ath9k_hw-Update-AR9565-initvals.patch
deleted file mode 100644
index 662d17c..0000000
--- a/linux-next-pending/0012-ath9k_hw-Update-AR9565-initvals.patch
+++ /dev/null
@@ -1,172 +0,0 @@
-From e21bb92fcbebf8f60d07f14dbcf8e8973b5b1f77 Mon Sep 17 00:00:00 2001
-From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
-Date: Wed, 12 Sep 2012 11:54:20 +0530
-Subject: [PATCH] ath9k_hw: Update AR9565 initvals
-
-Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
----
- .../net/wireless/ath/ath9k/ar9565_1p0_initvals.h   | 100 ++++++++++-----------
- 1 file changed, 49 insertions(+), 51 deletions(-)
-
---- a/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
-+++ b/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
-@@ -58,8 +58,6 @@ static const u32 ar9565_1p0_mac_core[][2
- 	{0x00008040, 0x00000000},
- 	{0x00008044, 0x00000000},
- 	{0x00008048, 0x00000000},
--	{0x0000804c, 0xffffffff},
--	{0x00008050, 0xffffffff},
- 	{0x00008054, 0x00000000},
- 	{0x00008058, 0x00000000},
- 	{0x0000805c, 0x000fc78f},
-@@ -246,7 +244,7 @@ static const u32 ar9565_1p0_baseband_cor
- 	{0x00009e50, 0x00ff03f1},
- 	{0x00009e54, 0xe4c355c7},
- 	{0x00009e5c, 0xe9198724},
--	{0x00009fc0, 0x823e4788},
-+	{0x00009fc0, 0x823e4fc8},
- 	{0x00009fc4, 0x0001efb5},
- 	{0x00009fcc, 0x40000014},
- 	{0x0000a20c, 0x00000000},
-@@ -291,7 +289,7 @@ static const u32 ar9565_1p0_baseband_cor
- 	{0x0000a3ec, 0x20202020},
- 	{0x0000a3f0, 0x00000000},
- 	{0x0000a3f4, 0x00000006},
--	{0x0000a3f8, 0x0cdbd380},
-+	{0x0000a3f8, 0x0c9bd380},
- 	{0x0000a3fc, 0x000f0f01},
- 	{0x0000a400, 0x8fa91f01},
- 	{0x0000a404, 0x00000000},
-@@ -355,11 +353,11 @@ static const u32 ar9565_1p0_baseband_pos
- 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
- 	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
- 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
--	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcf946222, 0xcf946222},
-+	{0x00009e3c, 0xcf946222, 0xcf946222, 0xcf946222, 0xcf946222},
- 	{0x00009e44, 0xfe321e27, 0xfe321e27, 0xfe291e27, 0xfe291e27},
- 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
- 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
--	{0x0000a204, 0x033187c0, 0x033187c4, 0x033187c4, 0x033187c0},
-+	{0x0000a204, 0x07318fc0, 0x07318fc4, 0x07318fc4, 0x07318fc0},
- 	{0x0000a208, 0x00000104, 0x00000104, 0x00000004, 0x00000004},
- 	{0x0000a22c, 0x01026a2f, 0x01026a27, 0x01026a2f, 0x01026a2f},
- 	{0x0000a230, 0x0000400a, 0x00004014, 0x00004016, 0x0000400b},
-@@ -375,9 +373,9 @@ static const u32 ar9565_1p0_baseband_pos
- 	{0x0000a284, 0x00000000, 0x00000000, 0x00000150, 0x00000150},
- 	{0x0000a288, 0x00100510, 0x00100510, 0x00100510, 0x00100510},
- 	{0x0000a28c, 0x00021551, 0x00021551, 0x00021551, 0x00021551},
--	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
-+	{0x0000a2c4, 0x00058d18, 0x00058d18, 0x00058d18, 0x00058d18},
- 	{0x0000a2d0, 0x00071982, 0x00071982, 0x00071982, 0x00071982},
--	{0x0000a2d8, 0x7999a83a, 0x7999a83a, 0x7999a83a, 0x7999a83a},
-+	{0x0000a2d8, 0x7999a83b, 0x7999a83b, 0x7999a83b, 0x7999a83b},
- 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
- 	{0x0000ae04, 0x00800000, 0x00800000, 0x00800000, 0x00800000},
- 	{0x0000ae18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-@@ -417,7 +415,7 @@ static const u32 ar9565_1p0_radio_core[]
- 	{0x00016144, 0x02084080},
- 	{0x00016148, 0x000080c0},
- 	{0x00016280, 0x050a0001},
--	{0x00016284, 0x3d841400},
-+	{0x00016284, 0x3d841440},
- 	{0x00016288, 0x00000000},
- 	{0x0001628c, 0xe3000000},
- 	{0x00016290, 0xa1004080},
-@@ -840,27 +838,27 @@ static const u32 ar9565_1p0_common_wo_xl
- 	{0x0000a0b4, 0x00000000},
- 	{0x0000a0b8, 0x00000000},
- 	{0x0000a0bc, 0x00000000},
--	{0x0000a0c0, 0x301f3000},
--	{0x0000a0c4, 0x41004101},
--	{0x0000a0c8, 0x411e411f},
--	{0x0000a0cc, 0x411c411d},
--	{0x0000a0d0, 0x42434244},
--	{0x0000a0d4, 0x42414242},
--	{0x0000a0d8, 0x425f4240},
--	{0x0000a0dc, 0x5342425e},
--	{0x0000a0e0, 0x53405341},
--	{0x0000a0e4, 0x535e535f},
--	{0x0000a0e8, 0x7402535d},
--	{0x0000a0ec, 0x74007401},
--	{0x0000a0f0, 0x741e741f},
--	{0x0000a0f4, 0x7522741d},
--	{0x0000a0f8, 0x75207521},
--	{0x0000a0fc, 0x753e753f},
--	{0x0000a100, 0x76617662},
--	{0x0000a104, 0x767f7660},
--	{0x0000a108, 0x767d767e},
--	{0x0000a10c, 0x77e277e3},
--	{0x0000a110, 0x77e077e1},
-+	{0x0000a0c0, 0x00bf00a0},
-+	{0x0000a0c4, 0x11a011a1},
-+	{0x0000a0c8, 0x11be11bf},
-+	{0x0000a0cc, 0x11bc11bd},
-+	{0x0000a0d0, 0x22632264},
-+	{0x0000a0d4, 0x22612262},
-+	{0x0000a0d8, 0x227f2260},
-+	{0x0000a0dc, 0x4322227e},
-+	{0x0000a0e0, 0x43204321},
-+	{0x0000a0e4, 0x433e433f},
-+	{0x0000a0e8, 0x4462433d},
-+	{0x0000a0ec, 0x44604461},
-+	{0x0000a0f0, 0x447e447f},
-+	{0x0000a0f4, 0x5582447d},
-+	{0x0000a0f8, 0x55805581},
-+	{0x0000a0fc, 0x559e559f},
-+	{0x0000a100, 0x66816682},
-+	{0x0000a104, 0x669f6680},
-+	{0x0000a108, 0x669d669e},
-+	{0x0000a10c, 0x77627763},
-+	{0x0000a110, 0x77607761},
- 	{0x0000a114, 0x00000000},
- 	{0x0000a118, 0x00000000},
- 	{0x0000a11c, 0x00000000},
-@@ -872,27 +870,27 @@ static const u32 ar9565_1p0_common_wo_xl
- 	{0x0000a134, 0x00000000},
- 	{0x0000a138, 0x00000000},
- 	{0x0000a13c, 0x00000000},
--	{0x0000a140, 0x301f3000},
--	{0x0000a144, 0x41004101},
--	{0x0000a148, 0x411e411f},
--	{0x0000a14c, 0x411c411d},
--	{0x0000a150, 0x42434244},
--	{0x0000a154, 0x42414242},
--	{0x0000a158, 0x425f4240},
--	{0x0000a15c, 0x5342425e},
--	{0x0000a160, 0x53405341},
--	{0x0000a164, 0x535e535f},
--	{0x0000a168, 0x7402535d},
--	{0x0000a16c, 0x74007401},
--	{0x0000a170, 0x741e741f},
--	{0x0000a174, 0x7522741d},
--	{0x0000a178, 0x75207521},
--	{0x0000a17c, 0x753e753f},
--	{0x0000a180, 0x76617662},
--	{0x0000a184, 0x767f7660},
--	{0x0000a188, 0x767d767e},
--	{0x0000a18c, 0x77e277e3},
--	{0x0000a190, 0x77e077e1},
-+	{0x0000a140, 0x00bf00a0},
-+	{0x0000a144, 0x11a011a1},
-+	{0x0000a148, 0x11be11bf},
-+	{0x0000a14c, 0x11bc11bd},
-+	{0x0000a150, 0x22632264},
-+	{0x0000a154, 0x22612262},
-+	{0x0000a158, 0x227f2260},
-+	{0x0000a15c, 0x4322227e},
-+	{0x0000a160, 0x43204321},
-+	{0x0000a164, 0x433e433f},
-+	{0x0000a168, 0x4462433d},
-+	{0x0000a16c, 0x44604461},
-+	{0x0000a170, 0x447e447f},
-+	{0x0000a174, 0x5582447d},
-+	{0x0000a178, 0x55805581},
-+	{0x0000a17c, 0x559e559f},
-+	{0x0000a180, 0x66816682},
-+	{0x0000a184, 0x669f6680},
-+	{0x0000a188, 0x669d669e},
-+	{0x0000a18c, 0x77627763},
-+	{0x0000a190, 0x77607761},
- 	{0x0000a194, 0x00000000},
- 	{0x0000a198, 0x00000000},
- 	{0x0000a19c, 0x00000000},
diff --git a/linux-next-pending/0013-ath9k_hw-Add-a-HW-callback-to-set-diversity.patch b/linux-next-pending/0013-ath9k_hw-Add-a-HW-callback-to-set-diversity.patch
deleted file mode 100644
index 5bef81a..0000000
--- a/linux-next-pending/0013-ath9k_hw-Add-a-HW-callback-to-set-diversity.patch
+++ /dev/null
@@ -1,213 +0,0 @@
-From f6acda9e9f2f0ac6f8ca6a1f91c373b18f49edca Mon Sep 17 00:00:00 2001
-From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
-Date: Fri, 14 Sep 2012 10:19:26 +0530
-Subject: [PATCH] ath9k_hw: Add a HW callback to set diversity
-
-This patch adds a new callback to handle WLAN RX diversity for
-AR9565.
-
-Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 10 +++++
- drivers/net/wireless/ath/ath9k/ar9003_phy.c    | 60 ++++++++++++++++++++++++++
- drivers/net/wireless/ath/ath9k/ar9003_phy.h    | 24 +++++++++++
- drivers/net/wireless/ath/ath9k/hw-ops.h        |  7 +++
- drivers/net/wireless/ath/ath9k/hw.c            |  4 ++
- drivers/net/wireless/ath/ath9k/hw.h            |  3 +-
- 6 files changed, 107 insertions(+), 1 deletion(-)
-
---- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
-@@ -3629,6 +3629,16 @@ static void ar9003_hw_ant_ctrl_apply(str
- 		/* enable_lnadiv */
- 		regval &= (~AR_PHY_ANT_DIV_LNADIV);
- 		regval |= ((value >> 6) & 0x1) << AR_PHY_ANT_DIV_LNADIV_S;
-+
-+		if (AR_SREV_9565(ah)) {
-+			if (ah->shared_chain_lnadiv) {
-+				regval |= (1 << AR_PHY_ANT_SW_RX_PROT_S);
-+			} else {
-+				regval &= ~(1 << AR_PHY_ANT_DIV_LNADIV_S);
-+				regval &= ~(1 << AR_PHY_ANT_SW_RX_PROT_S);
-+			}
-+		}
-+
- 		REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
- 
- 		/*enable fast_div */
---- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
-@@ -1325,6 +1325,65 @@ static void ar9003_hw_antdiv_comb_conf_s
- 	REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
- }
- 
-+static void ar9003_hw_antctrl_shared_chain_lnadiv(struct ath_hw *ah,
-+						  bool enable)
-+{
-+	u8 ant_div_ctl1;
-+	u32 regval;
-+
-+	if (!AR_SREV_9565(ah))
-+		return;
-+
-+	ah->shared_chain_lnadiv = enable;
-+	ant_div_ctl1 = ah->eep_ops->get_eeprom(ah, EEP_ANT_DIV_CTL1);
-+
-+	regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
-+	regval &= (~AR_ANT_DIV_CTRL_ALL);
-+	regval |= (ant_div_ctl1 & 0x3f) << AR_ANT_DIV_CTRL_ALL_S;
-+	regval &= ~AR_PHY_ANT_DIV_LNADIV;
-+	regval |= ((ant_div_ctl1 >> 6) & 0x1) << AR_PHY_ANT_DIV_LNADIV_S;
-+
-+	if (enable)
-+		regval |= AR_ANT_DIV_ENABLE;
-+
-+	REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
-+
-+	regval = REG_READ(ah, AR_PHY_CCK_DETECT);
-+	regval &= ~AR_FAST_DIV_ENABLE;
-+	regval |= ((ant_div_ctl1 >> 7) & 0x1) << AR_FAST_DIV_ENABLE_S;
-+
-+	if (enable)
-+		regval |= AR_FAST_DIV_ENABLE;
-+
-+	REG_WRITE(ah, AR_PHY_CCK_DETECT, regval);
-+
-+	if (enable) {
-+		REG_SET_BIT(ah, AR_PHY_MC_GAIN_CTRL,
-+			    (1 << AR_PHY_ANT_SW_RX_PROT_S));
-+		if (IS_CHAN_2GHZ(ah->curchan))
-+			REG_SET_BIT(ah, AR_PHY_RESTART,
-+				    AR_PHY_RESTART_ENABLE_DIV_M2FLAG);
-+		REG_SET_BIT(ah, AR_BTCOEX_WL_LNADIV,
-+			    AR_BTCOEX_WL_LNADIV_FORCE_ON);
-+	} else {
-+		REG_CLR_BIT(ah, AR_PHY_MC_GAIN_CTRL, AR_ANT_DIV_ENABLE);
-+		REG_CLR_BIT(ah, AR_PHY_MC_GAIN_CTRL,
-+			    (1 << AR_PHY_ANT_SW_RX_PROT_S));
-+		REG_CLR_BIT(ah, AR_PHY_CCK_DETECT, AR_FAST_DIV_ENABLE);
-+		REG_CLR_BIT(ah, AR_BTCOEX_WL_LNADIV,
-+			    AR_BTCOEX_WL_LNADIV_FORCE_ON);
-+
-+		regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
-+		regval &= ~(AR_PHY_ANT_DIV_MAIN_LNACONF |
-+			AR_PHY_ANT_DIV_ALT_LNACONF |
-+			AR_PHY_ANT_DIV_MAIN_GAINTB |
-+			AR_PHY_ANT_DIV_ALT_GAINTB);
-+		regval |= (AR_PHY_ANT_DIV_LNA1 << AR_PHY_ANT_DIV_MAIN_LNACONF_S);
-+		regval |= (AR_PHY_ANT_DIV_LNA2 << AR_PHY_ANT_DIV_ALT_LNACONF_S);
-+		REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
-+	}
-+}
-+
- static int ar9003_hw_fast_chan_change(struct ath_hw *ah,
- 				      struct ath9k_channel *chan,
- 				      u8 *ini_reloaded)
-@@ -1423,6 +1482,7 @@ void ar9003_hw_attach_phy_ops(struct ath
- 
- 	ops->antdiv_comb_conf_get = ar9003_hw_antdiv_comb_conf_get;
- 	ops->antdiv_comb_conf_set = ar9003_hw_antdiv_comb_conf_set;
-+	ops->antctrl_shared_chain_lnadiv = ar9003_hw_antctrl_shared_chain_lnadiv;
- 
- 	ar9003_hw_set_nf_limits(ah);
- 	ar9003_hw_set_radar_conf(ah);
---- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
-+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
-@@ -282,6 +282,8 @@
- 
- #define AR_PHY_ANT_FAST_DIV_BIAS                0x00007e00
- #define AR_PHY_ANT_FAST_DIV_BIAS_S              9
-+#define AR_PHY_ANT_SW_RX_PROT                   0x00800000
-+#define AR_PHY_ANT_SW_RX_PROT_S                 23
- #define AR_PHY_ANT_DIV_LNADIV                   0x01000000
- #define AR_PHY_ANT_DIV_LNADIV_S                 24
- #define AR_PHY_ANT_DIV_ALT_LNACONF              0x06000000
-@@ -422,6 +424,8 @@
- #define AR_PHY_FIND_SIG_RELSTEP        0x1f
- #define AR_PHY_FIND_SIG_RELSTEP_S         0
- #define AR_PHY_FIND_SIG_RELSTEP_SIGN_BIT  5
-+#define AR_PHY_RESTART_ENABLE_DIV_M2FLAG 0x00200000
-+#define AR_PHY_RESTART_ENABLE_DIV_M2FLAG_S 21
- #define AR_PHY_RESTART_DIV_GC   0x001C0000
- #define AR_PHY_RESTART_DIV_GC_S 18
- #define AR_PHY_RESTART_ENA      0x01
-@@ -1261,4 +1265,24 @@
- #define AR_PHY_CL_TAB_CL_GAIN_MOD		0x1f
- #define AR_PHY_CL_TAB_CL_GAIN_MOD_S		0
- 
-+#define AR_BTCOEX_WL_LNADIV                                0x1a64
-+#define AR_BTCOEX_WL_LNADIV_PREDICTED_PERIOD               0x00003FFF
-+#define AR_BTCOEX_WL_LNADIV_PREDICTED_PERIOD_S             0
-+#define AR_BTCOEX_WL_LNADIV_DPDT_IGNORE_PRIORITY           0x00004000
-+#define AR_BTCOEX_WL_LNADIV_DPDT_IGNORE_PRIORITY_S         14
-+#define AR_BTCOEX_WL_LNADIV_FORCE_ON                       0x00008000
-+#define AR_BTCOEX_WL_LNADIV_FORCE_ON_S                     15
-+#define AR_BTCOEX_WL_LNADIV_MODE_OPTION                    0x00030000
-+#define AR_BTCOEX_WL_LNADIV_MODE_OPTION_S                  16
-+#define AR_BTCOEX_WL_LNADIV_MODE                           0x007c0000
-+#define AR_BTCOEX_WL_LNADIV_MODE_S                         18
-+#define AR_BTCOEX_WL_LNADIV_ALLOWED_TX_ANTDIV_WL_TX_REQ    0x00800000
-+#define AR_BTCOEX_WL_LNADIV_ALLOWED_TX_ANTDIV_WL_TX_REQ_S  23
-+#define AR_BTCOEX_WL_LNADIV_DISABLE_TX_ANTDIV_ENABLE       0x01000000
-+#define AR_BTCOEX_WL_LNADIV_DISABLE_TX_ANTDIV_ENABLE_S     24
-+#define AR_BTCOEX_WL_LNADIV_CONTINUOUS_BT_ACTIVE_PROTECT   0x02000000
-+#define AR_BTCOEX_WL_LNADIV_CONTINUOUS_BT_ACTIVE_PROTECT_S 25
-+#define AR_BTCOEX_WL_LNADIV_BT_INACTIVE_THRESHOLD          0xFC000000
-+#define AR_BTCOEX_WL_LNADIV_BT_INACTIVE_THRESHOLD_S        26
-+
- #endif  /* AR9003_PHY_H */
---- a/drivers/net/wireless/ath/ath9k/hw-ops.h
-+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
-@@ -78,6 +78,13 @@ static inline void ath9k_hw_antdiv_comb_
- 	ath9k_hw_ops(ah)->antdiv_comb_conf_set(ah, antconf);
- }
- 
-+static inline void ath9k_hw_antctrl_shared_chain_lnadiv(struct ath_hw *ah,
-+							bool enable)
-+{
-+	if (ath9k_hw_ops(ah)->antctrl_shared_chain_lnadiv)
-+		ath9k_hw_ops(ah)->antctrl_shared_chain_lnadiv(ah, enable);
-+}
-+
- /* Private hardware call ops */
- 
- /* PHY ops */
---- a/drivers/net/wireless/ath/ath9k/hw.c
-+++ b/drivers/net/wireless/ath/ath9k/hw.c
-@@ -24,6 +24,7 @@
- #include "rc.h"
- #include "ar9003_mac.h"
- #include "ar9003_mci.h"
-+#include "ar9003_phy.h"
- #include "debug.h"
- #include "ath9k.h"
- 
-@@ -2025,6 +2026,9 @@ int ath9k_hw_reset(struct ath_hw *ah, st
- 
- 	ath9k_hw_apply_gpio_override(ah);
- 
-+	if (AR_SREV_9565(ah) && ah->shared_chain_lnadiv)
-+		REG_SET_BIT(ah, AR_BTCOEX_WL_LNADIV, AR_BTCOEX_WL_LNADIV_FORCE_ON);
-+
- 	return 0;
- }
- EXPORT_SYMBOL(ath9k_hw_reset);
---- a/drivers/net/wireless/ath/ath9k/hw.h
-+++ b/drivers/net/wireless/ath/ath9k/hw.h
-@@ -687,7 +687,7 @@ struct ath_hw_ops {
- 			struct ath_hw_antcomb_conf *antconf);
- 	void (*antdiv_comb_conf_set)(struct ath_hw *ah,
- 			struct ath_hw_antcomb_conf *antconf);
--
-+	void (*antctrl_shared_chain_lnadiv)(struct ath_hw *hw, bool enable);
- };
- 
- struct ath_nf_limits {
-@@ -731,6 +731,7 @@ struct ath_hw {
- 	bool aspm_enabled;
- 	bool is_monitoring;
- 	bool need_an_top2_fixup;
-+	bool shared_chain_lnadiv;
- 	u16 tx_trig_level;
- 
- 	u32 nf_regs[6];
diff --git a/linux-next-pending/0014-ath9k-Add-a-module-parameter-to-enable-diversity.patch b/linux-next-pending/0014-ath9k-Add-a-module-parameter-to-enable-diversity.patch
deleted file mode 100644
index 0054bf8..0000000
--- a/linux-next-pending/0014-ath9k-Add-a-module-parameter-to-enable-diversity.patch
+++ /dev/null
@@ -1,68 +0,0 @@
-From f2bc9be90f6818009e16ce8c65665c4f7331272e Mon Sep 17 00:00:00 2001
-From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
-Date: Fri, 14 Sep 2012 11:50:22 +0530
-Subject: [PATCH] ath9k: Add a module parameter to enable diversity
-
-Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath.h           |  1 +
- drivers/net/wireless/ath/ath9k/antenna.c |  4 ++++
- drivers/net/wireless/ath/ath9k/init.c    | 12 ++++++++++++
- 3 files changed, 17 insertions(+)
-
---- a/drivers/net/wireless/ath/ath.h
-+++ b/drivers/net/wireless/ath/ath.h
-@@ -159,6 +159,7 @@ struct ath_common {
- 
- 	bool btcoex_enabled;
- 	bool disable_ani;
-+	bool antenna_diversity;
- };
- 
- struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
---- a/drivers/net/wireless/ath/ath9k/antenna.c
-+++ b/drivers/net/wireless/ath/ath9k/antenna.c
-@@ -776,6 +776,7 @@ div_comb_done:
- void ath_ant_comb_update(struct ath_softc *sc)
- {
- 	struct ath_hw *ah = sc->sc_ah;
-+	struct ath_common *common = ath9k_hw_common(ah);
- 	struct ath_hw_antcomb_conf div_ant_conf;
- 	u8 lna_conf;
- 
-@@ -790,4 +791,7 @@ void ath_ant_comb_update(struct ath_soft
- 	div_ant_conf.alt_lna_conf = lna_conf;
- 
- 	ath9k_hw_antdiv_comb_conf_set(ah, &div_ant_conf);
-+
-+	if (common->antenna_diversity)
-+		ath9k_hw_antctrl_shared_chain_lnadiv(ah, true);
- }
---- a/drivers/net/wireless/ath/ath9k/init.c
-+++ b/drivers/net/wireless/ath/ath9k/init.c
-@@ -48,6 +48,10 @@ static int ath9k_btcoex_enable;
- module_param_named(btcoex_enable, ath9k_btcoex_enable, int, 0444);
- MODULE_PARM_DESC(btcoex_enable, "Enable wifi-BT coexistence");
- 
-+static int ath9k_enable_diversity;
-+module_param_named(enable_diversity, ath9k_enable_diversity, int, 0444);
-+MODULE_PARM_DESC(enable_diversity, "Enable Antenna diversity for AR9565");
-+
- bool is_ath9k_unloaded;
- /* We use the hw_value as an index into our private channel structure */
- 
-@@ -548,6 +552,14 @@ static int ath9k_init_softc(u16 devid, s
- 	common->debug_mask = ath9k_debug;
- 	common->btcoex_enabled = ath9k_btcoex_enable == 1;
- 	common->disable_ani = false;
-+
-+	/*
-+	 * Enable Antenna diversity only when BTCOEX is disabled
-+	 * and the user manually requests the feature.
-+	 */
-+	if (!common->btcoex_enabled && ath9k_enable_diversity)
-+		common->antenna_diversity = 1;
-+
- 	spin_lock_init(&common->cc_lock);
- 
- 	spin_lock_init(&sc->sc_serial_rw);
diff --git a/linux-next-pending/0015-ath9k_hw-Enable-WLAN-RX-diversity-for-AR9565.patch b/linux-next-pending/0015-ath9k_hw-Enable-WLAN-RX-diversity-for-AR9565.patch
deleted file mode 100644
index f2a073f..0000000
--- a/linux-next-pending/0015-ath9k_hw-Enable-WLAN-RX-diversity-for-AR9565.patch
+++ /dev/null
@@ -1,21 +0,0 @@
-From 58b8ed332215e0dbc79a68277db29e305d6764fa Mon Sep 17 00:00:00 2001
-From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
-Date: Wed, 12 Sep 2012 10:44:10 +0530
-Subject: [PATCH] ath9k_hw: Enable WLAN RX diversity for AR9565
-
-Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
----
- drivers/net/wireless/ath/ath9k/hw.c | 2 +-
- 1 file changed, 1 insertion(+), 1 deletion(-)
-
---- a/drivers/net/wireless/ath/ath9k/hw.c
-+++ b/drivers/net/wireless/ath/ath9k/hw.c
-@@ -2543,7 +2543,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw
- 	}
- 
- 
--	if (AR_SREV_9330(ah) || AR_SREV_9485(ah)) {
-+	if (AR_SREV_9330(ah) || AR_SREV_9485(ah) || AR_SREV_9565(ah)) {
- 		ant_div_ctl1 = ah->eep_ops->get_eeprom(ah, EEP_ANT_DIV_CTL1);
- 		/*
- 		 * enable the diversity-combining algorithm only when
-- 
1.7.12.1

