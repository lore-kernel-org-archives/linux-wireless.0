Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56812 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab1KVQXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 11:23:06 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Wilson Tsao <wtsao@qca.qualcomm.com>
Subject: [PATCH 01/18] ath9k_hw: add definitions to support MCI h/w code
Date: Tue, 22 Nov 2011 21:52:28 +0530
Message-ID: <1321978965-21684-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111122_172310_712484_666ABE8E)
In-Reply-To: <1321978965-21684-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1321978965-21684-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

these definitions will be used by MCI state machine and the corresponding
hardware code

Cc: Wilson Tsao <wtsao@qca.qualcomm.com>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.h |  102 +++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |    3 +
 drivers/net/wireless/ath/ath9k/hw.h         |  146 +++++++++++++
 drivers/net/wireless/ath/ath9k/reg.h        |  304 ++++++++++++++++++++++++---
 4 files changed, 529 insertions(+), 26 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_mci.h

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
new file mode 100644
index 0000000..798da11
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -0,0 +1,102 @@
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
+#ifndef AR9003_MCI_H
+#define AR9003_MCI_H
+
+#define MCI_FLAG_DISABLE_TIMESTAMP      0x00000001      /* Disable time stamp */
+
+/* Default remote BT device MCI COEX version */
+#define MCI_GPM_COEX_MAJOR_VERSION_DEFAULT  3
+#define MCI_GPM_COEX_MINOR_VERSION_DEFAULT  0
+
+/* Local WLAN MCI COEX version */
+#define MCI_GPM_COEX_MAJOR_VERSION_WLAN     3
+#define MCI_GPM_COEX_MINOR_VERSION_WLAN     0
+
+enum mci_gpm_coex_query_type {
+	MCI_GPM_COEX_QUERY_BT_ALL_INFO      = BIT(0),
+	MCI_GPM_COEX_QUERY_BT_TOPOLOGY      = BIT(1),
+	MCI_GPM_COEX_QUERY_BT_DEBUG         = BIT(2),
+};
+
+enum mci_gpm_coex_halt_bt_gpm {
+	MCI_GPM_COEX_BT_GPM_UNHALT,
+	MCI_GPM_COEX_BT_GPM_HALT
+};
+
+enum mci_gpm_coex_bt_update_flags_op {
+	MCI_GPM_COEX_BT_FLAGS_READ,
+	MCI_GPM_COEX_BT_FLAGS_SET,
+	MCI_GPM_COEX_BT_FLAGS_CLEAR
+};
+
+#define MCI_NUM_BT_CHANNELS     79
+
+#define MCI_BT_MCI_FLAGS_UPDATE_CORR          0x00000002
+#define MCI_BT_MCI_FLAGS_UPDATE_HDR           0x00000004
+#define MCI_BT_MCI_FLAGS_UPDATE_PLD           0x00000008
+#define MCI_BT_MCI_FLAGS_LNA_CTRL             0x00000010
+#define MCI_BT_MCI_FLAGS_DEBUG                0x00000020
+#define MCI_BT_MCI_FLAGS_SCHED_MSG            0x00000040
+#define MCI_BT_MCI_FLAGS_CONT_MSG             0x00000080
+#define MCI_BT_MCI_FLAGS_COEX_GPM             0x00000100
+#define MCI_BT_MCI_FLAGS_CPU_INT_MSG          0x00000200
+#define MCI_BT_MCI_FLAGS_MCI_MODE             0x00000400
+#define MCI_BT_MCI_FLAGS_AR9462_MODE          0x00001000
+#define MCI_BT_MCI_FLAGS_OTHER                0x00010000
+
+#define MCI_DEFAULT_BT_MCI_FLAGS              0x00011dde
+
+#define MCI_TOGGLE_BT_MCI_FLAGS  (MCI_BT_MCI_FLAGS_UPDATE_CORR | \
+				  MCI_BT_MCI_FLAGS_UPDATE_HDR  | \
+				  MCI_BT_MCI_FLAGS_UPDATE_PLD  | \
+				  MCI_BT_MCI_FLAGS_MCI_MODE)
+
+#define MCI_2G_FLAGS_CLEAR_MASK   0x00000000
+#define MCI_2G_FLAGS_SET_MASK     MCI_TOGGLE_BT_MCI_FLAGS
+#define MCI_2G_FLAGS              MCI_DEFAULT_BT_MCI_FLAGS
+
+#define MCI_5G_FLAGS_CLEAR_MASK   MCI_TOGGLE_BT_MCI_FLAGS
+#define MCI_5G_FLAGS_SET_MASK     0x00000000
+#define MCI_5G_FLAGS              (MCI_DEFAULT_BT_MCI_FLAGS & \
+				   ~MCI_TOGGLE_BT_MCI_FLAGS)
+
+/*
+ * Default value for AR9462 is 0x00002201
+ */
+#define ATH_MCI_CONFIG_CONCUR_TX            0x00000003
+#define ATH_MCI_CONFIG_MCI_OBS_MCI          0x00000004
+#define ATH_MCI_CONFIG_MCI_OBS_TXRX         0x00000008
+#define ATH_MCI_CONFIG_MCI_OBS_BT           0x00000010
+#define ATH_MCI_CONFIG_DISABLE_MCI_CAL      0x00000020
+#define ATH_MCI_CONFIG_DISABLE_OSLA         0x00000040
+#define ATH_MCI_CONFIG_DISABLE_FTP_STOMP    0x00000080
+#define ATH_MCI_CONFIG_AGGR_THRESH          0x00000700
+#define ATH_MCI_CONFIG_AGGR_THRESH_S        8
+#define ATH_MCI_CONFIG_DISABLE_AGGR_THRESH  0x00000800
+#define ATH_MCI_CONFIG_CLK_DIV              0x00003000
+#define ATH_MCI_CONFIG_CLK_DIV_S            12
+#define ATH_MCI_CONFIG_DISABLE_TUNING       0x00004000
+#define ATH_MCI_CONFIG_MCI_WEIGHT_DBG       0x40000000
+#define ATH_MCI_CONFIG_DISABLE_MCI          0x80000000
+
+#define ATH_MCI_CONFIG_MCI_OBS_MASK     (ATH_MCI_CONFIG_MCI_OBS_MCI  | \
+					 ATH_MCI_CONFIG_MCI_OBS_TXRX | \
+					 ATH_MCI_CONFIG_MCI_OBS_BT)
+#define ATH_MCI_CONFIG_MCI_OBS_GPIO     0x0000002F
+
+#endif
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 497d746..ed64114 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -490,6 +490,8 @@
 #define AR_PHY_TEST_CTL_TSTADC_EN_S       8
 #define AR_PHY_TEST_CTL_RX_OBS_SEL        0x3C00
 #define AR_PHY_TEST_CTL_RX_OBS_SEL_S      10
+#define AR_PHY_TEST_CTL_DEBUGPORT_SEL	  0xe0000000
+#define AR_PHY_TEST_CTL_DEBUGPORT_SEL_S	  29
 
 
 #define AR_PHY_TSTDAC            (AR_SM_BASE + 0x168)
@@ -1001,6 +1003,7 @@
 
 /* GLB Registers */
 #define AR_GLB_BASE	0x20000
+#define AR_GLB_GPIO_CONTROL	(AR_GLB_BASE)
 #define AR_PHY_GLB_CONTROL	(AR_GLB_BASE + 0x44)
 #define AR_GLB_SCRATCH(_ah)	(AR_GLB_BASE + \
 					(AR_SREV_9462_20(_ah) ? 0x4c : 0x50))
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 3cb878c..4f786cb 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -266,6 +266,7 @@ enum ath9k_int {
 	ATH9K_INT_TX = 0x00000040,
 	ATH9K_INT_TXDESC = 0x00000080,
 	ATH9K_INT_TIM_TIMER = 0x00000100,
+	ATH9K_INT_MCI = 0x00000200,
 	ATH9K_INT_BB_WATCHDOG = 0x00000400,
 	ATH9K_INT_TXURN = 0x00000800,
 	ATH9K_INT_MIB = 0x00001000,
@@ -417,6 +418,25 @@ enum ath9k_rx_qtype {
 	ATH9K_RX_QUEUE_MAX,
 };
 
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
 enum ath_mci_gpm_coex_profile_type {
 	MCI_GPM_COEX_PROFILE_UNKNOWN,
 	MCI_GPM_COEX_PROFILE_RFCOMM,
@@ -427,6 +447,132 @@ enum ath_mci_gpm_coex_profile_type {
 	MCI_GPM_COEX_PROFILE_MAX
 };
 
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
 struct ath9k_beacon_state {
 	u32 bs_nexttbtt;
 	u32 bs_nextdtim;
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 4591097..ba3672f 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1006,6 +1006,8 @@ enum {
 #define AR_INTR_ASYNC_MASK                       (AR_SREV_9340(ah) ? 0x4018 : 0x4030)
 #define AR_INTR_ASYNC_MASK_GPIO                  0xFFFC0000
 #define AR_INTR_ASYNC_MASK_GPIO_S                18
+#define AR_INTR_ASYNC_MASK_MCI                   0x00000080
+#define AR_INTR_ASYNC_MASK_MCI_S                 7
 
 #define AR_INTR_SYNC_MASK                        (AR_SREV_9340(ah) ? 0x401c : 0x4034)
 #define AR_INTR_SYNC_MASK_GPIO                   0xFFFC0000
@@ -1013,6 +1015,14 @@ enum {
 
 #define AR_INTR_ASYNC_CAUSE_CLR                  (AR_SREV_9340(ah) ? 0x4020 : 0x4038)
 #define AR_INTR_ASYNC_CAUSE                      (AR_SREV_9340(ah) ? 0x4020 : 0x4038)
+#define AR_INTR_ASYNC_CAUSE_MCI			 0x00000080
+#define AR_INTR_ASYNC_USED			 (AR_INTR_MAC_IRQ | \
+						  AR_INTR_ASYNC_CAUSE_MCI)
+
+/* Asynchronous Interrupt Enable Register */
+#define AR_INTR_ASYNC_ENABLE_MCI         0x00000080
+#define AR_INTR_ASYNC_ENABLE_MCI_S       7
+
 
 #define AR_INTR_ASYNC_ENABLE                     (AR_SREV_9340(ah) ? 0x4024 : 0x403c)
 #define AR_INTR_ASYNC_ENABLE_GPIO                0xFFFC0000
@@ -1555,6 +1565,8 @@ enum {
 #define AR_DIAG_FRAME_NV0           0x00020000
 #define AR_DIAG_OBS_PT_SEL1         0x000C0000
 #define AR_DIAG_OBS_PT_SEL1_S       18
+#define AR_DIAG_OBS_PT_SEL2         0x08000000
+#define AR_DIAG_OBS_PT_SEL2_S       27
 #define AR_DIAG_FORCE_RX_CLEAR      0x00100000 /* force rx_clear high */
 #define AR_DIAG_IGNORE_VIRT_CS      0x00200000
 #define AR_DIAG_FORCE_CH_IDLE_HIGH  0x00400000
@@ -1929,37 +1941,277 @@ enum {
 #define AR_PHY_AGC_CONTROL_YCOK_MAX_S		6
 
 /* MCI Registers */
-#define AR_MCI_INTERRUPT_RX_MSG_EN		0x183c
-#define AR_MCI_INTERRUPT_RX_MSG_REMOTE_RESET    0x00000001
-#define AR_MCI_INTERRUPT_RX_MSG_REMOTE_RESET_S  0
-#define AR_MCI_INTERRUPT_RX_MSG_LNA_CONTROL     0x00000002
-#define AR_MCI_INTERRUPT_RX_MSG_LNA_CONTROL_S   1
-#define AR_MCI_INTERRUPT_RX_MSG_CONT_NACK       0x00000004
-#define AR_MCI_INTERRUPT_RX_MSG_CONT_NACK_S     2
-#define AR_MCI_INTERRUPT_RX_MSG_CONT_INFO       0x00000008
-#define AR_MCI_INTERRUPT_RX_MSG_CONT_INFO_S     3
-#define AR_MCI_INTERRUPT_RX_MSG_CONT_RST        0x00000010
-#define AR_MCI_INTERRUPT_RX_MSG_CONT_RST_S      4
-#define AR_MCI_INTERRUPT_RX_MSG_SCHD_INFO       0x00000020
-#define AR_MCI_INTERRUPT_RX_MSG_SCHD_INFO_S     5
-#define AR_MCI_INTERRUPT_RX_MSG_CPU_INT         0x00000040
-#define AR_MCI_INTERRUPT_RX_MSG_CPU_INT_S       6
-#define AR_MCI_INTERRUPT_RX_MSG_GPM             0x00000100
-#define AR_MCI_INTERRUPT_RX_MSG_GPM_S           8
-#define AR_MCI_INTERRUPT_RX_MSG_LNA_INFO        0x00000200
-#define AR_MCI_INTERRUPT_RX_MSG_LNA_INFO_S      9
-#define AR_MCI_INTERRUPT_RX_MSG_SYS_SLEEPING    0x00000400
-#define AR_MCI_INTERRUPT_RX_MSG_SYS_SLEEPING_S  10
-#define AR_MCI_INTERRUPT_RX_MSG_SYS_WAKING      0x00000800
-#define AR_MCI_INTERRUPT_RX_MSG_SYS_WAKING_S    11
-#define AR_MCI_INTERRUPT_RX_MSG_REQ_WAKE        0x00001000
-#define AR_MCI_INTERRUPT_RX_MSG_REQ_WAKE_S      12
-#define AR_MCI_INTERRUPT_RX_HW_MSG_MASK	(AR_MCI_INTERRUPT_RX_MSG_SCHD_INFO  | \
+
+#define AR_MCI_COMMAND0				0x1800
+#define AR_MCI_COMMAND0_HEADER			0xFF
+#define AR_MCI_COMMAND0_HEADER_S		0
+#define AR_MCI_COMMAND0_LEN			0x1f00
+#define AR_MCI_COMMAND0_LEN_S			8
+#define AR_MCI_COMMAND0_DISABLE_TIMESTAMP	0x2000
+#define AR_MCI_COMMAND0_DISABLE_TIMESTAMP_S	13
+
+#define AR_MCI_COMMAND1				0x1804
+
+#define AR_MCI_COMMAND2				0x1808
+#define AR_MCI_COMMAND2_RESET_TX		0x01
+#define AR_MCI_COMMAND2_RESET_TX_S		0
+#define AR_MCI_COMMAND2_RESET_RX		0x02
+#define AR_MCI_COMMAND2_RESET_RX_S		1
+#define AR_MCI_COMMAND2_RESET_RX_NUM_CYCLES     0x3FC
+#define AR_MCI_COMMAND2_RESET_RX_NUM_CYCLES_S   2
+#define AR_MCI_COMMAND2_RESET_REQ_WAKEUP        0x400
+#define AR_MCI_COMMAND2_RESET_REQ_WAKEUP_S      10
+
+#define AR_MCI_RX_CTRL				0x180c
+
+#define AR_MCI_TX_CTRL				0x1810
+/* 0 = no division, 1 = divide by 2, 2 = divide by 4, 3 = divide by 8 */
+#define AR_MCI_TX_CTRL_CLK_DIV			0x03
+#define AR_MCI_TX_CTRL_CLK_DIV_S		0
+#define AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE	0x04
+#define AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE_S	2
+#define AR_MCI_TX_CTRL_GAIN_UPDATE_FREQ		0xFFFFF8
+#define AR_MCI_TX_CTRL_GAIN_UPDATE_FREQ_S	3
+#define AR_MCI_TX_CTRL_GAIN_UPDATE_NUM		0xF000000
+#define AR_MCI_TX_CTRL_GAIN_UPDATE_NUM_S	24
+
+#define AR_MCI_MSG_ATTRIBUTES_TABLE			0x1814
+#define AR_MCI_MSG_ATTRIBUTES_TABLE_CHECKSUM		0xFFFF
+#define AR_MCI_MSG_ATTRIBUTES_TABLE_CHECKSUM_S		0
+#define AR_MCI_MSG_ATTRIBUTES_TABLE_INVALID_HDR		0xFFFF0000
+#define AR_MCI_MSG_ATTRIBUTES_TABLE_INVALID_HDR_S	16
+
+#define AR_MCI_SCHD_TABLE_0				0x1818
+#define AR_MCI_SCHD_TABLE_1				0x181c
+#define AR_MCI_GPM_0					0x1820
+#define AR_MCI_GPM_1					0x1824
+#define AR_MCI_GPM_WRITE_PTR				0xFFFF0000
+#define AR_MCI_GPM_WRITE_PTR_S				16
+#define AR_MCI_GPM_BUF_LEN				0x0000FFFF
+#define AR_MCI_GPM_BUF_LEN_S				0
+
+#define AR_MCI_INTERRUPT_RAW				0x1828
+#define AR_MCI_INTERRUPT_EN				0x182c
+#define AR_MCI_INTERRUPT_SW_MSG_DONE			0x00000001
+#define AR_MCI_INTERRUPT_SW_MSG_DONE_S			0
+#define AR_MCI_INTERRUPT_CPU_INT_MSG			0x00000002
+#define AR_MCI_INTERRUPT_CPU_INT_MSG_S			1
+#define AR_MCI_INTERRUPT_RX_CKSUM_FAIL			0x00000004
+#define AR_MCI_INTERRUPT_RX_CKSUM_FAIL_S		2
+#define AR_MCI_INTERRUPT_RX_INVALID_HDR			0x00000008
+#define AR_MCI_INTERRUPT_RX_INVALID_HDR_S		3
+#define AR_MCI_INTERRUPT_RX_HW_MSG_FAIL			0x00000010
+#define AR_MCI_INTERRUPT_RX_HW_MSG_FAIL_S		4
+#define AR_MCI_INTERRUPT_RX_SW_MSG_FAIL			0x00000020
+#define AR_MCI_INTERRUPT_RX_SW_MSG_FAIL_S		5
+#define AR_MCI_INTERRUPT_TX_HW_MSG_FAIL			0x00000080
+#define AR_MCI_INTERRUPT_TX_HW_MSG_FAIL_S		7
+#define AR_MCI_INTERRUPT_TX_SW_MSG_FAIL			0x00000100
+#define AR_MCI_INTERRUPT_TX_SW_MSG_FAIL_S		8
+#define AR_MCI_INTERRUPT_RX_MSG				0x00000200
+#define AR_MCI_INTERRUPT_RX_MSG_S			9
+#define AR_MCI_INTERRUPT_REMOTE_SLEEP_UPDATE		0x00000400
+#define AR_MCI_INTERRUPT_REMOTE_SLEEP_UPDATE_S		10
+#define AR_MCI_INTERRUPT_BT_PRI				0x07fff800
+#define AR_MCI_INTERRUPT_BT_PRI_S			11
+#define AR_MCI_INTERRUPT_BT_PRI_THRESH			0x08000000
+#define AR_MCI_INTERRUPT_BT_PRI_THRESH_S		27
+#define AR_MCI_INTERRUPT_BT_FREQ			0x10000000
+#define AR_MCI_INTERRUPT_BT_FREQ_S			28
+#define AR_MCI_INTERRUPT_BT_STOMP			0x20000000
+#define AR_MCI_INTERRUPT_BT_STOMP_S			29
+#define AR_MCI_INTERRUPT_BB_AIC_IRQ			0x40000000
+#define AR_MCI_INTERRUPT_BB_AIC_IRQ_S			30
+#define AR_MCI_INTERRUPT_CONT_INFO_TIMEOUT		0x80000000
+#define AR_MCI_INTERRUPT_CONT_INFO_TIMEOUT_S		31
+
+#define AR_MCI_INTERRUPT_DEFAULT    (AR_MCI_INTERRUPT_SW_MSG_DONE	  | \
+				     AR_MCI_INTERRUPT_RX_INVALID_HDR	  | \
+				     AR_MCI_INTERRUPT_RX_HW_MSG_FAIL	  | \
+				     AR_MCI_INTERRUPT_RX_SW_MSG_FAIL	  | \
+				     AR_MCI_INTERRUPT_TX_HW_MSG_FAIL	  | \
+				     AR_MCI_INTERRUPT_TX_SW_MSG_FAIL	  | \
+				     AR_MCI_INTERRUPT_RX_MSG		  | \
+				     AR_MCI_INTERRUPT_REMOTE_SLEEP_UPDATE | \
+				     AR_MCI_INTERRUPT_CONT_INFO_TIMEOUT)
+
+#define AR_MCI_INTERRUPT_MSG_FAIL_MASK (AR_MCI_INTERRUPT_RX_HW_MSG_FAIL | \
+					AR_MCI_INTERRUPT_RX_SW_MSG_FAIL | \
+					AR_MCI_INTERRUPT_TX_HW_MSG_FAIL | \
+					AR_MCI_INTERRUPT_TX_SW_MSG_FAIL)
+
+#define AR_MCI_REMOTE_CPU_INT				0x1830
+#define AR_MCI_REMOTE_CPU_INT_EN			0x1834
+#define AR_MCI_INTERRUPT_RX_MSG_RAW			0x1838
+#define AR_MCI_INTERRUPT_RX_MSG_EN			0x183c
+#define AR_MCI_INTERRUPT_RX_MSG_REMOTE_RESET		0x00000001
+#define AR_MCI_INTERRUPT_RX_MSG_REMOTE_RESET_S		0
+#define AR_MCI_INTERRUPT_RX_MSG_LNA_CONTROL		0x00000002
+#define AR_MCI_INTERRUPT_RX_MSG_LNA_CONTROL_S		1
+#define AR_MCI_INTERRUPT_RX_MSG_CONT_NACK		0x00000004
+#define AR_MCI_INTERRUPT_RX_MSG_CONT_NACK_S		2
+#define AR_MCI_INTERRUPT_RX_MSG_CONT_INFO		0x00000008
+#define AR_MCI_INTERRUPT_RX_MSG_CONT_INFO_S		3
+#define AR_MCI_INTERRUPT_RX_MSG_CONT_RST		0x00000010
+#define AR_MCI_INTERRUPT_RX_MSG_CONT_RST_S		4
+#define AR_MCI_INTERRUPT_RX_MSG_SCHD_INFO		0x00000020
+#define AR_MCI_INTERRUPT_RX_MSG_SCHD_INFO_S		5
+#define AR_MCI_INTERRUPT_RX_MSG_CPU_INT			0x00000040
+#define AR_MCI_INTERRUPT_RX_MSG_CPU_INT_S		6
+#define AR_MCI_INTERRUPT_RX_MSG_GPM			0x00000100
+#define AR_MCI_INTERRUPT_RX_MSG_GPM_S			8
+#define AR_MCI_INTERRUPT_RX_MSG_LNA_INFO		0x00000200
+#define AR_MCI_INTERRUPT_RX_MSG_LNA_INFO_S		9
+#define AR_MCI_INTERRUPT_RX_MSG_SYS_SLEEPING		0x00000400
+#define AR_MCI_INTERRUPT_RX_MSG_SYS_SLEEPING_S		10
+#define AR_MCI_INTERRUPT_RX_MSG_SYS_WAKING		0x00000800
+#define AR_MCI_INTERRUPT_RX_MSG_SYS_WAKING_S		11
+#define AR_MCI_INTERRUPT_RX_MSG_REQ_WAKE		0x00001000
+#define AR_MCI_INTERRUPT_RX_MSG_REQ_WAKE_S		12
+#define AR_MCI_INTERRUPT_RX_HW_MSG_MASK	 (AR_MCI_INTERRUPT_RX_MSG_SCHD_INFO  | \
 					  AR_MCI_INTERRUPT_RX_MSG_LNA_CONTROL| \
 					  AR_MCI_INTERRUPT_RX_MSG_LNA_INFO   | \
 					  AR_MCI_INTERRUPT_RX_MSG_CONT_NACK  | \
 					  AR_MCI_INTERRUPT_RX_MSG_CONT_INFO  | \
 					  AR_MCI_INTERRUPT_RX_MSG_CONT_RST)
 
+#define AR_MCI_INTERRUPT_RX_MSG_DEFAULT (AR_MCI_INTERRUPT_RX_MSG_GPM	 | \
+					 AR_MCI_INTERRUPT_RX_MSG_REMOTE_RESET| \
+					 AR_MCI_INTERRUPT_RX_MSG_SYS_WAKING  | \
+					 AR_MCI_INTERRUPT_RX_MSG_SYS_SLEEPING| \
+					 AR_MCI_INTERRUPT_RX_MSG_SCHD_INFO   | \
+					 AR_MCI_INTERRUPT_RX_MSG_LNA_CONTROL | \
+					 AR_MCI_INTERRUPT_RX_MSG_LNA_INFO    | \
+					 AR_MCI_INTERRUPT_RX_MSG_CONT_NACK   | \
+					 AR_MCI_INTERRUPT_RX_MSG_CONT_INFO   | \
+					 AR_MCI_INTERRUPT_RX_MSG_CONT_RST    | \
+					 AR_MCI_INTERRUPT_RX_MSG_REQ_WAKE)
+
+#define AR_MCI_CPU_INT					0x1840
+
+#define AR_MCI_RX_STATUS			0x1844
+#define AR_MCI_RX_LAST_SCHD_MSG_INDEX		0x00000F00
+#define AR_MCI_RX_LAST_SCHD_MSG_INDEX_S		8
+#define AR_MCI_RX_REMOTE_SLEEP			0x00001000
+#define AR_MCI_RX_REMOTE_SLEEP_S		12
+#define AR_MCI_RX_MCI_CLK_REQ			0x00002000
+#define AR_MCI_RX_MCI_CLK_REQ_S			13
+
+#define AR_MCI_CONT_STATUS			0x1848
+#define AR_MCI_CONT_RSSI_POWER			0x000000FF
+#define AR_MCI_CONT_RSSI_POWER_S		0
+#define AR_MCI_CONT_RRIORITY			0x0000FF00
+#define AR_MCI_CONT_RRIORITY_S			8
+#define AR_MCI_CONT_TXRX			0x00010000
+#define AR_MCI_CONT_TXRX_S			16
+
+#define AR_MCI_BT_PRI0				0x184c
+#define AR_MCI_BT_PRI1				0x1850
+#define AR_MCI_BT_PRI2				0x1854
+#define AR_MCI_BT_PRI3				0x1858
+#define AR_MCI_BT_PRI				0x185c
+#define AR_MCI_WL_FREQ0				0x1860
+#define AR_MCI_WL_FREQ1				0x1864
+#define AR_MCI_WL_FREQ2				0x1868
+#define AR_MCI_GAIN				0x186c
+#define AR_MCI_WBTIMER1				0x1870
+#define AR_MCI_WBTIMER2				0x1874
+#define AR_MCI_WBTIMER3				0x1878
+#define AR_MCI_WBTIMER4				0x187c
+#define AR_MCI_MAXGAIN				0x1880
+#define AR_MCI_HW_SCHD_TBL_CTL			0x1884
+#define AR_MCI_HW_SCHD_TBL_D0			0x1888
+#define AR_MCI_HW_SCHD_TBL_D1			0x188c
+#define AR_MCI_HW_SCHD_TBL_D2			0x1890
+#define AR_MCI_HW_SCHD_TBL_D3			0x1894
+#define AR_MCI_TX_PAYLOAD0			0x1898
+#define AR_MCI_TX_PAYLOAD1			0x189c
+#define AR_MCI_TX_PAYLOAD2			0x18a0
+#define AR_MCI_TX_PAYLOAD3			0x18a4
+#define AR_BTCOEX_WBTIMER			0x18a8
+
+#define AR_BTCOEX_CTRL					0x18ac
+#define AR_BTCOEX_CTRL_AR9462_MODE			0x00000001
+#define AR_BTCOEX_CTRL_AR9462_MODE_S			0
+#define AR_BTCOEX_CTRL_WBTIMER_EN			0x00000002
+#define AR_BTCOEX_CTRL_WBTIMER_EN_S			1
+#define AR_BTCOEX_CTRL_MCI_MODE_EN			0x00000004
+#define AR_BTCOEX_CTRL_MCI_MODE_EN_S			2
+#define AR_BTCOEX_CTRL_LNA_SHARED			0x00000008
+#define AR_BTCOEX_CTRL_LNA_SHARED_S			3
+#define AR_BTCOEX_CTRL_PA_SHARED			0x00000010
+#define AR_BTCOEX_CTRL_PA_SHARED_S			4
+#define AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN		0x00000020
+#define AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN_S		5
+#define AR_BTCOEX_CTRL_TIME_TO_NEXT_BT_THRESH_EN	0x00000040
+#define AR_BTCOEX_CTRL_TIME_TO_NEXT_BT_THRESH_EN_S	6
+#define AR_BTCOEX_CTRL_NUM_ANTENNAS			0x00000180
+#define AR_BTCOEX_CTRL_NUM_ANTENNAS_S			7
+#define AR_BTCOEX_CTRL_RX_CHAIN_MASK			0x00000E00
+#define AR_BTCOEX_CTRL_RX_CHAIN_MASK_S			9
+#define AR_BTCOEX_CTRL_AGGR_THRESH			0x00007000
+#define AR_BTCOEX_CTRL_AGGR_THRESH_S			12
+#define AR_BTCOEX_CTRL_1_CHAIN_BCN			0x00080000
+#define AR_BTCOEX_CTRL_1_CHAIN_BCN_S			19
+#define AR_BTCOEX_CTRL_1_CHAIN_ACK			0x00100000
+#define AR_BTCOEX_CTRL_1_CHAIN_ACK_S			20
+#define AR_BTCOEX_CTRL_WAIT_BA_MARGIN			0x1FE00000
+#define AR_BTCOEX_CTRL_WAIT_BA_MARGIN_S			28
+#define AR_BTCOEX_CTRL_REDUCE_TXPWR			0x20000000
+#define AR_BTCOEX_CTRL_REDUCE_TXPWR_S			29
+#define AR_BTCOEX_CTRL_SPDT_ENABLE_10			0x40000000
+#define AR_BTCOEX_CTRL_SPDT_ENABLE_10_S			30
+#define AR_BTCOEX_CTRL_SPDT_POLARITY			0x80000000
+#define AR_BTCOEX_CTRL_SPDT_POLARITY_S			31
+
+#define AR_BTCOEX_WL_WEIGHTS0				0x18b0
+#define AR_BTCOEX_WL_WEIGHTS1				0x18b4
+#define AR_BTCOEX_WL_WEIGHTS2				0x18b8
+#define AR_BTCOEX_WL_WEIGHTS3				0x18bc
+#define AR_BTCOEX_MAX_TXPWR(_x)				(0x18c0 + ((_x) << 2))
+#define AR_BTCOEX_WL_LNA				0x1940
+#define AR_BTCOEX_RFGAIN_CTRL				0x1944
+
+#define AR_BTCOEX_CTRL2					0x1948
+#define AR_BTCOEX_CTRL2_TXPWR_THRESH			0x0007F800
+#define AR_BTCOEX_CTRL2_TXPWR_THRESH_S			11
+#define AR_BTCOEX_CTRL2_TX_CHAIN_MASK			0x00380000
+#define AR_BTCOEX_CTRL2_TX_CHAIN_MASK_S			19
+#define AR_BTCOEX_CTRL2_RX_DEWEIGHT			0x00400000
+#define AR_BTCOEX_CTRL2_RX_DEWEIGHT_S			22
+#define AR_BTCOEX_CTRL2_GPIO_OBS_SEL			0x00800000
+#define AR_BTCOEX_CTRL2_GPIO_OBS_SEL_S			23
+#define AR_BTCOEX_CTRL2_MAC_BB_OBS_SEL			0x01000000
+#define AR_BTCOEX_CTRL2_MAC_BB_OBS_SEL_S		24
+#define AR_BTCOEX_CTRL2_DESC_BASED_TXPWR_ENABLE		0x02000000
+#define AR_BTCOEX_CTRL2_DESC_BASED_TXPWR_ENABLE_S	25
+
+#define AR_BTCOEX_CTRL_SPDT_ENABLE          0x00000001
+#define AR_BTCOEX_CTRL_SPDT_ENABLE_S        0
+#define AR_BTCOEX_CTRL_BT_OWN_SPDT_CTRL     0x00000002
+#define AR_BTCOEX_CTRL_BT_OWN_SPDT_CTRL_S   1
+#define AR_BTCOEX_CTRL_USE_LATCHED_BT_ANT   0x00000004
+#define AR_BTCOEX_CTRL_USE_LATCHED_BT_ANT_S 2
+#define AR_GLB_WLAN_UART_INTF_EN            0x00020000
+#define AR_GLB_WLAN_UART_INTF_EN_S          17
+#define AR_GLB_DS_JTAG_DISABLE              0x00040000
+#define AR_GLB_DS_JTAG_DISABLE_S            18
+
+#define AR_BTCOEX_RC                    0x194c
+#define AR_BTCOEX_MAX_RFGAIN(_x)        (0x1950 + ((_x) << 2))
+#define AR_BTCOEX_DBG                   0x1a50
+#define AR_MCI_LAST_HW_MSG_HDR          0x1a54
+#define AR_MCI_LAST_HW_MSG_BDY          0x1a58
+
+#define AR_MCI_SCHD_TABLE_2             0x1a5c
+#define AR_MCI_SCHD_TABLE_2_MEM_BASED   0x00000001
+#define AR_MCI_SCHD_TABLE_2_MEM_BASED_S 0
+#define AR_MCI_SCHD_TABLE_2_HW_BASED    0x00000002
+#define AR_MCI_SCHD_TABLE_2_HW_BASED_S  1
+
+#define AR_BTCOEX_CTRL3               0x1a60
+#define AR_BTCOEX_CTRL3_CONT_INFO_TIMEOUT	0x00000fff
+#define AR_BTCOEX_CTRL3_CONT_INFO_TIMEOUT_S	0
+
 
 #endif
-- 
1.7.0.4

