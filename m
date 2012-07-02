Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33578 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab2GBOWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 10:22:30 -0400
Received: by mail-ey0-f174.google.com with SMTP id k11so2110016eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jul 2012 07:22:29 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 3/5] compat: Define I2C_FUNC_NOSTART
Date: Mon,  2 Jul 2012 17:22:12 +0300
Message-Id: <1341238934-30855-3-git-send-email-ozancag@gmail.com> (sfid-20120702_162243_669813_368B8037)
In-Reply-To: <1341238934-30855-1-git-send-email-ozancag@gmail.com>
References: <1341238934-30855-1-git-send-email-ozancag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This backports:

 commit 14674e70119ea01549ce593d8901a797f8a90f74
 Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
 Date:   Wed May 30 10:55:34 2012 +0200

     i2c: Split I2C_M_NOSTART support out of I2C_FUNC_PROTOCOL_MANGLING

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 include/linux/compat-3.5.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/compat-3.5.h b/include/linux/compat-3.5.h
index 7855ac9..6bb450d 100644
--- a/include/linux/compat-3.5.h
+++ b/include/linux/compat-3.5.h
@@ -113,6 +113,17 @@ static inline int compat_vga_switcheroo_register_client(struct pci_dev *dev,
 
 #endif
 
+/* This backports
+ *
+ * commit 14674e70119ea01549ce593d8901a797f8a90f74
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ * Date:   Wed May 30 10:55:34 2012 +0200
+ *
+ *     i2c: Split I2C_M_NOSTART support out of I2C_FUNC_PROTOCOL_MANGLING
+ */
+
+#define I2C_FUNC_NOSTART 0x00000010 /* I2C_M_NOSTART */
+
 /*
  * This backports:
  *
-- 
1.7.10.4

