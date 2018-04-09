Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:50477 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbeDIStG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 14:49:06 -0400
Received: by mail-wm0-f48.google.com with SMTP id t67so21328436wmt.0
        for <linux-wireless@vger.kernel.org>; Mon, 09 Apr 2018 11:49:05 -0700 (PDT)
Date: Mon, 9 Apr 2018 20:45:20 +0200 (CEST)
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        =?ISO-8859-2?Q?Jakub_Kici=F1ski?= <moorray3@wp.pl>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [ANN] mt76x0 usb driver
In-Reply-To: <20180409141032.GA9247@redhat.com>
Message-ID: <alpine.LNX.2.00.1804092042320.8369@T420s> (sfid-20180409_204910_419690_0DA99EC8)
References: <20180409141032.GA9247@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Mon, 9 Apr 2018, Stanislaw Gruszka wrote:

> Hi
> 
> I would like to announce mt76x0 driver for MT7610U USB dongles:
> 
> https://github.com/sgruszka/mt76x0
> 
> mt76x0 is based on Jakub's mt7601u mac80211 driver and is intended to be
> integrated in the linux kernel.
> 
> Currently only Linksys AE6000 (ID 13b1:003e) in on USB id's list
> and 5GHz does not work.
> 

here are my changes for working 5Ghz band and more USB ID's form my side

diff --git a/phy.c b/phy.c
index e1af2b0..460bd4e 100644
--- a/phy.c
+++ b/phy.c
@@ -350,7 +350,7 @@ mt76x0_phy_set_band(struct mt76x0_dev *dev, enum nl80211_band band)
 static void
 mt76x0_phy_set_chan_rf_params(struct mt76x0_dev *dev, u8 channel, u16 rf_bw_band)
 {
-	u16 rf_band = rf_bw_band & 0xff00;
+	u16 rf_band;
 	u16 rf_bw = rf_bw_band & 0x00ff;
 	u32 mac_reg;
 	u8 rf_val;
@@ -367,6 +367,7 @@ mt76x0_phy_set_chan_rf_params(struct mt76x0_dev *dev, u8 channel, u16 rf_bw_band
 
 	for (i = 0; i < ARRAY_SIZE(mt76x0_frequency_plan); i++) {
 		if (channel == mt76x0_frequency_plan[i].channel) {
+			rf_band = mt76x0_frequency_plan[i].band;
 
 			if (bSDM)
 				freq_item = &(mt76x0_sdm_frequency_plan[i]);
diff --git a/usb.c b/usb.c
index efae0a0..6b9a505 100644
--- a/usb.c
+++ b/usb.c
@@ -20,7 +20,29 @@
 #include "trace.h"
 
 static struct usb_device_id mt76x0_device_table[] = {
-	{ USB_DEVICE(0x13b1,0x003e) },
+	{ USB_DEVICE(0x148F, 0x7610) },	/* MT7610U */
+	{ USB_DEVICE(0x13B1, 0x003E) },	/* Linksys AE6000 */
+	{ USB_DEVICE(0x0E8D, 0x7610) },	/* Sabrent NTWLAC */
+	{ USB_DEVICE(0x7392, 0xa711) },	/* Edimax 7711mac */
+	{ USB_DEVICE(0x7392, 0xb711) },	/* Edimax / Elecom  */
+	{ USB_DEVICE(0x148f, 0x761a) },	/* TP-Link TL-WDN5200 */
+	{ USB_DEVICE(0x148f, 0x760a) },	/* TP-Link unknown */
+	{ USB_DEVICE(0x0b05, 0x17d1) },	/* Asus USB-AC51 */
+	{ USB_DEVICE(0x0b05, 0x17db) },	/* Asus USB-AC50 */
+	{ USB_DEVICE(0x0df6, 0x0075) },	/* Sitecom WLA-3100 */
+	{ USB_DEVICE(0x2019, 0xab31) },	/* Planex GW-450D */
+	{ USB_DEVICE(0x2001, 0x3d02) },	/* D-LINK DWA-171 rev B1 */
+	{ USB_DEVICE(0x0586, 0x3425) },	/* Zyxel NWD6505 */
+	{ USB_DEVICE(0x07b8, 0x7610) },	/* AboCom AU7212 */
+	{ USB_DEVICE(0x04bb, 0x0951) },	/* I-O DATA WN-AC433UK */
+	{ USB_DEVICE(0x057c, 0x8502) },	/* AVM FRITZ!WLAN USB Stick AC 430 */
+	{ USB_DEVICE(0x293c, 0x5702) },	/* Comcast Xfinity KXW02AAA  */
+	{ USB_DEVICE(0x20f4, 0x806b) },	/* TRENDnet TEW-806UBH  */
+	{ USB_DEVICE(0x7392, 0xc711) }, /* Devolo Wifi ac Stick */
+	{ USB_DEVICE(0x0df6, 0x0079) }, /* Sitecom Europe B.V. ac  Stick */
+	{ USB_DEVICE(0x2357, 0x0105) }, /* TP-LINK Archer T1U */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0E8D, 0x7630, 0xff, 0x2, 0xff)}, /* MT7630U */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0E8D, 0x7650, 0xff, 0x2, 0xff)}, /* MT7650U */
 	{ 0, }
 };
 
Greetings
Hans
