Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7288 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbYBVFBC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 00:01:02 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 4/5] at76_usb: reindent, reorder initializers for readability
To: linux-wireless@vger.kernel.org, at76c503a-develop@lists.berlios.de
Date: Fri, 22 Feb 2008 00:01:01 -0500
Message-ID: <20080222050101.11158.37111.stgit@dv.roinet.com> (sfid-20080222_050109_337636_1E21D756)
In-Reply-To: <20080222050044.11158.86655.stgit@dv.roinet.com>
References: <20080222050044.11158.86655.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |  221 +++++++++++++++++----------------------
 1 files changed, 98 insertions(+), 123 deletions(-)

diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index da531a3..33fa026 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -110,15 +110,15 @@ static int at76_debug = DBG_DEFAULTS;
 static struct mutex fw_mutex;
 
 static struct fwentry firmwares[] = {
-	[0] = {""},
-	[BOARD_503_ISL3861] = {"atmel_at76c503-i3861.bin"},
-	[BOARD_503_ISL3863] = {"atmel_at76c503-i3863.bin"},
-	[BOARD_503] = {"atmel_at76c503-rfmd.bin"},
-	[BOARD_503_ACC] = {"atmel_at76c503-rfmd-acc.bin"},
-	[BOARD_505] = {"atmel_at76c505-rfmd.bin"},
-	[BOARD_505_2958] = {"atmel_at76c505-rfmd2958.bin"},
-	[BOARD_505A] = {"atmel_at76c505a-rfmd2958.bin"},
-	[BOARD_505AMX] = {"atmel_at76c505amx-rfmd.bin"},
+	[0] = { "" },
+	[BOARD_503_ISL3861] = { "atmel_at76c503-i3861.bin" },
+	[BOARD_503_ISL3863] = { "atmel_at76c503-i3863.bin" },
+	[BOARD_503] = { "atmel_at76c503-rfmd.bin" },
+	[BOARD_503_ACC] = { "atmel_at76c503-rfmd-acc.bin" },
+	[BOARD_505] = { "atmel_at76c505-rfmd.bin" },
+	[BOARD_505_2958] = { "atmel_at76c505-rfmd2958.bin" },
+	[BOARD_505A] = { "atmel_at76c505a-rfmd2958.bin" },
+	[BOARD_505AMX] = { "atmel_at76c505amx-rfmd.bin" },
 };
 
 #define USB_DEVICE_DATA(__ops)	.driver_info = (kernel_ulong_t)(__ops)
@@ -128,133 +128,133 @@ static struct usb_device_id dev_table[] = {
 	 * at76c503-i3861
 	 */
 	/* Generic AT76C503/3861 device */
-	{USB_DEVICE(0x03eb, 0x7603), USB_DEVICE_DATA(BOARD_503_ISL3861)},
+	{ USB_DEVICE(0x03eb, 0x7603), USB_DEVICE_DATA(BOARD_503_ISL3861) },
 	/* Linksys WUSB11 v2.1/v2.6 */
-	{USB_DEVICE(0x066b, 0x2211), USB_DEVICE_DATA(BOARD_503_ISL3861)},
+	{ USB_DEVICE(0x066b, 0x2211), USB_DEVICE_DATA(BOARD_503_ISL3861) },
 	/* Netgear MA101 rev. A */
-	{USB_DEVICE(0x0864, 0x4100), USB_DEVICE_DATA(BOARD_503_ISL3861)},
+	{ USB_DEVICE(0x0864, 0x4100), USB_DEVICE_DATA(BOARD_503_ISL3861) },
 	/* Tekram U300C / Allnet ALL0193 */
-	{USB_DEVICE(0x0b3b, 0x1612), USB_DEVICE_DATA(BOARD_503_ISL3861)},
+	{ USB_DEVICE(0x0b3b, 0x1612), USB_DEVICE_DATA(BOARD_503_ISL3861) },
 	/* HP HN210W J7801A */
-	{USB_DEVICE(0x03f0, 0x011c), USB_DEVICE_DATA(BOARD_503_ISL3861)},
+	{ USB_DEVICE(0x03f0, 0x011c), USB_DEVICE_DATA(BOARD_503_ISL3861) },
 	/* Sitecom/Z-Com/Zyxel M4Y-750 */
-	{USB_DEVICE(0x0cde, 0x0001), USB_DEVICE_DATA(BOARD_503_ISL3861)},
+	{ USB_DEVICE(0x0cde, 0x0001), USB_DEVICE_DATA(BOARD_503_ISL3861) },
 	/* Dynalink/Askey WLL013 (intersil) */
-	{USB_DEVICE(0x069a, 0x0320), USB_DEVICE_DATA(BOARD_503_ISL3861)},
+	{ USB_DEVICE(0x069a, 0x0320), USB_DEVICE_DATA(BOARD_503_ISL3861) },
 	/* EZ connect 11Mpbs Wireless USB Adapter SMC2662W v1 */
-	{USB_DEVICE(0x0d5c, 0xa001), USB_DEVICE_DATA(BOARD_503_ISL3861)},
+	{ USB_DEVICE(0x0d5c, 0xa001), USB_DEVICE_DATA(BOARD_503_ISL3861) },
 	/* BenQ AWL300 */
-	{USB_DEVICE(0x04a5, 0x9000), USB_DEVICE_DATA(BOARD_503_ISL3861)},
+	{ USB_DEVICE(0x04a5, 0x9000), USB_DEVICE_DATA(BOARD_503_ISL3861) },
 	/* Addtron AWU-120, Compex WLU11 */
-	{USB_DEVICE(0x05dd, 0xff31), USB_DEVICE_DATA(BOARD_503_ISL3861)},
+	{ USB_DEVICE(0x05dd, 0xff31), USB_DEVICE_DATA(BOARD_503_ISL3861) },
 	/* Intel AP310 AnyPoint II USB */
-	{USB_DEVICE(0x8086, 0x0200), USB_DEVICE_DATA(BOARD_503_ISL3861)},
+	{ USB_DEVICE(0x8086, 0x0200), USB_DEVICE_DATA(BOARD_503_ISL3861) },
 	/* Dynalink L11U */
-	{USB_DEVICE(0x0d8e, 0x7100), USB_DEVICE_DATA(BOARD_503_ISL3861)},
+	{ USB_DEVICE(0x0d8e, 0x7100), USB_DEVICE_DATA(BOARD_503_ISL3861) },
 	/* Arescom WL-210, FCC id 07J-GL2411USB */
-	{USB_DEVICE(0x0d8e, 0x7110), USB_DEVICE_DATA(BOARD_503_ISL3861)},
+	{ USB_DEVICE(0x0d8e, 0x7110), USB_DEVICE_DATA(BOARD_503_ISL3861) },
 	/* I-O DATA WN-B11/USB */
-	{USB_DEVICE(0x04bb, 0x0919), USB_DEVICE_DATA(BOARD_503_ISL3861)},
+	{ USB_DEVICE(0x04bb, 0x0919), USB_DEVICE_DATA(BOARD_503_ISL3861) },
 	/* BT Voyager 1010 */
-	{USB_DEVICE(0x069a, 0x0821), USB_DEVICE_DATA(BOARD_503_ISL3861)},
+	{ USB_DEVICE(0x069a, 0x0821), USB_DEVICE_DATA(BOARD_503_ISL3861) },
 	/*
 	 * at76c503-i3863
 	 */
 	/* Generic AT76C503/3863 device */
-	{USB_DEVICE(0x03eb, 0x7604), USB_DEVICE_DATA(BOARD_503_ISL3863)},
+	{ USB_DEVICE(0x03eb, 0x7604), USB_DEVICE_DATA(BOARD_503_ISL3863) },
 	/* Samsung SWL-2100U */
-	{USB_DEVICE(0x055d, 0xa000), USB_DEVICE_DATA(BOARD_503_ISL3863)},
+	{ USB_DEVICE(0x055d, 0xa000), USB_DEVICE_DATA(BOARD_503_ISL3863) },
 	/*
 	 * at76c503-rfmd
 	 */
 	/* Generic AT76C503/RFMD device */
-	{USB_DEVICE(0x03eb, 0x7605), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x03eb, 0x7605), USB_DEVICE_DATA(BOARD_503) },
 	/* Dynalink/Askey WLL013 (rfmd) */
-	{USB_DEVICE(0x069a, 0x0321), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x069a, 0x0321), USB_DEVICE_DATA(BOARD_503) },
 	/* Linksys WUSB11 v2.6 */
-	{USB_DEVICE(0x077b, 0x2219), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x077b, 0x2219), USB_DEVICE_DATA(BOARD_503) },
 	/* Network Everywhere NWU11B */
-	{USB_DEVICE(0x077b, 0x2227), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x077b, 0x2227), USB_DEVICE_DATA(BOARD_503) },
 	/* Netgear MA101 rev. B */
-	{USB_DEVICE(0x0864, 0x4102), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x0864, 0x4102), USB_DEVICE_DATA(BOARD_503) },
 	/* D-Link DWL-120 rev. E */
-	{USB_DEVICE(0x2001, 0x3200), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x2001, 0x3200), USB_DEVICE_DATA(BOARD_503) },
 	/* Actiontec 802UAT1, HWU01150-01UK */
-	{USB_DEVICE(0x1668, 0x7605), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x1668, 0x7605), USB_DEVICE_DATA(BOARD_503) },
 	/* AirVast W-Buddie WN210 */
-	{USB_DEVICE(0x03eb, 0x4102), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x03eb, 0x4102), USB_DEVICE_DATA(BOARD_503) },
 	/* Dick Smith Electronics XH1153 802.11b USB adapter */
-	{USB_DEVICE(0x1371, 0x5743), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x1371, 0x5743), USB_DEVICE_DATA(BOARD_503) },
 	/* CNet CNUSB611 */
-	{USB_DEVICE(0x1371, 0x0001), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x1371, 0x0001), USB_DEVICE_DATA(BOARD_503) },
 	/* FiberLine FL-WL200U */
-	{USB_DEVICE(0x1371, 0x0002), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x1371, 0x0002), USB_DEVICE_DATA(BOARD_503) },
 	/* BenQ AWL400 USB stick */
-	{USB_DEVICE(0x04a5, 0x9001), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x04a5, 0x9001), USB_DEVICE_DATA(BOARD_503) },
 	/* 3Com 3CRSHEW696 */
-	{USB_DEVICE(0x0506, 0x0a01), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x0506, 0x0a01), USB_DEVICE_DATA(BOARD_503) },
 	/* Siemens Santis ADSL WLAN USB adapter WLL 013 */
-	{USB_DEVICE(0x0681, 0x001b), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x0681, 0x001b), USB_DEVICE_DATA(BOARD_503) },
 	/* Belkin F5D6050, version 2 */
-	{USB_DEVICE(0x050d, 0x0050), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x050d, 0x0050), USB_DEVICE_DATA(BOARD_503) },
 	/* iBlitzz, BWU613 (not *B or *SB) */
-	{USB_DEVICE(0x07b8, 0xb000), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x07b8, 0xb000), USB_DEVICE_DATA(BOARD_503) },
 	/* Gigabyte GN-WLBM101 */
-	{USB_DEVICE(0x1044, 0x8003), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x1044, 0x8003), USB_DEVICE_DATA(BOARD_503) },
 	/* Planex GW-US11S */
-	{USB_DEVICE(0x2019, 0x3220), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x2019, 0x3220), USB_DEVICE_DATA(BOARD_503) },
 	/* Internal WLAN adapter in h5[4,5]xx series iPAQs */
-	{USB_DEVICE(0x049f, 0x0032), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x049f, 0x0032), USB_DEVICE_DATA(BOARD_503) },
 	/* Corega Wireless LAN USB-11 mini */
-	{USB_DEVICE(0x07aa, 0x0011), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x07aa, 0x0011), USB_DEVICE_DATA(BOARD_503) },
 	/* Corega Wireless LAN USB-11 mini2 */
-	{USB_DEVICE(0x07aa, 0x0018), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x07aa, 0x0018), USB_DEVICE_DATA(BOARD_503) },
 	/* Uniden PCW100 */
-	{USB_DEVICE(0x05dd, 0xff35), USB_DEVICE_DATA(BOARD_503)},
+	{ USB_DEVICE(0x05dd, 0xff35), USB_DEVICE_DATA(BOARD_503) },
 	/*
 	 * at76c503-rfmd-acc
 	 */
 	/* SMC2664W */
-	{USB_DEVICE(0x083a, 0x3501), USB_DEVICE_DATA(BOARD_503_ACC)},
+	{ USB_DEVICE(0x083a, 0x3501), USB_DEVICE_DATA(BOARD_503_ACC) },
 	/* Belkin F5D6050, SMC2662W v2, SMC2662W-AR */
-	{USB_DEVICE(0x0d5c, 0xa002), USB_DEVICE_DATA(BOARD_503_ACC)},
+	{ USB_DEVICE(0x0d5c, 0xa002), USB_DEVICE_DATA(BOARD_503_ACC) },
 	/*
 	 * at76c505-rfmd
 	 */
 	/* Generic AT76C505/RFMD */
-	{USB_DEVICE(0x03eb, 0x7606), USB_DEVICE_DATA(BOARD_505)},
+	{ USB_DEVICE(0x03eb, 0x7606), USB_DEVICE_DATA(BOARD_505) },
 	/*
 	 * at76c505-rfmd2958
 	 */
 	/* Generic AT76C505/RFMD, OvisLink WL-1130USB */
-	{USB_DEVICE(0x03eb, 0x7613), USB_DEVICE_DATA(BOARD_505_2958)},
+	{ USB_DEVICE(0x03eb, 0x7613), USB_DEVICE_DATA(BOARD_505_2958) },
 	/* Fiberline FL-WL240U */
-	{USB_DEVICE(0x1371, 0x0014), USB_DEVICE_DATA(BOARD_505_2958)},
+	{ USB_DEVICE(0x1371, 0x0014), USB_DEVICE_DATA(BOARD_505_2958) },
 	/* CNet CNUSB-611G */
-	{USB_DEVICE(0x1371, 0x0013), USB_DEVICE_DATA(BOARD_505_2958)},
+	{ USB_DEVICE(0x1371, 0x0013), USB_DEVICE_DATA(BOARD_505_2958) },
 	/* Linksys WUSB11 v2.8 */
-	{USB_DEVICE(0x1915, 0x2233), USB_DEVICE_DATA(BOARD_505_2958)},
+	{ USB_DEVICE(0x1915, 0x2233), USB_DEVICE_DATA(BOARD_505_2958) },
 	/* Xterasys XN-2122B, IBlitzz BWU613B/BWU613SB */
-	{USB_DEVICE(0x12fd, 0x1001), USB_DEVICE_DATA(BOARD_505_2958)},
+	{ USB_DEVICE(0x12fd, 0x1001), USB_DEVICE_DATA(BOARD_505_2958) },
 	/* Corega WLAN USB Stick 11 */
-	{USB_DEVICE(0x07aa, 0x7613), USB_DEVICE_DATA(BOARD_505_2958)},
+	{ USB_DEVICE(0x07aa, 0x7613), USB_DEVICE_DATA(BOARD_505_2958) },
 	/* Microstar MSI Box MS6978 */
-	{USB_DEVICE(0x0db0, 0x1020), USB_DEVICE_DATA(BOARD_505_2958)},
+	{ USB_DEVICE(0x0db0, 0x1020), USB_DEVICE_DATA(BOARD_505_2958) },
 	/*
 	 * at76c505a-rfmd2958
 	 */
 	/* Generic AT76C505A device */
-	{USB_DEVICE(0x03eb, 0x7614), USB_DEVICE_DATA(BOARD_505A)},
+	{ USB_DEVICE(0x03eb, 0x7614), USB_DEVICE_DATA(BOARD_505A) },
 	/* Generic AT76C505AS device */
-	{USB_DEVICE(0x03eb, 0x7617), USB_DEVICE_DATA(BOARD_505A)},
+	{ USB_DEVICE(0x03eb, 0x7617), USB_DEVICE_DATA(BOARD_505A) },
 	/* Siemens Gigaset USB WLAN Adapter 11 */
-	{USB_DEVICE(0x1690, 0x0701), USB_DEVICE_DATA(BOARD_505A)},
+	{ USB_DEVICE(0x1690, 0x0701), USB_DEVICE_DATA(BOARD_505A) },
 	/*
 	 * at76c505amx-rfmd
 	 */
 	/* Generic AT76C505AMX device */
-	{USB_DEVICE(0x03eb, 0x7615), USB_DEVICE_DATA(BOARD_505AMX)},
-	{}
+	{ USB_DEVICE(0x03eb, 0x7615), USB_DEVICE_DATA(BOARD_505AMX) },
+	{ }
 };
 
 MODULE_DEVICE_TABLE(usb, dev_table);
@@ -663,15 +663,15 @@ static struct reg_domain const *at76_get_reg_domain(u16 code)
 {
 	int i;
 	static struct reg_domain const fd_tab[] = {
-		{0x10, "FCC (USA)", 0x7ff},	/* ch 1-11 */
-		{0x20, "IC (Canada)", 0x7ff},	/* ch 1-11 */
-		{0x30, "ETSI (most of Europe)", 0x1fff},	/* ch 1-13 */
-		{0x31, "Spain", 0x600},	/* ch 10-11 */
-		{0x32, "France", 0x1e00},	/* ch 10-13 */
-		{0x40, "MKK (Japan)", 0x2000},	/* ch 14 */
-		{0x41, "MKK1 (Japan)", 0x3fff},	/* ch 1-14 */
-		{0x50, "Israel", 0x3fc},	/* ch 3-9 */
-		{0x00, "<unknown>", 0xffffffff}	/* ch 1-32 */
+		{ 0x10, "FCC (USA)", 0x7ff },	/* ch 1-11 */
+		{ 0x20, "IC (Canada)", 0x7ff },	/* ch 1-11 */
+		{ 0x30, "ETSI (most of Europe)", 0x1fff },	/* ch 1-13 */
+		{ 0x31, "Spain", 0x600 },	/* ch 10-11 */
+		{ 0x32, "France", 0x1e00 },	/* ch 10-13 */
+		{ 0x40, "MKK (Japan)", 0x2000 },	/* ch 14 */
+		{ 0x41, "MKK1 (Japan)", 0x3fff },	/* ch 1-14 */
+		{ 0x50, "Israel", 0x3fc },	/* ch 3-9 */
+		{ 0x00, "<unknown>", 0xffffffff }	/* ch 1-32 */
 	};
 
 	/* Last entry is fallback for unknown domain code */
@@ -1566,7 +1566,7 @@ static void at76_rx_tasklet(unsigned long param)
 	struct urb *urb = (struct urb *)param;
 	struct at76_priv *priv = urb->context;
 	struct at76_rx_buffer *buf;
-	struct ieee80211_rx_status rx_status = {0};
+	struct ieee80211_rx_status rx_status = { 0 };
 
 	if (priv->device_unplugged) {
 		at76_dbg(DBG_DEVSTART, "device unplugged");
@@ -1597,8 +1597,7 @@ static void at76_rx_tasklet(unsigned long param)
 	skb_pull(priv->rx_skb, AT76_RX_HDRLEN);
 	skb_trim(priv->rx_skb, le16_to_cpu(buf->wlength));
 	at76_dbg_dump(DBG_RX_DATA, priv->rx_skb->data,
-		      priv->rx_skb->len, "RX: len=%d",
-		      priv->rx_skb->len);
+		      priv->rx_skb->len, "RX: len=%d", priv->rx_skb->len);
 
 	rx_status.ssi = buf->rssi;
 	rx_status.flag |= RX_FLAG_DECRYPTED;
@@ -1725,7 +1724,7 @@ static void at76_mac80211_tx_callback(struct urb *urb)
 }
 
 static int at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
-		  struct ieee80211_tx_control *control)
+			    struct ieee80211_tx_control *control)
 {
 	struct at76_priv *priv = hw->priv;
 	struct at76_tx_buffer *tx_buffer = priv->bulk_out_buffer;
@@ -1829,7 +1828,7 @@ static void at76_mac80211_stop(struct ieee80211_hw *hw)
 }
 
 static int at76_add_interface(struct ieee80211_hw *hw,
-			     struct ieee80211_if_init_conf *conf)
+			      struct ieee80211_if_init_conf *conf)
 {
 	struct at76_priv *priv = hw->priv;
 	int ret = 0;
@@ -1854,7 +1853,7 @@ exit:
 }
 
 static void at76_remove_interface(struct ieee80211_hw *hw,
-				 struct ieee80211_if_init_conf *conf)
+				  struct ieee80211_if_init_conf *conf)
 {
 	at76_dbg(DBG_MAC80211, "%s()", __func__);
 }
@@ -1904,8 +1903,7 @@ static void at76_dwork_hw_scan(struct work_struct *work)
 	mutex_lock(&priv->mtx);
 
 	ret = at76_get_cmd_status(priv->udev, CMD_SCAN);
-	at76_dbg(DBG_MAC80211, "%s: CMD_SCAN status 0x%02x",
-		 __func__, ret);
+	at76_dbg(DBG_MAC80211, "%s: CMD_SCAN status 0x%02x", __func__, ret);
 
 	/* FIXME: add maximum time for scan to complete */
 
@@ -1926,7 +1924,6 @@ exit:
 	mutex_unlock(&priv->mtx);
 }
 
-
 static int at76_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 {
 	struct at76_priv *priv = hw->priv;
@@ -1934,8 +1931,7 @@ static int at76_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 	int ret;
 
 	at76_dbg(DBG_MAC80211, "%s():", __func__);
-	at76_dbg_dump(DBG_MAC80211, ssid, len,
-		      "ssid %zd bytes:", len);
+	at76_dbg_dump(DBG_MAC80211, ssid, len, "ssid %zd bytes:", len);
 
 	mutex_lock(&priv->mtx);
 
@@ -1954,8 +1950,7 @@ static int at76_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 	scan.international_scan = 0;
 
 	at76_dbg(DBG_MAC80211, "%s: sending CMD_SCAN", __func__);
-	ret = at76_set_card_command(priv->udev, CMD_SCAN, &scan,
-				    sizeof(scan));
+	ret = at76_set_card_command(priv->udev, CMD_SCAN, &scan, sizeof(scan));
 
 	if (ret < 0) {
 		err("CMD_SCAN failed: %d", ret);
@@ -2099,7 +2094,6 @@ static int at76_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return 0;
 }
 
-
 static const struct ieee80211_ops at76_ops = {
 	.tx = at76_mac80211_tx,
 	.add_interface = at76_add_interface,
@@ -2208,45 +2202,27 @@ static int at76_alloc_urbs(struct at76_priv *priv,
 }
 
 static struct ieee80211_rate at76_rates[] = {
-	{ .bitrate = 10,
-	  .hw_value = TX_RATE_1MBIT, },
-	{ .bitrate = 20,
-	  .hw_value = TX_RATE_2MBIT, },
-	{ .bitrate = 55,
-	  .hw_value = TX_RATE_5_5MBIT, },
-	{ .bitrate = 110,
-	  .hw_value = TX_RATE_11MBIT, },
+	{ .bitrate = 10, .hw_value = TX_RATE_1MBIT, },
+	{ .bitrate = 20, .hw_value = TX_RATE_2MBIT, },
+	{ .bitrate = 55, .hw_value = TX_RATE_5_5MBIT, },
+	{ .bitrate = 110, .hw_value = TX_RATE_11MBIT, },
 };
 
 static struct ieee80211_channel at76_channels[] = {
-	{ .hw_value = 1,
-	  .center_freq = 2412},
-	{ .hw_value = 2,
-	  .center_freq = 2417},
-	{ .hw_value = 3,
-	  .center_freq = 2422},
-	{ .hw_value = 4,
-	  .center_freq = 2427},
-	{ .hw_value = 5,
-	  .center_freq = 2432},
-	{ .hw_value = 6,
-	  .center_freq = 2437},
-	{ .hw_value = 7,
-	  .center_freq = 2442},
-	{ .hw_value = 8,
-	  .center_freq = 2447},
-	{ .hw_value = 9,
-	  .center_freq = 2452},
-	{ .hw_value = 10,
-	  .center_freq = 2457},
-	{ .hw_value = 11,
-	  .center_freq = 2462},
-	{ .hw_value = 12,
-	  .center_freq = 2467},
-	{ .hw_value = 13,
-	  .center_freq = 2472},
-	{ .hw_value = 14,
-	  .center_freq = 2484}
+	{ .center_freq = 2412, .hw_value = 1 },
+	{ .center_freq = 2417, .hw_value = 2 },
+	{ .center_freq = 2422, .hw_value = 3 },
+	{ .center_freq = 2427, .hw_value = 4 },
+	{ .center_freq = 2432, .hw_value = 5 },
+	{ .center_freq = 2437, .hw_value = 6 },
+	{ .center_freq = 2442, .hw_value = 7 },
+	{ .center_freq = 2447, .hw_value = 8 },
+	{ .center_freq = 2452, .hw_value = 9 },
+	{ .center_freq = 2457, .hw_value = 10 },
+	{ .center_freq = 2462, .hw_value = 11 },
+	{ .center_freq = 2467, .hw_value = 12 },
+	{ .center_freq = 2472, .hw_value = 13 },
+	{ .center_freq = 2484, .hw_value = 14 }
 };
 
 static struct ieee80211_supported_band at76_supported_band = {
@@ -2256,7 +2232,6 @@ static struct ieee80211_supported_band at76_supported_band = {
 	.n_bitrates = ARRAY_SIZE(at76_rates),
 };
 
-
 /* Register network device and initialize the hardware */
 static int at76_init_new_device(struct at76_priv *priv,
 				struct usb_interface *interface)
