Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40209 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab3LNM1W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Dec 2013 07:27:22 -0500
Date: Sat, 14 Dec 2013 17:57:14 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	josh@joshtriplett.org
Subject: [PATCH v2 6/9] drivers: net: Mark functions as static in 3945-debug.c
Message-ID: <c57bc0a7337568ce09127f380c50e829a89d82ea.1386911124.git.rashika.kheria@gmail.com> (sfid-20131214_132742_758719_D576F18F)
References: <a610f6ee6bb992b91e43bdc851f3db62fc3decd5.1386911123.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <a610f6ee6bb992b91e43bdc851f3db62fc3decd5.1386911123.git.rashika.kheria@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch marks the function il3945_ucode_rx_stats_read(),
il3945_ucode_tx_stats_read() and il3945_ucode_general_stats_read() in
3945-debug.c as static because they are not used outside this file.

Thus, it also removes the following warnings in
wireless/iwlegacy/3945-debug.c:

drivers/net/wireless/iwlegacy/3945-debug.c:52:1: warning: no previous prototype for ‘il3945_ucode_rx_stats_read’ [-Wmissing-prototypes]
drivers/net/wireless/iwlegacy/3945-debug.c:317:1: warning: no previous prototype for ‘il3945_ucode_tx_stats_read’ [-Wmissing-prototypes]
drivers/net/wireless/iwlegacy/3945-debug.c:407:1: warning: no previous prototype for ‘il3945_ucode_general_stats_read’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/net/wireless/iwlegacy/3945-debug.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-debug.c b/drivers/net/wireless/iwlegacy/3945-debug.c
index f767dd1..c1b4441 100644
--- a/drivers/net/wireless/iwlegacy/3945-debug.c
+++ b/drivers/net/wireless/iwlegacy/3945-debug.c
@@ -48,7 +48,7 @@ il3945_stats_flag(struct il_priv *il, char *buf, int bufsz)
 	return p;
 }
 
-ssize_t
+static ssize_t
 il3945_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
@@ -313,7 +313,7 @@ il3945_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 	return ret;
 }
 
-ssize_t
+static ssize_t
 il3945_ucode_tx_stats_read(struct file *file, char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
@@ -403,7 +403,7 @@ il3945_ucode_tx_stats_read(struct file *file, char __user *user_buf,
 	return ret;
 }
 
-ssize_t
+static ssize_t
 il3945_ucode_general_stats_read(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
-- 
1.7.9.5

