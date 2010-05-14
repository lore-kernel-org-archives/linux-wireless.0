Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:61069 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab0ENNbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 09:31:49 -0400
Received: by wwi18 with SMTP id 18so531044wwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 06:31:48 -0700 (PDT)
Date: Fri, 14 May 2010 15:24:37 +0200
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
Subject: [patch -next 1/2] ath9k/debug: improve the snprintf() handling
Message-ID: <20100514132437.GG5695@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The snprintf() function returns the number of bytes that *would* have
been written (not counting the NULL terminator) and that can potentally
be more than the size of the buffer.

In this patch if there were one liners where string clearly fits into
the buffer, then I changed snprintf to sprintf().  It's confusing to use
the return value of snprintf() as a limitter without verifying that it's 
smaller than size.  This is what initially caught my attention here.
If we use the return value of sprintf() instead future code auditors will
assume we've verified that it fits already.

Also I did find some places where it made sense to use the return value 
after we've verified that it is smaller than the buffer size.

Finally the read_file_rcstat() function added an explicit NULL terminator
before calling snprintf().  That's unnecessary because snprintf() will 
add the null terminator automatically.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 2ca9bba..f344128 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -41,7 +41,7 @@ static ssize_t read_file_debug(struct file *file, char __user *user_buf,
 	char buf[32];
 	unsigned int len;
 
-	len = snprintf(buf, sizeof(buf), "0x%08x\n", common->debug_mask);
+	len = sprintf(buf, "0x%08x\n", common->debug_mask);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -85,7 +85,7 @@ static ssize_t read_file_tx_chainmask(struct file *file, char __user *user_buf,
 	char buf[32];
 	unsigned int len;
 
-	len = snprintf(buf, sizeof(buf), "0x%08x\n", common->tx_chainmask);
+	len = sprintf(buf, "0x%08x\n", common->tx_chainmask);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -127,7 +127,7 @@ static ssize_t read_file_rx_chainmask(struct file *file, char __user *user_buf,
 	char buf[32];
 	unsigned int len;
 
-	len = snprintf(buf, sizeof(buf), "0x%08x\n", common->rx_chainmask);
+	len = sprintf(buf, "0x%08x\n", common->rx_chainmask);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -247,6 +247,9 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 
 	ath9k_ps_restore(sc);
 
+	if (len > DMA_BUF_LEN)
+		len = DMA_BUF_LEN;
+
 	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
 	kfree(buf);
 	return retval;
@@ -357,6 +360,9 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
 	len += snprintf(buf + len, sizeof(buf) - len,
 		"%8s: %10u\n", "TOTAL", sc->debug.stats.istats.total);
 
+	if (len > sizeof(buf))
+		len = sizeof(buf);
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -396,11 +402,10 @@ static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 	if (sc->cur_rate_table == NULL)
 		return 0;
 
-	max = 80 + sc->cur_rate_table->rate_cnt * 1024;
-	buf = kmalloc(max + 1, GFP_KERNEL);
+	max = 80 + sc->cur_rate_table->rate_cnt * 1024 + 1;
+	buf = kmalloc(max, GFP_KERNEL);
 	if (buf == NULL)
 		return 0;
-	buf[max] = 0;
 
 	len += sprintf(buf, "%6s %6s %6s "
 		       "%10s %10s %10s %10s\n",
@@ -442,6 +447,9 @@ static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 			stats->per);
 	}
 
+	if (len > max)
+		len = max;
+
 	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
 	kfree(buf);
 	return retval;
@@ -504,6 +512,9 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"addrmask: %pM\n", addr);
 
+	if (len > sizeof(buf))
+		len = sizeof(buf);
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -647,6 +658,9 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	PR("DATA Underrun:   ", data_underrun);
 	PR("DELIM Underrun:  ", delim_underrun);
 
+	if (len > size)
+		len = size;
+
 	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
 	kfree(buf);
 
@@ -750,6 +764,9 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 	PHY_ERR("HT-LENGTH", ATH9K_PHYERR_HT_LENGTH_ILLEGAL);
 	PHY_ERR("HT-RATE", ATH9K_PHYERR_HT_RATE_ILLEGAL);
 
+	if (len > size)
+		len = size;
+
 	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
 	kfree(buf);
 
@@ -801,7 +818,7 @@ static ssize_t read_file_regidx(struct file *file, char __user *user_buf,
 	char buf[32];
 	unsigned int len;
 
-	len = snprintf(buf, sizeof(buf), "0x%08x\n", sc->debug.regidx);
+	len = sprintf(buf, "0x%08x\n", sc->debug.regidx);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -842,7 +859,7 @@ static ssize_t read_file_regval(struct file *file, char __user *user_buf,
 	u32 regval;
 
 	regval = REG_READ_D(ah, sc->debug.regidx);
-	len = snprintf(buf, sizeof(buf), "0x%08x\n", regval);
+	len = sprintf(buf, "0x%08x\n", regval);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
