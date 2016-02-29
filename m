Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 024/113] rtl8xxxu: Add definitions for new generation h2c commands
Date: Mon, 29 Feb 2016 17:04:22 -0500
Message-Id: <1456783551-28315-25-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231104_491169_756A1FD0)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The larger mailboxes also use a different set of mailbox commands.
This provides a list of the 64 bit commands.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 87 ++++++++++++++++++++++--
 1 file changed, 83 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 7aed304..198b1d8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -617,12 +617,91 @@ struct rtl8xxxu_rfregs {
 
 #define H2C_MAX_MBOX			4
 #define H2C_EXT				BIT(7)
-#define H2C_SET_POWER_MODE		1
-#define H2C_JOIN_BSS_REPORT		2
 #define  H2C_JOIN_BSS_DISCONNECT	0
 #define  H2C_JOIN_BSS_CONNECT		1
-#define H2C_SET_RSSI			5
-#define H2C_SET_RATE_MASK		(6 | H2C_EXT)
+
+/*
+ * H2C (firmware) commands differ between the older generation chips
+ * 8188[cr]u, 819[12]cu, and 8723au, and the more recent chips 8723bu,
+ * 8192[de]u, 8192eu, and 8812.
+ */
+enum h2c_cmd_8723a {
+	H2C_SET_POWER_MODE = 1,
+	H2C_JOIN_BSS_REPORT = 2,
+	H2C_SET_RSSI = 5,
+	H2C_SET_RATE_MASK = (6 | H2C_EXT),
+};
+
+enum h2c_cmd_8723b {
+	/*
+	 * Common Class: 000
+	 */
+	H2C_8723B_RSVD_PAGE = 0x00,
+	H2C_8723B_MEDIA_STATUS_RPT = 0x01,
+	H2C_8723B_SCAN_ENABLE = 0x02,
+	H2C_8723B_KEEP_ALIVE = 0x03,
+	H2C_8723B_DISCON_DECISION = 0x04,
+	H2C_8723B_PSD_OFFLOAD = 0x05,
+	H2C_8723B_AP_OFFLOAD = 0x08,
+	H2C_8723B_BCN_RSVDPAGE = 0x09,
+	H2C_8723B_PROBERSP_RSVDPAGE = 0x0A,
+	H2C_8723B_FCS_RSVDPAGE = 0x10,
+	H2C_8723B_FCS_INFO = 0x11,
+	H2C_8723B_AP_WOW_GPIO_CTRL = 0x13,
+
+	/*
+	 * PoweSave Class: 001
+	 */
+	H2C_8723B_SET_PWR_MODE = 0x20,
+	H2C_8723B_PS_TUNING_PARA = 0x21,
+	H2C_8723B_PS_TUNING_PARA2 = 0x22,
+	H2C_8723B_P2P_LPS_PARAM = 0x23,
+	H2C_8723B_P2P_PS_OFFLOAD = 0x24,
+	H2C_8723B_PS_SCAN_ENABLE = 0x25,
+	H2C_8723B_SAP_PS_ = 0x26,
+	H2C_8723B_INACTIVE_PS_ = 0x27,
+	H2C_8723B_FWLPS_IN_IPS_ = 0x28,
+
+	/*
+	 * Dynamic Mechanism Class: 010
+	 */
+	H2C_8723B_MACID_CFG = 0x40,
+	H2C_8723B_TXBF = 0x41,
+	H2C_8723B_RSSI_SETTING = 0x42,
+	H2C_8723B_AP_REQ_TXRPT = 0x43,
+	H2C_8723B_INIT_RATE_COLLECT = 0x44,
+
+	/*
+	 * BT Class: 011
+	 */
+	H2C_8723B_B_TYPE_TDMA = 0x60,
+	H2C_8723B_BT_INFO = 0x61,
+	H2C_8723B_FORCE_BT_TXPWR = 0x62,
+	H2C_8723B_BT_IGNORE_WLANACT = 0x63,
+	H2C_8723B_DAC_SWING_VALUE = 0x64,
+	H2C_8723B_ANT_SEL_RSV = 0x65,
+	H2C_8723B_WL_OPMODE = 0x66,
+	H2C_8723B_BT_MP_OPER = 0x67,
+	H2C_8723B_BT_CONTROL = 0x68,
+	H2C_8723B_BT_WIFI_CTRL = 0x69,
+	H2C_8723B_BT_FW_PATCH = 0x6A,
+	H2C_8723B_BT_WLAN_CALIBRATION = 0x6D,
+
+	/*
+	 * WOWLAN Class: 100
+	 */
+	H2C_8723B_WOWLAN = 0x80,
+	H2C_8723B_REMOTE_WAKE_CTRL = 0x81,
+	H2C_8723B_AOAC_GLOBAL_INFO = 0x82,
+	H2C_8723B_AOAC_RSVD_PAGE = 0x83,
+	H2C_8723B_AOAC_RSVD_PAGE2 = 0x84,
+	H2C_8723B_D0_SCAN_OFFLOAD_CTRL = 0x85,
+	H2C_8723B_D0_SCAN_OFFLOAD_INFO = 0x86,
+	H2C_8723B_CHNL_SWITCH_OFFLOAD = 0x87,
+
+	H2C_8723B_RESET_TSF = 0xC0,
+};
+
 
 struct h2c_cmd {
 	union {
-- 
2.5.0

