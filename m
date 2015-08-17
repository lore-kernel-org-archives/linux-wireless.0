Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:34664 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbbHQXMz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 19:12:55 -0400
From: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCHv3] staging: wilc1000: replace MALLOC_WILC_BUFFER() macro to avoid possible memory leak
Date: Mon, 17 Aug 2015 19:12:47 -0400
Message-Id: <ba3c67af8cbe5658154084a165785c637e5a2bc8.1439853139.git.raphael.beamonte@gmail.com> (sfid-20150818_011327_342765_2489121F)
In-Reply-To: <55D238D4.20800@broadcom.com>
References: <55D238D4.20800@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MALLOC_WILC_BUFFER() macro was using a return statement, and didn't
take care of possible memory leaks and subsequent bugs when it was failing
after succeeding some allocations. This patch corrects this behavior.

Signed-off-by: Raphaël Beamonte <raphael.beamonte@gmail.com>
---
 drivers/staging/wilc1000/wilc_exported_buf.c | 31 +++++++++++++++++++---------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_exported_buf.c b/drivers/staging/wilc1000/wilc_exported_buf.c
index c3f6a0a..ec8d8e5 100644
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
 #define FREE_WILC_BUFFER(name)	\
 	kfree(exported_ ## name);
 
@@ -49,11 +42,29 @@ static int __init wilc_module_init(void)
 	/*
 	 * alloc necessary memory
 	 */
-	MALLOC_WILC_BUFFER(g_tx_buf, LINUX_TX_SIZE)
-	MALLOC_WILC_BUFFER(g_rx_buf, LINUX_RX_SIZE)
-	MALLOC_WILC_BUFFER(g_fw_buf, WILC1000_FW_SIZE)
+	exported_g_tx_buf = kmalloc(LINUX_TX_SIZE, GFP_KERNEL);
+	if (!exported_g_tx_buf)
+		return -ENOMEM;
+
+	exported_g_rx_buf = kmalloc(LINUX_RX_SIZE, GFP_KERNEL);
+	if (!exported_g_rx_buf)
+		goto free_g_tx_buf;
+
+	exported_g_fw_buf = kmalloc(WILC1000_FW_SIZE, GFP_KERNEL);
+	if (!exported_g_fw_buf)
+		goto free_g_rx_buf;
 
 	return 0;
+
+free_g_rx_buf:
+	kfree(exported_g_rx_buf);
+	exported_g_rx_buf = NULL;
+
+free_g_tx_buf:
+	kfree(exported_g_tx_buf);
+	exported_g_tx_buf = NULL;
+
+	return -ENOMEM;
 }
 
 static void __exit wilc_module_deinit(void)
-- 
2.1.4

