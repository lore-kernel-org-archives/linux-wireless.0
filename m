Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50451 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab0EONhG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 May 2010 09:37:06 -0400
Received: by fxm6 with SMTP id 6so2348414fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 May 2010 06:37:05 -0700 (PDT)
Date: Sat, 15 May 2010 15:36:16 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Jeff Hansen <x@jeffhansen.com>, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Subject: [patch -next 2/2 v2] ath9k/debug: fixup the return codes
Message-ID: <20100515133616.GC5381@bicker>
References: <20100514132539.GH5695@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100514132539.GH5695@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changed -EINVAL to -EFAULT if copy_to_user() failed.
Changed 0 to -ENOMEM if allocations failed.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
V2:  No change.  Just updated to apply on top of V2 of the earlier patch

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index fad1c85..3ff6a52 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -56,7 +56,7 @@ static ssize_t write_file_debug(struct file *file, const char __user *user_buf,
 
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
-		return -EINVAL;
+		return -EFAULT;
 
 	buf[len] = '\0';
 	if (strict_strtoul(buf, 0, &mask))
@@ -100,7 +100,7 @@ static ssize_t write_file_tx_chainmask(struct file *file, const char __user *use
 
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
-		return -EINVAL;
+		return -EFAULT;
 
 	buf[len] = '\0';
 	if (strict_strtoul(buf, 0, &mask))
@@ -142,7 +142,7 @@ static ssize_t write_file_rx_chainmask(struct file *file, const char __user *use
 
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
-		return -EINVAL;
+		return -EFAULT;
 
 	buf[len] = '\0';
 	if (strict_strtoul(buf, 0, &mask))
@@ -175,7 +175,7 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 
 	buf = kmalloc(DMA_BUF_LEN, GFP_KERNEL);
 	if (!buf)
-		return 0;
+		return -ENOMEM;
 
 	ath9k_ps_wakeup(sc);
 
@@ -407,7 +407,7 @@ static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 	max = 80 + sc->cur_rate_table->rate_cnt * 1024 + 1;
 	buf = kmalloc(max, GFP_KERNEL);
 	if (buf == NULL)
-		return 0;
+		return -ENOMEM;
 
 	len += sprintf(buf, "%6s %6s %6s "
 		       "%10s %10s %10s %10s\n",
@@ -644,7 +644,7 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 
 	buf = kzalloc(size, GFP_KERNEL);
 	if (buf == NULL)
-		return 0;
+		return -ENOMEM;
 
 	len += sprintf(buf, "%30s %10s%10s%10s\n\n", "BE", "BK", "VI", "VO");
 
@@ -718,7 +718,7 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 
 	buf = kzalloc(size, GFP_KERNEL);
 	if (buf == NULL)
-		return 0;
+		return -ENOMEM;
 
 	len += snprintf(buf + len, size - len,
 			"%18s : %10u\n", "CRC ERR",
@@ -838,7 +838,7 @@ static ssize_t write_file_regidx(struct file *file, const char __user *user_buf,
 
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
-		return -EINVAL;
+		return -EFAULT;
 
 	buf[len] = '\0';
 	if (strict_strtoul(buf, 0, &regidx))
@@ -880,7 +880,7 @@ static ssize_t write_file_regval(struct file *file, const char __user *user_buf,
 
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
-		return -EINVAL;
+		return -EFAULT;
 
 	buf[len] = '\0';
 	if (strict_strtoul(buf, 0, &regval))
