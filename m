Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:14807 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730915AbeHAMyM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 08:54:12 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 2/2] staging: wilc1000: fix endianness warnings reported by sparse
Date: Wed, 1 Aug 2018 16:41:00 +0530
Message-ID: <1533121860-20820-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180801_130859_885100_A0A672A7)
In-Reply-To: <1533121860-20820-1-git-send-email-ajay.kathat@microchip.com>
References: <1533121860-20820-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the sparse warnings by making use of le32_to_cpus() &
cpu_to_le32s() conversion API's.
Remove the unnecessary byte-order conversion in
wilc_wlan_parse_response_frame() as the data is copied using individual
byte operation.

Also added the byte-order conversion for 'header' in
wilc_wfi_monitor_rx() & wilc_wfi_p2p_rx() as received in LE byte-order.

The link [1] contains the details of discussion related to this patch.

[1]. https://patchwork.kernel.org/patch/10436791/

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_mon.c              |  1 +
 drivers/staging/wilc1000/wilc_sdio.c              |  4 ++--
 drivers/staging/wilc1000/wilc_spi.c               |  8 ++++----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  6 ++++--
 drivers/staging/wilc1000/wilc_wlan.c              | 12 ++++++------
 drivers/staging/wilc1000/wilc_wlan_cfg.c          | 21 ++++++++++-----------
 6 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 14405bf..020383c 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -39,6 +39,7 @@ void wilc_wfi_monitor_rx(u8 *buff, u32 size)
 
 	/* Get WILC header */
 	memcpy(&header, (buff - HOST_HDR_OFFSET), HOST_HDR_OFFSET);
+	le32_to_cpus(&header);
 	/*
 	 * The packet offset field contain info about what type of management
 	 * the frame we are dealing with and ack status
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 8a47147..459eb11 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -384,7 +384,7 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 	struct sdio_func *func = dev_to_sdio_func(wilc->dev);
 	int ret;
 
-	data = cpu_to_le32(data);
+	cpu_to_le32s(&data);
 
 	if (addr >= 0xf0 && addr <= 0xff) {
 		struct sdio_cmd52 cmd;
@@ -563,7 +563,7 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		}
 	}
 
-	*data = cpu_to_le32(*data);
+	le32_to_cpus(*data);
 
 	return 1;
 
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index fa9371b..bb2c738 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -678,7 +678,7 @@ static int spi_internal_write(struct wilc *wilc, u32 adr, u32 dat)
 	struct spi_device *spi = to_spi_device(wilc->dev);
 	int result;
 
-	dat = cpu_to_le32(dat);
+	cpu_to_le32s(&dat);
 	result = spi_cmd_complete(wilc, CMD_INTERNAL_WRITE, adr, (u8 *)&dat, 4,
 				  0);
 	if (result != N_OK)
@@ -699,7 +699,7 @@ static int spi_internal_read(struct wilc *wilc, u32 adr, u32 *data)
 		return 0;
 	}
 
-	*data = cpu_to_le32(*data);
+	le32_to_cpus(*data);
 
 	return 1;
 }
@@ -717,7 +717,7 @@ static int wilc_spi_write_reg(struct wilc *wilc, u32 addr, u32 data)
 	u8 cmd = CMD_SINGLE_WRITE;
 	u8 clockless = 0;
 
-	data = cpu_to_le32(data);
+	cpu_to_le32s(&data);
 	if (addr < 0x30) {
 		/* Clockless register */
 		cmd = CMD_INTERNAL_WRITE;
@@ -779,7 +779,7 @@ static int wilc_spi_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		return 0;
 	}
 
-	*data = cpu_to_le32(*data);
+	le32_to_cpus(*data);
 
 	return 1;
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 42c0128..c6f2cf6 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1363,9 +1363,10 @@ void wilc_wfi_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 	struct host_if_drv *wfi_drv = priv->hif_drv;
 	u32 header, pkt_offset;
 	s32 freq;
+	__le16 fc;
 
 	memcpy(&header, (buff - HOST_HDR_OFFSET), HOST_HDR_OFFSET);
-
+	le32_to_cpus(&header);
 	pkt_offset = GET_PKT_OFFSET(header);
 
 	if (pkt_offset & IS_MANAGMEMENT_CALLBACK) {
@@ -1382,7 +1383,8 @@ void wilc_wfi_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 
 	freq = ieee80211_channel_to_frequency(curr_channel, NL80211_BAND_2GHZ);
 
-	if (!ieee80211_is_action(buff[FRAME_TYPE_ID])) {
+	fc = ((struct ieee80211_hdr *)buff)->frame_control;
+	if (!ieee80211_is_action(fc)) {
 		cfg80211_rx_mgmt(priv->wdev, freq, 0, buff, size, 0);
 		return;
 	}
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index ea2e77f..cde5ce1 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -541,7 +541,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 			vmm_table[i] = vmm_sz / 4;
 			if (tqe->type == WILC_CFG_PKT)
 				vmm_table[i] |= BIT(10);
-			vmm_table[i] = cpu_to_le32(vmm_table[i]);
+			cpu_to_le32s(&vmm_table[i]);
 
 			i++;
 			sum += vmm_sz;
@@ -644,7 +644,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 		if (vmm_table[i] == 0)
 			break;
 
-		vmm_table[i] = cpu_to_le32(vmm_table[i]);
+		le32_to_cpus(&vmm_table[i]);
 		vmm_sz = (vmm_table[i] & 0x3ff);
 		vmm_sz *= 4;
 		header = (tqe->type << 31) |
@@ -655,7 +655,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 		else
 			header &= ~BIT(30);
 
-		header = cpu_to_le32(header);
+		cpu_to_le32s(&header);
 		memcpy(&txb[offset], &header, 4);
 		if (tqe->type == WILC_CFG_PKT) {
 			buffer_offset = ETH_CONFIG_PKT_HDR_OFFSET;
@@ -710,7 +710,7 @@ static void wilc_wlan_handle_rx_buff(struct wilc *wilc, u8 *buffer, int size)
 	do {
 		buff_ptr = buffer + offset;
 		memcpy(&header, buff_ptr, 4);
-		header = cpu_to_le32(header);
+		le32_to_cpus(&header);
 
 		is_cfg_packet = (header >> 31) & 0x1;
 		pkt_offset = (header >> 22) & 0x1ff;
@@ -889,8 +889,8 @@ int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
 	do {
 		memcpy(&addr, &buffer[offset], 4);
 		memcpy(&size, &buffer[offset + 4], 4);
-		addr = cpu_to_le32(addr);
-		size = cpu_to_le32(size);
+		le32_to_cpus(&addr);
+		le32_to_cpus(&size);
 		acquire_bus(wilc, ACQUIRE_ONLY);
 		offset += 8;
 		while (((int)size) && (offset < buffer_size)) {
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index c0b9b70..b6feb25 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -273,16 +273,17 @@ static int wilc_wlan_cfg_set_bin(u8 *frame, u32 offset, u16 id, u8 *b, u32 size)
  *
  ********************************************/
 
+#define GET_WID_TYPE(wid)		(((wid) >> 12) & 0x7)
 static void wilc_wlan_parse_response_frame(u8 *info, int size)
 {
-	u32 wid, len = 0, i = 0;
+	u16 wid;
+	u32 len = 0, i = 0;
 
 	while (size > 0) {
 		i = 0;
 		wid = info[0] | (info[1] << 8);
-		wid = cpu_to_le32(wid);
 
-		switch ((wid >> 12) & 0x7) {
+		switch (GET_WID_TYPE(wid)) {
 		case WID_CHAR:
 			do {
 				if (g_cfg_byte[i].id == WID_NIL)
@@ -303,9 +304,8 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 					break;
 
 				if (g_cfg_hword[i].id == wid) {
-					g_cfg_hword[i].val =
-						cpu_to_le16(info[4] |
-							    (info[5] << 8));
+					g_cfg_hword[i].val = (info[4] |
+							      (info[5] << 8));
 					break;
 				}
 				i++;
@@ -319,11 +319,10 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 					break;
 
 				if (g_cfg_word[i].id == wid) {
-					g_cfg_word[i].val =
-						cpu_to_le32(info[4] |
-							    (info[5] << 8) |
-							    (info[6] << 16) |
-							    (info[7] << 24));
+					g_cfg_word[i].val = (info[4] |
+							     (info[5] << 8) |
+							     (info[6] << 16) |
+							     (info[7] << 24));
 					break;
 				}
 				i++;
-- 
2.7.4
