Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39014 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753224AbZIOLhO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 07:37:14 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [RFC] ar9170usb: add ar9170 usbid
Date: Tue, 15 Sep 2009 13:37:13 +0200
Cc: Fabian Lenz <lenz_fabian@yahoo.de>, linux-wireless@vger.kernel.org,
	Stephen.Chen@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
References: <200909142046.07525.lenz_fabian@yahoo.de> <200909150752.19146.lenz_fabian@yahoo.de> <200909151006.26631.chunkeey@googlemail.com>
In-Reply-To: <200909151006.26631.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909151337.15163.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tuesday 15 September 2009, Christian Lamparter wrote:
> On Tuesday 15 September 2009 07:52:19 Fabian Lenz wrote:
> > Here the output of lsusb: 
> > 
> > Bus 002 Device 003: ID 0cf3:1002 Atheros Communications, Inc.
> 
> they made two revisions (v1 and v2).
> Do you know which one you've got?

v1 (FCC ID: TE7WN821NV1) at least identifies itself as:
ID 0cf3:9170 Atheros Communications, Inc. AR9170 802.11n

> > and the product page of the WLAN stick:
> > 
> > http://www.tp-link.com/products/product_des.asp?id=140
> > 
> > I added { USB_DEVICE(0x0cf3, 0x1002) } to the usb.c file manually some time 
> > ago and got my stick to work but the connection is somewhat unstable... but 
> > that's another story.
> what firmware image do you use?
> the two-stage (ar9170-1.fw & ar9170-2.fw) firmware should work.
> for one-stage you should use a bleeding edge wireless-testing tree.

On this TL-WN821N v1 the one-stage (as published in binary from by Atheros,
so far I had problems with my self compiled one) and two-stage firmwares 
work equally well on a vanilla 2.6.31 kernel:

usb 1-2: new high speed USB device using ehci_hcd and address 4                                  
usb 1-2: New USB device found, idVendor=0cf3, idProduct=9170                                     
usb 1-2: New USB device strings: Mfr=16, Product=32, SerialNumber=48                             
usb 1-2: Product: USB2.0 WLAN                                                                    
usb 1-2: Manufacturer: ATHER                                                                     
usb 1-2: SerialNumber: 12345
usb 1-2: configuration #1 chosen from 1 choice
usb 1-2: reset high speed USB device using ehci_hcd and address 4
usb 1-2: firmware: requesting ar9170.fw
ath: EEPROM regdomain: 0x809c
ath: EEPROM indicates we should expect a country code
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x52
ath: Country alpha2 being used: CN
ath: Regpair used: 0x52
phy2: Selected rate control algorithm 'minstrel'
cfg80211: Calling CRDA for country: CN
Registered led device: ar9170-phy2::tx
Registered led device: ar9170-phy2::assoc
usb 1-2: Atheros AR9170 is registered as 'phy2'
usbcore: registered new interface driver ar9170usb
udev: renamed network interface wlan2 to wlan3
cfg80211: Current regulatory domain intersected:
        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
        (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)

Regards
	Stefan Lippers-Hollmann
