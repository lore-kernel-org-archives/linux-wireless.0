Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:34849 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728087AbeGSGqR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:46:17 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 09/23] staging: wilc1000: remove unused elements in 'wilc' struct
Date: Thu, 19 Jul 2018 04:15:05 +0530
Message-ID: <1531953919-20804-10-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080500_554273_2327F7A3)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove unused elements from 'wilc' struct.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 4 ----
 drivers/staging/wilc1000/wilc_wlan.c          | 6 ------
 2 files changed, 10 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index fe18ae9..22f3486 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -157,12 +157,8 @@ struct wilc {
 
 	struct txq_entry_t txq_head;
 	int txq_entries;
-	int txq_exit;
 
 	struct rxq_entry_t rxq_head;
-	int rxq_exit;
-
-	unsigned char eth_src_address[NUM_CONCURRENT_IFC][6];
 
 	const struct firmware *firmware;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 8e71c28..c77e5c8 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -527,7 +527,6 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 	wilc = vif->wilc;
 
 	txb = wilc->tx_buffer;
-	wilc->txq_exit = 0;
 
 	if (wilc->quit)
 		goto out;
@@ -713,7 +712,6 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 out:
 	mutex_unlock(&wilc->txq_add_to_head_cs);
 
-	wilc->txq_exit = 1;
 	*txq_count = wilc->txq_entries;
 	return ret;
 }
@@ -780,8 +778,6 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 	u8 *buffer;
 	struct rxq_entry_t *rqe;
 
-	wilc->rxq_exit = 0;
-
 	do {
 		if (wilc->quit) {
 			complete(&wilc->cfg_event);
@@ -797,8 +793,6 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 
 		kfree(rqe);
 	} while (1);
-
-	wilc->rxq_exit = 1;
 }
 
 static void wilc_unknown_isr_ext(struct wilc *wilc)
-- 
2.7.4
