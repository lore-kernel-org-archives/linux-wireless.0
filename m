Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:34423 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbbJPJXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 05:23:25 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/13] staging: wilc1000: add wilc to netdev private data structure
Date: Fri, 16 Oct 2015 18:22:57 +0900
Message-ID: <1444987389-14151-1-git-send-email-tony.cho@atmel.com> (sfid-20151016_112329_367809_5796BF78)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch adds struct wilc to struct perInterface_wlan_t which is netdev
private data to access wilc via netdev_priv function and assigns wilc to
nic->wilc. The global variable wl will be replaced with netdev private data
member wilc step by step.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 1 +
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 3cc4861..90c39b6 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1658,6 +1658,7 @@ int wilc_netdev_init(struct wilc **wilc)
 
 		nic->u8IfIdx = wl->vif_num;
 		nic->wilc_netdev = ndev;
+		nic->wilc = *wilc;
 		wl->vif[wl->vif_num].ndev = ndev;
 		wl->vif_num++;
 		ndev->netdev_ops = &wilc_netdev_ops;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 9a9e082..cb23134 100644
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

