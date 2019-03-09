Return-Path: <SRS0=krUy=RM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D047BC43381
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 13:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26DD5207E0
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 13:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfCINt2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Mar 2019 08:49:28 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:40706 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfCINt1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Mar 2019 08:49:27 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x29DmnJ8020452, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x29DmnJ8020452
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Sat, 9 Mar 2019 21:48:49 +0800
Received: from localhost.localdomain (1.168.42.219) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Sat, 9 Mar 2019 21:48:48 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>, <johannes@sipsolutions.net>,
        <gregkh@linuxfoundation.org>
CC:     <linux-wireless@vger.kernel.org>, <Larry.Finger@lwfinger.net>,
        <sgruszka@redhat.com>, <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>
Subject: [PATCH v7 09/14] rtw88: chip files
Date:   Sat, 9 Mar 2019 21:48:17 +0800
Message-ID: <1552139302-20476-10-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1552139302-20476-1-git-send-email-yhchuang@realtek.com>
References: <1552139302-20476-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [1.168.42.219]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

chip files Realtek 802.11ac wireless network chips
8822B & 8822C series files

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      | 1594 +++++++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw8822b.h      |  170 ++
 .../net/wireless/realtek/rtw88/rtw8822b_table.h    |   18 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      | 1890 ++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |  186 ++
 .../net/wireless/realtek/rtw88/rtw8822c_table.h    |   17 +
 6 files changed, 3875 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822b_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822c_table.h

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
new file mode 100644
index 0000000..7432c37
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -0,0 +1,1594 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#include "main.h"
+#include "fw.h"
+#include "tx.h"
+#include "rx.h"
+#include "phy.h"
+#include "rtw8822b.h"
+#include "rtw8822b_table.h"
+#include "mac.h"
+#include "reg.h"
+#include "debug.h"
+
+static void rtw8822b_config_trx_mode(struct rtw_dev *rtwdev, u8 tx_path,
+				     u8 rx_path, bool is_tx2_path);
+
+static void rtw8822be_efuse_parsing(struct rtw_efuse *efuse,
+				    struct rtw8822b_efuse *map)
+{
+	ether_addr_copy(efuse->addr, map->e.mac_addr);
+}
+
+static int rtw8822b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
+{
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	struct rtw8822b_efuse *map;
+	int i;
+
+	map = (struct rtw8822b_efuse *)log_map;
+
+	efuse->rfe_option = map->rfe_option;
+	efuse->crystal_cap = map->xtal_k;
+	efuse->pa_type_2g = map->pa_type;
+	efuse->pa_type_5g = map->pa_type;
+	efuse->lna_type_2g = map->lna_type_2g[0];
+	efuse->lna_type_5g = map->lna_type_5g[0];
+	efuse->channel_plan = map->channel_plan;
+	efuse->country_code[0] = map->country_code[0];
+	efuse->country_code[1] = map->country_code[1];
+	efuse->bt_setting = map->rf_bt_setting;
+	efuse->regd = map->rf_board_option & 0x7;
+
+	for (i = 0; i < 4; i++)
+		efuse->txpwr_idx_table[i] = map->txpwr_idx_table[i];
+
+	switch (rtw_hci_type(rtwdev)) {
+	case RTW_HCI_TYPE_PCIE:
+		rtw8822be_efuse_parsing(efuse, map);
+		break;
+	default:
+		/* unsupported now */
+		return -ENOTSUPP;
+	}
+
+	return 0;
+}
+
+static void rtw8822b_phy_rfe_init(struct rtw_dev *rtwdev)
+{
+	/* chip top mux */
+	rtw_write32_mask(rtwdev, 0x64, BIT(29) | BIT(28), 0x3);
+	rtw_write32_mask(rtwdev, 0x4c, BIT(26) | BIT(25), 0x0);
+	rtw_write32_mask(rtwdev, 0x40, BIT(2), 0x1);
+
+	/* from s0 or s1 */
+	rtw_write32_mask(rtwdev, 0x1990, 0x3f, 0x30);
+	rtw_write32_mask(rtwdev, 0x1990, (BIT(11) | BIT(10)), 0x3);
+
+	/* input or output */
+	rtw_write32_mask(rtwdev, 0x974, 0x3f, 0x3f);
+	rtw_write32_mask(rtwdev, 0x974, (BIT(11) | BIT(10)), 0x3);
+}
+
+static void rtw8822b_phy_set_param(struct rtw_dev *rtwdev)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	u8 crystal_cap;
+	bool is_tx2_path;
+
+	/* power on BB/RF domain */
+	rtw_write8_set(rtwdev, REG_SYS_FUNC_EN,
+		       BIT_FEN_BB_RSTB | BIT_FEN_BB_GLB_RST);
+	rtw_write8_set(rtwdev, REG_RF_CTRL,
+		       BIT_RF_EN | BIT_RF_RSTB | BIT_RF_SDM_RSTB);
+	rtw_write32_set(rtwdev, REG_WLRF1, BIT_WLRF1_BBRF_EN);
+
+	/* pre init before header files config */
+	rtw_write32_clr(rtwdev, REG_RXPSEL, BIT_RX_PSEL_RST);
+
+	rtw_phy_load_tables(rtwdev);
+
+	crystal_cap = rtwdev->efuse.crystal_cap & 0x3F;
+	rtw_write32_mask(rtwdev, 0x24, 0x7e000000, crystal_cap);
+	rtw_write32_mask(rtwdev, 0x28, 0x7e, crystal_cap);
+
+	/* post init after header files config */
+	rtw_write32_set(rtwdev, REG_RXPSEL, BIT_RX_PSEL_RST);
+
+	is_tx2_path = false;
+	rtw8822b_config_trx_mode(rtwdev, hal->antenna_tx, hal->antenna_rx,
+				 is_tx2_path);
+	rtw_phy_init(rtwdev);
+
+	rtw8822b_phy_rfe_init(rtwdev);
+
+	/* wifi path controller */
+	rtw_write32_mask(rtwdev, 0x70, 0x4000000, 1);
+	/* BB control */
+	rtw_write32_mask(rtwdev, 0x4c, 0x01800000, 0x2);
+	/* antenna mux switch */
+	rtw_write8(rtwdev, 0x974, 0xff);
+	rtw_write32_mask(rtwdev, 0x1990, 0x300, 0);
+	rtw_write32_mask(rtwdev, 0xcbc, 0x80000, 0x0);
+	/* SW control */
+	rtw_write8(rtwdev, 0xcb4, 0x77);
+	/* switch to WL side controller and gnt_wl gnt_bt debug signal */
+	rtw_write32_mask(rtwdev, 0x70, 0xff000000, 0x0e);
+	/* gnt_wl = 1, gnt_bt = 0 */
+	rtw_write32(rtwdev, 0x1704, 0x7700);
+	rtw_write32(rtwdev, 0x1700, 0xc00f0038);
+	/* switch for WL 2G */
+	rtw_write8(rtwdev, 0xcbd, 0x2);
+}
+
+#define WLAN_SLOT_TIME		0x09
+#define WLAN_PIFS_TIME		0x19
+#define WLAN_SIFS_CCK_CONT_TX	0xA
+#define WLAN_SIFS_OFDM_CONT_TX	0xE
+#define WLAN_SIFS_CCK_TRX	0x10
+#define WLAN_SIFS_OFDM_TRX	0x10
+#define WLAN_VO_TXOP_LIMIT	0x186 /* unit : 32us */
+#define WLAN_VI_TXOP_LIMIT	0x3BC /* unit : 32us */
+#define WLAN_RDG_NAV		0x05
+#define WLAN_TXOP_NAV		0x1B
+#define WLAN_CCK_RX_TSF		0x30
+#define WLAN_OFDM_RX_TSF	0x30
+#define WLAN_TBTT_PROHIBIT	0x04 /* unit : 32us */
+#define WLAN_TBTT_HOLD_TIME	0x064 /* unit : 32us */
+#define WLAN_DRV_EARLY_INT	0x04
+#define WLAN_BCN_DMA_TIME	0x02
+
+#define WLAN_RX_FILTER0		0x0FFFFFFF
+#define WLAN_RX_FILTER2		0xFFFF
+#define WLAN_RCR_CFG		0xE400220E
+#define WLAN_RXPKT_MAX_SZ	12288
+#define WLAN_RXPKT_MAX_SZ_512	(WLAN_RXPKT_MAX_SZ >> 9)
+
+#define WLAN_AMPDU_MAX_TIME		0x70
+#define WLAN_RTS_LEN_TH			0xFF
+#define WLAN_RTS_TX_TIME_TH		0x08
+#define WLAN_MAX_AGG_PKT_LIMIT		0x20
+#define WLAN_RTS_MAX_AGG_PKT_LIMIT	0x20
+#define FAST_EDCA_VO_TH		0x06
+#define FAST_EDCA_VI_TH		0x06
+#define FAST_EDCA_BE_TH		0x06
+#define FAST_EDCA_BK_TH		0x06
+#define WLAN_BAR_RETRY_LIMIT		0x01
+#define WLAN_RA_TRY_RATE_AGG_LIMIT	0x08
+
+#define WLAN_TX_FUNC_CFG1		0x30
+#define WLAN_TX_FUNC_CFG2		0x30
+#define WLAN_MAC_OPT_NORM_FUNC1		0x98
+#define WLAN_MAC_OPT_LB_FUNC1		0x80
+#define WLAN_MAC_OPT_FUNC2		0x30810041
+
+#define WLAN_SIFS_CFG	(WLAN_SIFS_CCK_CONT_TX | \
+			(WLAN_SIFS_OFDM_CONT_TX << BIT_SHIFT_SIFS_OFDM_CTX) | \
+			(WLAN_SIFS_CCK_TRX << BIT_SHIFT_SIFS_CCK_TRX) | \
+			(WLAN_SIFS_OFDM_TRX << BIT_SHIFT_SIFS_OFDM_TRX))
+
+#define WLAN_TBTT_TIME	(WLAN_TBTT_PROHIBIT |\
+			(WLAN_TBTT_HOLD_TIME << BIT_SHIFT_TBTT_HOLD_TIME_AP))
+
+#define WLAN_NAV_CFG		(WLAN_RDG_NAV | (WLAN_TXOP_NAV << 16))
+#define WLAN_RX_TSF_CFG		(WLAN_CCK_RX_TSF | (WLAN_OFDM_RX_TSF) << 8)
+
+static int rtw8822b_mac_init(struct rtw_dev *rtwdev)
+{
+	u32 value32;
+
+	/* protocol configuration */
+	rtw_write8_clr(rtwdev, REG_SW_AMPDU_BURST_MODE_CTRL, BIT_PRE_TX_CMD);
+	rtw_write8(rtwdev, REG_AMPDU_MAX_TIME_V1, WLAN_AMPDU_MAX_TIME);
+	rtw_write8_set(rtwdev, REG_TX_HANG_CTRL, BIT_EN_EOF_V1);
+	value32 = WLAN_RTS_LEN_TH | (WLAN_RTS_TX_TIME_TH << 8) |
+		  (WLAN_MAX_AGG_PKT_LIMIT << 16) |
+		  (WLAN_RTS_MAX_AGG_PKT_LIMIT << 24);
+	rtw_write32(rtwdev, REG_PROT_MODE_CTRL, value32);
+	rtw_write16(rtwdev, REG_BAR_MODE_CTRL + 2,
+		    WLAN_BAR_RETRY_LIMIT | WLAN_RA_TRY_RATE_AGG_LIMIT << 8);
+	rtw_write8(rtwdev, REG_FAST_EDCA_VOVI_SETTING, FAST_EDCA_VO_TH);
+	rtw_write8(rtwdev, REG_FAST_EDCA_VOVI_SETTING + 2, FAST_EDCA_VI_TH);
+	rtw_write8(rtwdev, REG_FAST_EDCA_BEBK_SETTING, FAST_EDCA_BE_TH);
+	rtw_write8(rtwdev, REG_FAST_EDCA_BEBK_SETTING + 2, FAST_EDCA_BK_TH);
+	/* EDCA configuration */
+	rtw_write8_clr(rtwdev, REG_TIMER0_SRC_SEL, BIT_TSFT_SEL_TIMER0);
+	rtw_write16(rtwdev, REG_TXPAUSE, 0x0000);
+	rtw_write8(rtwdev, REG_SLOT, WLAN_SLOT_TIME);
+	rtw_write8(rtwdev, REG_PIFS, WLAN_PIFS_TIME);
+	rtw_write32(rtwdev, REG_SIFS, WLAN_SIFS_CFG);
+	rtw_write16(rtwdev, REG_EDCA_VO_PARAM + 2, WLAN_VO_TXOP_LIMIT);
+	rtw_write16(rtwdev, REG_EDCA_VI_PARAM + 2, WLAN_VI_TXOP_LIMIT);
+	rtw_write32(rtwdev, REG_RD_NAV_NXT, WLAN_NAV_CFG);
+	rtw_write16(rtwdev, REG_RXTSF_OFFSET_CCK, WLAN_RX_TSF_CFG);
+	/* Set beacon cotnrol - enable TSF and other related functions */
+	rtw_write8_set(rtwdev, REG_BCN_CTRL, BIT_EN_BCN_FUNCTION);
+	/* Set send beacon related registers */
+	rtw_write32(rtwdev, REG_TBTT_PROHIBIT, WLAN_TBTT_TIME);
+	rtw_write8(rtwdev, REG_DRVERLYINT, WLAN_DRV_EARLY_INT);
+	rtw_write8(rtwdev, REG_BCNDMATIM, WLAN_BCN_DMA_TIME);
+	rtw_write8_clr(rtwdev, REG_TX_PTCL_CTRL + 1, BIT_SIFS_BK_EN >> 8);
+	/* WMAC configuration */
+	rtw_write32(rtwdev, REG_RXFLTMAP0, WLAN_RX_FILTER0);
+	rtw_write16(rtwdev, REG_RXFLTMAP2, WLAN_RX_FILTER2);
+	rtw_write32(rtwdev, REG_RCR, WLAN_RCR_CFG);
+	rtw_write8(rtwdev, REG_RX_PKT_LIMIT, WLAN_RXPKT_MAX_SZ_512);
+	rtw_write8(rtwdev, REG_TCR + 2, WLAN_TX_FUNC_CFG2);
+	rtw_write8(rtwdev, REG_TCR + 1, WLAN_TX_FUNC_CFG1);
+	rtw_write32(rtwdev, REG_WMAC_OPTION_FUNCTION + 8, WLAN_MAC_OPT_FUNC2);
+	rtw_write8(rtwdev, REG_WMAC_OPTION_FUNCTION + 4, WLAN_MAC_OPT_NORM_FUNC1);
+
+	return 0;
+}
+
+static void rtw8822b_set_channel_rfe_efem(struct rtw_dev *rtwdev, u8 channel)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	bool is_channel_2g = (channel <= 14) ? true : false;
+
+	if (is_channel_2g) {
+		rtw_write32s_mask(rtwdev, REG_RFESEL0, 0xffffff, 0x705770);
+		rtw_write32s_mask(rtwdev, REG_RFESEL8, MASKBYTE1, 0x57);
+		rtw_write32s_mask(rtwdev, REG_RFECTL, BIT(4), 0);
+	} else {
+		rtw_write32s_mask(rtwdev, REG_RFESEL0, 0xffffff, 0x177517);
+		rtw_write32s_mask(rtwdev, REG_RFESEL8, MASKBYTE1, 0x75);
+		rtw_write32s_mask(rtwdev, REG_RFECTL, BIT(5), 0);
+	}
+
+	rtw_write32s_mask(rtwdev, REG_RFEINV, BIT(11) | BIT(10) | 0x3f, 0x0);
+
+	if (hal->antenna_rx == BB_PATH_AB ||
+	    hal->antenna_tx == BB_PATH_AB) {
+		/* 2TX or 2RX */
+		rtw_write32s_mask(rtwdev, REG_TRSW, MASKLWORD, 0xa501);
+	} else if (hal->antenna_rx == hal->antenna_tx) {
+		/* TXA+RXA or TXB+RXB */
+		rtw_write32s_mask(rtwdev, REG_TRSW, MASKLWORD, 0xa500);
+	} else {
+		/* TXB+RXA or TXA+RXB */
+		rtw_write32s_mask(rtwdev, REG_TRSW, MASKLWORD, 0xa005);
+	}
+}
+
+static void rtw8822b_set_channel_rfe_ifem(struct rtw_dev *rtwdev, u8 channel)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	bool is_channel_2g = (channel <= 14) ? true : false;
+
+	if (is_channel_2g) {
+		/* signal source */
+		rtw_write32s_mask(rtwdev, REG_RFESEL0, 0xffffff, 0x745774);
+		rtw_write32s_mask(rtwdev, REG_RFESEL8, MASKBYTE1, 0x57);
+	} else {
+		/* signal source */
+		rtw_write32s_mask(rtwdev, REG_RFESEL0, 0xffffff, 0x477547);
+		rtw_write32s_mask(rtwdev, REG_RFESEL8, MASKBYTE1, 0x75);
+	}
+
+	rtw_write32s_mask(rtwdev, REG_RFEINV, BIT(11) | BIT(10) | 0x3f, 0x0);
+
+	if (is_channel_2g) {
+		if (hal->antenna_rx == BB_PATH_AB ||
+		    hal->antenna_tx == BB_PATH_AB) {
+			/* 2TX or 2RX */
+			rtw_write32s_mask(rtwdev, REG_TRSW, MASKLWORD, 0xa501);
+		} else if (hal->antenna_rx == hal->antenna_tx) {
+			/* TXA+RXA or TXB+RXB */
+			rtw_write32s_mask(rtwdev, REG_TRSW, MASKLWORD, 0xa500);
+		} else {
+			/* TXB+RXA or TXA+RXB */
+			rtw_write32s_mask(rtwdev, REG_TRSW, MASKLWORD, 0xa005);
+		}
+	} else {
+		rtw_write32s_mask(rtwdev, REG_TRSW, MASKLWORD, 0xa5a5);
+	}
+}
+
+enum {
+	CCUT_IDX_1R_2G,
+	CCUT_IDX_2R_2G,
+	CCUT_IDX_1R_5G,
+	CCUT_IDX_2R_5G,
+	CCUT_IDX_NR,
+};
+
+struct cca_ccut {
+	u32 reg82c[CCUT_IDX_NR];
+	u32 reg830[CCUT_IDX_NR];
+	u32 reg838[CCUT_IDX_NR];
+};
+
+static const struct cca_ccut cca_ifem_ccut = {
+	{0x75C97010, 0x75C97010, 0x75C97010, 0x75C97010}, /*Reg82C*/
+	{0x79a0eaaa, 0x79A0EAAC, 0x79a0eaaa, 0x79a0eaaa}, /*Reg830*/
+	{0x87765541, 0x87746341, 0x87765541, 0x87746341}, /*Reg838*/
+};
+
+static const struct cca_ccut cca_efem_ccut = {
+	{0x75B86010, 0x75B76010, 0x75B86010, 0x75B76010}, /*Reg82C*/
+	{0x79A0EAA8, 0x79A0EAAC, 0x79A0EAA8, 0x79a0eaaa}, /*Reg830*/
+	{0x87766451, 0x87766431, 0x87766451, 0x87766431}, /*Reg838*/
+};
+
+static const struct cca_ccut cca_ifem_ccut_ext = {
+	{0x75da8010, 0x75da8010, 0x75da8010, 0x75da8010}, /*Reg82C*/
+	{0x79a0eaaa, 0x97A0EAAC, 0x79a0eaaa, 0x79a0eaaa}, /*Reg830*/
+	{0x87765541, 0x86666341, 0x87765561, 0x86666361}, /*Reg838*/
+};
+
+static void rtw8822b_get_cca_val(const struct cca_ccut *cca_ccut, u8 col,
+				 u32 *reg82c, u32 *reg830, u32 *reg838)
+{
+	*reg82c = cca_ccut->reg82c[col];
+	*reg830 = cca_ccut->reg830[col];
+	*reg838 = cca_ccut->reg838[col];
+}
+
+struct rtw8822b_rfe_info {
+	const struct cca_ccut *cca_ccut_2g;
+	const struct cca_ccut *cca_ccut_5g;
+	enum rtw_rfe_fem fem;
+	bool ifem_ext;
+	void (*rtw_set_channel_rfe)(struct rtw_dev *rtwdev, u8 channel);
+};
+
+#define I2GE5G_CCUT(set_ch) {						\
+	.cca_ccut_2g = &cca_ifem_ccut,					\
+	.cca_ccut_5g = &cca_efem_ccut,					\
+	.fem = RTW_RFE_IFEM2G_EFEM5G,					\
+	.ifem_ext = false,						\
+	.rtw_set_channel_rfe = &rtw8822b_set_channel_rfe_ ## set_ch,	\
+	}
+#define IFEM_EXT_CCUT(set_ch) {						\
+	.cca_ccut_2g = &cca_ifem_ccut_ext,				\
+	.cca_ccut_5g = &cca_ifem_ccut_ext,				\
+	.fem = RTW_RFE_IFEM,						\
+	.ifem_ext = true,						\
+	.rtw_set_channel_rfe = &rtw8822b_set_channel_rfe_ ## set_ch,	\
+	}
+
+static const struct rtw8822b_rfe_info rtw8822b_rfe_info[] = {
+	[2] = I2GE5G_CCUT(efem),
+	[5] = IFEM_EXT_CCUT(ifem),
+};
+
+static void rtw8822b_set_channel_cca(struct rtw_dev *rtwdev, u8 channel, u8 bw,
+				     const struct rtw8822b_rfe_info *rfe_info)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	const struct cca_ccut *cca_ccut;
+	u8 col;
+	u32 reg82c, reg830, reg838;
+	bool is_efem_cca = false, is_ifem_cca = false, is_rfe_type = false;
+
+	if (channel <= 14) {
+		cca_ccut = rfe_info->cca_ccut_2g;
+
+		if (hal->antenna_rx == BB_PATH_A ||
+		    hal->antenna_rx == BB_PATH_B)
+			col = CCUT_IDX_1R_2G;
+		else
+			col = CCUT_IDX_2R_2G;
+	} else {
+		cca_ccut = rfe_info->cca_ccut_5g;
+
+		if (hal->antenna_rx == BB_PATH_A ||
+		    hal->antenna_rx == BB_PATH_B)
+			col = CCUT_IDX_1R_5G;
+		else
+			col = CCUT_IDX_2R_5G;
+	}
+
+	rtw8822b_get_cca_val(cca_ccut, col, &reg82c, &reg830, &reg838);
+
+	switch (rfe_info->fem) {
+	case RTW_RFE_IFEM:
+	default:
+		is_ifem_cca = true;
+		if (rfe_info->ifem_ext)
+			is_rfe_type = true;
+		break;
+	case RTW_RFE_EFEM:
+		is_efem_cca = true;
+		break;
+	case RTW_RFE_IFEM2G_EFEM5G:
+		if (channel <= 14)
+			is_ifem_cca = true;
+		else
+			is_efem_cca = true;
+		break;
+	}
+
+	if (is_ifem_cca) {
+		if ((hal->cut_version == RTW_CHIP_VER_CUT_B &&
+		     (col == CCUT_IDX_2R_2G || col == CCUT_IDX_2R_5G) &&
+		     bw == RTW_CHANNEL_WIDTH_40) ||
+		    (!is_rfe_type && col == CCUT_IDX_2R_5G &&
+		     bw == RTW_CHANNEL_WIDTH_40) ||
+		    (efuse->rfe_option == 5 && col == CCUT_IDX_2R_5G))
+			reg830 = 0x79a0ea28;
+	}
+
+	rtw_write32_mask(rtwdev, REG_CCASEL, MASKDWORD, reg82c);
+	rtw_write32_mask(rtwdev, REG_PDMFTH, MASKDWORD, reg830);
+	rtw_write32_mask(rtwdev, REG_CCA2ND, MASKDWORD, reg838);
+
+	if (is_efem_cca && !(hal->cut_version == RTW_CHIP_VER_CUT_B))
+		rtw_write32_mask(rtwdev, REG_L1WT, MASKDWORD, 0x9194b2b9);
+
+	if (bw == RTW_CHANNEL_WIDTH_20 &&
+	    ((channel >= 52 && channel <= 64) ||
+	     (channel >= 100 && channel <= 144)))
+		rtw_write32_mask(rtwdev, REG_CCA2ND, 0xf0, 0x4);
+}
+
+static const u8 low_band[15] = {0x7, 0x6, 0x6, 0x5, 0x0, 0x0, 0x7, 0xff, 0x6,
+				0x5, 0x0, 0x0, 0x7, 0x6, 0x6};
+static const u8 middle_band[23] = {0x6, 0x5, 0x0, 0x0, 0x7, 0x6, 0x6, 0xff, 0x0,
+				   0x0, 0x7, 0x6, 0x6, 0x5, 0x0, 0xff, 0x7, 0x6,
+				   0x6, 0x5, 0x0, 0x0, 0x7};
+static const u8 high_band[15] = {0x5, 0x5, 0x0, 0x7, 0x7, 0x6, 0x5, 0xff, 0x0,
+				 0x7, 0x7, 0x6, 0x5, 0x5, 0x0};
+
+static void rtw8822b_set_channel_rf(struct rtw_dev *rtwdev, u8 channel, u8 bw)
+{
+#define RF18_BAND_MASK		(BIT(16) | BIT(9) | BIT(8))
+#define RF18_BAND_2G		(0)
+#define RF18_BAND_5G		(BIT(16) | BIT(8))
+#define RF18_CHANNEL_MASK	(MASKBYTE0)
+#define RF18_RFSI_MASK		(BIT(18) | BIT(17))
+#define RF18_RFSI_GE_CH80	(BIT(17))
+#define RF18_RFSI_GT_CH144	(BIT(18))
+#define RF18_BW_MASK		(BIT(11) | BIT(10))
+#define RF18_BW_20M		(BIT(11) | BIT(10))
+#define RF18_BW_40M		(BIT(11))
+#define RF18_BW_80M		(BIT(10))
+#define RFBE_MASK		(BIT(17) | BIT(16) | BIT(15))
+
+	struct rtw_hal *hal = &rtwdev->hal;
+	u32 rf_reg18, rf_reg_be;
+
+	rf_reg18 = rtw_read_rf(rtwdev, RF_PATH_A, 0x18, RFREG_MASK);
+
+	rf_reg18 &= ~(RF18_BAND_MASK | RF18_CHANNEL_MASK | RF18_RFSI_MASK |
+		      RF18_BW_MASK);
+
+	rf_reg18 |= (channel <= 14 ? RF18_BAND_2G : RF18_BAND_5G);
+	rf_reg18 |= (channel & RF18_CHANNEL_MASK);
+	if (channel > 144)
+		rf_reg18 |= RF18_RFSI_GT_CH144;
+	else if (channel >= 80)
+		rf_reg18 |= RF18_RFSI_GE_CH80;
+
+	switch (bw) {
+	case RTW_CHANNEL_WIDTH_5:
+	case RTW_CHANNEL_WIDTH_10:
+	case RTW_CHANNEL_WIDTH_20:
+	default:
+		rf_reg18 |= RF18_BW_20M;
+		break;
+	case RTW_CHANNEL_WIDTH_40:
+		rf_reg18 |= RF18_BW_40M;
+		break;
+	case RTW_CHANNEL_WIDTH_80:
+		rf_reg18 |= RF18_BW_80M;
+		break;
+	}
+
+	if (channel <= 14)
+		rf_reg_be = 0x0;
+	else if (channel >= 36 && channel <= 64)
+		rf_reg_be = low_band[(channel - 36) >> 1];
+	else if (channel >= 100 && channel <= 144)
+		rf_reg_be = middle_band[(channel - 100) >> 1];
+	else if (channel >= 149 && channel <= 177)
+		rf_reg_be = high_band[(channel - 149) >> 1];
+	else
+		goto err;
+
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_MALSEL, RFBE_MASK, rf_reg_be);
+
+	/* need to set 0xdf[18]=1 before writing RF18 when channel 144 */
+	if (channel == 144)
+		rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTDBG, BIT(18), 0x1);
+	else
+		rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTDBG, BIT(18), 0x0);
+
+	rtw_write_rf(rtwdev, RF_PATH_A, 0x18, RFREG_MASK, rf_reg18);
+	if (hal->rf_type > RF_1T1R)
+		rtw_write_rf(rtwdev, RF_PATH_B, 0x18, RFREG_MASK, rf_reg18);
+
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_XTALX2, BIT(19), 0);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_XTALX2, BIT(19), 1);
+
+	return;
+
+err:
+	WARN_ON(1);
+}
+
+static void rtw8822b_toggle_igi(struct rtw_dev *rtwdev)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	u32 igi;
+
+	igi = rtw_read32_mask(rtwdev, REG_RXIGI_A, 0x7f);
+	rtw_write32_mask(rtwdev, REG_RXIGI_A, 0x7f, igi - 2);
+	rtw_write32_mask(rtwdev, REG_RXIGI_A, 0x7f, igi);
+	rtw_write32_mask(rtwdev, REG_RXIGI_B, 0x7f, igi - 2);
+	rtw_write32_mask(rtwdev, REG_RXIGI_B, 0x7f, igi);
+
+	rtw_write32_mask(rtwdev, REG_RXPSEL, MASKBYTE0, 0x0);
+	rtw_write32_mask(rtwdev, REG_RXPSEL, MASKBYTE0,
+			 hal->antenna_rx | (hal->antenna_rx << 4));
+}
+
+static void rtw8822b_set_channel_rxdfir(struct rtw_dev *rtwdev, u8 bw)
+{
+	if (bw == RTW_CHANNEL_WIDTH_40) {
+		/* RX DFIR for BW40 */
+		rtw_write32_mask(rtwdev, REG_ACBB0, BIT(29) | BIT(28), 0x1);
+		rtw_write32_mask(rtwdev, REG_ACBBRXFIR, BIT(29) | BIT(28), 0x0);
+		rtw_write32s_mask(rtwdev, REG_TXDFIR, BIT(31), 0x0);
+	} else if (bw == RTW_CHANNEL_WIDTH_80) {
+		/* RX DFIR for BW80 */
+		rtw_write32_mask(rtwdev, REG_ACBB0, BIT(29) | BIT(28), 0x2);
+		rtw_write32_mask(rtwdev, REG_ACBBRXFIR, BIT(29) | BIT(28), 0x1);
+		rtw_write32s_mask(rtwdev, REG_TXDFIR, BIT(31), 0x0);
+	} else {
+		/* RX DFIR for BW20, BW10 and BW5*/
+		rtw_write32_mask(rtwdev, REG_ACBB0, BIT(29) | BIT(28), 0x2);
+		rtw_write32_mask(rtwdev, REG_ACBBRXFIR, BIT(29) | BIT(28), 0x2);
+		rtw_write32s_mask(rtwdev, REG_TXDFIR, BIT(31), 0x1);
+	}
+}
+
+static void rtw8822b_set_channel_bb(struct rtw_dev *rtwdev, u8 channel, u8 bw,
+				    u8 primary_ch_idx)
+{
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	u8 rfe_option = efuse->rfe_option;
+	u32 val32;
+
+	if (channel <= 14) {
+		rtw_write32_mask(rtwdev, REG_RXPSEL, BIT(28), 0x1);
+		rtw_write32_mask(rtwdev, REG_CCK_CHECK, BIT(7), 0x0);
+		rtw_write32_mask(rtwdev, REG_ENTXCCK, BIT(18), 0x0);
+		rtw_write32_mask(rtwdev, REG_RXCCAMSK, 0x0000FC00, 15);
+
+		rtw_write32_mask(rtwdev, REG_ACGG2TBL, 0x1f, 0x0);
+		rtw_write32_mask(rtwdev, REG_CLKTRK, 0x1ffe0000, 0x96a);
+		if (channel == 14) {
+			rtw_write32_mask(rtwdev, REG_TXSF2, MASKDWORD, 0x00006577);
+			rtw_write32_mask(rtwdev, REG_TXSF6, MASKLWORD, 0x0000);
+		} else {
+			rtw_write32_mask(rtwdev, REG_TXSF2, MASKDWORD, 0x384f6577);
+			rtw_write32_mask(rtwdev, REG_TXSF6, MASKLWORD, 0x1525);
+		}
+
+		rtw_write32_mask(rtwdev, REG_RFEINV, 0x300, 0x2);
+	} else if (channel > 35) {
+		rtw_write32_mask(rtwdev, REG_ENTXCCK, BIT(18), 0x1);
+		rtw_write32_mask(rtwdev, REG_CCK_CHECK, BIT(7), 0x1);
+		rtw_write32_mask(rtwdev, REG_RXPSEL, BIT(28), 0x0);
+		rtw_write32_mask(rtwdev, REG_RXCCAMSK, 0x0000FC00, 34);
+
+		if (channel >= 36 && channel <= 64)
+			rtw_write32_mask(rtwdev, REG_ACGG2TBL, 0x1f, 0x1);
+		else if (channel >= 100 && channel <= 144)
+			rtw_write32_mask(rtwdev, REG_ACGG2TBL, 0x1f, 0x2);
+		else if (channel >= 149)
+			rtw_write32_mask(rtwdev, REG_ACGG2TBL, 0x1f, 0x3);
+
+		if (channel >= 36 && channel <= 48)
+			rtw_write32_mask(rtwdev, REG_CLKTRK, 0x1ffe0000, 0x494);
+		else if (channel >= 52 && channel <= 64)
+			rtw_write32_mask(rtwdev, REG_CLKTRK, 0x1ffe0000, 0x453);
+		else if (channel >= 100 && channel <= 116)
+			rtw_write32_mask(rtwdev, REG_CLKTRK, 0x1ffe0000, 0x452);
+		else if (channel >= 118 && channel <= 177)
+			rtw_write32_mask(rtwdev, REG_CLKTRK, 0x1ffe0000, 0x412);
+
+		rtw_write32_mask(rtwdev, 0xcbc, 0x300, 0x1);
+	}
+
+	switch (bw) {
+	case RTW_CHANNEL_WIDTH_20:
+	default:
+		val32 = rtw_read32_mask(rtwdev, REG_ADCCLK, MASKDWORD);
+		val32 &= 0xFFCFFC00;
+		val32 |= (RTW_CHANNEL_WIDTH_20);
+		rtw_write32_mask(rtwdev, REG_ADCCLK, MASKDWORD, val32);
+
+		rtw_write32_mask(rtwdev, REG_ADC160, BIT(30), 0x1);
+		break;
+	case RTW_CHANNEL_WIDTH_40:
+		if (primary_ch_idx == 1)
+			rtw_write32_set(rtwdev, REG_RXSB, BIT(4));
+		else
+			rtw_write32_clr(rtwdev, REG_RXSB, BIT(4));
+
+		val32 = rtw_read32_mask(rtwdev, REG_ADCCLK, MASKDWORD);
+		val32 &= 0xFF3FF300;
+		val32 |= (((primary_ch_idx & 0xf) << 2) | RTW_CHANNEL_WIDTH_40);
+		rtw_write32_mask(rtwdev, REG_ADCCLK, MASKDWORD, val32);
+
+		rtw_write32_mask(rtwdev, REG_ADC160, BIT(30), 0x1);
+		break;
+	case RTW_CHANNEL_WIDTH_80:
+		val32 = rtw_read32_mask(rtwdev, REG_ADCCLK, MASKDWORD);
+		val32 &= 0xFCEFCF00;
+		val32 |= (((primary_ch_idx & 0xf) << 2) | RTW_CHANNEL_WIDTH_80);
+		rtw_write32_mask(rtwdev, REG_ADCCLK, MASKDWORD, val32);
+
+		rtw_write32_mask(rtwdev, REG_ADC160, BIT(30), 0x1);
+
+		if (rfe_option == 2) {
+			rtw_write32_mask(rtwdev, REG_L1PKWT, 0x0000f000, 0x6);
+			rtw_write32_mask(rtwdev, REG_ADC40, BIT(10), 0x1);
+		}
+		break;
+	case RTW_CHANNEL_WIDTH_5:
+		val32 = rtw_read32_mask(rtwdev, REG_ADCCLK, MASKDWORD);
+		val32 &= 0xEFEEFE00;
+		val32 |= ((BIT(6) | RTW_CHANNEL_WIDTH_20));
+		rtw_write32_mask(rtwdev, REG_ADCCLK, MASKDWORD, val32);
+
+		rtw_write32_mask(rtwdev, REG_ADC160, BIT(30), 0x0);
+		rtw_write32_mask(rtwdev, REG_ADC40, BIT(31), 0x1);
+		break;
+	case RTW_CHANNEL_WIDTH_10:
+		val32 = rtw_read32_mask(rtwdev, REG_ADCCLK, MASKDWORD);
+		val32 &= 0xEFFEFF00;
+		val32 |= ((BIT(7) | RTW_CHANNEL_WIDTH_20));
+		rtw_write32_mask(rtwdev, REG_ADCCLK, MASKDWORD, val32);
+
+		rtw_write32_mask(rtwdev, REG_ADC160, BIT(30), 0x0);
+		rtw_write32_mask(rtwdev, REG_ADC40, BIT(31), 0x1);
+		break;
+	}
+}
+
+static void rtw8822b_set_channel(struct rtw_dev *rtwdev, u8 channel, u8 bw,
+				 u8 primary_chan_idx)
+{
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	const struct rtw8822b_rfe_info *rfe_info;
+
+	if (WARN(efuse->rfe_option >= ARRAY_SIZE(rtw8822b_rfe_info),
+		 "rfe_option %d is out of boundary\n", efuse->rfe_option))
+		return;
+
+	rfe_info = &rtw8822b_rfe_info[efuse->rfe_option];
+
+	rtw8822b_set_channel_bb(rtwdev, channel, bw, primary_chan_idx);
+	rtw_set_channel_mac(rtwdev, channel, bw, primary_chan_idx);
+	rtw8822b_set_channel_rf(rtwdev, channel, bw);
+	rtw8822b_set_channel_rxdfir(rtwdev, bw);
+	rtw8822b_toggle_igi(rtwdev);
+	rtw8822b_set_channel_cca(rtwdev, channel, bw, rfe_info);
+	(*rfe_info->rtw_set_channel_rfe)(rtwdev, channel);
+}
+
+static void rtw8822b_config_trx_mode(struct rtw_dev *rtwdev, u8 tx_path,
+				     u8 rx_path, bool is_tx2_path)
+{
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	const struct rtw8822b_rfe_info *rfe_info;
+	u8 ch = rtwdev->hal.current_channel;
+	u8 tx_path_sel, rx_path_sel;
+	int counter;
+
+	if (WARN(efuse->rfe_option >= ARRAY_SIZE(rtw8822b_rfe_info),
+		 "rfe_option %d is out of boundary\n", efuse->rfe_option))
+		return;
+
+	rfe_info = &rtw8822b_rfe_info[efuse->rfe_option];
+
+	if ((tx_path | rx_path) & BB_PATH_A)
+		rtw_write32_mask(rtwdev, REG_AGCTR_A, MASKLWORD, 0x3231);
+	else
+		rtw_write32_mask(rtwdev, REG_AGCTR_A, MASKLWORD, 0x1111);
+
+	if ((tx_path | rx_path) & BB_PATH_B)
+		rtw_write32_mask(rtwdev, REG_AGCTR_B, MASKLWORD, 0x3231);
+	else
+		rtw_write32_mask(rtwdev, REG_AGCTR_B, MASKLWORD, 0x1111);
+
+	rtw_write32_mask(rtwdev, REG_CDDTXP, (BIT(19) | BIT(18)), 0x3);
+	rtw_write32_mask(rtwdev, REG_TXPSEL, (BIT(29) | BIT(28)), 0x1);
+	rtw_write32_mask(rtwdev, REG_TXPSEL, BIT(30), 0x1);
+
+	if (tx_path & BB_PATH_A) {
+		rtw_write32_mask(rtwdev, REG_CDDTXP, 0xfff00000, 0x001);
+		rtw_write32_mask(rtwdev, REG_ADCINI, 0xf0000000, 0x8);
+	} else if (tx_path & BB_PATH_B) {
+		rtw_write32_mask(rtwdev, REG_CDDTXP, 0xfff00000, 0x002);
+		rtw_write32_mask(rtwdev, REG_ADCINI, 0xf0000000, 0x4);
+	}
+
+	if (tx_path == BB_PATH_A || tx_path == BB_PATH_B)
+		rtw_write32_mask(rtwdev, REG_TXPSEL1, 0xfff0, 0x01);
+	else
+		rtw_write32_mask(rtwdev, REG_TXPSEL1, 0xfff0, 0x43);
+
+	tx_path_sel = (tx_path << 4) | tx_path;
+	rtw_write32_mask(rtwdev, REG_TXPSEL, MASKBYTE0, tx_path_sel);
+
+	if (tx_path != BB_PATH_A && tx_path != BB_PATH_B) {
+		if (is_tx2_path || rtwdev->mp_mode) {
+			rtw_write32_mask(rtwdev, REG_CDDTXP, 0xfff00000, 0x043);
+			rtw_write32_mask(rtwdev, REG_ADCINI, 0xf0000000, 0xc);
+		}
+	}
+
+	rtw_write32_mask(rtwdev, REG_RXDESC, BIT(22), 0x0);
+	rtw_write32_mask(rtwdev, REG_RXDESC, BIT(18), 0x0);
+
+	if (rx_path & BB_PATH_A)
+		rtw_write32_mask(rtwdev, REG_ADCINI, 0x0f000000, 0x0);
+	else if (rx_path & BB_PATH_B)
+		rtw_write32_mask(rtwdev, REG_ADCINI, 0x0f000000, 0x5);
+
+	rx_path_sel = (rx_path << 4) | rx_path;
+	rtw_write32_mask(rtwdev, REG_RXPSEL, MASKBYTE0, rx_path_sel);
+
+	if (rx_path == BB_PATH_A || rx_path == BB_PATH_B) {
+		rtw_write32_mask(rtwdev, REG_ANTWT, BIT(16), 0x0);
+		rtw_write32_mask(rtwdev, REG_HTSTFWT, BIT(28), 0x0);
+		rtw_write32_mask(rtwdev, REG_MRC, BIT(23), 0x0);
+	} else {
+		rtw_write32_mask(rtwdev, REG_ANTWT, BIT(16), 0x1);
+		rtw_write32_mask(rtwdev, REG_HTSTFWT, BIT(28), 0x1);
+		rtw_write32_mask(rtwdev, REG_MRC, BIT(23), 0x1);
+	}
+
+	for (counter = 100; counter > 0; counter--) {
+		u32 rf_reg33;
+
+		rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWE, RFREG_MASK, 0x80000);
+		rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWA, RFREG_MASK, 0x00001);
+
+		udelay(2);
+		rf_reg33 = rtw_read_rf(rtwdev, RF_PATH_A, 0x33, RFREG_MASK);
+
+		if (rf_reg33 == 0x00001)
+			break;
+	}
+
+	if (WARN(counter <= 0, "write RF mode table fail\n"))
+		return;
+
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWE, RFREG_MASK, 0x80000);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWA, RFREG_MASK, 0x00001);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWD1, RFREG_MASK, 0x00034);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWD0, RFREG_MASK, 0x4080c);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWE, RFREG_MASK, 0x00000);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWE, RFREG_MASK, 0x00000);
+
+	rtw8822b_toggle_igi(rtwdev);
+	rtw8822b_set_channel_cca(rtwdev, 1, RTW_CHANNEL_WIDTH_20, rfe_info);
+	(*rfe_info->rtw_set_channel_rfe)(rtwdev, ch);
+}
+
+static void query_phy_status_page0(struct rtw_dev *rtwdev, u8 *phy_status,
+				   struct rtw_rx_pkt_stat *pkt_stat)
+{
+	s8 min_rx_power = -120;
+	u8 pwdb = GET_PHY_STAT_P0_PWDB(phy_status);
+
+	pkt_stat->rx_power[RF_PATH_A] = pwdb - 110;
+	pkt_stat->rssi = rtw_phy_rf_power_2_rssi(pkt_stat->rx_power, 1);
+	pkt_stat->bw = RTW_CHANNEL_WIDTH_20;
+	pkt_stat->signal_power = max(pkt_stat->rx_power[RF_PATH_A],
+				     min_rx_power);
+}
+
+static void query_phy_status_page1(struct rtw_dev *rtwdev, u8 *phy_status,
+				   struct rtw_rx_pkt_stat *pkt_stat)
+{
+	u8 rxsc, bw;
+	s8 min_rx_power = -120;
+
+	if (pkt_stat->rate > DESC_RATE11M && pkt_stat->rate < DESC_RATEMCS0)
+		rxsc = GET_PHY_STAT_P1_L_RXSC(phy_status);
+	else
+		rxsc = GET_PHY_STAT_P1_HT_RXSC(phy_status);
+
+	if (rxsc >= 1 && rxsc <= 8)
+		bw = RTW_CHANNEL_WIDTH_20;
+	else if (rxsc >= 9 && rxsc <= 12)
+		bw = RTW_CHANNEL_WIDTH_40;
+	else if (rxsc >= 13)
+		bw = RTW_CHANNEL_WIDTH_80;
+	else
+		bw = GET_PHY_STAT_P1_RF_MODE(phy_status);
+
+	pkt_stat->rx_power[RF_PATH_A] = GET_PHY_STAT_P1_PWDB_A(phy_status) - 110;
+	pkt_stat->rx_power[RF_PATH_B] = GET_PHY_STAT_P1_PWDB_B(phy_status) - 110;
+	pkt_stat->rssi = rtw_phy_rf_power_2_rssi(pkt_stat->rx_power, 2);
+	pkt_stat->bw = bw;
+	pkt_stat->signal_power = max3(pkt_stat->rx_power[RF_PATH_A],
+				      pkt_stat->rx_power[RF_PATH_B],
+				      min_rx_power);
+}
+
+static void query_phy_status(struct rtw_dev *rtwdev, u8 *phy_status,
+			     struct rtw_rx_pkt_stat *pkt_stat)
+{
+	u8 page;
+
+	page = *phy_status & 0xf;
+
+	switch (page) {
+	case 0:
+		query_phy_status_page0(rtwdev, phy_status, pkt_stat);
+		break;
+	case 1:
+		query_phy_status_page1(rtwdev, phy_status, pkt_stat);
+		break;
+	default:
+		rtw_warn(rtwdev, "unused phy status page (%d)\n", page);
+		return;
+	}
+}
+
+static void rtw8822b_query_rx_desc(struct rtw_dev *rtwdev, u8 *rx_desc,
+				   struct rtw_rx_pkt_stat *pkt_stat,
+				   struct ieee80211_rx_status *rx_status)
+{
+	struct ieee80211_hdr *hdr;
+	u32 desc_sz = rtwdev->chip->rx_pkt_desc_sz;
+	u8 *phy_status = NULL;
+
+	memset(pkt_stat, 0, sizeof(*pkt_stat));
+
+	pkt_stat->phy_status = GET_RX_DESC_PHYST(rx_desc);
+	pkt_stat->icv_err = GET_RX_DESC_ICV_ERR(rx_desc);
+	pkt_stat->crc_err = GET_RX_DESC_CRC32(rx_desc);
+	pkt_stat->decrypted = !GET_RX_DESC_SWDEC(rx_desc);
+	pkt_stat->is_c2h = GET_RX_DESC_C2H(rx_desc);
+	pkt_stat->pkt_len = GET_RX_DESC_PKT_LEN(rx_desc);
+	pkt_stat->drv_info_sz = GET_RX_DESC_DRV_INFO_SIZE(rx_desc);
+	pkt_stat->shift = GET_RX_DESC_SHIFT(rx_desc);
+	pkt_stat->rate = GET_RX_DESC_RX_RATE(rx_desc);
+	pkt_stat->cam_id = GET_RX_DESC_MACID(rx_desc);
+	pkt_stat->ppdu_cnt = GET_RX_DESC_PPDU_CNT(rx_desc);
+	pkt_stat->tsf_low = GET_RX_DESC_TSFL(rx_desc);
+
+	/* drv_info_sz is in unit of 8-bytes */
+	pkt_stat->drv_info_sz *= 8;
+
+	/* c2h cmd pkt's rx/phy status is not interested */
+	if (pkt_stat->is_c2h)
+		return;
+
+	hdr = (struct ieee80211_hdr *)(rx_desc + desc_sz + pkt_stat->shift +
+				       pkt_stat->drv_info_sz);
+	if (pkt_stat->phy_status) {
+		phy_status = rx_desc + desc_sz + pkt_stat->shift;
+		query_phy_status(rtwdev, phy_status, pkt_stat);
+	}
+
+	rtw_rx_fill_rx_status(rtwdev, pkt_stat, hdr, rx_status, phy_status);
+}
+
+static void
+rtw8822b_set_tx_power_index_by_rate(struct rtw_dev *rtwdev, u8 path, u8 rs)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	static const u32 offset_txagc[2] = {0x1d00, 0x1d80};
+	static u32 phy_pwr_idx;
+	u8 rate, rate_idx, pwr_index, shift;
+	int j;
+
+	for (j = 0; j < rate_size[rs]; j++) {
+		rate = rate_section[rs][j];
+		pwr_index = hal->tx_pwr_tbl[path][rate];
+		shift = rate & 0x3;
+		phy_pwr_idx |= ((u32)pwr_index << (shift * 8));
+		if (shift == 0x3) {
+			rate_idx = rate & 0xfc;
+			rtw_write32(rtwdev, offset_txagc[path] + rate_idx,
+				    phy_pwr_idx);
+			phy_pwr_idx = 0;
+		}
+	}
+}
+
+static void rtw8822b_set_tx_power_index(struct rtw_dev *rtwdev)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	int rs, path;
+
+	for (path = 0; path < hal->rf_path_num; path++) {
+		for (rs = 0; rs < RTW_RATE_SECTION_MAX; rs++)
+			rtw8822b_set_tx_power_index_by_rate(rtwdev, path, rs);
+	}
+}
+
+static bool rtw8822b_check_rf_path(u8 antenna)
+{
+	switch (antenna) {
+	case BB_PATH_A:
+	case BB_PATH_B:
+	case BB_PATH_AB:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static void rtw8822b_set_antenna(struct rtw_dev *rtwdev, u8 antenna_tx,
+				 u8 antenna_rx)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+
+	rtw_dbg(rtwdev, RTW_DBG_PHY, "config RF path, tx=0x%x rx=0x%x\n",
+		antenna_tx, antenna_rx);
+
+	if (!rtw8822b_check_rf_path(antenna_tx)) {
+		rtw_info(rtwdev, "unsupport tx path, set to default path ab\n");
+		antenna_tx = BB_PATH_AB;
+	}
+	if (!rtw8822b_check_rf_path(antenna_rx)) {
+		rtw_info(rtwdev, "unsupport rx path, set to default path ab\n");
+		antenna_rx = BB_PATH_AB;
+	}
+	hal->antenna_tx = antenna_tx;
+	hal->antenna_rx = antenna_rx;
+	rtw8822b_config_trx_mode(rtwdev, antenna_tx, antenna_rx, false);
+}
+
+static void rtw8822b_cfg_ldo25(struct rtw_dev *rtwdev, bool enable)
+{
+	u8 ldo_pwr;
+
+	ldo_pwr = rtw_read8(rtwdev, REG_LDO_EFUSE_CTRL + 3);
+	ldo_pwr = enable ? ldo_pwr | BIT(7) : ldo_pwr & ~BIT(7);
+	rtw_write8(rtwdev, REG_LDO_EFUSE_CTRL + 3, ldo_pwr);
+}
+
+static void rtw8822b_false_alarm_statistics(struct rtw_dev *rtwdev)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	u32 cck_enable;
+	u32 cck_fa_cnt;
+	u32 ofdm_fa_cnt;
+
+	cck_enable = rtw_read32(rtwdev, 0x808) & BIT(28);
+	cck_fa_cnt = rtw_read16(rtwdev, 0xa5c);
+	ofdm_fa_cnt = rtw_read16(rtwdev, 0xf48);
+
+	dm_info->cck_fa_cnt = cck_fa_cnt;
+	dm_info->ofdm_fa_cnt = ofdm_fa_cnt;
+	dm_info->total_fa_cnt = ofdm_fa_cnt;
+	dm_info->total_fa_cnt += cck_enable ? cck_fa_cnt : 0;
+
+	rtw_write32_set(rtwdev, 0x9a4, BIT(17));
+	rtw_write32_clr(rtwdev, 0x9a4, BIT(17));
+	rtw_write32_clr(rtwdev, 0xa2c, BIT(15));
+	rtw_write32_set(rtwdev, 0xa2c, BIT(15));
+	rtw_write32_set(rtwdev, 0xb58, BIT(0));
+	rtw_write32_clr(rtwdev, 0xb58, BIT(0));
+}
+
+static void rtw8822b_do_iqk(struct rtw_dev *rtwdev)
+{
+	static int do_iqk_cnt;
+	struct rtw_iqk_para para = {.clear = 0, .segment_iqk = 0};
+	u32 rf_reg, iqk_fail_mask;
+	int counter;
+	bool reload;
+
+	rtw_fw_do_iqk(rtwdev, &para);
+
+	for (counter = 0; counter < 300; counter++) {
+		rf_reg = rtw_read_rf(rtwdev, RF_PATH_A, RF_DTXLOK, RFREG_MASK);
+		if (rf_reg == 0xabcde)
+			break;
+		msleep(20);
+	}
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_DTXLOK, RFREG_MASK, 0x0);
+
+	reload = !!rtw_read32_mask(rtwdev, REG_IQKFAILMSK, BIT(16));
+	iqk_fail_mask = rtw_read32_mask(rtwdev, REG_IQKFAILMSK, GENMASK(0, 7));
+	rtw_dbg(rtwdev, RTW_DBG_PHY,
+		"iqk counter=%d reload=%d do_iqk_cnt=%d n_iqk_fail(mask)=0x%02x\n",
+		counter, reload, ++do_iqk_cnt, iqk_fail_mask);
+}
+
+static struct rtw_pwr_seq_cmd trans_carddis_to_cardemu_8822b[] = {
+	{0x0086,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_SDIO,
+	 RTW_PWR_CMD_WRITE, BIT(0), 0},
+	{0x0086,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_SDIO,
+	 RTW_PWR_CMD_POLLING, BIT(1), BIT(1)},
+	{0x004A,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), 0},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(3) | BIT(4) | BIT(7), 0},
+	{0x0300,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0},
+	{0x0301,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0},
+	{0xFFFF,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 0,
+	 RTW_PWR_CMD_END, 0, 0},
+};
+
+static struct rtw_pwr_seq_cmd trans_cardemu_to_act_8822b[] = {
+	{0x0012,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), 0},
+	{0x0012,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0020,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0001,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_DELAY, 1, RTW_PWR_DELAY_MS},
+	{0x0000,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(5), 0},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, (BIT(4) | BIT(3) | BIT(2)), 0},
+	{0x0075,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0006,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_POLLING, BIT(1), BIT(1)},
+	{0x0075,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), 0},
+	{0xFF1A,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0},
+	{0x0006,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(7), 0},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, (BIT(4) | BIT(3)), 0},
+	{0x10C3,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_POLLING, BIT(0), 0},
+	{0x0020,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(3), BIT(3)},
+	{0x10A8,
+	 RTW_PWR_CUT_C_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0},
+	{0x10A9,
+	 RTW_PWR_CUT_C_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0xef},
+	{0x10AA,
+	 RTW_PWR_CUT_C_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0x0c},
+	{0x0068,
+	 RTW_PWR_CUT_C_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(4), BIT(4)},
+	{0x0029,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0xF9},
+	{0x0024,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(2), 0},
+	{0x0074,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(5), BIT(5)},
+	{0x00AF,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(5), BIT(5)},
+	{0xFFFF,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 0,
+	 RTW_PWR_CMD_END, 0, 0},
+};
+
+static struct rtw_pwr_seq_cmd trans_act_to_cardemu_8822b[] = {
+	{0x0003,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(2), 0},
+	{0x0093,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(3), 0},
+	{0x001F,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0},
+	{0x00EF,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0},
+	{0xFF1A,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0x30},
+	{0x0049,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), 0},
+	{0x0006,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0002,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), 0},
+	{0x10C3,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), 0},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), BIT(1)},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_POLLING, BIT(1), 0},
+	{0x0020,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(3), 0},
+	{0x0000,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(5), BIT(5)},
+	{0xFFFF,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 0,
+	 RTW_PWR_CMD_END, 0, 0},
+};
+
+static struct rtw_pwr_seq_cmd trans_cardemu_to_carddis_8822b[] = {
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(7), BIT(7)},
+	{0x0007,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0x20},
+	{0x0067,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(5), 0},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(2), BIT(2)},
+	{0x004A,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), 0},
+	{0x0067,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(5), 0},
+	{0x0067,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(4), 0},
+	{0x004F,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), 0},
+	{0x0067,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), 0},
+	{0x0046,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(6), BIT(6)},
+	{0x0067,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(2), 0},
+	{0x0046,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(7), BIT(7)},
+	{0x0062,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(4), BIT(4)},
+	{0x0081,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(7) | BIT(6), 0},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(3) | BIT(4), BIT(3)},
+	{0x0086,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_SDIO,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0086,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_SDIO,
+	 RTW_PWR_CMD_POLLING, BIT(1), 0},
+	{0x0090,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), 0},
+	{0x0044,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_SDIO,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0},
+	{0x0040,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_SDIO,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0x90},
+	{0x0041,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_SDIO,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0x00},
+	{0x0042,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_SDIO,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0x04},
+	{0xFFFF,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 0,
+	 RTW_PWR_CMD_END, 0, 0},
+};
+
+static struct rtw_pwr_seq_cmd *card_enable_flow_8822b[] = {
+	trans_carddis_to_cardemu_8822b,
+	trans_cardemu_to_act_8822b,
+	NULL
+};
+
+static struct rtw_pwr_seq_cmd *card_disable_flow_8822b[] = {
+	trans_act_to_cardemu_8822b,
+	trans_cardemu_to_carddis_8822b,
+	NULL
+};
+
+static struct rtw_intf_phy_para usb2_param_8822b[] = {
+	{0xFFFF, 0x00,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_ALL,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+};
+
+static struct rtw_intf_phy_para usb3_param_8822b[] = {
+	{0x0001, 0xA841,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_D,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0xFFFF, 0x0000,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_ALL,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+};
+
+static struct rtw_intf_phy_para pcie_gen1_param_8822b[] = {
+	{0x0001, 0xA841,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0x0002, 0x60C6,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0x0008, 0x3596,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0x0009, 0x321C,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0x000A, 0x9623,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0x0020, 0x94FF,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0x0021, 0xFFCF,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0x0026, 0xC006,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0x0029, 0xFF0E,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0x002A, 0x1840,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0xFFFF, 0x0000,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_ALL,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+};
+
+static struct rtw_intf_phy_para pcie_gen2_param_8822b[] = {
+	{0x0001, 0xA841,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0x0002, 0x60C6,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0x0008, 0x3597,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0x0009, 0x321C,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0x000A, 0x9623,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0x0020, 0x94FF,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0x0021, 0xFFCF,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0x0026, 0xC006,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0x0029, 0xFF0E,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0x002A, 0x3040,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_C,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+	{0xFFFF, 0x0000,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_ALL,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+};
+
+static struct rtw_intf_phy_para_table phy_para_table_8822b = {
+	.usb2_para	= usb2_param_8822b,
+	.usb3_para	= usb3_param_8822b,
+	.gen1_para	= pcie_gen1_param_8822b,
+	.gen2_para	= pcie_gen2_param_8822b,
+	.n_usb2_para	= ARRAY_SIZE(usb2_param_8822b),
+	.n_usb3_para	= ARRAY_SIZE(usb2_param_8822b),
+	.n_gen1_para	= ARRAY_SIZE(pcie_gen1_param_8822b),
+	.n_gen2_para	= ARRAY_SIZE(pcie_gen2_param_8822b),
+};
+
+static const struct rtw_rfe_def rtw8822b_rfe_defs[] = {
+	[2] = RTW_DEF_RFE(8822b, 2, 2),
+	[5] = RTW_DEF_RFE(8822b, 5, 5),
+};
+
+static struct rtw_hw_reg rtw8822b_dig[] = {
+	[0] = { .addr = 0xc50, .mask = 0x7f },
+	[1] = { .addr = 0xe50, .mask = 0x7f },
+};
+
+static struct rtw_page_table page_table_8822b[] = {
+	{64, 64, 64, 64, 1},
+	{64, 64, 64, 64, 1},
+	{64, 64, 0, 0, 1},
+	{64, 64, 64, 0, 1},
+	{64, 64, 64, 64, 1},
+};
+
+static struct rtw_rqpn rqpn_table_8822b[] = {
+	{RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_NORMAL,
+	 RTW_DMA_MAPPING_LOW, RTW_DMA_MAPPING_LOW,
+	 RTW_DMA_MAPPING_EXTRA, RTW_DMA_MAPPING_HIGH},
+	{RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_NORMAL,
+	 RTW_DMA_MAPPING_LOW, RTW_DMA_MAPPING_LOW,
+	 RTW_DMA_MAPPING_EXTRA, RTW_DMA_MAPPING_HIGH},
+	{RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_NORMAL,
+	 RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_HIGH,
+	 RTW_DMA_MAPPING_HIGH, RTW_DMA_MAPPING_HIGH},
+	{RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_NORMAL,
+	 RTW_DMA_MAPPING_LOW, RTW_DMA_MAPPING_LOW,
+	 RTW_DMA_MAPPING_HIGH, RTW_DMA_MAPPING_HIGH},
+	{RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_NORMAL,
+	 RTW_DMA_MAPPING_LOW, RTW_DMA_MAPPING_LOW,
+	 RTW_DMA_MAPPING_EXTRA, RTW_DMA_MAPPING_HIGH},
+};
+
+static struct rtw_chip_ops rtw8822b_ops = {
+	.phy_set_param		= rtw8822b_phy_set_param,
+	.read_efuse		= rtw8822b_read_efuse,
+	.query_rx_desc		= rtw8822b_query_rx_desc,
+	.set_channel		= rtw8822b_set_channel,
+	.mac_init		= rtw8822b_mac_init,
+	.read_rf		= rtw_phy_read_rf,
+	.write_rf		= rtw_phy_write_rf_reg_sipi,
+	.set_tx_power_index	= rtw8822b_set_tx_power_index,
+	.set_antenna		= rtw8822b_set_antenna,
+	.cfg_ldo25		= rtw8822b_cfg_ldo25,
+	.false_alarm_statistics	= rtw8822b_false_alarm_statistics,
+	.do_iqk			= rtw8822b_do_iqk,
+};
+
+struct rtw_chip_info rtw8822b_hw_spec = {
+	.ops = &rtw8822b_ops,
+	.id = RTW_CHIP_TYPE_8822B,
+	.fw_name = "rtw88/rtw8822b_fw.bin",
+	.tx_pkt_desc_sz = 48,
+	.tx_buf_desc_sz = 16,
+	.rx_pkt_desc_sz = 24,
+	.rx_buf_desc_sz = 8,
+	.phy_efuse_size = 1024,
+	.log_efuse_size = 768,
+	.ptct_efuse_size = 96,
+	.txff_size = 262144,
+	.rxff_size = 24576,
+	.txgi_factor = 1,
+	.is_pwr_by_rate_dec = true,
+	.max_power_index = 0x3f,
+	.csi_buf_pg_num = 0,
+	.band = RTW_BAND_2G | RTW_BAND_5G,
+	.page_size = 128,
+	.dig_min = 0x1c,
+	.ht_supported = true,
+	.vht_supported = true,
+	.sys_func_en = 0xDC,
+	.pwr_on_seq = card_enable_flow_8822b,
+	.pwr_off_seq = card_disable_flow_8822b,
+	.page_table = page_table_8822b,
+	.rqpn_table = rqpn_table_8822b,
+	.intf_table = &phy_para_table_8822b,
+	.dig = rtw8822b_dig,
+	.rf_base_addr = {0x2800, 0x2c00},
+	.rf_sipi_addr = {0xc90, 0xe90},
+	.mac_tbl = &rtw8822b_mac_tbl,
+	.agc_tbl = &rtw8822b_agc_tbl,
+	.bb_tbl = &rtw8822b_bb_tbl,
+	.rf_tbl = {&rtw8822b_rf_a_tbl, &rtw8822b_rf_b_tbl},
+	.rfe_defs = rtw8822b_rfe_defs,
+	.rfe_defs_size = ARRAY_SIZE(rtw8822b_rfe_defs),
+};
+EXPORT_SYMBOL(rtw8822b_hw_spec);
+
+MODULE_FIRMWARE("rtw88/rtw8822b_fw.bin");
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.h b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
new file mode 100644
index 0000000..8036e30
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
@@ -0,0 +1,170 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTW8822B_H__
+#define __RTW8822B_H__
+
+#include <asm/byteorder.h>
+
+#define RCR_VHT_ACK		BIT(26)
+
+struct rtw8822bu_efuse {
+	u8 res4[4];			/* 0xd0 */
+	u8 usb_optional_function;
+	u8 res5[0x1e];
+	u8 res6[2];
+	u8 serial[0x0b];		/* 0xf5 */
+	u8 vid;				/* 0x100 */
+	u8 res7;
+	u8 pid;
+	u8 res8[4];
+	u8 mac_addr[ETH_ALEN];		/* 0x107 */
+	u8 res9[2];
+	u8 vendor_name[0x07];
+	u8 res10[2];
+	u8 device_name[0x14];
+	u8 res11[0xcf];
+	u8 package_type;		/* 0x1fb */
+	u8 res12[0x4];
+};
+
+struct rtw8822be_efuse {
+	u8 mac_addr[ETH_ALEN];		/* 0xd0 */
+	u8 vender_id[2];
+	u8 device_id[2];
+	u8 sub_vender_id[2];
+	u8 sub_device_id[2];
+	u8 pmc[2];
+	u8 exp_device_cap[2];
+	u8 msi_cap;
+	u8 ltr_cap;			/* 0xe3 */
+	u8 exp_link_control[2];
+	u8 link_cap[4];
+	u8 link_control[2];
+	u8 serial_number[8];
+	u8 res0:2;			/* 0xf4 */
+	u8 ltr_en:1;
+	u8 res1:2;
+	u8 obff:2;
+	u8 res2:3;
+	u8 obff_cap:2;
+	u8 res3:4;
+	u8 res4[3];
+	u8 class_code[3];
+	u8 pci_pm_L1_2_supp:1;
+	u8 pci_pm_L1_1_supp:1;
+	u8 aspm_pm_L1_2_supp:1;
+	u8 aspm_pm_L1_1_supp:1;
+	u8 L1_pm_substates_supp:1;
+	u8 res5:3;
+	u8 port_common_mode_restore_time;
+	u8 port_t_power_on_scale:2;
+	u8 res6:1;
+	u8 port_t_power_on_value:5;
+	u8 res7;
+};
+
+struct rtw8822b_efuse {
+	__le16 rtl_id;
+	u8 res0[0x0e];
+
+	/* power index for four RF paths */
+	struct rtw_txpwr_idx txpwr_idx_table[4];
+
+	u8 channel_plan;		/* 0xb8 */
+	u8 xtal_k;
+	u8 thermal_meter;
+	u8 iqk_lck;
+	u8 pa_type;			/* 0xbc */
+	u8 lna_type_2g[2];		/* 0xbd */
+	u8 lna_type_5g[2];
+	u8 rf_board_option;
+	u8 rf_feature_option;
+	u8 rf_bt_setting;
+	u8 eeprom_version;
+	u8 eeprom_customer_id;
+	u8 tx_bb_swing_setting_2g;
+	u8 tx_bb_swing_setting_5g;
+	u8 tx_pwr_calibrate_rate;
+	u8 rf_antenna_option;		/* 0xc9 */
+	u8 rfe_option;
+	u8 country_code[2];
+	u8 res[3];
+	union {
+		struct rtw8822bu_efuse u;
+		struct rtw8822be_efuse e;
+	};
+};
+
+static inline void
+_rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 data)
+{
+	/* 0xC00-0xCFF and 0xE00-0xEFF have the same layout */
+	rtw_write32_mask(rtwdev, addr, mask, data);
+	rtw_write32_mask(rtwdev, addr + 0x200, mask, data);
+}
+
+#define rtw_write32s_mask(rtwdev, addr, mask, data)			       \
+	do {								       \
+		BUILD_BUG_ON((addr) < 0xC00 || (addr) >= 0xD00);	       \
+									       \
+		_rtw_write32s_mask(rtwdev, addr, mask, data);		       \
+	} while (0)
+
+/* phy status page0 */
+#define GET_PHY_STAT_P0_PWDB(phy_stat)                                         \
+	le32_get_bits(*((__le32 *)(phy_stat) + 0x00), GENMASK(15, 8))
+
+/* phy status page1 */
+#define GET_PHY_STAT_P1_PWDB_A(phy_stat)                                       \
+	le32_get_bits(*((__le32 *)(phy_stat) + 0x00), GENMASK(15, 8))
+#define GET_PHY_STAT_P1_PWDB_B(phy_stat)                                       \
+	le32_get_bits(*((__le32 *)(phy_stat) + 0x00), GENMASK(23, 16))
+#define GET_PHY_STAT_P1_RF_MODE(phy_stat)                                      \
+	le32_get_bits(*((__le32 *)(phy_stat) + 0x03), GENMASK(29, 28))
+#define GET_PHY_STAT_P1_L_RXSC(phy_stat)                                       \
+	le32_get_bits(*((__le32 *)(phy_stat) + 0x01), GENMASK(11, 8))
+#define GET_PHY_STAT_P1_HT_RXSC(phy_stat)                                      \
+	le32_get_bits(*((__le32 *)(phy_stat) + 0x01), GENMASK(15, 12))
+
+#define REG_HTSTFWT	0x800
+#define REG_RXPSEL	0x808
+#define BIT_RX_PSEL_RST		(BIT(28) | BIT(29))
+#define REG_TXPSEL	0x80c
+#define REG_RXCCAMSK	0x814
+#define REG_CCASEL	0x82c
+#define REG_PDMFTH	0x830
+#define REG_CCA2ND	0x838
+#define REG_L1WT	0x83c
+#define REG_L1PKWT	0x840
+#define REG_MRC		0x850
+#define REG_CLKTRK	0x860
+#define REG_ADCCLK	0x8ac
+#define REG_ADC160	0x8c4
+#define REG_ADC40	0x8c8
+#define REG_CDDTXP	0x93c
+#define REG_TXPSEL1	0x940
+#define REG_ACBB0	0x948
+#define REG_ACBBRXFIR	0x94c
+#define REG_ACGG2TBL	0x958
+#define REG_RXSB	0xa00
+#define REG_ADCINI	0xa04
+#define REG_TXSF2	0xa24
+#define REG_TXSF6	0xa28
+#define REG_RXDESC	0xa2c
+#define REG_ENTXCCK	0xa80
+#define REG_AGCTR_A	0xc08
+#define REG_TXDFIR	0xc20
+#define REG_RXIGI_A	0xc50
+#define REG_TRSW	0xca0
+#define REG_RFESEL0	0xcb0
+#define REG_RFESEL8	0xcb4
+#define REG_RFECTL	0xcb8
+#define REG_RFEINV	0xcbc
+#define REG_AGCTR_B	0xe08
+#define REG_RXIGI_B	0xe50
+#define REG_ANTWT	0x1904
+#define REG_IQKFAILMSK	0x1bf0
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b_table.h b/drivers/net/wireless/realtek/rtw88/rtw8822b_table.h
new file mode 100644
index 0000000..693b781
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b_table.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTW8822B_TABLE_H__
+#define __RTW8822B_TABLE_H__
+
+extern const struct rtw_table rtw8822b_mac_tbl;
+extern const struct rtw_table rtw8822b_agc_tbl;
+extern const struct rtw_table rtw8822b_bb_tbl;
+extern const struct rtw_table rtw8822b_bb_pg_type2_tbl;
+extern const struct rtw_table rtw8822b_bb_pg_type5_tbl;
+extern const struct rtw_table rtw8822b_rf_a_tbl;
+extern const struct rtw_table rtw8822b_rf_b_tbl;
+extern const struct rtw_table rtw8822b_txpwr_lmt_type2_tbl;
+extern const struct rtw_table rtw8822b_txpwr_lmt_type5_tbl;
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
new file mode 100644
index 0000000..b6e73dd
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -0,0 +1,1890 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#include "main.h"
+#include "fw.h"
+#include "tx.h"
+#include "rx.h"
+#include "phy.h"
+#include "rtw8822c.h"
+#include "rtw8822c_table.h"
+#include "mac.h"
+#include "reg.h"
+#include "debug.h"
+
+static void rtw8822c_config_trx_mode(struct rtw_dev *rtwdev, u8 tx_path,
+				     u8 rx_path, bool is_tx2_path);
+
+static void rtw8822ce_efuse_parsing(struct rtw_efuse *efuse,
+				    struct rtw8822c_efuse *map)
+{
+	ether_addr_copy(efuse->addr, map->e.mac_addr);
+}
+
+static int rtw8822c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
+{
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	struct rtw8822c_efuse *map;
+	int i;
+
+	map = (struct rtw8822c_efuse *)log_map;
+
+	efuse->rfe_option = map->rfe_option;
+	efuse->crystal_cap = map->xtal_k;
+	efuse->channel_plan = map->channel_plan;
+	efuse->country_code[0] = map->country_code[0];
+	efuse->country_code[1] = map->country_code[1];
+	efuse->bt_setting = map->rf_bt_setting;
+	efuse->regd = map->rf_board_option & 0x7;
+
+	for (i = 0; i < 4; i++)
+		efuse->txpwr_idx_table[i] = map->txpwr_idx_table[i];
+
+	switch (rtw_hci_type(rtwdev)) {
+	case RTW_HCI_TYPE_PCIE:
+		rtw8822ce_efuse_parsing(efuse, map);
+		break;
+	default:
+		/* unsupported now */
+		return -ENOTSUPP;
+	}
+
+	return 0;
+}
+
+static void rtw8822c_header_file_init(struct rtw_dev *rtwdev, bool pre)
+{
+	rtw_write32_set(rtwdev, REG_3WIRE, BIT_3WIRE_TX_EN | BIT_3WIRE_RX_EN);
+	rtw_write32_set(rtwdev, REG_3WIRE, BIT_3WIRE_PI_ON);
+	rtw_write32_set(rtwdev, REG_3WIRE2, BIT_3WIRE_TX_EN | BIT_3WIRE_RX_EN);
+	rtw_write32_set(rtwdev, REG_3WIRE2, BIT_3WIRE_PI_ON);
+
+	if (pre)
+		rtw_write32_clr(rtwdev, REG_ENCCK, BIT_CCK_OFDM_BLK_EN);
+	else
+		rtw_write32_set(rtwdev, REG_ENCCK, BIT_CCK_OFDM_BLK_EN);
+}
+
+static void rtw8822c_dac_backup_reg(struct rtw_dev *rtwdev,
+				    struct rtw_backup_info *backup,
+				    struct rtw_backup_info *backup_rf)
+{
+	u32 path, i;
+	u32 val;
+	u32 reg;
+	u32 rf_addr[DACK_RF_8822C] = {0x8f};
+	u32 addrs[DACK_REG_8822C] = {0x180c, 0x1810, 0x410c, 0x4110,
+				     0x1c3c, 0x1c24, 0x1d70, 0x9b4,
+				     0x1a00, 0x1a14, 0x1d58, 0x1c38,
+				     0x1e24, 0x1e28, 0x1860, 0x4160};
+
+	for (i = 0; i < DACK_REG_8822C; i++) {
+		backup[i].len = 4;
+		backup[i].reg = addrs[i];
+		backup[i].val = rtw_read32(rtwdev, addrs[i]);
+	}
+
+	for (path = 0; path < DACK_PATH_8822C; path++) {
+		for (i = 0; i < DACK_RF_8822C; i++) {
+			reg = rf_addr[i];
+			val = rtw_read_rf(rtwdev, path, reg, RFREG_MASK);
+			backup_rf[path * i + i].reg = reg;
+			backup_rf[path * i + i].val = val;
+		}
+	}
+}
+
+static void rtw8822c_dac_restore_reg(struct rtw_dev *rtwdev,
+				     struct rtw_backup_info *backup,
+				     struct rtw_backup_info *backup_rf)
+{
+	u32 path, i;
+	u32 val;
+	u32 reg;
+
+	rtw_restore_reg(rtwdev, backup, DACK_REG_8822C);
+
+	for (path = 0; path < DACK_PATH_8822C; path++) {
+		for (i = 0; i < DACK_RF_8822C; i++) {
+			val = backup_rf[path * i + i].val;
+			reg = backup_rf[path * i + i].reg;
+			rtw_write_rf(rtwdev, path, reg, RFREG_MASK, val);
+		}
+	}
+}
+
+static void rtw8822c_rf_minmax_cmp(struct rtw_dev *rtwdev, u32 value,
+				   u32 *min, u32 *max)
+{
+	if (value >= 0x200) {
+		if (*min >= 0x200) {
+			if (*min > value)
+				*min = value;
+		} else {
+			*min = value;
+		}
+		if (*max >= 0x200) {
+			if (*max < value)
+				*max = value;
+		}
+	} else {
+		if (*min < 0x200) {
+			if (*min > value)
+				*min = value;
+		}
+
+		if (*max  >= 0x200) {
+			*max = value;
+		} else {
+			if (*max < value)
+				*max = value;
+		}
+	}
+}
+
+static void swap_u32(u32 *v1, u32 *v2)
+{
+	u32 tmp;
+
+	tmp = *v1;
+	*v1 = *v2;
+	*v2 = tmp;
+}
+
+static void __rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, u32 *v1, u32 *v2)
+{
+	if (*v1 >= 0x200 && *v2 >= 0x200) {
+		if (*v1 > *v2)
+			swap_u32(v1, v2);
+	} else if (*v1 < 0x200 && *v2 < 0x200) {
+		if (*v1 > *v2)
+			swap_u32(v1, v2);
+	} else if (*v1 < 0x200 && *v2 >= 0x200) {
+		swap_u32(v1, v2);
+	}
+}
+
+static void rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
+{
+	u32 i, j;
+
+	for (i = 0; i < DACK_SN_8822C - 1; i++) {
+		for (j = 0; j < (DACK_SN_8822C - 1 - i) ; j++) {
+			__rtw8822c_dac_iq_sort(rtwdev, &iv[j], &iv[j + 1]);
+			__rtw8822c_dac_iq_sort(rtwdev, &qv[j], &qv[j + 1]);
+		}
+	}
+}
+
+static void rtw8822c_dac_iq_offset(struct rtw_dev *rtwdev, u32 *vec, u32 *val)
+{
+	u32 p, m, t, i;
+
+	m = 0;
+	p = 0;
+	for (i = 10; i < DACK_SN_8822C - 10; i++) {
+		if (vec[i] > 0x200)
+			m = (0x400 - vec[i]) + m;
+		else
+			p = vec[i] + p;
+	}
+
+	if (p > m) {
+		t = p - m;
+		t = t / (DACK_SN_8822C - 20);
+	} else {
+		t = m - p;
+		t = t / (DACK_SN_8822C - 20);
+		if (t != 0x0)
+			t = 0x400 - t;
+	}
+
+	*val = t;
+}
+
+static u32 rtw8822c_get_path_base_addr(u8 path)
+{
+	u32 base_addr;
+
+	switch (path) {
+	case RF_PATH_A:
+		base_addr = 0x1800;
+		break;
+	case RF_PATH_B:
+		base_addr = 0x4100;
+		break;
+	default:
+		WARN_ON(1);
+		return -1;
+	}
+
+	return base_addr;
+}
+
+static bool rtw8822c_dac_iq_check(struct rtw_dev *rtwdev, u32 value)
+{
+	bool ret = true;
+
+	if ((value >= 0x200 && (0x400 - value) > 0x64) ||
+	    (value < 0x200 && value > 0x64)) {
+		ret = false;
+		rtw_dbg(rtwdev, RTW_DBG_RFK, "[DACK] Error overflow\n");
+	}
+
+	return ret;
+}
+
+static void rtw8822c_dac_cal_iq_sample(struct rtw_dev *rtwdev, u32 *iv, u32 *qv)
+{
+	u32 temp;
+	int i = 0, cnt = 0;
+
+	while (i < DACK_SN_8822C && cnt < 10000) {
+		cnt++;
+		temp = rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
+		iv[i] = (temp & 0x3ff000) >> 12;
+		qv[i] = temp & 0x3ff;
+
+		if (rtw8822c_dac_iq_check(rtwdev, iv[i]) &&
+		    rtw8822c_dac_iq_check(rtwdev, qv[i]))
+			i++;
+	}
+}
+
+static void rtw8822c_dac_cal_iq_search(struct rtw_dev *rtwdev,
+				       u32 *iv, u32 *qv,
+				       u32 *i_value, u32 *q_value)
+{
+	u32 i_max = 0, q_max = 0, i_min = 0, q_min = 0;
+	u32 i_delta, q_delta;
+	u32 temp;
+	int i, cnt = 0;
+
+	do {
+		i_min = iv[0];
+		i_max = iv[0];
+		q_min = qv[0];
+		q_max = qv[0];
+		for (i = 0; i < DACK_SN_8822C; i++) {
+			rtw8822c_rf_minmax_cmp(rtwdev, iv[i], &i_min, &i_max);
+			rtw8822c_rf_minmax_cmp(rtwdev, qv[i], &q_min, &q_max);
+		}
+
+		if (i_max < 0x200 && i_min < 0x200)
+			i_delta = i_max - i_min;
+		else if (i_max >= 0x200 && i_min >= 0x200)
+			i_delta = i_max - i_min;
+		else
+			i_delta = i_max + (0x400 - i_min);
+
+		if (q_max < 0x200 && q_min < 0x200)
+			q_delta = q_max - q_min;
+		else if (q_max >= 0x200 && q_min >= 0x200)
+			q_delta = q_max - q_min;
+		else
+			q_delta = q_max + (0x400 - q_min);
+
+		rtw_dbg(rtwdev, RTW_DBG_RFK,
+			"[DACK] i: min=0x%08x, max=0x%08x, delta=0x%08x\n",
+			i_min, i_max, i_delta);
+		rtw_dbg(rtwdev, RTW_DBG_RFK,
+			"[DACK] q: min=0x%08x, max=0x%08x, delta=0x%08x\n",
+			q_min, q_max, q_delta);
+
+		rtw8822c_dac_iq_sort(rtwdev, iv, qv);
+
+		if (i_delta > 5 || q_delta > 5) {
+			temp = rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
+			iv[0] = (temp & 0x3ff000) >> 12;
+			qv[0] = temp & 0x3ff;
+			temp = rtw_read32_mask(rtwdev, 0x2dbc, 0x3fffff);
+			iv[DACK_SN_8822C - 1] = (temp & 0x3ff000) >> 12;
+			qv[DACK_SN_8822C - 1] = temp & 0x3ff;
+		} else {
+			break;
+		}
+	} while (cnt++ < 100);
+
+	rtw8822c_dac_iq_offset(rtwdev, iv, i_value);
+	rtw8822c_dac_iq_offset(rtwdev, qv, q_value);
+}
+
+static void rtw8822c_dac_cal_rf_mode(struct rtw_dev *rtwdev,
+				     u32 *i_value, u32 *q_value)
+{
+	u32 iv[DACK_SN_8822C], qv[DACK_SN_8822C];
+	u32 rf_a, rf_b;
+
+	mdelay(10);
+
+	rf_a = rtw_read_rf(rtwdev, RF_PATH_A, 0x0, RFREG_MASK);
+	rf_b = rtw_read_rf(rtwdev, RF_PATH_B, 0x0, RFREG_MASK);
+
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[DACK] RF path-A=0x%05x\n", rf_a);
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[DACK] RF path-B=0x%05x\n", rf_b);
+
+	rtw8822c_dac_cal_iq_sample(rtwdev, iv, qv);
+	rtw8822c_dac_cal_iq_search(rtwdev, iv, qv, i_value, q_value);
+}
+
+static void rtw8822c_dac_bb_setting(struct rtw_dev *rtwdev)
+{
+	rtw_write32_mask(rtwdev, 0x1d58, 0xff8, 0x1ff);
+	rtw_write32_mask(rtwdev, 0x1a00, 0x3, 0x2);
+	rtw_write32_mask(rtwdev, 0x1a14, 0x300, 0x3);
+	rtw_write32(rtwdev, 0x1d70, 0x7e7e7e7e);
+	rtw_write32_mask(rtwdev, 0x180c, 0x3, 0x0);
+	rtw_write32_mask(rtwdev, 0x410c, 0x3, 0x0);
+	rtw_write32(rtwdev, 0x1b00, 0x00000008);
+	rtw_write8(rtwdev, 0x1bcc, 0x3f);
+	rtw_write32(rtwdev, 0x1b00, 0x0000000a);
+	rtw_write8(rtwdev, 0x1bcc, 0x3f);
+	rtw_write32_mask(rtwdev, 0x1e24, BIT(31), 0x0);
+	rtw_write32_mask(rtwdev, 0x1e28, 0xf, 0x3);
+}
+
+static void rtw8822c_dac_cal_adc(struct rtw_dev *rtwdev,
+				 u8 path, u32 *adc_ic, u32 *adc_qc)
+{
+	u32 ic = 0, qc = 0, temp = 0;
+	u32 base_addr;
+	u32 path_sel;
+	int i;
+
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[DACK] ADCK path(%d)\n", path);
+
+	base_addr = rtw8822c_get_path_base_addr(path);
+	switch (path) {
+	case RF_PATH_A:
+		path_sel = 0xa0000;
+		break;
+	case RF_PATH_B:
+		path_sel = 0x80000;
+		break;
+	default:
+		WARN_ON(1);
+		return;
+	}
+
+	/* ADCK step1 */
+	rtw_write32_mask(rtwdev, base_addr + 0x30, BIT(30), 0x0);
+	if (path == RF_PATH_B)
+		rtw_write32(rtwdev, base_addr + 0x30, 0x30db8041);
+	rtw_write32(rtwdev, base_addr + 0x60, 0xf0040ff0);
+	rtw_write32(rtwdev, base_addr + 0x0c, 0xdff00220);
+	rtw_write32(rtwdev, base_addr + 0x10, 0x02dd08c4);
+	rtw_write32(rtwdev, base_addr + 0x0c, 0x10000260);
+	rtw_write_rf(rtwdev, RF_PATH_A, 0x0, RFREG_MASK, 0x10000);
+	rtw_write_rf(rtwdev, RF_PATH_B, 0x0, RFREG_MASK, 0x10000);
+	for (i = 0; i < 10; i++) {
+		rtw_dbg(rtwdev, RTW_DBG_RFK, "[DACK] ADCK count=%d\n", i);
+		rtw_write32(rtwdev, 0x1c3c, path_sel + 0x8003);
+		rtw_write32(rtwdev, 0x1c24, 0x00010002);
+		rtw8822c_dac_cal_rf_mode(rtwdev, &ic, &qc);
+		rtw_dbg(rtwdev, RTW_DBG_RFK,
+			"[DACK] before: i=0x%x, q=0x%x\n", ic, qc);
+
+		/* compensation value */
+		if (ic != 0x0) {
+			ic = 0x400 - ic;
+			*adc_ic = ic;
+		}
+		if (qc != 0x0) {
+			qc = 0x400 - qc;
+			*adc_qc = qc;
+		}
+		temp = (ic & 0x3ff) | ((qc & 0x3ff) << 10);
+		rtw_write32(rtwdev, base_addr + 0x68, temp);
+		rtw_dbg(rtwdev, RTW_DBG_RFK, "[DACK] ADCK 0x%08x=0x08%x\n",
+			base_addr + 0x68, temp);
+		/* check ADC DC offset */
+		rtw_write32(rtwdev, 0x1c3c, path_sel + 0x8103);
+		rtw8822c_dac_cal_rf_mode(rtwdev, &ic, &qc);
+		rtw_dbg(rtwdev, RTW_DBG_RFK,
+			"[DACK] after:  i=0x%08x, q=0x%08x\n", ic, qc);
+		if (ic >= 0x200)
+			ic = 0x400 - ic;
+		if (qc >= 0x200)
+			qc = 0x400 - qc;
+		if (ic < 5 && qc < 5)
+			break;
+	}
+
+	/* ADCK step2 */
+	rtw_write32(rtwdev, 0x1c3c, 0x00000003);
+	rtw_write32(rtwdev, base_addr + 0x0c, 0x10000260);
+	rtw_write32(rtwdev, base_addr + 0x10, 0x02d508c4);
+
+	/* release pull low switch on IQ path */
+	rtw_write_rf(rtwdev, path, 0x8f, BIT(13), 0x1);
+}
+
+static void rtw8822c_dac_cal_step1(struct rtw_dev *rtwdev, u8 path)
+{
+	u32 base_addr;
+
+	base_addr = rtw8822c_get_path_base_addr(path);
+
+	rtw_write32(rtwdev, base_addr + 0x0c, 0xdff00220);
+	if (path == RF_PATH_A) {
+		rtw_write32(rtwdev, base_addr + 0x60, 0xf0040ff0);
+		rtw_write32(rtwdev, 0x1c38, 0xffffffff);
+	}
+	rtw_write32(rtwdev, base_addr + 0x10, 0x02d508c5);
+	rtw_write32(rtwdev, 0x9b4, 0xdb66db00);
+	rtw_write32(rtwdev, base_addr + 0xb0, 0x0a11fb88);
+	rtw_write32(rtwdev, base_addr + 0xbc, 0x0008ff81);
+	rtw_write32(rtwdev, base_addr + 0xc0, 0x0003d208);
+	rtw_write32(rtwdev, base_addr + 0xcc, 0x0a11fb88);
+	rtw_write32(rtwdev, base_addr + 0xd8, 0x0008ff81);
+	rtw_write32(rtwdev, base_addr + 0xdc, 0x0003d208);
+	rtw_write32(rtwdev, base_addr + 0xb8, 0x60000000);
+	mdelay(2);
+	rtw_write32(rtwdev, base_addr + 0xbc, 0x000aff8d);
+	mdelay(2);
+	rtw_write32(rtwdev, base_addr + 0xb0, 0x0a11fb89);
+	rtw_write32(rtwdev, base_addr + 0xcc, 0x0a11fb89);
+	mdelay(1);
+	rtw_write32(rtwdev, base_addr + 0xb8, 0x62000000);
+	mdelay(20);
+	rtw_write32(rtwdev, base_addr + 0xd4, 0x62000000);
+	mdelay(20);
+	rtw_write32(rtwdev, base_addr + 0xb8, 0x02000000);
+	mdelay(20);
+	rtw_write32(rtwdev, base_addr + 0xbc, 0x0008ff87);
+	rtw_write32(rtwdev, 0x9b4, 0xdb6db600);
+	rtw_write32(rtwdev, base_addr + 0x10, 0x02d508c5);
+	rtw_write32(rtwdev, base_addr + 0xbc, 0x0008ff87);
+	rtw_write32(rtwdev, base_addr + 0x60, 0xf0000000);
+}
+
+static void rtw8822c_dac_cal_step2(struct rtw_dev *rtwdev,
+				   u8 path, u32 *ic_out, u32 *qc_out)
+{
+	u32 base_addr;
+	u32 ic, qc, ic_in, qc_in;
+
+	base_addr = rtw8822c_get_path_base_addr(path);
+	rtw_write32_mask(rtwdev, base_addr + 0xbc, 0xf0000000, 0x0);
+	rtw_write32_mask(rtwdev, base_addr + 0xc0, 0xf, 0x8);
+	rtw_write32_mask(rtwdev, base_addr + 0xd8, 0xf0000000, 0x0);
+	rtw_write32_mask(rtwdev, base_addr + 0xdc, 0xf, 0x8);
+
+	rtw_write32(rtwdev, 0x1b00, 0x00000008);
+	rtw_write8(rtwdev, 0x1bcc, 0x03f);
+	rtw_write32(rtwdev, base_addr + 0x0c, 0xdff00220);
+	rtw_write32(rtwdev, base_addr + 0x10, 0x02d508c5);
+	rtw_write32(rtwdev, 0x1c3c, 0x00088103);
+
+	rtw8822c_dac_cal_rf_mode(rtwdev, &ic_in, &qc_in);
+	ic = ic_in;
+	qc = qc_in;
+
+	/* compensation value */
+	if (ic != 0x0)
+		ic = 0x400 - ic;
+	if (qc != 0x0)
+		qc = 0x400 - qc;
+	if (ic < 0x300) {
+		ic = ic * 2 * 6 / 5;
+		ic = ic + 0x80;
+	} else {
+		ic = (0x400 - ic) * 2 * 6 / 5;
+		ic = 0x7f - ic;
+	}
+	if (qc < 0x300) {
+		qc = qc * 2 * 6 / 5;
+		qc = qc + 0x80;
+	} else {
+		qc = (0x400 - qc) * 2 * 6 / 5;
+		qc = 0x7f - qc;
+	}
+
+	*ic_out = ic;
+	*qc_out = qc;
+
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[DACK] before i=0x%x, q=0x%x\n", ic_in, qc_in);
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[DACK] after  i=0x%x, q=0x%x\n", ic, qc);
+}
+
+static void rtw8822c_dac_cal_step3(struct rtw_dev *rtwdev, u8 path,
+				   u32 adc_ic, u32 adc_qc,
+				   u32 *ic_in, u32 *qc_in,
+				   u32 *i_out, u32 *q_out)
+{
+	u32 base_addr;
+	u32 ic, qc;
+	u32 temp;
+
+	base_addr = rtw8822c_get_path_base_addr(path);
+	ic = *ic_in;
+	qc = *qc_in;
+
+	rtw_write32(rtwdev, base_addr + 0x0c, 0xdff00220);
+	rtw_write32(rtwdev, base_addr + 0x10, 0x02d508c5);
+	rtw_write32(rtwdev, 0x9b4, 0xdb66db00);
+	rtw_write32(rtwdev, base_addr + 0xb0, 0x0a11fb88);
+	rtw_write32(rtwdev, base_addr + 0xbc, 0xc008ff81);
+	rtw_write32(rtwdev, base_addr + 0xc0, 0x0003d208);
+	rtw_write32_mask(rtwdev, base_addr + 0xbc, 0xf0000000, ic & 0xf);
+	rtw_write32_mask(rtwdev, base_addr + 0xc0, 0xf, (ic & 0xf0) >> 4);
+	rtw_write32(rtwdev, base_addr + 0xcc, 0x0a11fb88);
+	rtw_write32(rtwdev, base_addr + 0xd8, 0xe008ff81);
+	rtw_write32(rtwdev, base_addr + 0xdc, 0x0003d208);
+	rtw_write32_mask(rtwdev, base_addr + 0xd8, 0xf0000000, qc & 0xf);
+	rtw_write32_mask(rtwdev, base_addr + 0xdc, 0xf, (qc & 0xf0) >> 4);
+	rtw_write32(rtwdev, base_addr + 0xb8, 0x60000000);
+	mdelay(2);
+	rtw_write32_mask(rtwdev, base_addr + 0xbc, 0xe, 0x6);
+	mdelay(2);
+	rtw_write32(rtwdev, base_addr + 0xb0, 0x0a11fb89);
+	rtw_write32(rtwdev, base_addr + 0xcc, 0x0a11fb89);
+	mdelay(1);
+	rtw_write32(rtwdev, base_addr + 0xb8, 0x62000000);
+	mdelay(20);
+	rtw_write32(rtwdev, base_addr + 0xd4, 0x62000000);
+	mdelay(20);
+	rtw_write32(rtwdev, base_addr + 0xb8, 0x02000000);
+	mdelay(20);
+	rtw_write32_mask(rtwdev, base_addr + 0xbc, 0xe, 0x3);
+	rtw_write32(rtwdev, 0x9b4, 0xdb6db600);
+
+	/* check DAC DC offset */
+	temp = ((adc_ic + 0x10) & 0x3ff) | (((adc_qc + 0x10) & 0x3ff) << 10);
+	rtw_write32(rtwdev, base_addr + 0x68, temp);
+	rtw_write32(rtwdev, base_addr + 0x10, 0x02d508c5);
+	rtw_write32(rtwdev, base_addr + 0x60, 0xf0000000);
+	rtw8822c_dac_cal_rf_mode(rtwdev, &ic, &qc);
+	if (ic >= 0x10)
+		ic = ic - 0x10;
+	else
+		ic = 0x400 - (0x10 - ic);
+
+	if (qc >= 0x10)
+		qc = qc - 0x10;
+	else
+		qc = 0x400 - (0x10 - qc);
+
+	*i_out = ic;
+	*q_out = qc;
+
+	if (ic >= 0x200)
+		ic = 0x400 - ic;
+	if (qc >= 0x200)
+		qc = 0x400 - qc;
+
+	*ic_in = ic;
+	*qc_in = qc;
+
+	rtw_dbg(rtwdev, RTW_DBG_RFK,
+		"[DACK] after  DACK i=0x%x, q=0x%x\n", *i_out, *q_out);
+}
+
+static void rtw8822c_dac_cal_step4(struct rtw_dev *rtwdev, u8 path)
+{
+	u32 base_addr = rtw8822c_get_path_base_addr(path);
+
+	rtw_write32(rtwdev, base_addr + 0x68, 0x0);
+	rtw_write32(rtwdev, base_addr + 0x10, 0x02d508c4);
+	rtw_write32_mask(rtwdev, base_addr + 0xbc, 0x1, 0x0);
+	rtw_write32_mask(rtwdev, base_addr + 0x30, BIT(30), 0x1);
+}
+
+static void rtw8822c_rf_dac_cal(struct rtw_dev *rtwdev)
+{
+	struct rtw_backup_info backup_rf[DACK_RF_8822C * DACK_PATH_8822C];
+	struct rtw_backup_info backup[DACK_REG_8822C];
+	u32 ic = 0, qc = 0, i;
+	u32 i_a = 0x0, q_a = 0x0, i_b = 0x0, q_b = 0x0;
+	u32 ic_a = 0x0, qc_a = 0x0, ic_b = 0x0, qc_b = 0x0;
+	u32 adc_ic_a = 0x0, adc_qc_a = 0x0, adc_ic_b = 0x0, adc_qc_b = 0x0;
+
+	rtw8822c_dac_backup_reg(rtwdev, backup, backup_rf);
+
+	rtw8822c_dac_bb_setting(rtwdev);
+
+	/* path-A */
+	rtw8822c_dac_cal_adc(rtwdev, RF_PATH_A, &adc_ic_a, &adc_qc_a);
+	for (i = 0; i < 10; i++) {
+		rtw8822c_dac_cal_step1(rtwdev, RF_PATH_A);
+		rtw8822c_dac_cal_step2(rtwdev, RF_PATH_A, &ic, &qc);
+		ic_a = ic;
+		qc_a = qc;
+
+		rtw8822c_dac_cal_step3(rtwdev, RF_PATH_A, adc_ic_a, adc_qc_a,
+				       &ic, &qc, &i_a, &q_a);
+
+		if (ic < 5 && qc < 5)
+			break;
+	}
+	rtw8822c_dac_cal_step4(rtwdev, RF_PATH_A);
+
+	/* path-B */
+	rtw8822c_dac_cal_adc(rtwdev, RF_PATH_B, &adc_ic_b, &adc_qc_b);
+	for (i = 0; i < 10; i++) {
+		rtw8822c_dac_cal_step1(rtwdev, RF_PATH_B);
+		rtw8822c_dac_cal_step2(rtwdev, RF_PATH_B, &ic, &qc);
+		ic_b = ic;
+		qc_b = qc;
+
+		rtw8822c_dac_cal_step3(rtwdev, RF_PATH_B, adc_ic_b, adc_qc_b,
+				       &ic, &qc, &i_b, &q_b);
+
+		if (ic < 5 && qc < 5)
+			break;
+	}
+	rtw8822c_dac_cal_step4(rtwdev, RF_PATH_B);
+
+	rtw_write32(rtwdev, 0x1b00, 0x00000008);
+	rtw_write32_mask(rtwdev, 0x4130, BIT(30), 0x1);
+	rtw_write8(rtwdev, 0x1bcc, 0x0);
+	rtw_write32(rtwdev, 0x1b00, 0x0000000a);
+	rtw_write8(rtwdev, 0x1bcc, 0x0);
+
+	rtw8822c_dac_restore_reg(rtwdev, backup, backup_rf);
+
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[DACK] path A: ic=0x%x, qc=0x%x\n", ic_a, qc_a);
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[DACK] path B: ic=0x%x, qc=0x%x\n", ic_b, qc_b);
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[DACK] path A: i=0x%x, q=0x%x\n", i_a, q_a);
+	rtw_dbg(rtwdev, RTW_DBG_RFK, "[DACK] path B: i=0x%x, q=0x%x\n", i_b, q_b);
+}
+
+static void rtw8822c_rf_x2_check(struct rtw_dev *rtwdev)
+{
+	u8 x2k_busy;
+
+	mdelay(1);
+	x2k_busy = rtw_read_rf(rtwdev, RF_PATH_A, 0xb8, BIT(15));
+	if (x2k_busy == 1) {
+		rtw_write_rf(rtwdev, RF_PATH_A, 0xb8, RFREG_MASK, 0xC4440);
+		rtw_write_rf(rtwdev, RF_PATH_A, 0xba, RFREG_MASK, 0x6840D);
+		rtw_write_rf(rtwdev, RF_PATH_A, 0xb8, RFREG_MASK, 0x80440);
+		mdelay(1);
+	}
+}
+
+static void rtw8822c_rf_init(struct rtw_dev *rtwdev)
+{
+	rtw8822c_rf_dac_cal(rtwdev);
+	rtw8822c_rf_x2_check(rtwdev);
+}
+
+static void rtw8822c_phy_set_param(struct rtw_dev *rtwdev)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	struct rtw_hal *hal = &rtwdev->hal;
+	u8 crystal_cap;
+	u8 cck_gi_u_bnd_msb = 0;
+	u8 cck_gi_u_bnd_lsb = 0;
+	u8 cck_gi_l_bnd_msb = 0;
+	u8 cck_gi_l_bnd_lsb = 0;
+	bool is_tx2_path;
+
+	/* power on BB/RF domain */
+	rtw_write8_set(rtwdev, REG_SYS_FUNC_EN,
+		       BIT_FEN_BB_GLB_RST | BIT_FEN_BB_RSTB);
+	rtw_write8_set(rtwdev, REG_RF_CTRL,
+		       BIT_RF_EN | BIT_RF_RSTB | BIT_RF_SDM_RSTB);
+	rtw_write32_set(rtwdev, REG_WLRF1, BIT_WLRF1_BBRF_EN);
+
+	/* pre init before header files config */
+	rtw8822c_header_file_init(rtwdev, true);
+
+	rtw_phy_load_tables(rtwdev);
+
+	crystal_cap = rtwdev->efuse.crystal_cap & 0x7f;
+	rtw_write32_mask(rtwdev, REG_ANAPAR_XTAL_0, 0xfffc00,
+			 crystal_cap | (crystal_cap << 7));
+
+	/* post init after header files config */
+	rtw8822c_header_file_init(rtwdev, false);
+
+	is_tx2_path = false;
+	rtw8822c_config_trx_mode(rtwdev, hal->antenna_tx, hal->antenna_rx,
+				 is_tx2_path);
+	rtw_phy_init(rtwdev);
+
+	cck_gi_u_bnd_msb = (u8)rtw_read32_mask(rtwdev, 0x1a98, 0xc000);
+	cck_gi_u_bnd_lsb = (u8)rtw_read32_mask(rtwdev, 0x1aa8, 0xf0000);
+	cck_gi_l_bnd_msb = (u8)rtw_read32_mask(rtwdev, 0x1a98, 0xc0);
+	cck_gi_l_bnd_lsb = (u8)rtw_read32_mask(rtwdev, 0x1a70, 0x0f000000);
+
+	dm_info->cck_gi_u_bnd = ((cck_gi_u_bnd_msb << 4) | (cck_gi_u_bnd_lsb));
+	dm_info->cck_gi_l_bnd = ((cck_gi_l_bnd_msb << 4) | (cck_gi_l_bnd_lsb));
+
+	rtw8822c_rf_init(rtwdev);
+	/* wifi path controller */
+	rtw_write32_mask(rtwdev, 0x70, 0xff000000, 0x0e);
+	rtw_write32_mask(rtwdev, 0x1704, 0xffffffff, 0x7700);
+	rtw_write32_mask(rtwdev, 0x1700, 0xffffffff, 0xc00f0038);
+	rtw_write32_mask(rtwdev, 0x6c0, 0xffffffff, 0xaaaaaaaa);
+	rtw_write32_mask(rtwdev, 0x6c4, 0xffffffff, 0xaaaaaaaa);
+}
+
+#define WLAN_TXQ_RPT_EN		0x1F
+#define WLAN_SLOT_TIME		0x09
+#define WLAN_PIFS_TIME		0x1C
+#define WLAN_SIFS_CCK_CONT_TX	0x0A
+#define WLAN_SIFS_OFDM_CONT_TX	0x0E
+#define WLAN_SIFS_CCK_TRX	0x0A
+#define WLAN_SIFS_OFDM_TRX	0x10
+#define WLAN_NAV_MAX		0xC8
+#define WLAN_RDG_NAV		0x05
+#define WLAN_TXOP_NAV		0x1B
+#define WLAN_CCK_RX_TSF		0x30
+#define WLAN_OFDM_RX_TSF	0x30
+#define WLAN_TBTT_PROHIBIT	0x04 /* unit : 32us */
+#define WLAN_TBTT_HOLD_TIME	0x064 /* unit : 32us */
+#define WLAN_DRV_EARLY_INT	0x04
+#define WLAN_BCN_CTRL_CLT0	0x10
+#define WLAN_BCN_DMA_TIME	0x02
+#define WLAN_BCN_MAX_ERR	0xFF
+#define WLAN_SIFS_CCK_DUR_TUNE	0x0A
+#define WLAN_SIFS_OFDM_DUR_TUNE	0x10
+#define WLAN_SIFS_CCK_CTX	0x0A
+#define WLAN_SIFS_CCK_IRX	0x0A
+#define WLAN_SIFS_OFDM_CTX	0x0E
+#define WLAN_SIFS_OFDM_IRX	0x0E
+#define WLAN_EIFS_DUR_TUNE	0x40
+#define WLAN_EDCA_VO_PARAM	0x002FA226
+#define WLAN_EDCA_VI_PARAM	0x005EA328
+#define WLAN_EDCA_BE_PARAM	0x005EA42B
+#define WLAN_EDCA_BK_PARAM	0x0000A44F
+
+#define WLAN_RX_FILTER0		0xFFFFFFFF
+#define WLAN_RX_FILTER2		0xFFFF
+#define WLAN_RCR_CFG		0xE400220E
+#define WLAN_RXPKT_MAX_SZ	12288
+#define WLAN_RXPKT_MAX_SZ_512	(WLAN_RXPKT_MAX_SZ >> 9)
+
+#define WLAN_AMPDU_MAX_TIME		0x70
+#define WLAN_RTS_LEN_TH			0xFF
+#define WLAN_RTS_TX_TIME_TH		0x08
+#define WLAN_MAX_AGG_PKT_LIMIT		0x20
+#define WLAN_RTS_MAX_AGG_PKT_LIMIT	0x20
+#define WLAN_PRE_TXCNT_TIME_TH		0x1E0
+#define FAST_EDCA_VO_TH		0x06
+#define FAST_EDCA_VI_TH		0x06
+#define FAST_EDCA_BE_TH		0x06
+#define FAST_EDCA_BK_TH		0x06
+#define WLAN_BAR_RETRY_LIMIT		0x01
+#define WLAN_BAR_ACK_TYPE		0x05
+#define WLAN_RA_TRY_RATE_AGG_LIMIT	0x08
+#define WLAN_RESP_TXRATE		0x84
+#define WLAN_ACK_TO			0x21
+#define WLAN_ACK_TO_CCK			0x6A
+#define WLAN_DATA_RATE_FB_CNT_1_4	0x01000000
+#define WLAN_DATA_RATE_FB_CNT_5_8	0x08070504
+#define WLAN_RTS_RATE_FB_CNT_5_8	0x08070504
+#define WLAN_DATA_RATE_FB_RATE0		0xFE01F010
+#define WLAN_DATA_RATE_FB_RATE0_H	0x40000000
+#define WLAN_RTS_RATE_FB_RATE1		0x003FF010
+#define WLAN_RTS_RATE_FB_RATE1_H	0x40000000
+#define WLAN_RTS_RATE_FB_RATE4		0x0600F010
+#define WLAN_RTS_RATE_FB_RATE4_H	0x400003E0
+#define WLAN_RTS_RATE_FB_RATE5		0x0600F015
+#define WLAN_RTS_RATE_FB_RATE5_H	0x000000E0
+
+#define WLAN_TX_FUNC_CFG1		0x30
+#define WLAN_TX_FUNC_CFG2		0x30
+#define WLAN_MAC_OPT_NORM_FUNC1		0x98
+#define WLAN_MAC_OPT_LB_FUNC1		0x80
+#define WLAN_MAC_OPT_FUNC2		0x30810041
+
+#define WLAN_SIFS_CFG	(WLAN_SIFS_CCK_CONT_TX | \
+			(WLAN_SIFS_OFDM_CONT_TX << BIT_SHIFT_SIFS_OFDM_CTX) | \
+			(WLAN_SIFS_CCK_TRX << BIT_SHIFT_SIFS_CCK_TRX) | \
+			(WLAN_SIFS_OFDM_TRX << BIT_SHIFT_SIFS_OFDM_TRX))
+
+#define WLAN_SIFS_DUR_TUNE	(WLAN_SIFS_CCK_DUR_TUNE | \
+				(WLAN_SIFS_OFDM_DUR_TUNE << 8))
+
+#define WLAN_TBTT_TIME	(WLAN_TBTT_PROHIBIT |\
+			(WLAN_TBTT_HOLD_TIME << BIT_SHIFT_TBTT_HOLD_TIME_AP))
+
+#define WLAN_NAV_CFG		(WLAN_RDG_NAV | (WLAN_TXOP_NAV << 16))
+#define WLAN_RX_TSF_CFG		(WLAN_CCK_RX_TSF | (WLAN_OFDM_RX_TSF) << 8)
+
+#define MAC_CLK_SPEED	80 /* 80M */
+#define EFUSE_PCB_INFO_OFFSET	0xCA
+
+static int rtw8822c_mac_init(struct rtw_dev *rtwdev)
+{
+	u8 value8;
+	u16 value16;
+	u32 value32;
+	u16 pre_txcnt;
+
+	/* txq control */
+	value8 = rtw_read8(rtwdev, REG_FWHW_TXQ_CTRL);
+	value8 |= (BIT(7) & ~BIT(1) & ~BIT(2));
+	rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL, value8);
+	rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 1, WLAN_TXQ_RPT_EN);
+	/* sifs control */
+	rtw_write16(rtwdev, REG_SPEC_SIFS, WLAN_SIFS_DUR_TUNE);
+	rtw_write32(rtwdev, REG_SIFS, WLAN_SIFS_CFG);
+	rtw_write16(rtwdev, REG_RESP_SIFS_CCK,
+		    WLAN_SIFS_CCK_CTX | WLAN_SIFS_CCK_IRX << 8);
+	rtw_write16(rtwdev, REG_RESP_SIFS_OFDM,
+		    WLAN_SIFS_OFDM_CTX | WLAN_SIFS_OFDM_IRX << 8);
+	/* rate fallback control */
+	rtw_write32(rtwdev, REG_DARFRC, WLAN_DATA_RATE_FB_CNT_1_4);
+	rtw_write32(rtwdev, REG_DARFRCH, WLAN_DATA_RATE_FB_CNT_5_8);
+	rtw_write32(rtwdev, REG_RARFRCH, WLAN_RTS_RATE_FB_CNT_5_8);
+	rtw_write32(rtwdev, REG_ARFR0, WLAN_DATA_RATE_FB_RATE0);
+	rtw_write32(rtwdev, REG_ARFRH0, WLAN_DATA_RATE_FB_RATE0_H);
+	rtw_write32(rtwdev, REG_ARFR1_V1, WLAN_RTS_RATE_FB_RATE1);
+	rtw_write32(rtwdev, REG_ARFRH1_V1, WLAN_RTS_RATE_FB_RATE1_H);
+	rtw_write32(rtwdev, REG_ARFR4, WLAN_RTS_RATE_FB_RATE4);
+	rtw_write32(rtwdev, REG_ARFRH4, WLAN_RTS_RATE_FB_RATE4_H);
+	rtw_write32(rtwdev, REG_ARFR5, WLAN_RTS_RATE_FB_RATE5);
+	rtw_write32(rtwdev, REG_ARFRH5, WLAN_RTS_RATE_FB_RATE5_H);
+	/* protocol configuration */
+	rtw_write8(rtwdev, REG_AMPDU_MAX_TIME_V1, WLAN_AMPDU_MAX_TIME);
+	rtw_write8_set(rtwdev, REG_TX_HANG_CTRL, BIT_EN_EOF_V1);
+	pre_txcnt = WLAN_PRE_TXCNT_TIME_TH | BIT_EN_PRECNT;
+	rtw_write8(rtwdev, REG_PRECNT_CTRL, (u8)(pre_txcnt & 0xFF));
+	rtw_write8(rtwdev, REG_PRECNT_CTRL + 1, (u8)(pre_txcnt >> 8));
+	value32 = WLAN_RTS_LEN_TH | (WLAN_RTS_TX_TIME_TH << 8) |
+		  (WLAN_MAX_AGG_PKT_LIMIT << 16) |
+		  (WLAN_RTS_MAX_AGG_PKT_LIMIT << 24);
+	rtw_write32(rtwdev, REG_PROT_MODE_CTRL, value32);
+	rtw_write16(rtwdev, REG_BAR_MODE_CTRL + 2,
+		    WLAN_BAR_RETRY_LIMIT | WLAN_RA_TRY_RATE_AGG_LIMIT << 8);
+	rtw_write8(rtwdev, REG_FAST_EDCA_VOVI_SETTING, FAST_EDCA_VO_TH);
+	rtw_write8(rtwdev, REG_FAST_EDCA_VOVI_SETTING + 2, FAST_EDCA_VI_TH);
+	rtw_write8(rtwdev, REG_FAST_EDCA_BEBK_SETTING, FAST_EDCA_BE_TH);
+	rtw_write8(rtwdev, REG_FAST_EDCA_BEBK_SETTING + 2, FAST_EDCA_BK_TH);
+	/* close BA parser */
+	rtw_write8_clr(rtwdev, REG_LIFETIME_EN, BIT_BA_PARSER_EN);
+	rtw_write32_clr(rtwdev, REG_RRSR, BITS_RRSR_RSC);
+
+	/* EDCA configuration */
+	rtw_write32(rtwdev, REG_EDCA_VO_PARAM, WLAN_EDCA_VO_PARAM);
+	rtw_write32(rtwdev, REG_EDCA_VI_PARAM, WLAN_EDCA_VI_PARAM);
+	rtw_write32(rtwdev, REG_EDCA_BE_PARAM, WLAN_EDCA_BE_PARAM);
+	rtw_write32(rtwdev, REG_EDCA_BK_PARAM, WLAN_EDCA_BK_PARAM);
+	rtw_write8(rtwdev, REG_PIFS, WLAN_PIFS_TIME);
+	rtw_write8_clr(rtwdev, REG_TX_PTCL_CTRL + 1, BIT_SIFS_BK_EN >> 8);
+	rtw_write8_set(rtwdev, REG_RD_CTRL + 1,
+		       (BIT_DIS_TXOP_CFE | BIT_DIS_LSIG_CFE |
+			BIT_DIS_STBC_CFE) >> 8);
+
+	/* MAC clock configuration */
+	rtw_write32_clr(rtwdev, REG_AFE_CTRL1, BIT_MAC_CLK_SEL);
+	rtw_write8(rtwdev, REG_USTIME_TSF, MAC_CLK_SPEED);
+	rtw_write8(rtwdev, REG_USTIME_EDCA, MAC_CLK_SPEED);
+
+	rtw_write8_set(rtwdev, REG_MISC_CTRL,
+		       BIT_EN_FREE_CNT | BIT_DIS_SECOND_CCA);
+	rtw_write8_clr(rtwdev, REG_TIMER0_SRC_SEL, BIT_TSFT_SEL_TIMER0);
+	rtw_write16(rtwdev, REG_TXPAUSE, 0x0000);
+	rtw_write8(rtwdev, REG_SLOT, WLAN_SLOT_TIME);
+	rtw_write32(rtwdev, REG_RD_NAV_NXT, WLAN_NAV_CFG);
+	rtw_write16(rtwdev, REG_RXTSF_OFFSET_CCK, WLAN_RX_TSF_CFG);
+	/* Set beacon cotnrol - enable TSF and other related functions */
+	rtw_write8_set(rtwdev, REG_BCN_CTRL, BIT_EN_BCN_FUNCTION);
+	/* Set send beacon related registers */
+	rtw_write32(rtwdev, REG_TBTT_PROHIBIT, WLAN_TBTT_TIME);
+	rtw_write8(rtwdev, REG_DRVERLYINT, WLAN_DRV_EARLY_INT);
+	rtw_write8(rtwdev, REG_BCN_CTRL_CLINT0, WLAN_BCN_CTRL_CLT0);
+	rtw_write8(rtwdev, REG_BCNDMATIM, WLAN_BCN_DMA_TIME);
+	rtw_write8(rtwdev, REG_BCN_MAX_ERR, WLAN_BCN_MAX_ERR);
+
+	/* WMAC configuration */
+	rtw_write8(rtwdev, REG_BBPSF_CTRL + 2, WLAN_RESP_TXRATE);
+	rtw_write8(rtwdev, REG_ACKTO, WLAN_ACK_TO);
+	rtw_write8(rtwdev, REG_ACKTO_CCK, WLAN_ACK_TO_CCK);
+	rtw_write16(rtwdev, REG_EIFS, WLAN_EIFS_DUR_TUNE);
+	rtw_write8(rtwdev, REG_NAV_CTRL + 2, WLAN_NAV_MAX);
+	rtw_write8(rtwdev, REG_WMAC_TRXPTCL_CTL_H  + 2, WLAN_BAR_ACK_TYPE);
+	rtw_write32(rtwdev, REG_RXFLTMAP0, WLAN_RX_FILTER0);
+	rtw_write16(rtwdev, REG_RXFLTMAP2, WLAN_RX_FILTER2);
+	rtw_write32(rtwdev, REG_RCR, WLAN_RCR_CFG);
+	rtw_write8(rtwdev, REG_RX_PKT_LIMIT, WLAN_RXPKT_MAX_SZ_512);
+	rtw_write8(rtwdev, REG_TCR + 2, WLAN_TX_FUNC_CFG2);
+	rtw_write8(rtwdev, REG_TCR + 1, WLAN_TX_FUNC_CFG1);
+	rtw_write32_set(rtwdev, REG_GENERAL_OPTION, BIT_DUMMY_FCS_READY_MASK_EN);
+	rtw_write32(rtwdev, REG_WMAC_OPTION_FUNCTION + 8, WLAN_MAC_OPT_FUNC2);
+	rtw_write8(rtwdev, REG_WMAC_OPTION_FUNCTION_1, WLAN_MAC_OPT_NORM_FUNC1);
+
+	/* init low power */
+	value16 = rtw_read16(rtwdev, REG_RXPSF_CTRL + 2) & 0xF00F;
+	value16 |= (BIT_RXGCK_VHT_FIFOTHR(1) | BIT_RXGCK_HT_FIFOTHR(1) |
+		    BIT_RXGCK_OFDM_FIFOTHR(1) | BIT_RXGCK_CCK_FIFOTHR(1)) >> 16;
+	rtw_write16(rtwdev, REG_RXPSF_CTRL + 2, value16);
+	value16 = 0;
+	value16 = BIT_SET_RXPSF_PKTLENTHR(value16, 1);
+	value16 |= BIT_RXPSF_CTRLEN | BIT_RXPSF_VHTCHKEN | BIT_RXPSF_HTCHKEN
+		| BIT_RXPSF_OFDMCHKEN | BIT_RXPSF_CCKCHKEN
+		| BIT_RXPSF_OFDMRST;
+	rtw_write16(rtwdev, REG_RXPSF_CTRL, value16);
+	rtw_write32(rtwdev, REG_RXPSF_TYPE_CTRL, 0xFFFFFFFF);
+	/* rx ignore configuration */
+	value16 = rtw_read16(rtwdev, REG_RXPSF_CTRL);
+	value16 &= ~(BIT_RXPSF_MHCHKEN | BIT_RXPSF_CCKRST |
+		     BIT_RXPSF_CONT_ERRCHKEN);
+	value16 = BIT_SET_RXPSF_ERRTHR(value16, 0x07);
+	rtw_write16(rtwdev, REG_RXPSF_CTRL, value16);
+
+	return 0;
+}
+
+static void rtw8822c_set_channel_rf(struct rtw_dev *rtwdev, u8 channel, u8 bw)
+{
+#define RF18_BAND_MASK		(BIT(16) | BIT(9) | BIT(8))
+#define RF18_BAND_2G		(0)
+#define RF18_BAND_5G		(BIT(16) | BIT(8))
+#define RF18_CHANNEL_MASK	(MASKBYTE0)
+#define RF18_RFSI_MASK		(BIT(18) | BIT(17))
+#define RF18_RFSI_GE_CH80	(BIT(17))
+#define RF18_RFSI_GT_CH140	(BIT(18))
+#define RF18_BW_MASK		(BIT(13) | BIT(12))
+#define RF18_BW_20M		(BIT(13) | BIT(12))
+#define RF18_BW_40M		(BIT(13))
+#define RF18_BW_80M		(BIT(12))
+
+	u32 rf_reg18 = 0;
+	u32 rf_rxbb = 0;
+
+	rf_reg18 = rtw_read_rf(rtwdev, RF_PATH_A, 0x18, RFREG_MASK);
+
+	rf_reg18 &= ~(RF18_BAND_MASK | RF18_CHANNEL_MASK | RF18_RFSI_MASK |
+		      RF18_BW_MASK);
+
+	rf_reg18 |= (channel <= 14 ? RF18_BAND_2G : RF18_BAND_5G);
+	rf_reg18 |= (channel & RF18_CHANNEL_MASK);
+	if (channel > 144)
+		rf_reg18 |= RF18_RFSI_GT_CH140;
+	else if (channel >= 80)
+		rf_reg18 |= RF18_RFSI_GE_CH80;
+
+	switch (bw) {
+	case RTW_CHANNEL_WIDTH_5:
+	case RTW_CHANNEL_WIDTH_10:
+	case RTW_CHANNEL_WIDTH_20:
+	default:
+		rf_reg18 |= RF18_BW_20M;
+		rf_rxbb = 0x18;
+		break;
+	case RTW_CHANNEL_WIDTH_40:
+		/* RF bandwidth */
+		rf_reg18 |= RF18_BW_40M;
+		rf_rxbb = 0x10;
+		break;
+	case RTW_CHANNEL_WIDTH_80:
+		rf_reg18 |= RF18_BW_80M;
+		rf_rxbb = 0x8;
+		break;
+	}
+
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWE2, 0x04, 0x01);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWA, 0x1f, 0x12);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWD0, 0xfffff, rf_rxbb);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWE2, 0x04, 0x00);
+
+	rtw_write_rf(rtwdev, RF_PATH_B, RF_LUTWE2, 0x04, 0x01);
+	rtw_write_rf(rtwdev, RF_PATH_B, RF_LUTWA, 0x1f, 0x12);
+	rtw_write_rf(rtwdev, RF_PATH_B, RF_LUTWD0, 0xfffff, rf_rxbb);
+	rtw_write_rf(rtwdev, RF_PATH_B, RF_LUTWE2, 0x04, 0x00);
+
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_CFGCH, RFREG_MASK, rf_reg18);
+	rtw_write_rf(rtwdev, RF_PATH_B, RF_CFGCH, RFREG_MASK, rf_reg18);
+}
+
+static void rtw8822c_toggle_igi(struct rtw_dev *rtwdev)
+{
+	u32 igi;
+
+	igi = rtw_read32_mask(rtwdev, REG_RXIGI, 0x7f);
+	rtw_write32_mask(rtwdev, REG_RXIGI, 0x7f, igi - 2);
+	rtw_write32_mask(rtwdev, REG_RXIGI, 0x7f00, igi - 2);
+	rtw_write32_mask(rtwdev, REG_RXIGI, 0x7f, igi);
+	rtw_write32_mask(rtwdev, REG_RXIGI, 0x7f00, igi);
+}
+
+static void rtw8822c_set_channel_bb(struct rtw_dev *rtwdev, u8 channel, u8 bw,
+				    u8 primary_ch_idx)
+{
+	if (channel <= 14) {
+		rtw_write32_clr(rtwdev, REG_BGCTRL, BITS_RX_IQ_WEIGHT);
+		rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0xf0000000, 0x8);
+		rtw_write32_set(rtwdev, REG_TXF4, BIT(20));
+		rtw_write32_clr(rtwdev, REG_CCK_CHECK, BIT_CHECK_CCK_EN);
+		rtw_write32_clr(rtwdev, REG_CCKTXONLY, BIT_BB_CCK_CHECK_EN);
+		rtw_write32_mask(rtwdev, REG_CCAMSK, 0x3F000000, 0xF);
+
+		rtw_write32_mask(rtwdev, REG_RXAGCCTL0, 0x1f0, 0x0);
+		rtw_write32_mask(rtwdev, REG_RXAGCCTL, 0x1f0, 0x0);
+		if (channel == 13 || channel == 14)
+			rtw_write32_mask(rtwdev, REG_SCOTRK, 0xfff, 0x969);
+		else if (channel == 11 || channel == 12)
+			rtw_write32_mask(rtwdev, REG_SCOTRK, 0xfff, 0x96a);
+		else
+			rtw_write32_mask(rtwdev, REG_SCOTRK, 0xfff, 0x9aa);
+		if (channel == 14) {
+			rtw_write32_mask(rtwdev, REG_TXF0, MASKHWORD, 0x3da0);
+			rtw_write32_mask(rtwdev, REG_TXF1, MASKDWORD,
+					 0x4962c931);
+			rtw_write32_mask(rtwdev, REG_TXF2, MASKLWORD, 0x6aa3);
+			rtw_write32_mask(rtwdev, REG_TXF3, MASKHWORD, 0xaa7b);
+			rtw_write32_mask(rtwdev, REG_TXF4, MASKLWORD, 0xf3d7);
+			rtw_write32_mask(rtwdev, REG_TXF5, MASKDWORD, 0x0);
+			rtw_write32_mask(rtwdev, REG_TXF6, MASKDWORD,
+					 0xff012455);
+			rtw_write32_mask(rtwdev, REG_TXF7, MASKDWORD, 0xffff);
+		} else {
+			rtw_write32_mask(rtwdev, REG_TXF0, MASKHWORD, 0x5284);
+			rtw_write32_mask(rtwdev, REG_TXF1, MASKDWORD,
+					 0x3e18fec8);
+			rtw_write32_mask(rtwdev, REG_TXF2, MASKLWORD, 0x0a88);
+			rtw_write32_mask(rtwdev, REG_TXF3, MASKHWORD, 0xacc4);
+			rtw_write32_mask(rtwdev, REG_TXF4, MASKLWORD, 0xc8b2);
+			rtw_write32_mask(rtwdev, REG_TXF5, MASKDWORD,
+					 0x00faf0de);
+			rtw_write32_mask(rtwdev, REG_TXF6, MASKDWORD,
+					 0x00122344);
+			rtw_write32_mask(rtwdev, REG_TXF7, MASKDWORD,
+					 0x0fffffff);
+		}
+		if (channel == 13)
+			rtw_write32_mask(rtwdev, REG_TXDFIR0, 0x70, 0x3);
+		else
+			rtw_write32_mask(rtwdev, REG_TXDFIR0, 0x70, 0x1);
+	} else if (channel > 35) {
+		rtw_write32_set(rtwdev, REG_CCKTXONLY, BIT_BB_CCK_CHECK_EN);
+		rtw_write32_set(rtwdev, REG_CCK_CHECK, BIT_CHECK_CCK_EN);
+		rtw_write32_set(rtwdev, REG_BGCTRL, BITS_RX_IQ_WEIGHT);
+		rtw_write32_clr(rtwdev, REG_TXF4, BIT(20));
+		rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0xf0000000, 0x0);
+		rtw_write32_mask(rtwdev, REG_CCAMSK, 0x3F000000, 0x22);
+		rtw_write32_mask(rtwdev, REG_TXDFIR0, 0x70, 0x3);
+		if (channel >= 36 && channel <= 64) {
+			rtw_write32_mask(rtwdev, REG_RXAGCCTL0, 0x1f0, 0x1);
+			rtw_write32_mask(rtwdev, REG_RXAGCCTL, 0x1f0, 0x1);
+		} else if (channel >= 100 && channel <= 144) {
+			rtw_write32_mask(rtwdev, REG_RXAGCCTL0, 0x1f0, 0x2);
+			rtw_write32_mask(rtwdev, REG_RXAGCCTL, 0x1f0, 0x2);
+		} else if (channel >= 149) {
+			rtw_write32_mask(rtwdev, REG_RXAGCCTL0, 0x1f0, 0x3);
+			rtw_write32_mask(rtwdev, REG_RXAGCCTL, 0x1f0, 0x3);
+		}
+
+		if (channel >= 36 && channel <= 51)
+			rtw_write32_mask(rtwdev, REG_SCOTRK, 0xfff, 0x494);
+		else if (channel >= 52 && channel <= 55)
+			rtw_write32_mask(rtwdev, REG_SCOTRK, 0xfff, 0x493);
+		else if (channel >= 56 && channel <= 111)
+			rtw_write32_mask(rtwdev, REG_SCOTRK, 0xfff, 0x453);
+		else if (channel >= 112 && channel <= 119)
+			rtw_write32_mask(rtwdev, REG_SCOTRK, 0xfff, 0x452);
+		else if (channel >= 120 && channel <= 172)
+			rtw_write32_mask(rtwdev, REG_SCOTRK, 0xfff, 0x412);
+		else if (channel >= 173 && channel <= 177)
+			rtw_write32_mask(rtwdev, REG_SCOTRK, 0xfff, 0x411);
+	}
+
+	switch (bw) {
+	case RTW_CHANNEL_WIDTH_20:
+		rtw_write32_mask(rtwdev, REG_DFIRBW, 0x3FF0, 0x19B);
+		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xf, 0x0);
+		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xffc0, 0x0);
+		rtw_write32_mask(rtwdev, REG_TXCLK, 0x700, 0x7);
+		rtw_write32_mask(rtwdev, REG_TXCLK, 0x700000, 0x6);
+		break;
+	case RTW_CHANNEL_WIDTH_40:
+		rtw_write32_mask(rtwdev, REG_CCKSB, BIT(4),
+				 (primary_ch_idx == 1 ? 1 : 0));
+		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xf, 0x5);
+		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xc0, 0x0);
+		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xff00,
+				 (primary_ch_idx | (primary_ch_idx << 4)));
+		break;
+	case RTW_CHANNEL_WIDTH_80:
+		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xf, 0xa);
+		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xc0, 0x0);
+		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xff00,
+				 (primary_ch_idx | (primary_ch_idx << 4)));
+		break;
+	case RTW_CHANNEL_WIDTH_5:
+		rtw_write32_mask(rtwdev, REG_DFIRBW, 0x3FF0, 0x2AB);
+		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xf, 0x0);
+		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xffc0, 0x1);
+		rtw_write32_mask(rtwdev, REG_TXCLK, 0x700, 0x4);
+		rtw_write32_mask(rtwdev, REG_TXCLK, 0x700000, 0x4);
+		break;
+	case RTW_CHANNEL_WIDTH_10:
+		rtw_write32_mask(rtwdev, REG_DFIRBW, 0x3FF0, 0x2AB);
+		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xf, 0x0);
+		rtw_write32_mask(rtwdev, REG_TXBWCTL, 0xffc0, 0x2);
+		rtw_write32_mask(rtwdev, REG_TXCLK, 0x700, 0x6);
+		rtw_write32_mask(rtwdev, REG_TXCLK, 0x700000, 0x5);
+		break;
+	}
+}
+
+static void rtw8822c_set_channel(struct rtw_dev *rtwdev, u8 channel, u8 bw,
+				 u8 primary_chan_idx)
+{
+	rtw8822c_set_channel_bb(rtwdev, channel, bw, primary_chan_idx);
+	rtw_set_channel_mac(rtwdev, channel, bw, primary_chan_idx);
+	rtw8822c_set_channel_rf(rtwdev, channel, bw);
+	rtw8822c_toggle_igi(rtwdev);
+}
+
+static void rtw8822c_config_cck_rx_path(struct rtw_dev *rtwdev, u8 rx_path)
+{
+	if (rx_path == BB_PATH_A || rx_path == BB_PATH_B) {
+		rtw_write32_mask(rtwdev, REG_CCANRX, 0x00060000, 0x0);
+		rtw_write32_mask(rtwdev, REG_CCANRX, 0x00600000, 0x0);
+	} else if (rx_path == BB_PATH_AB) {
+		rtw_write32_mask(rtwdev, REG_CCANRX, 0x00600000, 0x1);
+		rtw_write32_mask(rtwdev, REG_CCANRX, 0x00060000, 0x1);
+	}
+
+	if (rx_path == BB_PATH_A)
+		rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0x0f000000, 0x0);
+	else if (rx_path == BB_PATH_B)
+		rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0x0f000000, 0x5);
+	else if (rx_path == BB_PATH_AB)
+		rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0x0f000000, 0x1);
+}
+
+static void rtw8822c_config_ofdm_rx_path(struct rtw_dev *rtwdev, u8 rx_path)
+{
+	if (rx_path == BB_PATH_A || rx_path == BB_PATH_B) {
+		rtw_write32_mask(rtwdev, REG_RXFNCTL, 0x300, 0x0);
+		rtw_write32_mask(rtwdev, REG_RXFNCTL, 0x600000, 0x0);
+		rtw_write32_mask(rtwdev, REG_AGCSWSH, BIT(17), 0x0);
+		rtw_write32_mask(rtwdev, REG_ANTWTPD, BIT(20), 0x0);
+		rtw_write32_mask(rtwdev, REG_MRCM, BIT(24), 0x0);
+	} else if (rx_path == BB_PATH_AB) {
+		rtw_write32_mask(rtwdev, REG_RXFNCTL, 0x300, 0x1);
+		rtw_write32_mask(rtwdev, REG_RXFNCTL, 0x600000, 0x1);
+		rtw_write32_mask(rtwdev, REG_AGCSWSH, BIT(17), 0x1);
+		rtw_write32_mask(rtwdev, REG_ANTWTPD, BIT(20), 0x1);
+		rtw_write32_mask(rtwdev, REG_MRCM, BIT(24), 0x1);
+	}
+
+	rtw_write32_mask(rtwdev, 0x824, 0x0f000000, rx_path);
+	rtw_write32_mask(rtwdev, 0x824, 0x000f0000, rx_path);
+}
+
+static void rtw8822c_config_rx_path(struct rtw_dev *rtwdev, u8 rx_path)
+{
+	rtw8822c_config_cck_rx_path(rtwdev, rx_path);
+	rtw8822c_config_ofdm_rx_path(rtwdev, rx_path);
+}
+
+static void rtw8822c_config_cck_tx_path(struct rtw_dev *rtwdev, u8 tx_path,
+					bool is_tx2_path)
+{
+	if (tx_path == BB_PATH_A) {
+		rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0xf0000000, 0x8);
+	} else if (tx_path == BB_PATH_B) {
+		rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0xf0000000, 0x4);
+	} else {
+		if (is_tx2_path)
+			rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0xf0000000, 0xc);
+		else
+			rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0xf0000000, 0x8);
+	}
+}
+
+static void rtw8822c_config_ofdm_tx_path(struct rtw_dev *rtwdev, u8 tx_path,
+					 bool is_tx2_path)
+{
+	if (tx_path == BB_PATH_A) {
+		rtw_write32_mask(rtwdev, REG_ANTMAP0, 0xff, 0x11);
+		rtw_write32_mask(rtwdev, REG_TXLGMAP, 0xff, 0x0);
+	} else if (tx_path == BB_PATH_B) {
+		rtw_write32_mask(rtwdev, REG_ANTMAP0, 0xff, 0x12);
+		rtw_write32_mask(rtwdev, REG_TXLGMAP, 0xff, 0x0);
+	} else {
+		if (is_tx2_path) {
+			rtw_write32_mask(rtwdev, REG_ANTMAP0, 0xff, 0x33);
+			rtw_write32_mask(rtwdev, REG_TXLGMAP, 0xffff, 0x0404);
+		} else {
+			rtw_write32_mask(rtwdev, REG_ANTMAP0, 0xff, 0x31);
+			rtw_write32_mask(rtwdev, REG_TXLGMAP, 0xffff, 0x0400);
+		}
+	}
+}
+
+static void rtw8822c_config_tx_path(struct rtw_dev *rtwdev, u8 tx_path,
+				    bool is_tx2_path)
+{
+	rtw8822c_config_cck_tx_path(rtwdev, tx_path, is_tx2_path);
+	rtw8822c_config_ofdm_tx_path(rtwdev, tx_path, is_tx2_path);
+}
+
+static void rtw8822c_config_trx_mode(struct rtw_dev *rtwdev, u8 tx_path,
+				     u8 rx_path, bool is_tx2_path)
+{
+	if ((tx_path | rx_path) & BB_PATH_A)
+		rtw_write32_mask(rtwdev, REG_ORITXCODE, MASK20BITS, 0x33312);
+	else
+		rtw_write32_mask(rtwdev, REG_ORITXCODE, MASK20BITS, 0x11111);
+	if ((tx_path | rx_path) & BB_PATH_B)
+		rtw_write32_mask(rtwdev, REG_ORITXCODE2, MASK20BITS, 0x33312);
+	else
+		rtw_write32_mask(rtwdev, REG_ORITXCODE2, MASK20BITS, 0x11111);
+
+	rtw8822c_config_rx_path(rtwdev, rx_path);
+	rtw8822c_config_tx_path(rtwdev, tx_path, is_tx2_path);
+
+	rtw8822c_toggle_igi(rtwdev);
+}
+
+static void query_phy_status_page0(struct rtw_dev *rtwdev, u8 *phy_status,
+				   struct rtw_rx_pkt_stat *pkt_stat)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	u8 l_bnd, u_bnd;
+	u8 gain_a, gain_b;
+	s8 rx_power[RTW_RF_PATH_MAX];
+	s8 min_rx_power = -120;
+
+	rx_power[RF_PATH_A] = GET_PHY_STAT_P0_PWDB_A(phy_status);
+	rx_power[RF_PATH_B] = GET_PHY_STAT_P0_PWDB_B(phy_status);
+	l_bnd = dm_info->cck_gi_l_bnd;
+	u_bnd = dm_info->cck_gi_u_bnd;
+	gain_a = GET_PHY_STAT_P0_GAIN_A(phy_status);
+	gain_b = GET_PHY_STAT_P0_GAIN_B(phy_status);
+	if (gain_a < l_bnd)
+		rx_power[RF_PATH_A] += (l_bnd - gain_a) << 1;
+	else if (gain_a > u_bnd)
+		rx_power[RF_PATH_A] -= (gain_a - u_bnd) << 1;
+	if (gain_b < l_bnd)
+		rx_power[RF_PATH_A] += (l_bnd - gain_b) << 1;
+	else if (gain_b > u_bnd)
+		rx_power[RF_PATH_A] -= (gain_b - u_bnd) << 1;
+
+	rx_power[RF_PATH_A] -= 110;
+	rx_power[RF_PATH_B] -= 110;
+
+	pkt_stat->rx_power[RF_PATH_A] = max3(rx_power[RF_PATH_A],
+					     rx_power[RF_PATH_B],
+					     min_rx_power);
+	pkt_stat->rssi = rtw_phy_rf_power_2_rssi(pkt_stat->rx_power, 1);
+	pkt_stat->bw = RTW_CHANNEL_WIDTH_20;
+	pkt_stat->signal_power = max(pkt_stat->rx_power[RF_PATH_A],
+				     min_rx_power);
+}
+
+static void query_phy_status_page1(struct rtw_dev *rtwdev, u8 *phy_status,
+				   struct rtw_rx_pkt_stat *pkt_stat)
+{
+	u8 rxsc, bw;
+	s8 min_rx_power = -120;
+
+	if (pkt_stat->rate > DESC_RATE11M && pkt_stat->rate < DESC_RATEMCS0)
+		rxsc = GET_PHY_STAT_P1_L_RXSC(phy_status);
+	else
+		rxsc = GET_PHY_STAT_P1_HT_RXSC(phy_status);
+
+	if (rxsc >= 9 && rxsc <= 12)
+		bw = RTW_CHANNEL_WIDTH_40;
+	else if (rxsc >= 13)
+		bw = RTW_CHANNEL_WIDTH_80;
+	else
+		bw = RTW_CHANNEL_WIDTH_20;
+
+	pkt_stat->rx_power[RF_PATH_A] = GET_PHY_STAT_P1_PWDB_A(phy_status) - 110;
+	pkt_stat->rx_power[RF_PATH_B] = GET_PHY_STAT_P1_PWDB_B(phy_status) - 110;
+	pkt_stat->rssi = rtw_phy_rf_power_2_rssi(pkt_stat->rx_power, 2);
+	pkt_stat->bw = bw;
+	pkt_stat->signal_power = max3(pkt_stat->rx_power[RF_PATH_A],
+				      pkt_stat->rx_power[RF_PATH_B],
+				      min_rx_power);
+}
+
+static void query_phy_status(struct rtw_dev *rtwdev, u8 *phy_status,
+			     struct rtw_rx_pkt_stat *pkt_stat)
+{
+	u8 page;
+
+	page = *phy_status & 0xf;
+
+	switch (page) {
+	case 0:
+		query_phy_status_page0(rtwdev, phy_status, pkt_stat);
+		break;
+	case 1:
+		query_phy_status_page1(rtwdev, phy_status, pkt_stat);
+		break;
+	default:
+		rtw_warn(rtwdev, "unused phy status page (%d)\n", page);
+		return;
+	}
+}
+
+static void rtw8822c_query_rx_desc(struct rtw_dev *rtwdev, u8 *rx_desc,
+				   struct rtw_rx_pkt_stat *pkt_stat,
+				   struct ieee80211_rx_status *rx_status)
+{
+	struct ieee80211_hdr *hdr;
+	u32 desc_sz = rtwdev->chip->rx_pkt_desc_sz;
+	u8 *phy_status = NULL;
+
+	memset(pkt_stat, 0, sizeof(*pkt_stat));
+
+	pkt_stat->phy_status = GET_RX_DESC_PHYST(rx_desc);
+	pkt_stat->icv_err = GET_RX_DESC_ICV_ERR(rx_desc);
+	pkt_stat->crc_err = GET_RX_DESC_CRC32(rx_desc);
+	pkt_stat->decrypted = !GET_RX_DESC_SWDEC(rx_desc);
+	pkt_stat->is_c2h = GET_RX_DESC_C2H(rx_desc);
+	pkt_stat->pkt_len = GET_RX_DESC_PKT_LEN(rx_desc);
+	pkt_stat->drv_info_sz = GET_RX_DESC_DRV_INFO_SIZE(rx_desc);
+	pkt_stat->shift = GET_RX_DESC_SHIFT(rx_desc);
+	pkt_stat->rate = GET_RX_DESC_RX_RATE(rx_desc);
+	pkt_stat->cam_id = GET_RX_DESC_MACID(rx_desc);
+	pkt_stat->ppdu_cnt = GET_RX_DESC_PPDU_CNT(rx_desc);
+	pkt_stat->tsf_low = GET_RX_DESC_TSFL(rx_desc);
+
+	/* drv_info_sz is in unit of 8-bytes */
+	pkt_stat->drv_info_sz *= 8;
+
+	/* c2h cmd pkt's rx/phy status is not interested */
+	if (pkt_stat->is_c2h)
+		return;
+
+	hdr = (struct ieee80211_hdr *)(rx_desc + desc_sz + pkt_stat->shift +
+				       pkt_stat->drv_info_sz);
+	if (pkt_stat->phy_status) {
+		phy_status = rx_desc + desc_sz + pkt_stat->shift;
+		query_phy_status(rtwdev, phy_status, pkt_stat);
+	}
+
+	rtw_rx_fill_rx_status(rtwdev, pkt_stat, hdr, rx_status, phy_status);
+}
+
+static void
+rtw8822c_set_write_tx_power_ref(struct rtw_dev *rtwdev, u8 *tx_pwr_ref_cck,
+				u8 *tx_pwr_ref_ofdm)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	u32 txref_cck[2] = {0x18a0, 0x41a0};
+	u32 txref_ofdm[2] = {0x18e8, 0x41e8};
+	u8 path;
+
+	for (path = 0; path < hal->rf_path_num; path++) {
+		rtw_write32_mask(rtwdev, 0x1c90, BIT(15), 0);
+		rtw_write32_mask(rtwdev, txref_cck[path], 0x7f0000,
+				 tx_pwr_ref_cck[path]);
+	}
+	for (path = 0; path < hal->rf_path_num; path++) {
+		rtw_write32_mask(rtwdev, 0x1c90, BIT(15), 0);
+		rtw_write32_mask(rtwdev, txref_ofdm[path], 0x1fc00,
+				 tx_pwr_ref_ofdm[path]);
+	}
+}
+
+static void rtw8822c_set_tx_power_diff(struct rtw_dev *rtwdev, u8 rate,
+				       s8 *diff_idx)
+{
+	u32 offset_txagc = 0x3a00;
+	u8 rate_idx = rate & 0xfc;
+	u8 pwr_idx[4];
+	u32 phy_pwr_idx;
+	int i;
+
+	for (i = 0; i < 4; i++)
+		pwr_idx[i] = diff_idx[i] & 0x7f;
+
+	phy_pwr_idx = pwr_idx[0] |
+		      (pwr_idx[1] << 8) |
+		      (pwr_idx[2] << 16) |
+		      (pwr_idx[3] << 24);
+
+	rtw_write32_mask(rtwdev, 0x1c90, BIT(15), 0x0);
+	rtw_write32_mask(rtwdev, offset_txagc + rate_idx, MASKDWORD,
+			 phy_pwr_idx);
+}
+
+static void rtw8822c_set_tx_power_index(struct rtw_dev *rtwdev)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	u8 rs, rate, j;
+	u8 pwr_ref_cck[2] = {hal->tx_pwr_tbl[RF_PATH_A][DESC_RATE11M],
+			     hal->tx_pwr_tbl[RF_PATH_B][DESC_RATE11M]};
+	u8 pwr_ref_ofdm[2] = {hal->tx_pwr_tbl[RF_PATH_A][DESC_RATEMCS7],
+			      hal->tx_pwr_tbl[RF_PATH_B][DESC_RATEMCS7]};
+	s8 diff_a, diff_b;
+	u8 pwr_a, pwr_b;
+	s8 diff_idx[4];
+
+	rtw8822c_set_write_tx_power_ref(rtwdev, pwr_ref_cck, pwr_ref_ofdm);
+	for (rs = 0; rs < RTW_RATE_SECTION_MAX; rs++) {
+		for (j = 0; j < rate_size[rs]; j++) {
+			rate = rate_section[rs][j];
+			pwr_a = hal->tx_pwr_tbl[RF_PATH_A][rate];
+			pwr_b = hal->tx_pwr_tbl[RF_PATH_B][rate];
+			if (rs == 0) {
+				diff_a = (s8)pwr_a - (s8)pwr_ref_cck[0];
+				diff_b = (s8)pwr_b - (s8)pwr_ref_cck[1];
+			} else {
+				diff_a = (s8)pwr_a - (s8)pwr_ref_ofdm[0];
+				diff_b = (s8)pwr_b - (s8)pwr_ref_ofdm[1];
+			}
+			diff_idx[rate % 4] = min(diff_a, diff_b);
+			if (rate % 4 == 3)
+				rtw8822c_set_tx_power_diff(rtwdev, rate - 3,
+							   diff_idx);
+		}
+	}
+}
+
+static void rtw8822c_cfg_ldo25(struct rtw_dev *rtwdev, bool enable)
+{
+	u8 ldo_pwr;
+
+	ldo_pwr = rtw_read8(rtwdev, REG_ANAPARLDO_POW_MAC);
+	ldo_pwr = enable ? ldo_pwr | BIT_LDOE25_PON : ldo_pwr & ~BIT_LDOE25_PON;
+	rtw_write8(rtwdev, REG_ANAPARLDO_POW_MAC, ldo_pwr);
+}
+
+static void rtw8822c_false_alarm_statistics(struct rtw_dev *rtwdev)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	u32 cck_enable;
+	u32 cck_fa_cnt;
+	u32 ofdm_fa_cnt;
+	u32 ofdm_tx_counter;
+
+	cck_enable = rtw_read32(rtwdev, REG_ENCCK) & BIT_CCK_BLK_EN;
+	cck_fa_cnt = rtw_read16(rtwdev, REG_CCK_FACNT);
+	ofdm_fa_cnt = rtw_read16(rtwdev, REG_OFDM_FACNT);
+	ofdm_tx_counter = rtw_read16(rtwdev, REG_OFDM_TXCNT);
+	ofdm_fa_cnt -= ofdm_tx_counter;
+
+	dm_info->cck_fa_cnt = cck_fa_cnt;
+	dm_info->ofdm_fa_cnt = ofdm_fa_cnt;
+	dm_info->total_fa_cnt = ofdm_fa_cnt;
+	dm_info->total_fa_cnt += cck_enable ? cck_fa_cnt : 0;
+
+	rtw_write32_mask(rtwdev, REG_CCANRX, BIT_CCK_FA_RST, 0);
+	rtw_write32_mask(rtwdev, REG_CCANRX, BIT_CCK_FA_RST, 2);
+	rtw_write32_mask(rtwdev, REG_CCANRX, BIT_OFDM_FA_RST, 0);
+	rtw_write32_mask(rtwdev, REG_CCANRX, BIT_OFDM_FA_RST, 2);
+	rtw_write32_set(rtwdev, REG_CNT_CTRL, BIT_ALL_CNT_RST);
+	rtw_write32_clr(rtwdev, REG_CNT_CTRL, BIT_ALL_CNT_RST);
+}
+
+static void rtw8822c_do_iqk(struct rtw_dev *rtwdev)
+{
+}
+
+static struct rtw_pwr_seq_cmd trans_carddis_to_cardemu_8822c[] = {
+	{0x0086,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_SDIO,
+	 RTW_PWR_CMD_WRITE, BIT(0), 0},
+	{0x0086,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_SDIO,
+	 RTW_PWR_CMD_POLLING, BIT(1), BIT(1)},
+	{0x002E,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(2), BIT(2)},
+	{0x002D,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), 0},
+	{0x007F,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(7), 0},
+	{0x004A,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), 0},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(3) | BIT(4) | BIT(7), 0},
+	{0xFFFF,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 0,
+	 RTW_PWR_CMD_END, 0, 0},
+};
+
+static struct rtw_pwr_seq_cmd trans_cardemu_to_act_8822c[] = {
+	{0x0000,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(5), 0},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, (BIT(4) | BIT(3) | BIT(2)), 0},
+	{0x0075,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0006,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_POLLING, BIT(1), BIT(1)},
+	{0x0075,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), 0},
+	{0xFF1A,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0},
+	{0x002E,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(3), 0},
+	{0x0006,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(7), 0},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, (BIT(4) | BIT(3)), 0},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_POLLING, BIT(0), 0},
+	{0x0074,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(5), BIT(5)},
+	{0x0071,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(4), 0},
+	{0x0062,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, (BIT(7) | BIT(6) | BIT(5)),
+	 (BIT(7) | BIT(6) | BIT(5))},
+	{0x0061,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, (BIT(7) | BIT(6) | BIT(5)), 0},
+	{0x001F,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, (BIT(7) | BIT(6)), BIT(7)},
+	{0x00EF,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, (BIT(7) | BIT(6)), BIT(7)},
+	{0x1045,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(4), BIT(4)},
+	{0x0010,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(2), BIT(2)},
+	{0xFFFF,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 0,
+	 RTW_PWR_CMD_END, 0, 0},
+};
+
+static struct rtw_pwr_seq_cmd trans_act_to_cardemu_8822c[] = {
+	{0x0093,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(3), 0},
+	{0x001F,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0},
+	{0x00EF,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0},
+	{0x1045,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(4), 0},
+	{0xFF1A,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0x30},
+	{0x0049,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), 0},
+	{0x0006,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0x0002,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), 0},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), BIT(1)},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_POLLING, BIT(1), 0},
+	{0x0000,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(5), BIT(5)},
+	{0xFFFF,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 0,
+	 RTW_PWR_CMD_END, 0, 0},
+};
+
+static struct rtw_pwr_seq_cmd trans_cardemu_to_carddis_8822c[] = {
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(7), BIT(7)},
+	{0x0007,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, 0xFF, 0x00},
+	{0x0067,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(5), 0},
+	{0x004A,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(0), 0},
+	{0x0081,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(7) | BIT(6), 0},
+	{0x0090,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(1), 0},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_USB_MSK | RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(3) | BIT(4), BIT(3)},
+	{0x0005,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_PCI_MSK,
+	 RTW_PWR_ADDR_MAC,
+	 RTW_PWR_CMD_WRITE, BIT(2), BIT(2)},
+	{0x0086,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_SDIO_MSK,
+	 RTW_PWR_ADDR_SDIO,
+	 RTW_PWR_CMD_WRITE, BIT(0), BIT(0)},
+	{0xFFFF,
+	 RTW_PWR_CUT_ALL_MSK,
+	 RTW_PWR_INTF_ALL_MSK,
+	 0,
+	 RTW_PWR_CMD_END, 0, 0},
+};
+
+static struct rtw_pwr_seq_cmd *card_enable_flow_8822c[] = {
+	trans_carddis_to_cardemu_8822c,
+	trans_cardemu_to_act_8822c,
+	NULL
+};
+
+static struct rtw_pwr_seq_cmd *card_disable_flow_8822c[] = {
+	trans_act_to_cardemu_8822c,
+	trans_cardemu_to_carddis_8822c,
+	NULL
+};
+
+static struct rtw_intf_phy_para usb2_param_8822c[] = {
+	{0xFFFF, 0x00,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_ALL,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+};
+
+static struct rtw_intf_phy_para usb3_param_8822c[] = {
+	{0xFFFF, 0x0000,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_ALL,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+};
+
+static struct rtw_intf_phy_para pcie_gen1_param_8822c[] = {
+	{0xFFFF, 0x0000,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_ALL,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+};
+
+static struct rtw_intf_phy_para pcie_gen2_param_8822c[] = {
+	{0xFFFF, 0x0000,
+	 RTW_IP_SEL_PHY,
+	 RTW_INTF_PHY_CUT_ALL,
+	 RTW_INTF_PHY_PLATFORM_ALL},
+};
+
+static struct rtw_intf_phy_para_table phy_para_table_8822c = {
+	.usb2_para	= usb2_param_8822c,
+	.usb3_para	= usb3_param_8822c,
+	.gen1_para	= pcie_gen1_param_8822c,
+	.gen2_para	= pcie_gen2_param_8822c,
+	.n_usb2_para	= ARRAY_SIZE(usb2_param_8822c),
+	.n_usb3_para	= ARRAY_SIZE(usb2_param_8822c),
+	.n_gen1_para	= ARRAY_SIZE(pcie_gen1_param_8822c),
+	.n_gen2_para	= ARRAY_SIZE(pcie_gen2_param_8822c),
+};
+
+static const struct rtw_rfe_def rtw8822c_rfe_defs[] = {
+	[0] = RTW_DEF_RFE(8822c, 0, 0),
+	[1] = RTW_DEF_RFE(8822c, 0, 0),
+	[2] = RTW_DEF_RFE(8822c, 0, 0),
+};
+
+static struct rtw_hw_reg rtw8822c_dig[] = {
+	[0] = { .addr = 0x1d70, .mask = 0x7f },
+	[1] = { .addr = 0x1d70, .mask = 0x7f00 },
+};
+
+static struct rtw_page_table page_table_8822c[] = {
+	{64, 64, 64, 64, 1},
+	{64, 64, 64, 64, 1},
+	{64, 64, 0, 0, 1},
+	{64, 64, 64, 0, 1},
+	{64, 64, 64, 64, 1},
+};
+
+static struct rtw_rqpn rqpn_table_8822c[] = {
+	{RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_NORMAL,
+	 RTW_DMA_MAPPING_LOW, RTW_DMA_MAPPING_LOW,
+	 RTW_DMA_MAPPING_EXTRA, RTW_DMA_MAPPING_HIGH},
+	{RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_NORMAL,
+	 RTW_DMA_MAPPING_LOW, RTW_DMA_MAPPING_LOW,
+	 RTW_DMA_MAPPING_EXTRA, RTW_DMA_MAPPING_HIGH},
+	{RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_NORMAL,
+	 RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_HIGH,
+	 RTW_DMA_MAPPING_HIGH, RTW_DMA_MAPPING_HIGH},
+	{RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_NORMAL,
+	 RTW_DMA_MAPPING_LOW, RTW_DMA_MAPPING_LOW,
+	 RTW_DMA_MAPPING_HIGH, RTW_DMA_MAPPING_HIGH},
+	{RTW_DMA_MAPPING_NORMAL, RTW_DMA_MAPPING_NORMAL,
+	 RTW_DMA_MAPPING_LOW, RTW_DMA_MAPPING_LOW,
+	 RTW_DMA_MAPPING_EXTRA, RTW_DMA_MAPPING_HIGH},
+};
+
+static struct rtw_chip_ops rtw8822c_ops = {
+	.phy_set_param		= rtw8822c_phy_set_param,
+	.read_efuse		= rtw8822c_read_efuse,
+	.query_rx_desc		= rtw8822c_query_rx_desc,
+	.set_channel		= rtw8822c_set_channel,
+	.mac_init		= rtw8822c_mac_init,
+	.read_rf		= rtw_phy_read_rf,
+	.write_rf		= rtw_phy_write_rf_reg_mix,
+	.set_tx_power_index	= rtw8822c_set_tx_power_index,
+	.cfg_ldo25		= rtw8822c_cfg_ldo25,
+	.false_alarm_statistics	= rtw8822c_false_alarm_statistics,
+	.do_iqk			= rtw8822c_do_iqk,
+};
+
+struct rtw_chip_info rtw8822c_hw_spec = {
+	.ops = &rtw8822c_ops,
+	.id = RTW_CHIP_TYPE_8822C,
+	.fw_name = "rtw88/rtw8822c_fw.bin",
+	.tx_pkt_desc_sz = 48,
+	.tx_buf_desc_sz = 16,
+	.rx_pkt_desc_sz = 24,
+	.rx_buf_desc_sz = 8,
+	.phy_efuse_size = 512,
+	.log_efuse_size = 768,
+	.ptct_efuse_size = 124,
+	.txff_size = 262144,
+	.rxff_size = 24576,
+	.txgi_factor = 2,
+	.is_pwr_by_rate_dec = false,
+	.max_power_index = 0x7f,
+	.csi_buf_pg_num = 50,
+	.band = RTW_BAND_2G | RTW_BAND_5G,
+	.page_size = 128,
+	.dig_min = 0x20,
+	.ht_supported = true,
+	.vht_supported = true,
+	.sys_func_en = 0xD8,
+	.pwr_on_seq = card_enable_flow_8822c,
+	.pwr_off_seq = card_disable_flow_8822c,
+	.page_table = page_table_8822c,
+	.rqpn_table = rqpn_table_8822c,
+	.intf_table = &phy_para_table_8822c,
+	.dig = rtw8822c_dig,
+	.rf_base_addr = {0x3c00, 0x4c00},
+	.rf_sipi_addr = {0x1808, 0x4108},
+	.mac_tbl = &rtw8822c_mac_tbl,
+	.agc_tbl = &rtw8822c_agc_tbl,
+	.bb_tbl = &rtw8822c_bb_tbl,
+	.rfk_init_tbl = &rtw8822c_array_mp_cal_init_tbl,
+	.rf_tbl = {&rtw8822c_rf_a_tbl, &rtw8822c_rf_b_tbl},
+	.rfe_defs = rtw8822c_rfe_defs,
+	.rfe_defs_size = ARRAY_SIZE(rtw8822c_rfe_defs),
+};
+EXPORT_SYMBOL(rtw8822c_hw_spec);
+
+MODULE_FIRMWARE("rtw88/rtw8822c_fw.bin");
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.h b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
new file mode 100644
index 0000000..74396ad
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
@@ -0,0 +1,186 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTW8822C_H__
+#define __RTW8822C_H__
+
+#include <asm/byteorder.h>
+
+struct rtw8822cu_efuse {
+	u8 res0[0x30];			/* 0x120 */
+	u8 vid[2];			/* 0x150 */
+	u8 pid[2];
+	u8 res1[3];
+	u8 mac_addr[ETH_ALEN];		/* 0x157 */
+	u8 res2[0x3d];
+};
+
+struct rtw8822ce_efuse {
+	u8 mac_addr[ETH_ALEN];		/* 0x120 */
+	u8 vender_id[2];
+	u8 device_id[2];
+	u8 sub_vender_id[2];
+	u8 sub_device_id[2];
+	u8 pmc[2];
+	u8 exp_device_cap[2];
+	u8 msi_cap;
+	u8 ltr_cap;			/* 0x133 */
+	u8 exp_link_control[2];
+	u8 link_cap[4];
+	u8 link_control[2];
+	u8 serial_number[8];
+	u8 res0:2;			/* 0x144 */
+	u8 ltr_en:1;
+	u8 res1:2;
+	u8 obff:2;
+	u8 res2:3;
+	u8 obff_cap:2;
+	u8 res3:4;
+	u8 class_code[3];
+	u8 res4;
+	u8 pci_pm_L1_2_supp:1;
+	u8 pci_pm_L1_1_supp:1;
+	u8 aspm_pm_L1_2_supp:1;
+	u8 aspm_pm_L1_1_supp:1;
+	u8 L1_pm_substates_supp:1;
+	u8 res5:3;
+	u8 port_common_mode_restore_time;
+	u8 port_t_power_on_scale:2;
+	u8 res6:1;
+	u8 port_t_power_on_value:5;
+	u8 res7;
+};
+
+struct rtw8822c_efuse {
+	__le16 rtl_id;
+	u8 res0[0x0e];
+
+	/* power index for four RF paths */
+	struct rtw_txpwr_idx txpwr_idx_table[4];
+
+	u8 channel_plan;		/* 0xb8 */
+	u8 xtal_k;
+	u8 res1;
+	u8 iqk_lck;
+	u8 res2[5];			/* 0xbc */
+	u8 rf_board_option;
+	u8 rf_feature_option;
+	u8 rf_bt_setting;
+	u8 eeprom_version;
+	u8 eeprom_customer_id;
+	u8 tx_bb_swing_setting_2g;
+	u8 tx_bb_swing_setting_5g;
+	u8 tx_pwr_calibrate_rate;
+	u8 rf_antenna_option;		/* 0xc9 */
+	u8 rfe_option;
+	u8 country_code[2];
+	u8 res3[3];
+	u8 path_a_thermal;		/* 0xd0 */
+	u8 path_b_thermal;
+	u8 res4[2];
+	u8 rx_gain_gap_2g_ofdm;
+	u8 res5;
+	u8 rx_gain_gap_2g_cck;
+	u8 res6;
+	u8 rx_gain_gap_5gl;
+	u8 res7;
+	u8 rx_gain_gap_5gm;
+	u8 res8;
+	u8 rx_gain_gap_5gh;
+	u8 res9;
+	u8 res10[0x42];
+	union {
+		struct rtw8822cu_efuse u;
+		struct rtw8822ce_efuse e;
+	};
+};
+
+#define DACK_PATH_8822C		2
+#define DACK_REG_8822C		16
+#define DACK_RF_8822C		1
+#define DACK_SN_8822C		100
+
+/* phy status page0 */
+#define GET_PHY_STAT_P0_PWDB_A(phy_stat)                                       \
+	le32_get_bits(*((__le32 *)(phy_stat) + 0x00), GENMASK(15, 8))
+#define GET_PHY_STAT_P0_PWDB_B(phy_stat)                                       \
+	le32_get_bits(*((__le32 *)(phy_stat) + 0x04), GENMASK(7, 0))
+#define GET_PHY_STAT_P0_GAIN_A(phy_stat)                                       \
+	le32_get_bits(*((__le32 *)(phy_stat) + 0x00), GENMASK(21, 16))
+#define GET_PHY_STAT_P0_GAIN_B(phy_stat)                                       \
+	le32_get_bits(*((__le32 *)(phy_stat) + 0x04), GENMASK(29, 24))
+
+/* phy status page1 */
+#define GET_PHY_STAT_P1_PWDB_A(phy_stat)                                       \
+	le32_get_bits(*((__le32 *)(phy_stat) + 0x00), GENMASK(15, 8))
+#define GET_PHY_STAT_P1_PWDB_B(phy_stat)                                       \
+	le32_get_bits(*((__le32 *)(phy_stat) + 0x00), GENMASK(23, 16))
+#define GET_PHY_STAT_P1_L_RXSC(phy_stat)                                       \
+	le32_get_bits(*((__le32 *)(phy_stat) + 0x01), GENMASK(11, 8))
+#define GET_PHY_STAT_P1_HT_RXSC(phy_stat)                                      \
+	le32_get_bits(*((__le32 *)(phy_stat) + 0x01), GENMASK(15, 12))
+
+#define REG_ANAPARLDO_POW_MAC	0x0029
+#define BIT_LDOE25_PON		BIT(0)
+#define REG_RRSR		0x0440
+#define BITS_RRSR_RSC		(BIT(21) | BIT(22))
+
+#define REG_TXDFIR0	0x808
+#define REG_DFIRBW	0x810
+#define REG_ANTMAP0	0x820
+#define REG_ANTMAP	0x824
+#define REG_DYMPRITH	0x86c
+#define REG_DYMENTH0	0x870
+#define REG_DYMENTH	0x874
+#define REG_DYMTHMIN	0x8a4
+#define REG_TXBWCTL	0x9b0
+#define REG_TXCLK	0x9b4
+#define REG_SCOTRK	0xc30
+#define REG_MRCM	0xc38
+#define REG_AGCSWSH	0xc44
+#define REG_ANTWTPD	0xc54
+#define REG_ORITXCODE	0x1800
+#define REG_3WIRE	0x180c
+#define BIT_3WIRE_TX_EN		BIT(0)
+#define BIT_3WIRE_RX_EN		BIT(1)
+#define BIT_3WIRE_PI_ON		BIT(28)
+#define REG_RXAGCCTL0	0x18ac
+#define REG_CCKSB	0x1a00
+#define REG_RXCCKSEL	0x1a04
+#define REG_BGCTRL	0x1a14
+#define BITS_RX_IQ_WEIGHT	(BIT(8) | BIT(9))
+#define REG_TXF0	0x1a20
+#define REG_TXF1	0x1a24
+#define REG_TXF2	0x1a28
+#define REG_CCANRX	0x1a2c
+#define BIT_CCK_FA_RST		(BIT(14) | BIT(15))
+#define BIT_OFDM_FA_RST		(BIT(12) | BIT(13))
+#define REG_CCK_FACNT	0x1a5c
+#define REG_CCKTXONLY	0x1a80
+#define BIT_BB_CCK_CHECK_EN	BIT(18)
+#define REG_TXF3	0x1a98
+#define REG_TXF4	0x1a9c
+#define REG_TXF5	0x1aa0
+#define REG_TXF6	0x1aac
+#define REG_TXF7	0x1ab0
+#define REG_TXANT	0x1c28
+#define REG_ENCCK	0x1c3c
+#define BIT_CCK_BLK_EN		BIT(1)
+#define BIT_CCK_OFDM_BLK_EN	(BIT(0) | BIT(1))
+#define REG_CCAMSK	0x1c80
+#define REG_RXFNCTL	0x1d30
+#define REG_RXIGI	0x1d70
+#define REG_ENFN	0x1e24
+#define REG_TXANTSEG	0x1e28
+#define REG_TXLGMAP	0x1e2c
+#define REG_CCKPATH	0x1e5c
+#define REG_CNT_CTRL	0x1eb4
+#define BIT_ALL_CNT_RST		BIT(25)
+#define REG_OFDM_FACNT	0x2d00
+#define REG_OFDM_TXCNT	0x2de0
+#define REG_ORITXCODE2	0x4100
+#define REG_3WIRE2	0x410c
+#define REG_RXAGCCTL	0x41ac
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c_table.h b/drivers/net/wireless/realtek/rtw88/rtw8822c_table.h
new file mode 100644
index 0000000..e4d9f74
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c_table.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTW8822C_TABLE_H__
+#define __RTW8822C_TABLE_H__
+
+extern const struct rtw_table rtw8822c_mac_tbl;
+extern const struct rtw_table rtw8822c_agc_tbl;
+extern const struct rtw_table rtw8822c_bb_tbl;
+extern const struct rtw_table rtw8822c_bb_pg_type0_tbl;
+extern const struct rtw_table rtw8822c_rf_a_tbl;
+extern const struct rtw_table rtw8822c_rf_b_tbl;
+extern const struct rtw_table rtw8822c_txpwr_lmt_type0_tbl;
+extern const struct rtw_table rtw8822c_array_mp_cal_init_tbl;
+
+#endif
-- 
2.7.4

