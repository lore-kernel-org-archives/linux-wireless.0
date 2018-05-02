Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:31900 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbeEBHPK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:15:10 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 05/21] staging: wilc1000: fix line over 80 chars in remove_network_from_shadow()
Date: Wed, 2 May 2018 12:43:31 +0530
Message-ID: <1525245227-3924-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_092059_895083_FA3FA3A9)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added changes to avoid line over 80 character issue in
remove_network_from_shadow().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 470a103..5c52a7c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -253,18 +253,18 @@ static void remove_network_from_shadow(struct timer_list *unused)
 	int i, j;
 
 	for (i = 0; i < last_scanned_cnt; i++) {
-		if (time_after(now, last_scanned_shadow[i].time_scan +
-			       (unsigned long)(SCAN_RESULT_EXPIRE))) {
-			kfree(last_scanned_shadow[i].ies);
-			last_scanned_shadow[i].ies = NULL;
+		if (!time_after(now, last_scanned_shadow[i].time_scan +
+				(unsigned long)(SCAN_RESULT_EXPIRE)))
+			continue;
+		kfree(last_scanned_shadow[i].ies);
+		last_scanned_shadow[i].ies = NULL;
 
-			kfree(last_scanned_shadow[i].join_params);
+		kfree(last_scanned_shadow[i].join_params);
 
-			for (j = i; (j < last_scanned_cnt - 1); j++)
-				last_scanned_shadow[j] = last_scanned_shadow[j + 1];
+		for (j = i; (j < last_scanned_cnt - 1); j++)
+			last_scanned_shadow[j] = last_scanned_shadow[j + 1];
 
-			last_scanned_cnt--;
-		}
+		last_scanned_cnt--;
 	}
 
 	if (last_scanned_cnt != 0)
-- 
2.7.4
