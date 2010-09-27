Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:16883 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816Ab0I0IiL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:38:11 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8biW2024345
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 03:38:10 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 08/25] wl1271: Remove outdated FIXME's
Date: Mon, 27 Sep 2010 11:37:32 +0300
Message-Id: <1285576669-8070-9-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Remove outdated FIXME's from the code.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c |   17 +++++------------
 drivers/net/wireless/wl12xx/wl1271_main.c |    7 ++-----
 drivers/net/wireless/wl12xx/wl1271_tx.c   |    2 --
 3 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index e5a7f04..f750d5a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -251,8 +251,10 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 		burst_len = nvs_ptr[0];
 		dest_addr = (nvs_ptr[1] & 0xfe) | ((u32)(nvs_ptr[2] << 8));
 
-		/* FIXME: Due to our new wl1271_translate_reg_addr function,
-		   we need to add the REGISTER_BASE to the destination */
+		/*
+		 * Due to our new wl1271_translate_reg_addr function,
+		 * we need to add the REGISTER_BASE to the destination
+		 */
 		dest_addr += REGISTERS_BASE;
 
 		/* We move our pointer to the data */
@@ -280,8 +282,6 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 			ALIGN(nvs_ptr - (u8 *)wl->nvs->nvs + 7, 4);
 	nvs_len -= nvs_ptr - (u8 *)wl->nvs->nvs;
 
-	/* FIXME: The driver sets the partition here, but this is not needed,
-	   since it sets to the same one as currently in use */
 	/* Now we must set the partition correctly */
 	wl1271_set_partition(wl, &part_table[PART_WORK]);
 
@@ -291,9 +291,6 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 		return -ENOMEM;
 
 	/* And finally we upload the NVS tables */
-	/* FIXME: In wl1271, we upload everything at once.
-	   No endianness handling needed here?! The ref driver doesn't do
-	   anything about it at this point */
 	wl1271_write(wl, CMD_MBOX_ADDRESS, nvs_aligned, nvs_len, false);
 
 	kfree(nvs_aligned);
@@ -491,10 +488,7 @@ int wl1271_boot(struct wl1271 *wl)
 
 	wl1271_debug(DEBUG_BOOT, "pause1 0x%x", pause);
 
-	pause &= ~(WU_COUNTER_PAUSE_VAL); /* FIXME: This should probably be
-					   * WU_COUNTER_PAUSE_VAL instead of
-					   * 0x3ff (magic number ).  How does
-					   * this work?! */
+	pause &= ~(WU_COUNTER_PAUSE_VAL);
 	pause |= WU_COUNTER_PAUSE_VAL;
 	wl1271_write32(wl, WU_COUNTER_PAUSE, pause);
 
@@ -548,7 +542,6 @@ int wl1271_boot(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
-	/* FIXME: Need to check whether this is really what we want */
 	wl1271_write32(wl, ACX_REG_INTERRUPT_MASK,
 		       WL1271_ACX_ALL_EVENTS_VECTOR);
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 8ce891a..bbd075a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -251,7 +251,6 @@ static struct conf_drv_settings default_conf = {
 		.host_fast_wakeup_support = false
 	},
 	.roam_trigger = {
-		/* FIXME: due to firmware bug, must use value 1 for now */
 		.trigger_pacing               = 1,
 		.avg_weight_rssi_beacon       = 20,
 		.avg_weight_rssi_data         = 10,
@@ -2281,8 +2280,7 @@ static ssize_t wl1271_sysfs_show_bt_coex_state(struct device *dev,
 	struct wl1271 *wl = dev_get_drvdata(dev);
 	ssize_t len;
 
-	/* FIXME: what's the maximum length of buf? page size?*/
-	len = 500;
+	len = PAGE_SIZE;
 
 	mutex_lock(&wl->mutex);
 	len = snprintf(buf, len, "%d\n\n0 - off\n1 - on\n",
@@ -2343,8 +2341,7 @@ static ssize_t wl1271_sysfs_show_hw_pg_ver(struct device *dev,
 	struct wl1271 *wl = dev_get_drvdata(dev);
 	ssize_t len;
 
-	/* FIXME: what's the maximum length of buf? page size?*/
-	len = 500;
+	len = PAGE_SIZE;
 
 	mutex_lock(&wl->mutex);
 	if (wl->hw_pg_ver >= 0)
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index dc0b46c..0f99eff 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -422,8 +422,6 @@ void wl1271_tx_reset(struct wl1271 *wl)
 	struct sk_buff *skb;
 
 	/* TX failure */
-/* 	control->flags = 0; FIXME */
-
 	while ((skb = skb_dequeue(&wl->tx_queue))) {
 		wl1271_debug(DEBUG_TX, "freeing skb 0x%p", skb);
 		ieee80211_tx_status(wl->hw, skb);
-- 
1.6.3.3

