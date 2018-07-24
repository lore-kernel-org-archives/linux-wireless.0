Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:57114 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388471AbeGXLFh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 07:05:37 -0400
From: Daniel Mack <daniel@zonque.org>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, colin.king@canonical.com,
        shikha.singh@st.com, Daniel Mack <daniel@zonque.org>
Subject: [PATCH v3 03/11] NFC: st95hf: drop illegal kfree_skb() in IRQ handler
Date: Tue, 24 Jul 2018 11:59:33 +0200
Message-Id: <20180724095941.25777-4-daniel@zonque.org> (sfid-20180724_120138_125898_61F72A39)
In-Reply-To: <20180724095941.25777-1-daniel@zonque.org>
References: <20180724095941.25777-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the error path of the IRQ handler, don't free the skb in flight. The
callback in the digital core will do that for us. Doing it from both
places causes a memory corruption.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/nfc/st95hf/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index d58424ab5c48..d857197ec7b2 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -863,7 +863,6 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
 	return IRQ_HANDLED;
 
 end:
-	kfree_skb(skb_resp);
 	wtx = false;
 	cb_arg->rats = false;
 	skb_resp = ERR_PTR(result);
-- 
2.17.1
