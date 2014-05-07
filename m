Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:42322 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932261AbaEGJlG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 05:41:06 -0400
Message-ID: <1399455657.6800.4.camel@dubbel> (sfid-20140507_114110_995067_577FE7AF)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Date: Wed, 07 May 2014 12:40:57 +0300
In-Reply-To: <1399450061.5038.10.camel@jlt4.sipsolutions.net>
References: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com>
	 <1398849681-3606-1-git-send-email-michal.kazior@tieto.com>
	 <1399372915.4218.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk1upg7yGK-QWoz8QhMeRzLBY60Lk=eUN=iQLaF2pUhQQ@mail.gmail.com>
	 <1399385141.4218.37.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnGRtdOGfJ78EG43cmND2bD9m3WyvmSKx92uBFnKenPkw@mail.gmail.com>
	 (sfid-20140507_080520_858946_318E5B7B) <1399450061.5038.10.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 10:07 +0200, Johannes Berg wrote:
> On Wed, 2014-05-07 at 08:05 +0200, Michal Kazior wrote:
> 
> > Hmm... Now that I think about the atomic swap - it actually becomes a
> > little bit of an issue in some cases.
> > 
> > For one you might need to overcommit number of chanctx since swapping
> > requires both chanctx (old and new) to exist but that's the least of
> > the eproblem. If you have more than one interface you end up with
> > temporarily breaking interface combinations from driver point of view
> > while switching (first swap breaks it, last swap fixes it). Driver
> > won't know whether given swap is first/last unless we somehow pass it
> > through the switch_vif_chanctx(). IOW we actually need a "chanctx
> > transaction" (sort of a start-stop) that can batch up a couple of
> > chanctx switches for different vifs as an atomic op.
> 
> Hmmm. Don't you already have that problem? Or you don't because you'd do
> 
> for_each_affected_vif: unassign
> del chanctx [optional depending on reservation]
> add chanctx [ditto]
> for_each_affected_vif: assign
> 
> right now?
> 
> I suppose a sort of transaction API, if designed the right way, would
> also work somehow - Luca?

Yeah, I think this is a good idea.  If we have an atomic transaction API
towards the driver, we can solve the problems of switching several vifs
at once.

--
Luca.

