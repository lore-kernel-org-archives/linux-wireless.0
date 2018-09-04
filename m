Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12538 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbeIDLDn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 07:03:43 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 04/26] staging: wilc1000: remove unnecessary NULL check in clear_shadow_scan()
Date: Tue, 4 Sep 2018 12:09:20 +0530
Message-ID: <1536043182-19735-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180904_084006_299885_97A2898B)
In-Reply-To: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
References: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the unnecessary NULL check before freeing up ies
information in clear_shadow_scan().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index ede9134..00a167b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -165,10 +165,8 @@ static void clear_shadow_scan(void)
 		return;
 
 	for (i = 0; i < last_scanned_cnt; i++) {
-		if (last_scanned_shadow[i].ies) {
-			kfree(last_scanned_shadow[i].ies);
-			last_scanned_shadow[i].ies = NULL;
-		}
+		kfree(last_scanned_shadow[i].ies);
+		last_scanned_shadow[i].ies = NULL;
 
 		kfree(last_scanned_shadow[i].join_params);
 		last_scanned_shadow[i].join_params = NULL;
-- 
2.7.4
