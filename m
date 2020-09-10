Return-Path: <SRS0=qoP/=CT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A71C2D0A7
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Sep 2020 21:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EA3C20829
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Sep 2020 21:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgIJVAd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Sep 2020 17:00:33 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12219 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730817AbgIJOpe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Sep 2020 10:45:34 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D7ED8128FEC0F2373102;
        Thu, 10 Sep 2020 21:52:30 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 21:52:22 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next 1/3] rtlwifi: rtl8188ee: fix comparison pointer to bool warning in phy.c
Date:   Thu, 10 Sep 2020 21:59:15 +0800
Message-ID: <20200910135917.143723-2-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
In-Reply-To: <20200910135917.143723-1-zhengbin13@huawei.com>
References: <20200910135917.143723-1-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes coccicheck warning:

drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c:1584:14-18: WARNING: Comparison to bool

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
index 63ec5a20b67b..38d4432767e8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
@@ -1581,7 +1581,7 @@ static void _rtl88e_phy_path_adda_on(struct ieee80211_hw *hw,
 	u32 i;

 	pathon = is_patha_on ? 0x04db25a4 : 0x0b1b25a4;
-	if (false == is2t) {
+	if (!is2t) {
 		pathon = 0x0bdb25a0;
 		rtl_set_bbreg(hw, addareg[0], MASKDWORD, 0x0b1b25a0);
 	} else {
--
2.26.0.106.g9fadedd

