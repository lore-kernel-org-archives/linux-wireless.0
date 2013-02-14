Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57419 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab3BNXvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 18:51:46 -0500
Message-ID: <1360885896.9475.0.camel@jlt4.sipsolutions.net> (sfid-20130215_005149_424901_87EE8B0D)
Subject: Re: [PATCH v3] cfg80211: clean up mesh plink station change API
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Fri, 15 Feb 2013 00:51:36 +0100
In-Reply-To: <CAG6hwVP+D0M-ww8-Joym50WPgL=TUwML3ffjgxT=Mx4q1FHZCA@mail.gmail.com> (sfid-20130214_235252_728553_840C4000)
References: <1360881457-30562-1-git-send-email-johannes@sipsolutions.net>
	 <CAG6hwVP+D0M-ww8-Joym50WPgL=TUwML3ffjgxT=Mx4q1FHZCA@mail.gmail.com>
	 (sfid-20130214_235252_728553_840C4000)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-14 at 14:52 -0800, Thomas Pedersen wrote:
> On Thu, Feb 14, 2013 at 2:37 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > Make the ability to leave the plink_state unchanged not use a
> > magic -1 variable that isn't in the enum, but an explicit change
> > flag; reject invalid plink states or actions and move the needed
> > constants for plink actions to the right header file. Also
> > reject plink_state changes for non-mesh interfaces.
> >
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> > diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> > index 909053a..8e1a03e 100644
> > --- a/net/mac80211/cfg.c
> > +++ b/net/mac80211/cfg.c
> > @@ -1261,7 +1261,9 @@ static int sta_apply_parameters(struct ieee80211_local *local,
> >         if (ieee80211_vif_is_mesh(&sdata->vif)) {
> >  #ifdef CONFIG_MAC80211_MESH
> >                 u32 changed = 0;
> > -               if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED) {
> > +               if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED &&
> > +                   (params->sta_modify_mask &
> > +                                       STATION_PARAM_APPLY_PLINK_STATE)) {
> >                         switch (params->plink_state) {
> >                         case NL80211_PLINK_ESTAB:
> >                                 if (sta->plink_state != NL80211_PLINK_ESTAB)
> > @@ -1292,12 +1294,18 @@ static int sta_apply_parameters(struct ieee80211_local *local,
> >                                 /*  nothing  */
> >                                 break;
> >                         }
> > +               } else if (params->sta_modify_mask &
> > +                                       STATION_PARAM_APPLY_PLINK_STATE) {
> > +                       return -EINVAL;
> 
> It would make sense to disallow setting plink_action if MPM is in userspace.

I'm not sure what you mean?

johannes

