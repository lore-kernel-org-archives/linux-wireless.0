Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26A6C433FE
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Dec 2020 13:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7040D23B51
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Dec 2020 13:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgLIN4Q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:56:16 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9050 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgLIN4Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Dec 2020 08:56:16 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CrdpY5L2Bzhpjj;
        Wed,  9 Dec 2020 21:55:01 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 21:55:24 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <pizza@shaftnet.org>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH wireless -next] cw1200: txrx: convert comma to semicolon
Date:   Wed, 9 Dec 2020 21:55:50 +0800
Message-ID: <20201209135550.2004-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Replace a comma between expression statements by a semicolon.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/wireless/st/cw1200/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/st/cw1200/txrx.c b/drivers/net/wireless/st/cw1200/txrx.c
index 400dd585916b..7de666b90ff5 100644
--- a/drivers/net/wireless/st/cw1200/txrx.c
+++ b/drivers/net/wireless/st/cw1200/txrx.c
@@ -650,7 +650,7 @@ cw1200_tx_h_rate_policy(struct cw1200_common *priv,
 	wsm->flags |= t->txpriv.rate_id << 4;
 
 	t->rate = cw1200_get_tx_rate(priv,
-		&t->tx_info->control.rates[0]),
+		&t->tx_info->control.rates[0]);
 	wsm->max_tx_rate = t->rate->hw_value;
 	if (t->rate->flags & IEEE80211_TX_RC_MCS) {
 		if (cw1200_ht_greenfield(&priv->ht_info))
-- 
2.22.0

