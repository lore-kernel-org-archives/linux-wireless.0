Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:39875 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425508AbeCBOXc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:23:32 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 04/13] staging: wilc1000: fix line over 80 char in wilc_network_info_received()
Date: Fri, 2 Mar 2018 19:52:40 +0530
Message-ID: <1520000569-27738-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180302_152336_437891_8106A4F1)
In-Reply-To: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
References: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 character' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index cabee47..a44ddb2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3482,7 +3482,10 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 	struct host_if_drv *hif_drv = NULL;
 	struct wilc_vif *vif;
 
-	id = ((buffer[length - 4]) | (buffer[length - 3] << 8) | (buffer[length - 2] << 16) | (buffer[length - 1] << 24));
+	id = buffer[length - 4];
+	id |= (buffer[length - 3] << 8);
+	id |= (buffer[length - 2] << 16);
+	id |= (buffer[length - 1] << 24);
 	vif = wilc_get_vif_from_idx(wilc, id);
 	if (!vif)
 		return;
-- 
2.7.4
