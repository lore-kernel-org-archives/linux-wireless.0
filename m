Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68707C169C4
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 03:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34C132184D
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 03:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbfA3DPm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 22:15:42 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:45628 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729213AbfA3DPm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 22:15:42 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 55B9C37E03DF41B4498F;
        Wed, 30 Jan 2019 11:15:40 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.408.0; Wed, 30 Jan 2019
 11:15:31 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <pkshih@realtek.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH][RESEND] rtlwifi: remove set but not used variable 'cmd_seq'
Date:   Wed, 30 Jan 2019 11:15:26 +0800
Message-ID: <20190130031526.20308-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtlwifi/base.c: In function 'rtl_c2h_content_parsing':
drivers/net/wireless/realtek/rtlwifi/base.c:2313:13: warning:
 variable 'cmd_seq' set but not used [-Wunused-but-set-variable]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index ef9b502..ee726f4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -2311,11 +2311,10 @@ static void rtl_c2h_content_parsing(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal_ops *hal_ops = rtlpriv->cfg->ops;
 	const struct rtl_btc_ops *btc_ops = rtlpriv->btcoexist.btc_ops;
-	u8 cmd_id, cmd_seq, cmd_len;
+	u8 cmd_id, cmd_len;
 	u8 *cmd_buf = NULL;
 
 	cmd_id = GET_C2H_CMD_ID(skb->data);
-	cmd_seq = GET_C2H_SEQ(skb->data);
 	cmd_len = skb->len - C2H_DATA_OFFSET;
 	cmd_buf = GET_C2H_DATA_PTR(skb->data);
 
-- 
2.7.4


