Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40132 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbbIPJxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 05:53:47 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 3/8] staging: wilc1000: remove define TCP_ENHANCEMENTS and it's related code
Date: Wed, 16 Sep 2015 18:53:22 +0900
Message-ID: <1442397207-20491-3-git-send-email-tony.cho@atmel.com> (sfid-20150916_115353_388458_B3B5F215)
In-Reply-To: <1442397207-20491-1-git-send-email-tony.cho@atmel.com>
References: <1442397207-20491-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

TCP_ENHANCEMENTS is always in use. Remove define TCP_ENHANCEMENTS, ifdef line,
ifndef line and codes inside ifndef.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 36 -----------------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 --
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |  2 --
 drivers/staging/wilc1000/wilc_wlan.c              |  8 +----
 drivers/staging/wilc1000/wilc_wlan_if.h           |  1 -
 5 files changed, 1 insertion(+), 48 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index f79aa49..08d75ab 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1284,21 +1284,6 @@ int wlan_initialize_threads(perInterface_wlan_t *nic)
 	}
 #endif
 
-#ifndef TCP_ENHANCEMENTS
-	/* create rx task */
-	PRINT_D(INIT_DBG, "Creating kthread for reception\n");
-	g_linux_wlan->rxq_thread = kthread_run(linux_wlan_rxq_task, (void *)g_linux_wlan, "K_RXQ_TASK");
-	if (g_linux_wlan->rxq_thread == 0) {
-		PRINT_ER("couldn't create RXQ thread\n");
-		ret = -ENOBUFS;
-		goto _fail_1;
-	}
-
-	/* wait for RXQ task to start. */
-	down(&g_linux_wlan->rxq_thread_started);
-
-#endif
-
 	/* create tx task */
 	PRINT_D(INIT_DBG, "Creating kthread for transmission\n");
 	g_linux_wlan->txq_thread = kthread_run(linux_wlan_txq_task, (void *)g_linux_wlan, "K_TXQ_TASK");
@@ -1327,9 +1312,6 @@ _fail_2:
 	up(&g_linux_wlan->rxq_event);
 	kthread_stop(g_linux_wlan->rxq_thread);
 
-#ifndef TCP_ENHANCEMENTS
-_fail_1:
-#endif
 	#if (RX_BH_TYPE == RX_BH_KTHREAD)
 	/*De-Initialize 1st thread*/
 	g_linux_wlan->close = 1;
@@ -1970,10 +1952,6 @@ void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset)
 	int stats;
 	unsigned char *buff_to_send = NULL;
 	struct sk_buff *skb;
-#ifndef TCP_ENHANCEMENTS
-	char *pu8UdpBuffer;
-	struct iphdr *ih;
-#endif
 	struct net_device *wilc_netdev;
 	perInterface_wlan_t *nic;
 
@@ -2019,16 +1997,6 @@ void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset)
 		/* nic = netdev_priv(wilc_netdev); */
 
 		skb->protocol = eth_type_trans(skb, wilc_netdev);
-			#ifndef TCP_ENHANCEMENTS
-		/*get source and dest ip addresses*/
-		ih = (struct iphdr *)(skb->data + sizeof(struct ethhdr));
-
-		pu8UdpBuffer = (char *)ih + sizeof(struct iphdr);
-		if (buff_to_send[35] == 67 && buff_to_send[37] == 68)
-			PRINT_D(RX_DBG, "DHCP Message received\n");
-		if (buff_to_send[12] == 0x88 && buff_to_send[13] == 0x8e)
-			PRINT_D(GENERIC_DBG, "eapol received\n");
-			#endif
 		/* Send the packet to the stack by giving it to the bridge */
 		nic->netstats.rx_packets++;
 		nic->netstats.rx_bytes += frame_len;
@@ -2036,10 +2004,6 @@ void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset)
 		stats = netif_rx(skb);
 		PRINT_D(RX_DBG, "netif_rx ret value is: %d\n", stats);
 	}
-		#ifndef TCP_ENHANCEMENTS
-	else
-		PRINT_ER("Discard sending packet with len = %d\n", size);
-		#endif
 }
 
 void WILC_WFI_mgmt_rx(u8 *buff, u32 size)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 468b632..a2c80db 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1663,12 +1663,10 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		sinfo->tx_failed	=  strStatistics.u32TxFailureCount;
 		sinfo->txrate.legacy = strStatistics.u8LinkSpeed * 10;
 
-#ifdef TCP_ENHANCEMENTS
 		if ((strStatistics.u8LinkSpeed > TCP_ACK_FILTER_LINK_SPEED_THRESH) && (strStatistics.u8LinkSpeed != DEFAULT_LINK_SPEED))
 			Enable_TCP_ACK_Filter(true);
 		else if (strStatistics.u8LinkSpeed != DEFAULT_LINK_SPEED)
 			Enable_TCP_ACK_Filter(false);
-#endif
 
 		PRINT_D(CORECONFIG_DBG, "*** stats[%d][%d][%d][%d][%d]\n", sinfo->signal, sinfo->rx_packets, sinfo->tx_packets,
 			sinfo->tx_failed, sinfo->txrate.legacy);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index dff8265..4d37c4e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -101,10 +101,8 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size);
 int WILC_WFI_deinit_mon_interface(void);
 struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_device *real_dev);
 
-#ifdef TCP_ENHANCEMENTS
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
 #define DEFAULT_LINK_SPEED			72
 void Enable_TCP_ACK_Filter(bool value);
-#endif
 
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 54f30b2..1db4cc8 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -480,7 +480,6 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 }
 #endif
 
-#ifdef TCP_ENHANCEMENTS
 bool EnableTCPAckFilter = false;
 
 void Enable_TCP_ACK_Filter(bool value)
@@ -492,7 +491,6 @@ bool is_TCP_ACK_Filter_Enabled(void)
 {
 	return EnableTCPAckFilter;
 }
-#endif
 
 static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
 {
@@ -552,10 +550,8 @@ static int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, u32 buffer_size, wi
 	PRINT_D(TX_DBG, "Adding mgmt packet at the Queue tail\n");
 #ifdef TCP_ACK_FILTER
 	tqe->tcp_PendingAck_index = NOT_TCP_ACK;
-#ifdef TCP_ENHANCEMENTS
 	if (is_TCP_ACK_Filter_Enabled())
-#endif
-	tcp_process(tqe);
+		tcp_process(tqe);
 #endif
 	wilc_wlan_txq_add_to_tail(tqe);
 	/*return number of itemes in the queue*/
@@ -1410,9 +1406,7 @@ _end_:
 #endif
 		}
 	}
-#ifdef TCP_ENHANCEMENTS
 	wilc_wlan_handle_rxq();
-#endif
 }
 
 void wilc_handle_isr(void)
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index d67718f..3f5aa44 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -12,7 +12,6 @@
 #define WILC_WLAN_IF_H
 
 /*bug 3887: [AP] Allow Management frames to be passed to the host*/
-#define TCP_ENHANCEMENTS
 /* #define MEMORY_STATIC */
 /* #define USE_OLD_SPI_SW */
 
-- 
1.9.1

