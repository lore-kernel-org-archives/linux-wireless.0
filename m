Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:47799 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab1HHIRL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 04:17:11 -0400
Date: Mon, 8 Aug 2011 11:16:35 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>
Subject: Re: [PATCH] mac80211/mesh: make the preq queue lock consistent
Message-ID: <20110808081635.GA2938@sapphire.tkos.co.il> (sfid-20110808_101716_725201_4D692256)
References: <52f0e75d7b2308f8ede85362ed96e6af71e39dd3.1311832184.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52f0e75d7b2308f8ede85362ed96e6af71e39dd3.1311832184.git.baruch@tkos.co.il>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi linux-wireless list,

On Thu, Jul 28, 2011 at 08:51:05AM +0300, Baruch Siach wrote:
> Make mesh_preq_queue_lock locking consistent with mesh_queue_preq() using
> spin_lock_bh().

Ping?

baruch

> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  net/mac80211/mesh_hwmp.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index 2b18053..fc8cb1a 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -792,9 +792,9 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
>  		return;
>  	}
>  
> -	spin_lock(&ifmsh->mesh_preq_queue_lock);
> +	spin_lock_bh(&ifmsh->mesh_preq_queue_lock);
>  	if (ifmsh->preq_queue_len == MAX_PREQ_QUEUE_LEN) {
> -		spin_unlock(&ifmsh->mesh_preq_queue_lock);
> +		spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
>  		kfree(preq_node);
>  		if (printk_ratelimit())
>  			mhwmp_dbg("PREQ node queue full\n");
> @@ -806,7 +806,7 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
>  
>  	list_add_tail(&preq_node->list, &ifmsh->preq_queue.list);
>  	++ifmsh->preq_queue_len;
> -	spin_unlock(&ifmsh->mesh_preq_queue_lock);
> +	spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
>  
>  	if (time_after(jiffies, ifmsh->last_preq + min_preq_int_jiff(sdata)))
>  		ieee80211_queue_work(&sdata->local->hw, &sdata->work);

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
