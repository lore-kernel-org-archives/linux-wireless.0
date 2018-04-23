Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:35393 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755597AbeDWQfH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 12:35:07 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [RESEND 08/33] staging: wilc1000: fix line over 80 char issue in clear_shadow_scan()
Date: Mon, 23 Apr 2018 22:03:10 +0530
Message-ID: <1524501215-4963-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180423_183518_280933_7F2810D8)
In-Reply-To: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
References: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove 'line over 80 char' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 7dfca74..075413f 100644
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
