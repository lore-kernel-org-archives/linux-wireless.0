Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45188 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932209AbeGCOcX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 10:32:23 -0400
Message-ID: <1530628340.4735.29.camel@sipsolutions.net> (sfid-20180703_163227_516004_57451097)
Subject: Re: [PATCH] mac80211: don't put null-data frames on the normal TXQ
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Date: Tue, 03 Jul 2018 16:32:20 +0200
In-Reply-To: <87601wfl1u.fsf@toke.dk>
References: <20180703124725.30917-1-johannes@sipsolutions.net>
         <87601wfl1u.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-07-03 at 16:31 +0200, Toke Høiland-Jørgensen wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Since (QoS) NDP frames shouldn't be put into aggregation nor are
> > assigned real sequence numbers, etc. it's better to treat them as
> > non-data packets and not put them on the normal TXQs, for example
> > when building A-MPDUs they need to be treated specially, and they
> > are more used for management (e.g. to see if the station is alive)
> > anyway.
> 
> No objections to this per se;

:-)

> but didn't we want to move towards
> everything going through the TXQs? Any progress on that front? :)

Not really. Yes, I wanted to, but it's some massive surgery. Right now
I'm working on converting iwlwifi, perhaps I'll learn about it more and
can then do the mac80211 surgery better later.

johannes
