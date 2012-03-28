Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:54060 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300Ab2C1TtV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 15:49:21 -0400
Message-ID: <4F736B3D.5050408@hartkopp.net> (sfid-20120328_214924_699537_A8E2997B)
Date: Wed, 28 Mar 2012 21:49:17 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3.4] mac80211: fix association beacon wait timeout
References: <1332961366.3479.41.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332961366.3479.41.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28.03.2012 21:02, Johannes Berg wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> The TU_TO_EXP_TIME() macro already includes the
> "jiffies +" piece of the calculation, so don't
> add jiffies again.
> 
> Reported-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>



Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>

three times :-)

Thanks Johannes!

> ---
>  net/mac80211/mlme.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- a/net/mac80211/mlme.c	2012-03-28 20:55:35.000000000 +0200
> +++ b/net/mac80211/mlme.c	2012-03-28 20:56:14.000000000 +0200
> @@ -3387,8 +3387,7 @@ int ieee80211_mgd_assoc(struct ieee80211
>  		 */
>  		printk(KERN_DEBUG "%s: waiting for beacon from %pM\n",
>  		       sdata->name, ifmgd->bssid);
> -		assoc_data->timeout = jiffies +
> -				TU_TO_EXP_TIME(req->bss->beacon_interval);
> +		assoc_data->timeout = TU_TO_EXP_TIME(req->bss->beacon_interval);
>  	} else {
>  		assoc_data->have_beacon = true;
>  		assoc_data->sent_assoc = false;
> 
> 


