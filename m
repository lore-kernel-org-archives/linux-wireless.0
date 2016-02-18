Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:29964 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1425347AbcBRLdp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 06:33:45 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH V2 07/24] staging: wilc1000: linux_mon.c: removes unnecessary log message
Date: Thu, 18 Feb 2016 20:30:07 +0900
Message-ID: <1455795024-26978-7-git-send-email-leo.kim@atmel.com> (sfid-20160218_123350_254222_B8364081)
In-Reply-To: <1455795024-26978-1-git-send-email-leo.kim@atmel.com>
References: <1455795024-26978-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch removes unnecessary log message and relate variables.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_mon.c | 42 ++++--------------------------------
 1 file changed, 4 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index dbb98bf..7e7cff4 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -52,15 +52,11 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 	struct wilc_wfi_radiotap_hdr *hdr;
 	struct wilc_wfi_radiotap_cb_hdr *cb_hdr;
 
-	PRINT_INFO(HOSTAPD_DBG, "In monitor interface receive function\n");
-
 	if (!wilc_wfi_mon)
 		return;
 
-	if (!netif_running(wilc_wfi_mon)) {
-		PRINT_INFO(HOSTAPD_DBG, "Monitor interface already RUNNING\n");
+	if (!netif_running(wilc_wfi_mon))
 		return;
-	}
 
 	/* Get WILC header */
 	memcpy(&header, (buff - HOST_HDR_OFFSET), HOST_HDR_OFFSET);
@@ -73,10 +69,8 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 		/* hostapd callback mgmt frame */
 
 		skb = dev_alloc_skb(size + sizeof(struct wilc_wfi_radiotap_cb_hdr));
-		if (!skb) {
-			PRINT_INFO(HOSTAPD_DBG, "Monitor if : No memory to allocate skb");
+		if (!skb)
 			return;
-		}
 
 		memcpy(skb_put(skb, size), buff, size);
 
@@ -103,20 +97,16 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 	} else {
 		skb = dev_alloc_skb(size + sizeof(struct wilc_wfi_radiotap_hdr));
 
-		if (!skb) {
-			PRINT_INFO(HOSTAPD_DBG, "Monitor if : No memory to allocate skb");
+		if (!skb)
 			return;
-		}
 
 		memcpy(skb_put(skb, size), buff, size);
 		hdr = (struct wilc_wfi_radiotap_hdr *)skb_push(skb, sizeof(*hdr));
 		memset(hdr, 0, sizeof(struct wilc_wfi_radiotap_hdr));
 		hdr->hdr.it_version = 0; /* PKTHDR_RADIOTAP_VERSION; */
 		hdr->hdr.it_len = cpu_to_le16(sizeof(struct wilc_wfi_radiotap_hdr));
-		PRINT_INFO(HOSTAPD_DBG, "Radiotap len %d\n", hdr->hdr.it_len);
 		hdr->hdr.it_present = cpu_to_le32
 				(1 << IEEE80211_RADIOTAP_RATE);                   /* | */
-		PRINT_INFO(HOSTAPD_DBG, "Presentflags %d\n", hdr->hdr.it_present);
 		hdr->rate = 5; /* txrate->bitrate / 5; */
 	}
 
@@ -138,14 +128,6 @@ struct tx_complete_mon_data {
 static void mgmt_tx_complete(void *priv, int status)
 {
 	struct tx_complete_mon_data *pv_data = priv;
-	u8 *buf =  pv_data->buff;
-
-	if (status == 1) {
-		if (INFO || buf[0] == 0x10 || buf[0] == 0xb0)
-			PRINT_INFO(HOSTAPD_DBG, "Packet sent successfully - Size = %d - Address = %p.\n", pv_data->size, pv_data->buff);
-	} else {
-		PRINT_INFO(HOSTAPD_DBG, "Couldn't send packet - Size = %d - Address = %p.\n", pv_data->size, pv_data->buff);
-	}
 
 	/* incase of fully hosting mode, the freeing will be done in response to the cfg packet */
 	kfree(pv_data->buff);
@@ -193,7 +175,7 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 				     struct net_device *dev)
 {
-	u32 rtap_len, i, ret = 0;
+	u32 rtap_len, ret = 0;
 	struct WILC_WFI_mon_priv  *mon_priv;
 
 	struct sk_buff *skb2;
@@ -210,18 +192,9 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 		return -1;
 
 	/* skip the radiotap header */
-	PRINT_INFO(HOSTAPD_DBG, "Radiotap len: %d\n", rtap_len);
-
-	if (INFO) {
-		for (i = 0; i < rtap_len; i++)
-			PRINT_INFO(HOSTAPD_DBG, "Radiotap_hdr[%d] %02x\n", i, skb->data[i]);
-	}
 	/* Skip the ratio tap header */
 	skb_pull(skb, rtap_len);
 
-	if (skb->data[0] == 0xc0)
-		PRINT_INFO(HOSTAPD_DBG, "%x:%x:%x:%x:%x%x\n", skb->data[4], skb->data[5], skb->data[6], skb->data[7], skb->data[8], skb->data[9]);
-
 	if (skb->data[0] == 0xc0 && (!(memcmp(broadcast, &skb->data[4], 6)))) {
 		skb2 = dev_alloc_skb(skb->len + sizeof(struct wilc_wfi_radiotap_cb_hdr));
 
@@ -254,11 +227,7 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 	}
 	skb->dev = mon_priv->real_ndev;
 
-	PRINT_INFO(HOSTAPD_DBG, "Skipping the radiotap header\n");
-
 	/* actual deliver of data is device-specific, and not shown here */
-	PRINT_INFO(HOSTAPD_DBG, "SKB netdevice name = %s\n", skb->dev->name);
-	PRINT_INFO(HOSTAPD_DBG, "MONITOR real dev name = %s\n", mon_priv->real_ndev->name);
 
 	/* Identify if Ethernet or MAC header (data or mgmt) */
 	memcpy(srcAdd, &skb->data[10], 6);
@@ -336,13 +305,10 @@ int WILC_WFI_deinit_mon_interface(void)
 	bool rollback_lock = false;
 
 	if (wilc_wfi_mon) {
-		PRINT_D(HOSTAPD_DBG, "In Deinit monitor interface\n");
-		PRINT_D(HOSTAPD_DBG, "RTNL is being locked\n");
 		if (rtnl_is_locked()) {
 			rtnl_unlock();
 			rollback_lock = true;
 		}
-		PRINT_D(HOSTAPD_DBG, "Unregister netdev\n");
 		unregister_netdev(wilc_wfi_mon);
 
 		if (rollback_lock) {
-- 
1.9.1

