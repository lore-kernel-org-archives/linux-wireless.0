Return-Path: <SRS0=PYjY=C7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45015C2D0E2
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Sep 2020 11:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09260221EB
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Sep 2020 11:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgIVLbB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Sep 2020 07:31:01 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:56112 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726454AbgIVLbB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Sep 2020 07:31:01 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 24B7DA009396B05D645B;
        Tue, 22 Sep 2020 19:30:56 +0800 (CST)
Received: from huawei.com (10.175.104.57) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Tue, 22 Sep 2020
 19:30:52 +0800
From:   Li Heng <liheng40@huawei.com>
To:     <ath9k-devel@qca.qualcomm.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] ath9k: Remove set but not used variable
Date:   Tue, 22 Sep 2020 19:30:52 +0800
Message-ID: <1600774252-48564-1-git-send-email-liheng40@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.104.57]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This addresses the following gcc warning with "make W=1":

drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h:1338:18: warning:
‘ar9580_1p0_pcie_phy_clkreq_disable_L1’ defined but not used [-Wunused-const-variable=]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Li Heng <liheng40@huawei.com>
---
 drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
index f4c9bef..f67f537 100644
--- a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
@@ -1335,13 +1335,6 @@ static const u32 ar9580_1p0_pcie_phy_clkreq_enable_L1[][2] = {
 	{0x00004044, 0x00000000},
 };

-static const u32 ar9580_1p0_pcie_phy_clkreq_disable_L1[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x0831365e},
-	{0x00004040, 0x0008003b},
-	{0x00004044, 0x00000000},
-};
-
 static const u32 ar9580_1p0_pcie_phy_pll_on_clkreq[][2] = {
 	/* Addr      allmodes  */
 	{0x00004040, 0x0831265e},
--
2.7.4

