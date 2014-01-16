Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:55608 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaAPNvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 08:51:04 -0500
Received: by mail-la0-f44.google.com with SMTP id hm7so235212lab.17
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 05:51:01 -0800 (PST)
Message-ID: <52D7E3C1.4090308@gmail.com> (sfid-20140116_145108_030134_94B5AF6A)
Date: Thu, 16 Jan 2014 14:50:57 +0100
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nl80211: Reset split_start on error path when split dump
 is not used
References: <1389879279-20832-1-git-send-email-pontus.fuchs@gmail.com>	 (sfid-20140116_143453_482265_044A6882) <1389879668.4345.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1389879668.4345.5.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-01-16 14:41, Johannes Berg wrote:
> On Thu, 2014-01-16 at 14:34 +0100, Pontus Fuchs wrote:
>> When the netlink skb is exhausted split_start is left set. In the
>> subsequent retry, with a larger buffer, the dump is continued from the
>> failing point instead of from the beginning.
>
> Hmm. Maybe it should be like this instead?
>
> johannes
>
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 138dc3b..2e08af5 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -1680,6 +1680,7 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
>   				    !skb->len &&
>   				    cb->min_dump_alloc < 4096) {
>   					cb->min_dump_alloc = 4096;
> +					state->split_start = 0;
>   					rtnl_unlock();
>   					return 1;
>   				}

Will that not cause problem if split scan is in use and one of the split 
chunks needs to be resent due to EMSGSIZE?

//Pontus

