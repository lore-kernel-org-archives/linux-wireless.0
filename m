Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44845 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab2BVHLj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 02:11:39 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20292.38178.132196.432415@gargle.gargle.HOWL> (sfid-20120222_081143_435351_62A2D78B)
Date: Wed, 22 Feb 2012 12:41:30 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 16/26] ath9k_hw: Use CONFIG_ATH9K_BTCOEX_SUPPORT
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make use of CONFIG_ATH9K_BTCOEX_SUPPORT in ath9k_hw
to provide a clean way of compilation without BTCOEX
support.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Makefile     |    6 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.h |   63 ++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/btcoex.h     |    1 -
 drivers/net/wireless/ath/ath9k/hw.c         |    3 +-
 drivers/net/wireless/ath/ath9k/hw.h         |   21 ++++++++-
 5 files changed, 79 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index b3c7b12..27d95fe 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -31,14 +31,14 @@ ath9k_hw-y:=	\
 		eeprom_4k.o \
 		eeprom_9287.o \
 		ani.o \
-		btcoex.o \
 		mac.o \
 		ar9002_mac.o \
 		ar9003_mac.o \
 		ar9003_eeprom.o \
-		ar9003_paprd.o \
-		ar9003_mci.o
+		ar9003_paprd.o
 
+ath9k_hw-$(CONFIG_ATH9K_BTCOEX_SUPPORT) += btcoex.o \
+					   ar9003_mci.o
 obj-$(CONFIG_ATH9K_HW) += ath9k_hw.o
 
 obj-$(CONFIG_ATH9K_COMMON) += ath9k_common.o
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index 507527b..de94f69 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -254,16 +254,32 @@ enum mci_gpm_coex_opcode {
 
 #define MCI_GPM_IS_CAL_TYPE(_type) ((_type) <= MCI_GPM_WLAN_CAL_DONE)
 
+/*
+ * Functions that are available to the MCI driver core.
+ */
 bool ar9003_mci_send_message(struct ath_hw *ah, u8 header, u32 flag,
 			     u32 *payload, u8 len, bool wait_done,
 			     bool check_bt);
-void ar9003_mci_stop_bt(struct ath_hw *ah, bool sava_fullsleep);
 u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data);
-void ar9003_mci_init_cal_req(struct ath_hw *ah, bool *is_reusable);
-void ar9003_mci_init_cal_done(struct ath_hw *ah);
 void ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
 		      u16 len, u32 sched_addr);
 void ar9003_mci_cleanup(struct ath_hw *ah);
+void ar9003_mci_get_interrupt(struct ath_hw *ah, u32 *raw_intr,
+			      u32 *rx_msg_intr);
+
+/*
+ * These functions are used by ath9k_hw.
+ */
+
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+
+static inline bool ar9003_mci_is_ready(struct ath_hw *ah)
+{
+	return ah->btcoex_hw.mci.ready;
+}
+void ar9003_mci_stop_bt(struct ath_hw *ah, bool save_fullsleep);
+void ar9003_mci_init_cal_req(struct ath_hw *ah, bool *is_reusable);
+void ar9003_mci_init_cal_done(struct ath_hw *ah);
 void ar9003_mci_set_full_sleep(struct ath_hw *ah);
 void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool wait_done);
 void ar9003_mci_check_bt(struct ath_hw *ah);
@@ -272,13 +288,46 @@ int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 			 struct ath9k_hw_cal_data *caldata);
 void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 		      bool is_full_sleep);
-void ar9003_mci_get_interrupt(struct ath_hw *ah, u32 *raw_intr,
-			      u32 *rx_msg_intr);
 void ar9003_mci_get_isr(struct ath_hw *ah, enum ath9k_int *masked);
 
-static inline bool ar9003_mci_is_ready(struct ath_hw *ah)
+#else
+
+#define ar9003_mci_is_ready(...) false
+
+static inline void ar9003_mci_stop_bt(struct ath_hw *ah, bool save_fullsleep)
+{
+}
+static inline void ar9003_mci_init_cal_req(struct ath_hw *ah, bool *is_reusable)
+{
+}
+static inline void ar9003_mci_init_cal_done(struct ath_hw *ah)
+{
+}
+static inline void ar9003_mci_set_full_sleep(struct ath_hw *ah)
+{
+}
+static inline void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool wait_done)
+{
+}
+static inline void ar9003_mci_check_bt(struct ath_hw *ah)
+{
+}
+static inline bool ar9003_mci_start_reset(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	return false;
+}
+static inline int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
+				       struct ath9k_hw_cal_data *caldata)
+{
+	return 0;
+}
+static inline void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
+				    bool is_full_sleep)
+{
+}
+static inline void ar9003_mci_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 {
-	return ah->btcoex_hw.mci.ready;
 }
+#endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
 
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 10627b4..8f93aef 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -105,7 +105,6 @@ void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum);
 void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
 				u32 bt_weight,
 				u32 wlan_weight);
-void ath9k_hw_btcoex_enable(struct ath_hw *ah);
 void ath9k_hw_btcoex_disable(struct ath_hw *ah);
 void ath9k_hw_btcoex_bt_stomp(struct ath_hw *ah,
 			      enum ath_stomp_type stomp_type);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 5f2e30c..8c840ca 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1800,8 +1800,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 #endif
 	}
 
-	if (ah->btcoex_hw.enabled &&
-	    ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE)
+	if (ath9k_hw_btcoex_is_enabled(ah))
 		ath9k_hw_btcoex_enable(ah);
 
 	if (mci)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index daceba7..d627399 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -801,8 +801,9 @@ struct ath_hw {
 	int firpwr[5];
 	enum ath9k_ani_cmd ani_function;
 
-	/* Bluetooth coexistance */
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	struct ath_btcoex_hw btcoex_hw;
+#endif
 
 	u32 intr_txqs;
 	u8 txchainmask;
@@ -1051,13 +1052,29 @@ void ath9k_hw_proc_mib_event(struct ath_hw *ah);
 void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan);
 
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+static inline bool ath9k_hw_btcoex_is_enabled(struct ath_hw *ah)
+{
+	return ah->btcoex_hw.enabled;
+}
+void ath9k_hw_btcoex_enable(struct ath_hw *ah);
 static inline enum ath_btcoex_scheme
 ath9k_hw_get_btcoex_scheme(struct ath_hw *ah)
 {
 	return ah->btcoex_hw.scheme;
 }
 #else
-#define ath9k_hw_get_btcoex_scheme(...) ATH_BTCOEX_CFG_NONE
+static inline bool ath9k_hw_btcoex_is_enabled(struct ath_hw *ah)
+{
+	return false;
+}
+static inline void ath9k_hw_btcoex_enable(struct ath_hw *ah)
+{
+}
+static inline enum ath_btcoex_scheme
+ath9k_hw_get_btcoex_scheme(struct ath_hw *ah)
+{
+	return ATH_BTCOEX_CFG_NONE;
+}
 #endif
 
 #define ATH9K_CLOCK_RATE_CCK		22
-- 
1.7.9.1

