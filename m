Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:19134 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727503AbeHLHZJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Aug 2018 03:25:09 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 5/5] staging: wilc1000: use void return for wilc_debugfs_init()
Date: Sun, 12 Aug 2018 10:17:45 +0530
Message-ID: <1534049265-5600-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180812_064840_378893_4D918B47)
In-Reply-To: <1534049265-5600-1-git-send-email-ajay.kathat@microchip.com>
References: <1534049265-5600-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change the return type from int to void for wilc_debugfs_init(), as its
return value is not used.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_debugfs.c | 4 +---
 drivers/staging/wilc1000/wilc_wlan_if.h | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index 15e797b..1a2c4e7 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -62,12 +62,10 @@ ssize_t wilc_debug_level_write(struct file *filp, const char __user *buf,
 	return count;
 }
 
-int wilc_debugfs_init(const struct file_operations *fops)
+void wilc_debugfs_init(const struct file_operations *fops)
 {
 	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
 	debugfs_create_file("wilc_debug_level", 0600, wilc_dir, NULL, fops);
-
-	return 0;
 }
 
 void wilc_debugfs_remove(void)
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 47b4020..21f72a8 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -831,7 +831,7 @@ struct wilc;
 int wilc_wlan_init(struct net_device *dev);
 u32 wilc_get_chipid(struct wilc *wilc, bool update);
 
-int wilc_debugfs_init(const struct file_operations *fops);
+void wilc_debugfs_init(const struct file_operations *fops);
 void wilc_debugfs_remove(void);
 ssize_t wilc_debug_level_read(struct file *file, char __user *userbuf,
 			      size_t count, loff_t *ppos);
-- 
2.7.4
