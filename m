Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:60290 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3LSIyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 03:54:16 -0500
From: Rashika Kheria <rashika.kheria@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, josh@joshtriplett.org
Subject: =?UTF-8?q?=5BPATCH=20v3=205/8=5D=20drivers=3A=20net=3A=20Mark=20functions=20as=20static=20in=203945-debug=2Ec?=
Date: Thu, 19 Dec 2013 14:23:49 +0530
Message-Id: <f6dd170a28455058d1d236425150d40baa3df0b3.1387382457.git.rashika.kheria@gmail.com> (sfid-20131219_095429_562322_230C2AEF)
In-Reply-To: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
References: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

