Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15840 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab1JXMvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 08:51:17 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k: Add btcoex profile management support for AR9462
Date: Mon, 24 Oct 2011 18:19:49 +0530
Message-ID: <1319460589-8457-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111024_145130_941830_7F412E2A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9462 chips have the capabilities to provoide bluetooth
profile information. For non-AR9462 btcoex chips, the BT
priority traffic was identified by periodically polling
the respective registers and updated dutycycle, stomptype,
etc. As AR9462 chip offers the BT profile informations,
let us make use of that to update aggregation limit,
dutycycle, stomptype and wieghtages.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath.h          |    1 +
 drivers/net/wireless/ath/ath9k/Makefile |    1 +
 drivers/net/wireless/ath/ath9k/ath9k.h  |    3 +
 drivers/net/wireless/ath/ath9k/gpio.c   |    7 +-
 drivers/net/wireless/ath/ath9k/hw.c     |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h     |   11 ++
 drivers/net/wireless/ath/ath9k/init.c   |    2 +
 drivers/net/wireless/ath/ath9k/main.c   |    6 +-
 drivers/net/wireless/ath/ath9k/mci.c    |  254 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/mci.h    |  118 ++++++++++++++
 drivers/net/wireless/ath/ath9k/xmit.c   |    5 +-
 11 files changed, 403 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/mci.c
 create mode 100644 drivers/net/wireless/ath/ath9k/mci.h

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 908fdbc..fe4bf4d 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -240,6 +240,7 @@ enum ATH_DEBUG {
 	ATH_DBG_BTCOEX		= 0x00002000,
 	ATH_DBG_WMI		= 0x00004000,
 	ATH_DBG_BSTUCK		= 0x00008000,
+	ATH_DBG_MCI		= 0x00010000,
 	ATH_DBG_ANY		= 0xffffffff
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 36ed3c4..49d3f25 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -4,6 +4,7 @@ ath9k-y +=	beacon.o \
 		main.o \
 		recv.o \
 		xmit.o \
+		mci.o \
 
 ath9k-$(CONFIG_ATH9K_RATE_CONTROL) += rc.o
 ath9k-$(CONFIG_ATH9K_PCI) += pci.o
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 1c269f5..4415e89 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -25,6 +25,7 @@
 
 #include "debug.h"
 #include "common.h"
+#include "mci.h"
 
 /*
  * Header for the ath9k.ko driver core *only* -- hw code nor any other driver
@@ -443,7 +444,9 @@ struct ath_btcoex {
 	u32 btcoex_no_stomp; /* in usec */
 	u32 btcoex_period; /* in usec */
 	u32 btscan_no_stomp; /* in usec */
+	u32 duty_cycle;
 	struct ath_gen_timer *no_stomp_timer; /* Timer for no BT stomping */
+	struct ath_mci_profile mci;
 };
 
 int ath_init_btcoex_timer(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 655576c..2c279dc 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -189,8 +189,8 @@ static void ath_btcoex_period_timer(unsigned long data)
 	bool is_btscan;
 
 	ath9k_ps_wakeup(sc);
-	ath_detect_bt_priority(sc);
-
+	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
+		ath_detect_bt_priority(sc);
 	is_btscan = sc->sc_flags & SC_OP_BT_SCAN;
 
 	spin_lock_bh(&btcoex->btcoex_lock);
@@ -212,8 +212,9 @@ static void ath_btcoex_period_timer(unsigned long data)
 	}
 
 	ath9k_ps_restore(sc);
+	timer_period = btcoex->btcoex_period / 1000;
 	mod_timer(&btcoex->period_timer, jiffies +
-				  msecs_to_jiffies(ATH_BTCOEX_DEF_BT_PERIOD));
+				  msecs_to_jiffies(timer_period));
 }
 
 /*
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f16d203..8c36938 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2331,7 +2331,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 			ah->enabled_cals |= TX_IQ_ON_AGC_CAL;
 	}
 	if (AR_SREV_9462(ah))
-		pCap->hw_caps |= ATH9K_HW_CAP_RTT;
+		pCap->hw_caps |= ATH9K_HW_CAP_RTT | ATH9K_HW_CAP_MCI;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index f389b3c..33e8f2f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -203,6 +203,7 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_5GHZ			= BIT(14),
 	ATH9K_HW_CAP_APM			= BIT(15),
 	ATH9K_HW_CAP_RTT			= BIT(16),
+	ATH9K_HW_CAP_MCI			= BIT(17),
 };
 
 struct ath9k_hw_capabilities {
@@ -419,6 +420,16 @@ enum ath9k_rx_qtype {
 	ATH9K_RX_QUEUE_MAX,
 };
 
+enum ath_mci_gpm_coex_profile_type {
+	MCI_GPM_COEX_PROFILE_UNKNOWN,
+	MCI_GPM_COEX_PROFILE_RFCOMM,
+	MCI_GPM_COEX_PROFILE_A2DP,
+	MCI_GPM_COEX_PROFILE_HID,
+	MCI_GPM_COEX_PROFILE_BNEP,
+	MCI_GPM_COEX_PROFILE_VOICE,
+	MCI_GPM_COEX_PROFILE_MAX
+};
+
 struct ath9k_beacon_state {
 	u32 bs_nexttbtt;
 	u32 bs_nextdtim;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index af1b325..e8af582 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -423,6 +423,8 @@ static int ath9k_init_btcoex(struct ath_softc *sc)
 		txq = sc->tx.txq_map[WME_AC_BE];
 		ath9k_hw_init_btcoex_hw(sc->sc_ah, txq->axq_qnum);
 		sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
+		sc->btcoex.duty_cycle = ATH_BTCOEX_DEF_DUTY_CYCLE;
+		INIT_LIST_HEAD(&sc->btcoex.mci.info);
 		break;
 	default:
 		WARN_ON(1);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 93fbe6f..e1e006d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1133,8 +1133,9 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	if ((ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE) &&
 	    !ah->btcoex_hw.enabled) {
-		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
-					   AR_STOMP_LOW_WLAN_WGHT);
+		if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
+			ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+						   AR_STOMP_LOW_WLAN_WGHT);
 		ath9k_hw_btcoex_enable(ah);
 
 		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
@@ -1237,6 +1238,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 		ath9k_hw_btcoex_disable(ah);
 		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 			ath9k_btcoex_timer_pause(sc);
+		ath_mci_flush_profile(&sc->btcoex.mci);
 	}
 
 	spin_lock_bh(&sc->sc_pcu_lock);
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
new file mode 100644
index 0000000..0fbb141
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -0,0 +1,254 @@
+/*
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "ath9k.h"
+#include "mci.h"
+
+u8 ath_mci_duty_cycle[] = { 0, 50, 60, 70, 80, 85, 90, 95, 98 };
+
+static struct ath_mci_profile_info*
+ath_mci_find_profile(struct ath_mci_profile *mci,
+		     struct ath_mci_profile_info *info)
+{
+	struct ath_mci_profile_info *entry;
+
+	list_for_each_entry(entry, &mci->info, list) {
+		if (entry->conn_handle == info->conn_handle)
+			break;
+	}
+	return entry;
+}
+
+static bool ath_mci_add_profile(struct ath_common *common,
+				struct ath_mci_profile *mci,
+				struct ath_mci_profile_info *info)
+{
+	struct ath_mci_profile_info *entry;
+
+	if ((mci->num_sco == ATH_MCI_MAX_SCO_PROFILE) &&
+	    (info->type == MCI_GPM_COEX_PROFILE_VOICE)) {
+		ath_dbg(common, ATH_DBG_MCI,
+			"Too many SCO profile, failed to add new profile\n");
+		return false;
+	}
+
+	if (((NUM_PROF(mci) - mci->num_sco) == ATH_MCI_MAX_ACL_PROFILE) &&
+	    (info->type != MCI_GPM_COEX_PROFILE_VOICE)) {
+		ath_dbg(common, ATH_DBG_MCI,
+			"Too many ACL profile, failed to add new profile\n");
+		return false;
+	}
+
+	entry = ath_mci_find_profile(mci, info);
+
+	if (entry)
+		memcpy(entry, info, 10);
+	else {
+		entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+		if (!entry)
+			return false;
+
+		memcpy(entry, info, 10);
+		INC_PROF(mci, info);
+		list_add_tail(&info->list, &mci->info);
+	}
+	return true;
+}
+
+static void ath_mci_del_profile(struct ath_common *common,
+				struct ath_mci_profile *mci,
+				struct ath_mci_profile_info *info)
+{
+	struct ath_mci_profile_info *entry;
+
+	entry = ath_mci_find_profile(mci, info);
+
+	if (!entry) {
+		ath_dbg(common, ATH_DBG_MCI,
+			"Profile to be deleted not found\n");
+		return;
+	}
+	DEC_PROF(mci, entry);
+	list_del(&entry->list);
+	kfree(entry);
+}
+
+void ath_mci_flush_profile(struct ath_mci_profile *mci)
+{
+	struct ath_mci_profile_info *info, *tinfo;
+
+	list_for_each_entry_safe(info, tinfo, &mci->info, list) {
+		list_del(&info->list);
+		DEC_PROF(mci, info);
+		kfree(info);
+	}
+	mci->aggr_limit = 0;
+}
+
+static void ath_mci_adjust_aggr_limit(struct ath_btcoex *btcoex)
+{
+	struct ath_mci_profile *mci = &btcoex->mci;
+	u32 wlan_airtime = btcoex->btcoex_period *
+				(100 - btcoex->duty_cycle) / 100;
+
+	/*
+	 * Scale: wlan_airtime is in ms, aggr_limit is in 0.25 ms.
+	 * When wlan_airtime is less than 4ms, aggregation limit has to be
+	 * adjusted half of wlan_airtime to ensure that the aggregation can fit
+	 * without collision with BT traffic.
+	 */
+	if ((wlan_airtime <= 4) &&
+	    (!mci->aggr_limit || (mci->aggr_limit > (2 * wlan_airtime))))
+		mci->aggr_limit = 2 * wlan_airtime;
+}
+
+static void ath_mci_update_scheme(struct ath_softc *sc)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_mci_profile *mci = &btcoex->mci;
+	struct ath_mci_profile_info *info;
+	u32 num_profile = NUM_PROF(mci);
+
+	if (num_profile == 1) {
+		info = list_first_entry(&mci->info,
+					struct ath_mci_profile_info,
+					list);
+		if (mci->num_sco && info->T == 12) {
+			mci->aggr_limit = 8;
+			ath_dbg(common, ATH_DBG_MCI,
+				"Single SCO, aggregation limit 2 ms\n");
+		} else if ((info->type == MCI_GPM_COEX_PROFILE_BNEP) &&
+			   !info->master) {
+			btcoex->btcoex_period = 60;
+			ath_dbg(common, ATH_DBG_MCI,
+				"Single slave PAN/FTP, bt period 60 ms\n");
+		} else if ((info->type == MCI_GPM_COEX_PROFILE_HID) &&
+			 (info->T > 0 && info->T < 50) &&
+			 (info->A > 1 || info->W > 1)) {
+			btcoex->duty_cycle = 30;
+			mci->aggr_limit = 8;
+			ath_dbg(common, ATH_DBG_MCI,
+				"Multiple attempt/timeout single HID "
+				"aggregation limit 2 ms dutycycle 30%%\n");
+		}
+	} else if ((num_profile == 2) && (mci->num_hid == 2)) {
+		btcoex->duty_cycle = 30;
+		mci->aggr_limit = 8;
+		ath_dbg(common, ATH_DBG_MCI,
+			"Two HIDs aggregation limit 2 ms dutycycle 30%%\n");
+	} else if (num_profile > 3) {
+		mci->aggr_limit = 6;
+		ath_dbg(common, ATH_DBG_MCI,
+			"Three or more profiles aggregation limit 1.5 ms\n");
+	}
+
+	if (IS_CHAN_2GHZ(sc->sc_ah->curchan)) {
+		if (IS_CHAN_HT(sc->sc_ah->curchan))
+			ath_mci_adjust_aggr_limit(btcoex);
+		else
+			btcoex->btcoex_period >>= 1;
+	}
+
+	ath9k_hw_btcoex_disable(sc->sc_ah);
+	ath9k_btcoex_timer_pause(sc);
+
+	if (IS_CHAN_5GHZ(sc->sc_ah->curchan))
+		return;
+
+	btcoex->duty_cycle += (mci->num_bdr ? ATH_MCI_MAX_DUTY_CYCLE : 0);
+	if (btcoex->duty_cycle > ATH_MCI_MAX_DUTY_CYCLE)
+		btcoex->duty_cycle = ATH_MCI_MAX_DUTY_CYCLE;
+
+	btcoex->btcoex_period *= 1000;
+	btcoex->btcoex_no_stomp =  btcoex->btcoex_period *
+					(100 - btcoex->duty_cycle) / 100;
+
+	ath9k_hw_btcoex_enable(sc->sc_ah);
+	ath9k_btcoex_timer_resume(sc);
+}
+
+void ath_mci_process_profile(struct ath_softc *sc,
+			     struct ath_mci_profile_info *info)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_mci_profile *mci = &btcoex->mci;
+
+	if (info->start) {
+		if (!ath_mci_add_profile(common, mci, info))
+			return;
+	} else
+		ath_mci_del_profile(common, mci, info);
+
+	btcoex->btcoex_period = ATH_MCI_DEF_BT_PERIOD;
+	mci->aggr_limit = mci->num_sco ? 6 : 0;
+	if (NUM_PROF(mci)) {
+		btcoex->bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
+		btcoex->duty_cycle = ath_mci_duty_cycle[NUM_PROF(mci)];
+	} else {
+		btcoex->bt_stomp_type = mci->num_mgmt ? ATH_BTCOEX_STOMP_ALL :
+							ATH_BTCOEX_STOMP_LOW;
+		btcoex->duty_cycle = ATH_BTCOEX_DEF_DUTY_CYCLE;
+	}
+
+	ath_mci_update_scheme(sc);
+}
+
+void ath_mci_process_status(struct ath_softc *sc,
+			    struct ath_mci_profile_status *status)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_mci_profile *mci = &btcoex->mci;
+	struct ath_mci_profile_info info;
+	int i = 0, old_num_mgmt = mci->num_mgmt;
+
+	/* Link status type are not handled */
+	if (status->is_link) {
+		ath_dbg(common, ATH_DBG_MCI,
+			"Skip link type status update\n");
+		return;
+	}
+
+	memset(&info, 0, sizeof(struct ath_mci_profile_info));
+
+	info.conn_handle = status->conn_handle;
+	if (ath_mci_find_profile(mci, &info)) {
+		ath_dbg(common, ATH_DBG_MCI,
+			"Skip non link state update for existing profile %d\n",
+			status->conn_handle);
+		return;
+	}
+	if (status->conn_handle >= ATH_MCI_MAX_PROFILE) {
+		ath_dbg(common, ATH_DBG_MCI,
+			"Ignore too many non-link update\n");
+		return;
+	}
+	if (status->is_critical)
+		__set_bit(status->conn_handle, mci->status);
+	else
+		__clear_bit(status->conn_handle, mci->status);
+
+	mci->num_mgmt = 0;
+	do {
+		if (test_bit(i, mci->status))
+			mci->num_mgmt++;
+	} while (++i < ATH_MCI_MAX_PROFILE);
+
+	if (old_num_mgmt != mci->num_mgmt)
+		ath_mci_update_scheme(sc);
+}
diff --git a/drivers/net/wireless/ath/ath9k/mci.h b/drivers/net/wireless/ath/ath9k/mci.h
new file mode 100644
index 0000000..9590c61
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/mci.h
@@ -0,0 +1,118 @@
+/*
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef MCI_H
+#define MCI_H
+
+#define ATH_MCI_DEF_BT_PERIOD		40
+#define ATH_MCI_BDR_DUTY_CYCLE		20
+#define ATH_MCI_MAX_DUTY_CYCLE		90
+
+#define ATH_MCI_DEF_AGGR_LIMIT		6 /* in 0.24 ms */
+#define ATH_MCI_MAX_ACL_PROFILE		7
+#define ATH_MCI_MAX_SCO_PROFILE		1
+#define ATH_MCI_MAX_PROFILE		(ATH_MCI_MAX_ACL_PROFILE +\
+					 ATH_MCI_MAX_SCO_PROFILE)
+
+#define INC_PROF(_mci, _info) do {		 \
+		switch (_info->type) {		 \
+		case MCI_GPM_COEX_PROFILE_RFCOMM:\
+			_mci->num_other_acl++;	 \
+			break;			 \
+		case MCI_GPM_COEX_PROFILE_A2DP:	 \
+			_mci->num_a2dp++;	 \
+			if (!_info->edr)	 \
+				_mci->num_bdr++; \
+			break;			 \
+		case MCI_GPM_COEX_PROFILE_HID:	 \
+			_mci->num_hid++;	 \
+			break;			 \
+		case MCI_GPM_COEX_PROFILE_BNEP:	 \
+			_mci->num_pan++;	 \
+			break;			 \
+		case MCI_GPM_COEX_PROFILE_VOICE: \
+			_mci->num_sco++;	 \
+			break;			 \
+		default:			 \
+			break;			 \
+		}				 \
+	} while (0)
+
+#define DEC_PROF(_mci, _info) do {		 \
+		switch (_info->type) {		 \
+		case MCI_GPM_COEX_PROFILE_RFCOMM:\
+			_mci->num_other_acl--;	 \
+			break;			 \
+		case MCI_GPM_COEX_PROFILE_A2DP:	 \
+			_mci->num_a2dp--;	 \
+			if (!_info->edr)	 \
+				_mci->num_bdr--; \
+			break;			 \
+		case MCI_GPM_COEX_PROFILE_HID:	 \
+			_mci->num_hid--;	 \
+			break;			 \
+		case MCI_GPM_COEX_PROFILE_BNEP:	 \
+			_mci->num_pan--;	 \
+			break;			 \
+		case MCI_GPM_COEX_PROFILE_VOICE: \
+			_mci->num_sco--;	 \
+			break;			 \
+		default:			 \
+			break;			 \
+		}				 \
+	} while (0)
+
+#define NUM_PROF(_mci)	(_mci->num_other_acl + _mci->num_a2dp + \
+			 _mci->num_hid + _mci->num_pan + _mci->num_sco)
+
+struct ath_mci_profile_info {
+	u8 type;
+	u8 conn_handle;
+	bool start;
+	bool master;
+	bool edr;
+	u8 voice_type;
+	u16 T;		/* Voice: Tvoice, HID: Tsniff,        in slots */
+	u8 W;		/* Voice: Wvoice, HID: Sniff timeout, in slots */
+	u8 A;		/*		  HID: Sniff attempt, in slots */
+	struct list_head list;
+};
+
+struct ath_mci_profile_status {
+	bool is_critical;
+	bool is_link;
+	u8 conn_handle;
+};
+
+struct ath_mci_profile {
+	struct list_head info;
+	DECLARE_BITMAP(status, ATH_MCI_MAX_PROFILE);
+	u16 aggr_limit;
+	u8 num_mgmt;
+	u8 num_sco;
+	u8 num_a2dp;
+	u8 num_hid;
+	u8 num_pan;
+	u8 num_other_acl;
+	u8 num_bdr;
+};
+
+void ath_mci_flush_profile(struct ath_mci_profile *mci);
+void ath_mci_process_profile(struct ath_softc *sc,
+			     struct ath_mci_profile_info *info);
+void ath_mci_process_status(struct ath_softc *sc,
+			    struct ath_mci_profile_status *status);
+#endif
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 03b0a65..55d077e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -601,6 +601,7 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *rates;
+	struct ath_mci_profile *mci = &sc->btcoex.mci;
 	u32 max_4ms_framelen, frmlen;
 	u16 aggr_limit, legacy = 0;
 	int i;
@@ -645,7 +646,9 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 	if (tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE || legacy)
 		return 0;
 
-	if (sc->sc_flags & SC_OP_BT_PRIORITY_DETECTED)
+	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_MCI) && mci->aggr_limit)
+		aggr_limit = (max_4ms_framelen * mci->aggr_limit) >> 4;
+	else if (sc->sc_flags & SC_OP_BT_PRIORITY_DETECTED)
 		aggr_limit = min((max_4ms_framelen * 3) / 8,
 				 (u32)ATH_AMPDU_LIMIT_MAX);
 	else
-- 
1.7.7

