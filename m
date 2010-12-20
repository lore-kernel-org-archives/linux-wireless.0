Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40655 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900Ab0LTPtp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 10:49:45 -0500
Received: by wwa36 with SMTP id 36so3086695wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 07:49:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinCWK95_eFb47pFLz2O=+UHMGpeXg9Z_JstFEa=@mail.gmail.com>
References: <AANLkTikKtc4uiXN+oHwDr8sPFXZCe3HvTfYSvgZ8uYx0@mail.gmail.com>
	<4D0BADBE.40101@lwfinger.net>
	<AANLkTimvazto71m6SPMYtSAGuQkNpab+kMZcF4buNqYa@mail.gmail.com>
	<4D0BC0C1.4000809@lwfinger.net>
	<AANLkTinCWK95_eFb47pFLz2O=+UHMGpeXg9Z_JstFEa=@mail.gmail.com>
Date: Mon, 20 Dec 2010 10:49:42 -0500
Message-ID: <AANLkTinWZ_1EQTJsWrPmUJEqFpEg8JEOkcOtKZXbqJr7@mail.gmail.com>
Subject: Re: rtl8192 does not see N networks in my building
From: Amos Blanton <amos.blanton@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, I did the lwist scan properly this time. And wow, we have a lot of
wifi here - 96 cells in fact.
The list has most of the visible networks that others can see in the
area with the exception of MIT N, which is the one that works decently
well.  There's also MIT Secure N, which it doesn't see either. So I
guess the device is not finding any N networks?

Would this be something I should report to RealTek?
Thanks very much for your help with this.
-Amos

p.s. Also, I heard a rumor that the people responsible for installing
the Wifi here overdid it a tad, with too many transmitters. Seems like
it might be true?

Here's a page or two of lwlist results:

wlan0     Scan completed :
          Cell 01 - Address: 00:23:EB:D1:C0:B3
                    ESSID:"MIT"
                    Protocol:IEEE802.11N-24G
                    Mode:Master
                    Channel:1
                    Encryption key:off
                    Bit Rates:300 Mb/s
                    Extra: Rates (Mb/s): 1 2 5.5 6 9 11 12 18 24 36 48 54
                    Quality=76/100  Signal level=-67 dBm  Noise level=-108 dBm
                    Extra: Last beacon: 122ms ago
          Cell 02 - Address: 00:23:EB:D1:C0:B4
                    ESSID:"MIT SECURE"
                    Protocol:IEEE802.11N-24G
                    Mode:Master
                    Channel:1
                    Encryption key:on
                    Bit Rates:300 Mb/s
                    Extra: Rates (Mb/s): 1 2 5.5 6 9 11 12 18 24 36 48 54
                    Quality=79/100  Signal level=-67 dBm  Noise level=-109 dBm
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                Authentication Suites (1) : 802.1x
                    Extra: Last beacon: 128ms ago
          Cell 03 - Address: 00:23:EB:D1:C0:B6
                    ESSID:"<hidden>\x00"
                    Protocol:IEEE802.11N-24G
                    Mode:Master
                    Channel:1
                    Encryption key:on
                    Bit Rates:300 Mb/s
                    Extra: Rates (Mb/s): 1 2 5.5 6 9 11 12 18 24 36 48 54
                    Quality=81/100  Signal level=-65 dBm  Noise level=-110 dBm
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
                    Extra: Last beacon: 1ms ago
          Cell 04 - Address: 00:23:EB:D2:26:90
                    ESSID:"MIT GUEST"
                    Protocol:IEEE802.11N-24G
                    Mode:Master
                    Channel:1
                    Encryption key:off
                    Bit Rates:300 Mb/s




On Fri, Dec 17, 2010 at 10:32 PM, Amos Blanton <amos.blanton@gmail.com> wrote:
> On Fri, Dec 17, 2010 at 2:57 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
>> The report I have from Realtek is that a mac80211 driver for that device is
>> nearing completion. I originally thought that you were using a staging driver,
>> but you must be using a driver from Realtek's site. Do you have the latest? I
>> show it to be rtl8192se_linux_2.6.0018.1025.2010. As I recall, that one does not
>> work on a 64-bit system.
>
> AFAIK it's whatever ships with Ubuntu 10.10, unless the people at
> Zareason installed a different driver before shipping this laptop.
> I've searched the package manager but can't find anything related.
> Let's see, google says modinfo should tell me. Here's the output:
>
> lightnin@Buford:~$ modinfo r8192se_pci
> filename:
> /lib/modules/2.6.35-23-generic/kernel/ubuntu/rtl8192se/r8192se_pci.ko
> license:        GPL
> version:        0017.0507.2010
> author:         Copyright(c) 2008 - 2010 Realsil Semiconductor
> Corporation <wlanfae@realtek.com>
> description:    Linux driver for Realtek RTL819x WiFi cards
> srcversion:     64C041B4E539FCBBF8BEA08
> alias:          pci:v000010ECd00008174sv*sd*bc*sc*i*
> alias:          pci:v000010ECd00008173sv*sd*bc*sc*i*
> alias:          pci:v000010ECd00008172sv*sd*bc*sc*i*
> alias:          pci:v000010ECd00008171sv*sd*bc*sc*i*
> alias:          pci:v000010ECd00008192sv*sd*bc*sc*i*
> depends:
> vermagic:       2.6.35-23-generic SMP mod_unload modversions
> parm:           ifname: Net interface name, wlan%d=default (charp)
> parm:           hwwep: Try to use hardware WEP support(default use hw.
> set 0 to use software security) (int)
> parm:           channels: Channel bitmask for specific locales. NYI (int)
>
>
>> You need to run iwlist as root to get an active scan. That is why I specified
>> the "sudo iwlist scan". Your prompt above looks like the regular user one. If
>> I'm wrong there, then something is blocking transmission. Is the module rfkill
>> loaded?
>
> Ah, my apologies! I did forget the sudo - sorry about that. I've left
> work now but will do a scan on Monday.
>
> Should I try installing an updated version of the driver that is
> compatible with 64 bit systems? Where might that be?
>
> Amos
>
>>
>> Larry
>>
>
