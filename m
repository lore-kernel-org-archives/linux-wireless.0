Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:55225 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab2CWJTv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 05:19:51 -0400
Message-ID: <4F6C4034.4050802@tieto.com> (sfid-20120323_102000_751421_631848DF)
Date: Fri, 23 Mar 2012 10:19:48 +0100
From: =?UTF-8?B?TWljaGHFgiBLYXppb3I=?= <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 12/12] mac80211: return NULL from get_channel in multi-channel
References: <892b9fb4-fb69-486f-b619-85d6336e5a31@FIVLA-EXHUB02.eu.tieto.com>	 (sfid-20120320_155530_182045_07E4AF64) <1332492860.3506.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332492860.3506.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2012-03-19 at 13:57 +0100, Michal Kazior wrote:
>> According to comment on cfg80211_ops/get_channel we should return NULL
>> in case of concurrent multi-channel.
>>
>> Signed-off-by: Michal Kazior<michal.kazior@tieto.com>
>> ---
>>   net/mac80211/cfg.c |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
>> index 88cc128..05f7022 100644
>> --- a/net/mac80211/cfg.c
>> +++ b/net/mac80211/cfg.c
>> @@ -2680,6 +2680,9 @@ ieee80211_wiphy_get_channel(struct wiphy *wiphy)
>>   	struct ieee80211_local *local = wiphy_priv(wiphy);
>>   	struct ieee80211_channel_state *chan_state =&local->chan_state;
>>
>> +	if (local->hw.flags&  IEEE80211_HW_SUPPORTS_MULTI_CHANNEL)
>> +		return NULL;
>> +
>
> We should return NULL if we're actually using multiple channels :-)
>
> So clearly we need mac80211 do more work in tracking which channels are
> used, compatible, etc.

Oh. So will it be enough to iterate through the interfaces that are up 
and check if they have different operational channels?


-- Pozdrawiam / Best Regards, Michal Kazior.
