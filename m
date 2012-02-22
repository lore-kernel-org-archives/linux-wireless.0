Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35524 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab2BVHL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 02:11:28 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20292.38166.172540.624239@gargle.gargle.HOWL> (sfid-20120222_081132_235867_997947B3)
Date: Wed, 22 Feb 2012 12:41:18 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 14/26] ath9k_hw: Cleanup MCI bits from hw.h
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves all the MCI-specific declarations that have been
dumped unceremoniously in hw.h to ar9003_mci.h

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    1 +
 drivers/net/wireless/ath/ath9k/ar9003_mci.h |  195 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c         |    1 +
 drivers/net/wireless/ath/ath9k/hw.h         |  195 ---------------------------
 drivers/net/wireless/ath/ath9k/mci.h        |    2 +
 5 files changed, 199 insertions(+), 195 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 575f36a..51687e3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -16,6 +16,7 @@
 #include <linux/export.h>
 #include "hw.h"
 #include "ar9003_mac.h"
+#include "ar9003_mci.h"
 
 static void ar9003_hw_rx_enable(struct ath_hw *hw)
 {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index 798da11..39bbf67 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -99,4 +99,199 @@ enum mci_gpm_coex_bt_update_flags_op {
 					 ATH_MCI_CONFIG_MCI_OBS_BT)
 #define ATH_MCI_CONFIG_MCI_OBS_GPIO     0x0000002F
 
+enum mci_message_header {		/* length of payload */
+	MCI_LNA_CTRL     = 0x10,        /* len = 0 */
+	MCI_CONT_NACK    = 0x20,        /* len = 0 */
+	MCI_CONT_INFO    = 0x30,        /* len = 4 */
+	MCI_CONT_RST     = 0x40,        /* len = 0 */
+	MCI_SCHD_INFO    = 0x50,        /* len = 16 */
+	MCI_CPU_INT      = 0x60,        /* len = 4 */
+	MCI_SYS_WAKING   = 0x70,        /* len = 0 */
+	MCI_GPM          = 0x80,        /* len = 16 */
+	MCI_LNA_INFO     = 0x90,        /* len = 1 */
+	MCI_LNA_STATE    = 0x94,
+	MCI_LNA_TAKE     = 0x98,
+	MCI_LNA_TRANS    = 0x9c,
+	MCI_SYS_SLEEPING = 0xa0,        /* len = 0 */
+	MCI_REQ_WAKE     = 0xc0,        /* len = 0 */
+	MCI_DEBUG_16     = 0xfe,        /* len = 2 */
+	MCI_REMOTE_RESET = 0xff         /* len = 16 */
+};
+
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
+/* MCI GPM/Coex opcode/type definitions */
+enum {
+	MCI_GPM_COEX_W_GPM_PAYLOAD      = 1,
+	MCI_GPM_COEX_B_GPM_TYPE         = 4,
+	MCI_GPM_COEX_B_GPM_OPCODE       = 5,
+	/* MCI_GPM_WLAN_CAL_REQ, MCI_GPM_WLAN_CAL_DONE */
+	MCI_GPM_WLAN_CAL_W_SEQUENCE     = 2,
+
+	/* MCI_GPM_COEX_VERSION_QUERY */
+	/* MCI_GPM_COEX_VERSION_RESPONSE */
+	MCI_GPM_COEX_B_MAJOR_VERSION    = 6,
+	MCI_GPM_COEX_B_MINOR_VERSION    = 7,
+	/* MCI_GPM_COEX_STATUS_QUERY */
+	MCI_GPM_COEX_B_BT_BITMAP        = 6,
+	MCI_GPM_COEX_B_WLAN_BITMAP      = 7,
+	/* MCI_GPM_COEX_HALT_BT_GPM */
+	MCI_GPM_COEX_B_HALT_STATE       = 6,
+	/* MCI_GPM_COEX_WLAN_CHANNELS */
+	MCI_GPM_COEX_B_CHANNEL_MAP      = 6,
+	/* MCI_GPM_COEX_BT_PROFILE_INFO */
+	MCI_GPM_COEX_B_PROFILE_TYPE     = 6,
+	MCI_GPM_COEX_B_PROFILE_LINKID   = 7,
+	MCI_GPM_COEX_B_PROFILE_STATE    = 8,
+	MCI_GPM_COEX_B_PROFILE_ROLE     = 9,
+	MCI_GPM_COEX_B_PROFILE_RATE     = 10,
+	MCI_GPM_COEX_B_PROFILE_VOTYPE   = 11,
+	MCI_GPM_COEX_H_PROFILE_T        = 12,
+	MCI_GPM_COEX_B_PROFILE_W        = 14,
+	MCI_GPM_COEX_B_PROFILE_A        = 15,
+	/* MCI_GPM_COEX_BT_STATUS_UPDATE */
+	MCI_GPM_COEX_B_STATUS_TYPE      = 6,
+	MCI_GPM_COEX_B_STATUS_LINKID    = 7,
+	MCI_GPM_COEX_B_STATUS_STATE     = 8,
+	/* MCI_GPM_COEX_BT_UPDATE_FLAGS */
+	MCI_GPM_COEX_W_BT_FLAGS         = 6,
+	MCI_GPM_COEX_B_BT_FLAGS_OP      = 10
+};
+
+enum mci_gpm_subtype {
+	MCI_GPM_BT_CAL_REQ      = 0,
+	MCI_GPM_BT_CAL_GRANT    = 1,
+	MCI_GPM_BT_CAL_DONE     = 2,
+	MCI_GPM_WLAN_CAL_REQ    = 3,
+	MCI_GPM_WLAN_CAL_GRANT  = 4,
+	MCI_GPM_WLAN_CAL_DONE   = 5,
+	MCI_GPM_COEX_AGENT      = 0x0c,
+	MCI_GPM_RSVD_PATTERN    = 0xfe,
+	MCI_GPM_RSVD_PATTERN32  = 0xfefefefe,
+	MCI_GPM_BT_DEBUG        = 0xff
+};
+
+enum mci_bt_state {
+	MCI_BT_SLEEP,
+	MCI_BT_AWAKE,
+	MCI_BT_CAL_START,
+	MCI_BT_CAL
+};
+
+/* Type of state query */
+enum mci_state_type {
+	MCI_STATE_ENABLE,
+	MCI_STATE_INIT_GPM_OFFSET,
+	MCI_STATE_NEXT_GPM_OFFSET,
+	MCI_STATE_LAST_GPM_OFFSET,
+	MCI_STATE_BT,
+	MCI_STATE_SET_BT_SLEEP,
+	MCI_STATE_SET_BT_AWAKE,
+	MCI_STATE_SET_BT_CAL_START,
+	MCI_STATE_SET_BT_CAL,
+	MCI_STATE_LAST_SCHD_MSG_OFFSET,
+	MCI_STATE_REMOTE_SLEEP,
+	MCI_STATE_CONT_RSSI_POWER,
+	MCI_STATE_CONT_PRIORITY,
+	MCI_STATE_CONT_TXRX,
+	MCI_STATE_RESET_REQ_WAKE,
+	MCI_STATE_SEND_WLAN_COEX_VERSION,
+	MCI_STATE_SET_BT_COEX_VERSION,
+	MCI_STATE_SEND_WLAN_CHANNELS,
+	MCI_STATE_SEND_VERSION_QUERY,
+	MCI_STATE_SEND_STATUS_QUERY,
+	MCI_STATE_NEED_FLUSH_BT_INFO,
+	MCI_STATE_SET_CONCUR_TX_PRI,
+	MCI_STATE_RECOVER_RX,
+	MCI_STATE_NEED_FTP_STOMP,
+	MCI_STATE_NEED_TUNING,
+	MCI_STATE_DEBUG,
+	MCI_STATE_MAX
+};
+
+enum mci_gpm_coex_opcode {
+	MCI_GPM_COEX_VERSION_QUERY,
+	MCI_GPM_COEX_VERSION_RESPONSE,
+	MCI_GPM_COEX_STATUS_QUERY,
+	MCI_GPM_COEX_HALT_BT_GPM,
+	MCI_GPM_COEX_WLAN_CHANNELS,
+	MCI_GPM_COEX_BT_PROFILE_INFO,
+	MCI_GPM_COEX_BT_STATUS_UPDATE,
+	MCI_GPM_COEX_BT_UPDATE_FLAGS
+};
+
+#define MCI_GPM_NOMORE  0
+#define MCI_GPM_MORE    1
+#define MCI_GPM_INVALID 0xffffffff
+
+#define MCI_GPM_RECYCLE(_p_gpm)	do {			  \
+	*(((u32 *)_p_gpm) + MCI_GPM_COEX_W_GPM_PAYLOAD) = \
+				MCI_GPM_RSVD_PATTERN32;   \
+} while (0)
+
+#define MCI_GPM_TYPE(_p_gpm)	\
+	(*(((u8 *)(_p_gpm)) + MCI_GPM_COEX_B_GPM_TYPE) & 0xff)
+
+#define MCI_GPM_OPCODE(_p_gpm)	\
+	(*(((u8 *)(_p_gpm)) + MCI_GPM_COEX_B_GPM_OPCODE) & 0xff)
+
+#define MCI_GPM_SET_CAL_TYPE(_p_gpm, _cal_type)	do {			   \
+	*(((u8 *)(_p_gpm)) + MCI_GPM_COEX_B_GPM_TYPE) = (_cal_type) & 0xff;\
+} while (0)
+
+#define MCI_GPM_SET_TYPE_OPCODE(_p_gpm, _type, _opcode) do {		   \
+	*(((u8 *)(_p_gpm)) + MCI_GPM_COEX_B_GPM_TYPE) = (_type) & 0xff;	   \
+	*(((u8 *)(_p_gpm)) + MCI_GPM_COEX_B_GPM_OPCODE) = (_opcode) & 0xff;\
+} while (0)
+
+#define MCI_GPM_IS_CAL_TYPE(_type) ((_type) <= MCI_GPM_WLAN_CAL_DONE)
+
+bool ar9003_mci_send_message(struct ath_hw *ah, u8 header, u32 flag,
+			     u32 *payload, u8 len, bool wait_done,
+			     bool check_bt);
+void ar9003_mci_stop_bt(struct ath_hw *ah, bool sava_fullsleep);
+void ar9003_mci_mute_bt(struct ath_hw *ah);
+u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data);
+void ar9003_mci_init_cal_req(struct ath_hw *ah, bool *is_reusable);
+void ar9003_mci_init_cal_done(struct ath_hw *ah);
+void ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
+		      u16 len, u32 sched_addr);
+void ar9003_mci_cleanup(struct ath_hw *ah);
+void ar9003_mci_send_coex_halt_bt_gpm(struct ath_hw *ah, bool halt,
+				      bool wait_done);
+u32 ar9003_mci_wait_for_gpm(struct ath_hw *ah, u8 gpm_type,
+			    u8 gpm_opcode, int time_out);
+void ar9003_mci_2g5g_changed(struct ath_hw *ah, bool is_2g);
+void ar9003_mci_set_full_sleep(struct ath_hw *ah);
+void ar9003_mci_disable_interrupt(struct ath_hw *ah);
+void ar9003_mci_enable_interrupt(struct ath_hw *ah);
+void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool wait_done);
+void ar9003_mci_check_bt(struct ath_hw *ah);
+bool ar9003_mci_start_reset(struct ath_hw *ah, struct ath9k_channel *chan);
+int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
+			 struct ath9k_hw_cal_data *caldata);
+void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
+		      bool is_full_sleep);
+bool ar9003_mci_check_int(struct ath_hw *ah, u32 ints);
+void ar9003_mci_remote_reset(struct ath_hw *ah, bool wait_done);
+void ar9003_mci_send_sys_waking(struct ath_hw *ah, bool wait_done);
+void ar9003_mci_send_lna_transfer(struct ath_hw *ah, bool wait_done);
+void ar9003_mci_sync_bt_state(struct ath_hw *ah);
+void ar9003_mci_get_interrupt(struct ath_hw *ah, u32 *raw_intr,
+			      u32 *rx_msg_intr);
+void ar9003_mci_get_isr(struct ath_hw *ah, enum ath9k_int *masked);
+
+static inline bool ar9003_mci_is_ready(struct ath_hw *ah)
+{
+	return ah->btcoex_hw.mci.ready;
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 475e4ca..5f2e30c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -23,6 +23,7 @@
 #include "hw-ops.h"
 #include "rc.h"
 #include "ar9003_mac.h"
+#include "ar9003_mci.h"
 
 static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1b41d11..daceba7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -432,161 +432,6 @@ enum ath9k_rx_qtype {
 	ATH9K_RX_QUEUE_MAX,
 };
 
-enum mci_message_header {		/* length of payload */
-	MCI_LNA_CTRL     = 0x10,        /* len = 0 */
-	MCI_CONT_NACK    = 0x20,        /* len = 0 */
-	MCI_CONT_INFO    = 0x30,        /* len = 4 */
-	MCI_CONT_RST     = 0x40,        /* len = 0 */
-	MCI_SCHD_INFO    = 0x50,        /* len = 16 */
-	MCI_CPU_INT      = 0x60,        /* len = 4 */
-	MCI_SYS_WAKING   = 0x70,        /* len = 0 */
-	MCI_GPM          = 0x80,        /* len = 16 */
-	MCI_LNA_INFO     = 0x90,        /* len = 1 */
-	MCI_LNA_STATE    = 0x94,
-	MCI_LNA_TAKE     = 0x98,
-	MCI_LNA_TRANS    = 0x9c,
-	MCI_SYS_SLEEPING = 0xa0,        /* len = 0 */
-	MCI_REQ_WAKE     = 0xc0,        /* len = 0 */
-	MCI_DEBUG_16     = 0xfe,        /* len = 2 */
-	MCI_REMOTE_RESET = 0xff         /* len = 16 */
-};
-
-enum ath_mci_gpm_coex_profile_type {
-	MCI_GPM_COEX_PROFILE_UNKNOWN,
-	MCI_GPM_COEX_PROFILE_RFCOMM,
-	MCI_GPM_COEX_PROFILE_A2DP,
-	MCI_GPM_COEX_PROFILE_HID,
-	MCI_GPM_COEX_PROFILE_BNEP,
-	MCI_GPM_COEX_PROFILE_VOICE,
-	MCI_GPM_COEX_PROFILE_MAX
-};
-
-/* MCI GPM/Coex opcode/type definitions */
-enum {
-	MCI_GPM_COEX_W_GPM_PAYLOAD      = 1,
-	MCI_GPM_COEX_B_GPM_TYPE         = 4,
-	MCI_GPM_COEX_B_GPM_OPCODE       = 5,
-	/* MCI_GPM_WLAN_CAL_REQ, MCI_GPM_WLAN_CAL_DONE */
-	MCI_GPM_WLAN_CAL_W_SEQUENCE     = 2,
-
-	/* MCI_GPM_COEX_VERSION_QUERY */
-	/* MCI_GPM_COEX_VERSION_RESPONSE */
-	MCI_GPM_COEX_B_MAJOR_VERSION    = 6,
-	MCI_GPM_COEX_B_MINOR_VERSION    = 7,
-	/* MCI_GPM_COEX_STATUS_QUERY */
-	MCI_GPM_COEX_B_BT_BITMAP        = 6,
-	MCI_GPM_COEX_B_WLAN_BITMAP      = 7,
-	/* MCI_GPM_COEX_HALT_BT_GPM */
-	MCI_GPM_COEX_B_HALT_STATE       = 6,
-	/* MCI_GPM_COEX_WLAN_CHANNELS */
-	MCI_GPM_COEX_B_CHANNEL_MAP      = 6,
-	/* MCI_GPM_COEX_BT_PROFILE_INFO */
-	MCI_GPM_COEX_B_PROFILE_TYPE     = 6,
-	MCI_GPM_COEX_B_PROFILE_LINKID   = 7,
-	MCI_GPM_COEX_B_PROFILE_STATE    = 8,
-	MCI_GPM_COEX_B_PROFILE_ROLE     = 9,
-	MCI_GPM_COEX_B_PROFILE_RATE     = 10,
-	MCI_GPM_COEX_B_PROFILE_VOTYPE   = 11,
-	MCI_GPM_COEX_H_PROFILE_T        = 12,
-	MCI_GPM_COEX_B_PROFILE_W        = 14,
-	MCI_GPM_COEX_B_PROFILE_A        = 15,
-	/* MCI_GPM_COEX_BT_STATUS_UPDATE */
-	MCI_GPM_COEX_B_STATUS_TYPE      = 6,
-	MCI_GPM_COEX_B_STATUS_LINKID    = 7,
-	MCI_GPM_COEX_B_STATUS_STATE     = 8,
-	/* MCI_GPM_COEX_BT_UPDATE_FLAGS */
-	MCI_GPM_COEX_W_BT_FLAGS         = 6,
-	MCI_GPM_COEX_B_BT_FLAGS_OP      = 10
-};
-
-enum mci_gpm_subtype {
-	MCI_GPM_BT_CAL_REQ      = 0,
-	MCI_GPM_BT_CAL_GRANT    = 1,
-	MCI_GPM_BT_CAL_DONE     = 2,
-	MCI_GPM_WLAN_CAL_REQ    = 3,
-	MCI_GPM_WLAN_CAL_GRANT  = 4,
-	MCI_GPM_WLAN_CAL_DONE   = 5,
-	MCI_GPM_COEX_AGENT      = 0x0c,
-	MCI_GPM_RSVD_PATTERN    = 0xfe,
-	MCI_GPM_RSVD_PATTERN32  = 0xfefefefe,
-	MCI_GPM_BT_DEBUG        = 0xff
-};
-
-enum mci_bt_state {
-	MCI_BT_SLEEP,
-	MCI_BT_AWAKE,
-	MCI_BT_CAL_START,
-	MCI_BT_CAL
-};
-
-/* Type of state query */
-enum mci_state_type {
-	MCI_STATE_ENABLE,
-	MCI_STATE_INIT_GPM_OFFSET,
-	MCI_STATE_NEXT_GPM_OFFSET,
-	MCI_STATE_LAST_GPM_OFFSET,
-	MCI_STATE_BT,
-	MCI_STATE_SET_BT_SLEEP,
-	MCI_STATE_SET_BT_AWAKE,
-	MCI_STATE_SET_BT_CAL_START,
-	MCI_STATE_SET_BT_CAL,
-	MCI_STATE_LAST_SCHD_MSG_OFFSET,
-	MCI_STATE_REMOTE_SLEEP,
-	MCI_STATE_CONT_RSSI_POWER,
-	MCI_STATE_CONT_PRIORITY,
-	MCI_STATE_CONT_TXRX,
-	MCI_STATE_RESET_REQ_WAKE,
-	MCI_STATE_SEND_WLAN_COEX_VERSION,
-	MCI_STATE_SET_BT_COEX_VERSION,
-	MCI_STATE_SEND_WLAN_CHANNELS,
-	MCI_STATE_SEND_VERSION_QUERY,
-	MCI_STATE_SEND_STATUS_QUERY,
-	MCI_STATE_NEED_FLUSH_BT_INFO,
-	MCI_STATE_SET_CONCUR_TX_PRI,
-	MCI_STATE_RECOVER_RX,
-	MCI_STATE_NEED_FTP_STOMP,
-	MCI_STATE_NEED_TUNING,
-	MCI_STATE_DEBUG,
-	MCI_STATE_MAX
-};
-
-enum mci_gpm_coex_opcode {
-	MCI_GPM_COEX_VERSION_QUERY,
-	MCI_GPM_COEX_VERSION_RESPONSE,
-	MCI_GPM_COEX_STATUS_QUERY,
-	MCI_GPM_COEX_HALT_BT_GPM,
-	MCI_GPM_COEX_WLAN_CHANNELS,
-	MCI_GPM_COEX_BT_PROFILE_INFO,
-	MCI_GPM_COEX_BT_STATUS_UPDATE,
-	MCI_GPM_COEX_BT_UPDATE_FLAGS
-};
-
-#define MCI_GPM_NOMORE  0
-#define MCI_GPM_MORE    1
-#define MCI_GPM_INVALID 0xffffffff
-
-#define MCI_GPM_RECYCLE(_p_gpm)	do {			  \
-	*(((u32 *)_p_gpm) + MCI_GPM_COEX_W_GPM_PAYLOAD) = \
-				MCI_GPM_RSVD_PATTERN32;   \
-} while (0)
-
-#define MCI_GPM_TYPE(_p_gpm)	\
-	(*(((u8 *)(_p_gpm)) + MCI_GPM_COEX_B_GPM_TYPE) & 0xff)
-
-#define MCI_GPM_OPCODE(_p_gpm)	\
-	(*(((u8 *)(_p_gpm)) + MCI_GPM_COEX_B_GPM_OPCODE) & 0xff)
-
-#define MCI_GPM_SET_CAL_TYPE(_p_gpm, _cal_type)	do {			   \
-	*(((u8 *)(_p_gpm)) + MCI_GPM_COEX_B_GPM_TYPE) = (_cal_type) & 0xff;\
-} while (0)
-
-#define MCI_GPM_SET_TYPE_OPCODE(_p_gpm, _type, _opcode) do {		   \
-	*(((u8 *)(_p_gpm)) + MCI_GPM_COEX_B_GPM_TYPE) = (_type) & 0xff;	   \
-	*(((u8 *)(_p_gpm)) + MCI_GPM_COEX_B_GPM_OPCODE) = (_opcode) & 0xff;\
-} while (0)
-
-#define MCI_GPM_IS_CAL_TYPE(_type) ((_type) <= MCI_GPM_WLAN_CAL_DONE)
-
 struct ath9k_beacon_state {
 	u32 bs_nexttbtt;
 	u32 bs_nextdtim;
@@ -1205,46 +1050,6 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning);
 void ath9k_hw_proc_mib_event(struct ath_hw *ah);
 void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan);
 
-bool ar9003_mci_send_message(struct ath_hw *ah, u8 header, u32 flag,
-			     u32 *payload, u8 len, bool wait_done,
-			     bool check_bt);
-void ar9003_mci_stop_bt(struct ath_hw *ah, bool sava_fullsleep);
-void ar9003_mci_mute_bt(struct ath_hw *ah);
-u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data);
-void ar9003_mci_init_cal_req(struct ath_hw *ah, bool *is_reusable);
-void ar9003_mci_init_cal_done(struct ath_hw *ah);
-void ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
-		      u16 len, u32 sched_addr);
-void ar9003_mci_cleanup(struct ath_hw *ah);
-void ar9003_mci_send_coex_halt_bt_gpm(struct ath_hw *ah, bool halt,
-				      bool wait_done);
-u32 ar9003_mci_wait_for_gpm(struct ath_hw *ah, u8 gpm_type,
-			    u8 gpm_opcode, int time_out);
-void ar9003_mci_2g5g_changed(struct ath_hw *ah, bool is_2g);
-void ar9003_mci_set_full_sleep(struct ath_hw *ah);
-void ar9003_mci_disable_interrupt(struct ath_hw *ah);
-void ar9003_mci_enable_interrupt(struct ath_hw *ah);
-void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool wait_done);
-void ar9003_mci_check_bt(struct ath_hw *ah);
-bool ar9003_mci_start_reset(struct ath_hw *ah, struct ath9k_channel *chan);
-int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
-			 struct ath9k_hw_cal_data *caldata);
-void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
-		      bool is_full_sleep);
-bool ar9003_mci_check_int(struct ath_hw *ah, u32 ints);
-void ar9003_mci_remote_reset(struct ath_hw *ah, bool wait_done);
-void ar9003_mci_send_sys_waking(struct ath_hw *ah, bool wait_done);
-void ar9003_mci_send_lna_transfer(struct ath_hw *ah, bool wait_done);
-void ar9003_mci_sync_bt_state(struct ath_hw *ah);
-void ar9003_mci_get_interrupt(struct ath_hw *ah, u32 *raw_intr,
-			      u32 *rx_msg_intr);
-void ar9003_mci_get_isr(struct ath_hw *ah, enum ath9k_int *masked);
-
-static inline bool ar9003_mci_is_ready(struct ath_hw *ah)
-{
-	return ah->btcoex_hw.mci.ready;
-}
-
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 static inline enum ath_btcoex_scheme
 ath9k_hw_get_btcoex_scheme(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/mci.h b/drivers/net/wireless/ath/ath9k/mci.h
index b805bf2..c841444 100644
--- a/drivers/net/wireless/ath/ath9k/mci.h
+++ b/drivers/net/wireless/ath/ath9k/mci.h
@@ -17,6 +17,8 @@
 #ifndef MCI_H
 #define MCI_H
 
+#include "ar9003_mci.h"
+
 #define ATH_MCI_SCHED_BUF_SIZE		(16 * 16) /* 16 entries, 4 dword each */
 #define ATH_MCI_GPM_MAX_ENTRY		16
 #define ATH_MCI_GPM_BUF_SIZE		(ATH_MCI_GPM_MAX_ENTRY * 16)
-- 
1.7.9.1

