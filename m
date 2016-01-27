Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14334 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbcA0C5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 21:57:48 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/13] staging: wilc1000: rename pBssid of tx_complete_data structure
Date: Wed, 27 Jan 2016 11:50:31 +0900
Message-ID: <1453863037-31073-7-git-send-email-glen.lee@atmel.com> (sfid-20160127_035750_340651_AD1C674E)
In-Reply-To: <1453863037-31073-1-git-send-email-glen.lee@atmel.com>
References: <1453863037-31073-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pBssid variable of tx_complete_data structure to bssid
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c    | 2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 402f8ce..4b544df 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1194,7 +1194,7 @@ int wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	PRINT_D(TX_DBG, "Adding tx packet to TX Queue\n");
 	vif->netstats.tx_packets++;
 	vif->netstats.tx_bytes += tx_data->size;
-	tx_data->pBssid = wilc->vif[vif->u8IfIdx]->bssid;
+	tx_data->bssid = wilc->vif[vif->u8IfIdx]->bssid;
 	queue_count = wilc_wlan_txq_add_net_pkt(ndev, (void *)tx_data,
 						tx_data->buff, tx_data->size,
 						linux_wlan_tx_complete);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index d7238e7..703dbe0 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -809,7 +809,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 				if (tqe->type == WILC_CFG_PKT) {
 					buffer_offset = ETH_CONFIG_PKT_HDR_OFFSET;
 				} else if (tqe->type == WILC_NET_PKT) {
-					char *bssid = ((struct tx_complete_data *)(tqe->priv))->pBssid;
+					char *bssid = ((struct tx_complete_data *)(tqe->priv))->bssid;
 
 					buffer_offset = ETH_ETHERNET_HDR_OFFSET;
 					memcpy(&txb[offset + 4], bssid, 6);
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 455a98f..294552d 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -82,7 +82,7 @@ typedef struct {
 struct tx_complete_data {
 	int size;
 	void *buff;
-	u8 *pBssid;
+	u8 *bssid;
 	struct sk_buff *skb;
 };
 
-- 
1.9.1

