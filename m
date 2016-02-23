Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60641 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbcBWNFe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 08:05:34 -0500
Message-ID: <1456232731.9910.4.camel@sipsolutions.net> (sfid-20160223_140537_074868_5BB59917)
Subject: Re: [PATCH 1/2] mac80211: add A-MSDU tx support
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Cc: egrumbach@gmail.com
Date: Tue, 23 Feb 2016 14:05:31 +0100
In-Reply-To: <56CC4CAC.4080501@openwrt.org>
References: <1455820762-22876-1-git-send-email-nbd@openwrt.org>
	 <1456226757.2041.35.camel@sipsolutions.net> <56CC4CAC.4080501@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-23 at 13:12 +0100, Felix Fietkau wrote:
> 
> It's initialized to 0 by default, in which case it does not limit the
> A-MSDU size. The driver does not need to set it, but it really
> should.

Right, but this is problematic as Emmanuel had pointed out, when
scaling down you run into problems. Not sure we want that as the
default when the driver doesn't do anything?

Documenting it as we discussed should be good enough though I guess.

> > Apart from that, I'm not sure that having a field here that works
> > like
> > this is a good idea at all - all the other fields in the vicinity
> > kinda
> > go from mac80211 to the driver, where here you have something that
> > potentially goes from the driver to mac80211. Perhaps we can find a
> > better way of doing this?
> Didn't find a better place to put it. Got any ideas?

Not off the top of my head, sorry.

> > > + * @max_tx_fragments: maximum fragments per (A-)MSDU.
> > 
> > "fragments" is a bit unclear - I guess this should refer to
> > fraglist
> > length only? Or is it meant to apply as a limit to the sum of
> > pieces in
> > the fraglist? I think that should be clarified.
> Sum of 1 (head) + n_frags for each skb in the fraglist.

Clarify the comment? :)

> Yes. If A-MSDU in A-MPDU is not supported, dealing with starting and
> stopping of A-MPDU sessions leaves all kinds of nasty corner cases
> (since the txq is not flushed between sessions). In that case it's
> better to just leave it disabled from that point on.

Fair enough. You should be able to deal with it with the SSN, but that
might be difficult.

Actually, mac80211 on its own assigns the seqno so frames already on
the txq would not become part of the session, so we should be OK
without much effort?

> Yes. I'm relying on fast_tx fields to simplify dealing with headers
> and to avoid adding extra checks for all kinds of stuff like no
> software crypto, which ieee80211_check_fast_xmit already handles.
> 

Ok, makes sense.

johannes
