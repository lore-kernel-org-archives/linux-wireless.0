Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58076 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab2EDGRK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 02:17:10 -0400
Received: by yhmm54 with SMTP id m54so2493961yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 23:17:10 -0700 (PDT)
Message-ID: <4FA37461.6050304@lwfinger.net> (sfid-20120504_081714_622540_D2B7EEBE)
Date: Fri, 04 May 2012 01:17:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Catalin Marinas <catalin.marinas@arm.com>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Suspicious RCU usage in mac80211
References: <4F83A6DE.7070109@lwfinger.net>  <1334201497.3788.1.camel@jlt3.sipsolutions.net>  <4F865155.2000202@lwfinger.net>  <1334202842.3788.10.camel@jlt3.sipsolutions.net>  <4F86FA05.5080404@lwfinger.net>  <1334246145.4062.0.camel@jlt3.sipsolutions.net>  <CAD2nsn1773KvbPCFKBWr5JOkLkj_cz4wk4fkTDA9cAdBUagQcw@mail.gmail.com>  <4FA0371E.9040704@lwfinger.net> <20120502100012.GA8492@arm.com>  <1335978471.4295.3.camel@jlt3.sipsolutions.net>  <20120502200955.GI2450@linux.vnet.ibm.com> <1336070304.5167.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1336070304.5167.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/03/2012 01:38 PM, Johannes Berg wrote:
> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
> index 5b7053c..40d3ff4 100644
> --- a/net/mac80211/agg-tx.c
> +++ b/net/mac80211/agg-tx.c
> @@ -421,16 +421,22 @@ static void sta_tx_agg_session_timer_expired(unsigned long data)
>   	struct tid_ampdu_tx *tid_tx;
>   	unsigned long timeout;
>
> -	tid_tx = rcu_dereference_protected_tid_tx(sta, *ptid);
> -	if (!tid_tx)
> +	rcu_read_lock();
> +	tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[*ptid]);
> +	if (!tid_tx) {
> +		rcu_read_unlock();
>   		return;
> +	}
>
>   	timeout = tid_tx->last_tx + TU_TO_JIFFIES(tid_tx->timeout);
>   	if (time_is_after_jiffies(timeout)) {
>   		mod_timer(&tid_tx->session_timer, timeout);
> +		rcu_read_unlock();
>   		return;
>   	}
>
> +	rcu_read_unlock();
> +
>   #ifdef CONFIG_MAC80211_HT_DEBUG
>   	printk(KERN_DEBUG "tx session timer expired on tid %d\n", (u16)*ptid);
>   #endif

This patch is the same as was proposed by Mohammed on May 1. I must have messed 
up the testing as I thought it failed; however, it is now working.

Mohammed - I plan on submitting this to John with a "From:" from you along with 
your s-o-b. Is that OK. It will be submitted for inclusion in 3.5.

Larry

