Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12073 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbeBZQf5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 11:35:57 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 3/8] staging: wilc1000: fix line over 80 char in wilc_wlan_handle_txq()
Date: Mon, 26 Feb 2018 22:01:57 +0530
Message-ID: <1519662722-15761-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180226_173603_195215_C35BC088)
In-Reply-To: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
References: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor wilc_wlan_handle_txq() to fix 'line over 80 char' issue found
by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 76 ++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 5422359..ee7102d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -707,49 +707,51 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 	offset = 0;
 	i = 0;
 	do {
+		u32 header, buffer_offset;
+		char *bssid;
+
 		tqe = wilc_wlan_txq_remove_from_head(dev);
-		if (tqe && vmm_table[i] != 0) {
-			u32 header, buffer_offset;
+		if (!tqe)
+			break;
 
-			vmm_table[i] = cpu_to_le32(vmm_table[i]);
-			vmm_sz = (vmm_table[i] & 0x3ff);
-			vmm_sz *= 4;
-			header = (tqe->type << 31) |
-				 (tqe->buffer_size << 15) |
-				 vmm_sz;
-			if (tqe->type == WILC_MGMT_PKT)
-				header |= BIT(30);
-			else
-				header &= ~BIT(30);
+		if (vmm_table[i] == 0)
+			break;
 
-			header = cpu_to_le32(header);
-			memcpy(&txb[offset], &header, 4);
-			if (tqe->type == WILC_CFG_PKT) {
-				buffer_offset = ETH_CONFIG_PKT_HDR_OFFSET;
-			} else if (tqe->type == WILC_NET_PKT) {
-				char *bssid = ((struct tx_complete_data *)(tqe->priv))->bssid;
-
-				buffer_offset = ETH_ETHERNET_HDR_OFFSET;
-				memcpy(&txb[offset + 8], bssid, 6);
-			} else {
-				buffer_offset = HOST_HDR_OFFSET;
-			}
+		vmm_table[i] = cpu_to_le32(vmm_table[i]);
+		vmm_sz = (vmm_table[i] & 0x3ff);
+		vmm_sz *= 4;
+		header = (tqe->type << 31) |
+			 (tqe->buffer_size << 15) |
+			 vmm_sz;
+		if (tqe->type == WILC_MGMT_PKT)
+			header |= BIT(30);
+		else
+			header &= ~BIT(30);
 
-			memcpy(&txb[offset + buffer_offset],
-			       tqe->buffer, tqe->buffer_size);
-			offset += vmm_sz;
-			i++;
-			tqe->status = 1;
-			if (tqe->tx_complete_func)
-				tqe->tx_complete_func(tqe->priv,
-						      tqe->status);
-			if (tqe->tcp_pending_ack_idx != NOT_TCP_ACK &&
-			    tqe->tcp_pending_ack_idx < MAX_PENDING_ACKS)
-				pending_acks_info[tqe->tcp_pending_ack_idx].txqe = NULL;
-			kfree(tqe);
+		header = cpu_to_le32(header);
+		memcpy(&txb[offset], &header, 4);
+		if (tqe->type == WILC_CFG_PKT) {
+			buffer_offset = ETH_CONFIG_PKT_HDR_OFFSET;
+		} else if (tqe->type == WILC_NET_PKT) {
+			bssid = ((struct tx_complete_data *)(tqe->priv))->bssid;
+
+			buffer_offset = ETH_ETHERNET_HDR_OFFSET;
+			memcpy(&txb[offset + 8], bssid, 6);
 		} else {
-			break;
+			buffer_offset = HOST_HDR_OFFSET;
 		}
+
+		memcpy(&txb[offset + buffer_offset],
+		       tqe->buffer, tqe->buffer_size);
+		offset += vmm_sz;
+		i++;
+		tqe->status = 1;
+		if (tqe->tx_complete_func)
+			tqe->tx_complete_func(tqe->priv, tqe->status);
+		if (tqe->tcp_pending_ack_idx != NOT_TCP_ACK &&
+		    tqe->tcp_pending_ack_idx < MAX_PENDING_ACKS)
+			pending_acks_info[tqe->tcp_pending_ack_idx].txqe = NULL;
+		kfree(tqe);
 	} while (--entries);
 
 	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
-- 
2.7.4
