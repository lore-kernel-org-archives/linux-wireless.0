Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44077 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab0JGRWq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 13:22:46 -0400
Message-ID: <4CAE01CC.40204@candelatech.com>
Date: Thu, 07 Oct 2010 10:22:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH] mac80211: fix sw scan locking
References: <1286448924.3657.35.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286448924.3657.35.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/07/2010 03:55 AM, Johannes Berg wrote:
> From: Johannes Berg<johannes.berg@intel.com>
>
> The recent scan overhaul broke locking
> because now we can jump to code that
> attempts to unlock, while we don't have
> the mutex held. Fix this by holding the
> mutex around all the relevant code.
>
> Reported-by: Ben Greear<greearb@candelatech.com>
> Signed-off-by: Johannes Berg<johannes.berg@intel.com>

That does indeed fix the problem for me.

Thanks,
Ben

> ---
>   net/mac80211/scan.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> --- wireless-testing.orig/net/mac80211/scan.c	2010-10-07 10:50:51.000000000 +0200
> +++ wireless-testing/net/mac80211/scan.c	2010-10-07 10:51:10.000000000 +0200
> @@ -682,8 +682,6 @@ void ieee80211_scan_work(struct work_str
>   		goto out_complete;
>   	}
>
> -	mutex_unlock(&local->mtx);
> -
>   	/*
>   	 * as long as no delay is required advance immediately
>   	 * without scheduling a new work
> @@ -714,6 +712,7 @@ void ieee80211_scan_work(struct work_str
>   	} while (next_delay == 0);
>
>   	ieee80211_queue_delayed_work(&local->hw,&local->scan_work, next_delay);
> +	mutex_unlock(&local->mtx);
>   	return;
>
>   out_complete:
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

