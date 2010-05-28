Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:44946 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894Ab0E1LBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 07:01:10 -0400
Received: by ewy8 with SMTP id 8so290887ewy.28
        for <linux-wireless@vger.kernel.org>; Fri, 28 May 2010 04:01:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1275025163.2091.20502.camel@rchatre-DESK>
References: <AANLkTikB8WaMyIj6CTY5wfEeVDratQ1Y8W3B_JBVllBp@mail.gmail.com>
	<1274465242.12391.0.camel@abhi-desktop>
	<AANLkTilnK6lkypJkajiwUbhl6JlNR7S8dL6YzKUe2yd3@mail.gmail.com>
	<1274740231.2091.15472.camel@rchatre-DESK>
	<AANLkTilfa4YPPiroX5yfJ2BNRUVZH6imTvG4I8ukGjBC@mail.gmail.com>
	<1275025163.2091.20502.camel@rchatre-DESK>
Date: Fri, 28 May 2010 13:01:08 +0200
Message-ID: <AANLkTim86ILiQu0BNzUAkUV6lg1-mXt5UBJ0C9gGcgaI@mail.gmail.com>
Subject: Re: Iwlwifi and LEDS?
From: Gregy <p.gregy@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> If you want to be able to manipulate the LED in other ways than the
> driver supports you could look into adding a debugfs file that
> manipulates the driver's led variables (allow_blinking,
> last_blink_time, ...). There is already a readable led file in debugfs,
> but not writable.
>
> Reinette

Ok, I have tried that with partial success. It allows me to change led
status "mid-flight" but if led is blinking it sometimes works only
after second try. Also my understanding of C and kernel programming is
very limited so I probably made some mistakes. Could you please look
at it?

Thank you.

--- iwl-debugfs.c.old	2010-05-14 15:20:16.000000000 +0200
+++ iwl-debugfs.c	2010-05-28 12:37:47.706991952 +0200
@@ -40,6 +40,7 @@
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-calib.h"
+#include "iwl-agn-led.c"

 /* create and remove of files */
 #define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
@@ -702,6 +703,34 @@
 	return ret;
 }

+static ssize_t iwl_dbgfs_ledw_write(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	
+	struct iwl_priv *priv = file->private_data;
+	char buf[8];
+	int buf_size;
+	int status;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%d", &status) != 1)
+		return -EFAULT;
+	
+	priv->last_blink_time = 0;
+	priv->allow_blinking = 0;  // i set the mode manually -> stop
blinking (doesn't work very well)
+	
+	if(status == 0)
+		iwl_led_off_reg(priv);
+	else
+		iwl_led_on_reg(priv);
+
+	return count;
+}
+
 static ssize_t iwl_dbgfs_thermal_throttling_read(struct file *file,
 				char __user *user_buf,
 				size_t count, loff_t *ppos)
@@ -872,6 +901,7 @@
 DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
 DEBUGFS_READ_FILE_OPS(qos);
 DEBUGFS_READ_FILE_OPS(led);
+DEBUGFS_WRITE_FILE_OPS(ledw);
 DEBUGFS_READ_FILE_OPS(thermal_throttling);
 DEBUGFS_READ_WRITE_FILE_OPS(disable_ht40);
 DEBUGFS_READ_WRITE_FILE_OPS(sleep_level_override);
@@ -2334,6 +2364,7 @@
 	DEBUGFS_ADD_FILE(interrupt, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(qos, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(led, dir_data, S_IRUSR);
+	DEBUGFS_ADD_FILE(ledw, dir_data, S_IWUSR);
 	DEBUGFS_ADD_FILE(sleep_level_override, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(current_sleep_command, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(thermal_throttling, dir_data, S_IRUSR);
