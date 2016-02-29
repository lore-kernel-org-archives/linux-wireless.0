Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbcB2WFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:55 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 051/113] rtl8xxxu: Handle BT register writes and MP_OPER events
Date: Mon, 29 Feb 2016 17:04:49 -0500
Message-Id: <1456783551-28315-52-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231001_976419_B01A1580)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

8723bu BT registers are written via the mailbox interface. Add support
for writing these and corresponding C2H event responses.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 34 +++++++++++++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 59 +++++++++++++++++++++++-
 2 files changed, 89 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 35e2522..8535883 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1531,6 +1531,27 @@ error:
 	return retval;
 }
 
+static void rtl8723bu_write_btreg(struct rtl8xxxu_priv *priv, u8 reg, u8 data)
+{
+	struct h2c_cmd h2c;
+	int reqnum = 0;
+
+	memset(&h2c, 0, sizeof(struct h2c_cmd));
+	h2c.bt_mp_oper.cmd = H2C_8723B_BT_MP_OPER;
+	h2c.bt_mp_oper.operreq = 0 | (reqnum << 4);
+	h2c.bt_mp_oper.opcode = BT_MP_OP_WRITE_REG_VALUE;
+	h2c.bt_mp_oper.data = data;
+	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.bt_mp_oper));
+
+	reqnum++;
+	memset(&h2c, 0, sizeof(struct h2c_cmd));
+	h2c.bt_mp_oper.cmd = H2C_8723B_BT_MP_OPER;
+	h2c.bt_mp_oper.operreq = 0 | (reqnum << 4);
+	h2c.bt_mp_oper.opcode = BT_MP_OP_WRITE_REG_VALUE;
+	h2c.bt_mp_oper.addr = reg;
+	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.bt_mp_oper));
+}
+
 static void rtl8723a_enable_rf(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
@@ -5646,6 +5667,8 @@ static void rtl8723bu_init_bt(struct rtl8xxxu_priv *priv)
 
 	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_IQADJ_G1, 0x780);
 
+	rtl8723bu_write_btreg(priv, 0x3c, 0x15); /* BT TRx Mask on */
+
 	/*
 	 * Set BT grant to low
 	 */
@@ -6824,8 +6847,9 @@ static void rtl8723bu_handle_c2h(struct rtl8xxxu_priv *priv,
 
 	len = skb->len - 2;
 
-	pr_info("%s: C2H ID %02x seq %02x, len %02x %02x\n", __func__,
-		c2h->id, c2h->seq, len, c2h->bt_info.response_source);
+	dev_info(dev, "%s: C2H ID %02x seq %02x, len %02x source %02x\n",
+		 __func__,
+		 c2h->id, c2h->seq, len, c2h->bt_info.response_source);
 
 	switch(c2h->id) {
 	case C2H_8723B_BT_INFO:
@@ -6837,8 +6861,14 @@ static void rtl8723bu_handle_c2h(struct rtl8xxxu_priv *priv,
 
 		if (c2h->bt_info.bt_has_reset)
 			dev_info(dev, "BT has been reset\n");
+		if (c2h->bt_info.tx_rx_mask)
+			dev_info(dev, "BT TRx mask\n");
 
 		break;
+	case C2H_8723B_BT_MP_INFO:
+		dev_info(dev, "C2H_MP_INFO ext ID %02x, status %02x\n",
+			 c2h->bt_mp_info.ext_id, c2h->bt_mp_info.status);
+		break;
 	default:
 		pr_info("%s: Unhandled C2H event %02x\n", __func__, c2h->id);
 		break;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index e4d5c4b..3e4e355 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -881,6 +881,13 @@ struct h2c_cmd {
 		} __packed b_type_dma;
 		struct {
 			u8 cmd;
+			u8 operreq;
+			u8 opcode;
+			u8 data;
+			u8 addr;
+		} __packed bt_mp_oper;
+		struct {
+			u8 cmd;
 			u8 data;
 		} __packed bt_wlan_calibration;
 		struct {
@@ -908,8 +915,8 @@ enum c2h_evt_8723b {
 	C2H_8723B_BT_OP_MODE = 5,
 	C2H_8723B_EXT_RA_RPT = 6,
 	C2H_8723B_BT_INFO = 9,
-	C2H_8723B_HW_INFO_EXCH = 10,
-	C2H_8723B_BT_MP_INFO = 11,
+	C2H_8723B_HW_INFO_EXCH = 0x0a,
+	C2H_8723B_BT_MP_INFO = 0x0b,
 	C2H_8723B_FW_DEBUG = 0xff,
 };
 
@@ -919,6 +926,46 @@ enum bt_info_src_8723b {
         BT_INFO_SRC_8723B_BT_ACTIVE_SEND = 0x2,
 };
 
+enum bt_mp_oper_opcode_8723b {
+	BT_MP_OP_GET_BT_VERSION	= 0x00,
+	BT_MP_OP_RESET = 0x01,
+	BT_MP_OP_TEST_CTRL = 0x02,
+	BT_MP_OP_SET_BT_MODE = 0x03,
+	BT_MP_OP_SET_CHNL_TX_GAIN = 0x04,
+	BT_MP_OP_SET_PKT_TYPE_LEN = 0x05,
+	BT_MP_OP_SET_PKT_CNT_L_PL_TYPE = 0x06,
+	BT_MP_OP_SET_PKT_CNT_H_PKT_INTV = 0x07,
+	BT_MP_OP_SET_PKT_HEADER = 0x08,
+	BT_MP_OP_SET_WHITENCOEFF = 0x09,
+	BT_MP_OP_SET_BD_ADDR_L = 0x0a,
+	BT_MP_OP_SET_BD_ADDR_H = 0x0b,
+	BT_MP_OP_WRITE_REG_ADDR = 0x0c,
+	BT_MP_OP_WRITE_REG_VALUE = 0x0d,
+	BT_MP_OP_GET_BT_STATUS = 0x0e,
+	BT_MP_OP_GET_BD_ADDR_L = 0x0f,
+	BT_MP_OP_GET_BD_ADDR_H = 0x10,
+	BT_MP_OP_READ_REG = 0x11,
+	BT_MP_OP_SET_TARGET_BD_ADDR_L = 0x12,
+	BT_MP_OP_SET_TARGET_BD_ADDR_H = 0x13,
+	BT_MP_OP_SET_TX_POWER_CALIBRATION = 0x14,
+	BT_MP_OP_GET_RX_PKT_CNT_L = 0x15,
+	BT_MP_OP_GET_RX_PKT_CNT_H = 0x16,
+	BT_MP_OP_GET_RX_ERROR_BITS_L = 0x17,
+	BT_MP_OP_GET_RX_ERROR_BITS_H = 0x18,
+	BT_MP_OP_GET_RSSI = 0x19,
+	BT_MP_OP_GET_CFO_HDR_QUALITY_L = 0x1a,
+	BT_MP_OP_GET_CFO_HDR_QUALITY_H = 0x1b,
+	BT_MP_OP_GET_TARGET_BD_ADDR_L = 0x1c,
+	BT_MP_OP_GET_TARGET_BD_ADDR_H = 0x1d,
+	BT_MP_OP_GET_AFH_MAP_L = 0x1e,
+	BT_MP_OP_GET_AFH_MAP_M = 0x1f,
+	BT_MP_OP_GET_AFH_MAP_H = 0x20,
+	BT_MP_OP_GET_AFH_STATUS = 0x21,
+	BT_MP_OP_SET_TRACKING_INTERVAL = 0x22,
+	BT_MP_OP_SET_THERMAL_METER = 0x23,
+	BT_MP_OP_ENABLE_CFO_TRACKING = 0x24,
+};
+
 struct rtl8723bu_c2h {
 	u8 id;
 	u8 seq;
@@ -927,6 +974,14 @@ struct rtl8723bu_c2h {
 			u8 payload[0];
 		} __packed raw;
 		struct {
+			u8 ext_id;
+			u8 status:4;
+			u8 retlen:4;
+			u8 opcode_ver:4;
+			u8 req_num:4;
+			u8 payload[2];
+		} __packed bt_mp_info;
+		struct {
 			u8 response_source:4;
 			u8 dummy0_0:4;
 
-- 
2.5.0

