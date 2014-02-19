Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:60801 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaBSMBB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 07:01:01 -0500
Message-ID: <1392811257.12095.95.camel@porter.coelho.fi> (sfid-20140219_130106_682390_7EDD3E97)
Subject: Re: [PATCH 6/7] cfg80211/mac80211: move interface counting for
 combination check to mac80211
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de, Bing Zhao <bzhao@marvell.com>,
	arend@broadcom.com
Date: Wed, 19 Feb 2014 14:00:57 +0200
In-Reply-To: <CA+BoTQ=ZAgOd0suPiTy_6SP6OzGsMcicv_f+foqBUCrL91NU5g@mail.gmail.com>
References: <1392804045-11258-1-git-send-email-luca@coelho.fi>
	 <1392804045-11258-7-git-send-email-luca@coelho.fi>
	 <CA+BoTQ=ZAgOd0suPiTy_6SP6OzGsMcicv_f+foqBUCrL91NU5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-19 at 12:51 +0100, Michal Kazior wrote:
> On 19 February 2014 11:00, Luciano Coelho <luca@coelho.fi> wrote:
> > From: Luciano Coelho <luciano.coelho@intel.com>
> >
> > Move the counting part of the interface combination check from
> > cfg80211 to mac80211.
> >
> > This is needed to simplify locking when the driver has to perform a
> > combination check by itself (eg. with channel-switch).
> >
> > Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> > ---
> 
> [...]
> 
> > @@ -520,6 +521,23 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
> >         WARN_ON(sdata->dev && netif_carrier_ok(sdata->dev));
> >
> >         mutex_lock(&local->chanctx_mtx);
> > +
> > +       radar_detect_width = cfg80211_chandef_dfs_required(local->hw.wiphy,
> > +                                                          chandef,
> > +                                                          sdata->vif.type);
> > +       if (radar_detect_width < 0) {
> > +               ret = radar_detect_width;
> > +               goto out;
> > +       }
> > +
> > +       sdata->radar_required = !!(radar_detect_width);
> > +
> > +       ret = ieee80211_check_combinations(local->hw.wiphy, &sdata->wdev,
> > +                                          chandef, IEEE80211_CHANCTX_SHARED,
> > +                                          radar_detect_width);
> > +       if (ret < 0)
> > +               goto out;
> > +
> 
> Shouldn't you be using `mode` function argument instead of
> IEEE80211_CHANCTX_SHARED?

Good catch! Someone is paying attention, apparently *I* was not. :P
I'll fix it in v2.

--
Luca.

