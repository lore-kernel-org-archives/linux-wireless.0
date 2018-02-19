Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59848 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752657AbeBSM65 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 07:58:57 -0500
Message-ID: <1519045134.7832.107.camel@coelho.fi> (sfid-20180219_135900_679349_060D03DA)
From: Luca Coelho <luca@coelho.fi>
To: Sara Sharon <sara.sharon@intel.com>
Cc: linux-wireless@vger.kernel.org,
        Nicolas Cavallari <Nicolas.Cavallari@green-communications.fr>,
        johannes@sipsolutions.net
Date: Mon, 19 Feb 2018 14:58:54 +0200
In-Reply-To: <90dd3605-1418-66e7-80f1-056773dc9fcb@green-communications.fr>
References: <20180216161301.29339-1-luca@coelho.fi>
         <20180216161301.29339-3-luca@coelho.fi>
         <90dd3605-1418-66e7-80f1-056773dc9fcb@green-communications.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 02/13] mac80211: ibss: send a probe request instead of
 allocating station
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-02-19 at 10:02 +0100, Nicolas Cavallari wrote:
> On 16/02/2018 17:12, Luca Coelho wrote:
> > -	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
> > -	if (!sta)
> > -		return;
> >  
> > -	/* make sure mandatory rates are always added */
> > -	sband = local->hw.wiphy->bands[band];
> > -	sta->sta.supp_rates[band] = supp_rates |
> > -			ieee80211_mandatory_rates(sband,
> > scan_width);
> > -
> > -	spin_lock(&ifibss->incomplete_lock);
> > -	list_add(&sta->list, &ifibss->incomplete_stations);
> > -	spin_unlock(&ifibss->incomplete_lock);
> > -	ieee80211_queue_work(&local->hw, &sdata->work);
> > +	ieee80211_send_probe_req(sdata, sdata->vif.addr, addr,
> > +				 sdata->u.ibss.ssid, sdata-
> > >u.ibss.ssid_len,
> > +				 NULL, 0, (u32)-1, true, 0,
> > +				 chanctx_conf->def.chan, false);
> > +	rcu_read_unlock();
> >  }
> 
> Won't that spam the channel with probe request if the traffic from
> the
> other station is heavy ?
> 
> And, if the other station is running the same code and didn't know
> about us (e.g. at join time), won't it also spam the channel with
> probe requests after receiving our many probe requests ? (as well as
> the probe responses from both stations)
> 
> Obviously it should stop after receiving a probe response... But what
> if the link is badly asymmetric ?

Sari, can you please look into this?

--
Cheers,
Luca.
