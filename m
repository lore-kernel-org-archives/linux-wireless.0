Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:51239 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbbKJXnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 18:43:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 20/20] staging/wilc1000: pass struct wilc to most linux_wlan.c functions
Date: Wed, 11 Nov 2015 00:42:40 +0100
Message-Id: <1447198960-2760143-21-git-send-email-arnd@arndb.de> (sfid-20151111_004339_642450_A9BB2FD2)
In-Reply-To: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
References: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We want to get rid of all global variables in this driver, and
instead pass device structures from one function to another.
This changes the linux_wlan.c and wilc_wlan.c to do this
for the most part. There are a few exceptions where these
functions are themselves called from another part of the driver
that does not have an instance pointer at hand. Changing those
would be a follow-up step.

There are a few other globals that will have to get moved
into struct wilc at a later point.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/host_interface.c     |   2 +-
 drivers/staging/wilc1000/linux_wlan.c         |  55 +++++-----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  12 ++-
 drivers/staging/wilc1000/wilc_wlan.c          | 145 ++++++++++++++------------
 drivers/staging/wilc1000/wilc_wlan.h          |  10 +-
 5 files changed, 119 insertions(+), 105 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d968483c6f00..640cb6bdf523 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2905,7 +2905,7 @@ static int hostIFthread(void *pvArg)
 			del_timer(&hif_drv->scan_timer);
 			PRINT_D(HOSTINF_DBG, "scan completed successfully\n");
 
-			if (!wilc_wlan_get_num_conn_ifcs())
+			if (!wilc_wlan_get_num_conn_ifcs(wilc_dev))
 				wilc_chip_sleep_manually();
 
 			Handle_ScanDone(msg.drv, SCAN_EVENT_DONE);
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index c3b521e085f2..89b5aca2115c 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -245,13 +245,14 @@ static void deinit_irq(struct net_device *dev)
 	}
 }
 
-void linux_wlan_dbg(u8 *buff)
+void wilc_dbg(struct wilc *wilc, u8 *buff)
 {
 	PRINT_D(INIT_DBG, "%d\n", *buff);
 }
 
-int linux_wlan_lock_timeout(void *vp, u32 timeout)
+int wilc_lock_timeout(struct wilc *nic, void *vp, u32 timeout)
 {
+	/* FIXME: replace with mutex_lock or wait_for_completion */
 	int error = -1;
 
 	PRINT_D(LOCK_DBG, "Locking %p\n", vp);
@@ -263,7 +264,7 @@ int linux_wlan_lock_timeout(void *vp, u32 timeout)
 	return error;
 }
 
-void linux_wlan_mac_indicate(struct wilc *wilc, int flag)
+void wilc_mac_indicate(struct wilc *wilc, int flag)
 {
 	int status;
 
@@ -328,14 +329,14 @@ int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid)
 	return ret;
 }
 
-int wilc_wlan_get_num_conn_ifcs(void)
+int wilc_wlan_get_num_conn_ifcs(struct wilc *wilc)
 {
 	u8 i = 0;
 	u8 null_bssid[6] = {0};
 	u8 ret_val = 0;
 
-	for (i = 0; i < wilc_dev->vif_num; i++)
-		if (memcmp(wilc_dev->vif[i].bssid, null_bssid, 6))
+	for (i = 0; i < wilc->vif_num; i++)
+		if (memcmp(wilc->vif[i].bssid, null_bssid, 6))
 			ret_val++;
 
 	return ret_val;
@@ -411,7 +412,7 @@ static int linux_wlan_txq_task(void *vp)
 	return 0;
 }
 
-void linux_wlan_rx_complete(void)
+void wilc_rx_complete(struct wilc *nic)
 {
 	PRINT_D(RX_DBG, "RX completed\n");
 }
@@ -468,14 +469,14 @@ static int linux_wlan_start_firmware(struct net_device *dev)
 	wilc = nic->wilc;
 
 	PRINT_D(INIT_DBG, "Starting Firmware ...\n");
-	ret = wilc_wlan_start();
+	ret = wilc_wlan_start(wilc);
 	if (ret < 0) {
 		PRINT_ER("Failed to start Firmware\n");
 		return ret;
 	}
 
 	PRINT_D(INIT_DBG, "Waiting for Firmware to get ready ...\n");
-	ret = linux_wlan_lock_timeout(&wilc->sync_event, 5000);
+	ret = wilc_lock_timeout(wilc, &wilc->sync_event, 5000);
 	if (ret) {
 		PRINT_D(INIT_DBG, "Firmware start timed out");
 		return ret;
@@ -485,7 +486,7 @@ static int linux_wlan_start_firmware(struct net_device *dev)
 	return 0;
 }
 
-static int linux_wlan_firmware_download(struct net_device *dev)
+static int wilc1000_firmware_download(struct net_device *dev)
 {
 	perInterface_wlan_t *nic;
 	struct wilc *wilc;
@@ -499,7 +500,7 @@ static int linux_wlan_firmware_download(struct net_device *dev)
 		return -ENOBUFS;
 	}
 	PRINT_D(INIT_DBG, "Downloading Firmware ...\n");
-	ret = wilc_wlan_firmware_download(wilc->firmware->data,
+	ret = wilc_wlan_firmware_download(wilc, wilc->firmware->data,
 					  wilc->firmware->size);
 	if (ret < 0)
 		return ret;
@@ -754,7 +755,7 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 		PRINT_D(INIT_DBG, "Deinitializing IRQ\n");
 		deinit_irq(dev);
 
-		wilc_wlan_stop();
+		wilc_wlan_stop(wl);
 
 		PRINT_D(INIT_DBG, "Deinitializing WILC Wlan\n");
 		wilc_wlan_cleanup(dev);
@@ -914,7 +915,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			goto _fail_irq_enable_;
 		}
 
-		ret = linux_wlan_firmware_download(dev);
+		ret = wilc1000_firmware_download(dev);
 		if (ret < 0) {
 			PRINT_ER("Failed to download firmware\n");
 			ret = -EIO;
@@ -952,7 +953,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		return 0;
 
 _fail_fw_start_:
-		wilc_wlan_stop();
+		wilc_wlan_stop(wl);
 
 _fail_irq_enable_:
 		if (!wl->dev_irq_num &&
@@ -985,6 +986,7 @@ static int mac_init_fn(struct net_device *ndev)
 int wilc_mac_open(struct net_device *ndev)
 {
 	perInterface_wlan_t *nic;
+	struct wilc *wilc;
 
 	unsigned char mac_add[ETH_ALEN] = {0};
 	int ret = 0;
@@ -1001,6 +1003,7 @@ int wilc_mac_open(struct net_device *ndev)
 	}
 
 	nic = netdev_priv(ndev);
+	wilc = nic->wilc;
 	priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
 	PRINT_D(INIT_DBG, "MAC OPEN[%p]\n", ndev);
 
@@ -1314,7 +1317,7 @@ done:
 	return ret;
 }
 
-void frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
+void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 {
 	unsigned int frame_len = 0;
 	int stats;
@@ -1393,7 +1396,7 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 		release_firmware(wilc->firmware);
 
 	if (wilc && (wilc->vif[0].ndev || wilc->vif[1].ndev)) {
-		linux_wlan_lock_timeout(&close_exit_sync, 12 * 1000);
+		wilc_lock_timeout(wilc, &close_exit_sync, 12 * 1000);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
 			if (wilc->vif[i].ndev)
@@ -1417,17 +1420,18 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	int i;
 	perInterface_wlan_t *nic;
 	struct net_device *ndev;
+	struct wilc *wl;
 
 	sema_init(&close_exit_sync, 0);
 
-	wilc_dev = kzalloc(sizeof(*wilc_dev), GFP_KERNEL);
-	if (!wilc_dev)
+	wl = kzalloc(sizeof(*wilc_dev), GFP_KERNEL);
+	if (!wl)
 		return -ENOMEM;
 
-	*wilc = wilc_dev;
-	wilc_dev->io_type = io_type;
-	wilc_dev->gpio = gpio;
-	wilc_dev->ops = ops;
+	*wilc = wl;
+	wl->io_type = io_type;
+	wl->gpio = gpio;
+	wl->ops = ops;
 
 	register_inetaddr_notifier(&g_dev_notifier);
 
@@ -1446,11 +1450,11 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		else
 			strcpy(ndev->name, "p2p%d");
 
-		nic->u8IfIdx = wilc_dev->vif_num;
+		nic->u8IfIdx = wl->vif_num;
 		nic->wilc_netdev = ndev;
 		nic->wilc = *wilc;
-		wilc_dev->vif[wilc_dev->vif_num].ndev = ndev;
-		wilc_dev->vif_num++;
+		wl->vif[wl->vif_num].ndev = ndev;
+		wl->vif_num++;
 		ndev->netdev_ops = &wilc_netdev_ops;
 
 		{
@@ -1483,6 +1487,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		nic->iftype = STATION_MODE;
 		nic->mac_opened = 0;
 	}
+	wilc_dev = *wilc = wl;
 
 	return 0;
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 761bc3f59138..6ec6d6a2868c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -207,11 +207,12 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic);
 
 extern struct wilc *wilc_dev;
 extern struct net_device *WILC_WFI_devs[];
-void frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
-void linux_wlan_mac_indicate(struct wilc *wilc, int flag);
-void linux_wlan_rx_complete(void);
-void linux_wlan_dbg(u8 *buff);
-int linux_wlan_lock_timeout(void *vp, u32 timeout);
+void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
+void wilc_mac_indicate(struct wilc *wilc, int flag);
+void wilc_rx_complete(struct wilc *wilc);
+void wilc_dbg(struct wilc *, u8 *buff);
+
+int wilc_lock_timeout(struct wilc *wilc, void *, u32 timeout);
 void wilc_netdev_cleanup(struct wilc *wilc);
 int wilc_netdev_init(struct wilc **wilc, struct device *, int io_type, int gpio,
 		     const struct wilc_hif_func *ops);
@@ -220,4 +221,5 @@ void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
 u16 wilc_set_machw_change_vir_if(struct net_device *dev, bool value);
 int wilc_wlan_get_firmware(struct net_device *dev);
 int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid);
+
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index a71901c22653..df8503f83a12 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -40,6 +40,7 @@ static inline void chip_allow_sleep(void);
 static inline void chip_wakeup(void);
 static u32 dbgflag = N_INIT | N_ERR | N_INTR | N_TXQ | N_RXQ;
 
+/* FIXME: replace with dev_debug() */
 static void wilc_debug(u32 flag, char *fmt, ...)
 {
 	char buf[256];
@@ -50,15 +51,15 @@ static void wilc_debug(u32 flag, char *fmt, ...)
 		vsprintf(buf, fmt, args);
 		va_end(args);
 
-		linux_wlan_dbg(buf);
+		wilc_dbg(wilc_dev, buf);
 	}
 }
 
 static CHIP_PS_STATE_T chip_ps_state = CHIP_WAKEDUP;
 
-static inline void acquire_bus(BUS_ACQUIRE_T acquire)
+static inline void acquire_bus(struct wilc *wilc, BUS_ACQUIRE_T acquire)
 {
-	mutex_lock(&wilc_dev->hif_cs);
+	mutex_lock(&wilc->hif_cs);
 	#ifndef WILC_OPTIMIZE_SLEEP_INT
 	if (chip_ps_state != CHIP_WAKEDUP)
 	#endif
@@ -68,13 +69,13 @@ static inline void acquire_bus(BUS_ACQUIRE_T acquire)
 	}
 }
 
-static inline void release_bus(BUS_RELEASE_T release)
+static inline void release_bus(struct wilc *wilc, BUS_RELEASE_T release)
 {
 	#ifdef WILC_OPTIMIZE_SLEEP_INT
 	if (release == RELEASE_ALLOW_SLEEP)
 		chip_allow_sleep();
 	#endif
-	mutex_unlock(&wilc_dev->hif_cs);
+	mutex_unlock(&wilc->hif_cs);
 }
 
 #ifdef TCP_ACK_FILTER
@@ -159,15 +160,15 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev,
 	up(&wilc->txq_event);
 }
 
-static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
+static int wilc_wlan_txq_add_to_head(struct wilc *wilc, struct txq_entry_t *tqe)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
-	if (linux_wlan_lock_timeout(&wilc_dev->txq_add_to_head_cs,
+	if (wilc_lock_timeout(wilc, &wilc->txq_add_to_head_cs,
 				    CFG_PKTS_TIMEOUT))
 		return -1;
 
-	spin_lock_irqsave(&wilc_dev->txq_spinlock, flags);
+	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
 	if (!p->txq_head) {
 		tqe->next = NULL;
@@ -183,9 +184,9 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 	p->txq_entries += 1;
 	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", p->txq_entries);
 
-	spin_unlock_irqrestore(&wilc_dev->txq_spinlock, flags);
-	up(&wilc_dev->txq_add_to_head_cs);
-	up(&wilc_dev->txq_event);
+	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
+	up(&wilc->txq_add_to_head_cs);
+	up(&wilc->txq_event);
 	PRINT_D(TX_DBG, "Wake up the txq_handler\n");
 
 	return 0;
@@ -255,14 +256,14 @@ static inline int add_tcp_pending_ack(u32 ack, u32 session_index,
 	}
 	return 0;
 }
-static inline int remove_TCP_related(void)
+static inline int remove_TCP_related(struct wilc *wilc)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
 
-	spin_lock_irqsave(&wilc_dev->txq_spinlock, flags);
+	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
-	spin_unlock_irqrestore(&wilc_dev->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 	return 0;
 }
 
@@ -281,7 +282,6 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 	nic = netdev_priv(dev);
 	wilc = nic->wilc;
 
-	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
 	eth_hdr_ptr = &buffer[0];
 	h_proto = ntohs(*((unsigned short *)&eth_hdr_ptr[12]));
@@ -377,7 +377,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 	spin_unlock_irqrestore(&wilc->txq_spinlock, p->txq_spinlock_flags);
 
 	while (dropped > 0) {
-		linux_wlan_lock_timeout(&wilc->txq_event, 1);
+		wilc_lock_timeout(wilc, &wilc->txq_event, 1);
 		dropped--;
 	}
 
@@ -399,7 +399,7 @@ static bool is_tcp_ack_filter_enabled(void)
 }
 #endif
 
-static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
+static int wilc_wlan_txq_add_cfg_pkt(struct wilc *wilc, u8 *buffer, u32 buffer_size)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	struct txq_entry_t *tqe;
@@ -407,7 +407,7 @@ static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
 	PRINT_D(TX_DBG, "Adding config packet ...\n");
 	if (p->quit) {
 		PRINT_D(TX_DBG, "Return due to clear function\n");
-		up(&wilc_dev->cfg_event);
+		up(&wilc->cfg_event);
 		return 0;
 	}
 
@@ -427,7 +427,7 @@ static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
 #endif
 	PRINT_D(TX_DBG, "Adding the config packet at the Queue tail\n");
 
-	if (wilc_wlan_txq_add_to_head(tqe))
+	if (wilc_wlan_txq_add_to_head(wilc, tqe))
 		return 0;
 	return 1;
 }
@@ -682,7 +682,7 @@ void wilc_chip_sleep_manually(void)
 {
 	if (chip_ps_state != CHIP_WAKEDUP)
 		return;
-	acquire_bus(ACQUIRE_ONLY);
+	acquire_bus(wilc_dev, ACQUIRE_ONLY);
 
 #ifdef WILC_OPTIMIZE_SLEEP_INT
 	chip_allow_sleep();
@@ -690,7 +690,7 @@ void wilc_chip_sleep_manually(void)
 	g_wlan.hif_func.hif_write_reg(0x10a8, 1);
 
 	chip_ps_state = CHIP_SLEEPING_MANUAL;
-	release_bus(RELEASE_ONLY);
+	release_bus(wilc_dev, RELEASE_ONLY);
 }
 
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
@@ -718,7 +718,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 		if (p->quit)
 			break;
 
-		linux_wlan_lock_timeout(&wilc->txq_add_to_head_cs,
+		wilc_lock_timeout(wilc, &wilc->txq_add_to_head_cs,
 					CFG_PKTS_TIMEOUT);
 #ifdef	TCP_ACK_FILTER
 		wilc_wlan_txq_filter_dup_tcp_ack(dev);
@@ -775,7 +775,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 			PRINT_D(TX_DBG, "Mark the last entry in VMM table - number of previous entries = %d\n", i);
 			vmm_table[i] = 0x0;
 		}
-		acquire_bus(ACQUIRE_AND_WAKEUP);
+		acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 		counter = 0;
 		do {
 			ret = p->hif_func.hif_read_reg(WILC_HOST_TX_CTRL, &reg);
@@ -796,9 +796,9 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 					break;
 				}
 				PRINT_WRN(GENERIC_DBG, "[wilc txq]: warn, vmm table not clear yet, wait...\n");
-				release_bus(RELEASE_ALLOW_SLEEP);
+				release_bus(wilc, RELEASE_ALLOW_SLEEP);
 				usleep_range(3000, 3000);
-				acquire_bus(ACQUIRE_AND_WAKEUP);
+				acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 			}
 		} while (!p->quit);
 
@@ -829,9 +829,9 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 					entries = ((reg >> 3) & 0x3f);
 					break;
 				} else {
-					release_bus(RELEASE_ALLOW_SLEEP);
+					release_bus(wilc, RELEASE_ALLOW_SLEEP);
 					usleep_range(3000, 3000);
-					acquire_bus(ACQUIRE_AND_WAKEUP);
+					acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 					PRINT_WRN(GENERIC_DBG, "Can't get VMM entery - reg = %2x\n", reg);
 				}
 			} while (--timeout);
@@ -871,7 +871,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 			goto _end_;
 		}
 
-		release_bus(RELEASE_ALLOW_SLEEP);
+		release_bus(wilc, RELEASE_ALLOW_SLEEP);
 
 		offset = 0;
 		i = 0;
@@ -926,7 +926,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 			}
 		} while (--entries);
 
-		acquire_bus(ACQUIRE_AND_WAKEUP);
+		acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 
 		ret = p->hif_func.hif_clear_int_ext(ENABLE_TX_VMM);
 		if (!ret) {
@@ -942,7 +942,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 
 _end_:
 
-		release_bus(RELEASE_ALLOW_SLEEP);
+		release_bus(wilc, RELEASE_ALLOW_SLEEP);
 		if (ret != 1)
 			break;
 	} while (0);
@@ -1016,7 +1016,7 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 			} else {
 				if (!is_cfg_packet) {
 					if (pkt_len > 0) {
-						frmw_to_linux(wilc,
+						wilc_frmw_to_linux(wilc,
 							      &buffer[offset],
 							      pkt_len,
 							      pkt_offset);
@@ -1031,10 +1031,10 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 						if (p->cfg_seq_no == rsp.seq_no)
 							up(&wilc->cfg_event);
 					} else if (rsp.type == WILC_CFG_RSP_STATUS) {
-						linux_wlan_mac_indicate(wilc, WILC_MAC_INDICATE_STATUS);
+						wilc_mac_indicate(wilc, WILC_MAC_INDICATE_STATUS);
 
 					} else if (rsp.type == WILC_CFG_RSP_SCAN) {
-						linux_wlan_mac_indicate(wilc, WILC_MAC_INDICATE_SCAN);
+						wilc_mac_indicate(wilc, WILC_MAC_INDICATE_SCAN);
 					}
 				}
 			}
@@ -1048,7 +1048,7 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 		kfree(rqe);
 
 		if (has_packet)
-			linux_wlan_rx_complete();
+			wilc_rx_complete(wilc);
 
 	} while (1);
 
@@ -1157,11 +1157,11 @@ _end_:
 	wilc_wlan_handle_rxq(wilc);
 }
 
-void wilc_handle_isr(void *wilc)
+void wilc_handle_isr(struct wilc *wilc)
 {
 	u32 int_status;
 
-	acquire_bus(ACQUIRE_AND_WAKEUP);
+	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 	g_wlan.hif_func.hif_read_int(&int_status);
 
 	if (int_status & PLL_INT_EXT)
@@ -1179,11 +1179,11 @@ void wilc_handle_isr(void *wilc)
 	if (!(int_status & (ALL_INT_EXT))) {
 		wilc_unknown_isr_ext();
 	}
-	release_bus(RELEASE_ALLOW_SLEEP);
+	release_bus(wilc, RELEASE_ALLOW_SLEEP);
 }
 EXPORT_SYMBOL_GPL(wilc_handle_isr);
 
-int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size)
+int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer, u32 buffer_size)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	u32 offset;
@@ -1210,7 +1210,7 @@ int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size)
 		addr = BYTE_SWAP(addr);
 		size = BYTE_SWAP(size);
 #endif
-		acquire_bus(ACQUIRE_ONLY);
+		acquire_bus(wilc, ACQUIRE_ONLY);
 		offset += 8;
 		while (((int)size) && (offset < buffer_size)) {
 			if (size <= blksz)
@@ -1227,7 +1227,7 @@ int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size)
 			offset += size2;
 			size -= size2;
 		}
-		release_bus(RELEASE_ONLY);
+		release_bus(wilc, RELEASE_ONLY);
 
 		if (!ret) {
 			ret = -EIO;
@@ -1246,7 +1246,7 @@ _fail_1:
 	return (ret < 0) ? ret : 0;
 }
 
-int wilc_wlan_start(void)
+int wilc_wlan_start(struct wilc *wilc)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	u32 reg = 0;
@@ -1259,16 +1259,16 @@ int wilc_wlan_start(void)
 	} else if (p->io_type == HIF_SPI) {
 		reg = 1;
 	}
-	acquire_bus(ACQUIRE_ONLY);
+	acquire_bus(wilc, ACQUIRE_ONLY);
 	ret = p->hif_func.hif_write_reg(WILC_VMM_CORE_CFG, reg);
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail write reg vmm_core_cfg...\n");
-		release_bus(RELEASE_ONLY);
+		release_bus(wilc, RELEASE_ONLY);
 		ret = -EIO;
 		return ret;
 	}
 	reg = 0;
-	if (p->io_type == HIF_SDIO && wilc_dev->dev_irq_num)
+	if (p->io_type == HIF_SDIO && wilc->dev_irq_num)
 		reg |= WILC_HAVE_SDIO_IRQ_GPIO;
 
 #ifdef WILC_DISABLE_PMU
@@ -1297,7 +1297,7 @@ int wilc_wlan_start(void)
 	ret = p->hif_func.hif_write_reg(WILC_GP_REG_1, reg);
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail write WILC_GP_REG_1 ...\n");
-		release_bus(RELEASE_ONLY);
+		release_bus(wilc, RELEASE_ONLY);
 		ret = -EIO;
 		return ret;
 	}
@@ -1307,7 +1307,7 @@ int wilc_wlan_start(void)
 	ret = p->hif_func.hif_read_reg(0x1000, &chipid);
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail read reg 0x1000 ...\n");
-		release_bus(RELEASE_ONLY);
+		release_bus(wilc, RELEASE_ONLY);
 		ret = -EIO;
 		return ret;
 	}
@@ -1322,32 +1322,32 @@ int wilc_wlan_start(void)
 	reg |= BIT(10);
 	ret = p->hif_func.hif_write_reg(WILC_GLB_RESET_0, reg);
 	p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
-	release_bus(RELEASE_ONLY);
+	release_bus(wilc, RELEASE_ONLY);
 
 	return (ret < 0) ? ret : 0;
 }
 
-void wilc_wlan_global_reset(void)
+void wilc_wlan_global_reset(struct wilc *wilc)
 {
 
 	wilc_wlan_dev_t *p = &g_wlan;
 
-	acquire_bus(ACQUIRE_AND_WAKEUP);
+	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 	p->hif_func.hif_write_reg(WILC_GLB_RESET_0, 0x0);
-	release_bus(RELEASE_ONLY);
+	release_bus(wilc, RELEASE_ONLY);
 }
-int wilc_wlan_stop(void)
+int wilc_wlan_stop(struct wilc *wilc)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	u32 reg = 0;
 	int ret;
 	u8 timeout = 10;
-	acquire_bus(ACQUIRE_AND_WAKEUP);
+	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 
 	ret = p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
 	if (!ret) {
 		PRINT_ER("Error while reading reg\n");
-		release_bus(RELEASE_ALLOW_SLEEP);
+		release_bus(wilc, RELEASE_ALLOW_SLEEP);
 		return ret;
 	}
 
@@ -1355,7 +1355,7 @@ int wilc_wlan_stop(void)
 	ret = p->hif_func.hif_write_reg(WILC_GLB_RESET_0, reg);
 	if (!ret) {
 		PRINT_ER("Error while writing reg\n");
-		release_bus(RELEASE_ALLOW_SLEEP);
+		release_bus(wilc, RELEASE_ALLOW_SLEEP);
 		return ret;
 	}
 
@@ -1363,7 +1363,7 @@ int wilc_wlan_stop(void)
 		ret = p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
 		if (!ret) {
 			PRINT_ER("Error while reading reg\n");
-			release_bus(RELEASE_ALLOW_SLEEP);
+			release_bus(wilc, RELEASE_ALLOW_SLEEP);
 			return ret;
 		}
 		PRINT_D(GENERIC_DBG, "Read RESET Reg %x : Retry%d\n",
@@ -1381,7 +1381,7 @@ int wilc_wlan_stop(void)
 			ret = p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
 			if (!ret) {
 				PRINT_ER("Error while reading reg\n");
-				release_bus(RELEASE_ALLOW_SLEEP);
+				release_bus(wilc, RELEASE_ALLOW_SLEEP);
 				return ret;
 			}
 			PRINT_D(GENERIC_DBG, "Read RESET Reg %x : Retry%d\n",
@@ -1398,7 +1398,7 @@ int wilc_wlan_stop(void)
 
 	ret = p->hif_func.hif_write_reg(WILC_GLB_RESET_0, reg);
 
-	release_bus(RELEASE_ALLOW_SLEEP);
+	release_bus(wilc, RELEASE_ALLOW_SLEEP);
 
 	return ret;
 }
@@ -1442,24 +1442,24 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	#endif
 	kfree(p->tx_buffer);
 
-	acquire_bus(ACQUIRE_AND_WAKEUP);
+	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 
 	ret = p->hif_func.hif_read_reg(WILC_GP_REG_0, &reg);
 	if (!ret) {
 		PRINT_ER("Error while reading reg\n");
-		release_bus(RELEASE_ALLOW_SLEEP);
+		release_bus(wilc, RELEASE_ALLOW_SLEEP);
 	}
 	PRINT_ER("Writing ABORT reg\n");
 	ret = p->hif_func.hif_write_reg(WILC_GP_REG_0, (reg | ABORT_INT));
 	if (!ret) {
 		PRINT_ER("Error while writing reg\n");
-		release_bus(RELEASE_ALLOW_SLEEP);
+		release_bus(wilc, RELEASE_ALLOW_SLEEP);
 	}
-	release_bus(RELEASE_ALLOW_SLEEP);
+	release_bus(wilc, RELEASE_ALLOW_SLEEP);
 	p->hif_func.hif_deinit(NULL);
 }
 
-static int wilc_wlan_cfg_commit(int type, u32 drv_handler)
+static int wilc_wlan_cfg_commit(struct wilc *wilc, int type, u32 drv_handler)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	struct wilc_cfg_frame *cfg = &p->cfg_frame;
@@ -1480,7 +1480,7 @@ static int wilc_wlan_cfg_commit(int type, u32 drv_handler)
 	cfg->wid_header[7] = (u8)(driver_handler >> 24);
 	p->cfg_seq_no = seq_no;
 
-	if (!wilc_wlan_txq_add_cfg_pkt(&cfg->wid_header[0], total_len))
+	if (!wilc_wlan_txq_add_cfg_pkt(wilc, &cfg->wid_header[0], total_len))
 		return -1;
 
 	return 0;
@@ -1490,6 +1490,7 @@ int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 		      int commit, u32 drv_handler)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
+	struct wilc *wilc = wilc_dev;
 	u32 offset;
 	int ret_size;
 
@@ -1511,10 +1512,10 @@ int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 		PRINT_D(RX_DBG, "Processing cfg_set()\n");
 		p->cfg_frame_in_use = 1;
 
-		if (wilc_wlan_cfg_commit(WILC_CFG_SET, drv_handler))
+		if (wilc_wlan_cfg_commit(wilc, WILC_CFG_SET, drv_handler))
 			ret_size = 0;
 
-		if (linux_wlan_lock_timeout(&wilc_dev->cfg_event,
+		if (wilc_lock_timeout(wilc, &wilc->cfg_event,
 					    CFG_PKTS_TIMEOUT)) {
 			PRINT_D(TX_DBG, "Set Timed Out\n");
 			ret_size = 0;
@@ -1530,6 +1531,7 @@ int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drv_handler)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
+	struct wilc *wilc = wilc_dev;
 	u32 offset;
 	int ret_size;
 
@@ -1547,10 +1549,10 @@ int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drv_handler)
 	if (commit) {
 		p->cfg_frame_in_use = 1;
 
-		if (wilc_wlan_cfg_commit(WILC_CFG_QUERY, drv_handler))
+		if (wilc_wlan_cfg_commit(wilc, WILC_CFG_QUERY, drv_handler))
 			ret_size = 0;
 
-		if (linux_wlan_lock_timeout(&wilc_dev->cfg_event,
+		if (wilc_lock_timeout(wilc, &wilc->cfg_event,
 					    CFG_PKTS_TIMEOUT)) {
 			PRINT_D(TX_DBG, "Get Timed Out\n");
 			ret_size = 0;
@@ -1587,8 +1589,13 @@ static u32 init_chip(struct net_device *dev)
 {
 	u32 chipid;
 	u32 reg, ret = 0;
+	perInterface_wlan_t *nic;
+	struct wilc *wilc;
+
+	nic = netdev_priv(dev);
+	wilc = nic->wilc;
 
-	acquire_bus(ACQUIRE_ONLY);
+	acquire_bus(wilc, ACQUIRE_ONLY);
 
 	chipid = wilc_get_chipid(true);
 
@@ -1611,7 +1618,7 @@ static u32 init_chip(struct net_device *dev)
 		}
 	}
 
-	release_bus(RELEASE_ONLY);
+	release_bus(wilc, RELEASE_ONLY);
 
 	return ret;
 }
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 90ef650e722d..20bca44bc8ba 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -283,13 +283,13 @@ struct wilc_cfg_rsp {
 
 struct wilc;
 
-int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size);
-int wilc_wlan_start(void);
-int wilc_wlan_stop(void);
+int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer, u32 buffer_size);
+int wilc_wlan_start(struct wilc *);
+int wilc_wlan_stop(struct wilc *);
 int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			      u32 buffer_size, wilc_tx_complete_func_t func);
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count);
-void wilc_handle_isr(void *wilc);
+void wilc_handle_isr(struct wilc *wilc);
 void wilc_wlan_cleanup(struct net_device *dev);
 int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 		      int commit, u32 drv_handler);
@@ -300,7 +300,7 @@ int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 void wilc_chip_sleep_manually(void);
 
 void wilc_enable_tcp_ack_filter(bool value);
-int wilc_wlan_get_num_conn_ifcs(void);
+int wilc_wlan_get_num_conn_ifcs(struct wilc *);
 int wilc_mac_xmit(struct sk_buff *skb, struct net_device *dev);
 
 int wilc_mac_open(struct net_device *ndev);
-- 
2.1.0.rc2

