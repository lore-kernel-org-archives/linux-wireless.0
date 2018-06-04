Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:32560 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751155AbeFDF3T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 01:29:19 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 1/4] staging: wilc1000: use list_head to maintain 'txq_entry_t' elements of tx queue
Date: Mon, 4 Jun 2018 10:59:07 +0530
Message-ID: <1528090150-5397-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180604_073033_312269_B478C28C)
In-Reply-To: <1528090150-5397-1-git-send-email-ajay.kathat@microchip.com>
References: <1528090150-5397-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use list_head data structure for the doubly linked list instead of own
implementation.
Only 'txq_head' is required, so removed the txq_tail pointer from
'wilc' structure.

Following functions are modified to provide data using list_head API's
wilc_wlan_txq_remove()
wilc_wlan_txq_remove_from_head()
wilc_wlan_txq_add_to_tail()
wilc_wlan_txq_add_to_head()
wilc_wlan_txq_get_first()
wilc_wlan_txq_get_next()

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c         |  1 +
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  3 +-
 drivers/staging/wilc1000/wilc_wlan.c          | 61 +++++++--------------------
 drivers/staging/wilc1000/wilc_wlan.h          |  3 +-
 4 files changed, 19 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 02e6b13..eac719b 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1118,6 +1118,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	wl->io_type = io_type;
 	wl->gpio = gpio;
 	wl->hif_func = ops;
+	INIT_LIST_HEAD(&wl->txq_head.list);
 
 	register_inetaddr_notifier(&g_dev_notifier);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index f2b07e8..e1fab73 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -157,8 +157,7 @@ struct wilc {
 
 	unsigned long txq_spinlock_flags;
 
-	struct txq_entry_t *txq_head;
-	struct txq_entry_t *txq_tail;
+	struct txq_entry_t txq_head;
 	int txq_entries;
 	int txq_exit;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index d4ebbf6..857cc38 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -20,25 +20,14 @@ static inline void release_bus(struct wilc *wilc, enum bus_release release)
 
 static void wilc_wlan_txq_remove(struct wilc *wilc, struct txq_entry_t *tqe)
 {
-	if (tqe == wilc->txq_head) {
-		wilc->txq_head = tqe->next;
-		if (wilc->txq_head)
-			wilc->txq_head->prev = NULL;
-	} else if (tqe == wilc->txq_tail) {
-		wilc->txq_tail = (tqe->prev);
-		if (wilc->txq_tail)
-			wilc->txq_tail->next = NULL;
-	} else {
-		tqe->prev->next = tqe->next;
-		tqe->next->prev = tqe->prev;
-	}
+	list_del(&tqe->list);
 	wilc->txq_entries -= 1;
 }
 
 static struct txq_entry_t *
 wilc_wlan_txq_remove_from_head(struct net_device *dev)
 {
-	struct txq_entry_t *tqe;
+	struct txq_entry_t *tqe = NULL;
 	unsigned long flags;
 	struct wilc_vif *vif;
 	struct wilc *wilc;
@@ -47,15 +36,12 @@ wilc_wlan_txq_remove_from_head(struct net_device *dev)
 	wilc = vif->wilc;
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
-	if (wilc->txq_head) {
-		tqe = wilc->txq_head;
-		wilc->txq_head = tqe->next;
-		if (wilc->txq_head)
-			wilc->txq_head->prev = NULL;
 
+	if (!list_empty(&wilc->txq_head.list)) {
+		tqe = list_first_entry(&wilc->txq_head.list, struct txq_entry_t,
+				       list);
+		list_del(&tqe->list);
 		wilc->txq_entries -= 1;
-	} else {
-		tqe = NULL;
 	}
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 	return tqe;
@@ -73,17 +59,7 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev,
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
-	if (!wilc->txq_head) {
-		tqe->next = NULL;
-		tqe->prev = NULL;
-		wilc->txq_head = tqe;
-		wilc->txq_tail = tqe;
-	} else {
-		tqe->next = NULL;
-		tqe->prev = wilc->txq_tail;
-		wilc->txq_tail->next = tqe;
-		wilc->txq_tail = tqe;
-	}
+	list_add_tail(&tqe->list, &wilc->txq_head.list);
 	wilc->txq_entries += 1;
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
@@ -101,17 +77,7 @@ static int wilc_wlan_txq_add_to_head(struct wilc_vif *vif,
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
-	if (!wilc->txq_head) {
-		tqe->next = NULL;
-		tqe->prev = NULL;
-		wilc->txq_head = tqe;
-		wilc->txq_tail = tqe;
-	} else {
-		tqe->next = wilc->txq_head;
-		tqe->prev = NULL;
-		wilc->txq_head->prev = tqe;
-		wilc->txq_head = tqe;
-	}
+	list_add(&tqe->list, &wilc->txq_head.list);
 	wilc->txq_entries += 1;
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
@@ -402,12 +368,14 @@ int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 
 static struct txq_entry_t *wilc_wlan_txq_get_first(struct wilc *wilc)
 {
-	struct txq_entry_t *tqe;
+	struct txq_entry_t *tqe = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
-	tqe = wilc->txq_head;
+	if (!list_empty(&wilc->txq_head.list))
+		tqe = list_first_entry(&wilc->txq_head.list, struct txq_entry_t,
+				       list);
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 
@@ -421,7 +389,10 @@ static struct txq_entry_t *wilc_wlan_txq_get_next(struct wilc *wilc,
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
-	tqe = tqe->next;
+	if (!list_is_last(&tqe->list, &wilc->txq_head.list))
+		tqe = list_next_entry(tqe, list);
+	else
+		tqe = NULL;
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 
 	return tqe;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index a5b9c68..e0ff3e8 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -207,8 +207,7 @@
  ********************************************/
 
 struct txq_entry_t {
-	struct txq_entry_t *next;
-	struct txq_entry_t *prev;
+	struct list_head list;
 	int type;
 	int tcp_pending_ack_idx;
 	u8 *buffer;
-- 
2.7.4
