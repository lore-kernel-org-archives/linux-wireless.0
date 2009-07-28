Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s30.bay0.hotmail.com ([65.54.246.230]:58448 "EHLO
	bay0-omc3-s30.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753976AbZG1VVX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 17:21:23 -0400
Message-ID: <BAY0-DP3-241EC0B1A0E15935251FCBBD150@phx.gbl>
From: Jack Lau <jackelectronics@hotmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: RE: kernel panic ieee80211_agg_splice_packets+0x3d/0xc0 [mac80211]
Date: Tue, 28 Jul 2009 21:21:23 +0000
In-Reply-To: <1248640816.32168.42.camel@mj>
References: <BAY0-DP2-2945C3011C834624418944BD170@phx.gbl>
 <1248640816.32168.42.camel@mj>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




----------------------------------------
> From: jackelectronics@hotmail.com
> To: proski@gnu.org
> Subject: RE: kernel panic ieee80211_agg_splice_packets+0x3d/0xc0 [mac80211]
> Date: Tue, 28 Jul 2009 20:34:07 +0000
>
>
> Dear Pavel
>
> I have tried your suggestion and I am getting absolutely nowhere with it.
>
> I have enabled debugging in config.mk and installed it. The kernel already has debugging enabled as I have examined the source from Ubuntu.
>
> When I load the gdb command, I just get no debugging symbols found and with the l command I just get no symbol file now.
>
> I know this may sound really simple to you but I have so little experience with programming and please don't leave me on my own to try and sort the problem out.
>
> Remember, I only install and configure Linux because it is free and lots to learn from but I really don't do programming.
>
> Regards
>
>
> Jack
>
> ----------------------------------------
>> Subject: Re: kernel panic ieee80211_agg_splice_packets+0x3d/0xc0 [mac80211]
>> From: proski@gnu.org
>> To: jackelectronics@hotmail.com
>> CC: linux-wireless@vger.kernel.org
>> Date: Sun, 26 Jul 2009 16:40:16 -0400
>>
>> On Sun, 2009-07-26 at 17:35 +0000, Jack Lau wrote:
>>>
>>> This is my very first post on a public mailing list where I am not
>>> into programming. I just set up and configure Linux but have very
>>> little experience with programing except BASIC and shell scripting.
>>>
>>> I have recently assembled a Linux server and router (no GUI) where I
>>> am using an Atheros AR9160 controller (Sparklan WMIA-268N) as an
>>> access point. I am using Ubuntu 9.04 jaunty release but using hostapd
>>> 0.69 from the upcoming 9.10 karmic release because the one that comes
>>> with jaunty does not support nl80211.
>>>
>>> The problem is that I am constantly getting kernel panics, each time
>>> of the same error kernel panic ieee80211_agg_splice_packets+0x3d/0xc0
>>> [mac80211]
>>
>> You can find where it happens if you kernel is compiled with the debug
>> information (CONFIG_DEBUG_INFO in .config). Load the mac80211 module in
>> gdb:
>>
>> gdb /lib/modules/`uname -r`/kernel/net/mac80211/mac80211.ko
>>
>> On the gdb prompt, run:
>>
>> l *(ieee80211_agg_splice_packets+0x3d)
>>
>> Actually, ieee80211_agg_splice_packets is a short function. Perhaps you
>> could add debug print statements to find possible errors. For instance,
>> local->hw is used. It would crash if local is NULL. So you add before
>> that place:
>>
>> printk("local = %p\n", local);
>>
>> Likewise, check sta, sta->ampdu_mlme.tid_tx[tid] and local->pending. Or
>> just print the line numbers. You will see which printk is run last
>> before the crash.
>>
>>> I enclose screenshots of 3 occurrences, the last occurrence with the
>>> options nosmp noacpi acpi=off noapic just to see if it solves the
>>> problem but it didn't. Most frustratingly, I hate it when I am the
>>> only person experiencing it because searching Google yields nothing
>>> with this error.
>>
>> Chances are it's because 802.11n is not used much with ath9k in AP mode.
>>
>> --
>> Regards,
>> Pavel Roskin
> _________________________________________________________________
> With Windows Live, you can organise, edit, and share your photos.
> http://clk.atdmt.com/UKM/go/134665338/direct/01/
_________________________________________________________________
Windows Live Messenger: Celebrate 10 amazing years with free winks and emoticons.
http://clk.atdmt.com/UKM/go/157562755/direct/01/