Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33488 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795AbbHQQIx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 12:08:53 -0400
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
Subject: [PATCH 2/5] staging: wilc1000: remove FREE_WILC_BUFFER()
Date: Mon, 17 Aug 2015 12:08:34 -0400
Message-Id: <da93f43d9e56eedb2afbf12387b782c4e686c7b7.1439827537.git.raphael.beamonte@gmail.com> (sfid-20150817_181053_201145_0966932F)
In-Reply-To: <cover.1439827537.git.raphael.beamonte@gmail.com>
References: <cover.1439827537.git.raphael.beamonte@gmail.com>
In-Reply-To: <cover.1439827537.git.raphael.beamonte@gmail.com>
References: <CAE_Gge0m4KRC7UJntqnsXPeO9HZ7dg9UexLAi__2EN+ouGGw9w@mail.gmail.com> <cover.1439827537.git.raphael.beamonte@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was just a wrapper around kfree(), so call that instead.

Signed-off-by: Raphaël Beamonte <raphael.beamonte@gmail.com>
---
 drivers/staging/wilc1000/wilc_exported_buf.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_exported_buf.c b/drivers/staging/wilc1000/wilc_exported_buf.c
index 985b0e1..bf392fb 100644
--- a/drivers/staging/wilc1000/wilc_exported_buf.c
+++ b/drivers/staging/wilc1000/wilc_exported_buf.c
@@ -15,9 +15,6 @@
 		return -ENOBUFS;	\
 	}
 
-#define FREE_WILC_BUFFER(name)	\
-	kfree(exported_ ## name);
-
 /*
  * Add necessary buffer pointers
  */
@@ -59,9 +56,15 @@ static int __init wilc_module_init(void)
 static void __exit wilc_module_deinit(void)
 {
 	printk("wilc_module_deinit\n");
-	FREE_WILC_BUFFER(g_tx_buf)
-	FREE_WILC_BUFFER(g_rx_buf)
-	FREE_WILC_BUFFER(g_fw_buf)
+
+	kfree(exported_g_tx_buf);
+	exported_g_tx_buf = NULL;
+
+	kfree(exported_g_rx_buf);
+	exported_g_rx_buf = NULL;
+
+	kfree(exported_g_fw_buf);
+	exported_g_fw_buf = NULL;
 
 	return;
 }
-- 
2.1.4

