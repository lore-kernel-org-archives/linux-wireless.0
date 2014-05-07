Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:42329 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932261AbaEGJl2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 05:41:28 -0400
Message-ID: <1399455679.6800.5.camel@dubbel> (sfid-20140507_114131_898139_78F094F8)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Date: Wed, 07 May 2014 12:41:19 +0300
In-Reply-To: <CA+BoTQkuHOXS92WOtNfRAu01n66CTpOdwTVNHHoa7=SfaFE=-g@mail.gmail.com>
References: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com>
	 <1398849681-3606-1-git-send-email-michal.kazior@tieto.com>
	 <1399372915.4218.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk1upg7yGK-QWoz8QhMeRzLBY60Lk=eUN=iQLaF2pUhQQ@mail.gmail.com>
	 <1399385141.4218.37.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnGRtdOGfJ78EG43cmND2bD9m3WyvmSKx92uBFnKenPkw@mail.gmail.com>
	 <1399450061.5038.10.camel@jlt4.sipsolutions.net>
	 <CA+BoTQkuHOXS92WOtNfRAu01n66CTpOdwTVNHHoa7=SfaFE=-g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 10:51 +0200, Michal Kazior wrote:
> On 7 May 2014 10:07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2014-05-07 at 08:05 +0200, Michal Kazior wrote:
> >
> >> Hmm... Now that I think about the atomic swap - it actually becomes a
> >> little bit of an issue in some cases.
> >>
> >> For one you might need to overcommit number of chanctx since swapping
> >> requires both chanctx (old and new) to exist but that's the least of
> >> the eproblem. If you have more than one interface you end up with
> >> temporarily breaking interface combinations from driver point of view
> >> while switching (first swap breaks it, last swap fixes it). Driver
> >> won't know whether given swap is first/last unless we somehow pass it
> >> through the switch_vif_chanctx(). IOW we actually need a "chanctx
> >> transaction" (sort of a start-stop) that can batch up a couple of
> >> chanctx switches for different vifs as an atomic op.
> >
> > Hmmm. Don't you already have that problem? Or you don't because you'd do
> >
> > for_each_affected_vif: unassign
> > del chanctx [optional depending on reservation]
> > add chanctx [ditto]
> > for_each_affected_vif: assign
> >
> > right now?
> 
> Correct - this is how my patch deals with this problem. This was also
> the reason why I split the new_chanctx() into alloc_chanctx() and
> add_chanctx().

Right, I had forgotten the overcommit thing...

--
Luca.

