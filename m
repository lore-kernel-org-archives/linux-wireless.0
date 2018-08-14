Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:57891 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731824AbeHNJgh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:36:37 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 08/24] staging: wilc1000: avoid use of extra 'if' condition in wilc_init()
Date: Tue, 14 Aug 2018 12:20:00 +0530
Message-ID: <1534229416-13254-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180814_085051_089654_F217B20A)
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to avoid the avoid extra 'if' condition and clubbed the
same condition in single 'if' block.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 11eb632..6225e67 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3459,9 +3459,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	if (clients_count == 0) {
 		init_completion(&hif_driver_comp);
 		mutex_init(&hif_deinit_lock);
-	}
 
-	if (clients_count == 0) {
 		hif_workqueue = create_singlethread_workqueue("WILC_wq");
 		if (!hif_workqueue) {
 			netdev_err(vif->ndev, "Failed to create workqueue\n");
-- 
2.7.4
