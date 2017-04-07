Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55972 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753962AbdDGXoI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 19:44:08 -0400
From: Colin King <colin.king@canonical.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: fix incorrect strncasecmp length
Date: Sat,  8 Apr 2017 00:44:03 +0100
Message-Id: <20170407234403.9795-1-colin.king@canonical.com> (sfid-20170408_014507_591766_A58B5012)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The strncasecmp of buff against the literal string RSSI
is using variable length which is zero. This should be instead
using the variable size instead.  Also remove the redundant
variable length.

Detected by PVS-Studio, warning: V575

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2eebc6215cac..6aeaf19182e7 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1074,7 +1074,7 @@ static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 {
 	u8 *buff = NULL;
 	s8 rssi;
-	u32 size = 0, length = 0;
+	u32 size = 0;
 	struct wilc_vif *vif;
 	s32 ret = 0;
 	struct wilc *wilc;
@@ -1098,7 +1098,7 @@ static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 			if (IS_ERR(buff))
 				return PTR_ERR(buff);
 
-			if (strncasecmp(buff, "RSSI", length) == 0) {
+			if (strncasecmp(buff, "RSSI", size) == 0) {
 				ret = wilc_get_rssi(vif, &rssi);
 				netdev_info(ndev, "RSSI :%d\n", rssi);
 
-- 
2.11.0
