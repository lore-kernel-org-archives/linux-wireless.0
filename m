Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:33800 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935084AbeF2MrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 08:47:24 -0400
From: Daniel Mack <daniel@zonque.org>
To: sameo@linux.intel.com, davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, Daniel Mack <daniel@zonque.org>
Subject: [PATCH 2/2] nfc: st95hf: drop another illegal kfree_skb()
Date: Fri, 29 Jun 2018 14:47:17 +0200
Message-Id: <20180629124717.2011-2-daniel@zonque.org> (sfid-20180629_144731_537203_FD7B1E19)
In-Reply-To: <20180629124717.2011-1-daniel@zonque.org>
References: <20180629124717.2011-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the error path of the IRQ handler, don't free the skb in flight. The
callback in the digital core will do that for us, so this is another
double-free that leads to memory corruptions.

The assignment of 'wtx' doesn't make sense as the variable is not read
after it is written. Drop it.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/nfc/st95hf/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index ef91ca8b53a4..e651e1aae5a3 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -868,8 +868,6 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
 	return IRQ_HANDLED;
 
 end:
-	kfree_skb(skb_resp);
-	wtx = false;
 	cb_arg->rats = false;
 	skb_resp = ERR_PTR(result);
 	/* call of callback with error */
-- 
2.17.1
