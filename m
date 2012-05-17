Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42166 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab2EQT3c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 15:29:32 -0400
Message-ID: <4FB55197.8070308@candelatech.com> (sfid-20120517_212935_979383_C3FCD3F8)
Date: Thu, 17 May 2012 12:29:27 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: fix memory leak/corruption of bss_list
References: <1337270768-22719-1-git-send-email-eliad@wizery.com>
In-Reply-To: <1337270768-22719-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/17/2012 09:06 AM, Eliad Peller wrote:
> cfg80211_dev_free() calls cfg80211_put_bss() directly on all
> the remaining bss entries, skipping the proper bss entry
> cleanup that usually made by __cfg80211_unlink_bss(), and
> leaving the bss_list and the rb_tree with dangling pointers.
>
> Fix it by calling cfg80211_unlink_bss() instead.

This doesn't apply clean against 3.3..though not too hard
to fix it up by hand.

Do you know how far back this does need to be applied (3.0, for instance)?

Thanks,
Ben

>
> Cc: stable@vger.kernel.org
> Signed-off-by: Eliad Peller<eliad@wizery.com>
> ---
>   net/wireless/core.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 4e86a86..232c385 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -729,7 +729,7 @@ void cfg80211_dev_free(struct cfg80211_registered_device *rdev)
>   	mutex_destroy(&rdev->devlist_mtx);
>   	mutex_destroy(&rdev->sched_scan_mtx);
>   	list_for_each_entry_safe(scan, tmp,&rdev->bss_list, list)
> -		cfg80211_put_bss(&scan->pub);
> +		cfg80211_unlink_bss(&rdev->wiphy,&scan->pub);
>   	kfree(rdev);
>   }
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

