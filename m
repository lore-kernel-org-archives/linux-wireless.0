Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36692 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbbFWASZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 20:18:25 -0400
Received: by pdcu2 with SMTP id u2so22414575pdc.3
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 17:18:25 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/4] staging: wilc1000: wilc_wfi_netdevice.c: remove commented codes
Date: Tue, 23 Jun 2015 09:17:44 +0900
Message-Id: <1435018667-12507-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150623_021836_768499_B874A088)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove commented codes.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.c b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
index 170ca65..478cd2b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.c
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
@@ -325,7 +325,6 @@ void WILC_WFI_Rx(struct net_device *dev, struct WILC_WFI_packet *pkt)
 		PRINT_INFO(RX_DBG, "In monitor device name %s\n", dev->name);
 		priv = wiphy_priv(priv->dev->ieee80211_ptr->wiphy);
 		PRINT_D(RX_DBG, "VALUE PASSED IN OF HRWD %p\n", priv->hWILCWFIDrv);
-		/* host_int_get_rssi(priv->hWILCWFIDrv, &(rssi)); */
 		if (INFO) {
 			for (i = 14; i < skb->len; i++)
 				PRINT_INFO(RX_DBG, "RXdata[%d] %02x\n", i, skb->data[i]);
@@ -600,12 +599,6 @@ int WILC_WFI_Tx(struct sk_buff *skb, struct net_device *dev)
 	char *data, shortpkt[ETH_ZLEN];
 	struct WILC_WFI_priv *priv = netdev_priv(dev);
 
-	/* priv = wiphy_priv(priv->dev->ieee80211_ptr->wiphy); */
-
-	/*  if(priv->monitor_flag) */
-	/*	 mac80211_hwsim_monitor_rx(skb); */
-
-
 	data = skb->data;
 	len = skb->len;
 
@@ -836,12 +829,6 @@ void WILC_WFI_Cleanup(void)
 	int i;
 	struct WILC_WFI_priv *priv[2];
 
-	/*if(hwsim_mon!=NULL)
-	 * {
-	 *      PRINT_D(RX_DBG, "Freeing monitor interface\n");
-	 *      unregister_netdev(hwsim_mon);
-	 *      free_netdev(hwsim_mon);
-	 * }*/
 	for (i = 0; i < 2; i++) {
 		priv[i] = netdev_priv(WILC_WFI_devs[i]);
 
@@ -897,7 +884,6 @@ int WILC_WFI_InitModule(void)
 						WILC_WFI_Init);
 		if (WILC_WFI_devs[i] == NULL)
 			goto out;
-		/* priv[i] = netdev_priv(WILC_WFI_devs[i]); */
 
 		wdev = WILC_WFI_WiphyRegister(WILC_WFI_devs[i]);
 		WILC_WFI_devs[i]->ieee80211_ptr = wdev;
@@ -921,9 +907,6 @@ int WILC_WFI_InitModule(void)
 	priv[1] = netdev_priv(WILC_WFI_devs[1]);
 
 	if (priv[1]->dev->ieee80211_ptr->wiphy->interface_modes && BIT(NL80211_IFTYPE_MONITOR))	{
-		/* snprintf(buf, IFNAMSIZ, "mon.%s",  priv[1]->dev->name); */
-		/*	WILC_WFI_init_mon_interface(); */
-		/*	priv[1]->monitor_flag = 1; */
 
 	}
 	priv[0]->bCfgScanning = false;
@@ -931,10 +914,6 @@ int WILC_WFI_InitModule(void)
 
 	WILC_memset(priv[0]->au8AssociatedBss, 0xFF, ETH_ALEN);
 
-
-	/* ret = host_int_init(&priv[0]->hWILCWFIDrv); */
-	/*copy handle to the other driver*/
-	/* priv[1]->hWILCWFIDrv = priv[0]->hWILCWFIDrv; */
 	if (ret)
 		PRINT_ER("Error Init Driver\n");
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
