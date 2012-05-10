Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:51830 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab2EJH5w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 03:57:52 -0400
Message-ID: <4FAB74FD.7080004@tieto.com> (sfid-20120510_095756_156698_EBA8C1FA)
Date: Thu, 10 May 2012 09:57:49 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/7] mac80211: add tracking of temporary offchannel sdata
References: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>  <1336632282-2278-2-git-send-email-michal.kazior@tieto.com> <1336634791.4334.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1336634791.4334.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Hi Michal,
>
>> This is necessary if we want to have a sdata-based
>> channel recalculation.
>>
>> Change-Id: I223e052146893b3ae1ca46de7d90c54ffc589f1b
>> Signed-off-by: Michal Kazior<michal.kazior@tieto.com>
>> ---
>>   net/mac80211/ieee80211_i.h |    1 +
>>   net/mac80211/work.c        |    2 ++
>>   2 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
>> index b5e491b..c109960 100644
>> --- a/net/mac80211/ieee80211_i.h
>> +++ b/net/mac80211/ieee80211_i.h
>> @@ -997,6 +997,7 @@ struct ieee80211_local {
>>   	struct ieee80211_channel *oper_channel, *csa_channel;
>>
>>   	/* Temporary remain-on-channel for off-channel operations */
>> +	struct ieee80211_sub_if_data *tmp_sdata;
>>   	struct ieee80211_channel *tmp_channel;
>>   	enum nl80211_channel_type tmp_channel_type;
>
> Do you actually need this? I'm still tempted to not worry about any of
> this and force drivers to implement remain-on-channel in the driver or
> device for multi-channel, and this temporary thing is only used for
> remain-on-channel operations now.

No I don't. But if it's not done we break the whole thing (sw 
offchannel/scan) with my next patch. We might as well just remove all 
the sw offchannel/scan code.

How many drivers are there that still depend on sw offchannel? Can we 
just go ahead and break them?


-- 
Pozdrawiam / Best regards, Michal Kazior.
