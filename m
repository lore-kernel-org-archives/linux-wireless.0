Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58616 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbbJ0J1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 05:27:39 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 26/27] staging: wilc1000: wilc_wlan_txq_add_net_pkt: add argument struct net_device
Date: Tue, 27 Oct 2015 18:28:02 +0900
Message-ID: <1445938083-20445-26-git-send-email-glen.lee@atmel.com> (sfid-20151027_102759_316524_B6659D0D)
In-Reply-To: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
References: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add new argument struct net_device *dev and pass net_device to
wilc_wlan_txq_add_net_pkt.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.c  | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.h  | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 9a105ceb..2a5b36f 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1413,8 +1413,8 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 	nic->netstats.tx_packets++;
 	nic->netstats.tx_bytes += tx_data->size;
 	tx_data->pBssid = wilc->vif[nic->u8IfIdx].bssid;
-	QueueCount = wilc_wlan_txq_add_net_pkt((void *)tx_data, tx_data->buff,
-					       tx_data->size,
+	QueueCount = wilc_wlan_txq_add_net_pkt(ndev, (void *)tx_data,
+					       tx_data->buff, tx_data->size,
 					       linux_wlan_tx_complete);
 
 	if (QueueCount > FLOW_CONTROL_UPPER_THRESHOLD) {
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index b109289..14a56d6 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -502,8 +502,8 @@ static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
 	return 1;
 }
 
-int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, u32 buffer_size,
-			      wilc_tx_complete_func_t func)
+int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
+			      u32 buffer_size, wilc_tx_complete_func_t func)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	struct txq_entry_t *tqe;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index d0b2448..57e1d51 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -298,8 +298,8 @@ typedef struct {
 int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size);
 int wilc_wlan_start(void);
 int wilc_wlan_stop(void);
-int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, u32 buffer_size,
-			      wilc_tx_complete_func_t func);
+int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
+			      u32 buffer_size, wilc_tx_complete_func_t func);
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount);
 void wilc_handle_isr(void *wilc);
 void wilc_wlan_cleanup(struct net_device *dev);
-- 
1.9.1

