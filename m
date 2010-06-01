Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38433 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab0FASgP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 14:36:15 -0400
Received: by gwaa12 with SMTP id a12so3849109gwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 11:36:14 -0700 (PDT)
Message-ID: <4C05531C.7000506@gmail.com>
Date: Tue, 01 Jun 2010 14:36:12 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	=?UTF-8?B?R8OhYm9yIFN0ZWZh?= =?UTF-8?B?bmlr?=
	<netrolller.3d@gmail.com>, Joker Joker <jokesareonyou@gmail.com>,
	linux-wireless@vger.kernel.org, mister_x@aircrack-ng.org
Subject: Re: Path for fixed channel issue in aircrack-ng suite [V2]
References: <AANLkTinAnMwY0ZCetUmUbuhsp3rB360xvlaGM5ifdFHz@mail.gmail.com>	 <1274775071.3635.4.camel@jlt3.sipsolutions.net>	 <AANLkTilPIt59FhAuVlhisUR7QDabCtnZwahjxWbUysiG@mail.gmail.com>	 <1274860275.3658.0.camel@jlt3.sipsolutions.net>	 <4C000B68.9000305@gmail.com> <1275416907.3778.11.camel@maxim-laptop>
In-Reply-To: <1275416907.3778.11.camel@maxim-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim Levitsky wrote:
> While debugging recent wireless problems, I gave the aircrack suite a
> shot, and found this thread.
>
>   
Thanks Maxim!
> How about this patch to fix this issue:
>
>   
I will definitely find some testers, the problem is that I have been 
unable to reliably reproduce the "channel -1".  Since I don't know the 
exact conditions this happens under the best I can do is have a few 
people test it and make sure no one sees the error.

Mister_X, how does this look to you? I assume you are familiar with the 
issue.

Thanks,
Rick Farina
> commit fffd6e63ea75850dafbf2ccfb38a4189f43c0282
> Author: Maxim Levitsky <maximlevitsky@gmail.com>
> Date:   Tue Jun 1 15:43:21 2010 +0300
>
>     wireless: allow to retrieve the channel set on monitor interface
>     
>     This will allow to preserve compatibility with userspace
>     
>     Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
>
> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> index b01a6f6..09d979b 100644
> --- a/net/wireless/chan.c
> +++ b/net/wireless/chan.c
> @@ -49,9 +49,12 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
>  {
>  	struct ieee80211_channel *chan;
>  	int result;
> +	struct wireless_dev *mon_dev = NULL;
>  
> -	if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR)
> +	if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR) {
> +		mon_dev = wdev;
>  		wdev = NULL;
> +	}
>  
>  	if (wdev) {
>  		ASSERT_WDEV_LOCK(wdev);
> @@ -76,5 +79,8 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
>  	if (wdev)
>  		wdev->channel = chan;
>  
> +	if (mon_dev)
> +		mon_dev->channel = chan;
> +
>  	return 0;
>  }
>
>
>
>   

