Return-Path: <SRS0=efDY=C3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E54C43463
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Sep 2020 10:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71C752075E
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Sep 2020 10:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgIRKSr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Sep 2020 06:18:47 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56580 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726533AbgIRKSZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Sep 2020 06:18:25 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 27BF4E6DBB8D80B0B27B;
        Fri, 18 Sep 2020 18:18:20 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 18:18:13 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next 7/9] rtlwifi: rtl8192ce: fix comparison to bool warning in hw.c
Date:   Fri, 18 Sep 2020 18:25:03 +0800
Message-ID: <20200918102505.16036-8-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
In-Reply-To: <20200918102505.16036-1-zhengbin13@huawei.com>
References: <20200918102505.16036-1-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes coccicheck warning:

drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c:616:14-20: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c:621:13-19: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c:626:14-20: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c:631:13-19: WARNING: Comparison to bool

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
index d4cd186036fd..bb5a0c4aec93 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
@@ -613,22 +613,22 @@ static bool _rtl92ce_llt_table_init(struct ieee80211_hw *hw)

 	for (i = 0; i < (txpktbuf_bndy - 1); i++) {
 		status = _rtl92ce_llt_write(hw, i, i + 1);
-		if (true != status)
+		if (!status)
 			return status;
 	}

 	status = _rtl92ce_llt_write(hw, (txpktbuf_bndy - 1), 0xFF);
-	if (true != status)
+	if (!status)
 		return status;

 	for (i = txpktbuf_bndy; i < maxpage; i++) {
 		status = _rtl92ce_llt_write(hw, i, (i + 1));
-		if (true != status)
+		if (!status)
 			return status;
 	}

 	status = _rtl92ce_llt_write(hw, maxpage, txpktbuf_bndy);
-	if (true != status)
+	if (!status)
 		return status;

 	return true;
--
2.26.0.106.g9fadedd

