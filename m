Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:56346 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab2D1Wtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 18:49:31 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAJfuBxw7YFAC9CLAGNmg3nM_g2xH2vuiz07D-3xOcyn2XuP5vA@mail.gmail.com>
References: <CA+icZUVAK3NHmbG5kR1KhqGe9mAimWWzLz-MfXOXbyry3Sz73w@mail.gmail.com>
	<20120427094007.GU3157@wantstofly.org>
	<CA+icZUUiYwpHpqe5_kz1rLzTT13qQMwpNpDH7EOaRrVi_c8Z2Q@mail.gmail.com>
	<20120427094637.GV3157@wantstofly.org>
	<CA+icZUXNZ=exTnR=OgD_9bpt_0s-KnR+v-K6u+XzQr4HBoTQHQ@mail.gmail.com>
	<20120427095842.GW3157@wantstofly.org>
	<CA+icZUWuynSaPE4pdxzoP783pw7r=5x27ewXN_pkR5VS=0kKUg@mail.gmail.com>
	<20120427101732.GX3157@wantstofly.org>
	<CA+icZUUnJPeDmL9xXfvj62an40bXwwaOnrJmxmLN_cBt9PyCZA@mail.gmail.com>
	<CA+icZUV76wSBj88EpzmWbO=u2dP23yi5P98nN2KZehBUni9mEg@mail.gmail.com>
	<20120427185809.GZ3157@wantstofly.org>
	<CA+icZUWQmCRdjucb4+Nf24_zbJ4fzzp7zjqhKjXE6U01rppDfA@mail.gmail.com>
	<CA+icZUXSaEMA=KbQP9UQcU6ZMBh8QD2sv-O=6r_Ly8is==gvSA@mail.gmail.com>
	<CAJfuBxw7YFAC9CLAGNmg3nM_g2xH2vuiz07D-3xOcyn2XuP5vA@mail.gmail.com>
Date: Sun, 29 Apr 2012 00:49:30 +0200
Message-ID: <CA+icZUVT6kvqj47x26FU2qjbMHc=jr9_Lso=zduf_cmcSrv=UQ@mail.gmail.com> (sfid-20120429_004935_559088_94AFE344)
Subject: Re: [PATCH] mwl8k: Add 0x2a02 PCI device-id (Marvell 88W8361)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	lautriv <admin@coldplug.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 29, 2012 at 12:36 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> [dropped lkml from cc]
>
> On Sat, Apr 28, 2012 at 4:25 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>> On Fri, Apr 27, 2012 at 11:53 PM, Sedat Dilek
>> <sedat.dilek@googlemail.com> wrote:
>>> On Fri, Apr 27, 2012 at 8:58 PM, Lennert Buytenhek
>>> <buytenh@wantstofly.org> wrote:
>>>> On Fri, Apr 27, 2012 at 03:29:26PM +0200, Sedat Dilek wrote:
>>>>
>>>>> >>> >> >> >> Are you planning to or even working on support (for) 8361 devices?
>>>>> >>> >> >> >
>>>>> >>> >> >> > I don't have any such plans, and I don't know of anyone who does.
>>>>> >>> >> >>
>>>>> >>> >> >> Does 8361 require firmware support?
>>>>> >>> >> >
>>>>> >>> >> > What do you mean by that?
>>>>> >>> >>
>>>>> >>> >> IIRC ath5k for example needs no external firmware file.
>>>>> >>> >
>>>>> >>> > The 8361 requires firmware to be loaded into it before it'll do
>>>>> >>> > anything useful.
>>>>> >>> >
>>>>> >>> >
>>>>> >>> >> >> Does a firmware file exist (name?)?
>>>>> >>> >> >
>>>>> >>> >> > There's firmware for the 8361 out there, however, that version of
>>>>> >>> >> > the firmware implements a firmware API that is different from the
>>>>> >>> >> > one that mwl8k currently implements.
>>>>> >>> >> >
>>>>> >>> >> > You could add 8361 support to mwl8k, but then you'd have to go over
>>>>> >>> >> > all the firmware command invocations in mwl8k and make sure that they
>>>>> >>> >> > will work on the 8361 firmware that you're trying to support as well.
>>>>> >>> >>
>>>>> >>> >> Without having a 8361 this will be even harder to walk through.
>>>>> >>> >>
>>>>> >>> >> Anyway, thanks for your detailed explanations.
>>>>> >>> >>
>>>>> >>> >> What's the alternative for such affected users?
>>>>> >>> >> Use ndis-wrapper?
>>>>> >>> >
>>>>> >>> > I'm not sure.  I've never tried to get a 8361 work under Linux.
>>>>> >>>
>>>>> >>> Just found on [1] this same wrong patch in [2] :-).
>>>>> >>> Dunno if [3] worked and from where they have stolen fw-files.
>>>>> >>>
>>>>> >>> - Sedat -
>>>>> >>>
>>>>> >>> [1] https://dev.openwrt.org/ticket/7209
>>>>> >>> [2] https://dev.openwrt.org/attachment/ticket/7209/mwl8k_fix_pci_id.patch
>>>>> >>> [3] https://dev.openwrt.org/attachment/ticket/7209/mwl8k_8361p.patch
>>>>> >>
>>>>> >> I doubt that [3] is really all that's needed to make it work.  But if
>>>>> >> there's someone for whom it works, I'd like them to run some tests on
>>>>> >> mwl8k + [3] on 88w8361p.
>>>>> >
>>>>> > Just asked lautriv to do so (he will do against linux-3.3.3), lets' see.
>>>>> > Also, I refreshed and adapted a bit the instructions (see attachment).
>>>>> >
>>>>> > - Sedat -
>>>>>
>>>>> [ CC Jim Cromie ]
>>>>>
>>>>> Now, with extracted firmware files renamed & copied to
>>>>> /lib/firmware/mwl8k/ and applied patch (see attachment) against
>>>>> Linux-3.4-rc4+ I am seeing with modinfo:
>>>>>
>>>>> $ sudo modinfo mwl8k
>>>>> filename:
>>>>> /lib/modules/3.4.0-rc4-5-generic/kernel/drivers/net/wireless/mwl8k.ko
>>>>> license:        GPL
>>>>> author:         Lennert Buytenhek <buytenh@marvell.com>
>>>>> version:        0.13
>>>>> description:    Marvell TOPDOG(R) 802.11 Wireless Network Driver
>>>>> firmware:       mwl8k/fmimage_8366_ap-2.fw
>>>>> firmware:       mwl8k/fmimage_8366.fw
>>>>> firmware:       mwl8k/helper_8366.fw
>>>>> firmware:       mwl8k/fmimage_8687.fw
>>>>> firmware:       mwl8k/helper_8687.fw
>>>>> firmware:       mwl8k/fmimage_8363.fw
>>>>> firmware:       mwl8k/helper_8363.fw
>>>>> firmware:       mwl8k/fmimage_8361p.fw
>>>>> firmware:       mwl8k/helper_8361p.fw
>>>>> srcversion:     9E1479A05C8D67E6AE90746
>>>>> alias:          pci:v000011ABd00002A43sv*sd*bc*sc*i*
>>>>> alias:          pci:v000011ABd00002A40sv*sd*bc*sc*i*
>>>>> alias:          pci:v000011ABd00002A30sv*sd*bc*sc*i*
>>>>> alias:          pci:v000011ABd00002A2Bsv*sd*bc*sc*i*
>>>>> alias:          pci:v000011ABd00002A24sv*sd*bc*sc*i*
>>>>> alias:          pci:v000011ABd00002A0Csv*sd*bc*sc*i*
>>>>> alias:          pci:v000011ABd00002A0Asv*sd*bc*sc*i*
>>>>> alias:          pci:v000011ABd00002A02sv*sd*bc*sc*i* <--- 8361P:
>>>>> 0x2a02 PCI device-id
>>>>> depends:        mac80211,cfg80211
>>>>> vermagic:       3.4.0-rc4-5-generic SMP mod_unload modversions
>>>>> parm:           ap_mode_default:Set to 1 to make ap mode the default
>>>>> instead of sta mode (bool)
>>>>>
>>>>> $ ls -l /lib/firmware/mwl8k/
>>>>> insgesamt 456
>>>>> -rw-r--r-- 1 root root  75848 Apr 27 13:49 fmimage_8361p.fw <---
>>>>> 8361P: Firmware image
>>>>> -rw-r--r-- 1 root root 101780 Mär 19 19:32 fmimage_8366_ap-1.fw
>>>>> -rw-r--r-- 1 root root 101976 Mär 19 19:32 fmimage_8366_ap-2.fw
>>>>> -rw-r--r-- 1 root root  96664 Mär 19 19:32 fmimage_8366.fw
>>>>> -rw-r--r-- 1 root root  73252 Feb 23 20:07 fmimage_8687.fw
>>>>> -rw-r--r-- 1 root root   2476 Apr 27 13:49 helper_8361p.fw <--- 8361P:
>>>>> Helper image
>>>>> -rw-r--r-- 1 root root   2476 Mär 19 19:32 helper_8366.fw
>>>>> -rw-r--r-- 1 root root   2476 Feb 23 20:07 helper_8687.fw
>>>>>
>>>>> As said... ***compile-tested*** only here.
>>>>
>>>> Which doesn't say much at all, but..
>>>>
>>>
>>> As already pointed out, no Marwell WLAN hardware here. Marvell comics
>>> of course :-).
>>>
>>>>
>>>>> I had a short query with lautriv on #linux-wireless this afternoon:
>>>>> * mwl8k kernel-module was autoloaded
>>>>> * wlan0 interface got fired up
>>>>> * ESSID was accepted
>>>>> * logs reported 802.11bgn support is active
>>>>> * (he tested on Linux-3.3.3)
>>>>>
>>>>> With WPA/WPA2 lautriv had some problems as his installation was
>>>>> missing wpasupplicant.
>>>>> He setup a classic /etc/network/interfaces.
>>>>> After resetting his router mwl8k worked nicely.
>>>>>
>>>>> Unfortunately, he was on the run and promised me to send logs and do
>>>>> more testing this evening.
>>>>
>>>> ..but this is pretty interesting.  I thought that the only available
>>>> 8361p firmware used an incompatible firmware API, and I didn't know
>>>> of the existence of an apparently compatible firmware.
>>>>
>>>>
>>>>> So, Lennert if you want more testing - What? How? etc.
>>>>
>>>> For one, the output of 'iw phy', please.
>>>>
>>>> Also, does monitor mode work?  Do you get plausible channel/rxpower
>>>> values in tcpdump in monitor mode?
>>>>
>>>> Are there any messages in the syslog about failing commands?
>>>>
>>>>
>>>> thanks,
>>>> Lennert
>>>
>>> On 1st sight, logs look fine:
>>>
>>> [21:52:52] <lautriv> [    6.050967] ieee80211 phy0: 88w8361p v4,
>>> 00173f3bdde3, STA firmware 2.1.4.25
>>>
>>> But WLAN connection is not that fast and stable as lautriv reports
>>> (several abnormalities were observed).
>>>
>>> I requested a tarball which includes:
>>> * dmesg (Linux-3.3.3)
>>> * e_n_a (/etc/network/interfaces)
>>> * ifconfig output
>>> * iwconfig output
>>> * iw_phy output
>>> * ps_axu (WPA) output
>>>
>>> lautriv will be so kind to be around on #linux-wireless/Freenode the
>>> next days (UTC+2: German/Swiss local-time).
>>> Just ping him.
>>>
>>> Hope you have fun, together!
>>>
>>> - Sedat -
>>
>> A new tarball from lautriv with same outputs as before, but now tested
>> with Linux-3.4-rc4.
>>
>> - Sedat -
>
>
> heres my logs, using firmware extracted by Sedat's script,
> and the patch on mwl8k.c
>
> bottom-line, it appears to be working.
>
> its contents are a bit more pedantic, and includes data for
> another wifi card (rtl8180 based) also in the box.
> It was obtained by this script:
>
> #!/bin/bash
>
> # dmesg (Linux-3.3.3)
> # e_n_a (/etc/network/interfaces)
> # ifconfig output
> # iwconfig output
> # iw_phy output
> # ps_axu (WPA) output
>
> devs="wlan0 wlan1"
> apmac=00:14:d1:e8:65:0a
>
> loudly () {
>    echo "# $@"
>    fname=`echo $@ | sed -e 's/ /-/g'`
>    $@ 2> $fname-err | tee $fname
>    [ $? != 0 ] && echo non-zero exit on $fname: $?
>    [ -s $fname-err ] || rm $fname-err
> }
>
> ( iw --debug event -f > iw-event-f )&
> pid_event=$!
>
> for N in 0 1 ; do
>    loudly iw dev wlan$N interface add fish$N type monitor # flags none
>    loudly iw dev fish$N set channel 8
>    loudly ifconfig fish$N up
>    ( tcpdump -i fish$N -s 65000 -p -U -w  fish$N.dump )&
>    pid_dump_fish$N=$!
> done
>
> loudly iw list
>
> #loudly iwspy
> # gives: Interface doesn't support wireless statistic collection
>
> for dev in $devs ; do
>    loudly ifconfig $dev
>    loudly iwconfig $dev
>    loudly iwlist $dev scan
>    loudly iw dev $dev info
>    loudly iw dev $dev link
>    loudly iw dev $dev scan
>    loudly iw dev $dev survey dump
> done
>
> for phy in $phys ; do
>    loudly iw phy $phy info
> done
>
> # these are unsupported on wlan0
> loudly iw dev wlan1 survey dump
> loudly iw dev wlan1 station dump
> loudly iw dev wlan1 station get $apmac
>
>
> for N in 0 1 ; do
>    loudly iw dev fish$N del
> done
>
> kill $pid_dump_fish0 $pid_dump_fish0
> kill $pid_event
>
> dmesg > dmesg
>
> grep -vE '^#|key' /etc/network/interfaces > e_n_a
>
> exit

Hi Jim,

thanks for your testing and the nice testcase-script!

lautriv you wanna run some more tests with Jim's script?

Jim, how stable/fast/reliable is your WLAN connection?
Suspend/resume tested?

Hope this helps to get native Linux support for 8361p.

Regards,
- Sedat -

P.S.: BTW, only to clarify it should be "e_n_i" as short-form for
/etc/network/interfaces file, but e_n_a sounds more female and nicer
:-).
