Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:14434 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751035AbeCZLqR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 07:46:17 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 2/9] staging: wilc1000: avoid 'NULL' pointer access in wilc_network_info_received()
Date: Mon, 26 Mar 2018 17:15:56 +0530
Message-ID: <1522064763-11576-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180326_134620_352251_1577B405)
In-Reply-To: <1522064763-11576-1-git-send-email-ajay.kathat@microchip.com>
References: <1522064763-11576-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added 'NULL' check before accessing the allocated memory. Free up the
memory incase of failure to enqueue the command. Used kmemdup instead of
kmalloc & memcpy.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a13998d..70c10bc 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3453,12 +3453,15 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 	msg.vif = vif;
 
 	msg.body.net_info.len = length;
-	msg.body.net_info.buffer = kmalloc(length, GFP_KERNEL);
-	memcpy(msg.body.net_info.buffer, buffer, length);
+	msg.body.net_info.buffer = kmemdup(buffer, length, GFP_KERNEL);
+	if (!msg.body.net_info.buffer)
+		return;
 
 	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	if (result) {
 		netdev_err(vif->ndev, "message parameters (%d)\n", result);
+		kfree(msg.body.net_info.buffer);
+	}
 }
 
 void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
-- 
2.7.4
