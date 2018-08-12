Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:16612 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727503AbeHLHZF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Aug 2018 03:25:05 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 4/5] staging: wilc1000: change permission to 0600 in debugfs_create_file() call
Date: Sun, 12 Aug 2018 10:17:44 +0530
Message-ID: <1534049265-5600-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180812_064838_717089_3641AD62)
In-Reply-To: <1534049265-5600-1-git-send-email-ajay.kathat@microchip.com>
References: <1534049265-5600-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to use more restrictive access permission for debugfs
file.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index c9bc325..15e797b 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -65,7 +65,7 @@ ssize_t wilc_debug_level_write(struct file *filp, const char __user *buf,
 int wilc_debugfs_init(const struct file_operations *fops)
 {
 	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
-	debugfs_create_file("wilc_debug_level", 0666, wilc_dir, NULL, fops);
+	debugfs_create_file("wilc_debug_level", 0600, wilc_dir, NULL, fops);
 
 	return 0;
 }
-- 
2.7.4
