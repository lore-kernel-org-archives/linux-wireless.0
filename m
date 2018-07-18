Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:62081 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbeGSGp5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:45:57 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 03/23] staging: wilc1000: remove extra enum defined for data rates
Date: Thu, 19 Jul 2018 04:14:59 +0530
Message-ID: <1531953919-20804-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080435_136703_91C7E2A9)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove extra enum defined to handle data rates.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c   |  2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h | 16 ----------------
 2 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 0019bb8..032afc2 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -378,7 +378,7 @@ static int linux_wlan_init_test_config(struct net_device *dev,
 	if (!wilc_wlan_cfg_set(vif, 0, WID_BSS_TYPE, c_val, 1, 0, 0))
 		goto fail;
 
-	c_val[0] = RATE_AUTO;
+	c_val[0] = AUTORATE;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_CURRENT_TX_RATE, c_val, 1, 0, 0))
 		goto fail;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 85ac878..b23f86c 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -88,22 +88,6 @@ enum bss_types {
 };
 
 enum {
-	RATE_AUTO		= 0,
-	RATE_1MB		= 1,
-	RATE_2MB		= 2,
-	RATE_5MB		= 5,
-	RATE_6MB		= 6,
-	RATE_9MB		= 9,
-	RATE_11MB		= 11,
-	RATE_12MB		= 12,
-	RATE_18MB		= 18,
-	RATE_24MB		= 24,
-	RATE_26MB		= 36,
-	RATE_48MB		= 48,
-	RATE_54MB		= 54
-};
-
-enum {
 	B_ONLY_MODE		= 0,    /* 1, 2 M, otherwise 5, 11 M */
 	G_ONLY_MODE,			/* 6,12,24 otherwise 9,18,36,48,54 */
 	G_MIXED_11B_1_MODE,		/* 1,2,5.5,11 otherwise all on */
-- 
2.7.4
