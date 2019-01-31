Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B72C282DA
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 12:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E987E218AC
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 12:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732819AbfAaMWK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 07:22:10 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:53727 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732798AbfAaMWI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 07:22:08 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0VCLrpH016777, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0VCLrpH016777
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 31 Jan 2019 20:21:53 +0800
Received: from localhost.localdomain (172.21.68.143) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 31 Jan 2019 20:21:52 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <Larry.Finger@lwfinger.net>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/24] rtw88: 8822c: update trx mode setting
Date:   Thu, 31 Jan 2019 20:21:24 +0800
Message-ID: <1548937297-14660-12-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
References: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.143]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chien-Hsun Liao <ben.liao@realtek.com>

We rearrange the coding style of trx mode setting based on ofdm_tx,
ofdm_rx, cck_tx and cck_rx. We also modify cck_rx 1r setting because the
original is incorrect and could cause the degradation of sensitivity.

Signed-off-by: Chien-Hsun Liao <ben.liao@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 132 ++++++++++++++------------
 1 file changed, 72 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index c10894e..40008d7 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -524,81 +524,26 @@ static void rtw8822c_set_channel(struct rtw_dev *rtwdev, u8 channel, u8 bw,
 	rtw8822c_toggle_igi(rtwdev);
 }
 
-static void rtw8822c_config_trx_mode(struct rtw_dev *rtwdev, u8 tx_path,
-				     u8 rx_path, bool is_tx2_path)
+static void rtw8822c_config_cck_rx_path(struct rtw_dev *rtwdev, u8 rx_path)
 {
-	if ((tx_path | rx_path) & BB_PATH_A)
-		rtw_write32_mask(rtwdev, REG_ORITXCODE, MASK20BITS, 0x33312);
-	else
-		rtw_write32_mask(rtwdev, REG_ORITXCODE, MASK20BITS, 0x11111);
-	if ((tx_path | rx_path) & BB_PATH_B)
-		rtw_write32_mask(rtwdev, REG_ORITXCODE2, MASK20BITS, 0x33312);
-	else
-		rtw_write32_mask(rtwdev, REG_ORITXCODE2, MASK20BITS, 0x11111);
-
-	rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0xf0000000, 0x8);
-	rtw_write32_mask(rtwdev, REG_CCKPATH, BIT(30), 0x1);
-
-	if (tx_path == BB_PATH_A)
-		rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0xf0000000, 0x8);
-	else if (tx_path == BB_PATH_B)
-		rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0xf0000000, 0x4);
-	else if (tx_path == BB_PATH_AB)
-		rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0xf0000000, 0xc);
-
-	rtw_write32_mask(rtwdev, REG_TXANTSEG, 0xf, tx_path);
-	rtw_write32_mask(rtwdev, REG_ENFN, BIT(16), 0x0);
-	rtw_write32_mask(rtwdev, REG_ENFN, BIT(31), 0x1);
-
-	if (tx_path == BB_PATH_A) {
-		rtw_write32_mask(rtwdev, REG_ANTMAP0, 0xf, 0x1);
-		rtw_write32_mask(rtwdev, REG_TXLGMAP, 0x3, 0x0);
-		rtw_write32_mask(rtwdev, REG_TXLGMAP, 0xc, 0x0);
-	} else if (tx_path == BB_PATH_B) {
-		rtw_write32_mask(rtwdev, REG_ANTMAP0, 0xf, 0x2);
-		rtw_write32_mask(rtwdev, REG_TXLGMAP, 0x3, 0x0);
-		rtw_write32_mask(rtwdev, REG_TXLGMAP, 0xc, 0x0);
-	} else if (tx_path == BB_PATH_AB) {
-		rtw_write32_mask(rtwdev, REG_ANTMAP0, 0xf, 0x3);
-		rtw_write32_mask(rtwdev, REG_TXLGMAP, 0x3, 0x0);
-		rtw_write32_mask(rtwdev, REG_TXLGMAP, 0xc, 0x1);
-	}
-
-	if (tx_path == BB_PATH_A || tx_path == BB_PATH_B) {
-		rtw_write32_mask(rtwdev, REG_ANTMAP0, 0xf0, 0x1);
-		rtw_write32_mask(rtwdev, REG_TXLGMAP, 0x300, 0x0);
-		rtw_write32_mask(rtwdev, REG_TXLGMAP, 0xc00, 0x0);
-	} else if (tx_path == BB_PATH_AB) {
-		rtw_write32_mask(rtwdev, REG_ANTMAP0, 0xf0, 0x3);
-		rtw_write32_mask(rtwdev, REG_TXLGMAP, 0x300, 0x0);
-		rtw_write32_mask(rtwdev, REG_TXLGMAP, 0xc00, 0x1);
-	}
-	rtw_write32_mask(rtwdev, REG_TXANT, 0xf, tx_path);
-
 	if (rx_path == BB_PATH_A || rx_path == BB_PATH_B) {
+		rtw_write32_mask(rtwdev, REG_CCANRX, 0x00060000, 0x0);
 		rtw_write32_mask(rtwdev, REG_CCANRX, 0x00600000, 0x0);
 	} else if (rx_path == BB_PATH_AB) {
 		rtw_write32_mask(rtwdev, REG_CCANRX, 0x00600000, 0x1);
 		rtw_write32_mask(rtwdev, REG_CCANRX, 0x00060000, 0x1);
 	}
 
-	rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0x0f000000, 0x0);
-
 	if (rx_path == BB_PATH_A)
 		rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0x0f000000, 0x0);
 	else if (rx_path == BB_PATH_B)
 		rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0x0f000000, 0x5);
 	else if (rx_path == BB_PATH_AB)
 		rtw_write32_mask(rtwdev, REG_RXCCKSEL, 0x0f000000, 0x1);
+}
 
-	rtw_write32_mask(rtwdev, REG_ANTMAP, MASKBYTE3LOWNIBBLE, rx_path);
-	rtw_write32_mask(rtwdev, REG_ANTMAP, 0x000F0000, rx_path);
-
-	if (!(rx_path & BB_PATH_A))
-		rtw_write_rf(rtwdev, 0, 0, 0xf0000, 0x1);
-	if (!(rx_path & BB_PATH_B))
-		rtw_write_rf(rtwdev, 1, 0, 0xf0000, 0x1);
-
+static void rtw8822c_config_ofdm_rx_path(struct rtw_dev *rtwdev, u8 rx_path)
+{
 	if (rx_path == BB_PATH_A || rx_path == BB_PATH_B) {
 		rtw_write32_mask(rtwdev, REG_RXFNCTL, 0x300, 0x0);
 		rtw_write32_mask(rtwdev, REG_RXFNCTL, 0x600000, 0x0);
@@ -613,6 +558,73 @@ static void rtw8822c_config_trx_mode(struct rtw_dev *rtwdev, u8 tx_path,
 		rtw_write32_mask(rtwdev, REG_MRCM, BIT(24), 0x1);
 	}
 
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
 	rtw8822c_toggle_igi(rtwdev);
 }
 
-- 
2.7.4

