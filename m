Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:37019 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757444AbXLGUiz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 15:38:55 -0500
Received: from [195.4.92.16] (helo=6.mx.freenet.de)
	by mout2.freenet.de with esmtpa (Exim 4.68)
	(envelope-from <lynx.abraxas@freenet.de>)
	id 1J0jyI-00020e-DE
	for linux-wireless@vger.kernel.org; Fri, 07 Dec 2007 21:38:54 +0100
Received: from p508e5b6e.dip.t-dialin.net ([80.142.91.110]:47188 helo=localhost)
	by 6.mx.freenet.de with esmtpsa (ID lynx.abraxas@freenet.de) (TLSv1:AES256-SHA:256) (port 587) (Exim 4.68 #1)
	id 1J0jyH-0004jk-Ty
	for linux-wireless@vger.kernel.org; Fri, 07 Dec 2007 21:38:54 +0100
Date: Fri, 7 Dec 2007 21:38:53 +0100
From: lynx.abraxas@freenet.de
To: linux-wireless@vger.kernel.org
Subject: Re: What's wrong if wlan0 device is not reacting?
Message-ID: <20071207203853.GA10241@drago> (sfid-20071207_203950_462454_7112933E)
References: <20071206170858.GA2008@drago> <8e6f94720712061052p105a9e82v290afb011765ba04@mail.gmail.com> <20071206214807.GB1811@drago> <43e72e890712061714i3427f558p9b94390955b0a817@mail.gmail.com> <c68f135e0712070221x36cffd95q724d8ecb23f4e1cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c68f135e0712070221x36cffd95q724d8ecb23f4e1cf@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/12/07 11:21:53, Andrea Merello wrote:
> > > > lsusb tells me the  manufacturer  is  Realtek  rtl8187  so   I   compiled, installed
> > > > and modprobed rtl8187 for the 2.6.22.5 kernel.
> 
> Can you please tell us which version of RF frontend and MAC processor
> do you have?
> You can see it in the dmesg output. I need the line where it talks about rtl8225

Dec  7 21:05:53 drago kernel: wmaster0: Selected rate control algorithm 'simple'
Dec  7 21:05:54 drago kernel: phy0: hwaddr 00:11:3b:0a:fc:ac, rtl8187 V1 + rtl8225z2
Dec  7 21:05:54 drago kernel: usbcore: registered new interface driver rtl8187


> > > iwlist wlan0 scan gives: wlan0 No scan results
>
> Should the scan find a lot of APs or just one ? Are you close to any
> AP? If you have other working cards can you please provide us a
> indicative measure of AP signal strength? Is it possible that the
> sensitivity of the card is not enough to find the AP? on which channel
> is the AP?

Scan could find more than one but here is what my orinoco card yields:

iwlist eth1 scan
eth1      Scan completed :
          Cell 01 - Address: 00:04:0E:8F:19:0D
                    ESSID:"home-WLAN"
                    Mode:Master
                    Frequency:2.462 GHz (Channel 11)
                    Signal level:-56 dBm  Noise level:-104 dBm
                    Encryption key:on


The  AP  is  just  5 meters away and the signal is close to best. I'm not sure
though if I have to set the sensitivity of  the  device  with  iwconfig  wlan0
txpower ???
What configuration should I do anyway? I do:

modprobe rtl8187
iwconfig wlan0 key foo_key
iwconfig wlan0 essid home-WLAN
ifconfig wlan0 192.168.2.23 or dhcpcd -d wlan0

lsmod|sort
Module                  Size  Used by
ac97_bus                2432  1 snd_ac97_codec
arc4                    2176  2
blkcipher               6660  1 ecb
cfg80211                7176  1 mac80211
crypto_algapi          14720  3 arc4,ecb,cryptomgr
cryptomgr               3712  0
ecb                     3712  2
eeprom_93cx6            2432  1 rtl8187
ehci_hcd               34572  0
evdev                  10368  1
fat                    50588  1 vfat
floppy                 56100  0
hermes                  7424  2 orinoco_cs,orinoco
mac80211              123012  2 rtl8187,rc80211_simple
mousedev               12808  1
nls_base                7680  2 vfat,fat
orinoco                41620  1 orinoco_cs
orinoco_cs             15876  1
pcmcia                 38676  5 orinoco_cs
pcmcia_core            38800  4 orinoco_cs,pcmcia,yenta_socket,rsrc_nonstatic
rc80211_simple          4480  1
rsrc_nonstatic         11136  1 yenta_socket
rtc                    13336  0
rtl8187                34304  0
scsi_mod              100360  2 sd_mod,usb_storage
sd_mod                 24720  0
sis900                 22656  0
snd                    50532  5 snd_intel8x0m,snd_intel8x0,snd_ac97_codec,snd_pcm,snd_timer
snd_ac97_codec         94112  2 snd_intel8x0m,snd_intel8x0
snd_intel8x0           32924  0
snd_intel8x0m          17548  0
snd_page_alloc         10376  3 snd_intel8x0m,snd_intel8x0,snd_pcm
snd_pcm                76552  3 snd_intel8x0m,snd_intel8x0,snd_ac97_codec
snd_timer              22788  1 snd_pcm
soundcore               8160  1 snd
usb_storage            37248  0
usbcore               135832  5 rtl8187,usb_storage,ehci_hcd,usbhid
usbhid                 21540  0
vfat                   13440  0
yenta_socket           25868  6


>
>  >  > Is  it  possible,  though  the  driver  catches the device and I don't
get any
> > > error-messages, that the Stick cannot be used under linux?
>
> If the device is a rtl818L, and it is likely to be, since the driver
> catches it, then it should work. If it doesn't not then it is probably
> a bug. rtl8187B is not supported, but it should not be catched by the
> driver (should have different USB id).
>
> Oh, do you have an USB port 1.x or 2.0 ?

On my LFS I have 2.0 but on the old PC where it is supposed to do its job  has
only  USB1.1. It's the reason why I bought this device. It is supposed to work
with USB1.1.

Thanks
Lynx

PS: I'm in the list now.


