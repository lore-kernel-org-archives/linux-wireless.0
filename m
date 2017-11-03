Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:19808 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754083AbdKCV0q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Nov 2017 17:26:46 -0400
From: Aditya Shankar <aditya.shankar@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <ganesh.krishna@microchip.com>, <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>,
        Aditya Shankar <aditya.shankar@microchip.com>,
        <stable@vger.kernel.org>,
        Aditya Shankar <Aditya.Shankar@microchip.com>
Subject: [PATCH] staging: wilc1000: Fix bssid buffer offset in Txq
Date: Fri, 3 Nov 2017 14:26:27 +0530
Message-ID: <1509699387-6916-1-git-send-email-aditya.shankar@microchip.com> (sfid-20171103_222652_394824_6C28D1D9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 46949b48568b ("staging: wilc1000: New cfg packet
format in handle_set_wfi_drv_handler") updated the frame
format sent from host to the firmware. The code to update
the bssid offset in the new frame was part of a second
patch in the series which did not make it in and thus
causes connection problems after associating to an AP.

This fix adds the proper offset of the bssid value in the
Tx queue buffer to fix the connection issues.

Fixes: Commit 46949b48568b ("staging: wilc1000: New cfg packet format in handle_set_wfi_drv_handler")
Cc: stable@vger.kernel.org
Signed-off-by: Aditya Shankar <Aditya.Shankar@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 9addef1..f49dfa8 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -714,7 +714,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 					char *bssid = ((struct tx_complete_data *)(tqe->priv))->bssid;
 
 					buffer_offset = ETH_ETHERNET_HDR_OFFSET;
-					memcpy(&txb[offset + 4], bssid, 6);
+					memcpy(&txb[offset + 8], bssid, 6);
 				} else {
 					buffer_offset = HOST_HDR_OFFSET;
 				}
-- 
2.7.4
