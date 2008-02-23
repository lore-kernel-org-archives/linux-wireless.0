Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:49279 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752242AbYBWGv3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 01:51:29 -0500
Date: Sat, 23 Feb 2008 07:41:33 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: [PATCH 08/13 v2] o11s: other changes in mac80211 for mesh
 interface support
Message-ID: <20080223074133.32a4609c@morte> (sfid-20080223_065135_680981_891C74D3)
In-Reply-To: <47be7741.05d6720a.44c4.ffffd0c9@mx.google.com>
References: <47be7741.05d6720a.44c4.ffffd0c9@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 21 Feb 2008 20:17:08 -0800
Luis Carlos Cobo <luisca@cozybit.com> wrote:

> diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
> index da8462b..5322486 100644
> --- a/net/mac80211/rc80211_pid_algo.c
> +++ b/net/mac80211/rc80211_pid_algo.c
> @@ -15,6 +15,9 @@
>  #include <linux/debugfs.h>
>  #include <net/mac80211.h>
>  #include "ieee80211_rate.h"
> +#ifdef CONFIG_MAC80211_MESH
> +#include "mesh.h"
> +#endif
>  
>  #include "rc80211_pid.h"
>  
> @@ -148,6 +151,9 @@ static void rate_control_pid_sample(struct rc_pid_info *pinfo,
>  				    struct ieee80211_local *local,
>  				    struct sta_info *sta)
>  {
> +#ifdef CONFIG_MAC80211_MESH
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
> +#endif
>  	struct rc_pid_sta_info *spinfo = sta->rate_ctrl_priv;
>  	struct rc_pid_rateinfo *rinfo = pinfo->rinfo;
>  	struct ieee80211_supported_band *sband;
> @@ -178,7 +184,14 @@ static void rate_control_pid_sample(struct rc_pid_info *pinfo,
>  		pf = spinfo->last_pf;
>  	else {
>  		pf = spinfo->tx_num_failed * 100 / spinfo->tx_num_xmit;
> +#ifdef CONFIG_MAC80211_MESH
> +		if (pf == 100 &&
> +		    sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
> +			mesh_plink_broken(sta);
> +#endif

I'd like to have this moved, maybe right before this:

        /* Compute the controller output. */

>  		pf <<= RC_PID_ARITH_SHIFT;
> +		sta->fail_avg = ((pf + (spinfo->last_pf << 3)) / 9)
> +					>> RC_PID_ARITH_SHIFT;
>  	}

What do you need fail_avg for? Please note that we have better estimates of
the frame failure trends (e.g., err_avg). What these magic values are?


--
Ciao
Stefano
