Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:36453 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab3JaOWD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 10:22:03 -0400
Received: by mail-ie0-f180.google.com with SMTP id e14so5098050iej.11
        for <linux-wireless@vger.kernel.org>; Thu, 31 Oct 2013 07:22:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1383227814.41997.YahooMailNeo@web171801.mail.ir2.yahoo.com>
References: <1382537927.62604.YahooMailNeo@web171801.mail.ir2.yahoo.com>
	<1382538469.7892.YahooMailNeo@web171805.mail.ir2.yahoo.com>
	<20131024112206.GB1677@redhat.com>
	<1382614336.89589.YahooMailNeo@web171804.mail.ir2.yahoo.com>
	<20131024113748.GD1677@redhat.com>
	<1383227814.41997.YahooMailNeo@web171801.mail.ir2.yahoo.com>
Date: Thu, 31 Oct 2013 15:22:00 +0100
Message-ID: <CAL1gcdO=1DKmByZnfR_sq2si+2EAf4qTtzgbM4BFaD=VmMPp2Q@mail.gmail.com> (sfid-20131031_152207_318962_0725C055)
Subject: Re: Edimax EW-7733UnD
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Gianfranco Costamagna <costamagnagianfranco@yahoo.it>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 31, 2013 at 2:56 PM, Gianfranco Costamagna
<costamagnagianfranco@yahoo.it> wrote:
>
>
>> Il Giovedì 24 Ottobre 2013 13:41, Stanislaw Gruszka <sgruszka@redhat.com> ha scritto:
>> > On Thu, Oct 24, 2013 at 12:32:16PM +0100, Gianfranco Costamagna wrote:
>>>
>>>
>>>  Il Giovedì 24 Ottobre 2013 13:25, Stanislaw Gruszka
>> <sgruszka@redhat.com> ha scritto:
>>>
>>>  On Wed, Oct 23, 2013 at 03:27:49PM +0100, Gianfranco Costamagna wrote:
>>>  >
>>>  >> Hi Kernel Wireless developers, I write here since I have an issue
>> with this module.
>>>  >>
>>>  >>
>>>  >> We bought 2 of them since they are both 2.4 and 5Ghz capable, and
>> they seem to be powerful enough for our pourposes
>>>  >>
>> http://www.edimax.com/au/produce_detail.php?pd_id=399&pl1_id=1&pl2_id=44
>>>  >>
>>>  >>
>>>  >> Anyway there is a problem, that the linux kernel seems to be not
>> supporting them
>>>  >>
>>>  >> I tried following this guide
>>>  >> http://wikidevi.com/wiki/Edimax_EW-7733UnD
>>>  >> rt3573sta, possibly rt5572sta, and future support in rt2800usb
>> "uhosg's patchset adding support, may be in by k3.12"
>>>  >> but at this moment it is showing an interface with one of them (I
>> cannot connect to anything, the interface shown seems to be incorrect), with
>> another I get a kernel anic and with the third one doesn't work at all.
>>>  >>
>>>  >> lsusb |grep Edimax
>>>  >>
>>>  >> Bus 002 Device 002: ID 7392:7733 Edimax Technology Co., Ltd
>>>  >
>>>  >I have that exect device and it works ok here, but I'm using
>>>  >wireless-testing tree. So perhaps you should try install that
>>>  >tree or use backports .
>>>
>>>
>>>  Wonderful! I don't really understand what do you mean with backports,
>> are you referring to "linux kernel backports" right?
>>
>> Yes.
>>
>>>  So I can choose the backport source or to checkout and build the
>> wireless-testing tree.
>>>
>>>  Just as information, how long will it take to have it into the stable
>> mainline?
>>
>> Current wireless-testing content will be available on 3.13 ,
>> though I think that device should also work on 3.12 .
>>
>
> Ok I built a custom kernel but I still have some issues
> Ubuntu 13.10 x64
> git clone http://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> cd wireless-testing
> copied my config from this kernel http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12-rc7-saucy/
>
> make oldconfig
> (a tail of my .config file after the make)
> CONFIG_RT2800PCI=m
> CONFIG_RT2800PCI_RT33XX=y
> CONFIG_RT2800PCI_RT35XX=y
> CONFIG_RT2800PCI_RT53XX=y
> CONFIG_RT2800PCI_RT3290=y
> CONFIG_RT2500USB=m
> CONFIG_RT73USB=m
> CONFIG_RT2800USB=m
> CONFIG_RT2800USB_RT33XX=y
> CONFIG_RT2800USB_RT35XX=y
> # CONFIG_RT2800USB_RT3573 is not set

You will have to enable this configuration item to make this device work.

> CONFIG_RT2800USB_RT53XX=y
> CONFIG_RT2800USB_RT55XX=y
> CONFIG_RT2800USB_UNKNOWN=y
> CONFIG_RT2800_LIB=m
> CONFIG_RT2800_LIB_MMIO=m
> CONFIG_RT2X00_LIB_MMIO=m
> CONFIG_RT2X00_LIB_PCI=m
> CONFIG_RT2X00_LIB_USB=m
> CONFIG_RT2X00_LIB=m
> CONFIG_RT2X00_LIB_FIRMWARE=y
> CONFIG_RT2X00_LIB_CRYPTO=y
> CONFIG_RT2X00_LIB_LEDS=y
> # CONFIG_RT2X00_LIB_DEBUGFS is not set
> # CONFIG_RT2X00_DEBUG is not set
>
> (apt-get build-dep linux)
> make
> make all
> sudo make modules_install
> sudo make install
>
> I was surprised that everything was automatically copied in /boot and grub automatically found the new kernel without manual mkinitrd anymore (so long time from my last kernel build)
>
> Reboot
>
> locutus@gianfranco-Latitude-E5520:~/wireless-testing$ uname -a
> Linux gianfranco-Latitude-E5520 3.12.0-rc5-wl #2 SMP Thu Oct 31 14:04:43 CET 2013 x86_64 x86_64 x86_64 GNU/Linux
>
>
> put key in my pc
> [  471.585065] usb 2-1.2: new high-speed USB device number 11 using ehci-pci
> [  471.693762] usb 2-1.2: New USB device found, idVendor=7392, idProduct=7733
> [  471.693766] usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [  471.693768] usb 2-1.2: Product: 802.11 n WLAN
> [  471.693770] usb 2-1.2: Manufacturer: Ralink
> [  471.693771] usb 2-1.2: SerialNumber: 1.0
>
> sudo modprobe rt2800usb
>
> [  540.170899] usbcore: registered new interface driver rt2800usb
>
> nothing works...
>
> Can you please help me again?
>

-- 
---
Gertjan
