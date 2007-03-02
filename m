Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44137 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932961AbXCBSp0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 13:45:26 -0500
From: Helge Deller <deller@gmx.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] p54 various cleanups
Date: Fri, 2 Mar 2007 19:45:20 +0100
Cc: linux-wireless@vger.kernel.org
References: <200702272219.58919.deller@gmx.de> <200702271826.07149.flamingice@sourmilk.net>
In-Reply-To: <200702271826.07149.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200703021945.20954.deller@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 February 2007, Michael Wu wrote:
> On Tuesday 27 February 2007 16:19, Helge Deller wrote:
> > Patch below
> > - uses PCI_DEVICE macro
> > - adds a "const" to the p54_ops struct and
> > - replaces "__attribute__ ((packed))" by the generic "__packed" keyword.
> >
> > Signed-off-by: Helge Deller <deller@gmx.de>
> >
> > PS: There are more possibilities to replace "__attribute__ ((packed))" by
> > the "__packed". Is this wished ? If yes, I can send additional patches for
> > the other subdirectories...
> >
> If you don't mind, please split each cleanup into a separate patch and do all 
> d80211 drivers at the same time. adm8211 can also use the PCI_DEVICE cleanup, 
> and adm8211, rt2x00, rtl8187, and zd1211rw can also switch to a const 
> ieee80211_ops struct. I don't take patches for rt2x00 so you can either have 
> a patch with the adm8211/p54/zd1211rw ieee80211_ops cleanup and another with  
> the rt2x00 ieee80211_ops cleanup or you can make one big ieee80211_ops patch 
> and let Linville apply that patch.
> 
> As for the __packed cleanup, I do not see any code in the kernel that uses 
> __packed, so I think it would be better if we dropped that for now.

Hi Michael,

thanks for the feedback.
I dropped the __packed patch, and instead just modified the drivers you mentioned.
Patch follows:


[PATCH] use PCI_DEVICE macro and add some const/__read_mostly annotations
Signed-off-by: Helge Deller <deller@gmx.de>

 adm8211/adm8211.c         |   18 +++++++++---------
 p54/prism54common.c       |    2 +-
 p54/prism54pci.c          |    8 ++++----
 rtl818x/rtl8187_dev.c     |    2 +-
 rtl818x/rtl8187_rtl8225.c |    4 ++--
 zd1211rw/zd_mac.c         |    2 +-
 zd1211rw/zd_rf.c          |    2 +-
 zd1211rw/zd_rf_al7230b.c  |    4 ++--
 zd1211rw/zd_rf_rf2959.c   |    4 ++--
 9 files changed, 23 insertions(+), 23 deletions(-)


diff --git a/drivers/net/wireless/mac80211/adm8211/adm8211.c b/drivers/net/wireless/mac80211/adm8211/adm8211.c
index 525821b..270e616 100644
--- a/drivers/net/wireless/mac80211/adm8211/adm8211.c
+++ b/drivers/net/wireless/mac80211/adm8211/adm8211.c
@@ -34,25 +34,25 @@ MODULE_DESCRIPTION("Driver for IEEE 802.
 MODULE_SUPPORTED_DEVICE("ADM8211");
 MODULE_LICENSE("GPL");
 
-static unsigned int tx_ring_size = 16;
-static unsigned int rx_ring_size = 16;
-static int debug = 1;
+static unsigned int tx_ring_size __read_mostly = 16;
+static unsigned int rx_ring_size __read_mostly = 16;
+static int debug __read_mostly = 1;
 
 module_param(tx_ring_size, uint, 0);
 module_param(rx_ring_size, uint, 0);
 module_param(debug, int, 0);
 
-static const char *version = KERN_INFO "adm8211: "
+static const char version[] = KERN_INFO "adm8211: "
 "Copyright 2003, Jouni Malinen <jkmaline@cc.hut.fi>; "
 "Copyright 2004-2006, Michael Wu <flamingice@sourmilk.net>\n";
 
 
 static struct pci_device_id adm8211_pci_id_table[] __devinitdata = {
 	/* ADMtek ADM8211 */
-	{ 0x10B7, 0x6000, PCI_ANY_ID, PCI_ANY_ID }, /* 3Com 3CRSHPW796 */
-	{ 0x1200, 0x8201, PCI_ANY_ID, PCI_ANY_ID }, /* ? */
-	{ 0x1317, 0x8201, PCI_ANY_ID, PCI_ANY_ID }, /* ADM8211A */
-	{ 0x1317, 0x8211, PCI_ANY_ID, PCI_ANY_ID }, /* ADM8211B/C */
+	{ PCI_DEVICE(0x10B7, 0x6000) }, /* 3Com 3CRSHPW796 */
+	{ PCI_DEVICE(0x1200, 0x8201) }, /* ? */
+	{ PCI_DEVICE(0x1317, 0x8201) }, /* ADM8211A */
+	{ PCI_DEVICE(0x1317, 0x8211) }, /* ADM8211B/C */
 	{ 0 }
 };
 
@@ -1898,7 +1898,7 @@ static int adm8211_alloc_rings(struct ie
 	return 0;
 }
 
-static struct ieee80211_ops adm8211_ops = {
+static const struct ieee80211_ops adm8211_ops = {
 	.tx			= adm8211_tx,
 	.reset			= adm8211_reset,
 	.open			= adm8211_open,
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
diff --git a/drivers/net/wireless/mac80211/rtl818x/rtl8187_dev.c b/drivers/net/wireless/mac80211/rtl818x/rtl8187_dev.c
index 6a203d4..8d49391 100644
--- a/drivers/net/wireless/mac80211/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/mac80211/rtl818x/rtl8187_dev.c
@@ -507,7 +507,7 @@ static int rtl8187_config_interface(stru
 	return 0;
 }
 
-static struct ieee80211_ops rtl8187_ops = {
+static const struct ieee80211_ops rtl8187_ops = {
 	.tx			= rtl8187_tx,
 	.open			= rtl8187_open,
 	.stop			= rtl8187_stop,
diff --git a/drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c b/drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c
index 2bcd0f0..d278aa1 100644
--- a/drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c
+++ b/drivers/net/wireless/mac80211/rtl818x/rtl8187_rtl8225.c
@@ -210,7 +210,7 @@ static const u16 rtl8225bcd_rxgain[] = {
 	0x07b4, 0x07b5, 0x07b8, 0x07b9, 0x07ba, 0x07bb, 0x07bb
 };
 
-const u8 rtl8225_agc[] = {
+const const u8 rtl8225_agc[] = {
 	0x9e, 0x9e, 0x9e, 0x9e, 0x9e, 0x9e, 0x9e, 0x9e,
 	0x9d, 0x9c, 0x9b, 0x9a, 0x99, 0x98, 0x97, 0x96,
 	0x95, 0x94, 0x93, 0x92, 0x91, 0x90, 0x8f, 0x8e,
@@ -269,7 +269,7 @@ static const u8 rtl8225_tx_power_ofdm[] 
 	0x80, 0x90, 0xa2, 0xb5, 0xcb, 0xe4
 };
 
-const u32 rtl8225_chan[] = {
+const const u32 rtl8225_chan[] = {
 	0x085c, 0x08dc, 0x095c, 0x09dc, 0x0a5c, 0x0adc, 0x0b5c,
 	0x0bdc, 0x0c5c, 0x0cdc, 0x0d5c, 0x0ddc, 0x0e5c, 0x0f72
 };
diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
index 5b9e04a..7a3b3b5 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
@@ -591,7 +591,7 @@ static void zd_mac_set_multicast_list(st
 	queue_work(zd_workqueue, &mac->set_multicast_hash_work);
 }
 
-static struct ieee80211_ops zd_ops = {
+static const struct ieee80211_ops zd_ops = {
 	.tx			= zd_mac_tx,
 	.open			= zd_mac_open,
 	.stop			= zd_mac_stop,
diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_rf.c b/drivers/net/wireless/mac80211/zd1211rw/zd_rf.c
index f50cff3..701e8cb 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_rf.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_rf.c
@@ -23,7 +23,7 @@ #include "zd_rf.h"
 #include "zd_ieee80211.h"
 #include "zd_chip.h"
 
-static const char *rfs[] = {
+static const char * const rfs[] = {
 	[0]		= "unknown RF0",
 	[1]		= "unknown RF1",
 	[UW2451_RF]	= "UW2451_RF",
diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_rf_al7230b.c b/drivers/net/wireless/mac80211/zd1211rw/zd_rf_al7230b.c
index a289f95..bd07c9b 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_rf_al7230b.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_rf_al7230b.c
@@ -183,12 +183,12 @@ static int al7230b_set_channel(struct zd
 	const u32 *rv = chan_rv[channel-1];
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 
-	struct zd_ioreq16 ioreqs_1[] = {
+	static const struct zd_ioreq16 ioreqs_1[] = {
 		{ CR128, 0x14 }, { CR129, 0x12 }, { CR130, 0x10 },
 		{ CR38,  0x38 }, { CR136, 0xdf },
 	};
 
-	struct zd_ioreq16 ioreqs_2[] = {
+	static const struct zd_ioreq16 ioreqs_2[] = {
 		/* PLL_ON */
 		{ CR251, 0x3f },
 		{ CR203, 0x06 }, { CR240, 0x08 },
diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_rf_rf2959.c b/drivers/net/wireless/mac80211/zd1211rw/zd_rf_rf2959.c
index 5824727..2d736bd 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_rf_rf2959.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_rf_rf2959.c
@@ -21,7 +21,7 @@ #include "zd_rf.h"
 #include "zd_usb.h"
 #include "zd_chip.h"
 
-static u32 rf2959_table[][2] = {
+static const u32 rf2959_table[][2] = {
 	RF_CHANNEL( 1) = { 0x181979, 0x1e6666 },
 	RF_CHANNEL( 2) = { 0x181989, 0x1e6666 },
 	RF_CHANNEL( 3) = { 0x181999, 0x1e6666 },
@@ -228,7 +228,7 @@ static int rf2959_init_hw(struct zd_rf *
 static int rf2959_set_channel(struct zd_rf *rf, u8 channel)
 {
 	int i, r;
-	u32 *rv = rf2959_table[channel-1];
+	const u32 *rv = rf2959_table[channel-1];
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 
 	for (i = 0; i < 2; i++) {



