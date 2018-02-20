Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:3080 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752245AbeBTO6v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:58:51 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 12/12] staging: wilc1000: rename _WPARxGtk_end_case_ label to avoid camelCase
Date: Tue, 20 Feb 2018 20:28:01 +0530
Message-ID: <1519138681-1982-13-git-send-email-ajay.kathat@microchip.com> (sfid-20180220_155854_767296_75F7AE5B)
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
index 0cfb79d..253225c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1620,7 +1620,7 @@ static int handle_key(struct wilc_vif *vif,
 			pu8keybuf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (!pu8keybuf) {
 				ret = -ENOMEM;
-				goto _WPARxGtk_end_case_;
+				goto out_wpa_rx_gtk;
 			}
 
 			if (pstrHostIFkeyAttr->attr.wpa.seq)
@@ -1651,7 +1651,7 @@ static int handle_key(struct wilc_vif *vif,
 			pu8keybuf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (!pu8keybuf) {
 				ret = -ENOMEM;
-				goto _WPARxGtk_end_case_;
+				goto out_wpa_rx_gtk;
 			}
 
 			if (hif_drv->hif_state == HOST_IF_CONNECTED)
@@ -1677,7 +1677,7 @@ static int handle_key(struct wilc_vif *vif,
 			kfree(pu8keybuf);
 			complete(&hif_drv->comp_test_key_block);
 		}
-_WPARxGtk_end_case_:
+out_wpa_rx_gtk:
 		kfree(pstrHostIFkeyAttr->attr.wpa.key);
 		kfree(pstrHostIFkeyAttr->attr.wpa.seq);
 		if (ret)
-- 
2.7.4
