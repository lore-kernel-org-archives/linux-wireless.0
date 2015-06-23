Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:32981 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbbFWASd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 20:18:33 -0400
Received: by pdjn11 with SMTP id n11so148904266pdj.0
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 17:18:33 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/4] staging: wilc1000: wilc_wfi_netdevice.c: remove blank lines
Date: Tue, 23 Jun 2015 09:17:47 +0900
Message-Id: <1435018667-12507-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150623_021838_683063_1FBAFC3D)
In-Reply-To: <1435018667-12507-1-git-send-email-chaehyun.lim@gmail.com>
References: <1435018667-12507-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove multiple blank lines.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.c b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
index c2e92c0..af9b858 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.c
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
@@ -12,11 +12,9 @@
 #include "wilc_wfi_cfgoperations.h"
 #include "host_interface.h"
 
-
 MODULE_AUTHOR("Mai Daftedar");
 MODULE_LICENSE("Dual BSD/GPL");
 
-
 struct net_device *WILC_WFI_devs[2];
 
 /*
@@ -34,7 +32,6 @@ module_param(timeout, int, 0);
 static int use_napi;
 module_param(use_napi, int, 0);
 
-
 /*
  * A structure representing an in-flight packet.
  */
@@ -45,12 +42,9 @@ struct WILC_WFI_packet {
 	u8 data[ETH_DATA_LEN];
 };
 
-
-
 int pool_size = 8;
 module_param(pool_size, int, 0);
 
-
 static void WILC_WFI_TxTimeout(struct net_device *dev);
 static void (*WILC_WFI_Interrupt)(int, void *, struct pt_regs *);
 
@@ -252,7 +246,6 @@ int WILC_WFI_Open(struct net_device *dev)
 int WILC_WFI_Release(struct net_device *dev)
 {
 	/* release ports, irq and such -- like fops->close */
-
 	netif_stop_queue(dev); /* can't transmit any more */
 
 	return 0;
@@ -512,7 +505,6 @@ void WILC_WFI_HwTx(char *buf, int len, struct net_device *dev)
 	u32 *saddr, *daddr;
 	struct WILC_WFI_packet *tx_buffer;
 
-
 	/* I am paranoid. Ain't I? */
 	if (len < sizeof(struct ethhdr) + sizeof(struct iphdr)) {
 		PRINT_D(RX_DBG, "WILC_WFI: Hmm... packet too short (%i octets)\n",
@@ -580,7 +572,6 @@ void WILC_WFI_HwTx(char *buf, int len, struct net_device *dev)
 			(unsigned long) priv->stats.tx_packets);
 	} else
 		WILC_WFI_Interrupt(0, dev, NULL);
-
 }
 
 /**
@@ -785,7 +776,6 @@ void WILC_WFI_Init(struct net_device *dev)
 {
 	struct WILC_WFI_priv *priv;
 
-
 	/*
 	 * Then, assign other fields in dev, using ether_setup() and some
 	 * hand assignments
@@ -851,12 +841,6 @@ void WILC_WFI_Cleanup(void)
 
 void StartConfigSim(void);
 
-
-
-
-
-
-
 /**
  *  @brief      WILC_WFI_Stat
  *  @details    Return statistics to the caller
@@ -877,7 +861,6 @@ int WILC_WFI_InitModule(void)
 	WILC_WFI_Interrupt = use_napi ? WILC_WFI_NapiInterrupt : WILC_WFI_RegularInterrupt;
 
 	for (i = 0; i < 2; i++)	{
-
 		/* Allocate the net devices */
 		WILC_WFI_devs[i] = alloc_netdev(sizeof(struct WILC_WFI_priv), "wlan%d",
 						WILC_WFI_Init);
@@ -900,7 +883,6 @@ int WILC_WFI_InitModule(void)
 			ret = 0;
 	}
 
-
 	/*init atmel driver */
 	priv[0] = netdev_priv(WILC_WFI_devs[0]);
 	priv[1] = netdev_priv(WILC_WFI_devs[1]);
@@ -921,7 +903,6 @@ out:
 
 }
 
-
 module_init(WILC_WFI_InitModule);
 module_exit(WILC_WFI_Cleanup);
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
