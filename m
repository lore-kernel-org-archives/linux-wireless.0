Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:2315 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730919AbeISLmC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 07:42:02 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 04/29] staging: wilc1000: change return type to 'void' for wilc_deinit_host_int()
Date: Wed, 19 Sep 2018 11:34:54 +0530
Message-ID: <1537337119-14952-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180919_080546_105936_35CA9308)
In-Reply-To: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
References: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to use 'void' return type for wilc_deinit_host_int(),
as its return value is not used in caller.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 +---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 37c26d4..02a8846 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2175,7 +2175,7 @@ int wilc_init_host_int(struct net_device *net)
 	return ret;
 }
 
-int wilc_deinit_host_int(struct net_device *net)
+void wilc_deinit_host_int(struct net_device *net)
 {
 	int ret;
 	struct wilc_priv *priv = wdev_priv(net->ieee80211_ptr);
@@ -2192,8 +2192,6 @@ int wilc_deinit_host_int(struct net_device *net)
 
 	if (ret)
 		netdev_err(net, "Error while deinitializing host interface\n");
-
-	return ret;
 }
 
 void wilc_free_wiphy(struct net_device *net)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index be412b6..1858f56 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -11,7 +11,7 @@
 struct wireless_dev *wilc_create_wiphy(struct net_device *net,
 				       struct device *dev);
 void wilc_free_wiphy(struct net_device *net);
-int wilc_deinit_host_int(struct net_device *net);
+void wilc_deinit_host_int(struct net_device *net);
 int wilc_init_host_int(struct net_device *net);
 void wilc_wfi_monitor_rx(u8 *buff, u32 size);
 int wilc_wfi_deinit_mon_interface(void);
-- 
2.7.4
