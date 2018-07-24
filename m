Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:57166 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388407AbeGXLFo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 07:05:44 -0400
From: Daniel Mack <daniel@zonque.org>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, colin.king@canonical.com,
        shikha.singh@st.com, Daniel Mack <daniel@zonque.org>
Subject: [PATCH v3 07/11] NFC: st95hf: ignore spurious interrupts
Date: Tue, 24 Jul 2018 11:59:37 +0200
Message-Id: <20180724095941.25777-8-daniel@zonque.org> (sfid-20180724_120140_396089_0EB6FE36)
In-Reply-To: <20180724095941.25777-1-daniel@zonque.org>
References: <20180724095941.25777-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an interrupt occurs before st95hf_in_send_cmd() was called, the ISR
will currently dereference a NULL pointer. Fix this by checking whether
`cb_arg->complete_cb' is set, and bail out early if that's not the case.

Again spurious interrupts are likely to occur with EMI noise through the
antenna, and need to be handled gracefully.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/nfc/st95hf/core.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 99f84ddfdfef..7fdad67b1a4d 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -796,6 +796,13 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
 		goto end;
 	}
 
+	/*
+	 * If the completion callback is not set, no command is currently
+	 * active. Ignore the spurious interrupt.
+	 */
+	if (unlikely(!cb_arg->complete_cb))
+		goto end;
+
 	/* if stcontext->ddev is %NULL, it means remove already ran */
 	if (!stcontext->ddev) {
 		result = -ENODEV;
@@ -844,8 +851,16 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
 	wtx = false;
 	cb_arg->rats = false;
 	skb_resp = ERR_PTR(result);
-	/* call of callback with error */
-	cb_arg->complete_cb(stcontext->ddev, cb_arg->cb_usrarg, skb_resp);
+
+	/*
+	 * Report an error to the core. If cb_arg->complete_cb is unset,
+	 * we're handling a spurious interrupt that can be ignored.
+	 */
+	if (cb_arg->complete_cb)
+		cb_arg->complete_cb(stcontext->ddev,
+				    cb_arg->cb_usrarg,
+				    skb_resp);
+
 	mutex_unlock(&stcontext->rm_lock);
 	return IRQ_HANDLED;
 }
-- 
2.17.1
