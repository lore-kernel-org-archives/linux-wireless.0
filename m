Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37217 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab0JECGj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 22:06:39 -0400
Received: by qwh6 with SMTP id 6so3475763qwh.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 19:06:39 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 5 Oct 2010 04:06:38 +0200
Message-ID: <AANLkTinke34B5w8yqzyJRR66vOnGVmP6Vm_KYQrVv5JP@mail.gmail.com>
Subject: Channels vs. frequencies: 2.4 GHz, 4.9 GHz, 5.0 GHz
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I hack on b43 a little and I try to understand wireless channels.
There are few things that seems magic to me, could I get help here?

***

First some info I grabbed from specifications:

20 MHz and 5 GHz:	17.3.8.3	start + 5 x channel [0, ..., 200]	[start =
dot11RegulatoryClassesRequired ? (500 * dot11ChannelStartingFactor) :
5000]
20 MHz and 2.4 GHz	18.4.6		[standard 1-14 channels table?]
40 MHz and 5 GHz:	20.3.15.2	start + 5 x channel [0, ..., 200]	[start =
dot11RegulatoryClassesRequired ? (500 * dot11ChannelStartingFactor) :
5000]
40 MHz and 2.4 GHz:	20.3.15.1	 2407 + 5 x channel [1, ..., 13]

This shows channels like 1, 5, 8 (some random numbers) can be actually
from any: 2.4 GHz or 5 GHz. Wikipedia [1] seems to agree with this as
it contains for example channel 9 with freq 5045.

However checking util.c::ieee80211_channel_to_frequency it looks we
assume channels lower/equal 14 are always 2.4 GHz. Something weird can
also be found in specs:

17.3.8.3.2 Channel numbering
This definition provides a unique numbering system for all channels
with 5 MHz between center
frequencies, as well as the flexibility to define channelization sets
for all current and future regulatory
domains.

So... how does it really work? Are channels uniq? Is our
channel<->freq translation bad/OK?

***

Are there some forbidden channels at specific ranges in 5 GHz?

Wikipedia starts 5 GHz channels from 7, doesn't mention 0 - 6. Same
for 17 - 34. Starting with 34 Wikipedia skips odd channels, but only
until 149.
Checking for 5 GHz channels Broadcom can work with [2] I don't see
anything between 0 and 31. Then it goes every even number until 145.

***

802.11j... this is disaster (I know it's Japanese-only). Wikipedia
shows channels 183 - 196 as 4.9 GHz. However according to
specifications channels between 0 and 200 can be 5 GHz! Similar thing
is visible in Broadcom's specs: 182 is last channel in 5 GHz (5910
MHz) and starting with 184 we go down to 4.9 GHz (4920 MHz for 184).
Any explaination, please? :|

***

Channels above 200?! According to specifications range of 5 GHz
channels is 0-200. Wikipedia agrees with that, however Broadcom's code
seems to support channels up to 228 (5140 MHz!).The crazy part for me
is Broadcom treat's channel 216 as 5080 MHz, while Wikipedia uses 16
for 5080 MHz. Of course there is no "16" channel in Broadcom's specs
:|

***

[1] http://en.wikipedia.org/wiki/List_of_WLAN_channels
[2] http://bcm-v4.sipsolutions.net/802.11/Radio/2056/ChannelTable

-- 
Rafał
