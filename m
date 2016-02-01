Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36334 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbcBAM1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 07:27:13 -0500
Received: by mail-pf0-f193.google.com with SMTP id n128so7472373pfn.3
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2016 04:27:13 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/11] staging: wilc1000: linux_mon: fix NULL comparison style
Date: Mon,  1 Feb 2016 21:26:41 +0900
Message-Id: <1454329607-9486-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20160201_132718_043553_3C10FE6E)
In-Reply-To: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com>
References: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes NULL comparsion style found by checkpatch.pl

CHECK: Comparison to NULL could be written "!wilc_wfi_mon"
CHECK: Comparison to NULL could be written "!skb"
CHECK: Comparison to NULL could be written "!skb"
CHECK: Comparison to NULL could be written "!dev"
CHECK: Comparison to NULL could be written "!mgmt_tx"
CHECK: Comparison to NULL could be written "!mgmt_tx->buff"
CHECK: Comparison to NULL could be written "!wilc_wfi_mon"
CHECK: Comparison to NULL could be written "!mon_priv"
CHECK: Comparison to NULL could be written "!priv"
CHECK: Comparison to NULL could be written "wilc_wfi_mon"

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_mon.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 398fdea..7b9cc02 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -54,7 +54,7 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 
 	PRINT_INFO(HOSTAPD_DBG, "In monitor interface receive function\n");
 
-	if (wilc_wfi_mon == NULL)
+	if (!wilc_wfi_mon)
 		return;
 
 	if (!netif_running(wilc_wfi_mon)) {
@@ -73,7 +73,7 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 		/* hostapd callback mgmt frame */
 
 		skb = dev_alloc_skb(size + sizeof(struct wilc_wfi_radiotap_cb_hdr));
-		if (skb == NULL) {
+		if (!skb) {
 			PRINT_INFO(HOSTAPD_DBG, "Monitor if : No memory to allocate skb");
 			return;
 		}
@@ -103,7 +103,7 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 	} else {
 		skb = dev_alloc_skb(size + sizeof(struct wilc_wfi_radiotap_hdr));
 
-		if (skb == NULL) {
+		if (!skb) {
 			PRINT_INFO(HOSTAPD_DBG, "Monitor if : No memory to allocate skb");
 			return;
 		}
@@ -156,20 +156,20 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 {
 	struct tx_complete_mon_data *mgmt_tx = NULL;
 
-	if (dev == NULL) {
+	if (!dev) {
 		PRINT_D(HOSTAPD_DBG, "ERROR: dev == NULL\n");
 		return -EFAULT;
 	}
 
 	netif_stop_queue(dev);
 	mgmt_tx = kmalloc(sizeof(struct tx_complete_mon_data), GFP_ATOMIC);
-	if (mgmt_tx == NULL) {
+	if (!mgmt_tx) {
 		PRINT_ER("Failed to allocate memory for mgmt_tx structure\n");
 		return -EFAULT;
 	}
 
 	mgmt_tx->buff = kmalloc(len, GFP_ATOMIC);
-	if (mgmt_tx->buff == NULL) {
+	if (!mgmt_tx->buff) {
 		PRINT_ER("Failed to allocate memory for mgmt_tx buff\n");
 		kfree(mgmt_tx);
 		return -EFAULT;
@@ -203,12 +203,12 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 	struct sk_buff *skb2;
 	struct wilc_wfi_radiotap_cb_hdr *cb_hdr;
 
-	if (wilc_wfi_mon == NULL)
+	if (!wilc_wfi_mon)
 		return -EFAULT;
 
 	mon_priv = netdev_priv(wilc_wfi_mon);
 
-	if (mon_priv == NULL) {
+	if (!mon_priv) {
 		PRINT_ER("Monitor interface private structure is NULL\n");
 		return -EFAULT;
 	}
@@ -324,7 +324,7 @@ struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_devi
 		return NULL;
 	}
 	priv = netdev_priv(wilc_wfi_mon);
-	if (priv == NULL) {
+	if (!priv) {
 		PRINT_ER("private structure is NULL\n");
 		return NULL;
 	}
@@ -347,7 +347,7 @@ int WILC_WFI_deinit_mon_interface(void)
 {
 	bool rollback_lock = false;
 
-	if (wilc_wfi_mon != NULL) {
+	if (wilc_wfi_mon) {
 		PRINT_D(HOSTAPD_DBG, "In Deinit monitor interface\n");
 		PRINT_D(HOSTAPD_DBG, "RTNL is being locked\n");
 		if (rtnl_is_locked()) {
-- 
2.7.0

