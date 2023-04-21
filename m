Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04206C77B7F
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Apr 2023 02:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbjDUCqh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Apr 2023 22:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbjDUCqf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2023 22:46:35 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3504265B7
        for <linux-wireless@vger.kernel.org>; Thu, 20 Apr 2023 19:46:29 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 33L2kNVe9016490, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 33L2kNVe9016490
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Fri, 21 Apr 2023 10:46:23 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Fri, 21 Apr 2023 10:46:02 +0800
Received: from localhost.localdomain (172.21.69.188) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 21 Apr 2023 10:46:02 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     <kvalo@kernel.org>
CC:     <leo.li@realtek.com>, <gary.chang@realtek.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/8] wifi: rtw89: use chip_info::small_fifo_size to choose debug_mask
Date:   Fri, 21 Apr 2023 10:45:48 +0800
Message-ID: <20230421024551.29994-6-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230421024551.29994-1-pkshih@realtek.com>
References: <20230421024551.29994-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.69.188]
X-ClientProxiedBy: RTEXH36505.realtek.com.tw (172.21.6.25) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Previously, 8852B has smaller FIFO size than others, so I use chip_id to
choose debug_mask before. 8851B has similar design, so add a field to
chip_info as a general expression.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h     | 1 +
 drivers/net/wireless/realtek/rtw89/pci.c      | 4 ++--
 drivers/net/wireless/realtek/rtw89/rtw8851b.c | 1 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c | 1 +
 drivers/net/wireless/realtek/rtw89/rtw8852b.c | 1 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c | 1 +
 6 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 43ac7b65d8665..0d7b056c77fbd 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -3129,6 +3129,7 @@ struct rtw89_chip_info {
 	u8 fw_format_max;
 	bool try_ce_fw;
 	u32 fifo_size;
+	bool small_fifo_size;
 	u32 dle_scc_rsvd_size;
 	u16 max_amsdu_limit;
 	bool dis_2g_40m_ul_ofdma;
diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 70b4754667c98..b53f346fef979 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -1003,10 +1003,10 @@ static u32 __rtw89_pci_check_and_reclaim_tx_resource(struct rtw89_dev *rtwdev,
 	min_cnt = min(bd_cnt, wd_cnt);
 	if (min_cnt == 0) {
 		/* This message can be frequently shown in low power mode or
-		 * high traffic with 8852B, and we have recognized it as normal
+		 * high traffic with small FIFO chips, and we have recognized it as normal
 		 * behavior, so print with mask RTW89_DBG_TXRX in these situations.
 		 */
-		if (rtwpci->low_power || chip->chip_id == RTL8852B)
+		if (rtwpci->low_power || chip->small_fifo_size)
 			debug_mask = RTW89_DBG_TXRX;
 		else
 			debug_mask = RTW89_DBG_UNEXP;
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851b.c b/drivers/net/wireless/realtek/rtw89/rtw8851b.c
index cc47bcbabfc97..2c3db08b68310 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851b.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851b.c
@@ -38,6 +38,7 @@ const struct rtw89_chip_info rtw8851b_chip_info = {
 	.fw_format_max		= RTW8851B_FW_FORMAT_MAX,
 	.try_ce_fw		= true,
 	.fifo_size		= 196608,
+	.small_fifo_size	= true,
 	.dle_scc_rsvd_size	= 98304,
 	.max_amsdu_limit	= 3500,
 	.dis_2g_40m_ul_ofdma	= true,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852a.c b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
index bd417c60171a0..58cb99003be94 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
@@ -2075,6 +2075,7 @@ const struct rtw89_chip_info rtw8852a_chip_info = {
 	.fw_format_max		= RTW8852A_FW_FORMAT_MAX,
 	.try_ce_fw		= false,
 	.fifo_size		= 458752,
+	.small_fifo_size	= false,
 	.dle_scc_rsvd_size	= 0,
 	.max_amsdu_limit	= 3500,
 	.dis_2g_40m_ul_ofdma	= true,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852b.c b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
index af74d0feeccb9..5a67f02557ee7 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852b.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
@@ -2506,6 +2506,7 @@ const struct rtw89_chip_info rtw8852b_chip_info = {
 	.fw_format_max		= RTW8852B_FW_FORMAT_MAX,
 	.try_ce_fw		= true,
 	.fifo_size		= 196608,
+	.small_fifo_size	= true,
 	.dle_scc_rsvd_size	= 98304,
 	.max_amsdu_limit	= 3500,
 	.dis_2g_40m_ul_ofdma	= true,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852c.c b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
index 3268be8fea6cc..35ba30f040c71 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852c.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
@@ -2805,6 +2805,7 @@ const struct rtw89_chip_info rtw8852c_chip_info = {
 	.fw_format_max		= RTW8852C_FW_FORMAT_MAX,
 	.try_ce_fw		= false,
 	.fifo_size		= 458752,
+	.small_fifo_size	= false,
 	.dle_scc_rsvd_size	= 0,
 	.max_amsdu_limit	= 8000,
 	.dis_2g_40m_ul_ofdma	= false,
-- 
2.25.1

