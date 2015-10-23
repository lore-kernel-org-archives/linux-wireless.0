Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:51974 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbbJWF13 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:27:29 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 16/28] staging: wilc1000: WILC_WFI_mgmt_rx: add argument wilc and use it
Date: Fri, 23 Oct 2015 14:28:32 +0900
Message-ID: <1445578124-31486-16-git-send-email-glen.lee@atmel.com> (sfid-20151023_074657_043220_44D8B7A2)
In-Reply-To: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add new argument wilc and use wilc instead of g_wlan_linux.
Declare the function in wilc_wfi_netdevice.h.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 10 +++++-----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  1 +
 drivers/staging/wilc1000/wilc_wlan.c          |  3 +--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2f1543d..fef6664 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1604,25 +1604,25 @@ void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset)
 	}
 }
 
-void WILC_WFI_mgmt_rx(u8 *buff, u32 size)
+void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size)
 {
 	int i = 0;
 	perInterface_wlan_t *nic;
 
 	/*Pass the frame on the monitor interface, if any.*/
 	/*Otherwise, pass it on p2p0 netdev, if registered on it*/
-	for (i = 0; i < g_linux_wlan->vif_num; i++) {
-		nic = netdev_priv(g_linux_wlan->vif[i].ndev);
+	for (i = 0; i < wilc->vif_num; i++) {
+		nic = netdev_priv(wilc->vif[i].ndev);
 		if (nic->monitor_flag) {
 			WILC_WFI_monitor_rx(buff, size);
 			return;
 		}
 	}
 
-	nic = netdev_priv(g_linux_wlan->vif[1].ndev); /* p2p0 */
+	nic = netdev_priv(wilc->vif[1].ndev); /* p2p0 */
 	if ((buff[0] == nic->g_struct_frame_reg[0].frame_type && nic->g_struct_frame_reg[0].reg) ||
 	    (buff[0] == nic->g_struct_frame_reg[1].frame_type && nic->g_struct_frame_reg[1].reg))
-		WILC_WFI_p2p_rx(g_linux_wlan->vif[1].ndev, buff, size);
+		WILC_WFI_p2p_rx(wilc->vif[1].ndev, buff, size);
 }
 
 void wl_wlan_cleanup(void)
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index a828fab..8ba69ee 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -216,4 +216,5 @@ int linux_wlan_lock_timeout(void *vp, u32 timeout);
 void wl_wlan_cleanup(void);
 int wilc_netdev_init(struct wilc **wilc);
 void wilc1000_wlan_deinit(struct net_device *dev);
+void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index ae4b01f..531d342 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -18,7 +18,6 @@
  ********************************************/
 extern wilc_hif_func_t hif_sdio;
 extern wilc_hif_func_t hif_spi;
-extern void WILC_WFI_mgmt_rx(u8 *buff, u32 size);
 u32 wilc_get_chipid(u8 update);
 u16 Set_machw_change_vir_if(bool bValue);
 
@@ -1178,7 +1177,7 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 				/* reset mgmt indicator bit, to use pkt_offeset in furthur calculations */
 				pkt_offset &= ~(IS_MANAGMEMENT | IS_MANAGMEMENT_CALLBACK | IS_MGMT_STATUS_SUCCES);
 
-				WILC_WFI_mgmt_rx(&buffer[offset + HOST_HDR_OFFSET], pkt_len);
+				WILC_WFI_mgmt_rx(wilc, &buffer[offset + HOST_HDR_OFFSET], pkt_len);
 			}
 			else
 			{
-- 
1.9.1

