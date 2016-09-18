Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:8119 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752803AbcIRH74 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Sep 2016 03:59:56 -0400
From: "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Luca Coelho <luca@coelho.fi>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Beker, Ayala" <ayala.beker@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: RE: [PATCH v2 2/9] mac80211: add boilerplate code for start / stop
 NAN
Date: Sun, 18 Sep 2016 07:59:51 +0000
Message-ID: <B2CD83211F5FDD478D7EFFF030D107ED57286E64@hasmsx108.ger.corp.intel.com> (sfid-20160918_100000_715060_03296C5D)
References: <20160916083321.5840-1-luca@coelho.fi>
 <20160916083321.5840-3-luca@coelho.fi>
 <fae482d0-4bcd-6b06-9846-298a3218ab26@broadcom.com>
In-Reply-To: <fae482d0-4bcd-6b06-9846-298a3218ab26@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Arend Van Spriel [mailto:arend.vanspriel@broadcom.com]
> Sent: Friday, September 16, 2016 14:09
> To: Luca Coelho <luca@coelho.fi>; johannes@sipsolutions.net
> Cc: linux-wireless@vger.kernel.org; Beker, Ayala <ayala.beker@intel.com>;
> Otcheretianski, Andrei <andrei.otcheretianski@intel.com>; Grumbach,
> Emmanuel <emmanuel.grumbach@intel.com>; Coelho, Luciano
> <luciano.coelho@intel.com>
> Subject: Re: [PATCH v2 2/9] mac80211: add boilerplate code for start / stop
> NAN
> 
> On 16-9-2016 10:33, Luca Coelho wrote:
> > From: Ayala Beker <ayala.beker@intel.com>
> >
> > This code doesn't do much besides allowing to start and stop the vif.
> >
> > Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > Signed-off-by: Ayala Beker <ayala.beker@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > ---
> >  include/net/mac80211.h    |  9 +++++++++
> >  net/mac80211/cfg.c        | 36 ++++++++++++++++++++++++++++++++++
> >  net/mac80211/chan.c       |  3 +++
> >  net/mac80211/driver-ops.h | 29 ++++++++++++++++++++++++++-
> >  net/mac80211/iface.c      |  8 ++++++--
> >  net/mac80211/main.c       |  5 +++++
> >  net/mac80211/offchannel.c |  3 ++-
> >  net/mac80211/trace.h      | 50
> +++++++++++++++++++++++++++++++++++++++++++++++
> >  net/mac80211/util.c       |  3 ++-
> >  9 files changed, 141 insertions(+), 5 deletions(-)
> 
> [...]
> 
> > diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
> > index fe35a1c..67b42c8 100644
> > --- a/net/mac80211/driver-ops.h
> > +++ b/net/mac80211/driver-ops.h
> > @@ -163,7 +163,8 @@ static inline void drv_bss_info_changed(struct
> > ieee80211_local *local,
> >
> >  	if (WARN_ON_ONCE(sdata->vif.type ==
> NL80211_IFTYPE_P2P_DEVICE ||
> >  			 (sdata->vif.type == NL80211_IFTYPE_MONITOR &&
> > -			  !sdata->vif.mu_mimo_owner)))
> > +			  !sdata->vif.mu_mimo_owner) ||
> > +			 sdata->vif.type == NL80211_IFTYPE_NAN))
> 
> Might be more clear to move this up right after P2P_DEVICE check.

Why? It's a completely separate new condition - so it goes to the end.

> 
> >  		return;
> >
> >  	if (!check_sdata_in_driver(sdata))
> > @@ -1165,4 +1166,30 @@ static inline void drv_wake_tx_queue(struct
> ieee80211_local *local,
> >  	local->ops->wake_tx_queue(&local->hw, &txq->txq);  }
> >
> > +static inline int drv_start_nan(struct ieee80211_local *local,
> > +				struct ieee80211_sub_if_data *sdata,
> > +				struct cfg80211_nan_conf *conf)
> > +{
> > +	int ret;
> > +
> > +	might_sleep();
> > +	check_sdata_in_driver(sdata);
> > +
> > +	trace_drv_start_nan(local, sdata, conf);
> > +	ret = local->ops->start_nan(&local->hw, &sdata->vif, conf);
> > +	trace_drv_return_int(local, ret);
> > +	return ret;
> > +}
> > +
> > +static inline void drv_stop_nan(struct ieee80211_local *local,
> > +				struct ieee80211_sub_if_data *sdata) {
> > +	might_sleep();
> > +	check_sdata_in_driver(sdata);
> > +
> > +	trace_drv_stop_nan(local, sdata);
> > +	local->ops->stop_nan(&local->hw, &sdata->vif);
> > +	trace_drv_return_void(local);
> > +}
> > +
> >  #endif /* __MAC80211_DRIVER_OPS */
> > diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c index
> > e694ca2..507f46a 100644
> > --- a/net/mac80211/iface.c
> > +++ b/net/mac80211/iface.c
> > @@ -327,6 +327,9 @@ static int ieee80211_check_queues(struct
> ieee80211_sub_if_data *sdata,
> >  	int n_queues = sdata->local->hw.queues;
> >  	int i;
> >
> > +	if (iftype == NL80211_IFTYPE_NAN)
> > +		return 0;
> > +
> >  	if (iftype != NL80211_IFTYPE_P2P_DEVICE) {
> >  		for (i = 0; i < IEEE80211_NUM_ACS; i++) {
> >  			if (WARN_ON_ONCE(sdata->vif.hw_queue[i] == @@
> -647,7 +650,8 @@ int
> > ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
> >  			local->fif_probe_req++;
> >  		}
> >
> > -		if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE)
> > +		if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE &&
> > +		    sdata->vif.type != NL80211_IFTYPE_NAN)
> 
> similar check keeps reoccuring in various places so maybe we can create a
> helper function for it.

Right, but not sure that it deserves a function.

> 
> >  			changed |= ieee80211_reset_erp_info(sdata);
> >  		ieee80211_bss_info_change_notify(sdata, changed);
> >
> 
> Regards,
> Arend
