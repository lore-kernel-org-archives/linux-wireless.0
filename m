Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f31.google.com ([209.85.219.31]:52746 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbZBQJti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 04:49:38 -0500
Received: by ewy12 with SMTP id 12so967528ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2009 01:49:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <499A00D7.1080000@lwfinger.net>
References: <4999F3A6.7020208@gmail.com> <4999F427.4060008@lwfinger.net>
	 <3ace41890902161603o447ae321obb536586dcafad69@mail.gmail.com>
	 <499A00D7.1080000@lwfinger.net>
Date: Tue, 17 Feb 2009 10:49:36 +0100
Message-ID: <63d38a500902170149q275bcb87r9ada40439a013dc7@mail.gmail.com> (sfid-20090217_104945_238807_7B643EBD)
Subject: Re: rtl8187 not handling my usb card
From: =?ISO-8859-2?Q?Viktor_Ilija=B9i=E6?= <viktor.ilijasic@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all.

Yesterday evening I tried John's patch (I manually added those two
lines to the source), and the driver properly loads and it seem to
work.

However.... it would seem that my card died some time in the last few
days. It works for about 10-15 seconds after i plug it in, and then
"dies". I'd say that when it gets warm, it's out of the game.

In Linux after i plug it in, it works just enough time to:
1. detect networks in ubuntu network manager (and return a nice scan
result with iwlist wlan3 scan)
2. starts to connect to my network (and reaches random points in connecting)
3. stops responding altogether, cannot connect, no more results with
iwlist scan, etc.

I noticed this exact behavior in windows too, yesterday morning,
before I tried these patches, so linux driver is DEFINITELY not to
blame.

In windows it very shortly detects available networks, starts to
connect and very soon stops responding and finding networks.

I'll return it to shop to be replaced, and I'll report back when I get
one that works properly.

Also, Larry, I took lsusb -v output during those first few moments
while the card operates properly, hope it helps:

$ sudo lsusb -v
Bus 004 Device 004: ID 1b75:8187
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x1b75
  idProduct          0x8187
  bcdDevice            1.00
  iManufacturer           1 Manufacturer_Realtek_RTL8187_
  iProduct                2 AirLive WL1600USB
  iSerial                 3 004F78000572
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          4 Wireless Network Card
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass         0 (Defined at Interface level)
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              5 Bulk-IN,Bulk-OUT,Bulk-OUT
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)


Hin-Tak, I did see the AirLive linux reference driver, but didn't even
want to try that, unless my only option left was ndiswrapper. I know
those manufacturer's "drivers" usually cause more frustration than
use.

Thanks all for your time and help.

Viktor


--
Don't let people drive you crazy when you know it's in walking distance.


On Tue, Feb 17, 2009 at 01:12, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> Hin-Tak Leung wrote:
> > Hiya,
> >
> > A quick search on google shows Airlive hosting a linux driver here:
> >
> > http://www.airlive.com/support/support_3a.jsp?pdid=PD1223473034861
> >
> > I had a quick look  and indeed it looks like the realtek vendor driver
> > (or a variant of) for 8187L.
> > Note that this is for reference, since we all know the vendor driver
> > has some issues with the latest wireless stack, etc.
>
> Once I get confirmation from the OP that his device works, I have a patch with a
> total of 6 new ID's for rtl8187. Four of them came from the .inf file
> accompaning the Windows version of the RTL8187L driver.
>
> Larry
