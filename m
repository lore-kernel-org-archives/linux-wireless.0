Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE8BCCA47F
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Jul 2022 07:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbiGSH4o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Jul 2022 03:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236764AbiGSH4n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jul 2022 03:56:43 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05C622B1F;
        Tue, 19 Jul 2022 00:56:41 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VJqwIJv_1658217398;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VJqwIJv_1658217398)
          by smtp.aliyun-inc.com;
          Tue, 19 Jul 2022 15:56:39 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     johannes@sipsolutions.net, Larry.Finger@lwfinger.net,
        kvalo@kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next v2] wifi: b43legacy: clean up one inconsistent indenting
Date:   Tue, 19 Jul 2022 15:56:37 +0800
Message-Id: <20220719075637.111716-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Eliminate the follow smatch warning:
drivers/net/wireless/broadcom/b43legacy/main.c:2947 b43legacy_wireless_core_stop() warn: inconsistent indenting

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/wireless/broadcom/b43legacy/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
index cbc21c7c3138..4022c544aefe 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -2944,7 +2944,7 @@ static void b43legacy_wireless_core_stop(struct b43legacy_wldev *dev)
 			dev_kfree_skb(skb_dequeue(&wl->tx_queue[queue_num]));
 	}
 
-b43legacy_mac_suspend(dev);
+	b43legacy_mac_suspend(dev);
 	free_irq(dev->dev->irq, dev);
 	b43legacydbg(wl, "Wireless interface stopped\n");
 }
-- 
2.20.1.7.g153144c

