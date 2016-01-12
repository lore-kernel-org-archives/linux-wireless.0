Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:52796 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933853AbcALHhk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 02:37:40 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 20/26] staging: wilc1000: remove define TCP_ACK_FILTER
Date: Tue, 12 Jan 2016 16:39:49 +0900
Message-ID: <1452584395-24910-21-git-send-email-glen.lee@atmel.com> (sfid-20160112_083754_307451_E8EDF422)
In-Reply-To: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
References: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes define TCP_ACK_FILTER and use it's feature codes.
Add argument wilc to wilc_wlan_txq_remove because compile error happens.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/Makefile    |  1 -
 drivers/staging/wilc1000/wilc_wlan.c | 22 ++--------------------
 2 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index 90c3760..acc3f3e 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -4,7 +4,6 @@ ccflags-y += -DFIRMWARE_1002=\"atmel/wilc1002_firmware.bin\" \
 		-DFIRMWARE_1003=\"atmel/wilc1003_firmware.bin\"
 
 ccflags-y += -I$(src)/ -DWILC_ASIC_A0 -DWILC_DEBUGFS
-#ccflags-y += -DTCP_ACK_FILTER
 
 wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
 			wilc_msgqueue.o \
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index e0696505..337a1ba 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -36,8 +36,7 @@ static inline void release_bus(struct wilc *wilc, BUS_RELEASE_T release)
 	mutex_unlock(&wilc->hif_cs);
 }
 
-#ifdef TCP_ACK_FILTER
-static void wilc_wlan_txq_remove(struct txq_entry_t *tqe)
+static void wilc_wlan_txq_remove(struct wilc *wilc, struct txq_entry_t *tqe)
 {
 
 	if (tqe == wilc->txq_head) {
@@ -54,7 +53,6 @@ static void wilc_wlan_txq_remove(struct txq_entry_t *tqe)
 	}
 	wilc->txq_entries -= 1;
 }
-#endif
 
 static struct txq_entry_t *
 wilc_wlan_txq_remove_from_head(struct net_device *dev)
@@ -146,7 +144,6 @@ static int wilc_wlan_txq_add_to_head(struct wilc *wilc, struct txq_entry_t *tqe)
 	return 0;
 }
 
-#ifdef	TCP_ACK_FILTER
 struct ack_session_info;
 struct ack_session_info {
 	u32 seq_num;
@@ -308,7 +305,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 				pending_acks_info[i].ack_num);
 			tqe = pending_acks_info[i].txqe;
 			if (tqe) {
-				wilc_wlan_txq_remove(tqe);
+				wilc_wlan_txq_remove(wilc, tqe);
 				tqe->status = 1;
 				if (tqe->tx_complete_func)
 					tqe->tx_complete_func(tqe->priv,
@@ -335,7 +332,6 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 
 	return 1;
 }
-#endif
 
 static bool enabled = false;
 
@@ -344,12 +340,10 @@ void wilc_enable_tcp_ack_filter(bool value)
 	enabled = value;
 }
 
-#ifdef TCP_ACK_FILTER
 static bool is_tcp_ack_filter_enabled(void)
 {
 	return enabled;
 }
-#endif
 
 static int wilc_wlan_txq_add_cfg_pkt(struct wilc *wilc, u8 *buffer, u32 buffer_size)
 {
@@ -373,9 +367,7 @@ static int wilc_wlan_txq_add_cfg_pkt(struct wilc *wilc, u8 *buffer, u32 buffer_s
 	tqe->buffer_size = buffer_size;
 	tqe->tx_complete_func = NULL;
 	tqe->priv = NULL;
-#ifdef TCP_ACK_FILTER
 	tqe->tcp_pending_ack_idx = NOT_TCP_ACK;
-#endif
 	PRINT_D(TX_DBG, "Adding the config packet at the Queue tail\n");
 
 	if (wilc_wlan_txq_add_to_head(wilc, tqe))
@@ -406,11 +398,9 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	tqe->priv = priv;
 
 	PRINT_D(TX_DBG, "Adding mgmt packet at the Queue tail\n");
-#ifdef TCP_ACK_FILTER
 	tqe->tcp_pending_ack_idx = NOT_TCP_ACK;
 	if (is_tcp_ack_filter_enabled())
 		tcp_process(dev, tqe);
-#endif
 	wilc_wlan_txq_add_to_tail(dev, tqe);
 	return wilc->txq_entries;
 }
@@ -436,9 +426,7 @@ int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	tqe->buffer_size = buffer_size;
 	tqe->tx_complete_func = func;
 	tqe->priv = priv;
-#ifdef TCP_ACK_FILTER
 	tqe->tcp_pending_ack_idx = NOT_TCP_ACK;
-#endif
 	PRINT_D(TX_DBG, "Adding Network packet at the Queue tail\n");
 	wilc_wlan_txq_add_to_tail(dev, tqe);
 	return 1;
@@ -643,9 +631,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 
 		wilc_lock_timeout(wilc, &wilc->txq_add_to_head_cs,
 					CFG_PKTS_TIMEOUT);
-#ifdef	TCP_ACK_FILTER
 		wilc_wlan_txq_filter_dup_tcp_ack(dev);
-#endif
 		PRINT_D(TX_DBG, "Getting the head of the TxQ\n");
 		tqe = wilc_wlan_txq_get_first(wilc);
 		i = 0;
@@ -829,10 +815,8 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 				if (tqe->tx_complete_func)
 					tqe->tx_complete_func(tqe->priv,
 							      tqe->status);
-				#ifdef TCP_ACK_FILTER
 				if (tqe->tcp_pending_ack_idx != NOT_TCP_ACK)
 					pending_acks_info[tqe->tcp_pending_ack_idx].txqe = NULL;
-				#endif
 				kfree(tqe);
 			} else {
 				break;
@@ -1564,9 +1548,7 @@ int wilc_wlan_init(struct net_device *dev)
 		ret = -EIO;
 		goto _fail_;
 	}
-#ifdef	TCP_ACK_FILTER
 	init_tcp_tracking();
-#endif
 
 	return 1;
 
-- 
1.9.1

