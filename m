Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40244 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965077AbbLHPm7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 10:42:59 -0500
Message-ID: <1449589374.4154.11.camel@sipsolutions.net> (sfid-20151208_164305_654009_DD85946D)
Subject: Re: [PATCH 6/9] mac80211: handle width changes from opmode
 notification IE in beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>
Date: Tue, 08 Dec 2015 16:42:54 +0100
In-Reply-To: <CABPxzYK=RdZo0WB7Tt4PO19n23+9rgAypj=OEDZE8GJ6cV_gXw@mail.gmail.com> (sfid-20151208_163915_733456_BB9785B1)
References: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1449583479-26658-7-git-send-email-emmanuel.grumbach@intel.com>
	 <CABPxzYK=RdZo0WB7Tt4PO19n23+9rgAypj=OEDZE8GJ6cV_gXw@mail.gmail.com>
	 (sfid-20151208_163915_733456_BB9785B1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-12-08 at 21:08 +0530, Krishna Chaitanya wrote:
> 
> >  void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data
> > *sdata,
> >                                  struct sta_info *sta, u8 opmode,
> > -                                enum ieee80211_band band, bool
> > nss_only)
> > +                                enum ieee80211_band band)
> >  {
> >         struct ieee80211_local *local = sdata->local;
> >         struct ieee80211_supported_band *sband = local->hw.wiphy-
> > >bands[band];
> > 
> > -       u32 changed = __ieee80211_vht_handle_opmode(sdata, sta,
> > opmode,
> > -                                                   band,
> > nss_only);
> > +       u32 changed = __ieee80211_vht_handle_opmode(sdata, sta,
> > opmode, band);
> > 
> >         if (changed > 0)
> >                 rate_control_rate_update(local, sband, sta,
> > changed);
> 
> Not related to current change.
> 
> I was looking at this code a while ago and found that
> rate_control_rate_update
> doesn't update the rates from rx_nss, rather it updates from HT/VHT
> capabilities.
> 
> So how does the NSS update from OP MODE IE work?
> 

Huh? You just quoted the code that does this?

If the rate control algorithm doesn't look at sta->sta.rx_nss then
that's their bug.

johannes
