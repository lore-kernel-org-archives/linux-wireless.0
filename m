Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:46237 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaBSL50 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 06:57:26 -0500
Message-ID: <1392811044.12095.93.camel@porter.coelho.fi> (sfid-20140219_125729_705301_1E0CC989)
Subject: Re: [PATCH 7/7] cfg80211/mac80211: move combination check to
 mac80211 for ibss
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Date: Wed, 19 Feb 2014 13:57:24 +0200
In-Reply-To: <CA+BoTQn3WAuVPM5HSHoaKFAhdDFfp7_qJXNEd+Nc_9B6VCk67g@mail.gmail.com>
References: <1392804045-11258-1-git-send-email-luca@coelho.fi>
	 <1392804045-11258-8-git-send-email-luca@coelho.fi>
	 <CA+BoTQmFRoS-uEWx-guObucK5dwM8gm=yGt-58hzADQBPxOAtg@mail.gmail.com>
	 <1392809283.12095.89.camel@porter.coelho.fi>
	 <CA+BoTQn3WAuVPM5HSHoaKFAhdDFfp7_qJXNEd+Nc_9B6VCk67g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-19 at 12:48 +0100, Michal Kazior wrote:
> On 19 February 2014 12:28, Luca Coelho <luca@coelho.fi> wrote:
> > On Wed, 2014-02-19 at 12:01 +0100, Michal Kazior wrote:
> >> On 19 February 2014 11:00, Luciano Coelho <luca@coelho.fi> wrote:
> >> > From: Luciano Coelho <luciano.coelho@intel.com>
> >> >
> >> > Now that mac80211 can check the interface combinations itself, move
> >> > the combinations check from cfg80211 to mac80211 when joining an IBSS.
> >> >
> >> > Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> >> > ---
> >> >  net/mac80211/ibss.c | 28 +++++++++++++++++++++++++---
> >> >  net/wireless/ibss.c | 27 ---------------------------
> >> >  2 files changed, 25 insertions(+), 30 deletions(-)
> >> >
> >> > diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> >> > index 56b0dce..49a25aa 100644
> >> > --- a/net/mac80211/ibss.c
> >> > +++ b/net/mac80211/ibss.c
> >> > @@ -1646,7 +1646,29 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
> >> >         u32 changed = 0;
> >> >         u32 rate_flags;
> >> >         struct ieee80211_supported_band *sband;
> >> > +       enum ieee80211_chanctx_mode chanmode;
> >> > +       struct ieee80211_local *local = sdata->local;
> >> > +       int radar_detect_width;
> >> >         int i;
> >> > +       int ret;
> >> > +
> >> > +       radar_detect_width = cfg80211_chandef_dfs_required(local->hw.wiphy,
> >> > +                                                          &params->chandef,
> >> > +                                                          sdata->vif.type);
> >> > +       if (radar_detect_width < 0)
> >> > +               return radar_detect_width;
> >> > +
> >> > +       if (radar_detect_width > 0 && !params->userspace_handles_dfs)
> >> > +               return -EINVAL;
> >> > +
> >> > +       chanmode = (params->channel_fixed && !radar_detect_width) ?
> >> > +               IEEE80211_CHANCTX_SHARED : IEEE80211_CHANCTX_EXCLUSIVE;
> >> > +
> >> > +       ret = ieee80211_check_combinations(local->hw.wiphy, &sdata->wdev,
> >> > +                                          &params->chandef, chanmode,
> >> > +                                          radar_detect_width);
> >> > +       if (ret < 0)
> >> > +               return ret;
> >>
> >> Aren't you supposed to be holding chanctx_mtx while calling
> >> ieee80211_check_combinations()?
> >
> > Gulp! You're totally right, I missed the mutex here.  I'll add it and
> > send it in v2.
> >
> > I haven't tested IBSS yet, as I said in my cover letter.  This would
> > have been caught with the lockdep_assert_held() in
> > ieee80211_check_combinations().
> >
> >
> >> I hope you're aware this can end up with not being able to connect?
> >> chanctx isn't claimed until __ieee80211_sta_join_ibss() so you could
> >> possibly start other interface and break combinations. Or am I missing
> >> something?
> >
> > This is just an early check.  The actual connection may still fail later
> > if someone adds another interface meanwhile.  We check that again in
> > ieee80211_vif_use_channel().
> >
> > This was actually broken before my changes, wasn't it? AFAICT the check
> > was only done in __cfg80211_join_ibss() and not later when the channel
> > was actually taken into use...
> 
> True. Maybe it's pointless to perform the check here at all? It
> doesn't guarantee anything..

Right, it's not entirely necessary, but at least we will fail early and
cleanly in most cases.  If we don't check here, it will only fail later,
in work context, and from the userspace perspective it just won't work
and will probably timeout instead.


--
Luca.

