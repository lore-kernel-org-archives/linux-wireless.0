Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34911 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbcCFQD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 11:03:56 -0500
Received: by mail-wm0-f68.google.com with SMTP id 1so6764773wmg.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 08:03:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160306155809.GA15589@w1.fi>
References: <1456954113-4682-1-git-send-email-emmanuel.grumbach@intel.com> <20160306155809.GA15589@w1.fi>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 6 Mar 2016 18:03:40 +0200
Message-ID: <CA+XVXfdb-LueLUp1N6OSpXU+roUTisqj1R+wW98WDrqgtRvdLA@mail.gmail.com> (sfid-20160306_170400_036322_0B037D01)
Subject: Re: [PATCH 1/3] mac80211: TDLS: always downgrade invalid chandefs
To: Jouni Malinen <j@w1.fi>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	"Peer, Ilan" <ilan.peer@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 6, 2016 at 5:58 PM, Jouni Malinen <j@w1.fi> wrote:
>
> On Wed, Mar 02, 2016 at 11:28:31PM +0200, Emmanuel Grumbach wrote:
> > Even if the current chandef width is equal to the station's max-BW, it
> > doesn't mean it's a valid width for TDLS. Make sure to always check
> > regulatory constraints in these cases.
>
> I'm not sure this change is the trigger for this issue, but since I
> noticed this for the first time today and this commit went just in into
> wireless-testing.git, it sounds quite likely that this was indeed behind
> the busy loop I saw here:
>
> > diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
> > @@ -332,7 +332,7 @@ ieee80211_tdls_chandef_vht_upgrade(struct ieee80211_sub_if_data *sdata,
> >       /* proceed to downgrade the chandef until usable or the same */
> > -     while (uc.width > max_width &&
> > +     while (uc.width > max_width ||
> >              !cfg80211_reg_can_beacon_relax(sdata->local->hw.wiphy, &uc,
> >                                             sdata->wdev.iftype))
> >               ieee80211_chandef_downgrade(&uc);

Good catch :)
We actually just noticed this as well and have a suggested fix already
- basically the code was trying to *upgrade* a 80p80 channel to a 80
one.

I guess it will be out in a couple days after some internal testing.

Arik
