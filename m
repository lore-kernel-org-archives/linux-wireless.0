Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:62472 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbeGSGqh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:46:37 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 15/23] staging: wilc1000: use single space before opening brances '{'
Date: Thu, 19 Jul 2018 04:15:11 +0530
Message-ID: <1531953919-20804-16-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080515_576219_D7767271)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to use single space instead of multiple space before the
'{'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 6 +++---
 drivers/staging/wilc1000/linux_wlan.c             | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c              | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8649225..2f25175 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -799,7 +799,7 @@ static void handle_scan(struct work_struct *work)
 	    scan_info->ch_list_len > 0) {
 		int i;
 
-		for (i = 0; i < scan_info->ch_list_len; i++)	{
+		for (i = 0; i < scan_info->ch_list_len; i++) {
 			if (scan_info->ch_freq_list[i] > 0)
 				scan_info->ch_freq_list[i] -= 1;
 		}
@@ -3337,7 +3337,7 @@ int wilc_deinit(struct wilc_vif *vif)
 	int result = 0;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
-	if (!hif_drv)	{
+	if (!hif_drv) {
 		netdev_err(vif->ndev, "hif_drv = NULL\n");
 		return -EFAULT;
 	}
@@ -3404,7 +3404,7 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 		return;
 	hif_drv = vif->hif_drv;
 
-	if (!hif_drv || hif_drv == terminated_handle)	{
+	if (!hif_drv || hif_drv == terminated_handle) {
 		netdev_err(vif->ndev, "driver not init[%p]\n", hif_drv);
 		return;
 	}
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 8f77435..5667a54 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -604,7 +604,7 @@ static void wilc_wlan_deinitialize(struct net_device *dev)
 		return;
 	}
 
-	if (wl->initialized)	{
+	if (wl->initialized) {
 		netdev_info(dev, "Deinitializing wilc1000...\n");
 
 		if (!wl->dev_irq_num &&
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 43003d8..96aaf14 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -524,7 +524,7 @@ static void cfg_connect_result(enum conn_event conn_disconn_evt,
 					conn_info->resp_ies,
 					conn_info->resp_ies_len, connect_status,
 					GFP_KERNEL);
-	} else if (conn_disconn_evt == CONN_DISCONN_EVENT_DISCONN_NOTIF)    {
+	} else if (conn_disconn_evt == CONN_DISCONN_EVENT_DISCONN_NOTIF) {
 		wilc_optaining_ip = false;
 		p2p_local_random = 0x01;
 		p2p_recv_random = 0x00;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c77e5c8..cb8bfd2 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -436,7 +436,7 @@ void chip_wakeup(struct wilc *wilc)
 				wilc_get_chipid(wilc, true);
 			} while (wilc_get_chipid(wilc, true) == 0);
 		} while (wilc_get_chipid(wilc, true) == 0);
-	} else if ((wilc->io_type & 0x1) == HIF_SDIO)	 {
+	} else if ((wilc->io_type & 0x1) == HIF_SDIO) {
 		wilc->hif_func->hif_write_reg(wilc, 0xfa, 1);
 		udelay(200);
 		wilc->hif_func->hif_read_reg(wilc, 0xf0, &reg);
-- 
2.7.4
