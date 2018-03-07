Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:50771 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934924AbeCHPLQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:11:16 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 09/10] staging: wilc1000: rename pJoinParams to avoid camelCase
Date: Wed, 7 Mar 2018 07:02:29 +0530
Message-ID: <1520386350-31607-10-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_161119_433280_45AFFC90)
In-Reply-To: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
References: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'Avoid camelCase' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index a93c550..9da686b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -315,7 +315,7 @@ static int is_network_in_shadow(struct network_info *nw_info, void *user_void)
 }
 
 static void add_network_to_shadow(struct network_info *nw_info,
-				  void *user_void, void *pJoinParams)
+				  void *user_void, void *join_params)
 {
 	int ap_found = is_network_in_shadow(nw_info, user_void);
 	u32 ap_index = 0;
@@ -360,7 +360,7 @@ static void add_network_to_shadow(struct network_info *nw_info,
 	last_scanned_shadow[ap_index].found = 1;
 	if (ap_found != -1)
 		kfree(last_scanned_shadow[ap_index].join_params);
-	last_scanned_shadow[ap_index].join_params = pJoinParams;
+	last_scanned_shadow[ap_index].join_params = join_params;
 }
 
 static void cfg_scan_result(enum scan_event scan_event,
-- 
2.7.4
