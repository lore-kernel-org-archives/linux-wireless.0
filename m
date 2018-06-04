Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:8034 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751155AbeFDF3Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 01:29:25 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 3/4] staging: wilc1000: remove 'rxq_entries' from 'wilc' struct
Date: Mon, 4 Jun 2018 10:59:09 +0530
Message-ID: <1528090150-5397-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180604_073034_474681_BCF2C708)
In-Reply-To: <1528090150-5397-1-git-send-email-ajay.kathat@microchip.com>
References: <1528090150-5397-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed unnecessary 'rxq_entries' element from 'wilc' struct, as its
value is not used.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 -
 drivers/staging/wilc1000/wilc_wlan.c          | 7 ++-----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index ba57f42..afba372 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -162,7 +162,6 @@ struct wilc {
 	int txq_exit;
 
 	struct rxq_entry_t rxq_head;
-	int rxq_entries;
 	int rxq_exit;
 
 	unsigned char eth_src_address[NUM_CONCURRENT_IFC][6];
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 059c5c7..26252d1 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -398,16 +398,14 @@ static struct txq_entry_t *wilc_wlan_txq_get_next(struct wilc *wilc,
 	return tqe;
 }
 
-static int wilc_wlan_rxq_add(struct wilc *wilc, struct rxq_entry_t *rqe)
+static void wilc_wlan_rxq_add(struct wilc *wilc, struct rxq_entry_t *rqe)
 {
 	if (wilc->quit)
-		return 0;
+		return;
 
 	mutex_lock(&wilc->rxq_cs);
 	list_add_tail(&rqe->list, &wilc->rxq_head.list);
-	wilc->rxq_entries += 1;
 	mutex_unlock(&wilc->rxq_cs);
-	return wilc->rxq_entries;
 }
 
 static struct rxq_entry_t *wilc_wlan_rxq_remove(struct wilc *wilc)
@@ -419,7 +417,6 @@ static struct rxq_entry_t *wilc_wlan_rxq_remove(struct wilc *wilc)
 		rqe = list_first_entry(&wilc->rxq_head.list, struct rxq_entry_t,
 				       list);
 		list_del(&rqe->list);
-		wilc->rxq_entries -= 1;
 	}
 	mutex_unlock(&wilc->rxq_cs);
 	return rqe;
-- 
2.7.4
