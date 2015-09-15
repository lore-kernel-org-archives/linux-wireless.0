Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:32915 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbbIOFHL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:07:11 -0400
Received: by pacex6 with SMTP id ex6so165315750pac.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 22:07:11 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/18] staging: wilc1000: remove commented codes
Date: Tue, 15 Sep 2015 14:06:17 +0900
Message-Id: <1442293588-15323-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20150915_071652_823927_B99B7250)
In-Reply-To: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes commented codes.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.h | 13 -------
 drivers/staging/wilc1000/linux_mon.c      | 59 -------------------------------
 drivers/staging/wilc1000/wilc_sdio.c      |  2 --
 drivers/staging/wilc1000/wilc_spi.c       |  4 ---
 4 files changed, 78 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index a107377..dfc210a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -65,14 +65,6 @@
 #define WILC_ADD_STA_LENGTH	40 /* Not including the rates field cause it has variable length*/
 #define SCAN_EVENT_DONE_ABORTED
 #define NUM_CONCURRENT_IFC 2
-/*****************************************************************************/
-/* Data Types                                                                */
-/*****************************************************************************/
-/* typedef unsigned char	uint8; */
-/* typedef signed char     int8; */
-/* typedef unsigned short	uint16; */
-/* typedef unsigned long   uint32; */
-/* typedef uint32   Bool; */
 
 typedef struct {
 	u16 cfg_wid;
@@ -192,7 +184,6 @@ typedef enum {
 typedef enum {
 	WEP,
 	WPARxGtk,
-	/* WPATxGtk, */
 	WPAPtk,
 	PMKSA,
 } tenuKeyType;
@@ -350,8 +341,6 @@ typedef struct {
 
 	tenuHostIFstate enuHostIFstate;
 
-	/* bool bPendingConnRequest; */
-
 	#ifndef CONNECT_DIRECT
 	u32 u32SurveyResultsCount;
 	wid_site_survey_reslts_s astrSurveyResults[MAX_NUM_SCANNED_NETWORKS];
@@ -414,8 +403,6 @@ typedef struct {
 	u16 u16FlagsSet;                /*<! Decoded according to tenuWILC_StaFlag */
 } tstrWILC_AddStaParam;
 
-/* extern void CfgDisconnected(void* pUserVoid, u16 u16reason, u8 * ie, size_t ie_len); */
-
 /*****************************************************************************/
 /*																			 */
 /*							Host Interface API								 */
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 01e8be1..6a27d5c 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -16,7 +16,6 @@
 struct wilc_wfi_radiotap_hdr {
 	struct ieee80211_radiotap_header hdr;
 	u8 rate;
-	/* u32 channel; */
 } __attribute__((packed));
 
 struct wilc_wfi_radiotap_cb_hdr {
@@ -24,7 +23,6 @@ struct wilc_wfi_radiotap_cb_hdr {
 	u8 rate;
 	u8 dump;
 	u16 tx_flags;
-	/* u32 channel; */
 } __attribute__((packed));
 
 extern linux_wlan_t *g_linux_wlan;
@@ -63,10 +61,6 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 
 	PRINT_INFO(HOSTAPD_DBG, "In monitor interface receive function\n");
 
-	/*   struct wilc_priv *priv = netdev_priv(dev); */
-
-	/*   priv = wiphy_priv(priv->dev->ieee80211_ptr->wiphy); */
-
 	/* Bug 4601 */
 	if (wilc_wfi_mon == NULL)
 		return;
@@ -124,30 +118,19 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 			return;
 		}
 
-		/* skb = skb_copy_expand(tx_skb, sizeof(*hdr), 0, GFP_ATOMIC); */
-		/* if (skb == NULL) */
-		/*      return; */
-
 		memcpy(skb_put(skb, size), buff, size);
 		hdr = (struct wilc_wfi_radiotap_hdr *) skb_push(skb, sizeof(*hdr));
 		memset(hdr, 0, sizeof(struct wilc_wfi_radiotap_hdr));
 		hdr->hdr.it_version = 0; /* PKTHDR_RADIOTAP_VERSION; */
-		/* hdr->hdr.it_pad = 0; */
 		hdr->hdr.it_len = cpu_to_le16(sizeof(struct wilc_wfi_radiotap_hdr));
 		PRINT_INFO(HOSTAPD_DBG, "Radiotap len %d\n", hdr->hdr.it_len);
 		hdr->hdr.it_present = cpu_to_le32
 				(1 << IEEE80211_RADIOTAP_RATE);                   /* | */
-		/* (1 << IEEE80211_RADIOTAP_CHANNEL)); */
 		PRINT_INFO(HOSTAPD_DBG, "Presentflags %d\n", hdr->hdr.it_present);
 		hdr->rate = 5; /* txrate->bitrate / 5; */
 
 	}
 
-/*	if(INFO || if(skb->data[9] == 0x00 || skb->data[9] == 0xb0))
- *      {
- *              for(i=0;i<skb->len;i++)
- *                      PRINT_INFO(HOSTAPD_DBG,"Mon RxData[%d] = %02x\n",i,skb->data[i]);
- *      }*/
 
 
 	skb->dev = wilc_wfi_mon;
@@ -170,9 +153,6 @@ struct tx_complete_mon_data {
 static void mgmt_tx_complete(void *priv, int status)
 {
 
-	/* struct sk_buff *skb2; */
-	/* struct wilc_wfi_radiotap_cb_hdr *cb_hdr; */
-
 	struct tx_complete_mon_data *pv_data = (struct tx_complete_mon_data *)priv;
 	u8 *buf =  pv_data->buff;
 
@@ -186,35 +166,6 @@ static void mgmt_tx_complete(void *priv, int status)
 	}
 
 
-/*			//(skb->data[9] == 0x00 || skb->data[9] == 0xb0 || skb->data[9] == 0x40 ||  skb->data[9] == 0xd0 )
- *      {
- *              skb2 = dev_alloc_skb(pv_data->size+sizeof(struct wilc_wfi_radiotap_cb_hdr));
- *
- *              memcpy(skb_put(skb2,pv_data->size),pv_data->buff, pv_data->size);
- *
- *              cb_hdr = (struct wilc_wfi_radiotap_cb_hdr *) skb_push(skb2, sizeof(*cb_hdr));
- *              memset(cb_hdr, 0, sizeof(struct wilc_wfi_radiotap_cb_hdr));
- *
- *               cb_hdr->hdr.it_version = 0;//PKTHDR_RADIOTAP_VERSION;
- *
- *              cb_hdr->hdr.it_len = cpu_to_le16(sizeof(struct wilc_wfi_radiotap_cb_hdr));
- *
- *       cb_hdr->hdr.it_present = cpu_to_le32(
- *                                        (1 << IEEE80211_RADIOTAP_RATE) |
- *                                       (1 << IEEE80211_RADIOTAP_TX_FLAGS));
- *
- *              cb_hdr->rate = 5;//txrate->bitrate / 5;
- *              cb_hdr->tx_flags = 0x0004;
- *
- *              skb2->dev = wilc_wfi_mon;
- *              skb_set_mac_header(skb2, 0);
- *              skb2->ip_summed = CHECKSUM_UNNECESSARY;
- *              skb2->pkt_type = PACKET_OTHERHOST;
- *              skb2->protocol = htons(ETH_P_802_2);
- *              memset(skb2->cb, 0, sizeof(skb2->cb));
- *
- *              netif_rx(skb2);
- *      }*/
 
 	/* incase of fully hosting mode, the freeing will be done in response to the cfg packet */
 	kfree(pv_data->buff);
@@ -276,8 +227,6 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 	if (wilc_wfi_mon == NULL)
 		return WILC_FAIL;
 
-	/* if(skb->data[3] == 0x10 || skb->data[3] == 0xb0) */
-
 	mon_priv = netdev_priv(wilc_wfi_mon);
 
 	if (mon_priv == NULL) {
@@ -355,7 +304,6 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 	} else
 		ret = mac_xmit(skb, mon_priv->real_ndev);
 
-	/* return NETDEV_TX_OK; */
 	return ret;
 }
 
@@ -377,7 +325,6 @@ static void WILC_WFI_mon_setup(struct net_device *dev)
 {
 
 	dev->netdev_ops = &wilc_wfi_netdev_ops;
-	/* dev->destructor = free_netdev; */
 	PRINT_INFO(CORECONFIG_DBG, "In Ethernet setup function\n");
 	ether_setup(dev);
 	dev->priv_flags |= IFF_NO_QUEUE;
@@ -385,12 +332,7 @@ static void WILC_WFI_mon_setup(struct net_device *dev)
 	eth_zero_addr(dev->dev_addr);
 
 	{
-		/* u8 * mac_add; */
 		unsigned char mac_add[] = {0x00, 0x50, 0xc2, 0x5e, 0x10, 0x8f};
-		/* priv = wiphy_priv(priv->dev->ieee80211_ptr->wiphy); */
-		/* mac_add = (u8*)WILC_MALLOC(ETH_ALEN); */
-		/* status = host_int_get_MacAddress(priv->hWILCWFIDrv,mac_add); */
-		/* mac_add[ETH_ALEN-1]+=1; */
 		memcpy(dev->dev_addr, mac_add, ETH_ALEN);
 	}
 
@@ -467,7 +409,6 @@ int WILC_WFI_deinit_mon_interface(void)
 		}
 		PRINT_D(HOSTAPD_DBG, "Unregister netdev\n");
 		unregister_netdev(wilc_wfi_mon);
-		/* free_netdev(wilc_wfi_mon); */
 
 		if (rollback_lock) {
 			rtnl_lock();
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 820aac5..48834c6 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -753,9 +753,7 @@ static int sdio_read_int(u32 *int_status)
 	 *      Read IRQ flags
 	 **/
 #ifndef WILC_SDIO_IRQ_GPIO
-	/* cmd.read_write = 0; */
 	cmd.function = 1;
-	/* cmd.raw = 0; */
 	cmd.address = 0x04;
 	cmd.data = 0;
 	g_sdio.sdio_cmd52(&cmd);
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index fd3ef97..8426641 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -10,10 +10,6 @@
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 
-/*
- * #include <linux/kernel.h>
- * #include <linux/string.h>
- */
 typedef struct {
 	void *os_context;
 	int (*spi_tx)(u8 *, u32);
-- 
2.5.1

