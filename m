Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38847 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab0GVIvP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 04:51:15 -0400
Date: Thu, 22 Jul 2010 10:50:28 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Vivek Natarajan <vnatarajan@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kernel-janitors@vger.kernel.org
Subject: [patch -next] ath9k: snprintf() returns largish values
Message-ID: <20100722085027.GU17585@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The snprintf() function returns the number of characters that would have
been written (not counting the NUL character on the end).  It could
potentially be larger than the size of the buffer.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 3243877..cf9bcc6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -524,6 +524,9 @@ static ssize_t read_file_tgt_stats(struct file *file, char __user *user_buf,
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"%19s : %10u\n", "TX Rate", priv->debug.txrate);
 
+	if (len > sizeof(buf))
+		len = sizeof(buf);
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -569,6 +572,9 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 			"%20s : %10u\n", "VO queued",
 			priv->debug.tx_stats.queue_stats[WME_AC_VO]);
 
+	if (len > sizeof(buf))
+		len = sizeof(buf);
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -595,6 +601,9 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 			"%20s : %10u\n", "SKBs Dropped",
 			priv->debug.rx_stats.skb_dropped);
 
+	if (len > sizeof(buf))
+		len = sizeof(buf);
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
