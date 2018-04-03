Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:36861 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754887AbeDCHyP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 03:54:15 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 07/17] rtlwifi: halmac: add definition of TX/RX descriptor
Date: Tue, 3 Apr 2018 15:53:22 +0800
Message-ID: <20180403075332.3344-8-pkshih@realtek.com> (sfid-20180403_095449_774178_131263A7)
In-Reply-To: <20180403075332.3344-1-pkshih@realtek.com>
References: <20180403075332.3344-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

TX/RX descriptor are the headers to describe the packet content.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../realtek/rtlwifi/halmac/halmac_rx_bd_nic.h      |  36 ++
 .../realtek/rtlwifi/halmac/halmac_rx_desc_chip.h   | 100 +++++
 .../realtek/rtlwifi/halmac/halmac_rx_desc_nic.h    | 123 ++++++
 .../realtek/rtlwifi/halmac/halmac_tx_bd_nic.h      | 106 +++++
 .../realtek/rtlwifi/halmac/halmac_tx_desc_chip.h   | 398 +++++++++++++++++++
 .../realtek/rtlwifi/halmac/halmac_tx_desc_nic.h    | 439 +++++++++++++++++++++
 6 files changed, 1202 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_rx_bd_nic.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_rx_desc_chip.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_rx_desc_nic.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_tx_bd_nic.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_tx_desc_chip.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_tx_desc_nic.h

diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_rx_bd_nic.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_rx_bd_nic.h
new file mode 100644
index 000000000000..c03d4d0e4e8a
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_rx_bd_nic.h
@@ -0,0 +1,36 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#ifndef _HALMAC_RX_BD_NIC_H_
+#define _HALMAC_RX_BD_NIC_H_
+
+/*TXBD_DW0*/
+
+#define GET_RX_BD_RXFAIL(rxbd) LE_BITS_TO_4BYTE(rxbd + 0x00, 31, 1)
+#define GET_RX_BD_TOTALRXPKTSIZE(rxbd) LE_BITS_TO_4BYTE(rxbd + 0x00, 16, 13)
+#define GET_RX_BD_RXTAG(rxbd) LE_BITS_TO_4BYTE(rxbd + 0x00, 16, 13)
+#define GET_RX_BD_FS(rxbd) LE_BITS_TO_4BYTE(rxbd + 0x00, 15, 1)
+#define GET_RX_BD_LS(rxbd) LE_BITS_TO_4BYTE(rxbd + 0x00, 14, 1)
+#define GET_RX_BD_RXBUFFSIZE(rxbd) LE_BITS_TO_4BYTE(rxbd + 0x00, 0, 14)
+
+/*TXBD_DW1*/
+
+#define GET_RX_BD_PHYSICAL_ADDR_LOW(rxbd) LE_BITS_TO_4BYTE(rxbd + 0x04, 0, 32)
+
+/*TXBD_DW2*/
+
+#define GET_RX_BD_PHYSICAL_ADDR_HIGH(rxbd) LE_BITS_TO_4BYTE(rxbd + 0x08, 0, 32)
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_rx_desc_chip.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_rx_desc_chip.h
new file mode 100644
index 000000000000..3134d3631281
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_rx_desc_chip.h
@@ -0,0 +1,100 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#ifndef _HALMAC_RX_DESC_CHIP_H_
+#define _HALMAC_RX_DESC_CHIP_H_
+
+/*RXDESC_WORD0*/
+
+#define GET_RX_DESC_EOR_8822B(rxdesc) GET_RX_DESC_EOR(rxdesc)
+#define GET_RX_DESC_PHYPKTIDC_8822B(rxdesc) GET_RX_DESC_PHYPKTIDC(rxdesc)
+#define GET_RX_DESC_SWDEC_8822B(rxdesc) GET_RX_DESC_SWDEC(rxdesc)
+#define GET_RX_DESC_PHYST_8822B(rxdesc) GET_RX_DESC_PHYST(rxdesc)
+#define GET_RX_DESC_SHIFT_8822B(rxdesc) GET_RX_DESC_SHIFT(rxdesc)
+#define GET_RX_DESC_QOS_8822B(rxdesc) GET_RX_DESC_QOS(rxdesc)
+#define GET_RX_DESC_SECURITY_8822B(rxdesc) GET_RX_DESC_SECURITY(rxdesc)
+#define GET_RX_DESC_DRV_INFO_SIZE_8822B(rxdesc)                                \
+	GET_RX_DESC_DRV_INFO_SIZE(rxdesc)
+#define GET_RX_DESC_ICV_ERR_8822B(rxdesc) GET_RX_DESC_ICV_ERR(rxdesc)
+#define GET_RX_DESC_CRC32_8822B(rxdesc) GET_RX_DESC_CRC32(rxdesc)
+#define GET_RX_DESC_PKT_LEN_8822B(rxdesc) GET_RX_DESC_PKT_LEN(rxdesc)
+
+/*RXDESC_WORD1*/
+
+#define GET_RX_DESC_BC_8822B(rxdesc) GET_RX_DESC_BC(rxdesc)
+#define GET_RX_DESC_MC_8822B(rxdesc) GET_RX_DESC_MC(rxdesc)
+#define GET_RX_DESC_TY_PE_8822B(rxdesc) GET_RX_DESC_TY_PE(rxdesc)
+#define GET_RX_DESC_MF_8822B(rxdesc) GET_RX_DESC_MF(rxdesc)
+#define GET_RX_DESC_MD_8822B(rxdesc) GET_RX_DESC_MD(rxdesc)
+#define GET_RX_DESC_PWR_8822B(rxdesc) GET_RX_DESC_PWR(rxdesc)
+#define GET_RX_DESC_PAM_8822B(rxdesc) GET_RX_DESC_PAM(rxdesc)
+#define GET_RX_DESC_CHK_VLD_8822B(rxdesc) GET_RX_DESC_CHK_VLD(rxdesc)
+#define GET_RX_DESC_RX_IS_TCP_UDP_8822B(rxdesc)                                \
+	GET_RX_DESC_RX_IS_TCP_UDP(rxdesc)
+#define GET_RX_DESC_RX_IPV_8822B(rxdesc) GET_RX_DESC_RX_IPV(rxdesc)
+#define GET_RX_DESC_CHKERR_8822B(rxdesc) GET_RX_DESC_CHKERR(rxdesc)
+#define GET_RX_DESC_PAGGR_8822B(rxdesc) GET_RX_DESC_PAGGR(rxdesc)
+#define GET_RX_DESC_RXID_MATCH_8822B(rxdesc) GET_RX_DESC_RXID_MATCH(rxdesc)
+#define GET_RX_DESC_AMSDU_8822B(rxdesc) GET_RX_DESC_AMSDU(rxdesc)
+#define GET_RX_DESC_MACID_VLD_8822B(rxdesc) GET_RX_DESC_MACID_VLD(rxdesc)
+#define GET_RX_DESC_TID_8822B(rxdesc) GET_RX_DESC_TID(rxdesc)
+#define GET_RX_DESC_MACID_8822B(rxdesc) GET_RX_DESC_MACID(rxdesc)
+
+/*RXDESC_WORD2*/
+
+#define GET_RX_DESC_FCS_OK_8822B(rxdesc) GET_RX_DESC_FCS_OK(rxdesc)
+#define GET_RX_DESC_PPDU_CNT_8822B(rxdesc) GET_RX_DESC_PPDU_CNT(rxdesc)
+#define GET_RX_DESC_C2H_8822B(rxdesc) GET_RX_DESC_C2H(rxdesc)
+#define GET_RX_DESC_HWRSVD_8822B(rxdesc) GET_RX_DESC_HWRSVD(rxdesc)
+#define GET_RX_DESC_WLANHD_IV_LEN_8822B(rxdesc)                                \
+	GET_RX_DESC_WLANHD_IV_LEN(rxdesc)
+#define GET_RX_DESC_RX_IS_QOS_8822B(rxdesc) GET_RX_DESC_RX_IS_QOS(rxdesc)
+#define GET_RX_DESC_FRAG_8822B(rxdesc) GET_RX_DESC_FRAG(rxdesc)
+#define GET_RX_DESC_SEQ_8822B(rxdesc) GET_RX_DESC_SEQ(rxdesc)
+
+/*RXDESC_WORD3*/
+
+#define GET_RX_DESC_MAGIC_WAKE_8822B(rxdesc) GET_RX_DESC_MAGIC_WAKE(rxdesc)
+#define GET_RX_DESC_UNICAST_WAKE_8822B(rxdesc) GET_RX_DESC_UNICAST_WAKE(rxdesc)
+#define GET_RX_DESC_PATTERN_MATCH_8822B(rxdesc)                                \
+	GET_RX_DESC_PATTERN_MATCH(rxdesc)
+#define GET_RX_DESC_RXPAYLOAD_MATCH_8822B(rxdesc)                              \
+	GET_RX_DESC_RXPAYLOAD_MATCH(rxdesc)
+#define GET_RX_DESC_RXPAYLOAD_ID_8822B(rxdesc) GET_RX_DESC_RXPAYLOAD_ID(rxdesc)
+#define GET_RX_DESC_DMA_AGG_NUM_8822B(rxdesc) GET_RX_DESC_DMA_AGG_NUM(rxdesc)
+#define GET_RX_DESC_BSSID_FIT_1_0_8822B(rxdesc)                                \
+	GET_RX_DESC_BSSID_FIT_1_0(rxdesc)
+#define GET_RX_DESC_EOSP_8822B(rxdesc) GET_RX_DESC_EOSP(rxdesc)
+#define GET_RX_DESC_HTC_8822B(rxdesc) GET_RX_DESC_HTC(rxdesc)
+#define GET_RX_DESC_BSSID_FIT_4_2_8822B(rxdesc)                                \
+	GET_RX_DESC_BSSID_FIT_4_2(rxdesc)
+#define GET_RX_DESC_RX_RATE_8822B(rxdesc) GET_RX_DESC_RX_RATE(rxdesc)
+
+/*RXDESC_WORD4*/
+
+#define GET_RX_DESC_A1_FIT_8822B(rxdesc) GET_RX_DESC_A1_FIT(rxdesc)
+#define GET_RX_DESC_MACID_RPT_BUFF_8822B(rxdesc)                               \
+	GET_RX_DESC_MACID_RPT_BUFF(rxdesc)
+#define GET_RX_DESC_RX_PRE_NDP_VLD_8822B(rxdesc)                               \
+	GET_RX_DESC_RX_PRE_NDP_VLD(rxdesc)
+#define GET_RX_DESC_RX_SCRAMBLER_8822B(rxdesc) GET_RX_DESC_RX_SCRAMBLER(rxdesc)
+#define GET_RX_DESC_RX_EOF_8822B(rxdesc) GET_RX_DESC_RX_EOF(rxdesc)
+#define GET_RX_DESC_PATTERN_IDX_8822B(rxdesc) GET_RX_DESC_PATTERN_IDX(rxdesc)
+
+/*RXDESC_WORD5*/
+
+#define GET_RX_DESC_TSFL_8822B(rxdesc) GET_RX_DESC_TSFL(rxdesc)
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_rx_desc_nic.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_rx_desc_nic.h
new file mode 100644
index 000000000000..245d6d1b60be
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_rx_desc_nic.h
@@ -0,0 +1,123 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#ifndef _HALMAC_RX_DESC_NIC_H_
+#define _HALMAC_RX_DESC_NIC_H_
+
+/*RXDESC_WORD0*/
+
+#define GET_RX_DESC_EOR(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 30, 1)
+#define GET_RX_DESC_PHYPKTIDC(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 28, 1)
+
+#define GET_RX_DESC_SWDEC(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 27, 1)
+#define GET_RX_DESC_PHYST(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 26, 1)
+#define GET_RX_DESC_SHIFT(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 24, 2)
+#define GET_RX_DESC_QOS(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 23, 1)
+#define GET_RX_DESC_SECURITY(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 20, 3)
+#define GET_RX_DESC_DRV_INFO_SIZE(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 16, 4)
+#define GET_RX_DESC_ICV_ERR(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 15, 1)
+#define GET_RX_DESC_CRC32(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 14, 1)
+#define GET_RX_DESC_PKT_LEN(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x00, 0, 14)
+
+/*RXDESC_WORD1*/
+
+#define GET_RX_DESC_BC(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 31, 1)
+#define GET_RX_DESC_MC(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 30, 1)
+
+#define GET_RX_DESC_TY_PE(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 28, 2)
+
+#define GET_RX_DESC_MF(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 27, 1)
+#define GET_RX_DESC_MD(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 26, 1)
+#define GET_RX_DESC_PWR(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 25, 1)
+
+#define GET_RX_DESC_PAM(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 24, 1)
+
+#define GET_RX_DESC_CHK_VLD(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 23, 1)
+
+#define GET_RX_DESC_RX_IS_TCP_UDP(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 22, 1)
+#define GET_RX_DESC_RX_IPV(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 21, 1)
+
+#define GET_RX_DESC_CHKERR(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 20, 1)
+
+#define GET_RX_DESC_PAGGR(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 15, 1)
+
+#define GET_RX_DESC_RXID_MATCH(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 14, 1)
+
+#define GET_RX_DESC_AMSDU(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 13, 1)
+
+#define GET_RX_DESC_MACID_VLD(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 12, 1)
+
+#define GET_RX_DESC_TID(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 8, 4)
+
+#define GET_RX_DESC_MACID(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x04, 0, 7)
+
+/*RXDESC_WORD2*/
+
+#define GET_RX_DESC_FCS_OK(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 31, 1)
+
+#define GET_RX_DESC_PPDU_CNT(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 29, 2)
+
+#define GET_RX_DESC_C2H(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 28, 1)
+
+#define GET_RX_DESC_HWRSVD(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 24, 4)
+
+#define GET_RX_DESC_WLANHD_IV_LEN(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 18, 6)
+
+#define GET_RX_DESC_RX_IS_QOS(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 16, 1)
+
+#define GET_RX_DESC_FRAG(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 12, 4)
+#define GET_RX_DESC_SEQ(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x08, 0, 12)
+
+/*RXDESC_WORD3*/
+
+#define GET_RX_DESC_MAGIC_WAKE(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 31, 1)
+#define GET_RX_DESC_UNICAST_WAKE(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 30, 1)
+
+#define GET_RX_DESC_PATTERN_MATCH(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 29, 1)
+
+#define GET_RX_DESC_RXPAYLOAD_MATCH(rxdesc)                                    \
+	LE_BITS_TO_4BYTE(rxdesc + 0x0C, 28, 1)
+#define GET_RX_DESC_RXPAYLOAD_ID(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 24, 4)
+
+#define GET_RX_DESC_DMA_AGG_NUM(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 16, 8)
+
+#define GET_RX_DESC_BSSID_FIT_1_0(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 12, 2)
+#define GET_RX_DESC_EOSP(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 11, 1)
+
+#define GET_RX_DESC_HTC(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 10, 1)
+
+#define GET_RX_DESC_BSSID_FIT_4_2(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 7, 3)
+
+#define GET_RX_DESC_RX_RATE(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x0C, 0, 7)
+
+/*RXDESC_WORD4*/
+
+#define GET_RX_DESC_A1_FIT(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 24, 5)
+
+#define GET_RX_DESC_MACID_RPT_BUFF(rxdesc)                                     \
+	LE_BITS_TO_4BYTE(rxdesc + 0x10, 17, 7)
+#define GET_RX_DESC_RX_PRE_NDP_VLD(rxdesc)                                     \
+	LE_BITS_TO_4BYTE(rxdesc + 0x10, 16, 1)
+
+#define GET_RX_DESC_RX_SCRAMBLER(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 9, 7)
+#define GET_RX_DESC_RX_EOF(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 8, 1)
+
+#define GET_RX_DESC_PATTERN_IDX(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x10, 0, 8)
+
+/*RXDESC_WORD5*/
+
+#define GET_RX_DESC_TSFL(rxdesc) LE_BITS_TO_4BYTE(rxdesc + 0x14, 0, 32)
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_tx_bd_nic.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_tx_bd_nic.h
new file mode 100644
index 000000000000..3260fcfcc04f
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_tx_bd_nic.h
@@ -0,0 +1,106 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#ifndef _HALMAC_TX_BD_NIC_H_
+#define _HALMAC_TX_BD_NIC_H_
+
+/*TXBD_DW0*/
+
+#define SET_TX_BD_OWN(txbd, value)                                             \
+	SET_BITS_TO_LE_4BYTE(txbd + 0x00, 31, 1, value)
+#define GET_TX_BD_OWN(txbd) LE_BITS_TO_4BYTE(txbd + 0x00, 31, 1)
+#define SET_TX_BD_PSB(txbd, value)                                             \
+	SET_BITS_TO_LE_4BYTE(txbd + 0x00, 16, 8, value)
+#define GET_TX_BD_PSB(txbd) LE_BITS_TO_4BYTE(txbd + 0x00, 16, 8)
+#define SET_TX_BD_TX_BUFF_SIZE0(txbd, value)                                   \
+	SET_BITS_TO_LE_4BYTE(txbd + 0x00, 0, 16, value)
+#define GET_TX_BD_TX_BUFF_SIZE0(txbd) LE_BITS_TO_4BYTE(txbd + 0x00, 0, 16)
+
+/*TXBD_DW1*/
+
+#define SET_TX_BD_PHYSICAL_ADDR0_LOW(txbd, value)                              \
+	SET_BITS_TO_LE_4BYTE(txbd + 0x04, 0, 32, value)
+#define GET_TX_BD_PHYSICAL_ADDR0_LOW(txbd) LE_BITS_TO_4BYTE(txbd + 0x04, 0, 32)
+
+/*TXBD_DW2*/
+
+#define SET_TX_BD_PHYSICAL_ADDR0_HIGH(txbd, value)                             \
+	SET_BITS_TO_LE_4BYTE(txbd + 0x08, 0, 32, value)
+#define GET_TX_BD_PHYSICAL_ADDR0_HIGH(txbd) LE_BITS_TO_4BYTE(txbd + 0x08, 0, 32)
+
+/*TXBD_DW4*/
+
+#define SET_TX_BD_A1(txbd, value)                                              \
+	SET_BITS_TO_LE_4BYTE(txbd + 0x10, 31, 1, value)
+#define GET_TX_BD_A1(txbd) LE_BITS_TO_4BYTE(txbd + 0x10, 31, 1)
+#define SET_TX_BD_TX_BUFF_SIZE1(txbd, value)                                   \
+	SET_BITS_TO_LE_4BYTE(txbd + 0x10, 0, 16, value)
+#define GET_TX_BD_TX_BUFF_SIZE1(txbd) LE_BITS_TO_4BYTE(txbd + 0x10, 0, 16)
+
+/*TXBD_DW5*/
+
+#define SET_TX_BD_PHYSICAL_ADDR1_LOW(txbd, value)                              \
+	SET_BITS_TO_LE_4BYTE(txbd + 0x14, 0, 32, value)
+#define GET_TX_BD_PHYSICAL_ADDR1_LOW(txbd) LE_BITS_TO_4BYTE(txbd + 0x14, 0, 32)
+
+/*TXBD_DW6*/
+
+#define SET_TX_BD_PHYSICAL_ADDR1_HIGH(txbd, value)                             \
+	SET_BITS_TO_LE_4BYTE(txbd + 0x18, 0, 32, value)
+#define GET_TX_BD_PHYSICAL_ADDR1_HIGH(txbd) LE_BITS_TO_4BYTE(txbd + 0x18, 0, 32)
+
+/*TXBD_DW8*/
+
+#define SET_TX_BD_A2(txbd, value)                                              \
+	SET_BITS_TO_LE_4BYTE(txbd + 0x20, 31, 1, value)
+#define GET_TX_BD_A2(txbd) LE_BITS_TO_4BYTE(txbd + 0x20, 31, 1)
+#define SET_TX_BD_TX_BUFF_SIZE2(txbd, value)                                   \
+	SET_BITS_TO_LE_4BYTE(txbd + 0x20, 0, 16, value)
+#define GET_TX_BD_TX_BUFF_SIZE2(txbd) LE_BITS_TO_4BYTE(txbd + 0x20, 0, 16)
+
+/*TXBD_DW9*/
+
+#define SET_TX_BD_PHYSICAL_ADDR2_LOW(txbd, value)                              \
+	SET_BITS_TO_LE_4BYTE(txbd + 0x24, 0, 32, value)
+#define GET_TX_BD_PHYSICAL_ADDR2_LOW(txbd) LE_BITS_TO_4BYTE(txbd + 0x24, 0, 32)
+
+/*TXBD_DW10*/
+
+#define SET_TX_BD_PHYSICAL_ADDR2_HIGH(txbd, value)                             \
+	SET_BITS_TO_LE_4BYTE(txbd + 0x28, 0, 32, value)
+#define GET_TX_BD_PHYSICAL_ADDR2_HIGH(txbd) LE_BITS_TO_4BYTE(txbd + 0x28, 0, 32)
+
+/*TXBD_DW12*/
+
+#define SET_TX_BD_A3(txbd, value)                                              \
+	SET_BITS_TO_LE_4BYTE(txbd + 0x30, 31, 1, value)
+#define GET_TX_BD_A3(txbd) LE_BITS_TO_4BYTE(txbd + 0x30, 31, 1)
+#define SET_TX_BD_TX_BUFF_SIZE3(txbd, value)                                   \
+	SET_BITS_TO_LE_4BYTE(txbd + 0x30, 0, 16, value)
+#define GET_TX_BD_TX_BUFF_SIZE3(txbd) LE_BITS_TO_4BYTE(txbd + 0x30, 0, 16)
+
+/*TXBD_DW13*/
+
+#define SET_TX_BD_PHYSICAL_ADDR3_LOW(txbd, value)                              \
+	SET_BITS_TO_LE_4BYTE(txbd + 0x34, 0, 32, value)
+#define GET_TX_BD_PHYSICAL_ADDR3_LOW(txbd) LE_BITS_TO_4BYTE(txbd + 0x34, 0, 32)
+
+/*TXBD_DW14*/
+
+#define SET_TX_BD_PHYSICAL_ADDR3_HIGH(txbd, value)                             \
+	SET_BITS_TO_LE_4BYTE(txbd + 0x38, 0, 32, value)
+#define GET_TX_BD_PHYSICAL_ADDR3_HIGH(txbd) LE_BITS_TO_4BYTE(txbd + 0x38, 0, 32)
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_tx_desc_chip.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_tx_desc_chip.h
new file mode 100644
index 000000000000..2df9202b7963
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_tx_desc_chip.h
@@ -0,0 +1,398 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#ifndef _HALMAC_TX_DESC_CHIP_H_
+#define _HALMAC_TX_DESC_CHIP_H_
+
+/*TXDESC_WORD0*/
+
+#define SET_TX_DESC_DISQSELSEQ_8822B(txdesc, value)                            \
+	SET_TX_DESC_DISQSELSEQ(txdesc, value)
+#define GET_TX_DESC_DISQSELSEQ_8822B(txdesc) GET_TX_DESC_DISQSELSEQ(txdesc)
+#define SET_TX_DESC_GF_8822B(txdesc, value) SET_TX_DESC_GF(txdesc, value)
+#define GET_TX_DESC_GF_8822B(txdesc) GET_TX_DESC_GF(txdesc)
+#define SET_TX_DESC_NO_ACM_8822B(txdesc, value)                                \
+	SET_TX_DESC_NO_ACM(txdesc, value)
+#define GET_TX_DESC_NO_ACM_8822B(txdesc) GET_TX_DESC_NO_ACM(txdesc)
+#define SET_TX_DESC_BCNPKT_TSF_CTRL_8822B(txdesc, value)                       \
+	SET_TX_DESC_BCNPKT_TSF_CTRL(txdesc, value)
+#define GET_TX_DESC_BCNPKT_TSF_CTRL_8822B(txdesc)                              \
+	GET_TX_DESC_BCNPKT_TSF_CTRL(txdesc)
+#define SET_TX_DESC_AMSDU_PAD_EN_8822B(txdesc, value)                          \
+	SET_TX_DESC_AMSDU_PAD_EN(txdesc, value)
+#define GET_TX_DESC_AMSDU_PAD_EN_8822B(txdesc) GET_TX_DESC_AMSDU_PAD_EN(txdesc)
+#define SET_TX_DESC_LS_8822B(txdesc, value) SET_TX_DESC_LS(txdesc, value)
+#define GET_TX_DESC_LS_8822B(txdesc) GET_TX_DESC_LS(txdesc)
+#define SET_TX_DESC_HTC_8822B(txdesc, value) SET_TX_DESC_HTC(txdesc, value)
+#define GET_TX_DESC_HTC_8822B(txdesc) GET_TX_DESC_HTC(txdesc)
+#define SET_TX_DESC_BMC_8822B(txdesc, value) SET_TX_DESC_BMC(txdesc, value)
+#define GET_TX_DESC_BMC_8822B(txdesc) GET_TX_DESC_BMC(txdesc)
+#define SET_TX_DESC_OFFSET_8822B(txdesc, value)                                \
+	SET_TX_DESC_OFFSET(txdesc, value)
+#define GET_TX_DESC_OFFSET_8822B(txdesc) GET_TX_DESC_OFFSET(txdesc)
+#define SET_TX_DESC_TXPKTSIZE_8822B(txdesc, value)                             \
+	SET_TX_DESC_TXPKTSIZE(txdesc, value)
+#define GET_TX_DESC_TXPKTSIZE_8822B(txdesc) GET_TX_DESC_TXPKTSIZE(txdesc)
+
+/*WORD1*/
+
+#define SET_TX_DESC_MOREDATA_8822B(txdesc, value)                              \
+	SET_TX_DESC_MOREDATA(txdesc, value)
+#define GET_TX_DESC_MOREDATA_8822B(txdesc) GET_TX_DESC_MOREDATA(txdesc)
+#define SET_TX_DESC_PKT_OFFSET_8822B(txdesc, value)                            \
+	SET_TX_DESC_PKT_OFFSET(txdesc, value)
+#define GET_TX_DESC_PKT_OFFSET_8822B(txdesc) GET_TX_DESC_PKT_OFFSET(txdesc)
+#define SET_TX_DESC_SEC_TYPE_8822B(txdesc, value)                              \
+	SET_TX_DESC_SEC_TYPE(txdesc, value)
+#define GET_TX_DESC_SEC_TYPE_8822B(txdesc) GET_TX_DESC_SEC_TYPE(txdesc)
+#define SET_TX_DESC_EN_DESC_ID_8822B(txdesc, value)                            \
+	SET_TX_DESC_EN_DESC_ID(txdesc, value)
+#define GET_TX_DESC_EN_DESC_ID_8822B(txdesc) GET_TX_DESC_EN_DESC_ID(txdesc)
+#define SET_TX_DESC_RATE_ID_8822B(txdesc, value)                               \
+	SET_TX_DESC_RATE_ID(txdesc, value)
+#define GET_TX_DESC_RATE_ID_8822B(txdesc) GET_TX_DESC_RATE_ID(txdesc)
+#define SET_TX_DESC_PIFS_8822B(txdesc, value) SET_TX_DESC_PIFS(txdesc, value)
+#define GET_TX_DESC_PIFS_8822B(txdesc) GET_TX_DESC_PIFS(txdesc)
+#define SET_TX_DESC_LSIG_TXOP_EN_8822B(txdesc, value)                          \
+	SET_TX_DESC_LSIG_TXOP_EN(txdesc, value)
+#define GET_TX_DESC_LSIG_TXOP_EN_8822B(txdesc) GET_TX_DESC_LSIG_TXOP_EN(txdesc)
+#define SET_TX_DESC_RD_NAV_EXT_8822B(txdesc, value)                            \
+	SET_TX_DESC_RD_NAV_EXT(txdesc, value)
+#define GET_TX_DESC_RD_NAV_EXT_8822B(txdesc) GET_TX_DESC_RD_NAV_EXT(txdesc)
+#define SET_TX_DESC_QSEL_8822B(txdesc, value) SET_TX_DESC_QSEL(txdesc, value)
+#define GET_TX_DESC_QSEL_8822B(txdesc) GET_TX_DESC_QSEL(txdesc)
+#define SET_TX_DESC_MACID_8822B(txdesc, value) SET_TX_DESC_MACID(txdesc, value)
+#define GET_TX_DESC_MACID_8822B(txdesc) GET_TX_DESC_MACID(txdesc)
+
+/*TXDESC_WORD2*/
+
+#define SET_TX_DESC_HW_AES_IV_8822B(txdesc, value)                             \
+	SET_TX_DESC_HW_AES_IV(txdesc, value)
+#define GET_TX_DESC_HW_AES_IV_8822B(txdesc) GET_TX_DESC_HW_AES_IV(txdesc)
+#define SET_TX_DESC_FTM_EN_8822B(txdesc, value)                                \
+	SET_TX_DESC_FTM_EN(txdesc, value)
+#define GET_TX_DESC_FTM_EN_8822B(txdesc) GET_TX_DESC_FTM_EN(txdesc)
+#define SET_TX_DESC_G_ID_8822B(txdesc, value) SET_TX_DESC_G_ID(txdesc, value)
+#define GET_TX_DESC_G_ID_8822B(txdesc) GET_TX_DESC_G_ID(txdesc)
+#define SET_TX_DESC_BT_NULL_8822B(txdesc, value)                               \
+	SET_TX_DESC_BT_NULL(txdesc, value)
+#define GET_TX_DESC_BT_NULL_8822B(txdesc) GET_TX_DESC_BT_NULL(txdesc)
+#define SET_TX_DESC_AMPDU_DENSITY_8822B(txdesc, value)                         \
+	SET_TX_DESC_AMPDU_DENSITY(txdesc, value)
+#define GET_TX_DESC_AMPDU_DENSITY_8822B(txdesc)                                \
+	GET_TX_DESC_AMPDU_DENSITY(txdesc)
+#define SET_TX_DESC_SPE_RPT_8822B(txdesc, value)                               \
+	SET_TX_DESC_SPE_RPT(txdesc, value)
+#define GET_TX_DESC_SPE_RPT_8822B(txdesc) GET_TX_DESC_SPE_RPT(txdesc)
+#define SET_TX_DESC_RAW_8822B(txdesc, value) SET_TX_DESC_RAW(txdesc, value)
+#define GET_TX_DESC_RAW_8822B(txdesc) GET_TX_DESC_RAW(txdesc)
+#define SET_TX_DESC_MOREFRAG_8822B(txdesc, value)                              \
+	SET_TX_DESC_MOREFRAG(txdesc, value)
+#define GET_TX_DESC_MOREFRAG_8822B(txdesc) GET_TX_DESC_MOREFRAG(txdesc)
+#define SET_TX_DESC_BK_8822B(txdesc, value) SET_TX_DESC_BK(txdesc, value)
+#define GET_TX_DESC_BK_8822B(txdesc) GET_TX_DESC_BK(txdesc)
+#define SET_TX_DESC_NULL_1_8822B(txdesc, value)                                \
+	SET_TX_DESC_NULL_1(txdesc, value)
+#define GET_TX_DESC_NULL_1_8822B(txdesc) GET_TX_DESC_NULL_1(txdesc)
+#define SET_TX_DESC_NULL_0_8822B(txdesc, value)                                \
+	SET_TX_DESC_NULL_0(txdesc, value)
+#define GET_TX_DESC_NULL_0_8822B(txdesc) GET_TX_DESC_NULL_0(txdesc)
+#define SET_TX_DESC_RDG_EN_8822B(txdesc, value)                                \
+	SET_TX_DESC_RDG_EN(txdesc, value)
+#define GET_TX_DESC_RDG_EN_8822B(txdesc) GET_TX_DESC_RDG_EN(txdesc)
+#define SET_TX_DESC_AGG_EN_8822B(txdesc, value)                                \
+	SET_TX_DESC_AGG_EN(txdesc, value)
+#define GET_TX_DESC_AGG_EN_8822B(txdesc) GET_TX_DESC_AGG_EN(txdesc)
+#define SET_TX_DESC_CCA_RTS_8822B(txdesc, value)                               \
+	SET_TX_DESC_CCA_RTS(txdesc, value)
+#define GET_TX_DESC_CCA_RTS_8822B(txdesc) GET_TX_DESC_CCA_RTS(txdesc)
+#define SET_TX_DESC_TRI_FRAME_8822B(txdesc, value)                             \
+	SET_TX_DESC_TRI_FRAME(txdesc, value)
+#define GET_TX_DESC_TRI_FRAME_8822B(txdesc) GET_TX_DESC_TRI_FRAME(txdesc)
+#define SET_TX_DESC_P_AID_8822B(txdesc, value) SET_TX_DESC_P_AID(txdesc, value)
+#define GET_TX_DESC_P_AID_8822B(txdesc) GET_TX_DESC_P_AID(txdesc)
+
+/*TXDESC_WORD3*/
+
+#define SET_TX_DESC_AMPDU_MAX_TIME_8822B(txdesc, value)                        \
+	SET_TX_DESC_AMPDU_MAX_TIME(txdesc, value)
+#define GET_TX_DESC_AMPDU_MAX_TIME_8822B(txdesc)                               \
+	GET_TX_DESC_AMPDU_MAX_TIME(txdesc)
+#define SET_TX_DESC_NDPA_8822B(txdesc, value) SET_TX_DESC_NDPA(txdesc, value)
+#define GET_TX_DESC_NDPA_8822B(txdesc) GET_TX_DESC_NDPA(txdesc)
+#define SET_TX_DESC_MAX_AGG_NUM_8822B(txdesc, value)                           \
+	SET_TX_DESC_MAX_AGG_NUM(txdesc, value)
+#define GET_TX_DESC_MAX_AGG_NUM_8822B(txdesc) GET_TX_DESC_MAX_AGG_NUM(txdesc)
+#define SET_TX_DESC_USE_MAX_TIME_EN_8822B(txdesc, value)                       \
+	SET_TX_DESC_USE_MAX_TIME_EN(txdesc, value)
+#define GET_TX_DESC_USE_MAX_TIME_EN_8822B(txdesc)                              \
+	GET_TX_DESC_USE_MAX_TIME_EN(txdesc)
+#define SET_TX_DESC_NAVUSEHDR_8822B(txdesc, value)                             \
+	SET_TX_DESC_NAVUSEHDR(txdesc, value)
+#define GET_TX_DESC_NAVUSEHDR_8822B(txdesc) GET_TX_DESC_NAVUSEHDR(txdesc)
+#define SET_TX_DESC_CHK_EN_8822B(txdesc, value)                                \
+	SET_TX_DESC_CHK_EN(txdesc, value)
+#define GET_TX_DESC_CHK_EN_8822B(txdesc) GET_TX_DESC_CHK_EN(txdesc)
+#define SET_TX_DESC_HW_RTS_EN_8822B(txdesc, value)                             \
+	SET_TX_DESC_HW_RTS_EN(txdesc, value)
+#define GET_TX_DESC_HW_RTS_EN_8822B(txdesc) GET_TX_DESC_HW_RTS_EN(txdesc)
+#define SET_TX_DESC_RTSEN_8822B(txdesc, value) SET_TX_DESC_RTSEN(txdesc, value)
+#define GET_TX_DESC_RTSEN_8822B(txdesc) GET_TX_DESC_RTSEN(txdesc)
+#define SET_TX_DESC_CTS2SELF_8822B(txdesc, value)                              \
+	SET_TX_DESC_CTS2SELF(txdesc, value)
+#define GET_TX_DESC_CTS2SELF_8822B(txdesc) GET_TX_DESC_CTS2SELF(txdesc)
+#define SET_TX_DESC_DISDATAFB_8822B(txdesc, value)                             \
+	SET_TX_DESC_DISDATAFB(txdesc, value)
+#define GET_TX_DESC_DISDATAFB_8822B(txdesc) GET_TX_DESC_DISDATAFB(txdesc)
+#define SET_TX_DESC_DISRTSFB_8822B(txdesc, value)                              \
+	SET_TX_DESC_DISRTSFB(txdesc, value)
+#define GET_TX_DESC_DISRTSFB_8822B(txdesc) GET_TX_DESC_DISRTSFB(txdesc)
+#define SET_TX_DESC_USE_RATE_8822B(txdesc, value)                              \
+	SET_TX_DESC_USE_RATE(txdesc, value)
+#define GET_TX_DESC_USE_RATE_8822B(txdesc) GET_TX_DESC_USE_RATE(txdesc)
+#define SET_TX_DESC_HW_SSN_SEL_8822B(txdesc, value)                            \
+	SET_TX_DESC_HW_SSN_SEL(txdesc, value)
+#define GET_TX_DESC_HW_SSN_SEL_8822B(txdesc) GET_TX_DESC_HW_SSN_SEL(txdesc)
+#define SET_TX_DESC_WHEADER_LEN_8822B(txdesc, value)                           \
+	SET_TX_DESC_WHEADER_LEN(txdesc, value)
+#define GET_TX_DESC_WHEADER_LEN_8822B(txdesc) GET_TX_DESC_WHEADER_LEN(txdesc)
+
+/*TXDESC_WORD4*/
+
+#define SET_TX_DESC_PCTS_MASK_IDX_8822B(txdesc, value)                         \
+	SET_TX_DESC_PCTS_MASK_IDX(txdesc, value)
+#define GET_TX_DESC_PCTS_MASK_IDX_8822B(txdesc)                                \
+	GET_TX_DESC_PCTS_MASK_IDX(txdesc)
+#define SET_TX_DESC_PCTS_EN_8822B(txdesc, value)                               \
+	SET_TX_DESC_PCTS_EN(txdesc, value)
+#define GET_TX_DESC_PCTS_EN_8822B(txdesc) GET_TX_DESC_PCTS_EN(txdesc)
+#define SET_TX_DESC_RTSRATE_8822B(txdesc, value)                               \
+	SET_TX_DESC_RTSRATE(txdesc, value)
+#define GET_TX_DESC_RTSRATE_8822B(txdesc) GET_TX_DESC_RTSRATE(txdesc)
+#define SET_TX_DESC_RTS_DATA_RTY_LMT_8822B(txdesc, value)                      \
+	SET_TX_DESC_RTS_DATA_RTY_LMT(txdesc, value)
+#define GET_TX_DESC_RTS_DATA_RTY_LMT_8822B(txdesc)                             \
+	GET_TX_DESC_RTS_DATA_RTY_LMT(txdesc)
+#define SET_TX_DESC_RTY_LMT_EN_8822B(txdesc, value)                            \
+	SET_TX_DESC_RTY_LMT_EN(txdesc, value)
+#define GET_TX_DESC_RTY_LMT_EN_8822B(txdesc) GET_TX_DESC_RTY_LMT_EN(txdesc)
+#define SET_TX_DESC_RTS_RTY_LOWEST_RATE_8822B(txdesc, value)                   \
+	SET_TX_DESC_RTS_RTY_LOWEST_RATE(txdesc, value)
+#define GET_TX_DESC_RTS_RTY_LOWEST_RATE_8822B(txdesc)                          \
+	GET_TX_DESC_RTS_RTY_LOWEST_RATE(txdesc)
+#define SET_TX_DESC_DATA_RTY_LOWEST_RATE_8822B(txdesc, value)                  \
+	SET_TX_DESC_DATA_RTY_LOWEST_RATE(txdesc, value)
+#define GET_TX_DESC_DATA_RTY_LOWEST_RATE_8822B(txdesc)                         \
+	GET_TX_DESC_DATA_RTY_LOWEST_RATE(txdesc)
+#define SET_TX_DESC_TRY_RATE_8822B(txdesc, value)                              \
+	SET_TX_DESC_TRY_RATE(txdesc, value)
+#define GET_TX_DESC_TRY_RATE_8822B(txdesc) GET_TX_DESC_TRY_RATE(txdesc)
+#define SET_TX_DESC_DATARATE_8822B(txdesc, value)                              \
+	SET_TX_DESC_DATARATE(txdesc, value)
+#define GET_TX_DESC_DATARATE_8822B(txdesc) GET_TX_DESC_DATARATE(txdesc)
+
+/*TXDESC_WORD5*/
+
+#define SET_TX_DESC_POLLUTED_8822B(txdesc, value)                              \
+	SET_TX_DESC_POLLUTED(txdesc, value)
+#define GET_TX_DESC_POLLUTED_8822B(txdesc) GET_TX_DESC_POLLUTED(txdesc)
+#define SET_TX_DESC_TXPWR_OFSET_8822B(txdesc, value)                           \
+	SET_TX_DESC_TXPWR_OFSET(txdesc, value)
+#define GET_TX_DESC_TXPWR_OFSET_8822B(txdesc) GET_TX_DESC_TXPWR_OFSET(txdesc)
+#define SET_TX_DESC_TX_ANT_8822B(txdesc, value)                                \
+	SET_TX_DESC_TX_ANT(txdesc, value)
+#define GET_TX_DESC_TX_ANT_8822B(txdesc) GET_TX_DESC_TX_ANT(txdesc)
+#define SET_TX_DESC_PORT_ID_8822B(txdesc, value)                               \
+	SET_TX_DESC_PORT_ID(txdesc, value)
+#define GET_TX_DESC_PORT_ID_8822B(txdesc) GET_TX_DESC_PORT_ID(txdesc)
+#define SET_TX_DESC_MULTIPLE_PORT_8822B(txdesc, value)                         \
+	SET_TX_DESC_MULTIPLE_PORT(txdesc, value)
+#define GET_TX_DESC_MULTIPLE_PORT_8822B(txdesc)                                \
+	GET_TX_DESC_MULTIPLE_PORT(txdesc)
+#define SET_TX_DESC_SIGNALING_TAPKT_EN_8822B(txdesc, value)                    \
+	SET_TX_DESC_SIGNALING_TAPKT_EN(txdesc, value)
+#define GET_TX_DESC_SIGNALING_TAPKT_EN_8822B(txdesc)                           \
+	GET_TX_DESC_SIGNALING_TAPKT_EN(txdesc)
+#define SET_TX_DESC_SIGNALING_TA_PKT_SC_8822B(txdesc, value)                   \
+	SET_TX_DESC_SIGNALING_TA_PKT_SC(txdesc, value)
+#define GET_TX_DESC_SIGNALING_TA_PKT_SC_8822B(txdesc)                          \
+	GET_TX_DESC_SIGNALING_TA_PKT_SC(txdesc)
+#define SET_TX_DESC_RTS_SHORT_8822B(txdesc, value)                             \
+	SET_TX_DESC_RTS_SHORT(txdesc, value)
+#define GET_TX_DESC_RTS_SHORT_8822B(txdesc) GET_TX_DESC_RTS_SHORT(txdesc)
+#define SET_TX_DESC_VCS_STBC_8822B(txdesc, value)                              \
+	SET_TX_DESC_VCS_STBC(txdesc, value)
+#define GET_TX_DESC_VCS_STBC_8822B(txdesc) GET_TX_DESC_VCS_STBC(txdesc)
+#define SET_TX_DESC_DATA_STBC_8822B(txdesc, value)                             \
+	SET_TX_DESC_DATA_STBC(txdesc, value)
+#define GET_TX_DESC_DATA_STBC_8822B(txdesc) GET_TX_DESC_DATA_STBC(txdesc)
+#define SET_TX_DESC_DATA_LDPC_8822B(txdesc, value)                             \
+	SET_TX_DESC_DATA_LDPC(txdesc, value)
+#define GET_TX_DESC_DATA_LDPC_8822B(txdesc) GET_TX_DESC_DATA_LDPC(txdesc)
+#define SET_TX_DESC_DATA_BW_8822B(txdesc, value)                               \
+	SET_TX_DESC_DATA_BW(txdesc, value)
+#define GET_TX_DESC_DATA_BW_8822B(txdesc) GET_TX_DESC_DATA_BW(txdesc)
+#define SET_TX_DESC_DATA_SHORT_8822B(txdesc, value)                            \
+	SET_TX_DESC_DATA_SHORT(txdesc, value)
+#define GET_TX_DESC_DATA_SHORT_8822B(txdesc) GET_TX_DESC_DATA_SHORT(txdesc)
+#define SET_TX_DESC_DATA_SC_8822B(txdesc, value)                               \
+	SET_TX_DESC_DATA_SC(txdesc, value)
+#define GET_TX_DESC_DATA_SC_8822B(txdesc) GET_TX_DESC_DATA_SC(txdesc)
+
+/*TXDESC_WORD6*/
+
+#define SET_TX_DESC_ANTSEL_D_8822B(txdesc, value)                              \
+	SET_TX_DESC_ANTSEL_D(txdesc, value)
+#define GET_TX_DESC_ANTSEL_D_8822B(txdesc) GET_TX_DESC_ANTSEL_D(txdesc)
+#define SET_TX_DESC_ANT_MAPD_8822B(txdesc, value)                              \
+	SET_TX_DESC_ANT_MAPD(txdesc, value)
+#define GET_TX_DESC_ANT_MAPD_8822B(txdesc) GET_TX_DESC_ANT_MAPD(txdesc)
+#define SET_TX_DESC_ANT_MAPC_8822B(txdesc, value)                              \
+	SET_TX_DESC_ANT_MAPC(txdesc, value)
+#define GET_TX_DESC_ANT_MAPC_8822B(txdesc) GET_TX_DESC_ANT_MAPC(txdesc)
+#define SET_TX_DESC_ANT_MAPB_8822B(txdesc, value)                              \
+	SET_TX_DESC_ANT_MAPB(txdesc, value)
+#define GET_TX_DESC_ANT_MAPB_8822B(txdesc) GET_TX_DESC_ANT_MAPB(txdesc)
+#define SET_TX_DESC_ANT_MAPA_8822B(txdesc, value)                              \
+	SET_TX_DESC_ANT_MAPA(txdesc, value)
+#define GET_TX_DESC_ANT_MAPA_8822B(txdesc) GET_TX_DESC_ANT_MAPA(txdesc)
+#define SET_TX_DESC_ANTSEL_C_8822B(txdesc, value)                              \
+	SET_TX_DESC_ANTSEL_C(txdesc, value)
+#define GET_TX_DESC_ANTSEL_C_8822B(txdesc) GET_TX_DESC_ANTSEL_C(txdesc)
+#define SET_TX_DESC_ANTSEL_B_8822B(txdesc, value)                              \
+	SET_TX_DESC_ANTSEL_B(txdesc, value)
+#define GET_TX_DESC_ANTSEL_B_8822B(txdesc) GET_TX_DESC_ANTSEL_B(txdesc)
+#define SET_TX_DESC_ANTSEL_A_8822B(txdesc, value)                              \
+	SET_TX_DESC_ANTSEL_A(txdesc, value)
+#define GET_TX_DESC_ANTSEL_A_8822B(txdesc) GET_TX_DESC_ANTSEL_A(txdesc)
+#define SET_TX_DESC_MBSSID_8822B(txdesc, value)                                \
+	SET_TX_DESC_MBSSID(txdesc, value)
+#define GET_TX_DESC_MBSSID_8822B(txdesc) GET_TX_DESC_MBSSID(txdesc)
+#define SET_TX_DESC_SW_DEFINE_8822B(txdesc, value)                             \
+	SET_TX_DESC_SW_DEFINE(txdesc, value)
+#define GET_TX_DESC_SW_DEFINE_8822B(txdesc) GET_TX_DESC_SW_DEFINE(txdesc)
+
+/*TXDESC_WORD7*/
+
+#define SET_TX_DESC_DMA_TXAGG_NUM_8822B(txdesc, value)                         \
+	SET_TX_DESC_DMA_TXAGG_NUM(txdesc, value)
+#define GET_TX_DESC_DMA_TXAGG_NUM_8822B(txdesc)                                \
+	GET_TX_DESC_DMA_TXAGG_NUM(txdesc)
+#define SET_TX_DESC_FINAL_DATA_RATE_8822B(txdesc, value)                       \
+	SET_TX_DESC_FINAL_DATA_RATE(txdesc, value)
+#define GET_TX_DESC_FINAL_DATA_RATE_8822B(txdesc)                              \
+	GET_TX_DESC_FINAL_DATA_RATE(txdesc)
+#define SET_TX_DESC_NTX_MAP_8822B(txdesc, value)                               \
+	SET_TX_DESC_NTX_MAP(txdesc, value)
+#define GET_TX_DESC_NTX_MAP_8822B(txdesc) GET_TX_DESC_NTX_MAP(txdesc)
+#define SET_TX_DESC_TX_BUFF_SIZE_8822B(txdesc, value)                          \
+	SET_TX_DESC_TX_BUFF_SIZE(txdesc, value)
+#define GET_TX_DESC_TX_BUFF_SIZE_8822B(txdesc) GET_TX_DESC_TX_BUFF_SIZE(txdesc)
+#define SET_TX_DESC_TXDESC_CHECKSUM_8822B(txdesc, value)                       \
+	SET_TX_DESC_TXDESC_CHECKSUM(txdesc, value)
+#define GET_TX_DESC_TXDESC_CHECKSUM_8822B(txdesc)                              \
+	GET_TX_DESC_TXDESC_CHECKSUM(txdesc)
+#define SET_TX_DESC_TIMESTAMP_8822B(txdesc, value)                             \
+	SET_TX_DESC_TIMESTAMP(txdesc, value)
+#define GET_TX_DESC_TIMESTAMP_8822B(txdesc) GET_TX_DESC_TIMESTAMP(txdesc)
+
+/*TXDESC_WORD8*/
+
+#define SET_TX_DESC_TXWIFI_CP_8822B(txdesc, value)                             \
+	SET_TX_DESC_TXWIFI_CP(txdesc, value)
+#define GET_TX_DESC_TXWIFI_CP_8822B(txdesc) GET_TX_DESC_TXWIFI_CP(txdesc)
+#define SET_TX_DESC_MAC_CP_8822B(txdesc, value)                                \
+	SET_TX_DESC_MAC_CP(txdesc, value)
+#define GET_TX_DESC_MAC_CP_8822B(txdesc) GET_TX_DESC_MAC_CP(txdesc)
+#define SET_TX_DESC_STW_PKTRE_DIS_8822B(txdesc, value)                         \
+	SET_TX_DESC_STW_PKTRE_DIS(txdesc, value)
+#define GET_TX_DESC_STW_PKTRE_DIS_8822B(txdesc)                                \
+	GET_TX_DESC_STW_PKTRE_DIS(txdesc)
+#define SET_TX_DESC_STW_RB_DIS_8822B(txdesc, value)                            \
+	SET_TX_DESC_STW_RB_DIS(txdesc, value)
+#define GET_TX_DESC_STW_RB_DIS_8822B(txdesc) GET_TX_DESC_STW_RB_DIS(txdesc)
+#define SET_TX_DESC_STW_RATE_DIS_8822B(txdesc, value)                          \
+	SET_TX_DESC_STW_RATE_DIS(txdesc, value)
+#define GET_TX_DESC_STW_RATE_DIS_8822B(txdesc) GET_TX_DESC_STW_RATE_DIS(txdesc)
+#define SET_TX_DESC_STW_ANT_DIS_8822B(txdesc, value)                           \
+	SET_TX_DESC_STW_ANT_DIS(txdesc, value)
+#define GET_TX_DESC_STW_ANT_DIS_8822B(txdesc) GET_TX_DESC_STW_ANT_DIS(txdesc)
+#define SET_TX_DESC_STW_EN_8822B(txdesc, value)                                \
+	SET_TX_DESC_STW_EN(txdesc, value)
+#define GET_TX_DESC_STW_EN_8822B(txdesc) GET_TX_DESC_STW_EN(txdesc)
+#define SET_TX_DESC_SMH_EN_8822B(txdesc, value)                                \
+	SET_TX_DESC_SMH_EN(txdesc, value)
+#define GET_TX_DESC_SMH_EN_8822B(txdesc) GET_TX_DESC_SMH_EN(txdesc)
+#define SET_TX_DESC_TAILPAGE_L_8822B(txdesc, value)                            \
+	SET_TX_DESC_TAILPAGE_L(txdesc, value)
+#define GET_TX_DESC_TAILPAGE_L_8822B(txdesc) GET_TX_DESC_TAILPAGE_L(txdesc)
+#define SET_TX_DESC_SDIO_DMASEQ_8822B(txdesc, value)                           \
+	SET_TX_DESC_SDIO_DMASEQ(txdesc, value)
+#define GET_TX_DESC_SDIO_DMASEQ_8822B(txdesc) GET_TX_DESC_SDIO_DMASEQ(txdesc)
+#define SET_TX_DESC_NEXTHEADPAGE_L_8822B(txdesc, value)                        \
+	SET_TX_DESC_NEXTHEADPAGE_L(txdesc, value)
+#define GET_TX_DESC_NEXTHEADPAGE_L_8822B(txdesc)                               \
+	GET_TX_DESC_NEXTHEADPAGE_L(txdesc)
+#define SET_TX_DESC_EN_HWSEQ_8822B(txdesc, value)                              \
+	SET_TX_DESC_EN_HWSEQ(txdesc, value)
+#define GET_TX_DESC_EN_HWSEQ_8822B(txdesc) GET_TX_DESC_EN_HWSEQ(txdesc)
+#define SET_TX_DESC_EN_HWEXSEQ_8822B(txdesc, value)                            \
+	SET_TX_DESC_EN_HWEXSEQ(txdesc, value)
+#define GET_TX_DESC_EN_HWEXSEQ_8822B(txdesc) GET_TX_DESC_EN_HWEXSEQ(txdesc)
+#define SET_TX_DESC_DATA_RC_8822B(txdesc, value)                               \
+	SET_TX_DESC_DATA_RC(txdesc, value)
+#define GET_TX_DESC_DATA_RC_8822B(txdesc) GET_TX_DESC_DATA_RC(txdesc)
+#define SET_TX_DESC_BAR_RTY_TH_8822B(txdesc, value)                            \
+	SET_TX_DESC_BAR_RTY_TH(txdesc, value)
+#define GET_TX_DESC_BAR_RTY_TH_8822B(txdesc) GET_TX_DESC_BAR_RTY_TH(txdesc)
+#define SET_TX_DESC_RTS_RC_8822B(txdesc, value)                                \
+	SET_TX_DESC_RTS_RC(txdesc, value)
+#define GET_TX_DESC_RTS_RC_8822B(txdesc) GET_TX_DESC_RTS_RC(txdesc)
+
+/*TXDESC_WORD9*/
+
+#define SET_TX_DESC_TAILPAGE_H_8822B(txdesc, value)                            \
+	SET_TX_DESC_TAILPAGE_H(txdesc, value)
+#define GET_TX_DESC_TAILPAGE_H_8822B(txdesc) GET_TX_DESC_TAILPAGE_H(txdesc)
+#define SET_TX_DESC_NEXTHEADPAGE_H_8822B(txdesc, value)                        \
+	SET_TX_DESC_NEXTHEADPAGE_H(txdesc, value)
+#define GET_TX_DESC_NEXTHEADPAGE_H_8822B(txdesc)                               \
+	GET_TX_DESC_NEXTHEADPAGE_H(txdesc)
+#define SET_TX_DESC_SW_SEQ_8822B(txdesc, value)                                \
+	SET_TX_DESC_SW_SEQ(txdesc, value)
+#define GET_TX_DESC_SW_SEQ_8822B(txdesc) GET_TX_DESC_SW_SEQ(txdesc)
+#define SET_TX_DESC_TXBF_PATH_8822B(txdesc, value)                             \
+	SET_TX_DESC_TXBF_PATH(txdesc, value)
+#define GET_TX_DESC_TXBF_PATH_8822B(txdesc) GET_TX_DESC_TXBF_PATH(txdesc)
+#define SET_TX_DESC_PADDING_LEN_8822B(txdesc, value)                           \
+	SET_TX_DESC_PADDING_LEN(txdesc, value)
+#define GET_TX_DESC_PADDING_LEN_8822B(txdesc) GET_TX_DESC_PADDING_LEN(txdesc)
+#define SET_TX_DESC_GROUP_BIT_IE_OFFSET_8822B(txdesc, value)                   \
+	SET_TX_DESC_GROUP_BIT_IE_OFFSET(txdesc, value)
+#define GET_TX_DESC_GROUP_BIT_IE_OFFSET_8822B(txdesc)                          \
+	GET_TX_DESC_GROUP_BIT_IE_OFFSET(txdesc)
+
+/*WORD10*/
+
+#define SET_TX_DESC_MU_DATARATE_8822B(txdesc, value)                           \
+	SET_TX_DESC_MU_DATARATE(txdesc, value)
+#define GET_TX_DESC_MU_DATARATE_8822B(txdesc) GET_TX_DESC_MU_DATARATE(txdesc)
+#define SET_TX_DESC_MU_RC_8822B(txdesc, value) SET_TX_DESC_MU_RC(txdesc, value)
+#define GET_TX_DESC_MU_RC_8822B(txdesc) GET_TX_DESC_MU_RC(txdesc)
+#define SET_TX_DESC_SND_PKT_SEL_8822B(txdesc, value)                           \
+	SET_TX_DESC_SND_PKT_SEL(txdesc, value)
+#define GET_TX_DESC_SND_PKT_SEL_8822B(txdesc) GET_TX_DESC_SND_PKT_SEL(txdesc)
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_tx_desc_nic.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_tx_desc_nic.h
new file mode 100644
index 000000000000..2fa2381730df
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_tx_desc_nic.h
@@ -0,0 +1,439 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#ifndef _HALMAC_TX_DESC_NIC_H_
+#define _HALMAC_TX_DESC_NIC_H_
+
+/*TXDESC_WORD0*/
+
+#define SET_TX_DESC_DISQSELSEQ(txdesc, value)                                  \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x00, 31, 1, value)
+#define GET_TX_DESC_DISQSELSEQ(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x00, 31, 1)
+
+#define SET_TX_DESC_GF(txdesc, value)                                          \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x00, 30, 1, value)
+#define GET_TX_DESC_GF(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x00, 30, 1)
+
+#define SET_TX_DESC_NO_ACM(txdesc, value)                                      \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x00, 29, 1, value)
+#define GET_TX_DESC_NO_ACM(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x00, 29, 1)
+
+#define SET_TX_DESC_BCNPKT_TSF_CTRL(txdesc, value)                             \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x00, 28, 1, value)
+#define GET_TX_DESC_BCNPKT_TSF_CTRL(txdesc)                                    \
+	LE_BITS_TO_4BYTE(txdesc + 0x00, 28, 1)
+
+#define SET_TX_DESC_AMSDU_PAD_EN(txdesc, value)                                \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x00, 27, 1, value)
+#define GET_TX_DESC_AMSDU_PAD_EN(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x00, 27, 1)
+#define SET_TX_DESC_LS(txdesc, value)                                          \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x00, 26, 1, value)
+#define GET_TX_DESC_LS(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x00, 26, 1)
+#define SET_TX_DESC_HTC(txdesc, value)                                         \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x00, 25, 1, value)
+#define GET_TX_DESC_HTC(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x00, 25, 1)
+#define SET_TX_DESC_BMC(txdesc, value)                                         \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x00, 24, 1, value)
+#define GET_TX_DESC_BMC(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x00, 24, 1)
+
+#define SET_TX_DESC_OFFSET(txdesc, value)                                      \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x00, 16, 8, value)
+#define GET_TX_DESC_OFFSET(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x00, 16, 8)
+#define SET_TX_DESC_TXPKTSIZE(txdesc, value)                                   \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x00, 0, 16, value)
+#define GET_TX_DESC_TXPKTSIZE(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x00, 0, 16)
+
+#define SET_TX_DESC_MOREDATA(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x04, 29, 1, value)
+#define GET_TX_DESC_MOREDATA(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x04, 29, 1)
+
+#define SET_TX_DESC_PKT_OFFSET(txdesc, value)                                  \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x04, 24, 5, value)
+#define GET_TX_DESC_PKT_OFFSET(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x04, 24, 5)
+
+#define SET_TX_DESC_SEC_TYPE(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x04, 22, 2, value)
+#define GET_TX_DESC_SEC_TYPE(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x04, 22, 2)
+#define SET_TX_DESC_EN_DESC_ID(txdesc, value)                                  \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x04, 21, 1, value)
+#define GET_TX_DESC_EN_DESC_ID(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x04, 21, 1)
+#define SET_TX_DESC_RATE_ID(txdesc, value)                                     \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x04, 16, 5, value)
+#define GET_TX_DESC_RATE_ID(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x04, 16, 5)
+
+#define SET_TX_DESC_PIFS(txdesc, value)                                        \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x04, 15, 1, value)
+#define GET_TX_DESC_PIFS(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x04, 15, 1)
+#define SET_TX_DESC_LSIG_TXOP_EN(txdesc, value)                                \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x04, 14, 1, value)
+#define GET_TX_DESC_LSIG_TXOP_EN(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x04, 14, 1)
+#define SET_TX_DESC_RD_NAV_EXT(txdesc, value)                                  \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x04, 13, 1, value)
+#define GET_TX_DESC_RD_NAV_EXT(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x04, 13, 1)
+
+#define SET_TX_DESC_QSEL(txdesc, value)                                        \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x04, 8, 5, value)
+#define GET_TX_DESC_QSEL(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x04, 8, 5)
+
+#define SET_TX_DESC_MACID(txdesc, value)                                       \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x04, 0, 7, value)
+#define GET_TX_DESC_MACID(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x04, 0, 7)
+
+/*TXDESC_WORD2*/
+
+#define SET_TX_DESC_HW_AES_IV(txdesc, value)                                   \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x08, 31, 1, value)
+#define GET_TX_DESC_HW_AES_IV(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x08, 31, 1)
+
+#define SET_TX_DESC_FTM_EN(txdesc, value)                                      \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x08, 30, 1, value)
+#define GET_TX_DESC_FTM_EN(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x08, 30, 1)
+
+#define SET_TX_DESC_G_ID(txdesc, value)                                        \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x08, 24, 6, value)
+#define GET_TX_DESC_G_ID(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x08, 24, 6)
+
+#define SET_TX_DESC_BT_NULL(txdesc, value)                                     \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x08, 23, 1, value)
+#define GET_TX_DESC_BT_NULL(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x08, 23, 1)
+#define SET_TX_DESC_AMPDU_DENSITY(txdesc, value)                               \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x08, 20, 3, value)
+#define GET_TX_DESC_AMPDU_DENSITY(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x08, 20, 3)
+#define SET_TX_DESC_SPE_RPT(txdesc, value)                                     \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x08, 19, 1, value)
+#define GET_TX_DESC_SPE_RPT(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x08, 19, 1)
+#define SET_TX_DESC_RAW(txdesc, value)                                         \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x08, 18, 1, value)
+#define GET_TX_DESC_RAW(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x08, 18, 1)
+#define SET_TX_DESC_MOREFRAG(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x08, 17, 1, value)
+#define GET_TX_DESC_MOREFRAG(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x08, 17, 1)
+#define SET_TX_DESC_BK(txdesc, value)                                          \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x08, 16, 1, value)
+#define GET_TX_DESC_BK(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x08, 16, 1)
+
+#define SET_TX_DESC_NULL_1(txdesc, value)                                      \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x08, 15, 1, value)
+#define GET_TX_DESC_NULL_1(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x08, 15, 1)
+#define SET_TX_DESC_NULL_0(txdesc, value)                                      \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x08, 14, 1, value)
+#define GET_TX_DESC_NULL_0(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x08, 14, 1)
+#define SET_TX_DESC_RDG_EN(txdesc, value)                                      \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x08, 13, 1, value)
+#define GET_TX_DESC_RDG_EN(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x08, 13, 1)
+#define SET_TX_DESC_AGG_EN(txdesc, value)                                      \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x08, 12, 1, value)
+#define GET_TX_DESC_AGG_EN(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x08, 12, 1)
+#define SET_TX_DESC_CCA_RTS(txdesc, value)                                     \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x08, 10, 2, value)
+#define GET_TX_DESC_CCA_RTS(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x08, 10, 2)
+
+#define SET_TX_DESC_TRI_FRAME(txdesc, value)                                   \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x08, 9, 1, value)
+#define GET_TX_DESC_TRI_FRAME(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x08, 9, 1)
+
+#define SET_TX_DESC_P_AID(txdesc, value)                                       \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x08, 0, 9, value)
+#define GET_TX_DESC_P_AID(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x08, 0, 9)
+
+/*TXDESC_WORD3*/
+
+#define SET_TX_DESC_AMPDU_MAX_TIME(txdesc, value)                              \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x0C, 24, 8, value)
+#define GET_TX_DESC_AMPDU_MAX_TIME(txdesc)                                     \
+	LE_BITS_TO_4BYTE(txdesc + 0x0C, 24, 8)
+#define SET_TX_DESC_NDPA(txdesc, value)                                        \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x0C, 22, 2, value)
+#define GET_TX_DESC_NDPA(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x0C, 22, 2)
+#define SET_TX_DESC_MAX_AGG_NUM(txdesc, value)                                 \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x0C, 17, 5, value)
+#define GET_TX_DESC_MAX_AGG_NUM(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x0C, 17, 5)
+#define SET_TX_DESC_USE_MAX_TIME_EN(txdesc, value)                             \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x0C, 16, 1, value)
+#define GET_TX_DESC_USE_MAX_TIME_EN(txdesc)                                    \
+	LE_BITS_TO_4BYTE(txdesc + 0x0C, 16, 1)
+
+#define SET_TX_DESC_NAVUSEHDR(txdesc, value)                                   \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x0C, 15, 1, value)
+#define GET_TX_DESC_NAVUSEHDR(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x0C, 15, 1)
+#define SET_TX_DESC_CHK_EN(txdesc, value)                                      \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x0C, 14, 1, value)
+#define GET_TX_DESC_CHK_EN(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x0C, 14, 1)
+#define SET_TX_DESC_HW_RTS_EN(txdesc, value)                                   \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x0C, 13, 1, value)
+#define GET_TX_DESC_HW_RTS_EN(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x0C, 13, 1)
+#define SET_TX_DESC_RTSEN(txdesc, value)                                       \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x0C, 12, 1, value)
+#define GET_TX_DESC_RTSEN(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x0C, 12, 1)
+#define SET_TX_DESC_CTS2SELF(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x0C, 11, 1, value)
+#define GET_TX_DESC_CTS2SELF(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x0C, 11, 1)
+
+#define SET_TX_DESC_DISDATAFB(txdesc, value)                                   \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x0C, 10, 1, value)
+#define GET_TX_DESC_DISDATAFB(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x0C, 10, 1)
+#define SET_TX_DESC_DISRTSFB(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x0C, 9, 1, value)
+#define GET_TX_DESC_DISRTSFB(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x0C, 9, 1)
+#define SET_TX_DESC_USE_RATE(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x0C, 8, 1, value)
+#define GET_TX_DESC_USE_RATE(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x0C, 8, 1)
+#define SET_TX_DESC_HW_SSN_SEL(txdesc, value)                                  \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x0C, 6, 2, value)
+#define GET_TX_DESC_HW_SSN_SEL(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x0C, 6, 2)
+
+#define SET_TX_DESC_WHEADER_LEN(txdesc, value)                                 \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x0C, 0, 5, value)
+#define GET_TX_DESC_WHEADER_LEN(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x0C, 0, 5)
+
+/*TXDESC_WORD4*/
+
+#define SET_TX_DESC_PCTS_MASK_IDX(txdesc, value)                               \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x10, 30, 2, value)
+#define GET_TX_DESC_PCTS_MASK_IDX(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x10, 30, 2)
+#define SET_TX_DESC_PCTS_EN(txdesc, value)                                     \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x10, 29, 1, value)
+#define GET_TX_DESC_PCTS_EN(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x10, 29, 1)
+#define SET_TX_DESC_RTSRATE(txdesc, value)                                     \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x10, 24, 5, value)
+#define GET_TX_DESC_RTSRATE(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x10, 24, 5)
+#define SET_TX_DESC_RTS_DATA_RTY_LMT(txdesc, value)                            \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x10, 18, 6, value)
+#define GET_TX_DESC_RTS_DATA_RTY_LMT(txdesc)                                   \
+	LE_BITS_TO_4BYTE(txdesc + 0x10, 18, 6)
+#define SET_TX_DESC_RTY_LMT_EN(txdesc, value)                                  \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x10, 17, 1, value)
+#define GET_TX_DESC_RTY_LMT_EN(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x10, 17, 1)
+#define SET_TX_DESC_RTS_RTY_LOWEST_RATE(txdesc, value)                         \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x10, 13, 4, value)
+#define GET_TX_DESC_RTS_RTY_LOWEST_RATE(txdesc)                                \
+	LE_BITS_TO_4BYTE(txdesc + 0x10, 13, 4)
+#define SET_TX_DESC_DATA_RTY_LOWEST_RATE(txdesc, value)                        \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x10, 8, 5, value)
+#define GET_TX_DESC_DATA_RTY_LOWEST_RATE(txdesc)                               \
+	LE_BITS_TO_4BYTE(txdesc + 0x10, 8, 5)
+#define SET_TX_DESC_TRY_RATE(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x10, 7, 1, value)
+#define GET_TX_DESC_TRY_RATE(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x10, 7, 1)
+#define SET_TX_DESC_DATARATE(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x10, 0, 7, value)
+#define GET_TX_DESC_DATARATE(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x10, 0, 7)
+
+/*TXDESC_WORD5*/
+
+#define SET_TX_DESC_POLLUTED(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x14, 31, 1, value)
+#define GET_TX_DESC_POLLUTED(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x14, 31, 1)
+
+#define SET_TX_DESC_TXPWR_OFSET(txdesc, value)                                 \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x14, 28, 3, value)
+#define GET_TX_DESC_TXPWR_OFSET(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x14, 28, 3)
+
+#define SET_TX_DESC_TX_ANT(txdesc, value)                                      \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x14, 24, 4, value)
+#define GET_TX_DESC_TX_ANT(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x14, 24, 4)
+
+#define SET_TX_DESC_PORT_ID(txdesc, value)                                     \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x14, 21, 3, value)
+#define GET_TX_DESC_PORT_ID(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x14, 21, 3)
+
+#define SET_TX_DESC_MULTIPLE_PORT(txdesc, value)                               \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x14, 18, 3, value)
+#define GET_TX_DESC_MULTIPLE_PORT(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x14, 18, 3)
+
+#define SET_TX_DESC_SIGNALING_TAPKT_EN(txdesc, value)                          \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x14, 17, 1, value)
+#define GET_TX_DESC_SIGNALING_TAPKT_EN(txdesc)                                 \
+	LE_BITS_TO_4BYTE(txdesc + 0x14, 17, 1)
+
+#define SET_TX_DESC_SIGNALING_TA_PKT_SC(txdesc, value)                         \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x14, 13, 4, value)
+#define GET_TX_DESC_SIGNALING_TA_PKT_SC(txdesc)                                \
+	LE_BITS_TO_4BYTE(txdesc + 0x14, 13, 4)
+
+#define SET_TX_DESC_RTS_SHORT(txdesc, value)                                   \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x14, 12, 1, value)
+#define GET_TX_DESC_RTS_SHORT(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x14, 12, 1)
+#define SET_TX_DESC_VCS_STBC(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x14, 10, 2, value)
+#define GET_TX_DESC_VCS_STBC(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x14, 10, 2)
+#define SET_TX_DESC_DATA_STBC(txdesc, value)                                   \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x14, 8, 2, value)
+#define GET_TX_DESC_DATA_STBC(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x14, 8, 2)
+#define SET_TX_DESC_DATA_LDPC(txdesc, value)                                   \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x14, 7, 1, value)
+#define GET_TX_DESC_DATA_LDPC(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x14, 7, 1)
+#define SET_TX_DESC_DATA_BW(txdesc, value)                                     \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x14, 5, 2, value)
+#define GET_TX_DESC_DATA_BW(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x14, 5, 2)
+#define SET_TX_DESC_DATA_SHORT(txdesc, value)                                  \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x14, 4, 1, value)
+#define GET_TX_DESC_DATA_SHORT(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x14, 4, 1)
+#define SET_TX_DESC_DATA_SC(txdesc, value)                                     \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x14, 0, 4, value)
+#define GET_TX_DESC_DATA_SC(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x14, 0, 4)
+
+/*TXDESC_WORD6*/
+
+#define SET_TX_DESC_ANTSEL_D(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x18, 30, 2, value)
+#define GET_TX_DESC_ANTSEL_D(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x18, 30, 2)
+
+#define SET_TX_DESC_ANT_MAPD(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x18, 28, 2, value)
+#define GET_TX_DESC_ANT_MAPD(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x18, 28, 2)
+
+#define SET_TX_DESC_ANT_MAPC(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x18, 26, 2, value)
+#define GET_TX_DESC_ANT_MAPC(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x18, 26, 2)
+
+#define SET_TX_DESC_ANT_MAPB(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x18, 24, 2, value)
+#define GET_TX_DESC_ANT_MAPB(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x18, 24, 2)
+
+#define SET_TX_DESC_ANT_MAPA(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x18, 22, 2, value)
+#define GET_TX_DESC_ANT_MAPA(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x18, 22, 2)
+#define SET_TX_DESC_ANTSEL_C(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x18, 20, 2, value)
+#define GET_TX_DESC_ANTSEL_C(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x18, 20, 2)
+
+#define SET_TX_DESC_ANTSEL_B(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x18, 18, 2, value)
+#define GET_TX_DESC_ANTSEL_B(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x18, 18, 2)
+#define SET_TX_DESC_ANTSEL_A(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x18, 16, 2, value)
+#define GET_TX_DESC_ANTSEL_A(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x18, 16, 2)
+
+#define SET_TX_DESC_MBSSID(txdesc, value)                                      \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x18, 12, 4, value)
+#define GET_TX_DESC_MBSSID(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x18, 12, 4)
+
+#define SET_TX_DESC_SW_DEFINE(txdesc, value)                                   \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x18, 0, 12, value)
+#define GET_TX_DESC_SW_DEFINE(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x18, 0, 12)
+
+/*TXDESC_WORD7*/
+
+#define SET_TX_DESC_DMA_TXAGG_NUM(txdesc, value)                               \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x1C, 24, 8, value)
+#define GET_TX_DESC_DMA_TXAGG_NUM(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x1C, 24, 8)
+#define SET_TX_DESC_FINAL_DATA_RATE(txdesc, value)                             \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x1C, 24, 8, value)
+#define GET_TX_DESC_FINAL_DATA_RATE(txdesc)                                    \
+	LE_BITS_TO_4BYTE(txdesc + 0x1C, 24, 8)
+#define SET_TX_DESC_NTX_MAP(txdesc, value)                                     \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x1C, 20, 4, value)
+#define GET_TX_DESC_NTX_MAP(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x1C, 20, 4)
+
+#define SET_TX_DESC_TX_BUFF_SIZE(txdesc, value)                                \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x1C, 0, 16, value)
+#define GET_TX_DESC_TX_BUFF_SIZE(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x1C, 0, 16)
+#define SET_TX_DESC_TXDESC_CHECKSUM(txdesc, value)                             \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x1C, 0, 16, value)
+#define GET_TX_DESC_TXDESC_CHECKSUM(txdesc)                                    \
+	LE_BITS_TO_4BYTE(txdesc + 0x1C, 0, 16)
+#define SET_TX_DESC_TIMESTAMP(txdesc, value)                                   \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x1C, 0, 16, value)
+#define GET_TX_DESC_TIMESTAMP(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x1C, 0, 16)
+
+/*TXDESC_WORD8*/
+
+#define SET_TX_DESC_TXWIFI_CP(txdesc, value)                                   \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x20, 31, 1, value)
+#define GET_TX_DESC_TXWIFI_CP(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x20, 31, 1)
+#define SET_TX_DESC_MAC_CP(txdesc, value)                                      \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x20, 30, 1, value)
+#define GET_TX_DESC_MAC_CP(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x20, 30, 1)
+#define SET_TX_DESC_STW_PKTRE_DIS(txdesc, value)                               \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x20, 29, 1, value)
+#define GET_TX_DESC_STW_PKTRE_DIS(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x20, 29, 1)
+#define SET_TX_DESC_STW_RB_DIS(txdesc, value)                                  \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x20, 28, 1, value)
+#define GET_TX_DESC_STW_RB_DIS(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x20, 28, 1)
+#define SET_TX_DESC_STW_RATE_DIS(txdesc, value)                                \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x20, 27, 1, value)
+#define GET_TX_DESC_STW_RATE_DIS(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x20, 27, 1)
+#define SET_TX_DESC_STW_ANT_DIS(txdesc, value)                                 \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x20, 26, 1, value)
+#define GET_TX_DESC_STW_ANT_DIS(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x20, 26, 1)
+#define SET_TX_DESC_STW_EN(txdesc, value)                                      \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x20, 25, 1, value)
+#define GET_TX_DESC_STW_EN(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x20, 25, 1)
+#define SET_TX_DESC_SMH_EN(txdesc, value)                                      \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x20, 24, 1, value)
+#define GET_TX_DESC_SMH_EN(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x20, 24, 1)
+#define SET_TX_DESC_TAILPAGE_L(txdesc, value)                                  \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x20, 24, 8, value)
+#define GET_TX_DESC_TAILPAGE_L(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x20, 24, 8)
+#define SET_TX_DESC_SDIO_DMASEQ(txdesc, value)                                 \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x20, 16, 8, value)
+#define GET_TX_DESC_SDIO_DMASEQ(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x20, 16, 8)
+#define SET_TX_DESC_NEXTHEADPAGE_L(txdesc, value)                              \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x20, 16, 8, value)
+#define GET_TX_DESC_NEXTHEADPAGE_L(txdesc)                                     \
+	LE_BITS_TO_4BYTE(txdesc + 0x20, 16, 8)
+#define SET_TX_DESC_EN_HWSEQ(txdesc, value)                                    \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x20, 15, 1, value)
+#define GET_TX_DESC_EN_HWSEQ(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x20, 15, 1)
+#define SET_TX_DESC_EN_HWEXSEQ(txdesc, value)                                  \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x20, 14, 1, value)
+#define GET_TX_DESC_EN_HWEXSEQ(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x20, 14, 1)
+#define SET_TX_DESC_DATA_RC(txdesc, value)                                     \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x20, 8, 6, value)
+#define GET_TX_DESC_DATA_RC(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x20, 8, 6)
+#define SET_TX_DESC_BAR_RTY_TH(txdesc, value)                                  \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x20, 6, 2, value)
+#define GET_TX_DESC_BAR_RTY_TH(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x20, 6, 2)
+#define SET_TX_DESC_RTS_RC(txdesc, value)                                      \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x20, 0, 6, value)
+#define GET_TX_DESC_RTS_RC(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x20, 0, 6)
+
+/*TXDESC_WORD9*/
+
+#define SET_TX_DESC_TAILPAGE_H(txdesc, value)                                  \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x24, 28, 4, value)
+#define GET_TX_DESC_TAILPAGE_H(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x24, 28, 4)
+#define SET_TX_DESC_NEXTHEADPAGE_H(txdesc, value)                              \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x24, 24, 4, value)
+#define GET_TX_DESC_NEXTHEADPAGE_H(txdesc)                                     \
+	LE_BITS_TO_4BYTE(txdesc + 0x24, 24, 4)
+#define SET_TX_DESC_SW_SEQ(txdesc, value)                                      \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x24, 12, 12, value)
+#define GET_TX_DESC_SW_SEQ(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x24, 12, 12)
+#define SET_TX_DESC_TXBF_PATH(txdesc, value)                                   \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x24, 11, 1, value)
+#define GET_TX_DESC_TXBF_PATH(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x24, 11, 1)
+#define SET_TX_DESC_PADDING_LEN(txdesc, value)                                 \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x24, 0, 11, value)
+#define GET_TX_DESC_PADDING_LEN(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x24, 0, 11)
+#define SET_TX_DESC_GROUP_BIT_IE_OFFSET(txdesc, value)                         \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x24, 0, 8, value)
+#define GET_TX_DESC_GROUP_BIT_IE_OFFSET(txdesc)                                \
+	LE_BITS_TO_4BYTE(txdesc + 0x24, 0, 8)
+
+/*WORD10*/
+
+#define SET_TX_DESC_MU_DATARATE(txdesc, value)                                 \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x28, 8, 8, value)
+#define GET_TX_DESC_MU_DATARATE(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x28, 8, 8)
+#define SET_TX_DESC_MU_RC(txdesc, value)                                       \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x28, 4, 4, value)
+#define GET_TX_DESC_MU_RC(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x28, 4, 4)
+#define SET_TX_DESC_SND_PKT_SEL(txdesc, value)                                 \
+	SET_BITS_TO_LE_4BYTE(txdesc + 0x28, 0, 2, value)
+#define GET_TX_DESC_SND_PKT_SEL(txdesc) LE_BITS_TO_4BYTE(txdesc + 0x28, 0, 2)
+
+#endif
-- 
2.15.1
