Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:28418 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755853AbeDYRUF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:20:05 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 16/21] staging: wilc1000: remove unused elements in 'wilc_priv' struct
Date: Wed, 25 Apr 2018 22:48:21 +0530
Message-ID: <1524676706-13179-17-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_192010_152480_6AC33DFF)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove unused element from 'wilc_priv' structure.

Below elements are removed in 'wilc_priv' structure:

struct WILC_WFI_packet *ppool;
struct WILC_WFI_packet *rx_queue; /* List of incoming packets */
int rx_int_enabled;
int tx_packetlen;
u8 *tx_packetdata;
struct napi_struct napi;

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 0a91468..e6489fa 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -108,15 +108,9 @@ struct wilc_priv {
 	struct net_device_stats stats;
 	u8 monitor_flag;
 	int status;
-	struct WILC_WFI_packet *ppool;
-	struct WILC_WFI_packet *rx_queue; /* List of incoming packets */
-	int rx_int_enabled;
-	int tx_packetlen;
-	u8 *tx_packetdata;
 	struct sk_buff *skb;
 	spinlock_t lock;
 	struct net_device *dev;
-	struct napi_struct napi;
 	struct host_if_drv *hif_drv;
 	struct host_if_pmkid_attr pmkid_list;
 	struct wilc_wfi_stats netstats;
-- 
2.7.4
