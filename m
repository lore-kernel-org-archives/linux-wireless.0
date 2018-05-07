Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12228 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752531AbeEGIob (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 04:44:31 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 15/30] staging: wilc1000: use kmemdup instead of kmalloc in add_network_to_shadow()
Date: Mon, 7 May 2018 14:13:19 +0530
Message-ID: <1525682614-3824-16-git-send-email-ajay.kathat@microchip.com> (sfid-20180507_104436_657961_3108911B)
In-Reply-To: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use kmemdup instead of kmalloc & memcpy in add_network_to_shadow().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 0ae2065..ca221f1 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -331,8 +331,8 @@ static void add_network_to_shadow(struct network_info *nw_info,
 	shadow_nw_info->tsf_hi = nw_info->tsf_hi;
 	if (ap_found != -1)
 		kfree(shadow_nw_info->ies);
-	shadow_nw_info->ies = kmalloc(nw_info->ies_len, GFP_KERNEL);
-	memcpy(shadow_nw_info->ies, nw_info->ies, nw_info->ies_len);
+	shadow_nw_info->ies = kmemdup(nw_info->ies, nw_info->ies_len,
+				      GFP_KERNEL);
 	shadow_nw_info->time_scan = jiffies;
 	shadow_nw_info->time_scan_cached = jiffies;
 	shadow_nw_info->found = 1;
-- 
2.7.4
