Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:9090 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752742AbeEKIOw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 04:14:52 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 17/30] staging: wilc1000: fix line over 80 chars in get_station()
Date: Fri, 11 May 2018 13:43:18 +0530
Message-ID: <1526026411-11058-18-git-send-email-ajay.kathat@microchip.com> (sfid-20180511_101454_776661_BCD6B2FF)
In-Reply-To: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
References: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix line over 80 characters issue in get_station().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 7994736..9684d34 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1121,7 +1121,9 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (vif->iftype == AP_MODE || vif->iftype == GO_MODE) {
 		for (i = 0; i < NUM_STA_ASSOCIATED; i++) {
-			if (!(memcmp(mac, priv->assoc_stainfo.sta_associated_bss[i], ETH_ALEN))) {
+			if (!(memcmp(mac,
+				     priv->assoc_stainfo.sta_associated_bss[i],
+				     ETH_ALEN))) {
 				associatedsta = i;
 				break;
 			}
-- 
2.7.4
