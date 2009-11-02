Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28709 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506AbZKBPcF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 10:32:05 -0500
Subject: Re: [PATCH 14/15] iwlwifi: add SM PS support for 6x50 series
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1257017010.3555.139.camel@johannes.local>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
	 <1256938578-9638-15-git-send-email-reinette.chatre@intel.com>
	 <1256968411.3555.77.camel@johannes.local>
	 <1257011058.8387.14.camel@wwguy-ubuntu>
	 <1257017010.3555.139.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 02 Nov 2009 07:29:33 -0800
Message-Id: <1257175773.8387.22.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-10-31 at 12:23 -0700, Johannes Berg wrote:
> On Sat, 2009-10-31 at 10:44 -0700, Guy, Wey-Yi wrote:
> 
> > > >  	ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
> > > > -	ht_info->cap |= (IEEE80211_HT_CAP_SM_PS &
> > > > -			     (WLAN_HT_CAP_SM_PS_DISABLED << 2));
> > > > +	if (priv->cfg->support_sm_ps)
> > > > +		ht_info->cap |= (IEEE80211_HT_CAP_SM_PS &
> > > > +				     (WLAN_HT_CAP_SM_PS_DYNAMIC << 2));
> > > > +	else
> > > > +		ht_info->cap |= (IEEE80211_HT_CAP_SM_PS &
> > > > +				     (WLAN_HT_CAP_SM_PS_DISABLED << 2));
> > > 
> > > here we always and unconditionally advertise dynamic SM-PS mode?
> > 
> > I am confuse, it is based on "priv->cfg->support_sm_ps", so it is not
> > always dynamic SM-PS mode.
> 
> Right, sorry -- but here it _only_ depends on "support_sm_ps", whereas
> 
> > > > +	if (priv->cfg->support_sm_ps) {
> > > > +		/* # Rx chains when idling and maybe trying to save power */
> > > > +		switch (priv->current_ht_config.sm_ps) {
> 
> Here it also depends on current_ht_config.sm_ps, which is not very
> useful. Using the AP setting is wrong, and above, assuming
> "support_sm_ps" [1] is true, this should just always fall into the
> dynamic case so the value "current_ht_config.sm_ps" isn't useful and can
> imho be removed.

Right, I already fix it and not reference to AP's setting. Thanks

> 
> [1] which btw I'd have called "use_sm_ps" since all hardware supports it
> afaik

That is a good point. On the other hand, I think it will make more sense
shoice the sm_ps mode in priv->conf instead of just a boolean value of
"use" or "not" use.

I will submit another patch to fix this.
 

