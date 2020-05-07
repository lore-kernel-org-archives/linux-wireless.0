Return-Path: <SRS0=9CG8=6V=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3986C38A2A
	for <linux-wireless@archiver.kernel.org>; Thu,  7 May 2020 11:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A34F2053B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 May 2020 11:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgEGLI3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 May 2020 07:08:29 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49834 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725910AbgEGLI3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 May 2020 07:08:29 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 706F79169ECFE8040AF6;
        Thu,  7 May 2020 19:08:27 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Thu, 7 May 2020
 19:08:21 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <tglx@linutronix.de>, <linux-wireless@vger.kernel.org>,
        <b43-dev@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] b43: remove dead function b43_rssinoise_postprocess()
Date:   Thu, 7 May 2020 19:07:41 +0800
Message-ID: <20200507110741.37757-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This function is dead for more than 10 years. Remove it.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/broadcom/b43/xmit.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/xmit.c b/drivers/net/wireless/broadcom/b43/xmit.c
index 058745219516..55babc6d1091 100644
--- a/drivers/net/wireless/broadcom/b43/xmit.c
+++ b/drivers/net/wireless/broadcom/b43/xmit.c
@@ -629,19 +629,6 @@ static s8 b43_rssi_postprocess(struct b43_wldev *dev,
 	return (s8) tmp;
 }
 
-//TODO
-#if 0
-static s8 b43_rssinoise_postprocess(struct b43_wldev *dev, u8 in_rssi)
-{
-	struct b43_phy *phy = &dev->phy;
-	s8 ret;
-
-	ret = b43_rssi_postprocess(dev, in_rssi, 0, 1, 1);
-
-	return ret;
-}
-#endif
-
 void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 {
 	struct ieee80211_rx_status status;
-- 
2.21.1

