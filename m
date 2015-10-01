Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3443 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbbJAHET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 03:04:19 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/12] staging: wilc1000: remove function pointer wlan_add_to_tx_que
Date: Thu, 1 Oct 2015 16:03:35 +0900
Message-ID: <1443683023-6498-4-git-send-email-tony.cho@atmel.com> (sfid-20151001_090422_260213_C431B0F4)
In-Reply-To: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
References: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes function pointer wlan_add_to_tx_que and just call
the function wilc_wlan_txq_add_net_pkt. Remove static from the function also.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 7 +++----
 drivers/staging/wilc1000/wilc_wlan.c    | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.h    | 2 ++
 drivers/staging/wilc1000/wilc_wlan_if.h | 1 -
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 245357e..e40ee8c 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1563,10 +1563,9 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	nic->netstats.tx_packets++;
 	nic->netstats.tx_bytes += tx_data->size;
 	tx_data->pBssid = g_linux_wlan->strInterfaceInfo[nic->u8IfIdx].aBSSID;
-	QueueCount = g_linux_wlan->oup.wlan_add_to_tx_que((void *)tx_data,
-							  tx_data->buff,
-							  tx_data->size,
-							  linux_wlan_tx_complete);
+	QueueCount = wilc_wlan_txq_add_net_pkt((void *)tx_data, tx_data->buff,
+					       tx_data->size,
+					       linux_wlan_tx_complete);
 
 	if (QueueCount > FLOW_CONTROL_UPPER_THRESHOLD) {
 		netif_stop_queue(g_linux_wlan->strInterfaceInfo[0].wilc_netdev);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 745953c..fcc4155 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -503,7 +503,8 @@ static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
 	return 1;
 }
 
-static int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, u32 buffer_size, wilc_tx_complete_func_t func)
+int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, u32 buffer_size,
+			      wilc_tx_complete_func_t func)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	struct txq_entry_t *tqe;
@@ -2027,7 +2028,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	/**
 	 *      export functions
 	 **/
-	oup->wlan_add_to_tx_que = wilc_wlan_txq_add_net_pkt;
 	oup->wlan_handle_tx_que = wilc_wlan_handle_txq;
 	oup->wlan_handle_rx_isr = wilc_handle_isr;
 	oup->wlan_cleanup = wilc_wlan_cleanup;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index b32ba4f..2af027c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -308,4 +308,6 @@ typedef struct {
 int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size);
 int wilc_wlan_start(void);
 int wilc_wlan_stop(void);
+int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, u32 buffer_size,
+			      wilc_tx_complete_func_t func);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 9e749c7..25d9d90 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -122,7 +122,6 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
 #define WILC_TX_ERR_NO_BUF	(-2)
 
 typedef struct {
-	int (*wlan_add_to_tx_que)(void *, u8 *, u32, wilc_tx_complete_func_t);
 	int (*wlan_handle_tx_que)(u32 *);
 	void (*wlan_handle_rx_isr)(void);
 	void (*wlan_cleanup)(void);
-- 
1.9.1

