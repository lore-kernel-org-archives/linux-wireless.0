Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49167 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbaCJHoK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 03:44:10 -0400
Message-ID: <1394437421.18265.3.camel@dubbel> (sfid-20140310_084423_390713_0CA25AB4)
Subject: Re: [PATCH v6 2/3] mac80211: implement chanctx reservation
From: Luciano Coelho <luciano.coelho@intel.com>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michal Kazior <michal.kazior@tieto.com>, sw@simonwunderlich.de,
	andrei.otcheretianski@intel.com
Date: Mon, 10 Mar 2014 09:43:41 +0200
In-Reply-To: <CAB3XZEd-EQ5zHKzvW_zVngGAtzRO8_Bm61yAYN6ADZVHVnby5w@mail.gmail.com>
References: <1394376039-9644-1-git-send-email-luciano.coelho@intel.com>
	 <1394376039-9644-3-git-send-email-luciano.coelho@intel.com>
	 <CAB3XZEd-EQ5zHKzvW_zVngGAtzRO8_Bm61yAYN6ADZVHVnby5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-03-09 at 17:08 +0200, Eliad Peller wrote:
> hi Luca,
> 
> On Sun, Mar 9, 2014 at 4:40 PM, Luciano Coelho <luciano.coelho@intel.com> wrote:
> > In order to support channel switch with multiple vifs and multiple
> > contexts, we implement a concept of channel context reservation.  This
> > allows us to reserve a channel context to be used later.
> >
> > The reservation functionality is not tied directly to channel switch
> > and may be used in other situations (eg. reserving a channel context
> > during IBSS join).
> >
> > We first check if an existing compatible context exists and if it
> > does, we reserve it.  If there is no compatible context we create a
> > new one and reserve it.
> >
> > Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> > ---
> [...]
> 
> > +int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
> > +                                      u32 *changed)
> > +{
> [...]
> > +
> > +       *changed = local_changed;
> > +
> > +       ieee80211_recalc_chanctx_chantype(local, ctx);
> > +       ieee80211_recalc_smps_chanctx(local, ctx);
> > +       ieee80211_recalc_radar_chanctx(local, ctx);
> 
> any reason for not calling ieee80211_recalc_chanctx_min_def() as well?

No, it's just missing. :( I'll add it.

--
Luca.

