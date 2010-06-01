Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59083 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab0FATu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 15:50:28 -0400
Received: by vws11 with SMTP id 11so1441639vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 12:50:28 -0700 (PDT)
Message-ID: <4C056476.9090905@gmail.com>
Date: Tue, 01 Jun 2010 15:50:14 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
	=?UTF-8?B?R8OhYm9yIFN0ZWZhbg==?= =?UTF-8?B?aWs=?=
	<netrolller.3d@gmail.com>, Joker Joker <jokesareonyou@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Path for fixed channel issue in aircrack-ng suite [V2]
References: <AANLkTinAnMwY0ZCetUmUbuhsp3rB360xvlaGM5ifdFHz@mail.gmail.com>	 <1274775071.3635.4.camel@jlt3.sipsolutions.net>	 <AANLkTilPIt59FhAuVlhisUR7QDabCtnZwahjxWbUysiG@mail.gmail.com>	 <1274860275.3658.0.camel@jlt3.sipsolutions.net>	 <4C000B68.9000305@gmail.com>  <1275416907.3778.11.camel@maxim-laptop> <1275419973.3634.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1275419973.3634.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2010-06-01 at 21:28 +0300, Maxim Levitsky wrote:
>
>   
>>     wireless: allow to retrieve the channel set on monitor interface
>>     
>>     This will allow to preserve compatibility with userspace
>>     
>>     Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
>>
>> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
>> index b01a6f6..09d979b 100644
>> --- a/net/wireless/chan.c
>> +++ b/net/wireless/chan.c
>> @@ -49,9 +49,12 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
>>  {
>>  	struct ieee80211_channel *chan;
>>  	int result;
>> +	struct wireless_dev *mon_dev = NULL;
>>  
>> -	if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR)
>> +	if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR) {
>> +		mon_dev = wdev;
>>  		wdev = NULL;
>> +	}
>>  
>>  	if (wdev) {
>>  		ASSERT_WDEV_LOCK(wdev);
>> @@ -76,5 +79,8 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
>>  	if (wdev)
>>  		wdev->channel = chan;
>>  
>> +	if (mon_dev)
>> +		mon_dev->channel = chan;
>> +
>>     
>
> This won't quite work. monitor interfaces are always slaves in the sense
> that their channel setting never takes precedence over anything, so if
> you add another interface and do something there, the hardware will
> happily channel switch away from the monitor channel, but it will still
> report the old channel here that you set.
>
> I have no idea how to _properly_ fix this though, since eventually we'll
> have a situation where you can have multiple interfaces active on
> different channels, so that monitors don't have a fixed channel anyway.
>
> Maybe this patch is sufficient since it works in the case people care
> about when they _only_ have a monitor interface, but I think it'd be
> nicer if it wouldn't report anything in the other cases.
>
>   
Is this a NACK or a "I wish there was a better way to do this but I'll 
allow it until a better way if found"?

-Rick

> johannes
>
>
>   

