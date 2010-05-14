Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58193 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006Ab0ENN00 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 09:26:26 -0400
Received: by wyb36 with SMTP id 36so20668wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 06:26:19 -0700 (PDT)
Date: Fri, 14 May 2010 15:25:39 +0200
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
Subject: [patch -next 2/2] ath9k/debug: fixup the return codes
Message-ID: <20100514132539.GH5695@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changed -EINVAL to -EFAULT if copy_to_user() failed.
Changed 0 to -ENOMEM if allocations failed.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index f344128..3123d16 100644
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
 
@@ -405,7 +405,7 @@ static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 	max = 80 + sc->cur_rate_table->rate_cnt * 1024 + 1;
 	buf = kmalloc(max, GFP_KERNEL);
 	if (buf == NULL)
-		return 0;
+		return -ENOMEM;
 
 	len += sprintf(buf, "%6s %6s %6s "
 		       "%10s %10s %10s %10s\n",
@@ -640,7 +640,7 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 
 	buf = kzalloc(size, GFP_KERNEL);
 	if (buf == NULL)
-		return 0;
+		return -ENOMEM;
 
 	len += sprintf(buf, "%30s %10s%10s%10s\n\n", "BE", "BK", "VI", "VO");
 
@@ -713,7 +713,7 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 
 	buf = kzalloc(size, GFP_KERNEL);
 	if (buf == NULL)
-		return 0;
+		return -ENOMEM;
 
 	len += snprintf(buf + len, size - len,
 			"%18s : %10u\n", "CRC ERR",
@@ -832,7 +832,7 @@ static ssize_t write_file_regidx(struct file *file, const char __user *user_buf,
 
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
-		return -EINVAL;
+		return -EFAULT;
 
 	buf[len] = '\0';
 	if (strict_strtoul(buf, 0, &regidx))
@@ -874,7 +874,7 @@ static ssize_t write_file_regval(struct file *file, const char __user *user_buf,
 
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
-		return -EINVAL;
+		return -EFAULT;
 
 	buf[len] = '\0';
 	if (strict_strtoul(buf, 0, &regval))
