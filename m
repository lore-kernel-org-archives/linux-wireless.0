Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:33549 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaBTJYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 04:24:44 -0500
Message-ID: <1392888279.10179.14.camel@porter.coelho.fi> (sfid-20140220_102450_630211_3A51B7B6)
Subject: Re: [PATCH v2 6/7] cfg80211/mac80211: move interface counting for
 combination check to mac80211
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de, Bing Zhao <bzhao@marvell.com>,
	arend@broadcom.com
Date: Thu, 20 Feb 2014 11:24:39 +0200
In-Reply-To: <CA+BoTQmKZi4oTVdcz14P-mSH+kiFMbXoAWX0E7+a4EDpjc1J0w@mail.gmail.com>
References: <1392873013-21772-1-git-send-email-luca@coelho.fi>
	 <1392873013-21772-7-git-send-email-luca@coelho.fi>
	 <CA+BoTQmKZi4oTVdcz14P-mSH+kiFMbXoAWX0E7+a4EDpjc1J0w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 09:40 +0100, Michal Kazior wrote:
> On 20 February 2014 06:10, Luciano Coelho <luca@coelho.fi> wrote:
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
> I think you forgot to change SHARED to `mode` :-)

Damn! I changed it in the wrong patch, 7/7 instead of here.

I'll resend.

--
Luca.

