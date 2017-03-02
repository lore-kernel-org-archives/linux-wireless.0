Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36435 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752542AbdCBQPC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 11:15:02 -0500
From: Georgios Emmanouil <geo.emmnl@gmail.com>
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging:wilc1000:linux_wlan: Modified the 'if-else' statement
Date: Thu,  2 Mar 2017 18:14:07 +0200
Message-Id: <1488471247-11820-1-git-send-email-geo.emmnl@gmail.com> (sfid-20170302_171722_976646_280D6E48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modified the 'if-else' statement to make it more readable.

Signed-off-by: Georgios Emmanouil <geo.emmnl@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2eebc62..d82f0ff 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -867,15 +867,10 @@ static int wilc_mac_open(struct net_device *ndev)
 							 wilc_get_vif_idx(vif),
 							 wl->open_ifcs);
 			} else {
-				if (memcmp(wl->vif[i ^ 1]->bssid,
-					   wl->vif[i ^ 1]->src_addr, 6))
-					wilc_set_wfi_drv_handler(vif,
-							 wilc_get_vif_idx(vif),
-							 0);
+				if (memcmp(wl->vif[i ^ 1]->bssid, wl->vif[i ^ 1]->src_addr, 6))
+					wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif), 0);
 				else
-					wilc_set_wfi_drv_handler(vif,
-							 wilc_get_vif_idx(vif),
-							 1);
+					wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif), 1);
 			}
 			wilc_set_operation_mode(vif, vif->iftype);

--
2.1.4
