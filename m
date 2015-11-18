Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:23606 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683AbbKROQq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 09:16:46 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/1] wireless: airo: re-use mac_pton()
Date: Wed, 18 Nov 2015 16:16:41 +0200
Message-Id: <1447856201-70408-1-git-send-email-andriy.shevchenko@linux.intel.com> (sfid-20151118_151649_537233_E3C5EDD5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac_pton() converts 6-byte MAC / BSSID to binary format. Change an open coded
variant by the generic one.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wireless/airo.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 17c40f0..7ad78e5 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -5137,21 +5137,9 @@ static void proc_APList_on_close( struct inode *inode, struct file *file ) {
 	memset(APList_rid, 0, sizeof(*APList_rid));
 	APList_rid->len = cpu_to_le16(sizeof(*APList_rid));
 
-	for( i = 0; i < 4 && data->writelen >= (i+1)*6*3; i++ ) {
-		int j;
-		for( j = 0; j < 6*3 && data->wbuffer[j+i*6*3]; j++ ) {
-			switch(j%3) {
-			case 0:
-				APList_rid->ap[i][j/3]=
-					hex_to_bin(data->wbuffer[j+i*6*3])<<4;
-				break;
-			case 1:
-				APList_rid->ap[i][j/3]|=
-					hex_to_bin(data->wbuffer[j+i*6*3]);
-				break;
-			}
-		}
-	}
+	for (i = 0; i < 4 && data->writelen >= (i + 1) * 6 * 3; i++)
+		mac_pton(data->wbuffer + i * 6 * 3, APList_rid.ap[i]);
+
 	disable_MAC(ai, 1);
 	writeAPListRid(ai, APList_rid, 1);
 	enable_MAC(ai, 1);
-- 
2.6.2

