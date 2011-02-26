Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49426 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab1BZTBP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Feb 2011 14:01:15 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/5] iwlagn: add BT Session Activity 2 UART message (BT -> WiFi)
Date: Sat, 26 Feb 2011 10:46:04 -0800
Message-Id: <1298745966-25130-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1298745966-25130-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1298745966-25130-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

additional UART message defines

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   78 +++++++++++++++++++++++++++
 1 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index b32b143..df6abbf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -4173,6 +4173,7 @@ enum iwl_bt_coex_profile_traffic_load {
  */
 };
 
+/* BT UART message - Share Part (BT -> WiFi) */
 #define BT_UART_MSG_FRAME1MSGTYPE_POS		(0)
 #define BT_UART_MSG_FRAME1MSGTYPE_MSK		\
 		(0x7 << BT_UART_MSG_FRAME1MSGTYPE_POS)
@@ -4267,6 +4268,83 @@ enum iwl_bt_coex_profile_traffic_load {
 #define BT_UART_MSG_FRAME7RESERVED_MSK		\
 		(0x3 << BT_UART_MSG_FRAME7RESERVED_POS)
 
+/* BT Session Activity 2 UART message (BT -> WiFi) */
+#define BT_UART_MSG_2_FRAME1RESERVED1_POS	(5)
+#define BT_UART_MSG_2_FRAME1RESERVED1_MSK	\
+		(0x1<<BT_UART_MSG_2_FRAME1RESERVED1_POS)
+#define BT_UART_MSG_2_FRAME1RESERVED2_POS	(6)
+#define BT_UART_MSG_2_FRAME1RESERVED2_MSK	\
+		(0x3<<BT_UART_MSG_2_FRAME1RESERVED2_POS)
+
+#define BT_UART_MSG_2_FRAME2AGGTRAFFICLOAD_POS	(0)
+#define BT_UART_MSG_2_FRAME2AGGTRAFFICLOAD_MSK	\
+		(0x3F<<BT_UART_MSG_2_FRAME2AGGTRAFFICLOAD_POS)
+#define BT_UART_MSG_2_FRAME2RESERVED_POS	(6)
+#define BT_UART_MSG_2_FRAME2RESERVED_MSK	\
+		(0x3<<BT_UART_MSG_2_FRAME2RESERVED_POS)
+
+#define BT_UART_MSG_2_FRAME3BRLASTTXPOWER_POS	(0)
+#define BT_UART_MSG_2_FRAME3BRLASTTXPOWER_MSK	\
+		(0xF<<BT_UART_MSG_2_FRAME3BRLASTTXPOWER_POS)
+#define BT_UART_MSG_2_FRAME3INQPAGESRMODE_POS	(4)
+#define BT_UART_MSG_2_FRAME3INQPAGESRMODE_MSK	\
+		(0x1<<BT_UART_MSG_2_FRAME3INQPAGESRMODE_POS)
+#define BT_UART_MSG_2_FRAME3LEMASTER_POS	(5)
+#define BT_UART_MSG_2_FRAME3LEMASTER_MSK	\
+		(0x1<<BT_UART_MSG_2_FRAME3LEMASTER_POS)
+#define BT_UART_MSG_2_FRAME3RESERVED_POS	(6)
+#define BT_UART_MSG_2_FRAME3RESERVED_MSK	\
+		(0x3<<BT_UART_MSG_2_FRAME3RESERVED_POS)
+
+#define BT_UART_MSG_2_FRAME4LELASTTXPOWER_POS	(0)
+#define BT_UART_MSG_2_FRAME4LELASTTXPOWER_MSK	\
+		(0xF<<BT_UART_MSG_2_FRAME4LELASTTXPOWER_POS)
+#define BT_UART_MSG_2_FRAME4NUMLECONN_POS	(4)
+#define BT_UART_MSG_2_FRAME4NUMLECONN_MSK	\
+		(0x3<<BT_UART_MSG_2_FRAME4NUMLECONN_POS)
+#define BT_UART_MSG_2_FRAME4RESERVED_POS	(6)
+#define BT_UART_MSG_2_FRAME4RESERVED_MSK	\
+		(0x3<<BT_UART_MSG_2_FRAME4RESERVED_POS)
+
+#define BT_UART_MSG_2_FRAME5BTMINRSSI_POS	(0)
+#define BT_UART_MSG_2_FRAME5BTMINRSSI_MSK	\
+		(0xF<<BT_UART_MSG_2_FRAME5BTMINRSSI_POS)
+#define BT_UART_MSG_2_FRAME5LESCANINITMODE_POS	(4)
+#define BT_UART_MSG_2_FRAME5LESCANINITMODE_MSK	\
+		(0x1<<BT_UART_MSG_2_FRAME5LESCANINITMODE_POS)
+#define BT_UART_MSG_2_FRAME5LEADVERMODE_POS	(5)
+#define BT_UART_MSG_2_FRAME5LEADVERMODE_MSK	\
+		(0x1<<BT_UART_MSG_2_FRAME5LEADVERMODE_POS)
+#define BT_UART_MSG_2_FRAME5RESERVED_POS	(6)
+#define BT_UART_MSG_2_FRAME5RESERVED_MSK	\
+		(0x3<<BT_UART_MSG_2_FRAME5RESERVED_POS)
+
+#define BT_UART_MSG_2_FRAME6LECONNINTERVAL_POS	(0)
+#define BT_UART_MSG_2_FRAME6LECONNINTERVAL_MSK	\
+		(0x1F<<BT_UART_MSG_2_FRAME6LECONNINTERVAL_POS)
+#define BT_UART_MSG_2_FRAME6RFU_POS		(5)
+#define BT_UART_MSG_2_FRAME6RFU_MSK		\
+		(0x1<<BT_UART_MSG_2_FRAME6RFU_POS)
+#define BT_UART_MSG_2_FRAME6RESERVED_POS	(6)
+#define BT_UART_MSG_2_FRAME6RESERVED_MSK	\
+		(0x3<<BT_UART_MSG_2_FRAME6RESERVED_POS)
+
+#define BT_UART_MSG_2_FRAME7LECONNSLAVELAT_POS	(0)
+#define BT_UART_MSG_2_FRAME7LECONNSLAVELAT_MSK	\
+		(0x7<<BT_UART_MSG_2_FRAME7LECONNSLAVELAT_POS)
+#define BT_UART_MSG_2_FRAME7LEPROFILE1_POS	(3)
+#define BT_UART_MSG_2_FRAME7LEPROFILE1_MSK	\
+		(0x1<<BT_UART_MSG_2_FRAME7LEPROFILE1_POS)
+#define BT_UART_MSG_2_FRAME7LEPROFILE2_POS	(4)
+#define BT_UART_MSG_2_FRAME7LEPROFILE2_MSK	\
+		(0x1<<BT_UART_MSG_2_FRAME7LEPROFILE2_POS)
+#define BT_UART_MSG_2_FRAME7LEPROFILEOTHER_POS	(5)
+#define BT_UART_MSG_2_FRAME7LEPROFILEOTHER_MSK	\
+		(0x1<<BT_UART_MSG_2_FRAME7LEPROFILEOTHER_POS)
+#define BT_UART_MSG_2_FRAME7RESERVED_POS	(6)
+#define BT_UART_MSG_2_FRAME7RESERVED_MSK	\
+		(0x3<<BT_UART_MSG_2_FRAME7RESERVED_POS)
+
 
 struct iwl_bt_uart_msg {
 	u8 header;
-- 
1.7.0.4

