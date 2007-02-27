Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43785 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752646AbXB0VUC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 16:20:02 -0500
From: Helge Deller <deller@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54 various cleanups
Date: Tue, 27 Feb 2007 22:19:58 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702272219.58919.deller@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch below 
- uses PCI_DEVICE macro
- adds a "const" to the p54_ops struct and 
- replaces "__attribute__ ((packed))" by the generic "__packed" keyword.

Signed-off-by: Helge Deller <deller@gmx.de>

PS: There are more possibilities to replace "__attribute__ ((packed))" by the "__packed". Is this wished ? If yes, I can send additional patches for the other subdirectories...


diff --git a/drivers/net/wireless/mac80211/p54/prism54pci.c b/drivers/net/wireless/mac80211/p54/prism54pci.c
index 9ccf42a..7f61202 100644
--- a/drivers/net/wireless/mac80211/p54/prism54pci.c
+++ b/drivers/net/wireless/mac80211/p54/prism54pci.c
@@ -30,13 +30,13 @@ MODULE_LICENSE("GPL");
 
 static struct pci_device_id p54p_table[] __devinitdata = {
 	/* Intersil PRISM Duette/Prism GT Wireless LAN adapter */
-	{ 0x1260, 0x3890, PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_DEVICE(0x1260, 0x3890) },
 	/* 3COM 3CRWE154G72 Wireless LAN adapter */
-	{ 0x10b7, 0x6001, PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_DEVICE(0x10b7, 0x6001) },
 	/* Intersil PRISM Indigo Wireless LAN adapter */
-	{ 0x1260, 0x3877, PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_DEVICE(0x1260, 0x3877) },
 	/* Intersil PRISM Javelin/Xbow Wireless LAN adapter */
-	{ 0x1260, 0x3886, PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_DEVICE(0x1260, 0x3886) },
 };
 
 MODULE_DEVICE_TABLE(pci, p54p_table);
diff --git a/drivers/net/wireless/mac80211/p54/prism54common.c b/drivers/net/wireless/mac80211/p54/prism54common.c
index 7b73463..cf7c018 100644
--- a/drivers/net/wireless/mac80211/p54/prism54common.c
+++ b/drivers/net/wireless/mac80211/p54/prism54common.c
@@ -727,7 +727,7 @@ static int p54_get_tx_stats(struct ieee8
 	return 0;
 }
 
-static struct ieee80211_ops p54_ops = {
+static const struct ieee80211_ops p54_ops = {
 	.tx			= p54_tx,
 	.add_interface		= p54_add_interface,
 	.remove_interface	= p54_remove_interface,





diff --git a/drivers/net/wireless/mac80211/p54/net2280.h b/drivers/net/wireless/mac80211/p54/net2280.h
index 120eb83..e4cf811 100644
--- a/drivers/net/wireless/mac80211/p54/net2280.h
+++ b/drivers/net/wireless/mac80211/p54/net2280.h
@@ -232,7 +232,7 @@ #define     GPIO3_INTERRUPT             
 #define     GPIO2_INTERRUPT                                     2
 #define     GPIO1_INTERRUPT                                     1
 #define     GPIO0_INTERRUPT                                     0
-} __attribute__ ((packed));
+} __packed;
 
 /* usb control, BAR0 + 0x0080 */
 struct net2280_usb_regs {
@@ -296,7 +296,7 @@ #define     TERMINATION_SELECT          
 #define     FORCE_IMMEDIATE                                     7
 #define     OUR_USB_ADDRESS                                     0
 	__le32                  ourconfig;
-} __attribute__ ((packed));
+} __packed;
 
 /* pci control, BAR0 + 0x0100 */
 struct net2280_pci_regs {
@@ -323,7 +323,7 @@ #define     PCI_MASTER_BYTE_WRITE_ENABLE
 #define     PCI_ARBITER_CLEAR                                   2
 #define     PCI_EXTERNAL_ARBITER                                1
 #define     PCI_HOST_MODE                                       0
-} __attribute__ ((packed));
+} __packed;
 
 /* dma control, BAR0 + 0x0180 ... array of four structs like this,
  * for channels 0..3.  see also struct net2280_dma:  descriptor
@@ -364,7 +364,7 @@ #define     DMA_BYTE_COUNT              
 	__le32                  dmaaddr;
 	__le32                  dmadesc;
 	u32                     _unused1;
-} __attribute__ ((packed));
+} __packed;
 
 /* dedicated endpoint registers, BAR0 + 0x0200 */
 
@@ -374,7 +374,7 @@ struct net2280_dep_regs {	/* [11.8] */
 	// offset 0x0204, 0x0214, 0x224, 0x234, 0x244
 	__le32                  dep_rsp;
 	u32                     _unused[2];
-} __attribute__ ((packed));
+} __packed;
 
 /* configurable endpoint registers, BAR0 + 0x0300 ... array of seven structs
  * like this, for ep0 then the configurable endpoints A..F
@@ -437,16 +437,16 @@ #define     DATA_IN_TOKEN_INTERRUPT     
 	__le32                  ep_avail;
 	__le32                  ep_data;
 	u32                     _unused0[2];
-} __attribute__ ((packed));
+} __packed;
 
 struct net2280_reg_write {
 	__le16 port;
 	__le32 addr;
 	__le32 val;
-} __attribute__ ((packed));
+} __packed;
 
 struct net2280_reg_read {
 	__le16 port;
 	__le32 addr;
-} __attribute__ ((packed));
+} __packed;
 #endif /* NET2280_H */
diff --git a/drivers/net/wireless/mac80211/p54/prism54.h b/drivers/net/wireless/mac80211/p54/prism54.h
index 884ba50..0a8222e 100644
--- a/drivers/net/wireless/mac80211/p54/prism54.h
+++ b/drivers/net/wireless/mac80211/p54/prism54.h
@@ -36,7 +36,7 @@ struct p54_control_hdr {
 	u8 retry1;
 	u8 retry2;
 	u8 data[0];
-} __attribute__ ((packed));
+} __packed;
 
 #define EEPROM_READBACK_LEN (sizeof(struct p54_control_hdr) + 4 /* p54_eeprom_lm86 */)
 #define MAX_RX_SIZE (IEEE80211_MAX_RTS_THRESHOLD + sizeof(struct p54_control_hdr) + 20 /* length of struct p54_rx_hdr */ + 16 )
diff --git a/drivers/net/wireless/mac80211/p54/prism54common.h b/drivers/net/wireless/mac80211/p54/prism54common.h
index 18cd4d9..a687de8 100644
--- a/drivers/net/wireless/mac80211/p54/prism54common.h
+++ b/drivers/net/wireless/mac80211/p54/prism54common.h
@@ -18,7 +18,7 @@ struct bootrec {
 	__le32 code;
 	__le32 len;
 	u32 data[];
-} __attribute__((packed));
+} __packed;
 
 struct bootrec_exp_if {
 	__le16 role;
@@ -26,7 +26,7 @@ struct bootrec_exp_if {
 	__le16 variant;
 	__le16 btm_compat;
 	__le16 top_compat;
-} __attribute__((packed));
+} __packed;
 
 #define BR_CODE_MIN			0x80000000
 #define BR_CODE_COMPONENT_ID		0x80000001
@@ -49,7 +49,7 @@ struct pda_entry {
 	__le16 len;	/* includes both code and data */
 	__le16 code;
 	u8 data[0];
-} __attribute__ ((packed));
+} __packed;
 
 struct eeprom_pda_wrap {
 	u32 magic;
@@ -57,12 +57,12 @@ struct eeprom_pda_wrap {
 	u16 len;
 	u32 arm_opcode;
 	u8 data[0];
-} __attribute__ ((packed));
+} __packed;
 
 struct pda_iq_autocal_entry {
         __le16 freq;
         __le16 iq_param[4];
-} __attribute__ ((packed));
+} __packed;
 
 struct pda_channel_output_limit {
 	__le16 freq;
@@ -72,13 +72,13 @@ struct pda_channel_output_limit {
 	u8 val_64qam;
 	u8 rate_set_mask;
 	u8 rate_set_size;
-} __attribute__ ((packed));
+} __packed;
 
 struct pda_pa_curve_data_sample_rev0 {
 	u8 rf_power;
 	u8 pa_detector;
 	u8 pcv;
-} __attribute__ ((packed));
+} __packed;
 
 struct pda_pa_curve_data_sample_rev1 {
 	u8 rf_power;
@@ -89,7 +89,7 @@ struct pda_pa_curve_data_sample_rev1 {
 	u8 data_16qam;
 	u8 data_64qam;
 	u8 padding;
-} __attribute__ ((packed));
+} __packed;
 
 struct pda_pa_curve_data {
 	u8 cal_method_rev;
@@ -97,7 +97,7 @@ struct pda_pa_curve_data {
 	u8 points_per_channel;
 	u8 padding;
 	u8 data[0];
-} __attribute__ ((packed));
+} __packed;
 
 /*
  * this defines the PDR codes used to build PDAs as defined in document
@@ -158,7 +158,7 @@ struct p54_eeprom_lm86 {
 	__le16 offset;
 	__le16 len;
 	u8 data[0];
-} __attribute__ ((packed));
+} __packed;
 
 struct p54_rx_hdr {
 	__le16 magic;
@@ -171,14 +171,14 @@ struct p54_rx_hdr {
 	u16 unknown2;
 	__le64 timestamp;
 	u8 data[0];
-} __attribute__ ((packed));
+} __packed;
 
 struct p54_frame_sent_hdr {
 	__le16 status;
 	__le16 ack_rssi;
 	__le16 seq;
 	u16 unknown;
-} __attribute__ ((packed));
+} __packed;
 
 struct p54_tx_control_allocdata {
 	u8 rateset[8];
@@ -191,7 +191,7 @@ struct p54_tx_control_allocdata {
 	__le32 magic4;
 	__le32 magic5;
 	u8 align[0];
-} __attribute__ ((packed));
+} __packed;
 
 struct p54_tx_control_filter {
 	__le16 filter_type;
@@ -206,7 +206,7 @@ struct p54_tx_control_filter {
 	__le16 rxhw;
 	__le16 magic8;
 	__le16 magic9;
-} __attribute__ ((packed));
+} __packed;
 
 struct p54_tx_control_channel {
 	__le16 magic1;
@@ -221,14 +221,14 @@ struct p54_tx_control_channel {
 	u8 val_64qam;
 	struct pda_pa_curve_data_sample_rev1 curve_data[0];
 	/* additional padding/data after curve_data */
-} __attribute__ ((packed));
+} __packed;
 
 struct p54_tx_control_led {
 	__le16 mode;
 	__le16 led_temporary;
 	__le16 led_permanent;
 	__le16 duration;
-} __attribute__ ((packed));
+} __packed;
 
 static const struct ieee80211_rate p54_rates[] = {
 	{ .rate = 10,
diff --git a/drivers/net/wireless/mac80211/p54/prism54pci.h b/drivers/net/wireless/mac80211/p54/prism54pci.h
index 52feb59..f0d2716 100644
--- a/drivers/net/wireless/mac80211/p54/prism54pci.h
+++ b/drivers/net/wireless/mac80211/p54/prism54pci.h
@@ -65,7 +65,7 @@ struct p54p_csr {
 	u8 unused_6[1924];
 	u8 cardbus_cis[0x800];
 	u8 direct_mem_win[0x1000];
-} __attribute__ ((packed));
+} __packed;
 
 /* usb backend only needs the register defines above */
 #ifndef PRISM54USB_H
@@ -74,7 +74,7 @@ struct p54p_desc {
 	__le32 device_addr;
 	__le16 len;
 	__le16 flags;
-} __attribute__ ((packed));
+} __packed;
 
 struct p54p_ring_control {
 	__le32 host_idx[4];
@@ -83,7 +83,7 @@ struct p54p_ring_control {
 	struct p54p_desc tx_data[32];
 	struct p54p_desc rx_mgmt[4];
 	struct p54p_desc tx_mgmt[4];
-} __attribute__ ((packed));
+} __packed;
 
 #define P54P_READ(r) __raw_readl(&priv->map->r)
 #define P54P_WRITE(r, val) __raw_writel((__force u32)(val), &priv->map->r)
diff --git a/drivers/net/wireless/mac80211/p54/prism54usb.c b/drivers/net/wireless/mac80211/p54/prism54usb.c
diff --git a/drivers/net/wireless/mac80211/p54/prism54usb.h b/drivers/net/wireless/mac80211/p54/prism54usb.h
index 5deffa8..022ffa2 100644
--- a/drivers/net/wireless/mac80211/p54/prism54usb.h
+++ b/drivers/net/wireless/mac80211/p54/prism54usb.h
@@ -70,7 +70,7 @@ struct net2280_tx_hdr {
 	__le16 len;
 	__le16 follower;	/* ? */
 	u8 padding[8];
-} __attribute__((packed));
+} __packed;
 
 /* Some flags for the isl hardware registers controlling DMA inside the
  * chip */
@@ -98,7 +98,7 @@ struct x2_header {
 	__le32 fw_load_addr;
 	__le32 fw_length;
 	__le32 crc;
-} __attribute__((packed));
+} __packed;
 
 /* pipes 3 and 4 are not used by the driver */
 #define P54U_PIPE_NUMBER 9

