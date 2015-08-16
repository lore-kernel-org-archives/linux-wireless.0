Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:36615 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbbHPFam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2015 01:30:42 -0400
From: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] staging: wilc1000: code style: fix macro with multiple statements
Date: Sun, 16 Aug 2015 01:30:12 -0400
Message-Id: <641be2615e97db253a306c766a48c2afccf338d7.1439702894.git.raphael.beamonte@gmail.com> (sfid-20150816_073133_767176_3563801A)
In-Reply-To: <cover.1439702894.git.raphael.beamonte@gmail.com>
References: <cover.1439702894.git.raphael.beamonte@gmail.com>
In-Reply-To: <cover.1439702894.git.raphael.beamonte@gmail.com>
References: <cover.1439702894.git.raphael.beamonte@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Macros with multiple statements should be enclosed in a do - while loop

Signed-off-by: Raphaël Beamonte <raphael.beamonte@gmail.com>
---
 drivers/staging/wilc1000/wilc_exported_buf.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_exported_buf.c b/drivers/staging/wilc1000/wilc_exported_buf.c
index 5294578..45c2c7e 100644
--- a/drivers/staging/wilc1000/wilc_exported_buf.c
+++ b/drivers/staging/wilc1000/wilc_exported_buf.c
@@ -12,11 +12,13 @@
 	void *exported_ ## name = NULL;
 
 #define MALLOC_WILC_BUFFER(name, size)	\
-	exported_ ## name = kmalloc(size, GFP_KERNEL);	  \
-	if (!exported_ ## name) {   \
-		printk("fail to alloc: %s memory\n", exported_ ## name);  \
-		return -ENOBUFS;	\
-	}
+	do { \
+		exported_ ## name = kmalloc(size, GFP_KERNEL);	  \
+		if (!exported_ ## name) {   \
+			printk("fail to alloc: %s memory\n", exported_ ## name);  \
+			return -ENOBUFS;	\
+		}
+	} while (0)
 
 #define FREE_WILC_BUFFER(name)	\
 	kfree(exported_ ## name);
@@ -73,4 +75,4 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Tony Cho");
 MODULE_DESCRIPTION("WILC1xxx Memory Manager");
 pure_initcall(wilc_module_init);
-module_exit(wilc_module_deinit);
\ No newline at end of file
+module_exit(wilc_module_deinit);
-- 
2.1.4

