Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:44995 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbaA3P7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 10:59:34 -0500
Message-ID: <52EA7584.4040508@redpinesignals.com> (sfid-20140130_165938_444207_B3C8ACC3)
Date: Thu, 30 Jan 2014 21:23:40 +0530
From: Jahnavi <jahnavi.meher@redpinesignals.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3.13.1 1/9] rsi: Add RS9113 driver
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>

This driver supports the RS9113 chipset from Redpine Signals Inc. This
chipset supports the 802.11a/b/g/n standards, but this driver currently
supports only b/g/n. Both SDIO and USB interfaces are supported. Can be
upgraded to 91x quite easily. More information can be found at:
http://www.redpinesignals.com/Technologies_&_Chipsets/Chipsets/RS9113.php

Signed-off-by: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
---

Kconfig                      |    1
Makefile                     |    1
rsi/Kconfig                  |   33 +++++
rsi/Makefile                 |    1
rsi/include/rsi_device_ops.h |  121 +++++++++++++++++++++
rsi/include/rsi_hw_intf.h    |  173 ++++++++++++++++++++++++++++++
rsi/include/rsi_mac80211.h   |  154 ++++++++++++++++++++++++++
rsi/include/rsi_main.h       |  110 +++++++++++++++++++
rsi/include/rsi_mgmt.h       |  246 +++++++++++++++++++++++++++++++++++++++++++
9 files changed, 840 insertions(+)

diff -uprN a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
--- a/drivers/net/wireless/Kconfig	2014-01-30 15:53:42.066094019 +0530
+++ b/drivers/net/wireless/Kconfig	2014-01-30 16:01:00.131769914 +0530
@@ -281,5 +281,6 @@ source "drivers/net/wireless/ti/Kconfig"
 source "drivers/net/wireless/zd1211rw/Kconfig"
 source "drivers/net/wireless/mwifiex/Kconfig"
 source "drivers/net/wireless/cw1200/Kconfig"
+source "drivers/net/wireless/rsi/Kconfig"
 
 endif # WLAN
diff -uprN a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
--- a/drivers/net/wireless/Makefile	2014-01-30 15:53:42.051092112 +0530
+++ b/drivers/net/wireless/Makefile	2014-01-30 16:01:00.133770168 +0530
@@ -59,3 +59,4 @@ obj-$(CONFIG_BRCMFMAC)	+= brcm80211/
 obj-$(CONFIG_BRCMSMAC)	+= brcm80211/
 
 obj-$(CONFIG_CW1200)	+= cw1200/
+obj-$(CONFIG_RSI)	+= rsi/
diff -uprN a/drivers/net/wireless/rsi/include/rsi_device_ops.h b/drivers/net/wireless/rsi/include/rsi_device_ops.h
--- a/drivers/net/wireless/rsi/include/rsi_device_ops.h	1970-01-01 05:30:00.000000000 +0530
+++ b/drivers/net/wireless/rsi/include/rsi_device_ops.h	2014-01-30 16:01:00.185776778 +0530
@@ -0,0 +1,121 @@
+/**
+ * @file rsi_device_ops.h
+ * @author
+ * @version 1.0
+ *
+ * @section LICENSE
+ * Copyright (c) 2013 Redpine Signals Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ *
+ * @section DESCRIPTION
+ *
+ * This file contians the data structures and variables/ macros commonly
+ * used in the driver .
+ */
+
+#ifndef __RSI_DEVICE_OPS_H__
+#define __RSI_DEVICE_OPS_H__
+
+#define RSI_HEADER_SIZE                 18
+#define RSI_NEEDED_HEADROOM             80
+#define RSI_RCV_BUFFER_LEN              2000
+#define RSI_RF_TYPE                     1
+#define MAX_MGMT_PKT_SIZE               512
+#define MIN_802_11_HDR_LEN              24
+
+#define RSI_RATE_00                     0x00
+#define RSI_RATE_1                      0x0
+#define RSI_RATE_2                      0x2
+#define RSI_RATE_5_5                    0x4
+#define RSI_RATE_11                     0x6
+#define RSI_RATE_6                      0x8b
+#define RSI_RATE_9                      0x8f
+#define RSI_RATE_12                     0x8a
+#define RSI_RATE_18                     0x8e
+#define RSI_RATE_24                     0x89
+#define RSI_RATE_36                     0x8d
+#define RSI_RATE_48                     0x88
+#define RSI_RATE_54                     0x8c
+#define RSI_RATE_MCS0                   0x100
+#define RSI_RATE_MCS1                   0x101
+#define RSI_RATE_MCS2                   0x102
+#define RSI_RATE_MCS3                   0x103
+#define RSI_RATE_MCS4                   0x104
+#define RSI_RATE_MCS5                   0x105
+#define RSI_RATE_MCS6                   0x106
+#define RSI_RATE_MCS7                   0x107
+#define RSI_RATE_MCS7_SG                0x307
+
+#define BW_20MHZ                        0
+#define BW_40MHZ                        1
+
+static inline unsigned int rsi_get_queueno(unsigned char *addr,
+					   unsigned short offset)
+{
+	return (le16_to_cpu(*(unsigned short *)&addr[offset]) & 0x7000) >> 12;
+}
+
+static inline unsigned int rsi_get_length(unsigned char *addr,
+					  unsigned short offset)
+{
+	return (le16_to_cpu(*(unsigned short *)&addr[offset])) & 0x0fff;
+}
+
+static inline unsigned char rsi_get_extended_desc(unsigned char *addr,
+						  unsigned short offset)
+{
+	return (le16_to_cpu(*(unsigned char *)&addr[offset + 4])) & 0x00ff;
+}
+
+static inline unsigned char rsi_get_rssi(unsigned char *addr)
+{
+	return *(unsigned char *)(addr + FRAME_DESC_SZ);
+}
+
+static inline unsigned char rsi_get_channel(unsigned char *addr)
+{
+	return *(char *)(addr + 15);
+}
+
+int rsi_mgmt_pkt_recv(struct rsi_common *common, unsigned char *msg);
+int rsi_set_vap_capabilities(struct rsi_common *common, unsigned char opmode);
+int rsi_send_ampdu_indication_frame(struct rsi_common *common,
+				    unsigned short tid,
+				    unsigned short ssn, unsigned char buf_size,
+				    unsigned char event);
+int rsi_hal_load_key(struct rsi_common *common, unsigned char *data,
+		     unsigned short key_len, unsigned char key_type,
+		     unsigned char key_id, unsigned int cipher);
+int rsi_set_channel(struct rsi_common *common, unsigned short chno);
+void rsi_inform_bss_status(struct rsi_common *common, unsigned char status,
+			   const unsigned char *bssid, unsigned char qos_enable,
+			   unsigned short aid);
+int rsi_send_mgmt_pkt(struct rsi_common *common, struct sk_buff *skb);
+int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb);
+void rsi_interrupt_handler(struct rsi_common *common);
+void rsi_tx_scheduler_thread(struct rsi_common *common);
+#ifdef USE_USB_INTF
+void rsi_usb_rx_thread(struct rsi_common *common);
+#endif
+int rsi_device_init(struct rsi_common *common, unsigned short fw_status);
+int rsi_device_deinit(struct rsi_hw *adapter);
+int rsi_set_default_parameters(struct rsi_common *common);
+void rsi_indicate_pkt_to_os(struct rsi_common *common, struct sk_buff *skb);
+int rsi_mac80211_attach(struct rsi_common *common);
+void rsi_mac80211_detach(struct rsi_hw *hw);
+void rsi_indicate_tx_status(struct rsi_hw *common, struct sk_buff *skb,
+			    int status);
+bool rsi_is_cipher_wep(struct rsi_common *common);
+unsigned short rsi_get_connected_channel(struct rsi_hw *adapter);
+#endif
diff -uprN a/drivers/net/wireless/rsi/include/rsi_hw_intf.h b/drivers/net/wireless/rsi/include/rsi_hw_intf.h
--- a/drivers/net/wireless/rsi/include/rsi_hw_intf.h	1970-01-01 05:30:00.000000000 +0530
+++ b/drivers/net/wireless/rsi/include/rsi_hw_intf.h	2014-01-30 16:01:00.187777032 +0530
@@ -0,0 +1,173 @@
+/**
+ * @file rsi_hw_intf.h
+ * @author
+ * @version 1.0
+ *
+ * @section LICENSE
+ * Copyright (c) 2013 Redpine Signals Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ *
+ * @section DESCRIPTION
+ *
+ * This file contians the function prototypes of related to sdio/usb interface
+ *
+ */
+
+#ifndef __RSI_HW_INTF__
+#define __RSI_HW_INTF__
+
+#ifdef USE_USB_INTF
+#include <linux/usb.h>
+#else
+#include <linux/mmc/card.h>
+#include <linux/mmc/mmc.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio.h>
+#include <linux/mmc/sd.h>
+#include <linux/mmc/sdio_ids.h>
+#endif
+
+#ifdef USE_SDIO_INTF
+enum SDIO_INTERRUPT_TYPE {
+	BUFFER_FULL         = 0x0,
+	BUFFER_AVAILABLE    = 0x1,
+	FIRMWARE_ASSERT_IND = 0x3,
+	MSDU_PACKET_PENDING = 0x4,
+	SLEEP_INDCN         = 0X5,
+	WAKEUP_INDCN        = 0x6,
+	SEMI_BUFFER_FULL    = 0x7,
+	MGMT_BUFFER_FULL    = 0x8,
+	VI_STARTVING        = 0X9,
+	VO_STARTVING        = 0xA,
+	BE_STARTVING        = 0xB,
+	BK_STARTVING        = 0xC,
+	UNKNOWN_INT         = 0XE
+};
+
+typedef void (*SD_INTERRUPT)(void *pcontext);
+
+#define SDIO_BLOCK_SIZE                         256
+#define RSI_SD_REQUEST_MASTER                   0x10000
+#define RSI_SDIO_INTERRUPT_ENABLE_REGISTER      0x04
+#define RSI_VENDOR_SPECIFIC_REGISTER_1          0xf1
+#define RSI_DEVICE_BUFFER_STATUS_REGISTER       0xf3
+#define RSI_NEXT_READ_DELAY_REGISTER_1          0xf4
+#define RSI_NEXT_READ_DELAY_REGISTER_2          0xf5
+#define RSI_VERSION_NO                          0xf8
+#define RSI_FN1_INT_REGISTER                    0xf9
+#define RSI_RFIFO_START_LEVEL_REGISTER          0xfc
+#define RSI_RFIFO_AFULL_LEVEL_REGISTER          0xfd
+#define RSI_WFIFO_AEMPTY_LEVEL_REGISTER         0xfe
+#define RSI_WAKEUP_REGISTER                     0xff
+#define SDIO_MASTER_ACCESS_MSBYTE               0x000FA
+#define SDIO_MASTER_ACCESS_LSBYTE               0x000FB
+#define RSI_DESC_QUEUE_NUM_MASK                 0x7
+
+/* Interrupt Bit Related Macros */
+#define PKT_BUFF_SEMI_FULL                      0
+#define PKT_BUFF_FULL                           1
+#define PKT_MGMT_BUFF_FULL                      2
+#define MSDU_PKT_PENDING                        3
+#define VI_STARVING                             4
+#define VO_STARVING                             5
+#define BE_STARVING                             6
+#define BK_STARVING                             7
+#define PKT_BUFF_AVAILABLE                      0
+#define FW_ASSERT_IND                           2
+
+/* FOR SD CARD ONLY */
+#define SDIO_RX_NUM_BLOCKS_REG                  0x000F1
+#define SDIO_FW_STATUS_REG                      0x000F2
+#define SDIO_NXT_RD_DELAY2                      0x000F5
+#define SDIO_FUN1_INT_REG                       0x000F9
+#define SDIO_READ_START_LVL                     0x000FC
+#define SDIO_READ_FIFO_CTL                      0x000FD
+#define SDIO_WRITE_FIFO_CTL                     0x000FE
+#define SDIO_WAKEUP_REG                         0x000FF
+#define SD_REQUEST_MASTER                       0x10000
+#define SDIO_FUN1_INTR_CLR_REG                  0x0008
+
+#define CCCR_REVISION                           0x00
+#define SD_SPEC_REVISION                        0x01
+#define SD_IO_ENABLE                            0x02
+#define SD_IO_READY                             0x03
+#define SD_INT_ENABLE                           0x04
+#define SD_INT_PENDING                          0x05
+#define SD_IO_ABART                             0x06
+#define SD_BUS_IF_CNT                           0x07
+#define SD_CARD_CAPABILITY                      0x08
+
+/* PTR to CARD'S COMMON CARD INFO STRUCT(CIS):0x09-0x0B*/
+#define SD_CIS_PTR                              0x09
+#define SD_BUS_SUSPEND                          0x0C
+#define SD_FUNCTION_SELEC                       0x0D
+#define SD_EXEC_FLAGS                           0x0E
+#define SD_READY_FLAGS                          0x0F
+#define SD_FN0_BLK_SZ                           0x10
+#define SD_RESERVED                             0x12
+#define SDIO_REG_HIGH_SPEED                     0x13
+
+#define RSI_GET_SDIO_INTERRUPT_TYPE(_I, TYPE)      \
+	{					   \
+		TYPE =                             \
+		(_I & (1 << PKT_BUFF_AVAILABLE)) ? \
+		BUFFER_AVAILABLE :		   \
+		(_I & (1 << MSDU_PKT_PENDING)) ?   \
+		MSDU_PACKET_PENDING :              \
+		(_I & (1 << FW_ASSERT_IND)) ?      \
+		FIRMWARE_ASSERT_IND : UNKNOWN_INT; \
+	}
+#endif
+
+#ifdef USE_USB_INTF
+#define WATCH_DOG_TIMER_1            0x16c
+#define WATCH_DOG_TIMER_2            0x16d
+#define WATCH_DOG_DELAY_TIMER_1      0x16e
+#define WATCH_DOG_DELAY_TIMER_2      0x16f
+#define WATCH_DOG_TIMER_ENABLE       0x170
+
+#define RESTART_WDT                  BIT(11)
+#define BYPASS_ULP_ON_WDT            BIT(1)
+
+#define RF_SPI_PROG_REG_BASE_ADDR    0x40080000
+#define GSPI_CTRL_REG0               (RF_SPI_PROG_REG_BASE_ADDR)
+#define GSPI_CTRL_REG1               (RF_SPI_PROG_REG_BASE_ADDR + 0x2)
+#define GSPI_DATA_REG0               (RF_SPI_PROG_REG_BASE_ADDR + 0x4)
+#define GSPI_DATA_REG1               (RF_SPI_PROG_REG_BASE_ADDR + 0x6)
+#define GSPI_DATA_REG2               (RF_SPI_PROG_REG_BASE_ADDR + 0x8)
+#define GSPI_2_ULP                   BIT(12)
+#define GSPI_TRIG                    BIT(7)
+#define GSPI_READ                    BIT(6)
+#define GSPI_RF_SPI_ACTIVE           BIT(8)
+#endif
+
+/* common registers in SDIO function1 */
+#define TA_SOFT_RESET_REG            0x0004
+#define TA_TH0_PC_REG                0x0400
+#define TA_HOLD_THREAD_REG           0x0844
+#define TA_RELEASE_THREAD_REG        0x0848
+
+#define TA_SOFT_RST_CLR              0
+#define TA_SOFT_RST_SET              BIT(0)
+#define TA_PC_ZERO                   0
+#define TA_HOLD_THREAD_VALUE         cpu_to_le32(0xF)
+#define TA_RELEASE_THREAD_VALUE      cpu_to_le32(0xF)
+
+#ifdef USE_USB_INTF
+#define USB_VENDOR_REGISTER_READ     0x15
+#define USB_VENDOR_REGISTER_WRITE    0x16
+#define RSI_USB_TX_HEAD_ROOM         128
+#endif
+#endif
diff -uprN a/drivers/net/wireless/rsi/include/rsi_mac80211.h b/drivers/net/wireless/rsi/include/rsi_mac80211.h
--- a/drivers/net/wireless/rsi/include/rsi_mac80211.h	1970-01-01 05:30:00.000000000 +0530
+++ b/drivers/net/wireless/rsi/include/rsi_mac80211.h	2014-01-30 16:01:00.194777922 +0530
@@ -0,0 +1,154 @@
+/**
+ * @file rsi_mac80211.h
+ * @author
+ * @version 1.0
+ *
+ * @section LICENSE
+ * Copyright (c) 2013 Redpine Signals Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ *
+ * @section DESCRIPTION
+ *
+ * This file contians the mac80211 include files and structures and functions
+ *
+ */
+
+#ifndef __RSI_MAC80211__H__
+#define __RSI_MAC80211__H__
+
+#define MAX_RETRIES                     8
+
+#define STD_RATE_MCS7                   0x07
+#define STD_RATE_MCS6                   0x06
+#define STD_RATE_MCS5                   0x05
+#define STD_RATE_MCS4                   0x04
+#define STD_RATE_MCS3                   0x03
+#define STD_RATE_MCS2                   0x02
+#define STD_RATE_MCS1                   0x01
+#define STD_RATE_MCS0                   0x00
+#define STD_RATE_54                     0x6c
+#define STD_RATE_48                     0x60
+#define STD_RATE_36                     0x48
+#define STD_RATE_24                     0x30
+#define STD_RATE_18                     0x24
+#define STD_RATE_12                     0x18
+#define STD_RATE_11                     0x16
+#define STD_RATE_09                     0x12
+#define STD_RATE_06                     0x0C
+#define STD_RATE_5_5                    0x0B
+#define STD_RATE_02                     0x04
+#define STD_RATE_01                     0x02
+
+static const struct ieee80211_channel rsi_2ghz_channels[] = {
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2412,
+	  .hw_value = 1 }, /* Channel 1 */
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2417,
+	  .hw_value = 2 }, /* Channel 2 */
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2422,
+	  .hw_value = 3 }, /* Channel 3 */
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2427,
+	  .hw_value = 4 }, /* Channel 4 */
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2432,
+	  .hw_value = 5 }, /* Channel 5 */
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2437,
+	  .hw_value = 6 }, /* Channel 6 */
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2442,
+	  .hw_value = 7 }, /* Channel 7 */
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2447,
+	  .hw_value = 8 }, /* Channel 8 */
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2452,
+	  .hw_value = 9 }, /* Channel 9 */
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2457,
+	  .hw_value = 10 }, /* Channel 10 */
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2462,
+	  .hw_value = 11 }, /* Channel 11 */
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2467,
+	  .hw_value = 12 }, /* Channel 12 */
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2472,
+	  .hw_value = 13 }, /* Channel 13 */
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2484,
+	  .hw_value = 14 }, /* Channel 14 */
+};
+
+static const struct ieee80211_channel rsi_5ghz_channels[] = {
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5180,
+	  .hw_value = 36,  }, /* Channel 36 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5200,
+	  .hw_value = 40, }, /* Channel 40 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5220,
+	  .hw_value = 44, }, /* Channel 44 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5240,
+	  .hw_value = 48, }, /* Channel 48 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5260,
+	  .hw_value = 52, }, /* Channel 52 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5280,
+	  .hw_value = 56, }, /* Channel 56 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5300,
+	  .hw_value = 60, }, /* Channel 60 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5320,
+	  .hw_value = 64, }, /* Channel 64 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5500,
+	  .hw_value = 100, }, /* Channel 100 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5520,
+	  .hw_value = 104, }, /* Channel 104 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5540,
+	  .hw_value = 108, }, /* Channel 108 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5560,
+	  .hw_value = 112, }, /* Channel 112 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5580,
+	  .hw_value = 116, }, /* Channel 116 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5600,
+	  .hw_value = 120, }, /* Channel 120 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5620,
+	  .hw_value = 124, }, /* Channel 124 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5640,
+	  .hw_value = 128, }, /* Channel 128 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5660,
+	  .hw_value = 132, }, /* Channel 132 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5680,
+	  .hw_value = 136, }, /* Channel 136 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5700,
+	  .hw_value = 140, }, /* Channel 140 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5745,
+	  .hw_value = 149, }, /* Channel 149 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5765,
+	  .hw_value = 153, }, /* Channel 153 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5785,
+	  .hw_value = 157, }, /* Channel 157 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5805,
+	  .hw_value = 161, }, /* Channel 161 */
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5825,
+	  .hw_value = 165, }, /* Channel 165 */
+};
+
+static struct ieee80211_rate rsi_rates[] = {
+	{ .bitrate = STD_RATE_01  * 5, .hw_value = RSI_RATE_1 },
+	{ .bitrate = STD_RATE_02  * 5, .hw_value = RSI_RATE_2 },
+	{ .bitrate = STD_RATE_5_5 * 5, .hw_value = RSI_RATE_5_5 },
+	{ .bitrate = STD_RATE_11  * 5, .hw_value = RSI_RATE_11 },
+	{ .bitrate = STD_RATE_06  * 5, .hw_value = RSI_RATE_6 },
+	{ .bitrate = STD_RATE_09  * 5, .hw_value = RSI_RATE_9 },
+	{ .bitrate = STD_RATE_12  * 5, .hw_value = RSI_RATE_12 },
+	{ .bitrate = STD_RATE_18  * 5, .hw_value = RSI_RATE_18 },
+	{ .bitrate = STD_RATE_24  * 5, .hw_value = RSI_RATE_24 },
+	{ .bitrate = STD_RATE_36  * 5, .hw_value = RSI_RATE_36 },
+	{ .bitrate = STD_RATE_48  * 5, .hw_value = RSI_RATE_48 },
+	{ .bitrate = STD_RATE_54  * 5, .hw_value = RSI_RATE_54 },
+};
+
+static const unsigned short rsi_mcsrates[] = {
+	RSI_RATE_MCS0, RSI_RATE_MCS1, RSI_RATE_MCS2, RSI_RATE_MCS3,
+	RSI_RATE_MCS4, RSI_RATE_MCS5, RSI_RATE_MCS6, RSI_RATE_MCS7
+};
+#endif
diff -uprN a/drivers/net/wireless/rsi/include/rsi_main.h b/drivers/net/wireless/rsi/include/rsi_main.h
--- a/drivers/net/wireless/rsi/include/rsi_main.h	1970-01-01 05:30:00.000000000 +0530
+++ b/drivers/net/wireless/rsi/include/rsi_main.h	2014-01-30 16:01:00.197778303 +0530
@@ -0,0 +1,110 @@
+/**
+ * @file rsi_main.h
+ * @author
+ * @version 1.0
+ *
+ * @section LICENSE
+ * Copyright (c) 2013 Redpine Signals Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ *
+ * @section DESCRIPTION
+ *
+ * This file contians the os dependent( Linux) specific function prototypes
+ * and macros
+ */
+
+#ifndef __RSI_MAIN_H__
+#define __RSI_MAIN_H__
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+#ifdef USE_USB_INTF
+#include <linux/usb.h>
+#endif
+#include <net/mac80211.h>
+#include "rsi_common.h"
+
+#define MAX_RX_URBS                     1
+#define MAX_BULK_EP                     8
+
+struct rsi_hw {
+	struct rsi_common *priv;
+	struct ieee80211_hw *hw;
+	struct ieee80211_vif *vifs[RSI_MAX_VIFS];
+	struct ieee80211_tx_queue_params edca_params[NUM_EDCA_QUEUES];
+	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
+
+	struct device *device;
+	unsigned char sc_nvifs;
+
+	struct proc_dir_entry *proc_entry;
+#ifdef USE_SDIO_INTF
+	struct sdio_func *pfunction;
+	struct task_struct *in_sdio_litefi_irq;
+	unsigned int next_read_delay;
+	unsigned int sdio_high_speed_enable;
+	unsigned char sdio_clock_speed;
+	unsigned int rx_blk_size;
+	unsigned int cardcapability;
+	unsigned char stop_card_write;
+	unsigned char prev_desc[FRAME_DESC_SZ];
+#else
+	unsigned char endpoint;
+	struct usb_device *usbdev;
+	struct usb_interface *pfunction;
+	struct urb *rx_usb_urb[MAX_RX_URBS];
+	unsigned char *tx_buffer;
+	unsigned int bulkin_size;
+	unsigned char bulkin_endpoint_addr;
+	unsigned int bulkout_size[MAX_BULK_EP];
+	unsigned char bulkout_endpoint_addr[MAX_BULK_EP];
+	unsigned int total_usb_rx_urbs_submitted;
+	unsigned int total_usb_rx_urbs_done;
+	unsigned int usb_rx_thread_exit;
+#endif
+	unsigned int tx_blk_size;
+	unsigned char write_fail;
+};
+
+void rsi_set_event(struct rsi_event *event);
+int rsi_wait_event(struct rsi_event *event, unsigned int timeout);
+void rsi_reset_event(struct rsi_event *event);
+struct rsi_hw *rsi_init_os_intf_ops(void);
+void rsi_deinit_os_intf_ops(struct rsi_hw *adapter);
+void rsi_core_qos_processor(struct rsi_common *common);
+int rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb);
+struct rsi_common_ops *rsi_get_common_ops(void);
+#ifdef USE_USB_INTF
+int rsi_write_ta_register_multiple(struct rsi_hw *adapter, unsigned int addr,
+				   unsigned char *data, unsigned int count);
+int rsi_rx_urb_submit(struct rsi_hw *adapter);
+int rsi_write_pkt(struct rsi_hw *adapter, unsigned char *pkt, unsigned int len);
+#else
+void rsi_ack_interrupt(struct rsi_hw *adapter, unsigned char int_bit);
+int rsi_read_register_multiple(struct rsi_hw *adapter, unsigned int addr,
+			       unsigned int count, unsigned char *data);
+int rsi_host_intf_read_pkt(struct rsi_hw *adapter, unsigned char *pkt,
+			   unsigned int len);
+int rsi_host_intf_write_pkt(struct rsi_hw *adapter, unsigned char *pkt,
+			    unsigned int len);
+int rsi_write_register_multiple(struct rsi_hw *adapter, unsigned int addr,
+				unsigned char *data, unsigned int count);
+int rsi_write_register(struct rsi_hw *adapter, unsigned char fun_num,
+		       unsigned int addr, unsigned char *data);
+int rsi_read_register(struct rsi_hw *adapter, unsigned int addr,
+		      unsigned char *data);
+#endif
+void rsi_print(int zone, unsigned char *vdata, int len);
+#endif
diff -uprN a/drivers/net/wireless/rsi/include/rsi_mgmt.h b/drivers/net/wireless/rsi/include/rsi_mgmt.h
--- a/drivers/net/wireless/rsi/include/rsi_mgmt.h	1970-01-01 05:30:00.000000000 +0530
+++ b/drivers/net/wireless/rsi/include/rsi_mgmt.h	2014-01-30 16:01:00.201778811 +0530
@@ -0,0 +1,246 @@
+/**
+ * @file rsi_mgmt.h
+ * @author
+ * @version 1.0
+ *
+ * @section LICENSE
+ * Copyright (c) 2013 Redpine Signals Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ *
+ * @section DESCRIPTION
+ *
+ * This file contians the datastructures / macros and function prototypes
+ * related to management module
+ *
+ */
+
+#ifndef __RSI_MGMT_H__
+#define __RSI_MGMT_H__
+
+#include <linux/sort.h>
+#include "rsi_boot_params.h"
+
+#define RSI_11B_MODE                    0
+#define RSI_11G_MODE                    BIT(7)
+#define RSI_11N_MODE                    BIT(8)
+#define RSI_11AC_MODE                   (BIT(7) | (BIT(8)))
+#define RETRY_COUNT                     8
+
+/* Receive Frame Types */
+#define MGMT_PPE_DEBUG_FRAME            0x82
+#define TA_CONFIRM_TYPE                 0x01
+#define RX_DOT11_MGMT                   0x02
+#define TX_STATUS_IND			0x04
+#define PROBEREQ_CONFIRM                2
+#define CARD_READY_IND                  0x0000
+
+#define RSI_DELETE_PEER                 0x0
+#define RSI_ADD_PEER                    0x1
+#define START_AMPDU_AGGR                0x1
+#define STOP_AMPDU_AGGR                 0x0
+#define INTERNAL_MGMT_PKT               0x99
+
+#define RSI_SELF_CTS_ENABLE             BIT(1)
+#define BBP_REMOVE_SOFT_RST_BEFORE_PROG BIT(0)
+#define BBP_REMOVE_SOFT_RST_AFTER_PROG  BIT(1)
+#define BBP_REG_READ                    BIT(2)
+#define PUT_BBP_RESET                   0
+#define BBP_REG_WRITE                   0
+#define BBP_REG_READ                    BIT(2)
+#define RF_RESET_ENABLE                 BIT(3)
+#define ULP_MODE                        BIT(0)
+
+#define RATE_INFO_ENABLE                BIT(0)
+#define RSI_BROADCAST_PKT               BIT(9)
+
+#define UPPER_20_ENABLE                 (0x2 << 12)
+#define LOWER_20_ENABLE                 (0x4 << 12)
+#define FULL40M_ENABLE                  0x6
+
+#define RSI_LMAC_CLOCK_40MHZ            0x0
+#define RSI_LMAC_CLOCK_80MHZ            0x1
+#define RSI_LMAC_CLOCK_160MHZ           0x2
+#define RSI_LMAC_CLOCK_320MHZ           0x3
+
+#define RSI_ENABLE_20MHZ                (0x0 << 3)
+#define RSI_ENABLE_40MHZ                (0x1 << 3)
+#define RSI_ENABLE_80MHZ                (0x2 << 3)
+
+#define RX_BA_INDICATION                1
+
+#define CONNECTED_SLEEP_ENABLE          1
+#define DEEP_SLEEP_ENABLE               2
+#define WAKEUP                          3
+
+#define WAKE_UP_HOST_REQ                BIT(0)
+#define WAKE_UP_GPIO_REQ                BIT(1)
+#define WAKE_UP_GEN_SLEEP_CLK_TOUT      BIT(2)
+#define WAKE_UP_PROCESSOR_REQ           BIT(3)
+#define WAKE_UP_SLEEP_TOUT              BIT(3)
+#define WAKE_UP_ULP_WATCHDOG_TOUT       BIT(4)
+#define WAKE_UP_GPIO_LEVEL_BASED        BIT(5)
+#define WAKE_UP_GPIO_RISE_EDGE          BIT(6)
+#define WAKE_UP_GPIO_FALL_EDGE          BIT(7)
+#define LP_MODE                         0
+
+#define RSI_TBL_SZ                      40
+
+/* Send Frames Types */
+enum cmd_frame_type {
+	TX_DOT11_MGMT,
+	RESET_MAC_REQ,
+	RADIO_CAPABILITIES,
+	BB_PROG_VALUES_REQUEST,
+	RF_PROG_VALUES_REQUEST,
+	WAKEUP_SLEEP_REQUEST,
+	SCAN_REQUEST,
+	TSF_UPDATE,
+	PEER_NOTIFY,
+	BLOCK_UNBLOCK,
+	SET_KEY_REQ,
+	AUTO_RATE_IND,
+	BOOTUP_PARAMS_REQUEST,
+	VAP_CAPABILITIES,
+	EEPROM_READ_TYPE ,
+	EEPROM_WRITE,
+	GPIO_PIN_CONFIG ,
+	SET_RX_FILTER,
+	AMPDU_IND,
+	STATS_REQUEST_FRAME,
+	BB_BUF_PROG_VALUES_REQ,
+	BBP_PROG_IN_TA,
+	BG_SCAN_PARAMS,
+	BG_SCAN_PROBE_REQ,
+	CW_MODE_REQ,
+	PER_CMD_PKT
+};
+
+struct module_ps_config {
+	unsigned int not_in_use:1;
+	unsigned int clock_gate:1;
+	unsigned int logical_prgm:1;
+	unsigned int logical_poweroff:1;
+	unsigned int power_off:1;
+	unsigned int resvd:27;
+};
+
+struct lp_mode_params {
+	unsigned int type_of_wakeup;
+	unsigned int wakeup_threshold[8];
+};
+
+struct ulp_ram_supply {
+	unsigned int ram_retention:1;
+	unsigned int ram_voltage:31;
+};
+
+struct ulp_mode_params {
+	unsigned int type_of_wakeup;
+	unsigned int wakeup_threshold[8];
+	struct ulp_ram_supply ram_supply;
+};
+
+struct pm_levels {
+	struct module_ps_config rf_ps_config;
+	struct module_ps_config bb_ps_config;
+	struct module_ps_config wlan_ps_config;
+	struct module_ps_config bt_zb_ps_config;
+	struct module_ps_config afe_ps_config;
+	struct module_ps_config pll_ps_config;
+};
+
+struct pm_config {
+	struct pm_levels config_module;
+	unsigned int sleep_duration[2];
+	unsigned int lp_or_ulp_mode;
+	struct lp_mode_params lp_mode_params;
+	struct ulp_mode_params ulp_mode_params;
+	unsigned int node_deregister;
+	unsigned int sleep_level;
+	unsigned int sleep_type;
+	struct pm_config *next;
+};
+
+struct rsi_mac_frame {
+	union {
+		unsigned short desc_word[8];
+		unsigned char desc_byte[16];
+		struct {
+			unsigned char frame_len;
+			unsigned char frame_type;
+		};
+	};
+	union {
+		struct  {
+			unsigned short rf_prog_vals[100];
+		} rf_prog_req;
+
+		struct  {
+			struct {
+				unsigned short cont_win_min_q;
+				unsigned short cont_win_max_q;
+				unsigned short aifsn_val_q;
+				unsigned short txop_q;
+			} qos_params[MAX_HW_QUEUES];
+
+			unsigned char num_11n_rates;
+			unsigned char num_11ac_rates;
+			unsigned short gcpd_per_rate[20];
+		} radio_caps;
+
+		struct  {
+			unsigned char mac_addr[6];
+			unsigned short command;
+			unsigned short mpdu_density;
+			unsigned short reserved;
+			unsigned int sta_flags;
+		} peer_notify;
+
+		struct  {
+			unsigned char mac_addr[6];
+			unsigned short keep_alive_period;
+			unsigned char bssid[6];
+			unsigned short reserved;
+			unsigned int flags;
+			unsigned short frag_threshold;
+			unsigned short rts_threshold;
+			unsigned int default_mgmt_rate_bbpinfo;
+			unsigned int default_ctrl_rate_bbpinfo;
+			unsigned int default_data_rate_bbpinfo;
+			unsigned short beacon_interval;
+			unsigned short dtim_period;
+		} vap_caps;
+
+		struct  {
+			unsigned char key[4][32];
+			unsigned char tx_mic_key[8];
+			unsigned char rx_mic_key[8];
+		} set_key;
+
+		struct  {
+			unsigned short failure_limit;
+			unsigned short initial_boundary;
+			unsigned short max_threshold_limt;
+			unsigned short num_supported_rates;
+			unsigned short aarf_rssi;
+			unsigned short moderate_rate_inx;
+			unsigned short collision_tolerance;
+			unsigned short  supported_rates[40];
+		} auto_rate;
+
+		struct bootup_params bootup_params;
+		struct pm_config ps_params;
+	} u;
+};
+#endif
diff -uprN a/drivers/net/wireless/rsi/Kconfig b/drivers/net/wireless/rsi/Kconfig
--- a/drivers/net/wireless/rsi/Kconfig	1970-01-01 05:30:00.000000000 +0530
+++ b/drivers/net/wireless/rsi/Kconfig	2014-01-30 16:01:00.204779193 +0530
@@ -0,0 +1,33 @@
+menuconfig RSI
+	bool "Redpine Signals Inc Wireless Chipset"
+	default y
+	---help---
+	  This will enable support for RSI wireless chips
+
+config RSI_91x
+	tristate "Redpine Signals Inc 1x1 device support"
+	depends on RSI && MAC80211
+	default m
+	---help---
+	  This option enabes support for RSI 1x1 devices.
+	  Select M (recommended), if you have a RSI 1x1 wireless module.
+
+choice
+	prompt "Redpine Signals Inc hardware interface support"
+	depends on RSI_91x
+	default RSI_USB
+
+config RSI_USB
+	bool "Redpine Signals USB bus support"
+	depends on USB && RSI_91x
+	---help---
+	  This option enables the USB bus support in rsi drivers.
+	  Select Y, if you have a RSI USB 1x1 wireless module.
+
+config RSI_SDIO
+	bool "Redpine Signals SDIO bus support"
+	depends on MMC && RSI_91x
+	---help---
+	  This option enables the SDIO bus support in rsi drivers.
+	  Select Y, if you have a RSI SDIO 1x1 wireless module.
+endchoice
diff -uprN a/drivers/net/wireless/rsi/Makefile b/drivers/net/wireless/rsi/Makefile
--- a/drivers/net/wireless/rsi/Makefile	1970-01-01 05:30:00.000000000 +0530
+++ b/drivers/net/wireless/rsi/Makefile	2014-01-30 16:01:00.206779447 +0530
@@ -0,0 +1 @@
+obj-$(CONFIG_RSI_91x) := 91x/ common/


