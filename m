Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:41423 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727575AbeGSOcB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 10:32:01 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        Jean-Pierre TOSONI <jp.tosoni@acksys.fr>,
        Ben Greear <greearb@candelatech.com>,
        SEDE <s.deronne@televic.com>,
        ath10k <ath10k@lists.infradead.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Setting tx retry count in ath10k
In-Reply-To: <c594f50b-a318-fbe2-847b-b76726eb1472@uni-rostock.de>
References: <b0f67dd7-dea9-508e-7ad9-f6db3ac88b90@candelatech.com> <e9b42b3d-2d03-ca69-5532-fbae08fdec5d@uni-rostock.de> <8b9713fe-7573-f009-d002-13df73315898@televic.com> <9dd76e58-b514-26f2-2fe9-0c9a7f798054@candelatech.com> <AM4PR0101MB2305917B39A84BBE13FDFAD1E4530@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com> <ea2ff457-e84e-8395-148d-8d90a749a40d@candelatech.com> <877els5xax.fsf@toke.dk> <AM4PR0101MB230575D91CEE21630A723466E4530@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com> <c594f50b-a318-fbe2-847b-b76726eb1472@uni-rostock.de>
Date: Thu, 19 Jul 2018 15:48:31 +0200
Message-ID: <87zhyn2v68.fsf@toke.dk> (sfid-20180719_154849_048458_B3F28632)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Benjamin Beichler <Benjamin.Beichler@uni-rostock.de> writes:

>>> For general internet traffic, a retry count of 30 is way too high; that
>>> is up to 120 ms of HOL blocking latency. Better to just drop the packet
>>> at that point.
>>>
>>> Ideally, the retry count should be dynamically calculated in units of
>>> time (which would depend on the rate and aggregate size), and also take
>>> queueing time into account. I've been meaning to experiment with this
>>> for minstrel and ath9k, but haven't gotten around to it...
> We have running current research on this topic but focused on the
> effects in 802.11s mesh networks. With multiple(forwarding) wireless
> links, the retry limit have a bigger impact as only in managed mode
> setups, since every forwarding step is doing repeated transmissions.
> But I also totally agree, that the retry count needs to be considered
> in the bufferbloat/airtime queuing stuff, which Toke proposed.

Ah, cool. Looking forward to seeing your results. And yeah, it's
probably even worse in meshes...

> Nonetheless, since this ambiguities are known, wouldn't it be nice to
> clean up all this patches to enable at least ath9k and ath10k to do
> the right thing, or do anybody can tell why they weren't included the
> first time ?

No objection from me, certainly! :)

-Toke
