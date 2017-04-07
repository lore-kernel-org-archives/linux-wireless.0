Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:14311 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932601AbdDGLzJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 07:55:09 -0400
From: Aditya Shankar <aditya.shankar@microchip.com>
To: <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>
CC: <ganesh.krishna@microchip.com>, <devel@driverdev.osuosl.org>,
        Aditya Shankar <aditya.shankar@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] staging: wilc1000: Fix problem with wrong vif index
Date: Fri, 7 Apr 2017 17:24:58 +0530
Message-ID: <1491566098-9328-1-git-send-email-aditya.shankar@microchip.com> (sfid-20170407_135512_742338_ABC2DD25)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The vif->idx value is always 0 for two interfaces.

wl->vif_num = 0;

loop {
     ...

     vif->idx = wl->vif_num;
     ...
     wl->vif_num = i;
      ....
     i++;
     ...
}

At present, vif->idx is assigned the value of wl->vif_num
at the beginning of this block and device is initialized
based on this index value.
In the next iteration, wl->vif_num is still 0 as it is only updated
later but gets assigned to vif->idx in the beginning. This causes problems
later when we try to reference a particular interface and also while
configuring the firmware.

This patch moves the assignment to vif->idx from the beginning
of the block to after wl->vif_num is updated with latest value of i.

Fixes: commit 735bb39ca3be ("staging: wilc1000: simplify vif[i]->ndev accesses")
Cc: <stable@vger.kernel.org>
Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index cd2f602..a2c2ce6 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1232,11 +1232,12 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		else
 			strcpy(ndev->name, "p2p%d");
 
-		vif->idx = wl->vif_num;
 		vif->wilc = *wilc;
 		vif->ndev = ndev;
 		wl->vif[i] = vif;
 		wl->vif_num = i;
+		vif->idx = wl->vif_num;
+
 		ndev->netdev_ops = &wilc_netdev_ops;
 
 		{
-- 
2.7.4
