Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:34268 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751653AbeCTQ4V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 12:56:21 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 08/11] staging: wilc1000: fix line over 80 char issue in clear_shadow_scan()
Date: Tue, 20 Mar 2018 22:25:41 +0530
Message-ID: <1521564944-3565-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180320_175624_618200_E931B6C7)
In-Reply-To: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
References: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove 'line over 80 char' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index ebebdc3..1b6fe64 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -173,20 +173,21 @@ static void clear_shadow_scan(void)
 {
 	int i;
 
-	if (op_ifcs == 0) {
-		del_timer_sync(&aging_timer);
+	if (op_ifcs != 0)
+		return;
 
-		for (i = 0; i < last_scanned_cnt; i++) {
-			if (last_scanned_shadow[last_scanned_cnt].ies) {
-				kfree(last_scanned_shadow[i].ies);
-				last_scanned_shadow[last_scanned_cnt].ies = NULL;
-			}
+	del_timer_sync(&aging_timer);
 
-			kfree(last_scanned_shadow[i].join_params);
-			last_scanned_shadow[i].join_params = NULL;
+	for (i = 0; i < last_scanned_cnt; i++) {
+		if (last_scanned_shadow[last_scanned_cnt].ies) {
+			kfree(last_scanned_shadow[i].ies);
+			last_scanned_shadow[last_scanned_cnt].ies = NULL;
 		}
-		last_scanned_cnt = 0;
+
+		kfree(last_scanned_shadow[i].join_params);
+		last_scanned_shadow[i].join_params = NULL;
 	}
+	last_scanned_cnt = 0;
 }
 
 static u32 get_rssi_avg(struct network_info *network_info)
-- 
2.7.4
