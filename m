Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C116FC169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 09:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A45820857
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 09:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbfA2JMc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 04:12:32 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:60489 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfA2JMc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 04:12:32 -0500
Received: from [192.168.178.52] ([109.104.39.36]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1M2w4S-1grhlL3RJU-003Nqv; Tue, 29 Jan 2019 10:12:23 +0100
From:   Stefan Wahren <stefan.wahren@i2se.com>
Subject: mt76x0: probing issues on Raspberry Pi
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Message-ID: <ee482b50-e20f-df8c-3e87-4f7796210f73@i2se.com>
Date:   Tue, 29 Jan 2019 10:12:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Provags-ID: V03:K1:azYi6qDu5qeyJ2zSlDXTR+SvVFOmKTKlz8LFdyswrOqdeSr7eOR
 1lQDnrnS33fJOLOStb1qqSSiHbkKIpubJhs9or3WS/HK57HYs7EyUiyGM9d8XrVBK6Ue7Gq
 MKNz+c9uEdwGdgApC5G6ygeEtVd+oO3Vb+6+wwKUIv0PCfVIwcwAW8ixqJE0Jr5diKv2czG
 82hXnPjHzFhK5u3lPoVyA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:lV+PrADk2dk=:YOeWWDAsv7VyvLbvRfcBMi
 jzclmHICE0WI9p6SYm23i3cGqRYN77DWl9yEfEue3WS2cUx0bVqKTdak7IOnbLQUcvDHvOZ3s
 7VFYpQ36D9YCL1Ytxh6+2RpuAV4WddQ46GZofgm77dD3tRfNjz1yy3lSpZWdep8Nb9ZRsNV3v
 CQJUpB9Kdm1YtP7IfxiYyNQYm7d5xw9CnnExvyIcxMFDwi9VhYtTP3owtgDLdVME7dU5msNLz
 PKaLOJRq6VfipYJmYBBU0ISP6M8Dsb8SCr6PhfQrMDy0Dvn3G4l3f8Y3aAO1zZwc3PpzI3CNc
 PjplM7QDhfJbvQVIkza5PrSZ0WaXQZNsjIVTPaPDBhC/7FuWMdBFB3J7VKOX6cGlRrx6MhxJg
 RSizPKE4baZ7qKHMuixmhdk0Ne7cpSiFsG+oms66vbHFFt5If1oMsyMxHYDq10v8Wep4sv8FW
 Nju6Qnr7Pa8Vind52QrJ0PjYOPNIKwsCfYPk2QxHQrZOTUyNt95/1++aj6oEKdp+Kxu4CSNgh
 dFPZ/fAA8DKNbGGzsDHahBy8wmXGgI8CH0G0YRWKGSd6OKSTic4ex3HL/NaCKiIeeJ54cbcC8
 6DfjKlKsl5n3q9dVxugCwt7VaLKYCaiH7Kjp725m/A4NSGqidx1LvL0514mhbnNpRZnX27u//
 enEtE60nILn/w37vk+XMoRh/FTWX1zgrRYstGzdjcBEWarGiyqHJrEuU4pBhSGifkkkntn6ct
 F3Twu08deiPf5gPEKvyonytoD++RRgj0uJ1WK9Kd9PCPPlkuU3hEdjFEals=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

recently i discovered a bug report about probing issues of the mt76x0
driver using T2U Archer on the Raspberry Pi 3 B (Linux 4.19.14, Aarch64)
[1].

Also i tried a T2UH Archer on my Raspberry Pi 3 B+ with a recent
Linux-Next and i'm getting the following output:

Vendor request req:07 off:0404 failed:-110
...

instead of successful probe. The author of the former bug report
provided the "lsusb -v" on a working system:

Bus 001 Device 009: ID 148f:761a Ralink Technology, Corp. MT7610U
("Archer T2U" 2.4G+5G WLAN Adapter
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.01
  bDeviceClass            0
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x148f Ralink Technology, Corp.
  idProduct          0x761a MT7610U ("Archer T2U" 2.4G+5G WLAN Adapter
  bcdDevice            1.00
  iManufacturer           1 MediaTek
  iProduct                2 WiFi
  iSerial                 3 1.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x004a
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              160mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           8
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      2
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x08  EP 8 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x05  EP 5 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x06  EP 6 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x07  EP 7 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x09  EP 9 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
Binary Object Store Descriptor:
  bLength                 5
  bDescriptorType        15
  wTotalLength       0x000c
  bNumDeviceCaps          1
  USB 2.0 Extension Device Capability:
    bLength                 7
    bDescriptorType        16
    bDevCapabilityType      2
    bmAttributes   0x00000002
      HIRD Link Power Management (LPM) Supported
can't get debug descriptor: Resource temporarily unavailable
Device Status:     0x0000
  (Bus Powered)

The BCM2835 on the Raspberry Pi only have 8 EP. So i suspect that the
amount of EP is the problem here.

Is it possible to reduce them in the mt76x0 driver?

[1] - https://github.com/raspberrypi/linux/issues/2817
