Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:44715 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752472AbeEKIOk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 04:14:40 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 14/30] staging: wilc1000: use kmemdup instead of kmalloc in add_network_to_shadow()
Date: Fri, 11 May 2018 13:43:15 +0530
Message-ID: <1526026411-11058-15-git-send-email-ajay.kathat@microchip.com> (sfid-20180511_101444_871776_F892BAA7)
In-Reply-To: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
References: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use kmemdup instead of kmalloc & memcpy in add_network_to_shadow(). Also
added  code to set 'ies_len' to zero in case of memory allocation
failure.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c730323..32bdefb 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -327,12 +327,15 @@ static void add_network_to_shadow(struct network_info *nw_info,
 	shadow_nw_info->beacon_period = nw_info->beacon_period;
 	shadow_nw_info->dtim_period = nw_info->dtim_period;
 	shadow_nw_info->ch = nw_info->ch;
-	shadow_nw_info->ies_len = nw_info->ies_len;
 	shadow_nw_info->tsf_hi = nw_info->tsf_hi;
 	if (ap_found != -1)
 		kfree(shadow_nw_info->ies);
-	shadow_nw_info->ies = kmalloc(nw_info->ies_len, GFP_KERNEL);
-	memcpy(shadow_nw_info->ies, nw_info->ies, nw_info->ies_len);
+	shadow_nw_info->ies = kmemdup(nw_info->ies, nw_info->ies_len,
+				      GFP_KERNEL);
+	if (shadow_nw_info->ies)
+		shadow_nw_info->ies_len = nw_info->ies_len;
+	else
+		shadow_nw_info->ies_len = 0;
 	shadow_nw_info->time_scan = jiffies;
 	shadow_nw_info->time_scan_cached = jiffies;
 	shadow_nw_info->found = 1;
-- 
2.7.4
