Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48767 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaEGIH7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 04:07:59 -0400
Message-ID: <1399450061.5038.10.camel@jlt4.sipsolutions.net> (sfid-20140507_100819_772616_5C298C34)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>,
	Simon Wunderlich <sw@simonwunderlich.de>
Date: Wed, 07 May 2014 10:07:41 +0200
In-Reply-To: <CA+BoTQnGRtdOGfJ78EG43cmND2bD9m3WyvmSKx92uBFnKenPkw@mail.gmail.com> (sfid-20140507_080520_858946_318E5B7B)
References: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com>
	 <1398849681-3606-1-git-send-email-michal.kazior@tieto.com>
	 <1399372915.4218.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk1upg7yGK-QWoz8QhMeRzLBY60Lk=eUN=iQLaF2pUhQQ@mail.gmail.com>
	 <1399385141.4218.37.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnGRtdOGfJ78EG43cmND2bD9m3WyvmSKx92uBFnKenPkw@mail.gmail.com>
	 (sfid-20140507_080520_858946_318E5B7B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 08:05 +0200, Michal Kazior wrote:

> Hmm... Now that I think about the atomic swap - it actually becomes a
> little bit of an issue in some cases.
> 
> For one you might need to overcommit number of chanctx since swapping
> requires both chanctx (old and new) to exist but that's the least of
> the eproblem. If you have more than one interface you end up with
> temporarily breaking interface combinations from driver point of view
> while switching (first swap breaks it, last swap fixes it). Driver
> won't know whether given swap is first/last unless we somehow pass it
> through the switch_vif_chanctx(). IOW we actually need a "chanctx
> transaction" (sort of a start-stop) that can batch up a couple of
> chanctx switches for different vifs as an atomic op.

Hmmm. Don't you already have that problem? Or you don't because you'd do

for_each_affected_vif: unassign
del chanctx [optional depending on reservation]
add chanctx [ditto]
for_each_affected_vif: assign

right now?

I suppose a sort of transaction API, if designed the right way, would
also work somehow - Luca?

johannes

