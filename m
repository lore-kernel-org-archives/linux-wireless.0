Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:42989 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbeCLNUQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Mar 2018 09:20:16 -0400
From: hariprasath.elango@gmail.com
To: aditya.shankar@microchip.com
Cc: hariprasath.elango@gmail.com, vbabu3@visteon.com,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: Destroy mutex object in deinitialization
Date: Mon, 12 Mar 2018 18:49:49 +0530
Message-Id: <20180312131950.12854-1-hariprasath.elango@gmail.com> (sfid-20180312_142035_368405_05F66633)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: HariPrasath Elango <hariprasath.elango@gmail.com>

Destroy the mutex object that is initialized in wlan_init_locks()

Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 1af3c14..38a83bd 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -678,6 +678,7 @@ static int wlan_deinit_locks(struct net_device *dev)
 
 	mutex_destroy(&wilc->hif_cs);
 	mutex_destroy(&wilc->rxq_cs);
+	mutex_destroy(&wilc->txq_add_to_head_cs);
 
 	return 0;
 }
-- 
2.10.0.GIT
