Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:3080 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752244AbeBTO6s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:58:48 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 11/12] staging: wilc1000: rename _WPAPtk_end_case_ label to avoid camelCase
Date: Tue, 20 Feb 2018 20:28:00 +0530
Message-ID: <1519138681-1982-12-git-send-email-ajay.kathat@microchip.com> (sfid-20180220_155851_960131_8A426451)
In-Reply-To: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
References: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8528ff8..0cfb79d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1690,7 +1690,7 @@ static int handle_key(struct wilc_vif *vif,
 			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN + 1, GFP_KERNEL);
 			if (!pu8keybuf) {
 				ret = -ENOMEM;
-				goto _WPAPtk_end_case_;
+				goto out_wpa_ptk;
 			}
 
 			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wpa.mac_addr, 6);
@@ -1719,7 +1719,7 @@ static int handle_key(struct wilc_vif *vif,
 			if (!pu8keybuf) {
 				netdev_err(vif->ndev, "No buffer send PTK\n");
 				ret = -ENOMEM;
-				goto _WPAPtk_end_case_;
+				goto out_wpa_ptk;
 			}
 
 			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wpa.mac_addr, 6);
@@ -1739,7 +1739,7 @@ static int handle_key(struct wilc_vif *vif,
 			complete(&hif_drv->comp_test_key_block);
 		}
 
-_WPAPtk_end_case_:
+out_wpa_ptk:
 		kfree(pstrHostIFkeyAttr->attr.wpa.key);
 		if (ret)
 			return ret;
-- 
2.7.4
