Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:18635 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbYH0XLR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2008 19:11:17 -0400
Received: by nf-out-0910.google.com with SMTP id d3so32897nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 27 Aug 2008 16:11:16 -0700 (PDT)
Message-ID: <1ba2fa240808271611v382631ecn2a24e2816562d434@mail.gmail.com> (sfid-20080828_011122_631270_1D6696BF)
Date: Thu, 28 Aug 2008 02:11:15 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: pull request: wireless-2.6 2008-08-26
Cc: "John W. Linville" <linville@tuxdriver.com>, davem@davemloft.net,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <200808272225.10557.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080827013009.GA15781@tuxdriver.com>
	 <1ba2fa240808271226i95a7789k481a68b09dc60164@mail.gmail.com>
	 <200808272225.10557.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 27, 2008 at 11:25 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Wednesday 27 August 2008, Tomas Winkler wrote:
>> > John W. Linville (1):
>> >      mac80211: quiet chatty IBSS merge message
>>
>> This patch is correct yet it suppresses an important warning, meaning
>> that you have constant IBSS reconnection, remove all connected station
>> and adding them again, This greatly degraded performance. This is
>> caused by inability to adjust to TSF of the IBSS leader
>>
>> <snipt>
>> static int ieee80211_sta_join_ibss(struct net_device *dev,
>>                                  struct ieee80211_if_sta *ifsta,
>>                                  struct ieee80211_sta_bss *bss)
>> .....
>> /* Remove possible STA entries from other IBSS networks. */
>>       sta_info_flush_delayed(sdata);
>> </snip>
>
> I fail to see how the TSF could be related to an ever reconnecting
> station. Can you elaborate on what happens?
>
> I was under the impression that the firmware would handle TSF stuff.
> Also the "IBSS leader" is a new thing to me. I remember from the specs
> that the device should accept the TSF from _any_ beacon. Not just a
> "leader". Am I mislead? :)

What is happening that IBSS station should adopt TSF of  the oldest
station i.e. with highest
TSF. This is also leader of the IBSS (this is not spec definition just
local jargon)  Adaptation
mean we adjust to the same clock

if (beacon_timestamp > rx_timestamp)
    merge

beacon_timestamp (what STA advertise in the beacon ) is bigger then
time reception of the beacon according our local TSF.  If this is true
then there is merging
  meaing we call reset_tsf, remove all the stations form the list and
add the leader.

In IBSS all the station race on sending beacon. so adjusting clock is
important for power save.

> I also fail to see how we could _ever_ set the TSF to something remotely
> correct from the driver because of the FIFO delay.
>
Exactly also iwlwifi driver is not able to really adjust TSF and
always lag behind we've really tried to make it work...no success.
The result is you are constantly removing and joining the same station.

The patch from Assaf just disable reporting RX timestamp to mac and
thus disabling merging which gives incorrect spec behavior but smooth
traffic.
Actually we've checked few cards including broadcom and various
windows NICs and non of them implements this correctly so this WA is
probably the solution.

Other solution would be to mark leader with highest TSF and not
reconnecting to the same station again and again.

Last solution would be to remove this merging all together but then
I'm not sure if Bruno added this code just implement the spec or
really tested it with any hardware. I'm not sure if any vendor
implements PS in IBSS so this merging is probably not important
anyway.

>>
>> > Assaf Krauss (1):
>> >      iwlwifi: W/A for the TSF correction in IBSS
>
> I cannot find this patch in wireless-testing and I don't
> have a copy of wireless-2.6 here. Can you send me the patch, or
> explain what it does?
>

Explained above just disable get_tsf and also report to mac
by removing line rx_status.flag |= RX_FLAG_TSFT;

Tomas
