Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35580 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752311AbdBJPH2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 10:07:28 -0500
Received: by mail-wm0-f68.google.com with SMTP id u63so7770856wmu.2
        for <linux-wireless@vger.kernel.org>; Fri, 10 Feb 2017 07:06:37 -0800 (PST)
From: Franck Demathieu <fdemathieu@gmail.com>
To: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Cc: aditya.shankar@microchip.com, ganesh.krishna@microchip.com
Subject: [PATCH] staging: wilc1000: remove unnecessary local array
Date: Fri, 10 Feb 2017 16:06:25 +0100
Message-Id: <20170210150625.23343-1-fdemathieu@gmail.com> (sfid-20170210_160837_454878_AF9B0E22)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It fixes the following warning reported by sparse:

  drivers/staging/wilc1000/linux_wlan.c:67:33: warning: too long initializer-string for array of char(no space for nul char)

Signed-off-by: Franck Demathieu <fdemathieu@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2eebc62..fc61f4e 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -64,7 +64,6 @@ static int dev_state_ev_handler(struct notifier_block *this,
 	u8 *ip_addr_buf;
 	struct wilc_vif *vif;
 	u8 null_ip[4] = {0};
-	char wlan_dev_name[5] = "wlan0";
 
 	if (!dev_iface || !dev_iface->ifa_dev || !dev_iface->ifa_dev->dev)
 		return NOTIFY_DONE;
@@ -113,7 +112,7 @@ static int dev_state_ev_handler(struct notifier_block *this,
 			wilc_optaining_ip = false;
 		}
 
-		if (memcmp(dev_iface->ifa_label, wlan_dev_name, 5) == 0)
+		if (memcmp(dev_iface->ifa_label, "wlan0", 5) == 0)
 			wilc_set_power_mgmt(vif, 0, 0);
 
 		wilc_resolve_disconnect_aberration(vif);
-- 
2.10.1
