Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:14434 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750984AbeCZLqV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 07:46:21 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 3/9] staging: wilc1000: free allocated memory in edit and add station functions
Date: Mon, 26 Mar 2018 17:15:57 +0530
Message-ID: <1522064763-11576-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180326_134623_817947_254567AC)
In-Reply-To: <1522064763-11576-1-git-send-email-ajay.kathat@microchip.com>
References: <1522064763-11576-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added fix to free the allocated memory in case of failure to enqueue
the command.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 70c10bc..1cc4c08 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3709,8 +3709,10 @@ int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param)
 	}
 
 	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		kfree(add_sta_info->rates);
+	}
 	return result;
 }
 
@@ -3793,8 +3795,10 @@ int wilc_edit_station(struct wilc_vif *vif,
 	}
 
 	result = wilc_enqueue_cmd(&msg);
-	if (result)
+	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		kfree(add_sta_info->rates);
+	}
 
 	return result;
 }
-- 
2.7.4
