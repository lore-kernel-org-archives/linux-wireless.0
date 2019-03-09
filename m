Return-Path: <SRS0=krUy=RM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A10C10F0F
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 13:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2CA9207E0
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 13:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfCINtL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Mar 2019 08:49:11 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:40678 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfCINtK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Mar 2019 08:49:10 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x29Dmke9020436, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x29Dmke9020436
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Sat, 9 Mar 2019 21:48:46 +0800
Received: from localhost.localdomain (1.168.42.219) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Sat, 9 Mar 2019 21:48:45 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>, <johannes@sipsolutions.net>,
        <gregkh@linuxfoundation.org>
CC:     <linux-wireless@vger.kernel.org>, <Larry.Finger@lwfinger.net>,
        <sgruszka@redhat.com>, <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>
Subject: [PATCH v7 06/14] rtw88: fw and efuse files
Date:   Sat, 9 Mar 2019 21:48:14 +0800
Message-ID: <1552139302-20476-7-git-send-email-yhchuang@realtek.com>
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

fw and efuse files for Realtek 802.11ac wireless network chips

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/efuse.c | 160 ++++++++
 drivers/net/wireless/realtek/rtw88/efuse.h |  26 ++
 drivers/net/wireless/realtek/rtw88/fw.c    | 633 +++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/fw.h    | 222 ++++++++++
 4 files changed, 1041 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/efuse.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/efuse.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/fw.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/fw.h

diff --git a/drivers/net/wireless/realtek/rtw88/efuse.c b/drivers/net/wireless/realtek/rtw88/efuse.c
new file mode 100644
index 0000000..d41072c
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/efuse.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#include "main.h"
+#include "efuse.h"
+#include "reg.h"
+#include "debug.h"
+
+#define RTW_EFUSE_BANK_WIFI		0x0
+
+static void switch_efuse_bank(struct rtw_dev *rtwdev)
+{
+	rtw_write32_mask(rtwdev, REG_LDO_EFUSE_CTRL, BIT_MASK_EFUSE_BANK_SEL,
+			 RTW_EFUSE_BANK_WIFI);
+}
+
+#define invalid_efuse_header(hdr1, hdr2) \
+	((hdr1) == 0xff || (((hdr1) & 0x1f) == 0xf && (hdr2) == 0xff))
+#define invalid_efuse_content(word_en, i) \
+	(((word_en) & BIT(i)) != 0x0)
+#define get_efuse_blk_idx_2_byte(hdr1, hdr2) \
+	((((hdr2) & 0xf0) >> 1) | (((hdr1) >> 5) & 0x07))
+#define get_efuse_blk_idx_1_byte(hdr1) \
+	(((hdr1) & 0xf0) >> 4)
+#define block_idx_to_logical_idx(blk_idx, i) \
+	(((blk_idx) << 3) + ((i) << 1))
+
+/* efuse header format
+ *
+ * | 7        5   4    0 | 7        4   3          0 | 15  8  7   0 |
+ *   block[2:0]   0 1111   block[6:3]   word_en[3:0]   byte0  byte1
+ * | header 1 (optional) |          header 2         |    word N    |
+ *
+ * word_en: 4 bits each word. 0 -> write; 1 -> not write
+ * N: 1~4, depends on word_en
+ */
+static int rtw_dump_logical_efuse_map(struct rtw_dev *rtwdev, u8 *phy_map,
+				      u8 *log_map)
+{
+	u32 physical_size = rtwdev->efuse.physical_size;
+	u32 protect_size = rtwdev->efuse.protect_size;
+	u32 logical_size = rtwdev->efuse.logical_size;
+	u32 phy_idx, log_idx;
+	u8 hdr1, hdr2;
+	u8 blk_idx;
+	u8 word_en;
+	int i;
+
+	for (phy_idx = 0; phy_idx < physical_size - protect_size;) {
+		hdr1 = phy_map[phy_idx];
+		hdr2 = phy_map[phy_idx + 1];
+		if (invalid_efuse_header(hdr1, hdr2))
+			break;
+
+		if ((hdr1 & 0x1f) == 0xf) {
+			/* 2-byte header format */
+			blk_idx = get_efuse_blk_idx_2_byte(hdr1, hdr2);
+			word_en = hdr2 & 0xf;
+			phy_idx += 2;
+		} else {
+			/* 1-byte header format */
+			blk_idx = get_efuse_blk_idx_1_byte(hdr1);
+			word_en = hdr1 & 0xf;
+			phy_idx += 1;
+		}
+
+		for (i = 0; i < 4; i++) {
+			if (invalid_efuse_content(word_en, i))
+				continue;
+
+			log_idx = block_idx_to_logical_idx(blk_idx, i);
+			if (phy_idx + 1 > physical_size - protect_size ||
+			    log_idx + 1 > logical_size)
+				return -EINVAL;
+
+			log_map[log_idx] = phy_map[phy_idx];
+			log_map[log_idx + 1] = phy_map[phy_idx + 1];
+			phy_idx += 2;
+		}
+	}
+	return 0;
+}
+
+static int rtw_dump_physical_efuse_map(struct rtw_dev *rtwdev, u8 *map)
+{
+	struct rtw_chip_info *chip = rtwdev->chip;
+	u32 size = rtwdev->efuse.physical_size;
+	u32 efuse_ctl;
+	u32 addr;
+	u32 cnt;
+
+	switch_efuse_bank(rtwdev);
+
+	/* disable 2.5V LDO */
+	chip->ops->cfg_ldo25(rtwdev, false);
+
+	efuse_ctl = rtw_read32(rtwdev, REG_EFUSE_CTRL);
+
+	for (addr = 0; addr < size; addr++) {
+		efuse_ctl &= ~(BIT_MASK_EF_DATA | BITS_EF_ADDR);
+		efuse_ctl |= (addr & BIT_MASK_EF_ADDR) << BIT_SHIFT_EF_ADDR;
+		rtw_write32(rtwdev, REG_EFUSE_CTRL, efuse_ctl & (~BIT_EF_FLAG));
+
+		cnt = 1000000;
+		do {
+			udelay(1);
+			efuse_ctl = rtw_read32(rtwdev, REG_EFUSE_CTRL);
+			if (--cnt == 0)
+				return -EBUSY;
+		} while (!(efuse_ctl & BIT_EF_FLAG));
+
+		*(map + addr) = (u8)(efuse_ctl & BIT_MASK_EF_DATA);
+	}
+
+	return 0;
+}
+
+int rtw_parse_efuse_map(struct rtw_dev *rtwdev)
+{
+	struct rtw_chip_info *chip = rtwdev->chip;
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	u32 phy_size = efuse->physical_size;
+	u32 log_size = efuse->logical_size;
+	u8 *phy_map = NULL;
+	u8 *log_map = NULL;
+	int ret = 0;
+
+	phy_map = kmalloc(phy_size, GFP_KERNEL);
+	log_map = kmalloc(log_size, GFP_KERNEL);
+	if (!phy_map || !log_map) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	ret = rtw_dump_physical_efuse_map(rtwdev, phy_map);
+	if (ret) {
+		rtw_err(rtwdev, "failed to dump efuse physical map\n");
+		goto out_free;
+	}
+
+	memset(log_map, 0xff, log_size);
+	ret = rtw_dump_logical_efuse_map(rtwdev, phy_map, log_map);
+	if (ret) {
+		rtw_err(rtwdev, "failed to dump efuse logical map\n");
+		goto out_free;
+	}
+
+	ret = chip->ops->read_efuse(rtwdev, log_map);
+	if (ret) {
+		rtw_err(rtwdev, "failed to read efuse map\n");
+		goto out_free;
+	}
+
+out_free:
+	kfree(log_map);
+	kfree(phy_map);
+
+	return ret;
+}
diff --git a/drivers/net/wireless/realtek/rtw88/efuse.h b/drivers/net/wireless/realtek/rtw88/efuse.h
new file mode 100644
index 0000000..c33e899
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/efuse.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTW_EFUSE_H__
+#define __RTW_EFUSE_H__
+
+#define EFUSE_HW_CAP_IGNORE		0
+#define EFUSE_HW_CAP_PTCL_VHT		3
+#define EFUSE_HW_CAP_SUPP_BW80		7
+#define EFUSE_HW_CAP_SUPP_BW40		6
+
+#define GET_EFUSE_HW_CAP_HCI(hw_cap)					       \
+	le32_get_bits(*((__le32 *)(hw_cap) + 0x01), GENMASK(3, 0))
+#define GET_EFUSE_HW_CAP_BW(hw_cap)					       \
+	le32_get_bits(*((__le32 *)(hw_cap) + 0x01), GENMASK(18, 16))
+#define GET_EFUSE_HW_CAP_NSS(hw_cap)					       \
+	le32_get_bits(*((__le32 *)(hw_cap) + 0x01), GENMASK(20, 19))
+#define GET_EFUSE_HW_CAP_ANT_NUM(hw_cap)				       \
+	le32_get_bits(*((__le32 *)(hw_cap) + 0x01), GENMASK(23, 21))
+#define GET_EFUSE_HW_CAP_PTCL(hw_cap)					       \
+	le32_get_bits(*((__le32 *)(hw_cap) + 0x01), GENMASK(27, 26))
+
+int rtw_parse_efuse_map(struct rtw_dev *rtwdev);
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
new file mode 100644
index 0000000..12c4de8
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -0,0 +1,633 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#include "main.h"
+#include "fw.h"
+#include "tx.h"
+#include "reg.h"
+#include "debug.h"
+
+void rtw_fw_c2h_cmd_handle_ext(struct rtw_dev *rtwdev, struct sk_buff *skb)
+{
+	struct rtw_c2h_cmd *c2h;
+	u8 sub_cmd_id;
+
+	c2h = get_c2h_from_skb(skb);
+	sub_cmd_id = c2h->payload[0];
+
+	switch (sub_cmd_id) {
+	case C2H_CCX_RPT:
+		rtw_tx_report_handle(rtwdev, skb);
+		break;
+	default:
+		break;
+	}
+}
+
+void rtw_fw_c2h_cmd_handle(struct rtw_dev *rtwdev, struct sk_buff *skb)
+{
+	struct rtw_c2h_cmd *c2h;
+	u32 pkt_offset;
+	u8 len;
+
+	pkt_offset = *((u32 *)skb->cb);
+	c2h = (struct rtw_c2h_cmd *)(skb->data + pkt_offset);
+	len = skb->len - pkt_offset - 2;
+
+	rtw_dbg(rtwdev, RTW_DBG_FW, "recv C2H, id=0x%02x, seq=0x%02x, len=%d\n",
+		c2h->id, c2h->seq, len);
+
+	switch (c2h->id) {
+	case C2H_HALMAC:
+		rtw_fw_c2h_cmd_handle_ext(rtwdev, skb);
+		break;
+	default:
+		break;
+	}
+}
+
+void rtw_fw_send_h2c_command(struct rtw_dev *rtwdev, u8 *h2c)
+{
+	u8 box;
+	u8 box_state;
+	u32 box_reg, box_ex_reg;
+	u32 h2c_wait;
+	int idx;
+
+	rtw_dbg(rtwdev, RTW_DBG_FW,
+		"send H2C content %02x%02x%02x%02x %02x%02x%02x%02x\n",
+		h2c[3], h2c[2], h2c[1], h2c[0],
+		h2c[7], h2c[6], h2c[5], h2c[4]);
+
+	spin_lock(&rtwdev->h2c.lock);
+
+	box = rtwdev->h2c.last_box_num;
+	switch (box) {
+	case 0:
+		box_reg = REG_HMEBOX0;
+		box_ex_reg = REG_HMEBOX0_EX;
+		break;
+	case 1:
+		box_reg = REG_HMEBOX1;
+		box_ex_reg = REG_HMEBOX1_EX;
+		break;
+	case 2:
+		box_reg = REG_HMEBOX2;
+		box_ex_reg = REG_HMEBOX2_EX;
+		break;
+	case 3:
+		box_reg = REG_HMEBOX3;
+		box_ex_reg = REG_HMEBOX3_EX;
+		break;
+	default:
+		WARN(1, "invalid h2c mail box number\n");
+		goto out;
+	}
+
+	h2c_wait = 20;
+	do {
+		box_state = rtw_read8(rtwdev, REG_HMETFR);
+	} while ((box_state >> box) & 0x1 && --h2c_wait > 0);
+
+	if (!h2c_wait) {
+		rtw_err(rtwdev, "failed to send h2c command\n");
+		goto out;
+	}
+
+	for (idx = 0; idx < 4; idx++)
+		rtw_write8(rtwdev, box_reg + idx, h2c[idx]);
+	for (idx = 0; idx < 4; idx++)
+		rtw_write8(rtwdev, box_ex_reg + idx, h2c[idx + 4]);
+
+	if (++rtwdev->h2c.last_box_num >= 4)
+		rtwdev->h2c.last_box_num = 0;
+
+out:
+	spin_unlock(&rtwdev->h2c.lock);
+}
+
+static void rtw_fw_send_h2c_packet(struct rtw_dev *rtwdev, u8 *h2c_pkt)
+{
+	int ret;
+
+	spin_lock(&rtwdev->h2c.lock);
+
+	FW_OFFLOAD_H2C_SET_SEQ_NUM(h2c_pkt, rtwdev->h2c.seq);
+	ret = rtw_hci_write_data_h2c(rtwdev, h2c_pkt, H2C_PKT_SIZE);
+	if (ret)
+		rtw_err(rtwdev, "failed to send h2c packet\n");
+	rtwdev->h2c.seq++;
+
+	spin_unlock(&rtwdev->h2c.lock);
+}
+
+void
+rtw_fw_send_general_info(struct rtw_dev *rtwdev)
+{
+	struct rtw_fifo_conf *fifo = &rtwdev->fifo;
+	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
+	u16 total_size = H2C_PKT_HDR_SIZE + 4;
+
+	rtw_h2c_pkt_set_header(h2c_pkt, H2C_PKT_GENERAL_INFO);
+
+	SET_PKT_H2C_TOTAL_LEN(h2c_pkt, total_size);
+
+	GENERAL_INFO_SET_FW_TX_BOUNDARY(h2c_pkt,
+					fifo->rsvd_fw_txbuf_addr -
+					fifo->rsvd_boundary);
+
+	rtw_fw_send_h2c_packet(rtwdev, h2c_pkt);
+}
+
+void
+rtw_fw_send_phydm_info(struct rtw_dev *rtwdev)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
+	u16 total_size = H2C_PKT_HDR_SIZE + 8;
+	u8 fw_rf_type = 0;
+
+	if (hal->rf_type == RF_1T1R)
+		fw_rf_type = FW_RF_1T1R;
+	else if (hal->rf_type == RF_2T2R)
+		fw_rf_type = FW_RF_2T2R;
+
+	rtw_h2c_pkt_set_header(h2c_pkt, H2C_PKT_PHYDM_INFO);
+
+	SET_PKT_H2C_TOTAL_LEN(h2c_pkt, total_size);
+	PHYDM_INFO_SET_REF_TYPE(h2c_pkt, efuse->rfe_option);
+	PHYDM_INFO_SET_RF_TYPE(h2c_pkt, fw_rf_type);
+	PHYDM_INFO_SET_CUT_VER(h2c_pkt, hal->cut_version);
+	PHYDM_INFO_SET_RX_ANT_STATUS(h2c_pkt, hal->antenna_tx);
+	PHYDM_INFO_SET_TX_ANT_STATUS(h2c_pkt, hal->antenna_rx);
+
+	rtw_fw_send_h2c_packet(rtwdev, h2c_pkt);
+}
+
+void rtw_fw_do_iqk(struct rtw_dev *rtwdev, struct rtw_iqk_para *para)
+{
+	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
+	u16 total_size = H2C_PKT_HDR_SIZE + 1;
+
+	rtw_h2c_pkt_set_header(h2c_pkt, H2C_PKT_IQK);
+	SET_PKT_H2C_TOTAL_LEN(h2c_pkt, total_size);
+	IQK_SET_CLEAR(h2c_pkt, para->clear);
+	IQK_SET_SEGMENT_IQK(h2c_pkt, para->segment_iqk);
+
+	rtw_fw_send_h2c_packet(rtwdev, h2c_pkt);
+}
+
+void rtw_fw_send_rssi_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si)
+{
+	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
+	u8 rssi = ewma_rssi_read(&si->avg_rssi);
+	bool stbc_en = si->stbc_en ? true : false;
+
+	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_RSSI_MONITOR);
+
+	SET_RSSI_INFO_MACID(h2c_pkt, si->mac_id);
+	SET_RSSI_INFO_RSSI(h2c_pkt, rssi);
+	SET_RSSI_INFO_STBC(h2c_pkt, stbc_en);
+
+	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
+}
+
+void rtw_fw_send_ra_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si)
+{
+	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
+	bool no_update = si->updated;
+	bool disable_pt = true;
+
+	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_RA_INFO);
+
+	SET_RA_INFO_MACID(h2c_pkt, si->mac_id);
+	SET_RA_INFO_RATE_ID(h2c_pkt, si->rate_id);
+	SET_RA_INFO_INIT_RA_LVL(h2c_pkt, si->init_ra_lv);
+	SET_RA_INFO_SGI_EN(h2c_pkt, si->sgi_enable);
+	SET_RA_INFO_BW_MODE(h2c_pkt, si->bw_mode);
+	SET_RA_INFO_LDPC(h2c_pkt, si->ldpc_en);
+	SET_RA_INFO_NO_UPDATE(h2c_pkt, no_update);
+	SET_RA_INFO_VHT_EN(h2c_pkt, si->vht_enable);
+	SET_RA_INFO_DIS_PT(h2c_pkt, disable_pt);
+	SET_RA_INFO_RA_MASK0(h2c_pkt, (si->ra_mask & 0xff));
+	SET_RA_INFO_RA_MASK1(h2c_pkt, (si->ra_mask & 0xff00) >> 8);
+	SET_RA_INFO_RA_MASK2(h2c_pkt, (si->ra_mask & 0xff0000) >> 16);
+	SET_RA_INFO_RA_MASK3(h2c_pkt, (si->ra_mask & 0xff000000) >> 24);
+
+	si->init_ra_lv = 0;
+	si->updated = true;
+
+	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
+}
+
+void rtw_fw_media_status_report(struct rtw_dev *rtwdev, u8 mac_id, bool connect)
+{
+	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
+
+	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_MEDIA_STATUS_RPT);
+	MEDIA_STATUS_RPT_SET_OP_MODE(h2c_pkt, connect);
+	MEDIA_STATUS_RPT_SET_MACID(h2c_pkt, mac_id);
+
+	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
+}
+
+void rtw_fw_set_pwr_mode(struct rtw_dev *rtwdev)
+{
+	struct rtw_lps_conf *conf = &rtwdev->lps_conf;
+	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
+
+	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_SET_PWR_MODE);
+
+	SET_PWR_MODE_SET_MODE(h2c_pkt, conf->mode);
+	SET_PWR_MODE_SET_RLBM(h2c_pkt, conf->rlbm);
+	SET_PWR_MODE_SET_SMART_PS(h2c_pkt, conf->smart_ps);
+	SET_PWR_MODE_SET_AWAKE_INTERVAL(h2c_pkt, conf->awake_interval);
+	SET_PWR_MODE_SET_PORT_ID(h2c_pkt, conf->port_id);
+	SET_PWR_MODE_SET_PWR_STATE(h2c_pkt, conf->state);
+
+	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
+}
+
+static u8 rtw_get_rsvd_page_location(struct rtw_dev *rtwdev,
+				     enum rtw_rsvd_packet_type type)
+{
+	struct rtw_rsvd_page *rsvd_pkt;
+	u8 location = 0;
+
+	list_for_each_entry(rsvd_pkt, &rtwdev->rsvd_page_list, list) {
+		if (type == rsvd_pkt->type)
+			location = rsvd_pkt->page;
+	}
+
+	return location;
+}
+
+void rtw_send_rsvd_page_h2c(struct rtw_dev *rtwdev)
+{
+	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
+	u8 location = 0;
+
+	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_RSVD_PAGE);
+
+	location = rtw_get_rsvd_page_location(rtwdev, RSVD_PROBE_RESP);
+	*(h2c_pkt + 1) = location;
+	rtw_dbg(rtwdev, RTW_DBG_FW, "RSVD_PROBE_RESP loc: %d\n", location);
+
+	location = rtw_get_rsvd_page_location(rtwdev, RSVD_PS_POLL);
+	*(h2c_pkt + 2) = location;
+	rtw_dbg(rtwdev, RTW_DBG_FW, "RSVD_PS_POLL loc: %d\n", location);
+
+	location = rtw_get_rsvd_page_location(rtwdev, RSVD_NULL);
+	*(h2c_pkt + 3) = location;
+	rtw_dbg(rtwdev, RTW_DBG_FW, "RSVD_NULL loc: %d\n", location);
+
+	location = rtw_get_rsvd_page_location(rtwdev, RSVD_QOS_NULL);
+	*(h2c_pkt + 4) = location;
+	rtw_dbg(rtwdev, RTW_DBG_FW, "RSVD_QOS_NULL loc: %d\n", location);
+
+	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
+}
+
+static struct sk_buff *
+rtw_beacon_get(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct sk_buff *skb_new;
+
+	if (vif->type != NL80211_IFTYPE_AP &&
+	    vif->type != NL80211_IFTYPE_ADHOC &&
+	    !ieee80211_vif_is_mesh(vif)) {
+		skb_new = alloc_skb(1, GFP_KERNEL);
+		if (!skb_new)
+			return NULL;
+		skb_put(skb_new, 1);
+	} else {
+		skb_new = ieee80211_beacon_get(hw, vif);
+	}
+
+	return skb_new;
+}
+
+static struct sk_buff *rtw_get_rsvd_page_skb(struct ieee80211_hw *hw,
+					     struct ieee80211_vif *vif,
+					     enum rtw_rsvd_packet_type type)
+{
+	struct sk_buff *skb_new;
+
+	switch (type) {
+	case RSVD_BEACON:
+		skb_new = rtw_beacon_get(hw, vif);
+		break;
+	case RSVD_PS_POLL:
+		skb_new = ieee80211_pspoll_get(hw, vif);
+		break;
+	case RSVD_PROBE_RESP:
+		skb_new = ieee80211_proberesp_get(hw, vif);
+		break;
+	case RSVD_NULL:
+		skb_new = ieee80211_nullfunc_get(hw, vif, false);
+		break;
+	case RSVD_QOS_NULL:
+		skb_new = ieee80211_nullfunc_get(hw, vif, true);
+		break;
+	default:
+		return NULL;
+	}
+
+	if (!skb_new)
+		return NULL;
+
+	return skb_new;
+}
+
+static void rtw_fill_rsvd_page_desc(struct rtw_dev *rtwdev, struct sk_buff *skb)
+{
+	struct rtw_tx_pkt_info pkt_info;
+	struct rtw_chip_info *chip = rtwdev->chip;
+	u8 *pkt_desc;
+
+	memset(&pkt_info, 0, sizeof(pkt_info));
+	rtw_rsvd_page_pkt_info_update(rtwdev, &pkt_info, skb);
+	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
+	memset(pkt_desc, 0, chip->tx_pkt_desc_sz);
+	rtw_tx_fill_tx_desc(&pkt_info, skb);
+}
+
+static inline u8 rtw_len_to_page(unsigned int len, u8 page_size)
+{
+	return DIV_ROUND_UP(len, page_size);
+}
+
+static void rtw_rsvd_page_list_to_buf(struct rtw_dev *rtwdev, u8 page_size,
+				      u8 page_margin, u32 page, u8 *buf,
+				      struct rtw_rsvd_page *rsvd_pkt)
+{
+	struct sk_buff *skb = rsvd_pkt->skb;
+
+	if (rsvd_pkt->add_txdesc)
+		rtw_fill_rsvd_page_desc(rtwdev, skb);
+
+	if (page >= 1)
+		memcpy(buf + page_margin + page_size * (page - 1),
+		       skb->data, skb->len);
+	else
+		memcpy(buf, skb->data, skb->len);
+}
+
+void rtw_add_rsvd_page(struct rtw_dev *rtwdev, enum rtw_rsvd_packet_type type,
+		       bool txdesc)
+{
+	struct rtw_rsvd_page *rsvd_pkt;
+
+	lockdep_assert_held(&rtwdev->mutex);
+
+	list_for_each_entry(rsvd_pkt, &rtwdev->rsvd_page_list, list) {
+		if (rsvd_pkt->type == type)
+			return;
+	}
+
+	rsvd_pkt = kmalloc(sizeof(*rsvd_pkt), GFP_KERNEL);
+	if (!rsvd_pkt)
+		return;
+
+	rsvd_pkt->type = type;
+	rsvd_pkt->add_txdesc = txdesc;
+	list_add_tail(&rsvd_pkt->list, &rtwdev->rsvd_page_list);
+}
+
+void rtw_reset_rsvd_page(struct rtw_dev *rtwdev)
+{
+	struct rtw_rsvd_page *rsvd_pkt, *tmp;
+
+	lockdep_assert_held(&rtwdev->mutex);
+
+	list_for_each_entry_safe(rsvd_pkt, tmp, &rtwdev->rsvd_page_list, list) {
+		if (rsvd_pkt->type == RSVD_BEACON)
+			continue;
+		list_del(&rsvd_pkt->list);
+		kfree(rsvd_pkt);
+	}
+}
+
+int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
+				u8 *buf, u32 size)
+{
+	u8 bckp[2];
+	u8 val;
+	u16 rsvd_pg_head;
+	int ret;
+
+	lockdep_assert_held(&rtwdev->mutex);
+
+	if (!size)
+		return -EINVAL;
+
+	pg_addr &= BIT_MASK_BCN_HEAD_1_V1;
+	rtw_write16(rtwdev, REG_FIFOPAGE_CTRL_2, pg_addr | BIT_BCN_VALID_V1);
+
+	val = rtw_read8(rtwdev, REG_CR + 1);
+	bckp[0] = val;
+	val |= BIT_ENSWBCN >> 8;
+	rtw_write8(rtwdev, REG_CR + 1, val);
+
+	val = rtw_read8(rtwdev, REG_FWHW_TXQ_CTRL + 2);
+	bckp[1] = val;
+	val &= ~(BIT_EN_BCNQ_DL >> 16);
+	rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, val);
+
+	ret = rtw_hci_write_data_rsvd_page(rtwdev, buf, size);
+	if (ret) {
+		rtw_err(rtwdev, "failed to write data to rsvd page\n");
+		goto restore;
+	}
+
+	if (!check_hw_ready(rtwdev, REG_FIFOPAGE_CTRL_2, BIT_BCN_VALID_V1, 1)) {
+		rtw_err(rtwdev, "error beacon valid\n");
+		ret = -EBUSY;
+	}
+
+restore:
+	rsvd_pg_head = rtwdev->fifo.rsvd_boundary;
+	rtw_write16(rtwdev, REG_FIFOPAGE_CTRL_2,
+		    rsvd_pg_head | BIT_BCN_VALID_V1);
+	rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, bckp[1]);
+	rtw_write8(rtwdev, REG_CR + 1, bckp[0]);
+
+	return ret;
+}
+
+static int rtw_download_drv_rsvd_page(struct rtw_dev *rtwdev, u8 *buf, u32 size)
+{
+	u32 pg_size;
+	u32 pg_num = 0;
+	u16 pg_addr = 0;
+
+	pg_size = rtwdev->chip->page_size;
+	pg_num = size / pg_size + ((size & (pg_size - 1)) ? 1 : 0);
+	if (pg_num > rtwdev->fifo.rsvd_drv_pg_num)
+		return -ENOMEM;
+
+	pg_addr = rtwdev->fifo.rsvd_drv_addr;
+
+	return rtw_fw_write_data_rsvd_page(rtwdev, pg_addr, buf, size);
+}
+
+static u8 *rtw_build_rsvd_page(struct rtw_dev *rtwdev,
+			       struct ieee80211_vif *vif, u32 *size)
+{
+	struct ieee80211_hw *hw = rtwdev->hw;
+	struct rtw_chip_info *chip = rtwdev->chip;
+	struct sk_buff *iter;
+	struct rtw_rsvd_page *rsvd_pkt;
+	u32 page = 0;
+	u8 total_page = 0;
+	u8 page_size, page_margin, tx_desc_sz;
+	u8 *buf;
+
+	page_size = chip->page_size;
+	tx_desc_sz = chip->tx_pkt_desc_sz;
+	page_margin = page_size - tx_desc_sz;
+
+	list_for_each_entry(rsvd_pkt, &rtwdev->rsvd_page_list, list) {
+		iter = rtw_get_rsvd_page_skb(hw, vif, rsvd_pkt->type);
+		if (!iter) {
+			rtw_err(rtwdev, "fail to build rsvd packet\n");
+			goto release_skb;
+		}
+		rsvd_pkt->skb = iter;
+		rsvd_pkt->page = total_page;
+		if (rsvd_pkt->add_txdesc)
+			total_page += rtw_len_to_page(iter->len + tx_desc_sz,
+						      page_size);
+		else
+			total_page += rtw_len_to_page(iter->len, page_size);
+	}
+
+	if (total_page > rtwdev->fifo.rsvd_drv_pg_num) {
+		rtw_err(rtwdev, "rsvd page over size: %d\n", total_page);
+		goto release_skb;
+	}
+
+	*size = (total_page - 1) * page_size + page_margin;
+	buf = kzalloc(*size, GFP_KERNEL);
+	if (!buf)
+		goto release_skb;
+
+	list_for_each_entry(rsvd_pkt, &rtwdev->rsvd_page_list, list) {
+		rtw_rsvd_page_list_to_buf(rtwdev, page_size, page_margin,
+					  page, buf, rsvd_pkt);
+		page += rtw_len_to_page(rsvd_pkt->skb->len, page_size);
+	}
+	list_for_each_entry(rsvd_pkt, &rtwdev->rsvd_page_list, list)
+		kfree_skb(rsvd_pkt->skb);
+
+	return buf;
+
+release_skb:
+	list_for_each_entry(rsvd_pkt, &rtwdev->rsvd_page_list, list)
+		kfree_skb(rsvd_pkt->skb);
+
+	return NULL;
+}
+
+static int
+rtw_download_beacon(struct rtw_dev *rtwdev, struct ieee80211_vif *vif)
+{
+	struct ieee80211_hw *hw = rtwdev->hw;
+	struct sk_buff *skb;
+	int ret = 0;
+
+	skb = rtw_beacon_get(hw, vif);
+	if (!skb) {
+		rtw_err(rtwdev, "failed to get beacon skb\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = rtw_download_drv_rsvd_page(rtwdev, skb->data, skb->len);
+	if (ret)
+		rtw_err(rtwdev, "failed to download drv rsvd page\n");
+
+	dev_kfree_skb(skb);
+
+out:
+	return ret;
+}
+
+int rtw_fw_download_rsvd_page(struct rtw_dev *rtwdev, struct ieee80211_vif *vif)
+{
+	u8 *buf;
+	u32 size;
+	int ret;
+
+	buf = rtw_build_rsvd_page(rtwdev, vif, &size);
+	if (!buf) {
+		rtw_err(rtwdev, "failed to build rsvd page pkt\n");
+		return -ENOMEM;
+	}
+
+	ret = rtw_download_drv_rsvd_page(rtwdev, buf, size);
+	if (ret) {
+		rtw_err(rtwdev, "failed to download drv rsvd page\n");
+		goto free;
+	}
+
+	ret = rtw_download_beacon(rtwdev, vif);
+	if (ret) {
+		rtw_err(rtwdev, "failed to download beacon\n");
+		goto free;
+	}
+
+free:
+	kfree(buf);
+
+	return ret;
+}
+
+int rtw_dump_drv_rsvd_page(struct rtw_dev *rtwdev,
+			   u32 offset, u32 size, u32 *buf)
+{
+	struct rtw_fifo_conf *fifo = &rtwdev->fifo;
+	u32 residue, i;
+	u16 start_pg;
+	u16 idx = 0;
+	u16 ctl;
+	u8 rcr;
+
+	if (size & 0x3) {
+		rtw_warn(rtwdev, "should be 4-byte aligned\n");
+		return -EINVAL;
+	}
+
+	offset += fifo->rsvd_boundary << TX_PAGE_SIZE_SHIFT;
+	residue = offset & (FIFO_PAGE_SIZE - 1);
+	start_pg = offset >> FIFO_PAGE_SIZE_SHIFT;
+	start_pg += RSVD_PAGE_START_ADDR;
+
+	rcr = rtw_read8(rtwdev, REG_RCR + 2);
+	ctl = rtw_read16(rtwdev, REG_PKTBUF_DBG_CTRL) & 0xf000;
+
+	/* disable rx clock gate */
+	rtw_write8(rtwdev, REG_RCR, rcr | BIT(3));
+
+	do {
+		rtw_write16(rtwdev, REG_PKTBUF_DBG_CTRL, start_pg | ctl);
+
+		for (i = FIFO_DUMP_ADDR + residue;
+		     i < FIFO_DUMP_ADDR + FIFO_PAGE_SIZE; i += 4) {
+			buf[idx++] = rtw_read32(rtwdev, i);
+			size -= 4;
+			if (size == 0)
+				goto out;
+		}
+
+		residue = 0;
+		start_pg++;
+	} while (size);
+
+out:
+	rtw_write16(rtwdev, REG_PKTBUF_DBG_CTRL, ctl);
+	rtw_write8(rtwdev, REG_RCR + 2, rcr);
+	return 0;
+}
diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
new file mode 100644
index 0000000..86d9c86
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -0,0 +1,222 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018  Realtek Corporation.
+ */
+
+#ifndef __RTW_FW_H_
+#define __RTW_FW_H_
+
+#define H2C_PKT_SIZE		32
+#define H2C_PKT_HDR_SIZE	8
+
+/* FW bin information */
+#define FW_HDR_SIZE			64
+#define FW_HDR_CHKSUM_SIZE		8
+#define FW_HDR_VERSION			4
+#define FW_HDR_SUBVERSION		6
+#define FW_HDR_SUBINDEX			7
+#define FW_HDR_MONTH			16
+#define FW_HDR_DATE			17
+#define FW_HDR_HOUR			18
+#define FW_HDR_MIN			19
+#define FW_HDR_YEAR			20
+#define FW_HDR_MEM_USAGE		24
+#define FW_HDR_H2C_FMT_VER		28
+#define FW_HDR_DMEM_ADDR		32
+#define FW_HDR_DMEM_SIZE		36
+#define FW_HDR_IMEM_SIZE		48
+#define FW_HDR_EMEM_SIZE		52
+#define FW_HDR_EMEM_ADDR		56
+#define FW_HDR_IMEM_ADDR		60
+
+#define FIFO_PAGE_SIZE_SHIFT		12
+#define FIFO_PAGE_SIZE			4096
+#define RSVD_PAGE_START_ADDR		0x780
+#define FIFO_DUMP_ADDR			0x8000
+
+enum rtw_c2h_cmd_id {
+	C2H_BT_INFO = 0x09,
+	C2H_HW_FEATURE_REPORT = 0x19,
+	C2H_HW_FEATURE_DUMP = 0xfd,
+	C2H_HALMAC = 0xff,
+};
+
+enum rtw_c2h_cmd_id_ext {
+	C2H_CCX_RPT = 0x0f,
+};
+
+struct rtw_c2h_cmd {
+	u8 id;
+	u8 seq;
+	u8 payload[0];
+} __packed;
+
+enum rtw_rsvd_packet_type {
+	RSVD_BEACON,
+	RSVD_PS_POLL,
+	RSVD_PROBE_RESP,
+	RSVD_NULL,
+	RSVD_QOS_NULL,
+};
+
+enum rtw_fw_rf_type {
+	FW_RF_1T2R = 0,
+	FW_RF_2T4R = 1,
+	FW_RF_2T2R = 2,
+	FW_RF_2T3R = 3,
+	FW_RF_1T1R = 4,
+	FW_RF_2T2R_GREEN = 5,
+	FW_RF_3T3R = 6,
+	FW_RF_3T4R = 7,
+	FW_RF_4T4R = 8,
+	FW_RF_MAX_TYPE = 0xF,
+};
+
+struct rtw_iqk_para {
+	u8 clear;
+	u8 segment_iqk;
+};
+
+struct rtw_rsvd_page {
+	struct list_head list;
+	struct sk_buff *skb;
+	enum rtw_rsvd_packet_type type;
+	u8 page;
+	bool add_txdesc;
+};
+
+/* C2H */
+#define GET_CCX_REPORT_SEQNUM(c2h_payload)	(c2h_payload[8] & 0xfc)
+#define GET_CCX_REPORT_STATUS(c2h_payload)	(c2h_payload[9] & 0xc0)
+
+/* PKT H2C */
+#define H2C_PKT_CMD_ID 0xFF
+#define H2C_PKT_CATEGORY 0x01
+
+#define H2C_PKT_GENERAL_INFO 0x0D
+#define H2C_PKT_PHYDM_INFO 0x11
+#define H2C_PKT_IQK 0x0E
+
+#define SET_PKT_H2C_CATEGORY(h2c_pkt, value)                                   \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(6, 0))
+#define SET_PKT_H2C_CMD_ID(h2c_pkt, value)                                     \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(15, 8))
+#define SET_PKT_H2C_SUB_CMD_ID(h2c_pkt, value)                                 \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(31, 16))
+#define SET_PKT_H2C_TOTAL_LEN(h2c_pkt, value)                                  \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x01, value, GENMASK(15, 0))
+
+static inline void rtw_h2c_pkt_set_header(u8 *h2c_pkt, u8 sub_id)
+{
+	SET_PKT_H2C_CATEGORY(h2c_pkt, H2C_PKT_CATEGORY);
+	SET_PKT_H2C_CMD_ID(h2c_pkt, H2C_PKT_CMD_ID);
+	SET_PKT_H2C_SUB_CMD_ID(h2c_pkt, sub_id);
+}
+
+#define FW_OFFLOAD_H2C_SET_SEQ_NUM(h2c_pkt, value)                             \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x01, value, GENMASK(31, 16))
+#define GENERAL_INFO_SET_FW_TX_BOUNDARY(h2c_pkt, value)                        \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x02, value, GENMASK(23, 16))
+
+#define PHYDM_INFO_SET_REF_TYPE(h2c_pkt, value)                                \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x02, value, GENMASK(7, 0))
+#define PHYDM_INFO_SET_RF_TYPE(h2c_pkt, value)                                 \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x02, value, GENMASK(15, 8))
+#define PHYDM_INFO_SET_CUT_VER(h2c_pkt, value)                                 \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x02, value, GENMASK(23, 16))
+#define PHYDM_INFO_SET_RX_ANT_STATUS(h2c_pkt, value)                           \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x02, value, GENMASK(27, 24))
+#define PHYDM_INFO_SET_TX_ANT_STATUS(h2c_pkt, value)                           \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x02, value, GENMASK(31, 28))
+#define IQK_SET_CLEAR(h2c_pkt, value)                                          \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x02, value, BIT(0))
+#define IQK_SET_SEGMENT_IQK(h2c_pkt, value)                                    \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x02, value, BIT(1))
+
+/* Command H2C */
+#define H2C_CMD_RSVD_PAGE		0x0
+#define H2C_CMD_MEDIA_STATUS_RPT	0x01
+#define H2C_CMD_SET_PWR_MODE		0x20
+#define H2C_CMD_RA_INFO			0x40
+#define H2C_CMD_RSSI_MONITOR		0x42
+
+#define SET_H2C_CMD_ID_CLASS(h2c_pkt, value)				       \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(7, 0))
+
+#define MEDIA_STATUS_RPT_SET_OP_MODE(h2c_pkt, value)                           \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, BIT(8))
+#define MEDIA_STATUS_RPT_SET_MACID(h2c_pkt, value)                             \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(23, 16))
+
+#define SET_PWR_MODE_SET_MODE(h2c_pkt, value)                                  \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(14, 8))
+#define SET_PWR_MODE_SET_RLBM(h2c_pkt, value)                                  \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(19, 16))
+#define SET_PWR_MODE_SET_SMART_PS(h2c_pkt, value)                              \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(23, 20))
+#define SET_PWR_MODE_SET_AWAKE_INTERVAL(h2c_pkt, value)                        \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(31, 24))
+#define SET_PWR_MODE_SET_PORT_ID(h2c_pkt, value)                               \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x01, value, GENMASK(7, 5))
+#define SET_PWR_MODE_SET_PWR_STATE(h2c_pkt, value)                             \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x01, value, GENMASK(15, 8))
+#define SET_RSSI_INFO_MACID(h2c_pkt, value)                                    \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(15, 8))
+#define SET_RSSI_INFO_RSSI(h2c_pkt, value)                                     \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(31, 24))
+#define SET_RSSI_INFO_STBC(h2c_pkt, value)                                     \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x01, value, BIT(1))
+#define SET_RA_INFO_MACID(h2c_pkt, value)                                      \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(15, 8))
+#define SET_RA_INFO_RATE_ID(h2c_pkt, value)                                    \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(20, 16))
+#define SET_RA_INFO_INIT_RA_LVL(h2c_pkt, value)                                \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(22, 21))
+#define SET_RA_INFO_SGI_EN(h2c_pkt, value)                                     \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, BIT(23))
+#define SET_RA_INFO_BW_MODE(h2c_pkt, value)                                    \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(25, 24))
+#define SET_RA_INFO_LDPC(h2c_pkt, value)                                       \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, BIT(26))
+#define SET_RA_INFO_NO_UPDATE(h2c_pkt, value)                                  \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, BIT(27))
+#define SET_RA_INFO_VHT_EN(h2c_pkt, value)                                     \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, GENMASK(29, 28))
+#define SET_RA_INFO_DIS_PT(h2c_pkt, value)                                     \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x00, value, BIT(30))
+#define SET_RA_INFO_RA_MASK0(h2c_pkt, value)                                   \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x01, value, GENMASK(7, 0))
+#define SET_RA_INFO_RA_MASK1(h2c_pkt, value)                                   \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x01, value, GENMASK(15, 8))
+#define SET_RA_INFO_RA_MASK2(h2c_pkt, value)                                   \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x01, value, GENMASK(23, 16))
+#define SET_RA_INFO_RA_MASK3(h2c_pkt, value)                                   \
+	le32p_replace_bits((__le32 *)(h2c_pkt) + 0x01, value, GENMASK(31, 24))
+
+static inline struct rtw_c2h_cmd *get_c2h_from_skb(struct sk_buff *skb)
+{
+	u32 pkt_offset;
+
+	pkt_offset = *((u32 *)skb->cb);
+	return (struct rtw_c2h_cmd *)(skb->data + pkt_offset);
+}
+
+void rtw_fw_c2h_cmd_handle(struct rtw_dev *rtwdev, struct sk_buff *skb);
+void rtw_fw_send_general_info(struct rtw_dev *rtwdev);
+void rtw_fw_send_phydm_info(struct rtw_dev *rtwdev);
+
+void rtw_fw_do_iqk(struct rtw_dev *rtwdev, struct rtw_iqk_para *para);
+void rtw_fw_set_pwr_mode(struct rtw_dev *rtwdev);
+void rtw_fw_send_rssi_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si);
+void rtw_fw_send_ra_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si);
+void rtw_fw_media_status_report(struct rtw_dev *rtwdev, u8 mac_id, bool conn);
+void rtw_add_rsvd_page(struct rtw_dev *rtwdev, enum rtw_rsvd_packet_type type,
+		       bool txdesc);
+int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
+				u8 *buf, u32 size);
+void rtw_reset_rsvd_page(struct rtw_dev *rtwdev);
+int rtw_fw_download_rsvd_page(struct rtw_dev *rtwdev,
+			      struct ieee80211_vif *vif);
+void rtw_send_rsvd_page_h2c(struct rtw_dev *rtwdev);
+int rtw_dump_drv_rsvd_page(struct rtw_dev *rtwdev,
+			   u32 offset, u32 size, u32 *buf);
+#endif
-- 
2.7.4

