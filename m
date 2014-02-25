Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:49902 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaBYLvI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 06:51:08 -0500
Message-ID: <1393329065.4534.4.camel@porter.coelho.fi> (sfid-20140225_125113_180070_50C8DCF0)
Subject: Re: [PATCH v4 3/4] cfg80211/mac80211: move interface counting for
 combination check to mac80211
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de, Bing Zhao <bzhao@marvell.com>,
	arend@broadcom.com
Date: Tue, 25 Feb 2014 13:51:05 +0200
In-Reply-To: <CA+BoTQ=o4UXSa68Sr8y_ZRt9EAhRGrfYqdvY-33-bEf4TA34kw@mail.gmail.com>
References: <1393275270-7255-1-git-send-email-luca@coelho.fi>
	 <1393275270-7255-4-git-send-email-luca@coelho.fi>
	 <CA+BoTQ=o4UXSa68Sr8y_ZRt9EAhRGrfYqdvY-33-bEf4TA34kw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-25 at 10:22 +0100, Michal Kazior wrote:
> On 24 February 2014 21:54, Luciano Coelho <luca@coelho.fi> wrote:
> 
> [...]
> 
> > --- a/net/mac80211/util.c
> > +++ b/net/mac80211/util.c
> > @@ -2801,3 +2801,79 @@ void ieee80211_recalc_dtim(struct ieee80211_local *local,
> >
> >         ps->dtim_count = dtim_count;
> >  }
> > +
> > +int ieee80211_check_combinations(struct ieee80211_local *local,
> > +                                struct ieee80211_sub_if_data *sdata,
> > +                                const struct cfg80211_chan_def *chandef,
> > +                                enum ieee80211_chanctx_mode chanmode,
> > +                                u8 radar_detect)
> > +{
> > +       struct ieee80211_sub_if_data *sdata_iter;
> > +       enum nl80211_iftype iftype = sdata->wdev.iftype;
> > +       u32 used_iftypes = 0;
> > +       int num[NUM_NL80211_IFTYPES];
> > +       struct ieee80211_chanctx *ctx;
> > +       int num_different_channels = 1;
> > +       int total = 1;
> > +
> > +       lockdep_assert_held(&local->chanctx_mtx);
> > +
> > +       if (WARN_ON(hweight32(radar_detect) > 1))
> > +               return -EINVAL;
> > +
> > +       if (WARN_ON(chanmode == IEEE80211_CHANCTX_SHARED && !chandef->chan))
> > +               return -EINVAL;
> > +
> > +       if (WARN_ON(iftype >= NUM_NL80211_IFTYPES))
> > +               return -EINVAL;
> > +
> > +       /* Always allow software iftypes */
> > +       if (local->hw.wiphy->software_iftypes & BIT(iftype)) {
> > +               if (radar_detect)
> > +                       return -EINVAL;
> > +               return 0;
> > +       }
> > +
> > +       memset(num, 0, sizeof(num));
> > +
> > +       if (iftype != NL80211_IFTYPE_UNSPECIFIED) {
> > +               used_iftypes = BIT(iftype);
> > +               num[iftype] = 1;
> > +       }
> > +
> 
> > +       list_for_each_entry(ctx, &local->chanctx_list, list) {
> > +               if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE) {
> > +                       num_different_channels++;
> > +                       continue;
> > +               }
> > +               if ((chanmode == IEEE80211_CHANCTX_SHARED) &&
> > +                   cfg80211_chandef_compatible(chandef,
> > +                                               &ctx->conf.def))
> > +                       continue;
> > +               num_different_channels++;
> > +               if (ctx->conf.radar_enabled)
> > +                       radar_detect |= BIT(ctx->conf.def.width);
> > +       }
> 
> Hmm.. now that I think about it -- is it correct to skip updating
> radar_detect when a chanctx is exclusive? Shouldn't the radar_enabled
> check be done at the beginning of each iteration?

Yes, you're right.  It makes sense also for shared, because we need to
take into consideration the existing context's width, because the
channels may be compatible but with different widths.

I'll fix and send v5.

--
Luca.

