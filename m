Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:47306 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbYBJPKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 10:10:38 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 02/12] Add at76_dbg_dump() macro
To: linux-wireless@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Date: Sun, 10 Feb 2008 17:00:04 +0200
Message-ID: <20080210150004.17592.32030.stgit@tikku> (sfid-20080210_151043_963046_C490518B)
In-Reply-To: <20080210145733.17592.61729.stgit@tikku>
References: <20080210145733.17592.61729.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/at76_usb.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 1f841bb..d2fe698 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -86,6 +86,14 @@
 		printk(KERN_DEBUG DRIVER_NAME ": " format "\n" , ## arg); \
 	} while (0)
 
+#define at76_dbg_dump(bits, buf, len, format, arg...)	\
+	do { \
+		if (at76_debug & (bits)) { \
+		printk(KERN_DEBUG DRIVER_NAME ": " format "\n" , ## arg); \
+		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, buf, len); \
+		}							\
+	} while (0)
+
 static int at76_debug = DBG_DEFAULTS;
 
 /* Protect against concurrent firmware loading and parsing */

