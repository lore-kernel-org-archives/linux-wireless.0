Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:56963 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbaBXUkI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 15:40:08 -0500
Message-ID: <1393274405.18879.53.camel@porter.coelho.fi> (sfid-20140224_214013_928665_91A19CC5)
Subject: Re: [PATCH v3 7/7] cfg80211/mac80211: move combination check to
 mac80211 for ibss
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Date: Mon, 24 Feb 2014 22:40:05 +0200
In-Reply-To: <1392972532.4346.35.camel@jlt4.sipsolutions.net>
References: <1392906986-12275-1-git-send-email-luca@coelho.fi>
	 <1392906986-12275-8-git-send-email-luca@coelho.fi>
	 <1392972532.4346.35.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-02-21 at 09:48 +0100, Johannes Berg wrote:
> On Thu, 2014-02-20 at 16:36 +0200, Luciano Coelho wrote:
> > From: Luciano Coelho <luciano.coelho@intel.com>
> > 
> > Now that mac80211 can check the interface combinations itself, move
> > the combinations check from cfg80211 to mac80211 when joining an IBSS.
> 
> > +++ b/net/mac80211/ibss.c
> > @@ -1646,7 +1646,31 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
> >  	u32 changed = 0;
> >  	u32 rate_flags;
> >  	struct ieee80211_supported_band *sband;
> > +	enum ieee80211_chanctx_mode chanmode;
> > +	struct ieee80211_local *local = sdata->local;
> > +	int radar_detect_width;
> >  	int i;
> > +	int ret;
> > +
> > +	radar_detect_width = cfg80211_chandef_dfs_required(local->hw.wiphy,
> > +							   &params->chandef,
> > +							   sdata->vif.type);
> > +	if (radar_detect_width < 0)
> > +		return radar_detect_width;
> > +
> > +	if (radar_detect_width > 0 && !params->userspace_handles_dfs)
> > +		return -EINVAL;
> > +
> > +	chanmode = (params->channel_fixed && !radar_detect_width) ?
> > +		IEEE80211_CHANCTX_SHARED : IEEE80211_CHANCTX_EXCLUSIVE;
> > +
> > +	mutex_lock(&local->chanctx_mtx);
> > +	ret = ieee80211_check_combinations(local->hw.wiphy, &sdata->wdev,
> > +					   &params->chandef, chanmode,
> > +					   radar_detect_width);
> > +	mutex_unlock(&local->chanctx_mtx);
> > +	if (ret < 0)
> > +		return ret;
> 
> Hm, that's a lot of new code just for IBSS. Is there anything that could
> be shared with other pieces of mac80211?

It's some extra code, right, but it's not that complicated and the two
things we do differently than in other parts is something we need to do
between the function calls (ie. we need radar_detect_width).   I think
it would get more complicated to try to change that.  Unless I add some
interface type knowledge into ieee80211_check_combinations(), which I'd
rather not do.

OTOH, as I discussed with Michal earlier, we don't strictly need these
calls here, since we will make the checks again when we actually join
the IBSS, where ieee80211_vif_use_channel() is called.  We need the
second check, because something may have changed in between.  But if
that second check fails, we don't return any error to the userspace, it
will just not work (and probably timeout).

I'll leave it as it is for v4, but I can change as you like and send a
new version later.

--
Luca.

