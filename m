Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:12716 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751882AbeBZQfx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 11:35:53 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 2/8] staging: wilc1000: rename label _end_ in wilc_wlan_handle_txq()
Date: Mon, 26 Feb 2018 22:01:56 +0530
Message-ID: <1519662722-15761-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180226_173632_661337_2A7B2511)
In-Reply-To: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
References: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename label name starting with '_' to follow as per linux coding style.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 37d6d87..5422359 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -648,7 +648,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 	} while (!wilc->quit);
 
 	if (!ret)
-		goto _end_;
+		goto out_release_bus;
 
 	timeout = 200;
 	do {
@@ -695,11 +695,11 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 	} while (1);
 
 	if (!ret)
-		goto _end_;
+		goto out_release_bus;
 
 	if (entries == 0) {
 		ret = WILC_TX_ERR_NO_BUF;
-		goto _end_;
+		goto out_release_bus;
 	}
 
 	release_bus(wilc, RELEASE_ALLOW_SLEEP);
@@ -756,11 +756,11 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 
 	ret = func->hif_clear_int_ext(wilc, ENABLE_TX_VMM);
 	if (!ret)
-		goto _end_;
+		goto out_release_bus;
 
 	ret = func->hif_block_tx_ext(wilc, 0, txb, offset);
 
-_end_:
+out_release_bus:
 	release_bus(wilc, RELEASE_ALLOW_SLEEP);
 
 out:
-- 
2.7.4
