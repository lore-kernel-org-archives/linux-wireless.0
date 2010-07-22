Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64532 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758908Ab0GVIwg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 04:52:36 -0400
Date: Thu, 22 Jul 2010 10:52:02 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Bruno Randolf <br1@einfach.org>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	kernel-janitors@vger.kernel.org
Subject: [patch -next] ath5k: snprintf() returns largish values
Message-ID: <20100722085202.GV17585@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

snprintf() returns the number of characters that would have been written
(not counting the NUL character).  So we can't use it as the limiter to 
simple_read_from_buffer() without capping it first at sizeof(buf).

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index ebb9c23..4cccc29 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -239,6 +239,9 @@ static ssize_t read_file_beacon(struct file *file, char __user *user_buf,
 		"TSF\t\t0x%016llx\tTU: %08x\n",
 		(unsigned long long)tsf, TSF_TO_TU(tsf));
 
+	if (len > sizeof(buf))
+		len = sizeof(buf);
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -334,6 +337,9 @@ static ssize_t read_file_debug(struct file *file, char __user *user_buf,
 		sc->debug.level == dbg_info[i].level ? '+' : ' ',
 		dbg_info[i].level, dbg_info[i].desc);
 
+	if (len > sizeof(buf))
+		len = sizeof(buf);
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -433,6 +439,9 @@ static ssize_t read_file_antenna(struct file *file, char __user *user_buf,
 	len += snprintf(buf+len, sizeof(buf)-len,
 			"AR5K_PHY_ANT_SWITCH_TABLE_1\t0x%08x\n", v);
 
+	if (len > sizeof(buf))
+		len = sizeof(buf);
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -542,6 +551,9 @@ static ssize_t read_file_frameerrors(struct file *file, char __user *user_buf,
 	len += snprintf(buf+len, sizeof(buf)-len, "[TX all\t%d]\n",
 			st->tx_all_count);
 
+	if (len > sizeof(buf))
+		len = sizeof(buf);
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -681,6 +693,9 @@ static ssize_t read_file_ani(struct file *file, char __user *user_buf,
 			ATH5K_ANI_CCK_TRIG_HIGH - (ATH5K_PHYERR_CNT_MAX -
 			ath5k_hw_reg_read(sc->ah, AR5K_PHYERR_CNT2)));
 
+	if (len > sizeof(buf))
+		len = sizeof(buf);
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -766,6 +781,9 @@ static ssize_t read_file_queue(struct file *file, char __user *user_buf,
 		len += snprintf(buf+len, sizeof(buf)-len, "  len: %d\n", n);
 	}
 
+	if (len > sizeof(buf))
+		len = sizeof(buf);
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
