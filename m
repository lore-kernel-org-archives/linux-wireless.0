Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:28880 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbeHAGpF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 02:45:05 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH] staging: wilc1000: refactor wilc_wlan_handle_isr_ext to avoid goto statement
Date: Wed, 1 Aug 2018 10:33:41 +0530
Message-ID: <1533099821-3769-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180801_070134_568122_9CB58E87)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor wilc_wlan_handle_isr_ext() to avoid the use of the goto label.
Also avoid the unnecessary NULL check for 'wilc->rx_buffer' and
calling wilc_wlan_handle_rxq() only after wilc_wlan_rxq_add() call.
The link [1] contains details for discussion related to this changes.

[1]. https://patchwork.kernel.org/patch/10533601/

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 45 +++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index ea2e77f..cad6cec 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -820,31 +820,28 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 		retries++;
 	}
 
-	if (size > 0) {
-		if (LINUX_RX_SIZE - offset < size)
-			offset = 0;
+	if (size <= 0)
+		return;
 
-		if (wilc->rx_buffer)
-			buffer = &wilc->rx_buffer[offset];
-		else
-			goto end;
-
-		wilc->hif_func->hif_clear_int_ext(wilc,
-					      DATA_INT_CLR | ENABLE_RX_VMM);
-		ret = wilc->hif_func->hif_block_rx_ext(wilc, 0, buffer, size);
-
-end:
-		if (ret) {
-			offset += size;
-			wilc->rx_buffer_offset = offset;
-			rqe = kmalloc(sizeof(*rqe), GFP_KERNEL);
-			if (rqe) {
-				rqe->buffer = buffer;
-				rqe->buffer_size = size;
-				wilc_wlan_rxq_add(wilc, rqe);
-			}
-		}
-	}
+	if (LINUX_RX_SIZE - offset < size)
+		offset = 0;
+
+	buffer = &wilc->rx_buffer[offset];
+
+	wilc->hif_func->hif_clear_int_ext(wilc, DATA_INT_CLR | ENABLE_RX_VMM);
+	ret = wilc->hif_func->hif_block_rx_ext(wilc, 0, buffer, size);
+	if (!ret)
+		return;
+
+	offset += size;
+	wilc->rx_buffer_offset = offset;
+	rqe = kmalloc(sizeof(*rqe), GFP_KERNEL);
+	if (!rqe)
+		return;
+
+	rqe->buffer = buffer;
+	rqe->buffer_size = size;
+	wilc_wlan_rxq_add(wilc, rqe);
 	wilc_wlan_handle_rxq(wilc);
 }
 
-- 
2.7.4
