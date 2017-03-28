Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:50743 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755094AbdC1JBd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 05:01:33 -0400
From: Elena Reshetova <elena.reshetova@intel.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-wireless@vger.kernel.org,
        ganeshgr@chelsio.com, nbd@openwrt.org, blogic@openwrt.org,
        matthias.bgg@gmail.com, yishaih@mellanox.com, saeedm@mellanox.com,
        matanb@mellanox.com, leonro@mellanox.com,
        ajk@comnets.uni-bremen.de, paulus@samba.org, j@w1.fi,
        kvalo@codeaurora.org, peterz@infradead.org, keescook@chromium.org,
        gregkh@linuxfoundation.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        David Windsor <dwindsor@gmail.com>
Subject: [PATCH 16/16] drivers, net, intersil: convert request_context.refcount from atomic_t to refcount_t
Date: Tue, 28 Mar 2017 11:56:43 +0300
Message-Id: <1490691403-4016-17-git-send-email-elena.reshetova@intel.com> (sfid-20170328_112613_500887_19FA883E)
In-Reply-To: <1490691403-4016-1-git-send-email-elena.reshetova@intel.com>
References: <1490691403-4016-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
index 98e1380..95dd03e 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -64,6 +64,7 @@
 #include <linux/etherdevice.h>
 #include <linux/wireless.h>
 #include <linux/firmware.h>
+#include <linux/refcount.h>
 
 #include "mic.h"
 #include "orinoco.h"
@@ -268,7 +269,7 @@ enum ezusb_state {
 
 struct request_context {
 	struct list_head list;
-	atomic_t refcount;
+	refcount_t refcount;
 	struct completion done;	/* Signals that CTX is dead */
 	int killed;
 	struct urb *outurb;	/* OUT for req pkt */
@@ -298,7 +299,7 @@ static inline u8 ezusb_reply_inc(u8 count)
 
 static void ezusb_request_context_put(struct request_context *ctx)
 {
-	if (!atomic_dec_and_test(&ctx->refcount))
+	if (!refcount_dec_and_test(&ctx->refcount))
 		return;
 
 	WARN_ON(!ctx->done.done);
@@ -328,7 +329,7 @@ static void ezusb_request_timerfn(u_long _ctx)
 	} else {
 		ctx->state = EZUSB_CTX_RESP_TIMEOUT;
 		dev_dbg(&ctx->outurb->dev->dev, "couldn't unlink\n");
-		atomic_inc(&ctx->refcount);
+		refcount_inc(&ctx->refcount);
 		ctx->killed = 1;
 		ezusb_ctx_complete(ctx);
 		ezusb_request_context_put(ctx);
@@ -361,7 +362,7 @@ static struct request_context *ezusb_alloc_ctx(struct ezusb_priv *upriv,
 	ctx->out_rid = out_rid;
 	ctx->in_rid = in_rid;
 
-	atomic_set(&ctx->refcount, 1);
+	refcount_set(&ctx->refcount, 1);
 	init_completion(&ctx->done);
 
 	setup_timer(&ctx->timer, ezusb_request_timerfn, (u_long)ctx);
@@ -469,7 +470,7 @@ static void ezusb_req_queue_run(struct ezusb_priv *upriv)
 	list_move_tail(&ctx->list, &upriv->req_active);
 
 	if (ctx->state == EZUSB_CTX_QUEUED) {
-		atomic_inc(&ctx->refcount);
+		refcount_inc(&ctx->refcount);
 		result = usb_submit_urb(ctx->outurb, GFP_ATOMIC);
 		if (result) {
 			ctx->state = EZUSB_CTX_REQSUBMIT_FAIL;
@@ -507,7 +508,7 @@ static void ezusb_req_enqueue_run(struct ezusb_priv *upriv,
 		spin_unlock_irqrestore(&upriv->req_lock, flags);
 		goto done;
 	}
-	atomic_inc(&ctx->refcount);
+	refcount_inc(&ctx->refcount);
 	list_add_tail(&ctx->list, &upriv->req_pending);
 	spin_unlock_irqrestore(&upriv->req_lock, flags);
 
@@ -1464,7 +1465,7 @@ static inline void ezusb_delete(struct ezusb_priv *upriv)
 		int err;
 
 		ctx = list_entry(item, struct request_context, list);
-		atomic_inc(&ctx->refcount);
+		refcount_inc(&ctx->refcount);
 
 		ctx->outurb->transfer_flags |= URB_ASYNC_UNLINK;
 		err = usb_unlink_urb(ctx->outurb);
-- 
2.7.4
