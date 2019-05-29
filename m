Return-Path: <SRS0=kjT+=T5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52974C04AB3
	for <linux-wireless@archiver.kernel.org>; Wed, 29 May 2019 07:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26CF421019
	for <linux-wireless@archiver.kernel.org>; Wed, 29 May 2019 07:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfE2Hy6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 29 May 2019 03:54:58 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:37203 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfE2Hy5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 May 2019 03:54:57 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x4T7ssjP005558, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x4T7ssjP005558
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Wed, 29 May 2019 15:54:54 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Wed, 29 May 2019 15:54:53 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>
Subject: [PATCH 05/11] rtw88: fix incorrect tx power limit at 5G
Date:   Wed, 29 May 2019 15:54:41 +0800
Message-ID: <1559116487-5244-6-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559116487-5244-1-git-send-email-yhchuang@realtek.com>
References: <1559116487-5244-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.126]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Tx power limit is stored separately by 2G and 5G.
But driver did not get tx power limit from 5G and causes incorrect tx
power. Check if the channel is beyond 2G and get the corresponding tx
power limit.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/phy.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index a7c7fd1..ac6912a 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -1461,15 +1461,6 @@ static u8 rtw_phy_get_5g_tx_power_index(struct rtw_dev *rtwdev,
 	return tx_power;
 }
 
-static s8 __rtw_phy_get_tx_power_limit(struct rtw_hal *hal,
-				       u8 bw, u8 rs, u8 ch, u8 regd)
-{
-	if (regd > RTW_REGD_WW)
-		return RTW_MAX_POWER_INDEX;
-
-	return hal->tx_pwr_limit_2g[regd][bw][rs][ch];
-}
-
 static s8 rtw_phy_get_tx_power_limit(struct rtw_dev *rtwdev, u8 band,
 				     enum rtw_bandwidth bw, u8 rf_path,
 				     u8 rate, u8 channel, u8 regd)
@@ -1479,6 +1470,9 @@ static s8 rtw_phy_get_tx_power_limit(struct rtw_dev *rtwdev, u8 band,
 	u8 rs;
 	int ch_idx;
 
+	if (regd > RTW_REGD_WW)
+		return RTW_MAX_POWER_INDEX;
+
 	if (rate >= DESC_RATE1M && rate <= DESC_RATE11M)
 		rs = RTW_RATE_SECTION_CCK;
 	else if (rate >= DESC_RATE6M && rate <= DESC_RATE54M)
@@ -1498,7 +1492,10 @@ static s8 rtw_phy_get_tx_power_limit(struct rtw_dev *rtwdev, u8 band,
 	if (ch_idx < 0)
 		goto err;
 
-	power_limit = __rtw_phy_get_tx_power_limit(hal, bw, rs, ch_idx, regd);
+	if (channel <= RTW_MAX_CHANNEL_NUM_2G)
+		power_limit = hal->tx_pwr_limit_2g[regd][bw][rs][ch_idx];
+	else
+		power_limit = hal->tx_pwr_limit_5g[regd][bw][rs][ch_idx];
 
 	return power_limit;
 
-- 
2.7.4

