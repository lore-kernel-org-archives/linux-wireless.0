Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F46D3E2777
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 03:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085590; cv=none; b=H+b2DsCpA5NxjN+T1UnJKk6fviJYIh8KqGkYjDf2XcwawwMaRcKmVXu8Ay5LUU95UgjfmkwacCsdODqnTxgZ7DmVtkI9iHwoJeFgKsD+LSFBHGD8tcMjKb40PPkn0JGLmUURRtu29tQqP8LwZP+uTYUXIcS4MeIAYwE+pg+Whmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085590; c=relaxed/simple;
	bh=YEAzHG2yMj4Lu12C22UC+YFZCxBKZvmX4jrhB7LbVUM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QgRGyCyLXr07LSvujNY6vILsQu1PaFQ96BS+F0T7d3xu2V6CyheCuw35YflR6FqLXX+lR6SfKKWNyfDieUfrfKHD1PFIVJf/Q6v9pBZdvCgxzdmN5mH/0JjsxpzGvujb3ePipodwgRJ3SUR0qtd56e8T4Na8WRYWWwjzGJkcGDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=a8LNRjQc; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="a8LNRjQc"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6943kQ0t9829303, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791085586; bh=DD4FToXRXTt5G2SvzCnzDDbvUINBlbUc9JJ87eYMn60=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=a8LNRjQcWbGX1ZnsA0krg4SpUT/aGTiSZ/J77+hfk+Mlo/d9mruLVzkRsY57EOUs9
	 Y6sjIvghhigyK+16FbnX6mvlD43ujF9OrbFqUxmaKFhB88oq8IGmGk9MQA4E1efxxN
	 dgelB38Z4o+WqBq7HtZKptwP4dXIW9J5IYaTFWFLcdx1CntC/BtsjYxdjD418VPCWC
	 FleWFGg+3c7gKVrJX7MA8PycDDUe0XavdNqGoM8Jr8AIuKe7UFRBEH/nNeUdC51DWc
	 cCoXx//cfb4qrJt+IMmdmLSQNric6wpW8ConbbWopiCYHtYqKm/SjBYLMB189kpelw
	 Jiiq7OyxC3Crw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6943kQ0t9829303
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 11:46:26 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:26 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 11:46:26 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 04/15] wifi: rtw89: coex: add outsrc-set-info v7 for BT SPDT state
Date: Sun, 4 Oct 2026 11:45:09 +0800
Message-ID: <20261004034520.33695-5-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261004034520.33695-1-pkshih@realtek.com>
References: <20261004034520.33695-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

The outsrc-set-info H2C used its last reserved byte for nothing. A
newer firmware version reuses that byte to carry whether BT shares
an SPDT switch with WL at the BB level, which the firmware needs to
pick the right RF constraint. Add a v7 variant of the struct with
the top bit of that byte named is_spdt_bb and the rest kept
reserved, a matching H2C sender, and dispatch fcxosi == 7 to it.
Also widen the gnt_set_be branch in the GNT H2C sender to cover
fcxosi == 7, since it shares the same GNT layout as v6, and add the
paired W2B/B2W scoreboard bits that let WL request and BT acknowledge
the LNA-backoff table for this fcxosi version.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c |  6 +-
 drivers/net/wireless/realtek/rtw89/core.h | 28 ++++++++-
 drivers/net/wireless/realtek/rtw89/fw.c   | 76 ++++++++++++++++++++++-
 drivers/net/wireless/realtek/rtw89/fw.h   |  6 ++
 4 files changed, 113 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 556c35e84043..fbd1a6b33cb6 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -526,6 +526,7 @@ enum btc_b2w_scoreboard {
 	BTC_BSCB_BT_CONNECT_56G = BIT(17),
 	BTC_BSCB_BT_LNAB0_56G = BIT(18),
 	BTC_BSCB_BT_LNAB1_56G = BIT(19),
+	BTC_BSCB_BT_BACKOFF_LNA = BIT(21),
 	BTC_BSCB_HID_ACT = BIT(23),
 	BTC_BSCB_BT_15DOT4 = BIT(24),
 	BTC_BSCB_BT_PROTECT = BIT(27),
@@ -829,6 +830,7 @@ enum btc_w2b_scoreboard {
 	BTC_WSCB_CTCODE = BIT(15),
 	BTC_WSCB_RXGAIN_56G = BIT(16),
 	BTC_WSCB_BT_HILNA_56G = BIT(17),
+	BTC_WSCB_BT_BACKOFF_LNA = BIT(18),
 	BTC_WSCB_ALL = GENMASK(23, 0),
 };
 
@@ -3871,6 +3873,8 @@ static void _fw_set_drv_info(struct rtw89_dev *rtwdev, u8 index)
 			rtw89_fw_h2c_cxdrv_osi_info(rtwdev, index);
 		else if (ver->fcxosi == 6)
 			rtw89_fw_h2c_cxdrv_osi_info_v6(rtwdev, index);
+		else if (ver->fcxosi == 7)
+			rtw89_fw_h2c_cxdrv_osi_info_v7(rtwdev, index);
 		else
 			return;
 		break;
@@ -4018,7 +4022,7 @@ static void _set_gnt(struct rtw89_dev *rtwdev, u8 phy_map,
 
 		memcpy(o->wlact_set, dm->wlact_set, sizeof(o->wlact_set));
 
-		if (btc->ver->fcxosi == 6) {
+		if (btc->ver->fcxosi == 6 || btc->ver->fcxosi == 7) {
 			memcpy(o->gnt_set_be, dm->gnt_set, sizeof(o->gnt_set_be));
 			return;
 		} else if (btc->ver->fcxosi == 1) {
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index d66a1febb85c..30c5822d63b8 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -3925,6 +3925,32 @@ struct rtw89_btc_fbtc_outsrc_set_info_v6 {
 	__le32 wl_tx_limit_time;
 } __packed;
 
+struct rtw89_btc_fbtc_outsrc_set_info_v7 {
+	u8 rf_band[BTC_RF_NUM];
+	u8 btg_rx[BTC_RF_NUM];
+	u8 nbtg_tx[BTC_RF_NUM];
+
+	struct rtw89_btc_gnt_ctrl gnt_set[RTW89_MAC_AX_COEX_GNT_NR];
+	struct rtw89_mac_ax_wl_act wlact_set[BTC_ALL_BT_EZL];
+
+	u8 pta_req_hw_band;
+	u8 rf_gbt_source;
+	u8 bt_enable_state;
+	u8 bt_plut_type;
+	u8 wl_tx_limit_en;
+	u8 fc_exec;
+	u8 wl_btg_standby_chg;
+	u8 option;
+#define OPTION_SPDT_BB BIT(0)
+	u8 bb_path_sel_bt[BTC_RF_NUM];
+	u8 bb_phy_sel_bt[RTW89_PHY_NUM];
+	u8 fbd_group_en[RTW89_MAC_NUM][2];
+	__le16 rf_center_freq[RTW89_MAC_NUM];
+	__le16 freq_diff_thres[RTW89_MAC_NUM][BTC_ALL_BT_EZL];
+	__le16 fbd_group_bound[RTW89_MAC_NUM][2];
+	__le32 wl_tx_limit_time;
+} __packed;
+
 struct rtw89_btc_fbtc_outsrc_set_info {
 	u8 rf_band[BTC_RF_NUM]; /* 0:2GHz/1:5GHz for MPI_bb_hwsi_ignore_gnt_wl() */
 	u8 btg_rx[BTC_RF_NUM]; /* for MPI_bb_btg_bt_rx() */
@@ -3945,7 +3971,7 @@ struct rtw89_btc_fbtc_outsrc_set_info {
 	u8 wl_tx_limit_en;
 	u8 fc_exec;
 	u8 wl_btg_standby_chg; /* keep RX-IQGen on in standby mode */
-	u8 rsvd;
+	u8 is_spdt_bb; /* v7: BT shares an SPDT with WL at BB level */
 
 	u8 bb_path_sel_bt[BTC_RF_NUM]; /* bb s0(1) select GNT_BT0 or BT1 */
 	u8 bb_phy_sel_bt[RTW89_PHY_NUM]; /* bb phy0(1) select GNT_BT0 or BT1 */
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 886d7c32d2ef..e9f6dc25b94c 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -7248,7 +7248,81 @@ int rtw89_fw_h2c_cxdrv_osi_info_v6(struct rtw89_dev *rtwdev, u8 type)
 	h2c->osi.wl_tx_limit_en = osi->wl_tx_limit_en;
 	h2c->osi.fc_exec = osi->fc_exec;
 	h2c->osi.wl_btg_standby_chg = osi->wl_btg_standby_chg;
-	h2c->osi.rsvd = osi->rsvd;
+	h2c->osi.rsvd = 0;
+
+	memcpy(h2c->osi.bb_path_sel_bt, osi->bb_path_sel_bt, sizeof(osi->bb_path_sel_bt));
+	memcpy(h2c->osi.bb_phy_sel_bt, osi->bb_phy_sel_bt, sizeof(osi->bb_phy_sel_bt));
+	memcpy(h2c->osi.fbd_group_en, osi->fbd_group_en, sizeof(osi->fbd_group_en));
+
+	for (i = 0; i < RTW89_MAC_NUM; i++) {
+		h2c->osi.rf_center_freq[i] = cpu_to_le16(osi->rf_center_freq[i]);
+		for (j = 0; j < BTC_RF_NUM; j++)
+			h2c->osi.fbd_group_bound[i][j] =
+				cpu_to_le16(osi->fbd_group_bound[i][j]);
+	}
+
+	for (i = 0; i < RTW89_MAC_NUM; i++) {
+		for (j = 0; j < BTC_ALL_BT_EZL; j++)
+			h2c->osi.freq_diff_thres[i][j] =
+				cpu_to_le16(osi->freq_diff_thres[i][j]);
+	}
+
+	h2c->osi.wl_tx_limit_time = cpu_to_le32(osi->wl_tx_limit_time);
+
+	rtw89_h2c_pkt_set_hdr(rtwdev, skb, FWCMD_TYPE_H2C,
+			      H2C_CAT_OUTSRC, BTFC_SET,
+			      SET_DRV_INFO, 0, 0,
+			      len);
+
+	ret = rtw89_h2c_tx(rtwdev, skb, false);
+	if (ret) {
+		rtw89_err(rtwdev, "failed to send h2c\n");
+		goto fail;
+	}
+
+	return 0;
+fail:
+	dev_kfree_skb_any(skb);
+
+	return ret;
+}
+
+int rtw89_fw_h2c_cxdrv_osi_info_v7(struct rtw89_dev *rtwdev, u8 type)
+{
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_fbtc_outsrc_set_info *osi = &btc->dm.ost_info;
+	struct rtw89_h2c_cxosi_v7 *h2c;
+	u32 len = sizeof(*h2c);
+	struct sk_buff *skb;
+	int ret;
+	u8 i, j;
+
+	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
+	if (!skb) {
+		rtw89_err(rtwdev, "failed to alloc skb for h2c cxdrv_osi_v7\n");
+		return -ENOMEM;
+	}
+	skb_put(skb, len);
+	h2c = (struct rtw89_h2c_cxosi_v7 *)skb->data;
+
+	h2c->hdr.type = type;
+	h2c->hdr.ver = btc->ver->fcxosi;
+	h2c->hdr.len = len - H2C_LEN_CXDRVHDR_V7;
+
+	memcpy(h2c->osi.rf_band, osi->rf_band, sizeof(osi->rf_band));
+	memcpy(h2c->osi.btg_rx, osi->btg_rx, sizeof(osi->btg_rx));
+	memcpy(h2c->osi.nbtg_tx, osi->nbtg_tx, sizeof(osi->nbtg_tx));
+	memcpy(h2c->osi.gnt_set, osi->gnt_set, sizeof(osi->gnt_set));
+	memcpy(h2c->osi.wlact_set, osi->wlact_set, sizeof(osi->wlact_set));
+
+	h2c->osi.pta_req_hw_band = osi->pta_req_hw_band;
+	h2c->osi.rf_gbt_source = osi->rf_gbt_source;
+	h2c->osi.bt_enable_state = osi->bt_enable_state;
+	h2c->osi.bt_plut_type = osi->bt_plut_type;
+	h2c->osi.wl_tx_limit_en = osi->wl_tx_limit_en;
+	h2c->osi.fc_exec = osi->fc_exec;
+	h2c->osi.wl_btg_standby_chg = osi->wl_btg_standby_chg;
+	h2c->osi.option = u8_encode_bits(!!osi->is_spdt_bb, OPTION_SPDT_BB);
 
 	memcpy(h2c->osi.bb_path_sel_bt, osi->bb_path_sel_bt, sizeof(osi->bb_path_sel_bt));
 	memcpy(h2c->osi.bb_phy_sel_bt, osi->bb_phy_sel_bt, sizeof(osi->bb_phy_sel_bt));
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index b0f1d51d67d9..11b6ade24940 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -2527,6 +2527,11 @@ struct rtw89_h2c_cxosi_v6 {
 	struct rtw89_btc_fbtc_outsrc_set_info_v6 osi;
 } __packed;
 
+struct rtw89_h2c_cxosi_v7 {
+	struct rtw89_h2c_cxhdr_v7 hdr;
+	struct rtw89_btc_fbtc_outsrc_set_info_v7 osi;
+} __packed;
+
 struct rtw89_h2c_cxinit {
 	struct rtw89_h2c_cxhdr hdr;
 	u8 ant_type;
@@ -5555,6 +5560,7 @@ int rtw89_fw_h2c_cxdrv_init_v11(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_mlo_v2(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_osi_info(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_osi_info_v6(struct rtw89_dev *rtwdev, u8 type);
+int rtw89_fw_h2c_cxdrv_osi_info_v7(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_ctrl(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_ctrl_v7(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_ctrl_v9(struct rtw89_dev *rtwdev, u8 type);
-- 
2.25.1

