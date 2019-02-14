Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 080F4C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D50CA222A4
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730641AbfBNI7h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:59:37 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:39587 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729096AbfBNI7g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 03:59:36 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1E8xHue005851, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1E8xHue005851
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 14 Feb 2019 16:59:17 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 14 Feb 2019 16:59:16 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>, <johannes@sipsolutions.net>
CC:     <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>
Subject: [PATCH v2 07/24] rtw88: 8822c: update efuse table as released
Date:   Thu, 14 Feb 2019 16:58:46 +0800
Message-ID: <1550134743-17443-8-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
References: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.126]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Update efuse table layout as the document released.
From the newest released document, 8822c has RFE type 1 and type 2.
Without adding RFE 1 and 2 the user's efuse-programed chips will failed
to pass the chip info check and cannot power on hardware.
And 8822c has only 512 bytes for physical efuse.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 12 ++----
 drivers/net/wireless/realtek/rtw88/rtw8822c.h | 53 ++++++++++++++-------------
 2 files changed, 31 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 71f2af0..5c06e32 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -16,12 +16,10 @@
 static void rtw8822c_config_trx_mode(struct rtw_dev *rtwdev, u8 tx_path,
 				     u8 rx_path, bool is_tx2_path);
 
-static u8 temp_addr[ETH_ALEN] = {0x00, 0xe0, 0x4c, 0x88, 0x22, 0xce};
-
 static void rtw8822ce_efuse_parsing(struct rtw_efuse *efuse,
 				    struct rtw8822c_efuse *map)
 {
-	ether_addr_copy(efuse->addr, temp_addr);
+	ether_addr_copy(efuse->addr, map->e.mac_addr);
 }
 
 static int rtw8822c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
@@ -34,10 +32,6 @@ static int rtw8822c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 
 	efuse->rfe_option = map->rfe_option;
 	efuse->crystal_cap = map->xtal_k;
-	efuse->pa_type_2g = map->pa_type;
-	efuse->pa_type_5g = map->pa_type;
-	efuse->lna_type_2g = map->lna_type_2g[0];
-	efuse->lna_type_5g = map->lna_type_5g[0];
 	efuse->channel_plan = map->channel_plan;
 	efuse->country_code[0] = map->country_code[0];
 	efuse->country_code[1] = map->country_code[1];
@@ -1082,6 +1076,8 @@ static struct rtw_intf_phy_para_table phy_para_table_8822c = {
 
 static const struct rtw_rfe_def rtw8822c_rfe_defs[] = {
 	[0] = RTW_DEF_RFE(8822c, 0, 0),
+	[1] = RTW_DEF_RFE(8822c, 0, 0),
+	[2] = RTW_DEF_RFE(8822c, 0, 0),
 };
 
 static struct rtw_hw_reg rtw8822c_dig[] = {
@@ -1137,7 +1133,7 @@ struct rtw_chip_info rtw8822c_hw_spec = {
 	.tx_buf_desc_sz = 16,
 	.rx_pkt_desc_sz = 24,
 	.rx_buf_desc_sz = 8,
-	.phy_efuse_size = 1024,
+	.phy_efuse_size = 512,
 	.log_efuse_size = 768,
 	.ptct_efuse_size = 124,
 	.txff_size = 262144,
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.h b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
index e8abce0..d4806fd 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
@@ -8,27 +8,16 @@
 #include <asm/byteorder.h>
 
 struct rtw8822cu_efuse {
-	u8 res4[4];			/* 0xd0 */
-	u8 usb_optional_function;
-	u8 res5[0x1e];
-	u8 res6[2];
-	u8 serial[0x0b];		/* 0xf5 */
-	u8 vid;				/* 0x100 */
-	u8 res7;
-	u8 pid;
-	u8 res8[4];
-	u8 mac_addr[ETH_ALEN];		/* 0x107 */
-	u8 res9[2];
-	u8 vendor_name[0x07];
-	u8 res10[2];
-	u8 device_name[0x14];
-	u8 res11[0xcf];
-	u8 package_type;		/* 0x1fb */
-	u8 res12[0x4];
+	u8 res0[0x30];			/* 0x120 */
+	u8 vid[2];			/* 0x150 */
+	u8 pid[2];
+	u8 res1[3];
+	u8 mac_addr[ETH_ALEN];		/* 0x157 */
+	u8 res2[0x3d];
 };
 
 struct rtw8822ce_efuse {
-	u8 mac_addr[ETH_ALEN];		/* 0xd0 */
+	u8 mac_addr[ETH_ALEN];		/* 0x120 */
 	u8 vender_id[2];
 	u8 device_id[2];
 	u8 sub_vender_id[2];
@@ -36,20 +25,20 @@ struct rtw8822ce_efuse {
 	u8 pmc[2];
 	u8 exp_device_cap[2];
 	u8 msi_cap;
-	u8 ltr_cap;			/* 0xe3 */
+	u8 ltr_cap;			/* 0x133 */
 	u8 exp_link_control[2];
 	u8 link_cap[4];
 	u8 link_control[2];
 	u8 serial_number[8];
-	u8 res0:2;			/* 0xf4 */
+	u8 res0:2;			/* 0x144 */
 	u8 ltr_en:1;
 	u8 res1:2;
 	u8 obff:2;
 	u8 res2:3;
 	u8 obff_cap:2;
 	u8 res3:4;
-	u8 res4[3];
 	u8 class_code[3];
+	u8 res4;
 	u8 pci_pm_L1_2_supp:1;
 	u8 pci_pm_L1_1_supp:1;
 	u8 aspm_pm_L1_2_supp:1;
@@ -72,11 +61,9 @@ struct rtw8822c_efuse {
 
 	u8 channel_plan;		/* 0xb8 */
 	u8 xtal_k;
-	u8 thermal_meter;
+	u8 res1;
 	u8 iqk_lck;
-	u8 pa_type;			/* 0xbc */
-	u8 lna_type_2g[2];		/* 0xbd */
-	u8 lna_type_5g[2];
+	u8 res2[5];			/* 0xbc */
 	u8 rf_board_option;
 	u8 rf_feature_option;
 	u8 rf_bt_setting;
@@ -88,7 +75,21 @@ struct rtw8822c_efuse {
 	u8 rf_antenna_option;		/* 0xc9 */
 	u8 rfe_option;
 	u8 country_code[2];
-	u8 res[3];
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
 	union {
 		struct rtw8822cu_efuse u;
 		struct rtw8822ce_efuse e;
-- 
2.7.4

