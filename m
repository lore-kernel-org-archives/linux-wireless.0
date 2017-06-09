Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59624 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751621AbdFIUBX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 16:01:23 -0400
Message-ID: <1497038480.12088.6.camel@sipsolutions.net> (sfid-20170609_220125_834262_A5CFB964)
Subject: Re: Question on setting key right after the EAPOL 4/4 is sent.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        Denis Kenzior <denkenz@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
Date: Fri, 09 Jun 2017 22:01:20 +0200
In-Reply-To: <de7611e7-c34d-26e2-4083-b7e01b657426@candelatech.com>
References: <4982156c-5325-8021-dcd3-f13e02c63c72@candelatech.com>
         <11de85e9-6028-e2f8-376b-3188ff1b95a5@gmail.com>
         <2cfd1160-f9b4-5f04-e20f-8d7f9be54f95@candelatech.com>
         <a0e8bd3f-ac25-9619-3f83-1b1debb36a4f@gmail.com>
         <1496993334.2424.1.camel@sipsolutions.net>
         <de7611e7-c34d-26e2-4083-b7e01b657426@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-06-09 at 06:46 -0700, Ben Greear wrote:

> > However, the solution is far simpler! Once you have nl80211 PAE
> > transport, you can easily even set the key before transmitting the
> > packet and simply indicate that this particular packet should _not_
> > be encrypted regardless of key presence.
> 
> My ath10k firmware cannot deal with a case like this:
> 
> pkt is enqueued before key is set
> key is set
> pkt is transmitted (incorrectly)
> 
> This is because of how the tid's header-length variables are set up
> and modified when the keys are set, and I don't see any good way to
> fix this.

That seems awful, and anyway will not work with the mentioned non-IEEE
protocols that require not encrypting the rekeying frames even when
keys have been set up.

I don't know what to tell you here, I think it'd be best if you fix
that. 

> Stock ath10k firmware goes to great lengths to parse EAPOL frames and
> try to work around it in that manner, but that breaks .11r (or used
> to, I haven't tried stock firmware lately) and adds more complexity
> to the code.

It just has to be a single flag saying "don't encrypt this frame" -
nothing super complicated about that?

In ath10k it looks like HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT gets set for
this, seems easy enough?

>  From a patch someone sent to hostapd list last night, it seems we
> could get the tx-status for the EAPOL 4/4, and in that case, we
> *know* the pkt has been transmitted, so we can then set the key
> safely it would seem?

I think so, and I don't remember why we dismissed this solution. Could
be that we just decided solving the bridging issue at the same time,
while not introducing more latency, was better.

Also, the other way can possibly solve some PTK rekeying issues, so
overall the solution to go all the way seems better.

johannes
