Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from daemonizer.de ([178.77.74.210]:33508 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320Ab3GLP1E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 11:27:04 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: Piotr Haber <phaber@broadcom.com>
Cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: Poor wireless reception on BCM4313
Date: Fri, 12 Jul 2013 17:27:23 +0200
Message-ID: <2466387.PRs18dOcM2@fuchs> (sfid-20130712_172709_826510_6B7B193C)
In-Reply-To: <51E008FC.4010104@broadcom.com>
References: <1624172.s6pnfBcJL7@fuchs> <30534146.LWDmOHhHCG@eisbaer> <51E008FC.4010104@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart274733231.CqlGd0t1NB"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart274733231.CqlGd0t1NB
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday 12 July 2013 15:47:40 Piotr Haber wrote:
> On 07/12/13 14:55, Maximilian Engelhardt wrote:
> > On Friday 21 June 2013 20:26:25 Maximilian Engelhardt wrote:
> >> Hello developers,
> >> 
> >> I'm having problems with the reception performance of my BCM4313 wireless
> >> card. The card is basically working fine, but the reception is quite bad
> >> compared to other wifi equipment. I first suspected a hardware problem,
> >> but
> >> after I tried Windows 7 with the same hardware and having no problem
> >> there
> >> I'm quite sure this is a software issue.
> >> 
> >> 
> >> Here is a more detailed explanation of a test setup I performed to show
> >> the
> >> problem:
> >> 
> >> I have an AP in about 2m distance and I connected to it by my BCM4313
> >> card
> >> and by a USB dongle (TP-Link TL-WN821N, using ath9k_htc). Both
> >> connections
> >> work and I can ping the AP using both cards.
> >> 
> >> iw dev $DEV link shows a signal of about -68 dBm for the broadcom card
> >> and
> >> about -51 dBm for the atheros dongle. I have no idea in how far one can
> >> trust these values, but the difference between these two cards mostly
> >> seems
> >> to be 20-30 dB, also in my further experiments (greater distance from the
> >> AP).
> >> 
> >> Now with both dongles being connected I move my laptop away from the AP
> >> and
> >> of course the signal is getting weaker. However at some point the
> >> broadcom
> >> card looses the connection to the AP while the USB dongle still has good
> >> connection (at this point the signal strength of the broadcom card is
> >> about
> >> -90dBm and -60dBm for the USB dongle). In my test with the Windows driver
> >> at that point the connection was still good and maximum distance till I
> >> lost the connection was much larger. So I don't think is a hardware
> >> problem.
> >> 
> >> In general I can say my BCM4313 card is only usable when I'm in vicinity
> >> of
> >> the AP. If I move further away the connection becomes unusable slow or is
> >> lost, while it is still working well using other cards/drivers.
> >> 
> >> 
> >> I'm currently using a 3.10-rc5 kernel with Debian jessie (kernel is from
> >> experimental, but the same behavior has been there with kernel 3.9, 3.8
> >> (and older)). The driver used for the broadcom card is brcmsmac.
> >> 
> >> 
> >> I did a search non the Internet regarding this issue and found some other
> >> people having the same problem but no real solution to this. There is a
> >> workaround some Ubuntu related sites, which consists of blacklisting the
> >> brcmsmac driver and installing the wl driver. With the wl driver this
> >> problem seems to be fixed according to the web (I didn't try it myself).
> >> 
> >> As I have no idea where this problem could be and how I can debug it, so
> >> I'm writing this mail now. If you need any addition information I'm
> >> happy to provide it.
> >> From the numbers shown above it seems like there is an attenuator of
> >> 20-30dB active on the receiver of the broadcom card.
> > 
> > [...]
> > 
> > 
> > Hello,
> > 
> > Is there any progress on this issue?
> > Here are the results of some additional test I performed.
> > 
> > 
> > I set up a AP (11g) and connected two client to it. The clients were my
> > bcm4313 wireless card and the TP-Link TL-WN821N USB dongle which was
> > connected to the laptop with the broadcom card. I connected both cards to
> > the AP. The distance between the cards and the AP was about 3m.
> > Then I set up another wireless card (TP-WN722N) in monitor mode about 3m
> > away from the AP and about 3m away from the laptop with the two wireless
> > cards. This card was connected to a different PC and I captured the data
> > of the clients and the AP. I then had a look at the reported SSI. You can
> > see my measured results below:
> > 
> > SSI for packets from the AP:              -27 to -23dBm
> > SSI for packets from client1 (broadcom):  -20 to -14dBm
> > SSI for packets from client2 (atheros):   -40 to -38dBm
> > 
> > The received signal from the broadcom card were quite strong. The signal
> > from the AP was a bit weaker. Interestingly the signal from the second
> > card was noticeably weaker. I didn't investigate any further as I wanted
> > to know how the broadcom cards performs in transmitting. So for me
> > transmitting power seems to be fine with the broadcom card. My guess for
> > the weaker signal from the 2nd client is ether some active power saving
> > or different propagation conditions.
> > 
> > Here are the reported signal strength from the clients (while being
> > connected to the AP):
> > client1 (broadcom): -74 to -75dBm
> > client2 (atheros):  -44 to -42dBm
> > 
> > 
> > So for me this test shows that the card only seems to have problems on
> > receiving packets, transmitting seems to work fine.
> > 
> > 
> > 
> > Additionally I performed a test with the wl driver. I booted an ubuntu
> > live CD and installed the wl driver there. Then I connected to my AP
> > using this driver and tested reception. Everything looked like it was
> > supposed to work. After connecting to the AP I got a reported signal
> > strength of about -38dBm. I then moved away from the AP and was still
> > able to get good connection where before I wasn't able to get any
> > connection at all using the brcmsmac driver.
> > 
> > 
> > 
> > Please let me know if I should perform any additional tests or if you need
> > any additional information.
> > 
> > 
> > Greetings,
> > Maxi
> 
> Hi Maximilian,
> 
> poor rx performance is observed on Wifi/Bluetooth combo modules (which
> according to hardware info sent before you have), I'm working on this
> problem.
> 
> Is Bluetooth function of the card usable under linux? What about windows?
> Could you send me output of 'lspci -nn'?
> 
> Kind regards
> Piotr

Hi Piotr,

Thank you for you reply, it's nice to hear you are working on this.

I don't use any other Bluetooth devices, however I did some tests in the past 
and there I was able to find other devices and connect to them, so I think 
Bluetooth should be working. I can do some better testing if you think it 
might be useful.

However I'm not 100% sure that my wifi card is also used for Bluetooth. I have 
the following usb device which seems to be a Blutooth device (see below for 
more details):
$ lsusb -s 004:004
Bus 004 Device 004: ID 0a5c:21f4 Broadcom Corp. 

I did a test with Windows some time ago and there wifi did work fine. However 
I did not test Bluetooth on Windows. As testing with Windows is quite 
complicated for me, so I want to avoid it if possible.

You can find the output of 'lspci -nn' below.

$ lsusb 
Bus 004 Device 004: ID 0a5c:21f4 Broadcom Corp. 
Bus 007 Device 003: ID 5986:0299 Acer, Inc 
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 007 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

$ lsusb -t 
/:  Bus 07.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/5p, 480M
    |__ Port 4: Dev 3, If 0, Class=Video, Driver=uvcvideo, 480M
    |__ Port 4: Dev 3, If 1, Class=Video, Driver=uvcvideo, 480M
/:  Bus 06.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/5p, 480M
/:  Bus 05.Port 1: Dev 1, Class=root_hub, Driver=ohci_hcd/2p, 12M
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=ohci_hcd/5p, 12M
    |__ Port 3: Dev 4, If 0, Class=Vendor Specific Class, Driver=btusb, 12M
    |__ Port 3: Dev 4, If 1, Class=Vendor Specific Class, Driver=btusb, 12M
    |__ Port 3: Dev 4, If 2, Class=Vendor Specific Class, Driver=, 12M
    |__ Port 3: Dev 4, If 3, Class=Application Specific Interface, Driver=, 12M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=ohci_hcd/5p, 12M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/2p, 5000M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/2p, 480M


$ lsusb -v -s 004:004

Bus 004 Device 004: ID 0a5c:21f4 Broadcom Corp. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass         1 
  bDeviceProtocol         1 
  bMaxPacketSize0        64
  idVendor           0x0a5c Broadcom Corp.
  idProduct          0x21f4 
  bcdDevice            1.12
  iManufacturer           1 Broadcom Corp
  iProduct                2 BCM20702A0
  iSerial                 3 C0143DC1809E
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          218
    bNumInterfaces          4
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1 
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1 
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1 
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0009  1x 9 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0009  1x 9 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       2
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1 
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0011  1x 17 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0011  1x 17 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       3
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1 
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0019  1x 25 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0019  1x 25 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       4
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1 
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0021  1x 33 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0021  1x 33 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       5
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1 
      bInterfaceProtocol      1 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0031  1x 49 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0031  1x 49 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass       254 Application Specific Interface
      bInterfaceSubClass      1 Device Firmware Update
      bInterfaceProtocol      1 
      iInterface              0 
      Device Firmware Upgrade Interface Descriptor:
        bLength                             9
        bDescriptorType                    33
        bmAttributes                        5
          Will Not Detach
          Manifestation Tolerant
          Upload Unsupported
          Download Supported
        wDetachTimeout                   5000 milliseconds
        wTransferSize                      64 bytes
        bcdDFUVersion                   1.10
Device Status:     0x0001
  Self Powered


$ lspci -nn
00:00.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family 14h Processor Root Complex [1022:1510]
00:01.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Wrestler [Radeon HD 7340] [1002:9808]
00:01.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Wrestler HDMI Audio [1002:1314]
00:05.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Family 14h Processor Root Port [1022:1513]
00:06.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Family 14h Processor Root Port [1022:1514]
00:07.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Family 14h Processor Root Port [1022:1515]
00:10.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] FCH USB XHCI Controller [1022:7812] (rev 03)
00:11.0 SATA controller [0106]: Advanced Micro Devices, Inc. [AMD] FCH SATA Controller [AHCI mode] [1022:7801]
00:12.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] FCH USB OHCI Controller [1022:7807] (rev 11)
00:12.2 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] FCH USB EHCI Controller [1022:7808] (rev 11)
00:13.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] FCH USB OHCI Controller [1022:7807] (rev 11)
00:13.2 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] FCH USB EHCI Controller [1022:7808] (rev 11)
00:14.0 SMBus [0c05]: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller [1022:780b] (rev 14)
00:14.2 Audio device [0403]: Advanced Micro Devices, Inc. [AMD] FCH Azalia Controller [1022:780d] (rev 01)
00:14.3 ISA bridge [0601]: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge [1022:780e] (rev 11)
00:14.4 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] FCH PCI Bridge [1022:780f] (rev 40)
00:14.5 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] FCH USB OHCI Controller [1022:7809] (rev 11)
00:18.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family 12h/14h Processor Function 0 [1022:1700] (rev 43)
00:18.1 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family 12h/14h Processor Function 1 [1022:1701]
00:18.2 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family 12h/14h Processor Function 2 [1022:1702]
00:18.3 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family 12h/14h Processor Function 3 [1022:1703]
00:18.4 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family 12h/14h Processor Function 4 [1022:1704]
00:18.5 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family 12h/14h Processor Function 6 [1022:1718]
00:18.6 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family 12h/14h Processor Function 5 [1022:1716]
00:18.7 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Family 12h/14h Processor Function 7 [1022:1719]
02:00.0 Network controller [0280]: Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller [14e4:4727] (rev 01)
03:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 07)
04:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS5209 PCI Express Card Reader [10ec:5209] (rev 01)


Greetings and thanks for your help,
Maxi
--nextPart274733231.CqlGd0t1NB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAABCgAGBQJR4CBfAAoJEIHqZH0kK9IV3ioQAIc1pwd4YZohxPshR2nNrFks
6K5doRvDJ3aYtAJS+PkZG4MAQwQKVZavOR1hn8BsbtVqWr6mv5FLVN4gNKn5kdOm
JAbbkErlBRuj+xneMpRcEkRaTM3zmstvO46TajGksHOnb8L6ObI5aEMVKsKhArgU
4E0FZ4DHE95E8sZppYTkiX6JosSKe8hBjsIPwV1dTkmdXey4q+t28roIrh/CO8f9
O5WLsfPJucLH4eh7HcowCm6nnEL8cY45H/h5QgACBA/IzuoRh1xVPHq1lnLv2cWk
V1xkngcwVxFI3obsAImTXugBdOuaErxXIPHjetNg8y9btJLqG5a0mUrj03+k7bNW
efOQbMqEmA1MGYKKSa270YgnRQsGyLi9N3wyde+GBOpLX2GoCcDgDuK+Opkuhem+
jo2m/nB1B6Nd1pRU46X/APjovCcDr2vdX0A2DJYfaIxedhsFscl+pEURnYabcS/K
U/vkYY9grTCcmb01Rsae1OdbBVvHrNdxyOgN6jBYwAIlEHj4P17pZdh/meh7jI9D
OdWXkAageOsUyqcEP7F9ZYH5FfM7vKpkIjorf6EZQx+Q8JBX3RyhPTkQ0fPsH7hu
CKwfY9bYeOqAcSrHXeqc9PqFsrxo4to76i/GI4cGRqJEuku61J63zNaUCe/TI66I
tvlR0oUdah3+dAX/zlMM
=mecW
-----END PGP SIGNATURE-----

--nextPart274733231.CqlGd0t1NB--

