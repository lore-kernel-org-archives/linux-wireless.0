Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:46871 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755823AbeDYRUM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:20:12 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 19/21] staging: wilc1000: remove inner block '{}' in handle_remain_on_chan()
Date: Wed, 25 Apr 2018 22:48:24 +0530
Message-ID: <1524676706-13179-20-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_192016_267247_79FBF8F4)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove unnecessary inner block {\* *\} in
handle_remain_on_chan().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6eafb98..2f3e20d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2244,19 +2244,16 @@ static int handle_remain_on_chan(struct wilc_vif *vif,
 		netdev_err(vif->ndev, "Failed to set remain on channel\n");
 
 error:
-	{
-		p2p_listen_state = 1;
-		hif_drv->remain_on_ch_timer_vif = vif;
-		mod_timer(&hif_drv->remain_on_ch_timer,
-			  jiffies +
-			  msecs_to_jiffies(hif_remain_ch->duration));
+	p2p_listen_state = 1;
+	hif_drv->remain_on_ch_timer_vif = vif;
+	mod_timer(&hif_drv->remain_on_ch_timer,
+		  jiffies + msecs_to_jiffies(hif_remain_ch->duration));
 
-		if (hif_drv->remain_on_ch.ready)
-			hif_drv->remain_on_ch.ready(hif_drv->remain_on_ch.arg);
+	if (hif_drv->remain_on_ch.ready)
+		hif_drv->remain_on_ch.ready(hif_drv->remain_on_ch.arg);
 
-		if (hif_drv->remain_on_ch_pending)
-			hif_drv->remain_on_ch_pending = 0;
-	}
+	if (hif_drv->remain_on_ch_pending)
+		hif_drv->remain_on_ch_pending = 0;
 
 	return result;
 }
-- 
2.7.4
