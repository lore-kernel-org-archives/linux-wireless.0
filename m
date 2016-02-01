Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47597 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933599AbcBACOn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 21:14:43 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH 7/7] staging: wilc1000: remove unused log message using the TX_DBG tag
Date: Mon, 1 Feb 2016 11:11:25 +0900
Message-ID: <1454292685-12294-7-git-send-email-leo.kim@atmel.com> (sfid-20160201_031459_048864_222132BF)
In-Reply-To: <1454292685-12294-1-git-send-email-leo.kim@atmel.com>
References: <1454292685-12294-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch remove unused log message using the TX_DBG tag

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c        | 4 ----
 drivers/staging/wilc1000/linux_wlan_common.h | 2 --
 drivers/staging/wilc1000/wilc_debugfs.c      | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c         | 9 +++------
 4 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 9e5dea4..202be15 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1047,10 +1047,6 @@ static void linux_wlan_tx_complete(void *priv, int status)
 {
 	struct tx_complete_data *pv_data = (struct tx_complete_data *)priv;
 
-	if (status == 1)
-		PRINT_D(TX_DBG, "Packet sent successfully - Size = %d - Address = %p - SKB = %p\n", pv_data->size, pv_data->buff, pv_data->skb);
-	else
-		PRINT_D(TX_DBG, "Couldn't send packet - Size = %d - Address = %p - SKB = %p\n", pv_data->size, pv_data->buff, pv_data->skb);
 	dev_kfree_skb(pv_data->skb);
 	kfree(pv_data);
 }
diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index 5374f36..617bc53 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -6,7 +6,6 @@ enum debug_region {
 	Hostapd_debug,
 	CFG80211_debug,
 	Interrupt_debug,
-	TX_debug,
 	RX_debug,
 	Lock_debug,
 	Tcp_enhance,
@@ -23,7 +22,6 @@ enum debug_region {
 #define HOSTAPD_DBG             (1 << Hostapd_debug)
 #define CFG80211_DBG            (1 << CFG80211_debug)
 #define INT_DBG                 (1 << Interrupt_debug)
-#define TX_DBG                  (1 << TX_debug)
 #define RX_DBG                  (1 << RX_debug)
 #define LOCK_DBG                (1 << Lock_debug)
 #define TCP_ENH                 (1 << Tcp_enhance)
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index 1e38d1b..fd0e58f 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -24,7 +24,7 @@ static struct dentry *wilc_dir;
  * --------------------------------------------------------------------------------
  */
 
-#define DBG_REGION_ALL	(GENERIC_DBG | HOSTAPD_DBG | CFG80211_DBG | INT_DBG | TX_DBG | RX_DBG | LOCK_DBG | INIT_DBG | BUS_DBG | MEM_DBG)
+#define DBG_REGION_ALL	(GENERIC_DBG | HOSTAPD_DBG | CFG80211_DBG | INT_DBG | RX_DBG | LOCK_DBG | INIT_DBG | BUS_DBG | MEM_DBG)
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
 atomic_t WILC_REGION = ATOMIC_INIT(INIT_DBG | GENERIC_DBG | CFG80211_DBG | FIRM_DBG | HOSTAPD_DBG);
 EXPORT_SYMBOL_GPL(WILC_REGION);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c19ae00..01c5857 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -652,13 +652,11 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 			}
 		} while (1);
 
-		if (i == 0) {
-			PRINT_D(TX_DBG, "Nothing in TX-Q\n");
+		if (i == 0)
 			break;
-		} else {
-			PRINT_D(TX_DBG, "Mark the last entry in VMM table - number of previous entries = %d\n", i);
+		else
 			vmm_table[i] = 0x0;
-		}
+
 		acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 		counter = 0;
 		do {
@@ -807,7 +805,6 @@ _end_:
 	up(&wilc->txq_add_to_head_cs);
 
 	wilc->txq_exit = 1;
-	PRINT_D(TX_DBG, "THREAD: Exiting txq\n");
 	*txq_count = wilc->txq_entries;
 	return ret;
 }
-- 
1.9.1

