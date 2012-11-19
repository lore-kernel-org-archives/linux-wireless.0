Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:54585
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab2KSIzN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 03:55:13 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix BTCOEX debugfs file usage
Date: Mon, 19 Nov 2012 14:24:46 +0530
Message-Id: <1353315286-13819-1-git-send-email-sujith@msujith.org> (sfid-20121119_095518_652559_5A2D9464)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The debugfs file for dumping btcoex parameters unconditionally
assumes a MCI-based device. This will not work for older btcoex
chips. Fix this by branching out the routine into separate
functions.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 11 ++++++--
 drivers/net/wireless/ath/ath9k/debug.c |  8 +++++-
 drivers/net/wireless/ath/ath9k/gpio.c  | 51 +++++++++++++++++++++++-----------
 3 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 4e125d8..9a93d2b 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -461,6 +461,12 @@ void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type);
 /* BTCOEX */
 /**********/
 
+#define ATH_DUMP_BTCOEX(_s, _val)				\
+	do {							\
+		len += snprintf(buf + len, size - len,		\
+				"%20s : %10d\n", _s, (_val));	\
+	} while (0)
+
 enum bt_op_flags {
 	BT_OP_PRIORITY_DETECTED,
 	BT_OP_SCAN,
@@ -494,7 +500,7 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc);
 void ath9k_btcoex_handle_interrupt(struct ath_softc *sc, u32 status);
 u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc, u32 max_4ms_framelen);
 void ath9k_btcoex_stop_gen_timer(struct ath_softc *sc);
-int ath9k_dump_btcoex(struct ath_softc *sc, u8 *buf, u32 len, u32 size);
+int ath9k_dump_btcoex(struct ath_softc *sc, u8 *buf, u32 size);
 #else
 static inline int ath9k_init_btcoex(struct ath_softc *sc)
 {
@@ -521,8 +527,7 @@ static inline u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc,
 static inline void ath9k_btcoex_stop_gen_timer(struct ath_softc *sc)
 {
 }
-static inline int ath9k_dump_btcoex(struct ath_softc *sc, u8 *buf,
-				    u32 len, u32 size)
+static inline int ath9k_dump_btcoex(struct ath_softc *sc, u8 *buf, u32 size)
 {
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index a8be94b..585aee4 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1599,8 +1599,14 @@ static ssize_t read_file_btcoex(struct file *file, char __user *user_buf,
 	if (buf == NULL)
 		return -ENOMEM;
 
-	len = ath9k_dump_btcoex(sc, buf, len, size);
+	if (!sc->sc_ah->common.btcoex_enabled) {
+		len = snprintf(buf, size, "%s\n",
+			       "BTCOEX is disabled");
+		goto exit;
+	}
 
+	len = ath9k_dump_btcoex(sc, buf, size);
+exit:
 	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
 	kfree(buf);
 
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index a8ea57b..4236df8 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -494,35 +494,31 @@ int ath9k_init_btcoex(struct ath_softc *sc)
 	return 0;
 }
 
-int ath9k_dump_btcoex(struct ath_softc *sc, u8 *buf, u32 len, u32 size)
+static int ath9k_dump_mci_btcoex(struct ath_softc *sc, u8 *buf, u32 size)
 {
-#define ATH_DUMP_BTCOEX(_s, _val)                                \
-	do {                                                     \
-		len += snprintf(buf + len, size - len,           \
-				"%20s : %10d\n", _s, (_val));    \
-	} while (0)
-
 	struct ath_btcoex *btcoex = &sc->btcoex;
 	struct ath_mci_profile *mci = &btcoex->mci;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+	u32 len = 0;
 	int i;
 
 	ATH_DUMP_BTCOEX("Total BT profiles", NUM_PROF(mci));
-	ATH_DUMP_BTCOEX("Number of MGMT", mci->num_mgmt);
-	ATH_DUMP_BTCOEX("Number of SCO", mci->num_sco);
-	ATH_DUMP_BTCOEX("Number of A2DP", mci->num_a2dp);
-	ATH_DUMP_BTCOEX("Number of HID", mci->num_hid);
-	ATH_DUMP_BTCOEX("Number of PAN", mci->num_pan);
-	ATH_DUMP_BTCOEX("Number of ACL", mci->num_other_acl);
-	ATH_DUMP_BTCOEX("Number of BDR", mci->num_bdr);
+	ATH_DUMP_BTCOEX("MGMT", mci->num_mgmt);
+	ATH_DUMP_BTCOEX("SCO", mci->num_sco);
+	ATH_DUMP_BTCOEX("A2DP", mci->num_a2dp);
+	ATH_DUMP_BTCOEX("HID", mci->num_hid);
+	ATH_DUMP_BTCOEX("PAN", mci->num_pan);
+	ATH_DUMP_BTCOEX("ACL", mci->num_other_acl);
+	ATH_DUMP_BTCOEX("BDR", mci->num_bdr);
 	ATH_DUMP_BTCOEX("Aggr. Limit", mci->aggr_limit);
 	ATH_DUMP_BTCOEX("Stomp Type", btcoex->bt_stomp_type);
 	ATH_DUMP_BTCOEX("BTCoex Period (msec)", btcoex->btcoex_period);
 	ATH_DUMP_BTCOEX("Duty Cycle", btcoex->duty_cycle);
 	ATH_DUMP_BTCOEX("BT Wait time", btcoex->bt_wait_time);
 	ATH_DUMP_BTCOEX("Concurrent Tx", btcoex_hw->mci.concur_tx);
-	ATH_DUMP_BTCOEX("Concur RSSI count", btcoex->rssi_count);
+	ATH_DUMP_BTCOEX("Concurrent RSSI cnt", btcoex->rssi_count);
+
 	len += snprintf(buf + len, size - len, "BT Weights: ");
 	for (i = 0; i < AR9300_NUM_BT_WEIGHTS; i++)
 		len += snprintf(buf + len, size - len, "%08x ",
@@ -537,9 +533,32 @@ int ath9k_dump_btcoex(struct ath_softc *sc, u8 *buf, u32 len, u32 size)
 	for (i = 0; i < ATH_BTCOEX_STOMP_MAX; i++)
 		len += snprintf(buf + len, size - len, "%08x ",
 				btcoex_hw->tx_prio[i]);
+
 	len += snprintf(buf + len, size - len, "\n");
-#undef ATH_DUMP_BTCOEX
 
 	return len;
 }
+
+static int ath9k_dump_legacy_btcoex(struct ath_softc *sc, u8 *buf, u32 size)
+{
+
+	struct ath_btcoex *btcoex = &sc->btcoex;
+	u32 len = 0;
+
+	ATH_DUMP_BTCOEX("Stomp Type", btcoex->bt_stomp_type);
+	ATH_DUMP_BTCOEX("BTCoex Period (msec)", btcoex->btcoex_period);
+	ATH_DUMP_BTCOEX("Duty Cycle", btcoex->duty_cycle);
+	ATH_DUMP_BTCOEX("BT Wait time", btcoex->bt_wait_time);
+
+	return len;
+}
+
+int ath9k_dump_btcoex(struct ath_softc *sc, u8 *buf, u32 size)
+{
+	if (ath9k_hw_mci_is_enabled(sc->sc_ah))
+		return ath9k_dump_mci_btcoex(sc, buf, size);
+	else
+		return ath9k_dump_legacy_btcoex(sc, buf, size);
+}
+
 #endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
-- 
1.8.0

