Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35808 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbbINQwE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 12:52:04 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH] drivers: stating: wilc1000: Add a check for SPI availability
Date: Mon, 14 Sep 2015 22:21:14 +0530
Message-Id: <1442249474-3014-1-git-send-email-csgorentla@gmail.com> (sfid-20150914_185226_230732_47287C49)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NULL pointer deference is observed in the wilc1000.ko module
with bus type SPI and when SPI is not ready.

Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---

Following are the steps to reproduce.

$ sudo insmod drivers/staging/wilc1000/wilc1000.ko
$ sudo ifconfig wlan1 up

wlan1 in the above command is the device controlled by 'wilc1000.ko'.

 drivers/staging/wilc1000/linux_wlan.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 63f44f8..48f063d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1634,6 +1634,12 @@ int mac_open(struct net_device *ndev)
 	int i = 0;
 	struct WILC_WFI_priv *priv;
 
+#ifdef WILC_SPI
+	if (!g_linux_wlan || !g_linux_wlan->wilc_spidev) {
+		netdev_err(ndev, "wilc1000: SPI device not ready\n");
+		return -ENODEV;
+	}
+#endif
 	nic = netdev_priv(ndev);
 	priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
 	PRINT_D(INIT_DBG, "MAC OPEN[%p]\n", ndev);
-- 
2.5.0

