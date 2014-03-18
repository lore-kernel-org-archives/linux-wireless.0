Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:38237 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755461AbaCROsf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:48:35 -0400
Message-ID: <1395154087.15856.45.camel@dubbel> (sfid-20140318_154838_451997_47A8A861)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"sw@simonwunderlich.de" <sw@simonwunderlich.de>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Date: Tue, 18 Mar 2014 16:48:07 +0200
In-Reply-To: <CA+BoTQkpjC+LeWfNvaNXTwTsHgWAg7-umDnq4CjWk1oBvvo+9g@mail.gmail.com>
References: <1394717621-5608-1-git-send-email-luciano.coelho@intel.com>
	 <1394717621-5608-4-git-send-email-luciano.coelho@intel.com>
	 <CA+BoTQkpjC+LeWfNvaNXTwTsHgWAg7-umDnq4CjWk1oBvvo+9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v9 3/4] mac80211: implement chanctx reservation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-03-18 at 15:10 +0100, Michal Kazior wrote:
> On 13 March 2014 14:33, Luciano Coelho <luciano.coelho@intel.com> wrote:
> 
> [...]
> 
> > +       ret = ieee80211_assign_vif_chanctx(sdata, ctx);
> > +       if (old_ctx->refcount == 0)
> > +               ieee80211_free_chanctx(local, old_ctx);
> > +       if (ret) {
> > +               /* if assign fails refcount stays the same */
> > +               if (ctx->refcount == 0)
> > +                       ieee80211_free_chanctx(local, ctx);
> > +               goto out;
> > +       }
> > +
> > +       __ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
> 
> I'm sorry I didn't notice that this earlier :-( but this should be
> guarded by if (sdata->vif.type == NL80211_IFTYPE_AP). Otherwise you
> hit WARN_ON for non-AP (e.g. STA) chanctx reservation.

Yeah, how didn't I notice that? Though this WARN_ON is unnecessary in my
opinion, because what happens now is that we have to check for the same
thing (ie. sdata->vif.type) twice.

Thanks for catching it! I'll fix.

--
Luca.

