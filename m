Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:48952 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbeHLHYz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Aug 2018 03:24:55 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 1/5] staging: wilc1000: avoid arrray of 'wilc_debugfs_info_t' type
Date: Sun, 12 Aug 2018 10:17:41 +0530
Message-ID: <1534049265-5600-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180812_064821_190589_67F37DD1)
In-Reply-To: <1534049265-5600-1-git-send-email-ajay.kathat@microchip.com>
References: <1534049265-5600-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor code by removing array of 'wilc_debugfs_info_t' type and use
single variable to store 'wilc_debugfs_info_t' struct value.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_debugfs.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index edc7287..c5f67c9 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -78,29 +78,21 @@ struct wilc_debugfs_info_t {
 	const struct file_operations fops;
 };
 
-static struct wilc_debugfs_info_t debugfs_info[] = {
-	{
-		"wilc_debug_level",
-		0666,
-		(DEBUG | ERR),
-		FOPS(NULL, wilc_debug_level_read, wilc_debug_level_write, NULL),
-	},
+static struct wilc_debugfs_info_t debugfs_info = {
+	"wilc_debug_level",
+	0666,
+	(DEBUG | ERR),
+	FOPS(NULL, wilc_debug_level_read, wilc_debug_level_write, NULL),
 };
 
 int wilc_debugfs_init(void)
 {
-	int i;
-	struct wilc_debugfs_info_t *info;
+	struct wilc_debugfs_info_t *info = &debugfs_info;
 
 	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
-	for (i = 0; i < ARRAY_SIZE(debugfs_info); i++) {
-		info = &debugfs_info[i];
-		debugfs_create_file(info->name,
-				    info->perm,
-				    wilc_dir,
-				    &info->data,
-				    &info->fops);
-	}
+	debugfs_create_file(info->name, info->perm, wilc_dir, &info->data,
+			    &info->fops);
+
 	return 0;
 }
 
-- 
2.7.4
