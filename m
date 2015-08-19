Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33306 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbbHSDPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 23:15:17 -0400
From: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCHv4 1/2] staging: wilc1000: remove FREE_WILC_BUFFER()
Date: Tue, 18 Aug 2015 23:14:49 -0400
Message-Id: <98b8f344a4c610b9273a0c753a1ec470dee10153.1439953865.git.raphael.beamonte@gmail.com> (sfid-20150819_051538_678373_B6334DFF)
In-Reply-To: <cover.1439953865.git.raphael.beamonte@gmail.com>
References: <cover.1439953865.git.raphael.beamonte@gmail.com>
In-Reply-To: <cover.1439953865.git.raphael.beamonte@gmail.com>
References: <20150819025942.GD4588@kroah.com> <cover.1439953865.git.raphael.beamonte@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was just a wrapper around kfree(), so call that instead.

Signed-off-by: Raphaël Beamonte <raphael.beamonte@gmail.com>
---
 drivers/staging/wilc1000/wilc_exported_buf.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_exported_buf.c b/drivers/staging/wilc1000/wilc_exported_buf.c
index c3f6a0a..44db496 100644
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
@@ -59,9 +56,9 @@ static int __init wilc_module_init(void)
 static void __exit wilc_module_deinit(void)
 {
 	printk("wilc_module_deinit\n");
-	FREE_WILC_BUFFER(g_tx_buf)
-	FREE_WILC_BUFFER(g_rx_buf)
-	FREE_WILC_BUFFER(g_fw_buf)
+	kfree(exported_g_tx_buf);
+	kfree(exported_g_rx_buf);
+	kfree(exported_g_fw_buf);
 }
 
 MODULE_LICENSE("Dual BSD/GPL");
-- 
2.1.4

