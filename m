Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4193 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410Ab1GNVaC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:30:02 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 32/35] staging: brcm80211: replace semaphore by
 wait_queue for sysioc thread
Date: Thu, 14 Jul 2011 14:29:28 -0700
Message-ID: <1310678971-28952-33-git-send-email-frankyl@broadcom.com> (sfid-20110714_233119_009949_99F2A0D5)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The sysioc thread was triggered using a semaphore. Now it waits for
a wake_up() on its wait queue and the semaphore has been removed as
the semaphore serves another purpose. This removes a checkpatch
warning for dhd_linux.c.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   27 ++++++++++++++++--------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 41d3e81..ea49f01 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -29,6 +29,7 @@
 #include <linux/fs.h>
 #include <linux/uaccess.h>
 #include <linux/mutex.h>
+#include <linux/wait.h>
 #include <net/cfg80211.h>
 #include <defs.h>
 #include <brcmu_utils.h>
@@ -78,7 +79,7 @@ struct brcmf_info {
 
 	/* Thread to issue ioctl for multicast */
 	struct task_struct *sysioc_tsk;
-	struct semaphore sysioc_sem;
+	wait_queue_head_t sysioc_waitq;
 	bool set_multicast;
 	bool set_macaddress;
 	u8 macvalue[ETH_ALEN];
@@ -493,12 +494,20 @@ static int _brcmf_sysioc_thread(void *data)
 #ifdef SOFTAP
 	bool in_ap = false;
 #endif
-
+	DECLARE_WAITQUEUE(wait, current);
 	allow_signal(SIGTERM);
 
-	while (down_interruptible(&drvr_priv->sysioc_sem) == 0) {
+	add_wait_queue(&drvr_priv->sysioc_waitq, &wait);
+	while (1) {
+		prepare_to_wait(&drvr_priv->sysioc_waitq, &wait,
+				TASK_INTERRUPTIBLE);
+
+		/* wait for event */
+		schedule();
+
 		if (kthread_should_stop())
 			break;
+
 		for (i = 0; i < BRCMF_MAX_IFS; i++) {
 			struct brcmf_if *ifentry = drvr_priv->iflist[i];
 			if (ifentry) {
@@ -545,6 +554,7 @@ static int _brcmf_sysioc_thread(void *data)
 			}
 		}
 	}
+	finish_wait(&drvr_priv->sysioc_waitq, &wait);
 	return 0;
 }
 
@@ -562,8 +572,7 @@ static int brcmf_netdev_set_mac_address(struct net_device *dev, void *addr)
 
 	memcpy(&drvr_priv->macvalue, sa->sa_data, ETH_ALEN);
 	drvr_priv->set_macaddress = true;
-	up(&drvr_priv->sysioc_sem);
-
+	wake_up(&drvr_priv->sysioc_waitq);
 	return ret;
 }
 
@@ -577,7 +586,7 @@ static void brcmf_netdev_set_multicast_list(struct net_device *dev)
 		return;
 
 	drvr_priv->set_multicast = true;
-	up(&drvr_priv->sysioc_sem);
+	wake_up(&drvr_priv->sysioc_waitq);
 }
 
 int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx, struct sk_buff *pktbuf)
@@ -1217,7 +1226,7 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, void *handle, char *name,
 	if (handle == NULL) {
 		ifp->state = BRCMF_E_IF_ADD;
 		ifp->idx = ifidx;
-		up(&drvr_priv->sysioc_sem);
+		wake_up(&drvr_priv->sysioc_waitq);
 	} else
 		ifp->net = (struct net_device *)handle;
 
@@ -1238,7 +1247,7 @@ void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 
 	ifp->state = BRCMF_E_IF_DEL;
 	ifp->idx = ifidx;
-	up(&drvr_priv->sysioc_sem);
+	wake_up(&drvr_priv->sysioc_waitq);
 }
 
 struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
@@ -1306,7 +1315,7 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 	}
 
 	if (brcmf_sysioc) {
-		sema_init(&drvr_priv->sysioc_sem, 0);
+		init_waitqueue_head(&drvr_priv->sysioc_waitq);
 		drvr_priv->sysioc_tsk = kthread_run(_brcmf_sysioc_thread, drvr_priv,
 						"_brcmf_sysioc");
 		if (IS_ERR(drvr_priv->sysioc_tsk)) {
-- 
1.7.1


