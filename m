Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2421 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100Ab3FRL3t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 07:29:49 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 5/8] brcmfmac: simplify dpc handling using atomic
 operations
Date: Tue, 18 Jun 2013 13:29:26 +0200
Message-ID: <1371554970-23495-6-git-send-email-arend@broadcom.com> (sfid-20130618_132958_680078_24652688)
In-Reply-To: <1371554970-23495-1-git-send-email-arend@broadcom.com>
References: <1371554970-23495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of allocating an empty list item and queue that for
the dpc data worker to dequeue an atomic counter is used.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   70 ++++----------------
 1 file changed, 12 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 6f3d181..d4db0c7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -495,8 +495,7 @@ struct brcmf_sdio {
 
 	struct workqueue_struct *brcmf_wq;
 	struct work_struct datawork;
-	struct list_head dpc_tsklst;
-	spinlock_t dpc_tl_lock;
+	atomic_t dpc_tskcnt;
 
 	const struct firmware *firmware;
 	u32 fw_ptr;
@@ -2061,23 +2060,6 @@ static inline void brcmf_sdbrcm_clrintr(struct brcmf_sdio *bus)
 	}
 }
 
-static inline void brcmf_sdbrcm_adddpctsk(struct brcmf_sdio *bus)
-{
-	struct list_head *new_hd;
-	unsigned long flags;
-
-	if (in_interrupt())
-		new_hd = kzalloc(sizeof(struct list_head), GFP_ATOMIC);
-	else
-		new_hd = kzalloc(sizeof(struct list_head), GFP_KERNEL);
-	if (new_hd == NULL)
-		return;
-
-	spin_lock_irqsave(&bus->dpc_tl_lock, flags);
-	list_add_tail(new_hd, &bus->dpc_tsklst);
-	spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
-}
-
 static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 {
 	u8 idx;
@@ -2312,7 +2294,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		   (!atomic_read(&bus->fcstate) &&
 		    brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) &&
 		    data_ok(bus)) || PKT_AVAILABLE()) {
-		brcmf_sdbrcm_adddpctsk(bus);
+		atomic_inc(&bus->dpc_tskcnt);
 	}
 
 	/* If we're done for now, turn off clock request. */
@@ -2342,7 +2324,6 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
-	unsigned long flags;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -2381,14 +2362,9 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 		qcount[prec] = pktq_plen(&bus->txq, prec);
 #endif
 
-	spin_lock_irqsave(&bus->dpc_tl_lock, flags);
-	if (list_empty(&bus->dpc_tsklst)) {
-		spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
-
-		brcmf_sdbrcm_adddpctsk(bus);
+	if (atomic_read(&bus->dpc_tskcnt) == 0) {
+		atomic_inc(&bus->dpc_tskcnt);
 		queue_work(bus->brcmf_wq, &bus->datawork);
-	} else {
-		spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
 	}
 
 	return ret;
@@ -2525,7 +2501,6 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
-	unsigned long flags;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -2612,18 +2587,13 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 		} while (ret < 0 && retries++ < TXRETRIES);
 	}
 
-	spin_lock_irqsave(&bus->dpc_tl_lock, flags);
 	if ((bus->idletime == BRCMF_IDLE_IMMEDIATE) &&
-	    list_empty(&bus->dpc_tsklst)) {
-		spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
-
+	    atomic_read(&bus->dpc_tskcnt) == 0) {
 		bus->activity = false;
 		sdio_claim_host(bus->sdiodev->func[1]);
 		brcmf_dbg(INFO, "idle\n");
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 		sdio_release_host(bus->sdiodev->func[1]);
-	} else {
-		spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
 	}
 
 	if (ret)
@@ -3451,7 +3421,7 @@ void brcmf_sdbrcm_isr(void *arg)
 	if (!bus->intr)
 		brcmf_err("isr w/o interrupt configured!\n");
 
-	brcmf_sdbrcm_adddpctsk(bus);
+	atomic_inc(&bus->dpc_tskcnt);
 	queue_work(bus->brcmf_wq, &bus->datawork);
 }
 
@@ -3460,7 +3430,6 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 #ifdef DEBUG
 	struct brcmf_bus *bus_if = dev_get_drvdata(bus->sdiodev->dev);
 #endif	/* DEBUG */
-	unsigned long flags;
 
 	brcmf_dbg(TIMER, "Enter\n");
 
@@ -3476,11 +3445,9 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 		if (!bus->intr ||
 		    (bus->sdcnt.intrcount == bus->sdcnt.lastintrs)) {
 
-			spin_lock_irqsave(&bus->dpc_tl_lock, flags);
-			if (list_empty(&bus->dpc_tsklst)) {
+			if (atomic_read(&bus->dpc_tskcnt) == 0) {
 				u8 devpend;
-				spin_unlock_irqrestore(&bus->dpc_tl_lock,
-						       flags);
+
 				sdio_claim_host(bus->sdiodev->func[1]);
 				devpend = brcmf_sdio_regrb(bus->sdiodev,
 							   SDIO_CCCR_INTx,
@@ -3489,9 +3456,6 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 				intstatus =
 				    devpend & (INTR_STATUS_FUNC1 |
 					       INTR_STATUS_FUNC2);
-			} else {
-				spin_unlock_irqrestore(&bus->dpc_tl_lock,
-						       flags);
 			}
 
 			/* If there is something, make like the ISR and
@@ -3500,7 +3464,7 @@ static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_sdio *bus)
 				bus->sdcnt.pollcnt++;
 				atomic_set(&bus->ipend, 1);
 
-				brcmf_sdbrcm_adddpctsk(bus);
+				atomic_inc(&bus->dpc_tskcnt);
 				queue_work(bus->brcmf_wq, &bus->datawork);
 			}
 		}
@@ -3566,20 +3530,11 @@ static void brcmf_sdio_dataworker(struct work_struct *work)
 {
 	struct brcmf_sdio *bus = container_of(work, struct brcmf_sdio,
 					      datawork);
-	struct list_head *cur_hd, *tmp_hd;
-	unsigned long flags;
-
-	spin_lock_irqsave(&bus->dpc_tl_lock, flags);
-	list_for_each_safe(cur_hd, tmp_hd, &bus->dpc_tsklst) {
-		spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
 
+	while (atomic_read(&bus->dpc_tskcnt)) {
 		brcmf_sdbrcm_dpc(bus);
-
-		spin_lock_irqsave(&bus->dpc_tl_lock, flags);
-		list_del(cur_hd);
-		kfree(cur_hd);
+		atomic_dec(&bus->dpc_tskcnt);
 	}
-	spin_unlock_irqrestore(&bus->dpc_tl_lock, flags);
 }
 
 static void brcmf_sdbrcm_release_malloc(struct brcmf_sdio *bus)
@@ -3927,8 +3882,7 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 		bus->watchdog_tsk = NULL;
 	}
 	/* Initialize DPC thread */
-	INIT_LIST_HEAD(&bus->dpc_tsklst);
-	spin_lock_init(&bus->dpc_tl_lock);
+	atomic_set(&bus->dpc_tskcnt, 0);
 
 	/* Assign bus interface call back */
 	bus->sdiodev->bus_if->dev = bus->sdiodev->dev;
-- 
1.7.10.4


