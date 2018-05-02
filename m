Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:28631 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbeEBHPM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:15:12 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 06/21] staging: wilc1000: use 'else if' condition in get_station()
Date: Wed, 2 May 2018 12:43:32 +0530
Message-ID: <1525245227-3924-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_092100_451102_9F2A392B)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use 'else if' in get_station(), as only one condition will statisfy.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5c52a7c..827afe9 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1143,9 +1143,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 
 		wilc_get_inactive_time(vif, mac, &inactive_time);
 		sinfo->inactive_time = 1000 * inactive_time;
-	}
-
-	if (vif->iftype == STATION_MODE) {
+	} else if (vif->iftype == STATION_MODE) {
 		struct rf_info stats;
 
 		wilc_get_statistics(vif, &stats);
-- 
2.7.4
