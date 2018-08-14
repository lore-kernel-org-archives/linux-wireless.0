Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:41347 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbeHNJg4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:36:56 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 14/24] staging: wilc1000: rename 'dummy_statistics' variable to 'periodic_stat'
Date: Tue, 14 Aug 2018 12:20:06 +0530
Message-ID: <1534229416-13254-15-git-send-email-ajay.kathat@microchip.com> (sfid-20180814_085110_661707_29E71917)
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to use appropriate variable name to fetch the periodic
statistics.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c     | 2 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a440f84..98098fb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3425,7 +3425,7 @@ static void get_periodic_rssi(struct timer_list *t)
 	}
 
 	if (vif->hif_drv->hif_state == HOST_IF_CONNECTED)
-		wilc_get_statistics(vif, &vif->dummy_statistics, false);
+		wilc_get_statistics(vif, &vif->periodic_stat, false);
 
 	mod_timer(&vif->periodic_rssi, jiffies + msecs_to_jiffies(5000));
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index cdb90c3..c53d38f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -123,7 +123,7 @@ struct wilc_vif {
 	u8 mc_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 	bool is_termination_progress;
 	struct timer_list periodic_rssi;
-	struct rf_info dummy_statistics;
+	struct rf_info periodic_stat;
 };
 
 struct wilc {
-- 
2.7.4
