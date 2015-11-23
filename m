Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33846 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbbKWNlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 08:41:04 -0500
Received: by padhx2 with SMTP id hx2so191716644pad.1
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2015 05:41:02 -0800 (PST)
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rdunlap@infradead.org, chris.park@atmel.com, austin.shin@atmel.com,
	johnny.kim@atmel.com, linux-wireless@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 3/4] staging: wilc1000: Fix typo in linux_wlan.c
Date: Mon, 23 Nov 2015 22:41:19 +0900
Message-Id: <1448286080-14787-3-git-send-email-standby24x7@gmail.com> (sfid-20151123_144117_424314_1A10E231)
In-Reply-To: <1448286080-14787-1-git-send-email-standby24x7@gmail.com>
References: <1448286080-14787-1-git-send-email-standby24x7@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fix some spelling typo in wilc1000.c.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 086f1db..dc98ccb 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -130,7 +130,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 
 	dev  = (struct net_device *)dev_iface->ifa_dev->dev;
 	if (!dev->ieee80211_ptr || !dev->ieee80211_ptr->wiphy) {
-		PRINT_D(GENERIC_DBG, "No Wireless registerd\n");
+		PRINT_D(GENERIC_DBG, "No Wireless registered\n");
 		return NOTIFY_DONE;
 	}
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
@@ -346,7 +346,7 @@ struct net_device *get_if_handler(struct wilc *wilc, u8 *mac_header)
 		    !memcmp(bssid, wilc->vif[i].bssid, ETH_ALEN))
 			return wilc->vif[i].ndev;
 
-	PRINT_INFO(INIT_DBG, "Invalide handle\n");
+	PRINT_INFO(INIT_DBG, "Invalid handle\n");
 	for (i = 0; i < 25; i++)
 		PRINT_D(INIT_DBG, "%02x ", mac_header[i]);
 	bssid = mac_header + 18;
@@ -500,13 +500,13 @@ int linux_wlan_get_firmware(struct net_device *dev)
 
 #ifdef WILC_SDIO
 	if (request_firmware(&wilc_firmware, firmware, &wilc->wilc_sdio_func->dev) != 0) {
-		PRINT_ER("%s - firmare not available\n", firmware);
+		PRINT_ER("%s - firmware not available\n", firmware);
 		ret = -1;
 		goto _fail_;
 	}
 #else
 	if (request_firmware(&wilc_firmware, firmware, &wilc->wilc_spidev->dev) != 0) {
-		PRINT_ER("%s - firmare not available\n", firmware);
+		PRINT_ER("%s - firmware not available\n", firmware);
 		ret = -1;
 		goto _fail_;
 	}
@@ -1155,19 +1155,19 @@ static void wilc_set_multicast_list(struct net_device *dev)
 		dev->mc.count);
 
 	if (dev->flags & IFF_PROMISC) {
-		PRINT_D(INIT_DBG, "Set promiscuous mode ON, retrive all packets\n");
+		PRINT_D(INIT_DBG, "Set promiscuous mode ON, retrieve all packets\n");
 		return;
 	}
 
 	if ((dev->flags & IFF_ALLMULTI) ||
 	    (dev->mc.count) > WILC_MULTICAST_TABLE_SIZE) {
-		PRINT_D(INIT_DBG, "Disable multicast filter, retrive all multicast packets\n");
+		PRINT_D(INIT_DBG, "Disable multicast filter, retrieve all multicast packets\n");
 		host_int_setup_multicast_filter(hif_drv, false, 0);
 		return;
 	}
 
 	if ((dev->mc.count) == 0) {
-		PRINT_D(INIT_DBG, "Enable multicast filter, retrive directed packets only.\n");
+		PRINT_D(INIT_DBG, "Enable multicast filter, retrieve directed packets only.\n");
 		host_int_setup_multicast_filter(hif_drv, true, 0);
 		return;
 	}
@@ -1413,7 +1413,7 @@ void frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 
 		skb = dev_alloc_skb(frame_len);
 		if (!skb) {
-			PRINT_ER("Low memory - packet droped\n");
+			PRINT_ER("Low memory - packet dropped\n");
 			return;
 		}
 
-- 
2.6.3.379.g0c83680

