Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:56637 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbeBSJDF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 04:03:05 -0500
Subject: Re: [PATCH 02/13] mac80211: ibss: send a probe request instead of
 allocating station
To: Luca Coelho <luca@coelho.fi>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
References: <20180216161301.29339-1-luca@coelho.fi>
 <20180216161301.29339-3-luca@coelho.fi>
From: Nicolas Cavallari <Nicolas.Cavallari@green-communications.fr>
Message-ID: <90dd3605-1418-66e7-80f1-056773dc9fcb@green-communications.fr> (sfid-20180219_100310_967760_A5615282)
Date: Mon, 19 Feb 2018 10:02:58 +0100
MIME-Version: 1.0
In-Reply-To: <20180216161301.29339-3-luca@coelho.fi>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16/02/2018 17:12, Luca Coelho wrote:
> -	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
> -	if (!sta)
> -		return;
>  
> -	/* make sure mandatory rates are always added */
> -	sband = local->hw.wiphy->bands[band];
> -	sta->sta.supp_rates[band] = supp_rates |
> -			ieee80211_mandatory_rates(sband, scan_width);
> -
> -	spin_lock(&ifibss->incomplete_lock);
> -	list_add(&sta->list, &ifibss->incomplete_stations);
> -	spin_unlock(&ifibss->incomplete_lock);
> -	ieee80211_queue_work(&local->hw, &sdata->work);
> +	ieee80211_send_probe_req(sdata, sdata->vif.addr, addr,
> +				 sdata->u.ibss.ssid, sdata->u.ibss.ssid_len,
> +				 NULL, 0, (u32)-1, true, 0,
> +				 chanctx_conf->def.chan, false);
> +	rcu_read_unlock();
>  }

Won't that spam the channel with probe request if the traffic from the
other station is heavy ?

And, if the other station is running the same code and didn't know
about us (e.g. at join time), won't it also spam the channel with
probe requests after receiving our many probe requests ? (as well as
the probe responses from both stations)

Obviously it should stop after receiving a probe response... But what
if the link is badly asymmetric ?
