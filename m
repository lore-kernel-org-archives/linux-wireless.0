Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43978 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753150AbdCHNUi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 08:20:38 -0500
Message-ID: <1488979139.31187.4.camel@sipsolutions.net> (sfid-20170308_142115_701287_824A96B8)
Subject: Re: [PATCH] mac80211: reject/clear user rate mask if not usable
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: kirtika@google.com
Date: Wed, 08 Mar 2017 14:18:59 +0100
In-Reply-To: <9f80f983-ca51-ae55-163e-311d86d1edbe@broadcom.com> (sfid-20170308_141746_676397_982CDD5A)
References: <20170308102008.31184-1-johannes@sipsolutions.net>
         <9f80f983-ca51-ae55-163e-311d86d1edbe@broadcom.com>
         (sfid-20170308_141746_676397_982CDD5A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-03-08 at 14:17 +0100, Arend Van Spriel wrote:
> 
> > +void ieee80211_check_rate_mask(struct ieee80211_sub_if_data
> > *sdata)
> > +{
> > +	struct ieee80211_local *local = sdata->local;
> > +	struct ieee80211_supported_band *sband;
> > +	u32 user_mask, basic_rates = sdata-
> > >vif.bss_conf.basic_rates;
> > +	enum nl80211_band band;
> > +
> > +	if (WARN_ON(!sdata->vif.bss_conf.chandef.chan))
> > +		return;
> > +
> > +	if (WARN_ON_ONCE(!basic_rates))
> > +		return;
> > +
> > +	band = sdata->vif.bss_conf.chandef.chan->band;
> > +	user_mask = sdata->rc_rateidx_mask[band];
> > +	sband = local->hw.wiphy->bands[band];
> > +
> > +	basic_rates = sdata->vif.bss_conf.basic_rates;
> 
> basic_rates has already been initialized (and checked) above so this
> is
> redundant.

Huh, yeah, good catch - will fix.

johannes
