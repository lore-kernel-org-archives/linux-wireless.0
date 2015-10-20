Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:16830 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbbJTIOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 04:14:18 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/13] staging: wilc1000: add wilc to netdev private data structure
Date: Tue, 20 Oct 2015 17:13:51 +0900
Message-ID: <1445328843-32247-1-git-send-email-tony.cho@atmel.com> (sfid-20151020_101424_144761_F82E8E8E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch add wilc to struct perInterface_wlan_t which is netdev private
data to access wilc via netdev_priv function. Assign wilc to nic->wilc.
The global variable g_linux_wlan will be replaced with netdev private data
member wilc step by step.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 1 +
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 5701e58..8fa6b7c 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1662,6 +1662,7 @@ int wilc_netdev_init(struct wilc **wilc)
 
 		nic->u8IfIdx = g_linux_wlan->vif_num;
 		nic->wilc_netdev = ndev;
+		nic->wilc = *wilc;
 		g_linux_wlan->vif[g_linux_wlan->vif_num].ndev = ndev;
 		g_linux_wlan->vif_num++;
 		ndev->netdev_ops = &wilc_netdev_ops;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index e0c66bc..40a44f8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -199,7 +199,7 @@ typedef struct {
 	struct_frame_reg g_struct_frame_reg[num_reg_frame];
 	struct net_device *wilc_netdev;
 	struct net_device_stats netstats;
-
+	struct wilc *wilc;
 } perInterface_wlan_t;
 
 struct WILC_WFI_mon_priv {
-- 
1.9.1

