Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2160 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab2FKMiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 08:38:20 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/2] ath9k: defer btcoex scheme update
Date: Mon, 11 Jun 2012 18:09:13 +0530
Message-ID: <1339418354-1843-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120611_143825_007906_1672ACD9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As btcoex scheme updation might sleep, remove the function call
from tasklet context and queue it up as a separate work.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    3 +++
 drivers/net/wireless/ath/ath9k/mci.c   |   14 +++++++++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 02fc1c1..a8c0500 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -698,6 +698,7 @@ struct ath_softc {
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	struct ath_btcoex btcoex;
 	struct ath_mci_coex mci_coex;
+	struct work_struct mci_work;
 #endif
 
 	struct ath_descdma txsdma;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e655f2a..c618414 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -188,6 +188,9 @@ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
 
 	ath9k_debug_samp_bb_mac(sc);
 	ath9k_hw_disable_interrupts(ah);
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+	cancel_work_sync(&sc->mci_work);
+#endif
 
 	if (!ath_stoprecv(sc))
 		ret = false;
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 92d61cc..e53df86 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -52,7 +52,7 @@ static bool ath_mci_add_profile(struct ath_common *common,
 	    (info->type != MCI_GPM_COEX_PROFILE_VOICE))
 		return false;
 
-	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 	if (!entry)
 		return false;
 
@@ -219,6 +219,13 @@ static void ath_mci_cal_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 	}
 }
 
+static void ath9k_mci_work(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc, mci_work);
+
+	ath_mci_update_scheme(sc);
+}
+
 static void ath_mci_process_profile(struct ath_softc *sc,
 				    struct ath_mci_profile_info *info)
 {
@@ -249,7 +256,7 @@ static void ath_mci_process_profile(struct ath_softc *sc,
 		btcoex->duty_cycle = ATH_BTCOEX_DEF_DUTY_CYCLE;
 	}
 
-	ath_mci_update_scheme(sc);
+	ieee80211_queue_work(sc->hw, &sc->mci_work);
 }
 
 static void ath_mci_process_status(struct ath_softc *sc,
@@ -283,7 +290,7 @@ static void ath_mci_process_status(struct ath_softc *sc,
 	} while (++i < ATH_MCI_MAX_PROFILE);
 
 	if (old_num_mgmt != mci->num_mgmt)
-		ath_mci_update_scheme(sc);
+		ieee80211_queue_work(sc->hw, &sc->mci_work);
 }
 
 static void ath_mci_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
@@ -377,6 +384,7 @@ int ath_mci_setup(struct ath_softc *sc)
 			 mci->gpm_buf.bf_addr, (mci->gpm_buf.bf_len >> 4),
 			 mci->sched_buf.bf_paddr);
 
+	INIT_WORK(&sc->mci_work, ath9k_mci_work);
 	ath_dbg(common, MCI, "MCI Initialized\n");
 
 	return 0;
-- 
1.7.10.4

