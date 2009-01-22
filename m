Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:24491 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZAVFNX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 00:13:23 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2024702fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jan 2009 21:13:21 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 22 Jan 2009 00:13:21 -0500
Message-ID: <578ff7cb0901212113i73bc8113g36eb18116407ec81@mail.gmail.com> (sfid-20090122_061330_086918_2C63A418)
Subject: Re: bcm4311 who likes to disassociate (yet associates just fine using
	knoppix)
From: Nate Lally <nate.lally@gmail.com>
To: bcm43xx-dev@berlios.de
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
  I didn't actually subscribe to the bcm43 mailing list so I'm not
quite sure if anyone actually received the prior emails.  Nor am I
convinced it is actually the domain of those working on the b43
firmware considering the fact that the exact same kernel compile and
modprobe configs are being used on the non-working ubuntu distribution
yet associate just fine while booting knoppix under the below
circumstances.

Any help/direction would be appreciated.

-Nate Lally

On 1/8/09, Nate Lally <nate.lally@gmail.com> wrote:
> An inspiring new development.  I boot the laptop with knoppix 5.3.1
> utilizing kernel version 2.6.24.4, I mount the firmware for bcm43xx @ 2.6.24
> on /lib/firmware and discover not only can I associate, I can utilize wep
> and pull an ip.  From there I copy the /boot/config and compile a 2.6.24-4
> kernel with those options using gcc 4.2.4 (because of a reported bug with
> gcc 4.3 and time.h) only to find that now card does not report ready ie:
>
> input: b43-phy0 as /class/input/input9
> Registered led device: b43-phy0:tx
> Registered led device: b43-phy0:rx
> Registered led device: b43-phy0:radio
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> eth0: no IPv6 routers present
> wlan0: Initial auth_alg=0
> wlan0: authenticate with AP 00:16:b6:55:77:b3
> wlan0: authenticate with AP 00:16:b6:55:77:b3
> wlan0: authenticate with AP 00:16:b6:55:77:b3
> wlan0: authentication with AP 00:16:b6:55:77:b3 timed out
>
> any ideas/flames/help/suggestions would help from you guys
>
> thanks again
> -Nate Lally
>
> On Tue, Jan 6, 2009 at 1:11 AM, Nate Lally <nate.lally@gmail.com> wrote:
>
>> Hi All,
>>   I'm wondering where to get started debugging this issue, not a lot of
>> wifi experience... I have a laptop I inherited with no pcmcia slot and a
>> broadcom bcm4311 wifi chip.  Whenever I try to associate to an access
>> point
>> with no encryption, the card associates, then shortly thereafter
>> disassociates stating reason 3 (as you'll see in the following dmesg)...
>> I
>> still haven't tracked down the reason 3 from the call to
>> ieee80211_sta_disassociate   in mlme.c (I can't find what calls
>> ieee80211_ioctl_siwmlme).
>> but it seems to me that a ioctl call to disassociate must be stemming from
>> a state machine that decided something was wrong or missing that the
>> driver
>> should be providing/correcting..
>> any tips tricks ideas directions would be much appreciated...
>>
>>
>> root@aello:/usr/src/wireless-testing# uname -a
>> Linux aello 2.6.28 #2 Mon Jan 5 20:12:00 CST 2009 i686 GNU/Linux
>>
>> root@aello:/usr/src/wireless-testing# git describe
>> v2.6.28-10356-g738910c
>>
>> root@aello:/usr/src/wireless-testing# lspci -vvvn | grep 43 -A7
>> 06:00.0 0280: 14e4:4311 (rev 01)
>>     Subsystem: 103c:1363
>>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR+ FastB2B- DisINTx-
>>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort-
>> <MAbort- >SERR- <PERR- INTx-
>>     Latency: 0, Cache Line Size: 64 bytes
>>     Interrupt: pin A routed to IRQ 18
>>     Region 0: Memory at 30000000 (32-bit, non-prefetchable) [size=16K]
>>     Capabilities: [40] Power Management version 2
>> --
>>     Kernel driver in use: b43-pci-bridge
>>     Kernel modules: ssb
>>
>>
>> dmesg output
>>
>> [11471.880103] b43-phy0: Loading firmware version 410.2160 (2007-05-26
>> 15:32:10)
>> [11471.940137] b43-phy0 debug: Chip initialized
>> [11471.940357] b43-phy0 debug: 32-bit DMA initialized
>> [11471.962122] Registered led device: b43-phy0::tx
>> [11471.962145] Registered led device: b43-phy0::rx
>> [11471.962175] Registered led device: b43-phy0::radio
>> [11471.962256] b43-phy0 debug: Wireless interface started
>> [11471.968608] b43-phy0 debug: Adding Interface type 2
>> [11471.980606] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> [11515.922066] wlan0: direct probe to AP 00:16:b6:xx:xx:xx try 1
>> [11516.120072] wlan0: direct probe to AP 00:16:b6:xx:xx:xx try 2
>> [11516.123276] wlan0 direct probe responded
>> [11516.123280] wlan0: authenticate with AP 00:16:b6:xx:xx:xx
>> [11516.125125] wlan0: authenticated
>> [11516.125129] wlan0: associate with AP 00:16:b6:xx:xx:xx
>> [11516.127714] wlan0: RX AssocResp from 00:16:b6:xx:xx:xx (capab=0x421
>> status=0 aid=9)
>> [11516.127717] wlan0: associated
>> [11516.127722] phy0: Allocated STA 00:16:b6:xx:xx:xx
>> [11516.128449] phy0: Inserted STA 00:16:b6:xx:xx:xx
>> [11516.128454] wmaster0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15
>> cWmax=1023
>> txop=0
>> [11516.129191] wmaster0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15
>> cWmax=1023
>> txop=0
>> [11516.129287] wmaster0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15
>> txop=94
>> [11516.129382] wmaster0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7
>> txop=47
>> [11516.129471] wlan0: switched to short barker preamble
>> (BSSID=00:16:b6:xx:xx:xx)
>> [11516.129475] wlan0: switched to short slot (BSSID=00:16:b6:xx:xx:xx)
>> [11516.130166] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>> [11516.130271] wlan0: disassociating by local choice (reason=3)
>> [11516.136255] phy0: Removed STA 00:16:b6:xx:xx:xx
>> [11516.136293] phy0: Destroyed STA 00:16:b6:xx:xx:xx
>> [11526.172056] wlan0: no IPv6 routers present
>>
>>
>>
>> --
>> Nate Lally
>>
>
>
>
> --
> Nate
> (763)-607-7630
>


-- 
Nate
(763)-607-7630
