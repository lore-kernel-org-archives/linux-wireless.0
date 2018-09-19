Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:1289 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730974AbeISLnd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 07:43:33 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 29/29] staging: wilc1000: return exact error of register_netdev() from wilc_netdev_init()
Date: Wed, 19 Sep 2018 11:35:19 +0530
Message-ID: <1537337119-14952-30-git-send-email-ajay.kathat@microchip.com> (sfid-20180919_080723_874927_C97858E5)
In-Reply-To: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
References: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modified wilc_netdev_init() to return the error code received from
register_netdev() during the failure condition.

Earlier discussion link
[1]. https://www.spinics.net/lists/linux-wireless/msg177304.html

Suggested-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 29c1317..75abaf9 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1056,14 +1056,14 @@ static const struct net_device_ops wilc_netdev_ops = {
 int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		     const struct wilc_hif_func *ops)
 {
-	int i, ret;
+	int i, ret = -ENOMEM;
 	struct wilc_vif *vif;
 	struct net_device *ndev;
 	struct wilc *wl;
 
 	wl = kzalloc(sizeof(*wl), GFP_KERNEL);
 	if (!wl)
-		return -ENOMEM;
+		return ret;
 
 	if (wilc_wlan_cfg_init(wl))
 		goto free_wl;
@@ -1151,7 +1151,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	wilc_wlan_cfg_deinit(wl);
 free_wl:
 	kfree(wl);
-	return -ENOMEM;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(wilc_netdev_init);
 
-- 
2.7.4
