Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57640 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754782AbdC1I63 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 04:58:29 -0400
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
Subject: [PATCH 13/16] drivers, net, ppp: convert ppp_file.refcnt from atomic_t to refcount_t
Date: Tue, 28 Mar 2017 11:56:40 +0300
Message-Id: <1490691403-4016-14-git-send-email-elena.reshetova@intel.com> (sfid-20170328_112612_355047_281878F1)
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
 drivers/net/ppp/ppp_generic.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index f9c0e62..7b1352c 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -51,6 +51,7 @@
 #include <asm/unaligned.h>
 #include <net/slhc_vj.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 
 #include <linux/nsproxy.h>
 #include <net/net_namespace.h>
@@ -84,7 +85,7 @@ struct ppp_file {
 	struct sk_buff_head xq;		/* pppd transmit queue */
 	struct sk_buff_head rq;		/* receive queue for pppd */
 	wait_queue_head_t rwait;	/* for poll on reading /dev/ppp */
-	atomic_t	refcnt;		/* # refs (incl /dev/ppp attached) */
+	refcount_t	refcnt;		/* # refs (incl /dev/ppp attached) */
 	int		hdrlen;		/* space to leave for headers */
 	int		index;		/* interface unit / channel number */
 	int		dead;		/* unit/channel has been shut down */
@@ -407,7 +408,7 @@ static int ppp_release(struct inode *unused, struct file *file)
 				unregister_netdevice(ppp->dev);
 			rtnl_unlock();
 		}
-		if (atomic_dec_and_test(&pf->refcnt)) {
+		if (refcount_dec_and_test(&pf->refcnt)) {
 			switch (pf->kind) {
 			case INTERFACE:
 				ppp_destroy_interface(PF_TO_PPP(pf));
@@ -880,7 +881,7 @@ static int ppp_unattached_ioctl(struct net *net, struct ppp_file *pf,
 		mutex_lock(&pn->all_ppp_mutex);
 		ppp = ppp_find_unit(pn, unit);
 		if (ppp) {
-			atomic_inc(&ppp->file.refcnt);
+			refcount_inc(&ppp->file.refcnt);
 			file->private_data = &ppp->file;
 			err = 0;
 		}
@@ -895,7 +896,7 @@ static int ppp_unattached_ioctl(struct net *net, struct ppp_file *pf,
 		spin_lock_bh(&pn->all_channels_lock);
 		chan = ppp_find_channel(pn, unit);
 		if (chan) {
-			atomic_inc(&chan->file.refcnt);
+			refcount_inc(&chan->file.refcnt);
 			file->private_data = &chan->file;
 			err = 0;
 		}
@@ -2641,7 +2642,7 @@ ppp_unregister_channel(struct ppp_channel *chan)
 
 	pch->file.dead = 1;
 	wake_up_interruptible(&pch->file.rwait);
-	if (atomic_dec_and_test(&pch->file.refcnt))
+	if (refcount_dec_and_test(&pch->file.refcnt))
 		ppp_destroy_channel(pch);
 }
 
@@ -3011,7 +3012,7 @@ init_ppp_file(struct ppp_file *pf, int kind)
 	pf->kind = kind;
 	skb_queue_head_init(&pf->xq);
 	skb_queue_head_init(&pf->rq);
-	atomic_set(&pf->refcnt, 1);
+	refcount_set(&pf->refcnt, 1);
 	init_waitqueue_head(&pf->rwait);
 }
 
@@ -3128,7 +3129,7 @@ ppp_connect_channel(struct channel *pch, int unit)
 	list_add_tail(&pch->clist, &ppp->channels);
 	++ppp->n_channels;
 	pch->ppp = ppp;
-	atomic_inc(&ppp->file.refcnt);
+	refcount_inc(&ppp->file.refcnt);
 	ppp_unlock(ppp);
 	ret = 0;
 
@@ -3159,7 +3160,7 @@ ppp_disconnect_channel(struct channel *pch)
 		if (--ppp->n_channels == 0)
 			wake_up_interruptible(&ppp->file.rwait);
 		ppp_unlock(ppp);
-		if (atomic_dec_and_test(&ppp->file.refcnt))
+		if (refcount_dec_and_test(&ppp->file.refcnt))
 			ppp_destroy_interface(ppp);
 		err = 0;
 	}
-- 
2.7.4
