Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:52284 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932094AbeDWQf5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 12:35:57 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [RESEND 28/33] staging: wilc1000: remove goto label '_done_' in handle_listen_state_expired()
Date: Mon, 23 Apr 2018 22:03:30 +0530
Message-ID: <1524501215-4963-29-git-send-email-ajay.kathat@microchip.com> (sfid-20180423_183609_407007_B0BA3E3C)
In-Reply-To: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
References: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the use of goto label '_done_' in handle_listen_state_expired().
Changes are done to avoid the use of '_' in label name.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1117705..65caa6d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2332,7 +2332,7 @@ static u32 handle_listen_state_expired(struct wilc_vif *vif,
 		kfree(wid.val);
 		if (result != 0) {
 			netdev_err(vif->ndev, "Failed to set remain channel\n");
-			goto _done_;
+			return result;
 		}
 
 		if (hif_drv->remain_on_ch.expired) {
@@ -2345,7 +2345,6 @@ static u32 handle_listen_state_expired(struct wilc_vif *vif,
 		result = -EFAULT;
 	}
 
-_done_:
 	return result;
 }
 
-- 
2.7.4
