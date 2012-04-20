Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3921 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559Ab2DTV2F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 17:28:05 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3.4 2/2] brcm80211: fmac: fix missing completion events
 issue
Date: Fri, 20 Apr 2012 14:27:49 -0700
Message-ID: <1334957269-27416-3-git-send-email-frankyl@broadcom.com> (sfid-20120420_232812_493514_CD18F238)
In-Reply-To: <1334957269-27416-1-git-send-email-frankyl@broadcom.com>
References: <1334957269-27416-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dpc takes care of all data packets transmissions for sdio function
2. It is possible that it misses some completion events when the
traffic is heavy or it's running on a slow cpu. A linked list is
introduced to make sure dpc is invoked whenever needed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   63 ++++++++++++++++----
 1 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 2bf5dda..eb3829b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -574,6 +574,8 @@ struct brcmf_sdio {
 
 	struct task_struct *dpc_tsk;
 	struct completion dpc_wait;
+	struct list_head dpc_tsklst;
+	spinlock_t dpc_tl_lock;
 
 	struct semaphore sdsem;
 
@@ -2594,29 +2596,58 @@ clkwait:
 	return resched;
 }
 
+static inline void brcmf_sdbrcm_adddpctsk(struct brcmf_sdio *bus)
+{
+	struct list_head *new_hd;
+	unsigned long flags;
+
+	if (in_interrupt())
+		new_hd = kzalloc(sizeof(struct list_head), GFP_ATOMIC);
+	else
+		new_hd = kzalloc(sizeof(struct list_head), GFP_KERNEL);
+	if (new_hd == NULL)
+		return;
+
+	spin_lock_irqsave(&bus->dpc_tl_lock, flags);
+	list_add_tail(new_hd, &bus->dpc_tsklst);
+	spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
+}
+
 static int brcmf_sdbrcm_dpc_thread(void *data)
 {
 	struct brcmf_sdio *bus = (struct brcmf_sdio *) data;
+	struct list_head *cur_hd, *tmp_hd;
+	unsigned long flags;
 
 	allow_signal(SIGTERM);
 	/* Run until signal received */
 	while (1) {
 		if (kthread_should_stop())
 			break;
-		if (!wait_for_completion_interruptible(&bus->dpc_wait)) {
-			/* Call bus dpc unless it indicated down
-			(then clean stop) */
-			if (bus->sdiodev->bus_if->state != BRCMF_BUS_DOWN) {
-				if (brcmf_sdbrcm_dpc(bus))
-					complete(&bus->dpc_wait);
-			} else {
+
+		if (list_empty(&bus->dpc_tsklst))
+			if (wait_for_completion_interruptible(&bus->dpc_wait))
+				break;
+
+		spin_lock_irqsave(&bus->dpc_tl_lock, flags);
+		list_for_each_safe(cur_hd, tmp_hd, &bus->dpc_tsklst) {
+			spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
+
+			if (bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN) {
 				/* after stopping the bus, exit thread */
 				brcmf_sdbrcm_bus_stop(bus->sdiodev->dev);
 				bus->dpc_tsk = NULL;
 				break;
 			}
-		} else
-			break;
+
+			if (brcmf_sdbrcm_dpc(bus))
+				brcmf_sdbrcm_adddpctsk(bus);
+
+			spin_lock_irqsave(&bus->dpc_tl_lock, flags);
+			list_del(cur_hd);
+			kfree(cur_hd);
+		}
+		spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
 	}
 	return 0;
 }
@@ -2669,8 +2700,10 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	/* Schedule DPC if needed to send queued packet(s) */
 	if (!bus->dpc_sched) {
 		bus->dpc_sched = true;
-		if (bus->dpc_tsk)
+		if (bus->dpc_tsk) {
+			brcmf_sdbrcm_adddpctsk(bus);
 			complete(&bus->dpc_wait);
+		}
 	}
 
 	return ret;
@@ -3514,8 +3547,10 @@ void brcmf_sdbrcm_isr(void *arg)
 		brcmf_dbg(ERROR, "isr w/o interrupt configured!\n");
 
 	bus->dpc_sched = true;
-	if (bus->dpc_tsk)
+	if (bus->dpc_tsk) {
+		brcmf_sdbrcm_adddpctsk(bus);
 		complete(&bus->dpc_wait);
+	}
 }
 
 static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
@@ -3559,8 +3594,10 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 				bus->ipend = true;
 
 				bus->dpc_sched = true;
-				if (bus->dpc_tsk)
+				if (bus->dpc_tsk) {
+					brcmf_sdbrcm_adddpctsk(bus);
 					complete(&bus->dpc_wait);
+				}
 			}
 		}
 
@@ -3897,6 +3934,8 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	}
 	/* Initialize DPC thread */
 	init_completion(&bus->dpc_wait);
+	INIT_LIST_HEAD(&bus->dpc_tsklst);
+	spin_lock_init(&bus->dpc_tl_lock);
 	bus->dpc_tsk = kthread_run(brcmf_sdbrcm_dpc_thread,
 				   bus, "brcmf_dpc");
 	if (IS_ERR(bus->dpc_tsk)) {
-- 
1.7.5.4


