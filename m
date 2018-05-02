Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:1451 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbeEBHPT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:15:19 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 08/21] staging: wilc1000: rename WILC_WFI_monitor_rx to avoid uppercase for function name
Date: Wed, 2 May 2018 12:43:34 +0530
Message-ID: <1525245227-3924-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_093236_080716_9BD0AFCD)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to follow names as per linux coding style.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_mon.c              | 2 +-
 drivers/staging/wilc1000/linux_wlan.c             | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 02cbefd..ff13e0d 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -25,7 +25,7 @@ static u8 broadcast[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 #define IEEE80211_RADIOTAP_F_TX_FAIL	0x0001  /* failed due to excessive*/
 #define GET_PKT_OFFSET(a) (((a) >> 22) & 0x1ff)
 
-void WILC_WFI_monitor_rx(u8 *buff, u32 size)
+void wilc_wfi_monitor_rx(u8 *buff, u32 size)
 {
 	u32 header, pkt_offset;
 	struct sk_buff *skb = NULL;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 491baeb..f66704d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1068,7 +1068,7 @@ void wilc_wfi_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size)
 	for (i = 0; i < wilc->vif_num; i++) {
 		vif = netdev_priv(wilc->vif[i]->ndev);
 		if (vif->monitor_flag) {
-			WILC_WFI_monitor_rx(buff, size);
+			wilc_wfi_monitor_rx(buff, size);
 			return;
 		}
 	}
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 7372813..a0a07b4 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -7,7 +7,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 void wilc_free_wiphy(struct net_device *net);
 int wilc_deinit_host_int(struct net_device *net);
 int wilc_init_host_int(struct net_device *net);
-void WILC_WFI_monitor_rx(u8 *buff, u32 size);
+void wilc_wfi_monitor_rx(u8 *buff, u32 size);
 int WILC_WFI_deinit_mon_interface(void);
 struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_device *real_dev);
 void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
-- 
2.7.4
