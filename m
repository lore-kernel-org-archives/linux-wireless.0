Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34141 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbcBAM1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 07:27:10 -0500
Received: by mail-pf0-f194.google.com with SMTP id 65so7494734pfd.1
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2016 04:27:09 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/11] staging: wilc1000: linux_mon: remove multiple blank lines
Date: Mon,  1 Feb 2016 21:26:40 +0900
Message-Id: <1454329607-9486-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20160201_132714_714013_71BA8DA6)
In-Reply-To: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com>
References: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes multiple blank lines found by checkpatch.pl
CHECK: Please don't use multiple blank lines

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_mon.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index bd0b17e..398fdea 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -11,7 +11,6 @@
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 
-
 struct wilc_wfi_radiotap_hdr {
 	struct ieee80211_radiotap_header hdr;
 	u8 rate;
@@ -121,8 +120,6 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 		hdr->rate = 5; /* txrate->bitrate / 5; */
 	}
 
-
-
 	skb->dev = wilc_wfi_mon;
 	skb_set_mac_header(skb, 0);
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -143,8 +140,6 @@ static void mgmt_tx_complete(void *priv, int status)
 	struct tx_complete_mon_data *pv_data = (struct tx_complete_mon_data *)priv;
 	u8 *buf =  pv_data->buff;
 
-
-
 	if (status == 1) {
 		if (INFO || buf[0] == 0x10 || buf[0] == 0xb0)
 			PRINT_INFO(HOSTAPD_DBG, "Packet sent successfully - Size = %d - Address = %p.\n", pv_data->size, pv_data->buff);
@@ -152,8 +147,6 @@ static void mgmt_tx_complete(void *priv, int status)
 		PRINT_INFO(HOSTAPD_DBG, "Couldn't send packet - Size = %d - Address = %p.\n", pv_data->size, pv_data->buff);
 	}
 
-
-
 	/* incase of fully hosting mode, the freeing will be done in response to the cfg packet */
 	kfree(pv_data->buff);
 
@@ -220,7 +213,6 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 		return -EFAULT;
 	}
 
-
 	rtap_len = ieee80211_get_radiotap_len(skb->data);
 	if (skb->len < rtap_len) {
 		PRINT_ER("Error in radiotap header\n");
@@ -273,8 +265,6 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 
 	PRINT_INFO(HOSTAPD_DBG, "Skipping the radiotap header\n");
 
-
-
 	/* actual deliver of data is device-specific, and not shown here */
 	PRINT_INFO(HOSTAPD_DBG, "SKB netdevice name = %s\n", skb->dev->name);
 	PRINT_INFO(HOSTAPD_DBG, "MONITOR real dev name = %s\n", mon_priv->real_ndev->name);
-- 
2.7.0

