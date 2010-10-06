Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35669 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759554Ab0JFSIY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 14:08:24 -0400
Message-ID: <4CACBB14.1090507@candelatech.com>
Date: Wed, 06 Oct 2010 11:08:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Crash in cfg80211_unlink_bss
References: <4CACB1D1.7090900@candelatech.com> <1286388245.3655.392.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286388245.3655.392.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/06/2010 11:04 AM, Johannes Berg wrote:
> On Wed, 2010-10-06 at 10:28 -0700, Ben Greear wrote:
>> This test scenario has  72 stations on ath5k trying to connect to a cisco AP
>> that supposedly only supports 63 stations.
>>
>> The 72 STA were created without ssid's configured, then we re-configured all
>> 72 'at once' to give them the proper SSID (ifdown, ifup, iwconfig to set values).
>
> Eww, iwconfig ;-)

Heh, one thing at a time :)

>> The system crashed and rebooted.
>>
>> Kernel is wireless-testing as of later yesterday, with a few additional
>> patches mostly dealing with counters in /proc/net/wireless and some lockdep
>> fixes pulled in from lkml etc.
>>
>> We have seen this before, but this is the first good stacktrace we got.
>>
>> Likely we can reproduce this if extra information is needed.
>
>> list_del corruption, next is LIST_POISON1 (00100100)
>
> This one's interesting.
>
> But anyway, now that I look at it in more detail, it seems fairly
> obvious. You should be able to trigger it with two stations, but it's
> probably harder ...
>
> I need to analyse the refcounting here again and in more detail, but in
> the meantime can you try below patch?

Yes, will do so and let you know the results.

Thanks,
Ben


>
> johannes
>
> ---
>   net/wireless/scan.c |   10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> --- wireless-testing.orig/net/wireless/scan.c	2010-10-06 19:59:41.000000000 +0200
> +++ wireless-testing/net/wireless/scan.c	2010-10-06 20:01:20.000000000 +0200
> @@ -668,11 +668,11 @@ void cfg80211_unlink_bss(struct wiphy *w
>   	bss = container_of(pub, struct cfg80211_internal_bss, pub);
>
>   	spin_lock_bh(&dev->bss_lock);
> -
> -	list_del(&bss->list);
> -	dev->bss_generation++;
> -	rb_erase(&bss->rbn,&dev->bss_tree);
> -
> +	if (!list_empty(&bss->list)) {
> +		list_del_init(&bss->list);
> +		dev->bss_generation++;
> +		rb_erase(&bss->rbn,&dev->bss_tree);
> +	}
>   	spin_unlock_bh(&dev->bss_lock);
>
>   	kref_put(&bss->ref, bss_release);
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

