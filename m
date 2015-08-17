Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36894 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbbHQQIv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 12:08:51 -0400
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
Subject: [PATCH 1/5] staging: wilc1000: remove DECLARE_WILC_BUFFER()
Date: Mon, 17 Aug 2015 12:08:33 -0400
Message-Id: <1236fc150aeaea845ffe8761fb3568beeba82964.1439827537.git.raphael.beamonte@gmail.com> (sfid-20150817_180855_780679_FEF69CBF)
In-Reply-To: <cover.1439827537.git.raphael.beamonte@gmail.com>
References: <cover.1439827537.git.raphael.beamonte@gmail.com>
In-Reply-To: <cover.1439827537.git.raphael.beamonte@gmail.com>
References: <CAE_Gge0m4KRC7UJntqnsXPeO9HZ7dg9UexLAi__2EN+ouGGw9w@mail.gmail.com> <cover.1439827537.git.raphael.beamonte@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was just a wrapper to initialize a variable. Initialize it
directly instead.

Signed-off-by: Raphaël Beamonte <raphael.beamonte@gmail.com>
---
 drivers/staging/wilc1000/wilc_exported_buf.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_exported_buf.c b/drivers/staging/wilc1000/wilc_exported_buf.c
index 5294578..985b0e1 100644
--- a/drivers/staging/wilc1000/wilc_exported_buf.c
+++ b/drivers/staging/wilc1000/wilc_exported_buf.c
@@ -8,9 +8,6 @@
 #define LINUX_TX_SIZE	(64 * 1024)
 #define WILC1000_FW_SIZE (4 * 1024)
 
-#define DECLARE_WILC_BUFFER(name)	\
-	void *exported_ ## name = NULL;
-
 #define MALLOC_WILC_BUFFER(name, size)	\
 	exported_ ## name = kmalloc(size, GFP_KERNEL);	  \
 	if (!exported_ ## name) {   \
@@ -24,9 +21,9 @@
 /*
  * Add necessary buffer pointers
  */
-DECLARE_WILC_BUFFER(g_tx_buf)
-DECLARE_WILC_BUFFER(g_rx_buf)
-DECLARE_WILC_BUFFER(g_fw_buf)
+void *exported_g_tx_buf;
+void *exported_g_rx_buf;
+void *exported_g_fw_buf;
 
 void *get_tx_buffer(void)
 {
@@ -73,4 +70,4 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Tony Cho");
 MODULE_DESCRIPTION("WILC1xxx Memory Manager");
 pure_initcall(wilc_module_init);
-module_exit(wilc_module_deinit);
\ No newline at end of file
+module_exit(wilc_module_deinit);
-- 
2.1.4

