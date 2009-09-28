Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web28307.mail.ukl.yahoo.com ([87.248.110.126]:29465 "HELO
	web28307.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752286AbZI1SEH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 14:04:07 -0400
Message-ID: <29413.68229.qm@web28307.mail.ukl.yahoo.com>
References: <505407.87957.qm@web28315.mail.ukl.yahoo.com>  <200909210845.51247.hs4233@mail.mn-solutions.de>  <4AB7A5BB.1050300@yahoo.es> <1253779538.3868.14.camel@johannes.local>
Date: Mon, 28 Sep 2009 11:04:10 -0700 (PDT)
From: Albert Herranz <albert_herranz@yahoo.es>
Subject: Re: Problems with "cfg80211: fix SME connect" commit
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1253779538.3868.14.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2009-09-21 at 18:11 +0200, Albert Herranz wrote:
> 
>> Adding back "cfg80211: fix SME connect" and applying "cfg80211: don't
>> overwrite privacy setting" fixes the connection issue, but with a
>> introduces a small difference vs the previous working version.
>> There is now an extra "deauthenticating by local choice (reason=3)"
>> message in the logs.
> 
>> [   13.969153] b43-phy0 debug: Adding Interface type 2
>> [   16.679249] wlan1: direct probe to AP 00:12:17:15:e7:79 (try 1)
> 
>> * master-20090916 + "cfg80211: don't overwrite privacy setting"
> 
>> [   13.218613] b43-phy0 debug: Adding Interface type 2
>> [   15.832582] wlan1: deauthenticating by local choice (reason=3)
>> [   16.131599] wlan1: direct probe to AP 00:12:17:15:e7:79 (try 1)
> 
> Very odd. Can you edit the deauthenticating message to show the
> BSSID/MAC address?
> 
> johannes

Hi,

Sorry if this comes too late (I was on vacation).

Here's the output showing the BSSID/MAC address for completeness.

[    1.307985] b43-sdio mmc1:0001:1: Chip ID 14e4:4318
[    1.344244] b43-phy0: Broadcom 4318 WLAN found (core revision 9)
[    1.372627] b43-phy0 debug: Found PHY: Analog 3, Type 2, Revision 7
[    1.377416] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 8
[    1.417302] phy0: Selected rate control algorithm 'minstrel'
[    4.462416] udev: renamed network interface wlan0 to wlan1
[   11.064949] b43 ssb0:0: firmware: requesting b43/ucode5.fw
[   11.118177] b43 ssb0:0: firmware: requesting b43-open/ucode5.fw
[   11.197385] b43 ssb0:0: firmware: requesting b43-open/pcm5.fw
[   11.268949] b43 ssb0:0: firmware: requesting b43-open/b0g0initvals5.fw
[   11.347623] b43 ssb0:0: firmware: requesting b43-open/b0g0bsinitvals5.fw
[   12.353406] b43-phy0: Loading OpenSource firmware version 410.31754
[   12.359142] b43-phy0: Hardware crypto acceleration not supported by firmware
[   12.369827] b43-phy0: QoS not supported by firmware
[   12.741767] b43-phy0 debug: Chip initialized
[   12.757540] b43-phy0 debug: PIO initialized
[   12.764455] b43-phy0 debug: QoS disabled
[   12.945116] b43-phy0 debug: Wireless interface started
[   13.053151] b43-phy0 debug: Adding Interface type 2
[   15.624121] wlan1: starting authentication with 00:12:17:15:e7:79
[   15.630717] wlan1: deauthenticating from 00:12:17:15:e7:79 by local choice (reason=3)
[   15.645151] wlan1: starting authentication with 00:12:17:15:e7:79
[   15.665811] wlan1: direct probe to AP 00:12:17:15:e7:79 (try 1)
[   15.681132] wlan1: direct probe responded
[   15.687261] wlan1: authenticate with AP 00:12:17:15:e7:79 (try 1)
[   15.701105] wlan1: authenticated
[   15.707860] wlan1: starting association with 00:12:17:15:e7:79
[   15.713877] wlan1: associate with AP 00:12:17:15:e7:79 (try 1)
[   15.726949] wlan1: RX AssocResp from 00:12:17:15:e7:79 (capab=0x431 status=0 aid=1)
[   15.740953] wlan1: associated

I'm using wpa_supplicant _without_ NM.

Cheers,
Albert


      
