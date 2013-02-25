Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:65286 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab3BYXbC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 18:31:02 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: carl9170 A-MPDU transmit problem
Date: Tue, 26 Feb 2013 00:30:58 +0100
Cc: Seth Forshee <seth.forshee@canonical.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.1302251516240.1184-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1302251516240.1184-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302260030.58332.chunkeey@googlemail.com> (sfid-20130226_003107_138761_F300751B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, February 25, 2013 09:19:03 PM Alan Stern wrote:
> On Mon, 25 Feb 2013, Seth Forshee wrote:
> > > > >ffff88012fe19500 1519981417 S Bo:3:003:1 -115 126 = 7e000000 ... <-- DATA
> > > > >
> > > > > [... long period where the device receives commands on EP4 and sends
> > > > > wifi data to the host via EP2 - so it is working!]
> > > > >
> > > > >ffff880146c8af00 1522200650 S Bo:3:003:1 -115 62 = 3e000000 ... <-- DELBA
> > > > >ffff88012fe19500 1522200720 C Bo:3:003:1 0 126 > <-- DATA urb completion
> > > > >ffff880146c8af00 1522200756 C Bo:3:003:1 0 62 > <-- DELBA urb completion
> 
> > > Which kernel version are you testing under?  Can you please recompile
> > > with CONFIG_USB_DEBUG and CONFIG_USB_XHCI_HCD_DEBUGGING turned on, and
> > > send me dmesg?  I should be able to see if there's an unhandled pending
> > > event on the xHCI rings if the data URB stalls for longer than say, a
> > > minute.
> > 
> > I'll do this.
> 
> Bear in mind that the usbmon trace shows the URB stalling for 2 - 3
> seconds.  There may have been other examples that went on for longer,
> but probably nothing anywhere near as long as a minute.
> 
---
This should open up the window for as long as we want it. 
The driver will now queue, but not deliver any frames to
the device when there are unfinished urbs.

Note: Just in case someone is interested in the interval
values of the eps. I attached a lsusb dump of a typical
carl9170 device (So, apart from the vendor and product
id, it should be the same for DWA-160 A2).

Regards,
	Christian
---
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 9c0b150..3931a1e 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -598,7 +598,6 @@ next:
 		 *  - all bugs you can't...
 		 *  - ...
 		 */
-		carl9170_restart(ar, CARL9170_RR_STUCK_TX);
 	}
 }
 
@@ -1336,6 +1335,9 @@ static void carl9170_tx(struct ar9170 *ar)
 	if (unlikely(!IS_STARTED(ar)))
 		return;
 
+	if (atomic_read(&ar->tx_total_pending))
+		return;
+
 	carl9170_usb_handle_tx_err(ar);
 
 	for (i = 0; i < ar->hw->queues; i++) {
---

Bus 004 Device 005: ID 0846:9010 NetGear, Inc. WNDA3100v1 802.11abgn [Atheros AR9170+AR9104]
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  idVendor           0x0846 NetGear, Inc.
  idProduct          0x9010 WNDA3100v1 802.11abgn [Atheros AR9170+AR9104]
  bcdDevice            1.06
  iManufacturer          16 ATHER
  iProduct               32 USB2.0 WLAN
  iSerial                48 12345
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  bNumConfigurations      0
Device Status:     0x0000
  (Bus Powered)
