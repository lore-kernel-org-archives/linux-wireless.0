Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:26101 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbeIDLDj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 07:03:39 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 03/26] staging: wilc1000: fix to use correct index to free scanned info in clear_shadow_scan()
Date: Tue, 4 Sep 2018 12:09:19 +0530
Message-ID: <1536043182-19735-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180904_084002_770510_1B06F0A7)
In-Reply-To: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
References: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes to use correct index to free the allocated memory for ies
information. The check was done using 'last_scanned_cnt' index and its
not correct, so use the correct index ('i') to check for before freeing
the allocated memory.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index d853508..ede9134 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -165,9 +165,9 @@ static void clear_shadow_scan(void)
 		return;
 
 	for (i = 0; i < last_scanned_cnt; i++) {
-		if (last_scanned_shadow[last_scanned_cnt].ies) {
+		if (last_scanned_shadow[i].ies) {
 			kfree(last_scanned_shadow[i].ies);
-			last_scanned_shadow[last_scanned_cnt].ies = NULL;
+			last_scanned_shadow[i].ies = NULL;
 		}
 
 		kfree(last_scanned_shadow[i].join_params);
-- 
2.7.4
