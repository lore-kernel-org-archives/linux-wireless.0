Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:44452 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbaCDJDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 04:03:44 -0500
Message-ID: <1393923821.13669.123.camel@dubbel> (sfid-20140304_100359_501176_C6A380C6)
Subject: Re: [PATCH v3 2/3] mac80211: implement chanctx reservation
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Date: Tue, 04 Mar 2014 11:03:41 +0200
In-Reply-To: <CA+BoTQnXUzJWfe3yoVoLDB=dSvZUsuCEVoX1UFk8KOBxzZr=6Q@mail.gmail.com>
References: <1393590200-25309-1-git-send-email-luca@coelho.fi>
	 <1393590200-25309-3-git-send-email-luca@coelho.fi>
	 <CA+BoTQnXUzJWfe3yoVoLDB=dSvZUsuCEVoX1UFk8KOBxzZr=6Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-03 at 12:54 +0100, Michal Kazior wrote:
> On 28 February 2014 13:23, Luca Coelho <luca@coelho.fi> wrote:
> 
> [...]
> 
> > +int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
> > +                                 const struct cfg80211_chan_def *chandef)
> > +{
> > +       struct ieee80211_local *local = sdata->local;
> > +       struct ieee80211_chanctx_conf *conf;
> > +       struct ieee80211_chanctx *new_ctx, *curr_ctx;
> > +       int ret = 0;
> > +
> > +       mutex_lock(&local->chanctx_mtx);
> > +
> > +       conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
> > +                                        lockdep_is_held(&local->chanctx_mtx));
> > +       if (!conf) {
> > +               ret = -EINVAL;
> > +               goto out;
> > +       }
> > +
> > +       curr_ctx = container_of(conf, struct ieee80211_chanctx, conf);
> > +
> > +       /* try to find another context with the chandef we want */
> > +       new_ctx = ieee80211_find_chanctx(local, chandef,
> > +                                        IEEE80211_CHANCTX_SHARED);
> > +       if (!new_ctx) {
> > +               /* create a new context */
> > +               new_ctx = ieee80211_new_chanctx(local, chandef,
> > +                                               IEEE80211_CHANCTX_SHARED);
> 
> Shouldn't you use curr_ctx->mode here instead of SHARED? Or perhaps
> the function should take `mode` argument..
> 
> For CSA it's probably okay to just use curr_ctx->mode, but for a more
> generic reservation it should probably be an argument.

You're right.  I'll add mode as an argument to this function in v4.

--
Luca

