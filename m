Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36260 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab1DEPZc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 11:25:32 -0400
Message-ID: <4D9B346A.5000601@openwrt.org>
Date: Tue, 05 Apr 2011 17:25:30 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Mohammed Shafi <mshajakhan@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: Add station uptime in debugfs
References: <1302010795-2522-1-git-send-email-mshajakhan@atheros.com> <4D9B2268.8070902@openwrt.org> <4D9B2F79.2090606@atheros.com>
In-Reply-To: <4D9B2F79.2090606@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-04-05 5:04 PM, Mohammed Shafi wrote:
> On Tuesday 05 April 2011 07:38 PM, Felix Fietkau wrote:
>>  On 2011-04-05 3:39 PM, Mohammed Shafi Shajakhan wrote:
>>
>>>  From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>>
>>>  Add station uptime parameter in debugfs. This will be helpful to get a
>>>  measure of stability of connection and also during stress testing.
>>>
>>>  Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>>
>>
>>>  diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
>>>  index 999f8fb..08b9f51 100644
>>>  --- a/net/mac80211/sta_info.c
>>>  +++ b/net/mac80211/sta_info.c
>>>  @@ -244,6 +244,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
>>>     	sta->local = local;
>>>     	sta->sdata = sdata;
>>>     	sta->last_rx = jiffies;
>>>  +	sta->sta_uptime = jiffies;
>>>
>>>     	ewma_init(&sta->avg_signal, 1024, 8);
>>>
>>>
>>  I think jiffies can easily overflow. Maybe it would be better to get a
>>  timeval from the monotonic clock.
>>
> Thanks, yes thats true and I assumed this will work fine for 49 days
> assuming 32 bit(please correct me if my calculations are wrong). will
> the overflow will take place in less than this time?.
Yes, but there are people that deploy point to point links that can last 
longer than that ;)

> I will dig more into it by looking at the time val.
Thanks.

- Felix
