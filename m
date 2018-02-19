Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36608 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753167AbeBSPat (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 10:30:49 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <Adham.Abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 12/14] staging: wilc1000: rename GetPeriodicRSSI to avoid camelCase
Date: Mon, 19 Feb 2018 20:59:42 +0530
Message-ID: <1519054184-14301-13-git-send-email-ajay.kathat@microchip.com> (sfid-20180219_163054_222350_8069879B)
In-Reply-To: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
References: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6dd1061..4cbfe3b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3316,7 +3316,7 @@ int wilc_hif_set_cfg(struct wilc_vif *vif,
 	return wilc_enqueue_cmd(&msg);
 }
 
-static void GetPeriodicRSSI(struct timer_list *unused)
+static void get_periodic_rssi(struct timer_list *unused)
 {
 	struct wilc_vif *vif = periodic_rssi_vif;
 
@@ -3381,7 +3381,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 		}
 
 		periodic_rssi_vif = vif;
-		timer_setup(&periodic_rssi, GetPeriodicRSSI, 0);
+		timer_setup(&periodic_rssi, get_periodic_rssi, 0);
 		mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
 	}
 
-- 
2.7.4
