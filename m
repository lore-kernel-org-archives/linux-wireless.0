Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:50762 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab2F1HBt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 03:01:49 -0400
Message-ID: <4FEC015B.4020603@tieto.com> (sfid-20120628_090153_931546_99E8782A)
Date: Thu, 28 Jun 2012 09:01:47 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v3] initial channel context implementation
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>    <1340718188.14634.47.camel@jlt3.sipsolutions.net>    <4FEAB698.5070309@tieto.com>   <1340784614.8305.8.camel@jlt3.sipsolutions.net>   <4FEADCAE.5080508@tieto.com>  <1340795424.11012.11.camel@jlt3.sipsolutions.net>  <4FEAFFF1.7080706@tieto.com> <1340805730.11012.33.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340805730.11012.33.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2012-06-27 at 14:43 +0200, Michal Kazior wrote:
>>> That was intended for AP mode, I'm not sure it's good for station mode,
>>> in station mode we need to have current_bss->channel updated as well in
>>> that case.
>>>
>>>> This would probably require some more
>>>> additional changes too (maybe with regard to channel tracking too).
>>>>
>>>> Worst-case we disconnect other interfaces. We might be able to create a
>>>> new channel context (provided num_different_channels hasn't been reached
>>>> yet) or reuse an existing channel context (provided CSA happens to
>>>> target a channel we have a channel context for already).
>>>
>>> Yeah ... we need to think about it more. I thought we could put it off a
>>> bit longer, but I guess with the channel tracking we already need it?
>>
>> Hmm.. Yeah we need to now, sort of. FullMAC drivers could suffer, but we
>> could drop connections upon CSA in mac80211 for the time being.
>>
>> cfg80211 could provide:
>>    * cfg80211_sta_can_switch_chan
>>    * cfg80211_sta_ch_switch_notify
>>
>> mac80211 could then be able to know whether num_different_channels has
>> been reached (cfg80211_sta_can_switch_chan) and eventually notify upon
>> channel switch (cfg80211_sta_ch_switch_notify).
>>
>> Channel switch would happen if either:
>>    * cfg80211_sta_can_switch_chan is true
>>    * channel context for target CSA channel already exists
>>
>> I'm just unsure about the current_bss thing - whether we should e.g.
>> initiate a scan to update it, or can we shamelessly update the channel
>> in the structure directly?
>
> Today mac80211 just updates it, yeah.

Should I send the ,,respect channels in iface combinations'' as a 
[PATCH] now, or should the CSA issue (in cfg80211) be addressed first?


-- 
Pozdrawiam / Best regards, Michal Kazior.

