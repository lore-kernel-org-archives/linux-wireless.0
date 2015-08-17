Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:38624 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbbHQT2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 15:28:48 -0400
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
Subject: [PATCHv2 4/5] staging: wilc1000: remove FREE_WILC_BUFFER()
Date: Mon, 17 Aug 2015 15:28:29 -0400
Message-Id: <1ed2c34e8fde92cd4813ae549ba0a0a3fd92afd0.1439838526.git.raphael.beamonte@gmail.com> (sfid-20150817_212931_852574_53F65226)
In-Reply-To: <cover.1439838526.git.raphael.beamonte@gmail.com>
References: <cover.1439838526.git.raphael.beamonte@gmail.com>
In-Reply-To: <cover.1439838526.git.raphael.beamonte@gmail.com>
References: <cover.1439838526.git.raphael.beamonte@gmail.com>
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
index 148d608..c9a5943 100644
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
@@ -57,9 +54,9 @@ static int __init wilc_module_init(void)
 
 static void __exit wilc_module_deinit(void)
 {
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

