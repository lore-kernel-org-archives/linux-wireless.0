Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11188 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbbLUFP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:15:29 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 04/46] staging: wilc1000: use kernel define byte order macros
Date: Mon, 21 Dec 2015 14:18:08 +0900
Message-ID: <1450675130-17866-5-git-send-email-glen.lee@atmel.com> (sfid-20151221_061532_377035_72B3CF87)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes define BIG_ENDIAN and use kernel define byte order macros
instead of swap itself. Remove unused BYTE_SWAP macro and __CHECK_ENDIAN__
in Makefile also.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/Makefile        |  2 +-
 drivers/staging/wilc1000/wilc_sdio.c     |  8 ++------
 drivers/staging/wilc1000/wilc_spi.c      | 16 ++++------------
 drivers/staging/wilc1000/wilc_wlan.c     | 22 ++++++----------------
 drivers/staging/wilc1000/wilc_wlan.h     | 11 -----------
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 16 +++-------------
 6 files changed, 16 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index cd71be9..2076743 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -4,7 +4,7 @@ ccflags-y += -DSTA_FIRMWARE=\"atmel/wilc1000_fw.bin\" \
 		-DAP_FIRMWARE=\"atmel/wilc1000_ap_fw.bin\" \
 		-DP2P_CONCURRENCY_FIRMWARE=\"atmel/wilc1000_p2p_fw.bin\"
 
-ccflags-y += -I$(src)/ -D__CHECK_ENDIAN__ -DWILC_ASIC_A0 -DWILC_DEBUGFS
+ccflags-y += -I$(src)/ -DWILC_ASIC_A0 -DWILC_DEBUGFS
 #ccflags-y += -DTCP_ACK_FILTER
 
 wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index ff7990a..a9ad49f 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -163,9 +163,7 @@ static int sdio_clear_int(struct wilc *wilc)
  ********************************************/
 static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 {
-#ifdef BIG_ENDIAN
-	data = BYTE_SWAP(data);
-#endif
+	data = cpu_to_le32(data);
 
 	if ((addr >= 0xf0) && (addr <= 0xff)) {
 		sdio_cmd52_t cmd;
@@ -330,9 +328,7 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		}
 	}
 
-#ifdef BIG_ENDIAN
-	*data = BYTE_SWAP(*data);
-#endif
+	*data = cpu_to_le32(*data);
 
 	return 1;
 
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index d6f4121..c94d86f 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -529,9 +529,7 @@ static int spi_internal_write(struct wilc *wilc, u32 adr, u32 dat)
 {
 	int result;
 
-#ifdef BIG_ENDIAN
-	dat = BYTE_SWAP(dat);
-#endif
+	dat = cpu_to_le32(dat);
 	result = spi_cmd_complete(wilc, CMD_INTERNAL_WRITE, adr, (u8 *)&dat, 4,
 				  0);
 	if (result != N_OK) {
@@ -552,9 +550,7 @@ static int spi_internal_read(struct wilc *wilc, u32 adr, u32 *data)
 		return 0;
 	}
 
-#ifdef BIG_ENDIAN
-	*data = BYTE_SWAP(*data);
-#endif
+	*data = cpu_to_le32(*data);
 
 	return 1;
 }
@@ -571,9 +567,7 @@ static int wilc_spi_write_reg(struct wilc *wilc, u32 addr, u32 data)
 	u8 cmd = CMD_SINGLE_WRITE;
 	u8 clockless = 0;
 
-#ifdef BIG_ENDIAN
-	data = BYTE_SWAP(data);
-#endif
+	data = cpu_to_le32(data);
 	if (addr < 0x30) {
 		/* Clockless register*/
 		cmd = CMD_INTERNAL_WRITE;
@@ -635,9 +629,7 @@ static int wilc_spi_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		return 0;
 	}
 
-#ifdef BIG_ENDIAN
-	*data = BYTE_SWAP(*data);
-#endif
+	*data = cpu_to_le32(*data);
 
 	return 1;
 }
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 27a44ee..a74a95e 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -759,9 +759,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 					vmm_table[i] |= BIT(10);
 					PRINT_D(TX_DBG, "VMMTable entry changed for CFG packet = %d\n", vmm_table[i]);
 				}
-#ifdef BIG_ENDIAN
-				vmm_table[i] = BYTE_SWAP(vmm_table[i]);
-#endif
+				vmm_table[i] = cpu_to_le32(vmm_table[i]);
 
 				i++;
 				sum += vmm_sz;
@@ -886,9 +884,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 			if (tqe && (vmm_table[i] != 0)) {
 				u32 header, buffer_offset;
 
-#ifdef BIG_ENDIAN
-				vmm_table[i] = BYTE_SWAP(vmm_table[i]);
-#endif
+				vmm_table[i] = cpu_to_le32(vmm_table[i]);
 				vmm_sz = (vmm_table[i] & 0x3ff);
 				vmm_sz *= 4;
 				header = (tqe->type << 31) |
@@ -899,9 +895,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 				else
 					header &= ~BIT(30);
 
-#ifdef BIG_ENDIAN
-				header = BYTE_SWAP(header);
-#endif
+				header = cpu_to_le32(header);
 				memcpy(&txb[offset], &header, 4);
 				if (tqe->type == WILC_CFG_PKT) {
 					buffer_offset = ETH_CONFIG_PKT_HDR_OFFSET;
@@ -993,9 +987,7 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 
 			PRINT_D(RX_DBG, "In the 2nd do-while\n");
 			memcpy(&header, &buffer[offset], 4);
-#ifdef BIG_ENDIAN
-			header = BYTE_SWAP(header);
-#endif
+			header = cpu_to_le32(header);
 			PRINT_D(RX_DBG, "Header = %04x - Offset = %d\n",
 				header, offset);
 
@@ -1194,10 +1186,8 @@ int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer, u32 buffer_
 	do {
 		memcpy(&addr, &buffer[offset], 4);
 		memcpy(&size, &buffer[offset + 4], 4);
-#ifdef BIG_ENDIAN
-		addr = BYTE_SWAP(addr);
-		size = BYTE_SWAP(size);
-#endif
+		addr = cpu_to_le32(addr);
+		size = cpu_to_le32(size);
 		acquire_bus(wilc, ACQUIRE_ONLY);
 		offset += 8;
 		while (((int)size) && (offset < buffer_size)) {
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 27c7bbb..3666453 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -37,17 +37,6 @@
 
 /********************************************
  *
- *      Endian Conversion
- *
- ********************************************/
-
-#define BYTE_SWAP(val)			(((val & 0x000000FF) << 24) + \
-					 ((val & 0x0000FF00) << 8) + \
-					 ((val & 0x00FF0000) >> 8) + \
-					 ((val & 0xFF000000) >> 24))
-
-/********************************************
- *
  *      Register Defines
  *
  ********************************************/
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 274052f..f62c0e6 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -275,9 +275,7 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 	while (size > 0) {
 		i = 0;
 		wid = info[0] | (info[1] << 8);
-#ifdef BIG_ENDIAN
-		wid = BYTE_SWAP(wid);
-#endif
+		wid = cpu_to_le32(wid);
 		PRINT_INFO(GENERIC_DBG, "Processing response for %d seq %d\n", wid, seq++);
 		switch ((wid >> 12) & 0x7) {
 		case WID_CHAR:
@@ -300,11 +298,7 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 					break;
 
 				if (g_cfg_hword[i].id == wid) {
-#ifdef BIG_ENDIAN
-					g_cfg_hword[i].val = (info[3] << 8) | (info[4]);
-#else
-					g_cfg_hword[i].val = info[3] | (info[4] << 8);
-#endif
+					g_cfg_hword[i].val = cpu_to_le16(info[3] | (info[4] << 8));
 					break;
 				}
 				i++;
@@ -318,11 +312,7 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 					break;
 
 				if (g_cfg_word[i].id == wid) {
-#ifdef BIG_ENDIAN
-					g_cfg_word[i].val = (info[3] << 24) | (info[4] << 16) | (info[5] << 8) | (info[6]);
-#else
-					g_cfg_word[i].val = info[3] | (info[4] << 8) | (info[5] << 16) | (info[6] << 24);
-#endif
+					g_cfg_word[i].val = cpu_to_le32(info[3] | (info[4] << 8) | (info[5] << 16) | (info[6] << 24));
 					break;
 				}
 				i++;
-- 
1.9.1

