Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:32636 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751339AbeEBHP4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:15:56 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 20/21] staging: wilc1000: rename 'during_ip_time' macro to have uppercase name for macro
Date: Wed, 2 May 2018 12:43:46 +0530
Message-ID: <1525245227-3924-21-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_093238_446525_CB7865B6)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename 'during_ip_time' to 'DURING_IP_TIME_OUT' to have uppercase letter
for macros(#define).

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5e7bb1f..ed613b3 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -156,7 +156,7 @@ static struct ieee80211_supported_band WILC_WFI_band_2ghz = {
 };
 
 #define AGING_TIME	(9 * 1000)
-#define during_ip_time	15000
+#define DURING_IP_TIME_OUT	15000
 
 static void clear_shadow_scan(void)
 {
@@ -1863,7 +1863,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	case NL80211_IFTYPE_P2P_GO:
 		wilc_optaining_ip = true;
 		mod_timer(&wilc_during_ip_timer,
-			  jiffies + msecs_to_jiffies(during_ip_time));
+			  jiffies + msecs_to_jiffies(DURING_IP_TIME_OUT));
 		wilc_set_operation_mode(vif, AP_MODE);
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
-- 
2.7.4
