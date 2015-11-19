Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52414 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721AbbKSCCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 21:02:48 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/4] staging: wilc1000: remove wilc memory allocation config
Date: Thu, 19 Nov 2015 11:05:59 +0900
Message-ID: <1447898761-6938-2-git-send-email-glen.lee@atmel.com> (sfid-20151119_030251_141493_359BF60D)
In-Reply-To: <1447898761-6938-1-git-send-email-glen.lee@atmel.com>
References: <1447898761-6938-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch remove memory allocation options in Kconfig. It was used a long time
ago to aquire memory, which we will not use this config anymore.
Remove it's config, related define and codes as well. We will take
PREALLOCATE_AT_LOADING_DRIVER as it is default.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/Kconfig             | 22 --------------------
 drivers/staging/wilc1000/Makefile            |  6 ------
 drivers/staging/wilc1000/linux_wlan_common.h |  2 --
 drivers/staging/wilc1000/wilc_wlan.c         | 30 ----------------------------
 4 files changed, 60 deletions(-)

diff --git a/drivers/staging/wilc1000/Kconfig b/drivers/staging/wilc1000/Kconfig
index 2923122..dce9cee 100644
--- a/drivers/staging/wilc1000/Kconfig
+++ b/drivers/staging/wilc1000/Kconfig
@@ -31,28 +31,6 @@ config WILC1000_SPI
 	  immediately following reset when pin 9 (SDIO_SPI_CFG) is tied to
 	  VDDIO. Select this if your platform is using the SPI bus.
 
-choice
-        prompt "WILC1000 Memory Allocation"
-        depends on WILC1000
-        default WILC1000_PREALLOCATE_AT_LOADING_DRIVER
-
-config WILC1000_PREALLOCATE_AT_LOADING_DRIVER
-	bool "Preallocate memory at loading driver"
-	---help---
-	  This choice supports static allocation of the memory
-	  for the receive buffer. The driver will allocate the RX buffer
-	  during initial time. The driver will also free the buffer
-	  by calling network device stop.
-
-config WILC1000_DYNAMICALLY_ALLOCATE_MEMROY
-        bool "Dynamically allocate memory in real time"
-        ---help---
-	  This choice supports dynamic allocation of the memory
-	  for the receive buffer. The driver will allocate the RX buffer
-	  when it is required.
-endchoice
-
-
 config WILC1000_HW_OOB_INTR
 	bool "WILC1000 out of band interrupt"
 	depends on WILC1000_SDIO
diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index c55fdd2..cd71be9 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -7,12 +7,6 @@ ccflags-y += -DSTA_FIRMWARE=\"atmel/wilc1000_fw.bin\" \
 ccflags-y += -I$(src)/ -D__CHECK_ENDIAN__ -DWILC_ASIC_A0 -DWILC_DEBUGFS
 #ccflags-y += -DTCP_ACK_FILTER
 
-ccflags-$(CONFIG_WILC1000_PREALLOCATE_AT_LOADING_DRIVER) += -DMEMORY_STATIC \
-								-DWILC_PREALLOC_AT_INSMOD
-
-ccflags-$(CONFIG_WILC1000_DYNAMICALLY_ALLOCATE_MEMROY) += -DWILC_NORMAL_ALLOC
-
-
 wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
 			wilc_msgqueue.o \
 			coreconfigurator.o host_interface.o \
diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index 72b524a..5d40f05 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -124,9 +124,7 @@ extern atomic_t WILC_DEBUG_LEVEL;
 #define FN_IN   /* PRINT_D(">>> \n") */
 #define FN_OUT  /* PRINT_D("<<<\n") */
 
-#ifdef MEMORY_STATIC
 #define LINUX_RX_SIZE	(96 * 1024)
-#endif
 #define LINUX_TX_SIZE	(64 * 1024)
 
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index a73e99f..10def3f 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -12,10 +12,8 @@ typedef struct {
 	u32 cfg_frame_offset;
 	int cfg_seq_no;
 
-	#ifdef MEMORY_STATIC
 	u8 *rx_buffer;
 	u32 rx_buffer_offset;
-	#endif
 	u8 *tx_buffer;
 	u32 tx_buffer_offset;
 
@@ -1050,9 +1048,6 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 			if (offset >= size)
 				break;
 		} while (1);
-#ifndef MEMORY_STATIC
-		kfree(buffer);
-#endif
 		kfree(rqe);
 
 		if (has_packet)
@@ -1097,9 +1092,7 @@ static void wilc_sleeptimer_isr_ext(struct wilc *wilc, u32 int_stats1)
 static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
-#ifdef MEMORY_STATIC
 	u32 offset = p->rx_buffer_offset;
-#endif
 	u8 *buffer = NULL;
 	u32 size;
 	u32 retries = 0;
@@ -1118,7 +1111,6 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 	}
 
 	if (size > 0) {
-#ifdef MEMORY_STATIC
 		if (LINUX_RX_SIZE - offset < size)
 			offset = 0;
 
@@ -1129,13 +1121,6 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 			goto _end_;
 		}
 
-#else
-		buffer = kmalloc(size, GFP_KERNEL);
-		if (!buffer) {
-			usleep_range(100 * 1000, 100 * 1000);
-			goto _end_;
-		}
-#endif
 		p->hif_func.hif_clear_int_ext(wilc,
 					      DATA_INT_CLR | ENABLE_RX_VMM);
 		ret = p->hif_func.hif_block_rx_ext(wilc, 0, buffer, size);
@@ -1146,10 +1131,8 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 		}
 _end_:
 		if (ret) {
-#ifdef MEMORY_STATIC
 			offset += size;
 			p->rx_buffer_offset = offset;
-#endif
 			rqe = kmalloc(sizeof(*rqe), GFP_KERNEL);
 			if (rqe) {
 				rqe->buffer = buffer;
@@ -1157,10 +1140,6 @@ _end_:
 				PRINT_D(RX_DBG, "rxq entery Size= %d - Address = %p\n", rqe->buffer_size, rqe->buffer);
 				wilc_wlan_rxq_add(wilc, rqe);
 			}
-		} else {
-#ifndef MEMORY_STATIC
-			kfree(buffer);
-#endif
 		}
 	}
 	wilc_wlan_handle_rxq(wilc);
@@ -1442,16 +1421,11 @@ void wilc_wlan_cleanup(struct net_device *dev)
 		rqe = wilc_wlan_rxq_remove(wilc);
 		if (!rqe)
 			break;
-#ifndef MEMORY_STATIC
-		kfree(rqe->buffer);
-#endif
 		kfree(rqe);
 	} while (1);
 
-	#ifdef MEMORY_STATIC
 	kfree(p->rx_buffer);
 	p->rx_buffer = NULL;
-	#endif
 	kfree(p->tx_buffer);
 
 	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
@@ -1691,7 +1665,6 @@ int wilc_wlan_init(struct net_device *dev)
 		goto _fail_;
 	}
 
-#if defined(MEMORY_STATIC)
 	if (!g_wlan.rx_buffer)
 		g_wlan.rx_buffer = kmalloc(LINUX_RX_SIZE, GFP_KERNEL);
 	PRINT_D(TX_DBG, "g_wlan.rx_buffer =%p\n", g_wlan.rx_buffer);
@@ -1700,7 +1673,6 @@ int wilc_wlan_init(struct net_device *dev)
 		PRINT_ER("Can't allocate Rx Buffer");
 		goto _fail_;
 	}
-#endif
 
 	if (!init_chip(dev)) {
 		ret = -EIO;
@@ -1714,10 +1686,8 @@ int wilc_wlan_init(struct net_device *dev)
 
 _fail_:
 
-  #ifdef MEMORY_STATIC
 	kfree(g_wlan.rx_buffer);
 	g_wlan.rx_buffer = NULL;
-  #endif
 	kfree(g_wlan.tx_buffer);
 	g_wlan.tx_buffer = NULL;
 
-- 
1.9.1

