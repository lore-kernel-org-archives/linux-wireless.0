Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:39476 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936456Ab3DRWUe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 18:20:34 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
	Thu, 18 Apr 2013 16:20:33 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 8F76B3E40066
	for <linux-wireless@vger.kernel.org>; Thu, 18 Apr 2013 16:20:07 -0600 (MDT)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r3IMKJcx123956
	for <linux-wireless@vger.kernel.org>; Thu, 18 Apr 2013 16:20:19 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r3IMN8hx013054
	for <linux-wireless@vger.kernel.org>; Thu, 18 Apr 2013 16:23:09 -0600
Date: Thu, 18 Apr 2013 15:20:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: use synchronize_rcu() with rcu_barrier()
Message-ID: <20130418222017.GF3479@linux.vnet.ibm.com> (sfid-20130419_002041_930071_30837809)
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130418220443.GB3759@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130418220443.GB3759@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 18, 2013 at 06:04:43PM -0400, Bob Copeland wrote:
> The RCU docs used to state that rcu_barrier() included a wait
> for an RCU grace period; however the comments for rcu_barrier()
> as of commit f0a0e6f... "rcu: Clarify memory-ordering properties
> of grace-period primitives" contradict this.
> 
> So add back synchronize_{rcu,net}() to where they once were,
> but keep the rcu_barrier()s for the call_rcu() callbacks.
> 
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Bob Copeland <bob@cozybit.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  net/mac80211/iface.c |    5 +++--
>  net/mac80211/pm.c    |    1 +
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index b6abaaa..c634aff 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -836,11 +836,12 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  		 *
>  		 * sta_info_flush_cleanup() requires rcu_barrier()
>  		 * first to wait for the station call_rcu() calls
> -		 * to complete, here we need at least sychronize_rcu()
> -		 * it to wait for the RX path in case it is using the
> +		 * to complete, and we also need synchronize_rcu()
> +		 * to wait for the RX path in case it is using the
>  		 * interface and enqueuing frames at this very time on
>  		 * another CPU.
>  		 */
> +		synchronize_rcu();
>  		rcu_barrier();
>  		sta_info_flush_cleanup(sdata);
> 
> diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
> index 4431f0f..7fc5d0d 100644
> --- a/net/mac80211/pm.c
> +++ b/net/mac80211/pm.c
> @@ -38,6 +38,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
>  					IEEE80211_QUEUE_STOP_REASON_SUSPEND);
> 
>  	/* flush out all packets and station cleanup call_rcu()s */
> +	synchronize_net();
>  	rcu_barrier();
> 
>  	ieee80211_flush_queues(local, NULL);
> -- 
> 1.7.10.4
> 
> -- 
> Bob Copeland %% www.bobcopeland.com
> 

