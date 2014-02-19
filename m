Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:43730 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaBSL2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 06:28:07 -0500
Message-ID: <1392809283.12095.89.camel@porter.coelho.fi> (sfid-20140219_122810_868331_E99DD31B)
Subject: Re: [PATCH 7/7] cfg80211/mac80211: move combination check to
 mac80211 for ibss
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Date: Wed, 19 Feb 2014 13:28:03 +0200
In-Reply-To: <CA+BoTQmFRoS-uEWx-guObucK5dwM8gm=yGt-58hzADQBPxOAtg@mail.gmail.com>
References: <1392804045-11258-1-git-send-email-luca@coelho.fi>
	 <1392804045-11258-8-git-send-email-luca@coelho.fi>
	 <CA+BoTQmFRoS-uEWx-guObucK5dwM8gm=yGt-58hzADQBPxOAtg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-19 at 12:01 +0100, Michal Kazior wrote:
> On 19 February 2014 11:00, Luciano Coelho <luca@coelho.fi> wrote:
> > From: Luciano Coelho <luciano.coelho@intel.com>
> >
> > Now that mac80211 can check the interface combinations itself, move
> > the combinations check from cfg80211 to mac80211 when joining an IBSS.
> >
> > Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> > ---
> >  net/mac80211/ibss.c | 28 +++++++++++++++++++++++++---
> >  net/wireless/ibss.c | 27 ---------------------------
> >  2 files changed, 25 insertions(+), 30 deletions(-)
> >
> > diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> > index 56b0dce..49a25aa 100644
> > --- a/net/mac80211/ibss.c
> > +++ b/net/mac80211/ibss.c
> > @@ -1646,7 +1646,29 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
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
> > +       ret = ieee80211_check_combinations(local->hw.wiphy, &sdata->wdev,
> > +                                          &params->chandef, chanmode,
> > +                                          radar_detect_width);
> > +       if (ret < 0)
> > +               return ret;
> 
> Aren't you supposed to be holding chanctx_mtx while calling
> ieee80211_check_combinations()?

Gulp! You're totally right, I missed the mutex here.  I'll add it and
send it in v2.

I haven't tested IBSS yet, as I said in my cover letter.  This would
have been caught with the lockdep_assert_held() in
ieee80211_check_combinations().


> I hope you're aware this can end up with not being able to connect?
> chanctx isn't claimed until __ieee80211_sta_join_ibss() so you could
> possibly start other interface and break combinations. Or am I missing
> something?

This is just an early check.  The actual connection may still fail later
if someone adds another interface meanwhile.  We check that again in
ieee80211_vif_use_channel().

This was actually broken before my changes, wasn't it? AFAICT the check
was only done in __cfg80211_join_ibss() and not later when the channel
was actually taken into use...


> 
> > @@ -1661,7 +1683,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
> >
> >         /* fix basic_rates if channel does not support these rates */
> >         rate_flags = ieee80211_chandef_rate_flags(&params->chandef);
> > -       sband = sdata->local->hw.wiphy->bands[params->chandef.chan->band];
> > +       sband = local->hw.wiphy->bands[params->chandef.chan->band];
> >         for (i = 0; i < sband->n_bitrates; i++) {
> >                 if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
> >                         sdata->u.ibss.basic_rates &= ~BIT(i);
> > @@ -1710,9 +1732,9 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
> >         ieee80211_bss_info_change_notify(sdata, changed);
> >
> >         sdata->smps_mode = IEEE80211_SMPS_OFF;
> > -       sdata->needed_rx_chains = sdata->local->rx_chains;
> > +       sdata->needed_rx_chains = local->rx_chains;
> >
> > -       ieee80211_queue_work(&sdata->local->hw, &sdata->work);
> > +       ieee80211_queue_work(&local->hw, &sdata->work);
> >
> >         return 0;
> >  }
> 
> Hmm, I don't think this belongs to this patch?

I added a local variable for "local" here, so I also changed the other
parts where it was being dereferenced from sdata.

--
Luca.

