Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48066 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab2K3XxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 18:53:02 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so1534853ieb.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Nov 2012 15:53:01 -0800 (PST)
Message-ID: <50B946D9.6010902@lwfinger.net> (sfid-20121201_005307_520379_D9C84068)
Date: Fri, 30 Nov 2012 17:52:57 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?Q2VuZ2l6IEfDvG5heQ==?= <cgunay@emory.edu>
CC: wlanfae <wlanfae@realtek.com>, linux-wireless@vger.kernel.org
Subject: Re: rtl8723e droping the AP continuously for low signals; is there
 a threshold parameter?
References: <CAG5aqJX6h7-aOBrq5pTNfBru7zmZji8hO+JqRC3eN0uXthAbLw@mail.gmail.com> <CAG5aqJV62_8eFJNQx=8R9gTYCRR4RbiaUks48oPRNm-Pq5DO=A@mail.gmail.com> <CAG5aqJWdxLf3X1+DsEiz4cpSnfo7JMsuEsMYPND8TPhUVag-Ww@mail.gmail.com>
In-Reply-To: <CAG5aqJWdxLf3X1+DsEiz4cpSnfo7JMsuEsMYPND8TPhUVag-Ww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/30/2012 04:19 PM, Cengiz Günay wrote:
> Hi,
>
> I am trying to use the Linux kernel driver for the RTL8723E wifi card. While the
> card works flawlessly in Windows, it is unusable under Linux. For low-signal
> APs, such as in public places, the kernel continuously drops the AP connection
> and reconnects. This brings the transfer rate almost to a stop. I compiled the
> sources of the unofficial kernel driver distributed by Realtek to get this card
> working.
>
> My question to you: is there a threshold parameter in the driver source code
> that I can play with to stop the driver from dropping AP connections even though
> the signal is low?
>
> I would really appreciate any suggestions as this problem is rendering the wifi
> card unusable.

Although I am listed as a driver author, my efforts are limited to the specific 
operations used in Linux. I have no knowledge of the operation of the chips and 
no knowledge of the programming of the chips.

It sounds to me as if the automatic gain control is not being handled correctly.

>
> Here are my system specifics:
>
> # uname -a
> Linux cenlap 3.4-trunk-amd64 #1 SMP Tue Jun 26 17:23:03 UTC 2012 x86_64 GNU/Linux
>
> It's a Debian (Testing level). From dmesg:
> Linux version 3.4-trunk-amd64 (Debian 3.4.4-1~experimental.1)
> (debian-kernel@lists.debian.org <mailto:debian-kernel@lists.debian.org>) (gcc
> version 4.6.3 (Debian 4.6.3-1) ) #1 SMP Tue Jun 26 17:23:03 UTC 2012
>
> # lspci -v -s 03:00.0
> 03:00.0 Network controller: Realtek Semiconductor Co., Ltd. Device 8723
>      Subsystem: Realtek Semiconductor Co., Ltd. Device 0726
>      Flags: bus master, fast devsel, latency 0, IRQ 18
>      I/O ports at d000 [size=256]
>      Memory at f7900000 (64-bit, non-prefetchable) [size=16K]
>      Capabilities: [40] Power Management version 3
>      Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
>      Capabilities: [70] Express Endpoint, MSI 00
>      Capabilities: [100] Advanced Error Reporting
>      Capabilities: [140] Virtual Channel
>      Capabilities: [160] Device Serial Number 01-23-87-fe-ff-4c-e0-00
>      Kernel driver in use: rtl8723e
>
> Using driver rtl_92ce_92se_92de_8723ae_
> linux_mac80211_0006.0514.2012
>
> I did have to comment out IEEE80211_HW_BEACON_FILTER (line 320 in base.c) to be
> able to compile your kernel driver for my 3.4 kernel, following the description
> here:
> http://askubuntu.com/questions/139632/wireless-card-realtek-rtl8723ae-bt-is-not-recognized
>

That is a matter of the vendor driver. I deal with that driver only in that I 
use it as a starting point for the version built into the Linux kernel. Any 
build problems were fixed several months ago.

> Here are the errors I'm getting on dmesg and I can see WPA_GUI continuously
> reconnecting every few seconds:
> [ 7316.486880 <tel:%5B%207316.486880>] wlan0: Connection to AP 00:0a:06:05:01:53
> lost.
> [ 7316.487711 <tel:%5B%207316.487711>] cfg80211: Calling CRDA to update world
> regulatory domain
> [ 7317.519557 <tel:%5B%207317.519557>] wlan0: authenticate with 00:0a:06:05:01:53
> [ 7317.551189 <tel:%5B%207317.551189>] wlan0: send auth to 00:0a:06:05:01:53
> (try 1/3)
> [ 7317.754273 <tel:%5B%207317.754273>] wlan0: send auth to 00:0a:06:05:01:53
> (try 2/3)
> [ 7317.958152 <tel:%5B%207317.958152>] wlan0: send auth to 00:0a:06:05:01:53
> (try 3/3)
> [ 7318.162085 <tel:%5B%207318.162085>] wlan0: authentication with
> 00:0a:06:05:01:53 timed out
> [ 7329.506332 <tel:%5B%207329.506332>] wlan0: authenticate with 00:0a:06:05:01:97
> [ 7329.519585 <tel:%5B%207329.519585>] wlan0: send auth to 00:0a:06:05:01:97
> (try 1/3)
> [ 7329.521128 <tel:%5B%207329.521128>] wlan0: authenticated
> [ 7329.536739 <tel:%5B%207329.536739>] wlan0: associate with 00:0a:06:05:01:97
> (try 1/3)
> [ 7329.538853 <tel:%5B%207329.538853>] wlan0: RX AssocResp from
> 00:0a:06:05:01:97 (capab=0x421 status=0 aid=1)
> [ 7329.538858] wlan0: associated
> [ 7332.527325] wlan0: Connection to AP 00:0a:06:05:01:97 lost.
> [ 7332.531547] cfg80211: Calling CRDA for country: US

The first thing I request is that you try the version that will be added to 
kernel version 3.8 as it is the one I specifically support. It is currently 
available in the 3.7-rc7 versions of the linux-next, wireless-next, and 
wireless-testing git trees.

The second thing is to report the signal strength at which the device fails. On 
my system, the driver runs without disconnection for days at a time; however, 
the signals are quite strong from my APs. Once I know where the difficulty 
happens, I can attenuate the signal.

Have you tried changing the power settings using the module parameters. I do not 
know what those are in the vendor driver, but in the kernel version, the 
pertiment ones are:

parm:   ips:Set to 0 to not use link power save (default 1)
parm:   swlps:Set to 1 to use SW control power save (default 0)
parm:   fwlps:Set to 1 to use FW control power save (default 1)

My suggestion is to disable link power saving with the "ips=0" option, or 
whatever the vendor driver uses.

Larry

