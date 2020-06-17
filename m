Return-Path: <SRS0=BEmV=76=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80064C433E2
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Jun 2020 21:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FFA520810
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Jun 2020 21:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgFQVZQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Jun 2020 17:25:16 -0400
Received: from muru.com ([72.249.23.125]:58172 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgFQVZQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jun 2020 17:25:16 -0400
Received: from hillo.muru.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTP id D8609802A;
        Wed, 17 Jun 2020 21:26:07 +0000 (UTC)
From:   Tony Lindgren <tony@atomide.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Eyal Reizer <eyalr@ti.com>, Guy Mishol <guym@ti.com>,
        linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH 2/4] wlcore: Use spin_trylock in wlcore_irq() to see if we need to queue tx
Date:   Wed, 17 Jun 2020 14:25:03 -0700
Message-Id: <20200617212505.62519-3-tony@atomide.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200617212505.62519-1-tony@atomide.com>
References: <20200617212505.62519-1-tony@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We need the spinlock to check if we need to queue tx in wlcore_irq().
Let's use spin_trylock instead and always queue tx unless we know there's
nothing to do.

Let's also update the comment a bit while at it.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -652,6 +652,7 @@ static irqreturn_t wlcore_irq(int irq, void *cookie)
 	int ret;
 	unsigned long flags;
 	struct wl1271 *wl = cookie;
+	bool queue_tx_work = true;
 
 	/* complete the ELP completion */
 	spin_lock_irqsave(&wl->wl_lock, flags);
@@ -682,13 +683,17 @@ static irqreturn_t wlcore_irq(int irq, void *cookie)
 	if (ret)
 		wl12xx_queue_recovery_work(wl);
 
-	spin_lock_irqsave(&wl->wl_lock, flags);
-	/* In case TX was not handled here, queue TX work */
+	/* In case TX was not handled in wlcore_irq_locked(), queue TX work */
 	clear_bit(WL1271_FLAG_TX_PENDING, &wl->flags);
-	if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags) &&
-	    wl1271_tx_total_queue_count(wl) > 0)
-		ieee80211_queue_work(wl->hw, &wl->tx_work);
-	spin_unlock_irqrestore(&wl->wl_lock, flags);
+	if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags)) {
+		if (spin_trylock_irqsave(&wl->wl_lock, flags)) {
+			if (!wl1271_tx_total_queue_count(wl))
+				queue_tx_work = false;
+			spin_unlock_irqrestore(&wl->wl_lock, flags);
+		}
+		if (queue_tx_work)
+			ieee80211_queue_work(wl->hw, &wl->tx_work);
+	}
 
 	mutex_unlock(&wl->mutex);
 
-- 
2.27.0
