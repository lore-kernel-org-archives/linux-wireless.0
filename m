Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:35651 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaBYLQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 06:16:33 -0500
Message-ID: <1393326988.4534.0.camel@porter.coelho.fi> (sfid-20140225_121636_490365_8CC2FF82)
Subject: Re: [PATCH v4 4/4] cfg80211/mac80211: move combination check to
 mac80211 for ibss
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de, Bing Zhao <bzhao@marvell.com>,
	arend@broadcom.com
Date: Tue, 25 Feb 2014 13:16:28 +0200
In-Reply-To: <CA+BoTQkJ4A25jMaT1335URu36eNzFTjT+N0sxZaw9Pph8qT=5w@mail.gmail.com>
References: <1393275270-7255-1-git-send-email-luca@coelho.fi>
	 <1393275270-7255-5-git-send-email-luca@coelho.fi>
	 <CA+BoTQkJ4A25jMaT1335URu36eNzFTjT+N0sxZaw9Pph8qT=5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-25 at 08:49 +0100, Michal Kazior wrote:
> On 24 February 2014 21:54, Luciano Coelho <luca@coelho.fi> wrote:
> > diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> > index bca7d09..745b445 100644
> > --- a/net/mac80211/ibss.c
> > +++ b/net/mac80211/ibss.c
> > @@ -1643,7 +1643,31 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
> >         u32 changed = 0;
> >         u32 rate_flags;
> >         struct ieee80211_supported_band *sband;
> > +       enum ieee80211_chanctx_mode chanmode;
> > +       struct ieee80211_local *local = sdata->local;
> > +       int radar_detect_width;
> >         int i;
> > +       int ret;
> > +
> > +       radar_detect_width = cfg80211_chandef_dfs_required(local->hw.wiphy,
> > +                                                          &params->chandef,
> > +                                                          sdata->vif.type);
> > +       if (radar_detect_width < 0)
> > +               return radar_detect_width;
> > +
> > +       if (radar_detect_width > 0 && !params->userspace_handles_dfs)
> > +               return -EINVAL;
> > +
> > +       chanmode = (params->channel_fixed && !radar_detect_width) ?
> > +               IEEE80211_CHANCTX_SHARED : IEEE80211_CHANCTX_EXCLUSIVE;
> > +
> > +       mutex_lock(&local->chanctx_mtx);
> > +       ret = ieee80211_check_combinations(local->hw.wiphy, &sdata->wdev,
> > +                                          &params->chandef, chanmode,
> > +                                          radar_detect_width);
> 
> I think you forgot to update this call - you should be passing `local`
> and `sdata` here, no?

Definitely.  Forgot to commit. :(

I'll commit and send v5.

--
Luca.

