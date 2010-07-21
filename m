Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32951 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab0GUQpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 12:45:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kalle.valo@iki.fi>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wl1251: fix sparse-generated warnings
Date: Wed, 21 Jul 2010 12:31:57 -0400
Message-Id: <1279729917-4451-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   drivers/net/wireless/wl12xx/wl1251_tx.c
drivers/net/wireless/wl12xx/wl1251_tx.c:118:32: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1251_tx.c:118:32:    expected unsigned short [unsigned] [usertype] frag_threshold
drivers/net/wireless/wl12xx/wl1251_tx.c:118:32:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/wl12xx/wl1251_tx.c:164:24: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1251_tx.c:164:24:    expected unsigned short [unsigned] [usertype] length
drivers/net/wireless/wl12xx/wl1251_tx.c:164:24:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/wl12xx/wl1251_tx.c:166:22: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1251_tx.c:166:22:    expected unsigned short [unsigned] [usertype] rate
drivers/net/wireless/wl12xx/wl1251_tx.c:166:22:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/wl12xx/wl1251_tx.c:167:29: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1251_tx.c:167:29:    expected unsigned int [unsigned] [usertype] expiry_time
drivers/net/wireless/wl12xx/wl1251_tx.c:167:29:    got restricted __le32 [usertype] <noident>
drivers/net/wireless/wl12xx/wl1251_tx.c:200:43: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/wl12xx/wl1251_tx.c:200:43:    expected restricted __le16 [usertype] fc
drivers/net/wireless/wl12xx/wl1251_tx.c:200:43:    got unsigned short [unsigned] [assigned] [usertype] fc
  CHECK   drivers/net/wireless/wl12xx/wl1251_cmd.c
drivers/net/wireless/wl12xx/wl1251_cmd.c:428:39: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1251_cmd.c:428:39:    expected unsigned int [unsigned] [usertype] rx_config_options
drivers/net/wireless/wl12xx/wl1251_cmd.c:428:39:    got restricted __le32 [usertype] <noident>
drivers/net/wireless/wl12xx/wl1251_cmd.c:429:39: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1251_cmd.c:429:39:    expected unsigned int [unsigned] [usertype] rx_filter_options
drivers/net/wireless/wl12xx/wl1251_cmd.c:429:39:    got restricted __le32 [usertype] <noident>
drivers/net/wireless/wl12xx/wl1251_cmd.c:435:29: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1251_cmd.c:435:29:    expected unsigned short [unsigned] [usertype] tx_rate
drivers/net/wireless/wl12xx/wl1251_cmd.c:435:29:    got restricted __le16 [usertype] <noident>
drivers/net/wireless/wl12xx/wl1251_cmd.c:439:47: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1251_cmd.c:439:47:    expected unsigned int [unsigned] [usertype] min_duration
drivers/net/wireless/wl12xx/wl1251_cmd.c:439:47:    got restricted __le32 [usertype] <noident>
drivers/net/wireless/wl12xx/wl1251_cmd.c:441:47: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1251_cmd.c:441:47:    expected unsigned int [unsigned] [usertype] max_duration
drivers/net/wireless/wl12xx/wl1251_cmd.c:441:47:    got restricted __le32 [usertype] <noident>
  CHECK   drivers/net/wireless/wl12xx/wl1251_boot.c
drivers/net/wireless/wl12xx/wl1251_boot.c:228:22: warning: symbol 'interrupt' shadows an earlier one
/home/linville/git/wireless-next-2.6/arch/x86/include/asm/hw_irq.h:132:13: originally declared here
drivers/net/wireless/wl12xx/wl1251_boot.c:470:21: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1251_boot.c:470:21:    expected unsigned int [unsigned] [assigned] [usertype] val
drivers/net/wireless/wl12xx/wl1251_boot.c:470:21:    got restricted __le32 [usertype] <noident>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
I made some assumptions about the endian-ness of some structure members
-- please verify!  Also, I'm reasonably certain there are more endian
issues lurking...

 drivers/net/wireless/wl12xx/wl1251_boot.c |   10 +++++-----
 drivers/net/wireless/wl12xx/wl1251_cmd.h  |   12 ++++++------
 drivers/net/wireless/wl12xx/wl1251_tx.c   |   10 ++++++----
 drivers/net/wireless/wl12xx/wl1251_tx.h   |    8 ++++----
 4 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl12xx/wl1251_boot.c
index 2545123..c688895 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.c
@@ -225,7 +225,7 @@ static void wl1251_boot_set_ecpu_ctrl(struct wl1251 *wl, u32 flag)
 int wl1251_boot_run_firmware(struct wl1251 *wl)
 {
 	int loop, ret;
-	u32 chip_id, interrupt;
+	u32 chip_id, acx_intr;
 
 	wl1251_boot_set_ecpu_ctrl(wl, ECPU_CONTROL_HALT);
 
@@ -242,15 +242,15 @@ int wl1251_boot_run_firmware(struct wl1251 *wl)
 	loop = 0;
 	while (loop++ < INIT_LOOP) {
 		udelay(INIT_LOOP_DELAY);
-		interrupt = wl1251_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+		acx_intr = wl1251_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
 
-		if (interrupt == 0xffffffff) {
+		if (acx_intr == 0xffffffff) {
 			wl1251_error("error reading hardware complete "
 				     "init indication");
 			return -EIO;
 		}
 		/* check that ACX_INTR_INIT_COMPLETE is enabled */
-		else if (interrupt & WL1251_ACX_INTR_INIT_COMPLETE) {
+		else if (acx_intr & WL1251_ACX_INTR_INIT_COMPLETE) {
 			wl1251_reg_write32(wl, ACX_REG_INTERRUPT_ACK,
 					   WL1251_ACX_INTR_INIT_COMPLETE);
 			break;
@@ -467,7 +467,7 @@ static int wl1251_boot_upload_nvs(struct wl1251 *wl)
 		val = (nvs_ptr[0] | (nvs_ptr[1] << 8)
 		       | (nvs_ptr[2] << 16) | (nvs_ptr[3] << 24));
 
-		val = cpu_to_le32(val);
+		val = (u32 __force) cpu_to_le32(val);
 
 		wl1251_debug(DEBUG_BOOT,
 			     "nvs write table 0x%x: 0x%x",
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.h b/drivers/net/wireless/wl12xx/wl1251_cmd.h
index 4ad67ca..ca1cb24 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.h
@@ -175,8 +175,8 @@ struct cmd_read_write_memory {
 #define WL1251_SCAN_NUM_PROBES 3
 
 struct wl1251_scan_parameters {
-	u32 rx_config_options;
-	u32 rx_filter_options;
+	__le32 rx_config_options;
+	__le32 rx_filter_options;
 
 	/*
 	 * Scan options:
@@ -186,7 +186,7 @@ struct wl1251_scan_parameters {
 	 * bit 2: voice mode, 0 for normal scan.
 	 * bit 3: scan priority, 1 for high priority.
 	 */
-	u16 scan_options;
+	__le16 scan_options;
 
 	/* Number of channels to scan */
 	u8 num_channels;
@@ -195,7 +195,7 @@ struct wl1251_scan_parameters {
 	u8 num_probe_requests;
 
 	/* Rate and modulation for probe requests */
-	u16 tx_rate;
+	__le16 tx_rate;
 
 	u8 tid_trigger;
 	u8 ssid_len;
@@ -204,8 +204,8 @@ struct wl1251_scan_parameters {
 } __attribute__ ((packed));
 
 struct wl1251_scan_ch_parameters {
-	u32 min_duration; /* in TU */
-	u32 max_duration; /* in TU */
+	__le32 min_duration; /* in TU */
+	__le32 max_duration; /* in TU */
 	u32 bssid_lsb;
 	u16 bssid_msb;
 
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.c b/drivers/net/wireless/wl12xx/wl1251_tx.c
index c822318..a38ec19 100644
--- a/drivers/net/wireless/wl12xx/wl1251_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_tx.c
@@ -117,7 +117,7 @@ static void wl1251_tx_frag_block_num(struct tx_double_buffer_desc *tx_hdr)
 	frag_threshold = IEEE80211_MAX_FRAG_THRESHOLD;
 	tx_hdr->frag_threshold = cpu_to_le16(frag_threshold);
 
-	payload_len = tx_hdr->length + MAX_MSDU_SECURITY_LENGTH;
+	payload_len = le16_to_cpu(tx_hdr->length) + MAX_MSDU_SECURITY_LENGTH;
 
 	if (payload_len > frag_threshold) {
 		mem_blocks_per_frag =
@@ -191,11 +191,13 @@ static int wl1251_tx_send_packet(struct wl1251 *wl, struct sk_buff *skb,
 	if (control->control.hw_key &&
 	    control->control.hw_key->alg == ALG_TKIP) {
 		int hdrlen;
-		u16 fc;
+		__le16 fc;
+		u16 length;
 		u8 *pos;
 
-		fc = *(u16 *)(skb->data + sizeof(*tx_hdr));
-		tx_hdr->length += WL1251_TKIP_IV_SPACE;
+		fc = *(__le16 *)(skb->data + sizeof(*tx_hdr));
+		length = le16_to_cpu(tx_hdr->length) + WL1251_TKIP_IV_SPACE;
+		tx_hdr->length = cpu_to_le16(length);
 
 		hdrlen = ieee80211_hdrlen(fc);
 
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.h b/drivers/net/wireless/wl12xx/wl1251_tx.h
index 55856c6..dff127f 100644
--- a/drivers/net/wireless/wl12xx/wl1251_tx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_tx.h
@@ -114,7 +114,7 @@ struct tx_control {
 
 struct tx_double_buffer_desc {
 	/* Length of payload, including headers. */
-	u16 length;
+	__le16 length;
 
 	/*
 	 * A bit mask that specifies the initial rate to be used
@@ -133,10 +133,10 @@ struct tx_double_buffer_desc {
 	 * 0x0800 - 48Mbits
 	 * 0x1000 - 54Mbits
 	 */
-	u16 rate;
+	__le16 rate;
 
 	/* Time in us that a packet can spend in the target */
-	u32 expiry_time;
+	__le32 expiry_time;
 
 	/* index of the TX queue used for this packet */
 	u8 xmit_queue;
@@ -150,7 +150,7 @@ struct tx_double_buffer_desc {
 	 * The FW should cut the packet into fragments
 	 * of this size.
 	 */
-	u16 frag_threshold;
+	__le16 frag_threshold;
 
 	/* Numbers of HW queue blocks to be allocated */
 	u8 num_mem_blocks;
-- 
1.7.1.1

