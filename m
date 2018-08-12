Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:34067 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbeHLHZC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Aug 2018 03:25:02 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 3/5] staging: wilc1000: remove the use of 'wilc_debugfs_info_t' struct
Date: Sun, 12 Aug 2018 10:17:43 +0530
Message-ID: <1534049265-5600-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180812_064837_366063_1C9BFF86)
In-Reply-To: <1534049265-5600-1-git-send-email-ajay.kathat@microchip.com>
References: <1534049265-5600-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor the code to remove the use of 'wilc_debugfs_info_t' struct.
Pass NULL for data in debugfs_create_file() call, as its value is not
used.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_debugfs.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index 78c0831..c9bc325 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -62,25 +62,10 @@ ssize_t wilc_debug_level_write(struct file *filp, const char __user *buf,
 	return count;
 }
 
-struct wilc_debugfs_info_t {
-	const char *name;
-	int perm;
-	unsigned int data;
-};
-
-static struct wilc_debugfs_info_t debugfs_info = {
-	"wilc_debug_level",
-	0666,
-	(DEBUG | ERR),
-};
-
 int wilc_debugfs_init(const struct file_operations *fops)
 {
-	struct wilc_debugfs_info_t *info = &debugfs_info;
-
 	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
-	debugfs_create_file(info->name, info->perm, wilc_dir, &info->data,
-			    fops);
+	debugfs_create_file("wilc_debug_level", 0666, wilc_dir, NULL, fops);
 
 	return 0;
 }
-- 
2.7.4
