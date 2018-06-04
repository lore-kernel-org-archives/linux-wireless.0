Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:37769 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751155AbeFDF3W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 01:29:22 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 2/4] staging: wilc1000: use list_head to maintain 'rxq_entry_t elements in rx queue
Date: Mon, 4 Jun 2018 10:59:08 +0530
Message-ID: <1528090150-5397-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180604_073033_868546_F92B1A3A)
In-Reply-To: <1528090150-5397-1-git-send-email-ajay.kathat@microchip.com>
References: <1528090150-5397-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make use of 'list_head' data structure to maintain the rx buffer queue.
Modified wilc_wlan_rxq_add() to add the element at the tail by using
list_head API and wilc_wlan_rxq_remove() to remove the element from
head.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c         |  1 +
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  3 +--
 drivers/staging/wilc1000/wilc_wlan.c          | 26 +++++++++-----------------
 drivers/staging/wilc1000/wilc_wlan.h          |  2 +-
 4 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index eac719b..0019bb8 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1119,6 +1119,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	wl->gpio = gpio;
 	wl->hif_func = ops;
 	INIT_LIST_HEAD(&wl->txq_head.list);
+	INIT_LIST_HEAD(&wl->rxq_head.list);
 
 	register_inetaddr_notifier(&g_dev_notifier);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index e1fab73..ba57f42 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -161,8 +161,7 @@ struct wilc {
 	int txq_entries;
 	int txq_exit;
 
-	struct rxq_entry_t *rxq_head;
-	struct rxq_entry_t *rxq_tail;
+	struct rxq_entry_t rxq_head;
 	int rxq_entries;
 	int rxq_exit;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 857cc38..059c5c7 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -404,15 +404,7 @@ static int wilc_wlan_rxq_add(struct wilc *wilc, struct rxq_entry_t *rqe)
 		return 0;
 
 	mutex_lock(&wilc->rxq_cs);
-	if (!wilc->rxq_head) {
-		rqe->next = NULL;
-		wilc->rxq_head = rqe;
-		wilc->rxq_tail = rqe;
-	} else {
-		wilc->rxq_tail->next = rqe;
-		rqe->next = NULL;
-		wilc->rxq_tail = rqe;
-	}
+	list_add_tail(&rqe->list, &wilc->rxq_head.list);
 	wilc->rxq_entries += 1;
 	mutex_unlock(&wilc->rxq_cs);
 	return wilc->rxq_entries;
@@ -420,17 +412,17 @@ static int wilc_wlan_rxq_add(struct wilc *wilc, struct rxq_entry_t *rqe)
 
 static struct rxq_entry_t *wilc_wlan_rxq_remove(struct wilc *wilc)
 {
-	if (wilc->rxq_head) {
-		struct rxq_entry_t *rqe;
+	struct rxq_entry_t *rqe = NULL;
 
-		mutex_lock(&wilc->rxq_cs);
-		rqe = wilc->rxq_head;
-		wilc->rxq_head = wilc->rxq_head->next;
+	mutex_lock(&wilc->rxq_cs);
+	if (!list_empty(&wilc->rxq_head.list)) {
+		rqe = list_first_entry(&wilc->rxq_head.list, struct rxq_entry_t,
+				       list);
+		list_del(&rqe->list);
 		wilc->rxq_entries -= 1;
-		mutex_unlock(&wilc->rxq_cs);
-		return rqe;
 	}
-	return NULL;
+	mutex_unlock(&wilc->rxq_cs);
+	return rqe;
 }
 
 void chip_allow_sleep(struct wilc *wilc)
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index e0ff3e8..dbdebf0 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -218,7 +218,7 @@ struct txq_entry_t {
 };
 
 struct rxq_entry_t {
-	struct rxq_entry_t *next;
+	struct list_head list;
 	u8 *buffer;
 	int buffer_size;
 };
-- 
2.7.4
