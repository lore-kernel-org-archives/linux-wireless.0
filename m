Return-Path: <SRS0=IwVr=W7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 096EFC3A5A8
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Sep 2019 06:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2B0F22CF5
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Sep 2019 06:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbfIDGrB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 4 Sep 2019 02:47:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6200 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726033AbfIDGrA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Sep 2019 02:47:00 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 16EF720EACC9E19A8E38;
        Wed,  4 Sep 2019 14:46:50 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 14:46:42 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>
CC:     <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <zhongjiang@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ath9k: Remove unneeded variable to store return value
Date:   Wed, 4 Sep 2019 14:43:48 +0800
Message-ID: <1567579428-16377-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ath9k_reg_rmw_single do not need return value to cope with different
cases. And change functon return type to void.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 214c682..d961095 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -463,7 +463,7 @@ static void ath9k_enable_rmw_buffer(void *hw_priv)
 	atomic_inc(&priv->wmi->m_rmw_cnt);
 }
 
-static u32 ath9k_reg_rmw_single(void *hw_priv,
+static void ath9k_reg_rmw_single(void *hw_priv,
 				 u32 reg_offset, u32 set, u32 clr)
 {
 	struct ath_hw *ah = hw_priv;
@@ -471,7 +471,6 @@ static u32 ath9k_reg_rmw_single(void *hw_priv,
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *) common->priv;
 	struct register_rmw buf, buf_ret;
 	int ret;
-	u32 val = 0;
 
 	buf.reg = cpu_to_be32(reg_offset);
 	buf.set = cpu_to_be32(set);
@@ -485,7 +484,6 @@ static u32 ath9k_reg_rmw_single(void *hw_priv,
 		ath_dbg(common, WMI, "REGISTER RMW FAILED:(0x%04x, %d)\n",
 			reg_offset, ret);
 	}
-	return val;
 }
 
 static u32 ath9k_reg_rmw(void *hw_priv, u32 reg_offset, u32 set, u32 clr)
-- 
1.7.12.4

