Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58731 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759552Ab3BZQu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 11:50:27 -0500
Date: Tue, 26 Feb 2013 10:50:21 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Christian Lamparter <chunkeey@googlemail.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-wireless@vger.kernel.org,
	USB list <linux-usb@vger.kernel.org>
Subject: Re: carl9170 A-MPDU transmit problem
Message-ID: <20130226165021.GA19077@thinkpad-t410> (sfid-20130226_175040_856247_50CFFE86)
References: <Pine.LNX.4.44L0.1302251516240.1184-100000@iolanthe.rowland.org>
 <201302260030.58332.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201302260030.58332.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 26, 2013 at 12:30:58AM +0100, Christian Lamparter wrote:
> On Monday, February 25, 2013 09:19:03 PM Alan Stern wrote:
> > On Mon, 25 Feb 2013, Seth Forshee wrote:
> > > > > >ffff88012fe19500 1519981417 S Bo:3:003:1 -115 126 = 7e000000 ... <-- DATA
> > > > > >
> > > > > > [... long period where the device receives commands on EP4 and sends
> > > > > > wifi data to the host via EP2 - so it is working!]
> > > > > >
> > > > > >ffff880146c8af00 1522200650 S Bo:3:003:1 -115 62 = 3e000000 ... <-- DELBA
> > > > > >ffff88012fe19500 1522200720 C Bo:3:003:1 0 126 > <-- DATA urb completion
> > > > > >ffff880146c8af00 1522200756 C Bo:3:003:1 0 62 > <-- DELBA urb completion
> > 
> > > > Which kernel version are you testing under?  Can you please recompile
> > > > with CONFIG_USB_DEBUG and CONFIG_USB_XHCI_HCD_DEBUGGING turned on, and
> > > > send me dmesg?  I should be able to see if there's an unhandled pending
> > > > event on the xHCI rings if the data URB stalls for longer than say, a
> > > > minute.
> > > 
> > > I'll do this.
> > 
> > Bear in mind that the usbmon trace shows the URB stalling for 2 - 3
> > seconds.  There may have been other examples that went on for longer,
> > but probably nothing anywhere near as long as a minute.
> > 
> ---
> This should open up the window for as long as we want it. 
> The driver will now queue, but not deliver any frames to
> the device when there are unfinished urbs.

Here's dmesg with USB debug with the patch. I let it run for at least 5
minutes after the connection stalled.

http://people.canonical.com/~sforshee/dmesg-carl9170-usb-debug2.txt

I pasted lsusb for the device below as well.

Thanks,
Seth


Bus 003 Device 004: ID 07d1:3a09 D-Link System DWA-160 802.11abgn Xtreme 
N Dual Band Adapter(rev.A2) [Atheros AR9170+AR9104]
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  idVendor           0x07d1 D-Link System
  idProduct          0x3a09 DWA-160 802.11abgn Xtreme N Dual Band Adapter(rev.A2) [Atheros AR9170+AR9104]
  bcdDevice            1.07
  iManufacturer          16 ATHER
  iProduct               32 11n adapter
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

