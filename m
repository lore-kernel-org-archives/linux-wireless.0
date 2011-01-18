Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:48539 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab1ARO3b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 09:29:31 -0500
Message-ID: <4D35A3C9.3070201@neratec.com>
Date: Tue, 18 Jan 2011 15:29:29 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	simon.wunderlich@saxnet.de
Subject: Re: [PATCH 1/5] mac80211: add DFS related channel flags
References: <201101171621.29863.bernhard.schmidt@saxnet.de> <201101181259.46719.bernhard.schmidt@saxnet.de> <1295352973.3563.16.camel@jlt3.sipsolutions.net> <201101181328.04540.bernhard.schmidt@saxnet.de>
In-Reply-To: <201101181328.04540.bernhard.schmidt@saxnet.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/18/2011 01:27 PM, Bernhard Schmidt wrote:
> On Tuesday, January 18, 2011 13:16:13 Johannes Berg wrote:
>> On Tue, 2011-01-18 at 12:59 +0100, Bernhard Schmidt wrote:
>>>> I'm not sure about this -- shouldn't that be global information?
>>>> If one device in the system records a radar on the channel, it
>>>> surely applies to other devices as well, even if they are
>>>> hot-plugged after the radar was found?
>>>
>>> True, I've based this on our IRC discussions, the consensus there
>>> was to do it per-wiphy only at first.
>>
>> I thought what we had discussed there (but I missed at least one
>> meeting) was that the *detector* state, for software-based detection,
>> should be per wiphy. I never heard anywhere that the result of that
>> should be local too.
> 
> Hmm, ok, I might have got that wrong. We should discuss this today on 
> IRC and whatever the consensus is, I will adjust the code.
> 
We discussed that each wiphy needs to have its own pattern detector, due to a missing common time base for accurately time stamp the pulse events.

The channel states on the other hand should be system global, i.e. if one wiphy detected radars on some channel, that channel should not be used by other wiphys.

Ideally the state should be even regulatory specific to support pure radar scanning devices (johill already told that mac82011 does not support per wiphy multi-countrycode operation, but let's plan long term...)


Cheers
Zefir
