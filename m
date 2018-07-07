Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49034 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753854AbeGGPfN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Jul 2018 11:35:13 -0400
To: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] net/wireless/intersil/hostap: fix defined but not used
 warnings
Message-ID: <b2a357a4-dfae-5561-deda-33b2124fc4cf@infradead.org> (sfid-20180707_173525_888000_C5DAC872)
Date: Sat, 7 Jul 2018 08:35:11 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Fix build warnings in drivers/net/wireless/intersil/hostap/ when
CONFIG_PROC_FS is not enabled by marking the unused functions as
__maybe_unused.

../drivers/net/wireless/intersil/hostap/hostap_ap.c:70:12: warning: 'ap_debug_proc_show' defined but not used [-Wunused-function]
../drivers/net/wireless/intersil/hostap/hostap_ap.c:994:12: warning: 'prism2_sta_proc_show' defined but not used [-Wunused-function]
../drivers/net/wireless/intersil/hostap/hostap_proc.c:16:12: warning: 'prism2_debug_proc_show' defined but not used [-Wunused-function]
../drivers/net/wireless/intersil/hostap/hostap_proc.c:49:12: warning: 'prism2_stats_proc_show' defined but not used [-Wunused-function]
../drivers/net/wireless/intersil/hostap/hostap_proc.c:177:12: warning: 'prism2_crypt_proc_show' defined but not used [-Wunused-function]
../drivers/net/wireless/intersil/hostap/hostap_hw.c:2901:12: warning: 'prism2_registers_proc_show' defined but not used [-Wunused-function]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/intersil/hostap/hostap_ap.c   |    5 +++--
 drivers/net/wireless/intersil/hostap/hostap_hw.c   |    3 ++-
 drivers/net/wireless/intersil/hostap/hostap_proc.c |    7 ++++---
 3 files changed, 9 insertions(+), 6 deletions(-)

--- linux-next-20180706.orig/drivers/net/wireless/intersil/hostap/hostap_ap.c
+++ linux-next-20180706/drivers/net/wireless/intersil/hostap/hostap_ap.c
@@ -17,6 +17,7 @@
  *   (8802.11: 5.5)
  */
 
+#include <linux/compiler.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/delay.h>
@@ -67,7 +68,7 @@ static void prism2_send_mgmt(struct net_
 
 
 #ifndef PRISM2_NO_PROCFS_DEBUG
-static int ap_debug_proc_show(struct seq_file *m, void *v)
+static int __maybe_unused ap_debug_proc_show(struct seq_file *m, void *v)
 {
 	struct ap_data *ap = PDE_DATA(file_inode(m->file));
 
@@ -991,7 +992,7 @@ static void prism2_send_mgmt(struct net_
 #endif /* PRISM2_NO_KERNEL_IEEE80211_MGMT */
 
 
-static int prism2_sta_proc_show(struct seq_file *m, void *v)
+static int __maybe_unused prism2_sta_proc_show(struct seq_file *m, void *v)
 {
 	struct sta_info *sta = m->private;
 	int i;
--- linux-next-20180706.orig/drivers/net/wireless/intersil/hostap/hostap_proc.c
+++ linux-next-20180706/drivers/net/wireless/intersil/hostap/hostap_proc.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* /proc routines for Host AP driver */
 
+#include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/proc_fs.h>
 #include <linux/export.h>
@@ -13,7 +14,7 @@
 
 
 #ifndef PRISM2_NO_PROCFS_DEBUG
-static int prism2_debug_proc_show(struct seq_file *m, void *v)
+static int __maybe_unused prism2_debug_proc_show(struct seq_file *m, void *v)
 {
 	local_info_t *local = m->private;
 	int i;
@@ -46,7 +47,7 @@ static int prism2_debug_proc_show(struct
 #endif /* PRISM2_NO_PROCFS_DEBUG */
 
 
-static int prism2_stats_proc_show(struct seq_file *m, void *v)
+static int __maybe_unused prism2_stats_proc_show(struct seq_file *m, void *v)
 {
 	local_info_t *local = m->private;
 	struct comm_tallies_sums *sums = &local->comm_tallies;
@@ -174,7 +175,7 @@ static const struct seq_operations prism
 	.show	= prism2_bss_list_proc_show,
 };
 
-static int prism2_crypt_proc_show(struct seq_file *m, void *v)
+static int __maybe_unused prism2_crypt_proc_show(struct seq_file *m, void *v)
 {
 	local_info_t *local = m->private;
 	int i;
--- linux-next-20180706.orig/drivers/net/wireless/intersil/hostap/hostap_hw.c
+++ linux-next-20180706/drivers/net/wireless/intersil/hostap/hostap_hw.c
@@ -32,6 +32,7 @@
 
 
 #include <asm/delay.h>
+#include <linux/compiler.h>
 #include <linux/uaccess.h>
 
 #include <linux/slab.h>
@@ -2898,7 +2899,7 @@ static void hostap_tick_timer(struct tim
 
 
 #ifndef PRISM2_NO_PROCFS_DEBUG
-static int prism2_registers_proc_show(struct seq_file *m, void *v)
+static int __maybe_unused prism2_registers_proc_show(struct seq_file *m, void *v)
 {
 	local_info_t *local = m->private;
 
