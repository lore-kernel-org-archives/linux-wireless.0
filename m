Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbXEKDEm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 23:04:42 -0400
Subject: [PATCH 16/19] libertas: made debugfs.c sparse-clean, found an  unused function that way
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178829040.6356.1.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 23:08:05 -0400
Message-Id: <1178852885.8607.48.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Subject says it all.
    
Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
Acked-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/debugfs.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 51dfd20..61cbd47 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -7,6 +7,7 @@
 #include "dev.h"
 #include "decl.h"
 #include "host.h"
+#include "debugfs.h"
 
 static struct dentry *libertas_dir = NULL;
 static char *szStates[] = {
@@ -1648,7 +1649,7 @@ struct libertas_debugfs_files {
 	struct file_operations fops;
 };
 
-struct libertas_debugfs_files debugfs_files[] = {
+static struct libertas_debugfs_files debugfs_files[] = {
 	{ "info", 0444, FOPS(libertas_dev_info, write_file_dummy), },
 	{ "getscantable", 0444, FOPS(libertas_getscantable,
 					write_file_dummy), },
@@ -1658,7 +1659,7 @@ struct libertas_debugfs_files debugfs_files[] = {
 	{ "setuserscan", 0600, FOPS(NULL, libertas_setuserscan), },
 };
 
-struct libertas_debugfs_files debugfs_events_files[] = {
+static struct libertas_debugfs_files debugfs_events_files[] = {
 	{"low_rssi", 0644, FOPS(libertas_lowrssi_read,
 				libertas_lowrssi_write), },
 	{"low_snr", 0644, FOPS(libertas_lowsnr_read,
@@ -1673,7 +1674,7 @@ struct libertas_debugfs_files debugfs_events_files[] = {
 				libertas_highsnr_write), },
 };
 
-struct libertas_debugfs_files debugfs_regs_files[] = {
+static struct libertas_debugfs_files debugfs_regs_files[] = {
 	{"rdmac", 0644, FOPS(libertas_rdmac_read, libertas_rdmac_write), },
 	{"wrmac", 0600, FOPS(NULL, libertas_wrmac_write), },
 	{"rdbbp", 0644, FOPS(libertas_rdbbp_read, libertas_rdbbp_write), },
@@ -1923,13 +1924,3 @@ void libertas_debug_init(wlan_private * priv, struct net_device *dev)
 						  &libertas_debug_fops);
 }
 
-/**
- *  @brief remove proc file
- *
- *  @param priv	   pointer wlan_private
- *  @return 	   N/A
- */
-void libertas_debug_remove(wlan_private * priv)
-{
-	debugfs_remove(priv->debugfs_debug);
-}
-- 
1.5.0.6



