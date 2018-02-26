Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:49515 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbeBZQgE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 11:36:04 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 5/8] staging: wilc1000: rename WILC_WFI_mgmt_rx() to avoid camelCase
Date: Mon, 26 Feb 2018 22:01:59 +0530
Message-ID: <1519662722-15761-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180226_173608_246611_E00618B5)
In-Reply-To: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
References: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 2 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c          | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index cf746f2..fe19bf3 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1149,7 +1149,7 @@ void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 	}
 }
 
-void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size)
+void wilc_wfi_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size)
 {
 	int i = 0;
 	struct wilc_vif *vif;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 3337fb2..d62c4f1 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -230,7 +230,7 @@ void wilc_netdev_cleanup(struct wilc *wilc);
 int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		     int gpio, const struct wilc_hif_func *ops);
 void wilc1000_wlan_deinit(struct net_device *dev);
-void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
+void wilc_wfi_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
 int wilc_wlan_get_firmware(struct net_device *dev);
 int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid, u8 mode);
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index f762785..74b80ad 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -815,7 +815,7 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 						IS_MANAGMEMENT_CALLBACK |
 						IS_MGMT_STATUS_SUCCES);
 
-				WILC_WFI_mgmt_rx(wilc, &buffer[offset + HOST_HDR_OFFSET], pkt_len);
+				wilc_wfi_mgmt_rx(wilc, &buffer[offset + HOST_HDR_OFFSET], pkt_len);
 			} else {
 				if (!is_cfg_packet) {
 					if (pkt_len > 0) {
-- 
2.7.4
