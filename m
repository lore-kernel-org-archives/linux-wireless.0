Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:6089 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425508AbeCBOXg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:23:36 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 05/13] staging: wilc1000: fix line over 80 char for wilc_gnrl_async_info_received()
Date: Fri, 2 Mar 2018 19:52:41 +0530
Message-ID: <1520000569-27738-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180302_152339_840022_78364D13)
In-Reply-To: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
References: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 char' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a44ddb2..a15c087 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3520,7 +3520,10 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 
 	mutex_lock(&hif_deinit_lock);
 
-	id = ((buffer[length - 4]) | (buffer[length - 3] << 8) | (buffer[length - 2] << 16) | (buffer[length - 1] << 24));
+	id = buffer[length - 4];
+	id |= (buffer[length - 3] << 8);
+	id |= (buffer[length - 2] << 16);
+	id |= (buffer[length - 1] << 24);
 	vif = wilc_get_vif_from_idx(wilc, id);
 	if (!vif) {
 		mutex_unlock(&hif_deinit_lock);
-- 
2.7.4
