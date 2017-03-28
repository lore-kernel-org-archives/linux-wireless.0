Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30539 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754838AbdC1I6c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 04:58:32 -0400
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
Subject: [PATCH 14/16] drivers, net, ppp: convert syncppp.refcnt from atomic_t to refcount_t
Date: Tue, 28 Mar 2017 11:56:41 +0300
Message-Id: <1490691403-4016-15-git-send-email-elena.reshetova@intel.com> (sfid-20170328_112614_796738_45A31A2A)
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
 drivers/net/ppp/ppp_synctty.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ppp/ppp_synctty.c b/drivers/net/ppp/ppp_synctty.c
index 9ae5398..4a643f8 100644
--- a/drivers/net/ppp/ppp_synctty.c
+++ b/drivers/net/ppp/ppp_synctty.c
@@ -46,6 +46,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
+#include <linux/refcount.h>
 #include <asm/unaligned.h>
 #include <linux/uaccess.h>
 
@@ -72,7 +73,7 @@ struct syncppp {
 
 	struct tasklet_struct tsk;
 
-	atomic_t	refcnt;
+	refcount_t	refcnt;
 	struct completion dead_cmp;
 	struct ppp_channel chan;	/* interface to generic ppp layer */
 };
@@ -141,14 +142,14 @@ static struct syncppp *sp_get(struct tty_struct *tty)
 	read_lock(&disc_data_lock);
 	ap = tty->disc_data;
 	if (ap != NULL)
-		atomic_inc(&ap->refcnt);
+		refcount_inc(&ap->refcnt);
 	read_unlock(&disc_data_lock);
 	return ap;
 }
 
 static void sp_put(struct syncppp *ap)
 {
-	if (atomic_dec_and_test(&ap->refcnt))
+	if (refcount_dec_and_test(&ap->refcnt))
 		complete(&ap->dead_cmp);
 }
 
@@ -182,7 +183,7 @@ ppp_sync_open(struct tty_struct *tty)
 	skb_queue_head_init(&ap->rqueue);
 	tasklet_init(&ap->tsk, ppp_sync_process, (unsigned long) ap);
 
-	atomic_set(&ap->refcnt, 1);
+	refcount_set(&ap->refcnt, 1);
 	init_completion(&ap->dead_cmp);
 
 	ap->chan.private = ap;
@@ -232,7 +233,7 @@ ppp_sync_close(struct tty_struct *tty)
 	 * our channel ops (i.e. ppp_sync_send/ioctl) are in progress
 	 * by the time it returns.
 	 */
-	if (!atomic_dec_and_test(&ap->refcnt))
+	if (!refcount_dec_and_test(&ap->refcnt))
 		wait_for_completion(&ap->dead_cmp);
 	tasklet_kill(&ap->tsk);
 
-- 
2.7.4
