Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:35581 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbbHQQIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 12:08:54 -0400
From: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 3/5] staging: wilc1000: replace MALLOC_WILC_BUFFER() macro to avoid possible memory leak
Date: Mon, 17 Aug 2015 12:08:35 -0400
Message-Id: <c8b8d96496a5502d6f02ff53f319f16bc612ff30.1439827537.git.raphael.beamonte@gmail.com> (sfid-20150817_180937_125214_5DF33E33)
In-Reply-To: <cover.1439827537.git.raphael.beamonte@gmail.com>
References: <cover.1439827537.git.raphael.beamonte@gmail.com>
In-Reply-To: <cover.1439827537.git.raphael.beamonte@gmail.com>
References: <CAE_Gge0m4KRC7UJntqnsXPeO9HZ7dg9UexLAi__2EN+ouGGw9w@mail.gmail.com> <cover.1439827537.git.raphael.beamonte@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MACRO_WILC_BUFFER() macro was using a return statement, and didn't
take care of possible memory leaks and subsequent bugs when it was failing
after succeeding some allocations. This patch corrects this behavior.

Signed-off-by: Raphaël Beamonte <raphael.beamonte@gmail.com>
---
 drivers/staging/wilc1000/wilc_exported_buf.c | 39 +++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_exported_buf.c b/drivers/staging/wilc1000/wilc_exported_buf.c
index bf392fb..c3aff9a 100644
--- a/drivers/staging/wilc1000/wilc_exported_buf.c
+++ b/drivers/staging/wilc1000/wilc_exported_buf.c
@@ -8,13 +8,6 @@
 #define LINUX_TX_SIZE	(64 * 1024)
 #define WILC1000_FW_SIZE (4 * 1024)
 
-#define MALLOC_WILC_BUFFER(name, size)	\
-	exported_ ## name = kmalloc(size, GFP_KERNEL);	  \
-	if (!exported_ ## name) {   \
-		printk("fail to alloc: %s memory\n", exported_ ## name);  \
-		return -ENOBUFS;	\
-	}
-
 /*
  * Add necessary buffer pointers
  */
@@ -40,17 +33,43 @@ void *get_fw_buffer(void)
 }
 EXPORT_SYMBOL(get_fw_buffer);
 
+static inline int kmalloc_wilc_buffer(void *buf, int size)
+{
+	buf = kmalloc(size, GFP_KERNEL);
+	if (!buf) {
+		printk("fail to alloc memory\n");
+		return -ENOBUFS;
+	}
+	return 0;
+}
+
 static int __init wilc_module_init(void)
 {
 	printk("wilc_module_init\n");
 	/*
 	 * alloc necessary memory
 	 */
-	MALLOC_WILC_BUFFER(g_tx_buf, LINUX_TX_SIZE)
-	MALLOC_WILC_BUFFER(g_rx_buf, LINUX_RX_SIZE)
-	MALLOC_WILC_BUFFER(g_fw_buf, WILC1000_FW_SIZE)
+	if (kmalloc_wilc_buffer(exported_g_tx_buf, LINUX_TX_SIZE))
+		goto error_g_tx_buf;
+
+	if (kmalloc_wilc_buffer(exported_g_rx_buf, LINUX_RX_SIZE))
+		goto error_g_rx_buf;
+
+	if (kmalloc_wilc_buffer(exported_g_fw_buf, WILC1000_FW_SIZE))
+		goto error_g_fw_buf;
 
 	return 0;
+
+error_g_fw_buf:
+	kfree(exported_g_rx_buf);
+	exported_g_rx_buf = NULL;
+
+error_g_rx_buf:
+	kfree(exported_g_tx_buf);
+	exported_g_tx_buf = NULL;
+
+error_g_tx_buf:
+	return -ENOBUFS;
 }
 
 static void __exit wilc_module_deinit(void)
-- 
2.1.4

