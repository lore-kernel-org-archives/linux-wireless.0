Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43959 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbcHQUnY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2016 16:43:24 -0400
Message-ID: <1471466600.5173.21.camel@sipsolutions.net> (sfid-20160817_224339_019640_5262FDF5)
Subject: Re: [Make-wifi-fast] [PATCH v2] mac80211: Move crypto IV generation
 to after TXQ dequeue.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave Taht <dave.taht@gmail.com>
Cc: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
	make-wifi-fast@lists.bufferbloat.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Date: Wed, 17 Aug 2016 22:43:20 +0200
In-Reply-To: <CAA93jw4+WTiFAdUJkPaf5aRDy81vMW34TPQt7xSgv95tsXU=cA@mail.gmail.com> (sfid-20160817_220750_313180_B51CF7A4)
References: <20160817125800.19154-1-toke@toke.dk>
	 <20160817144531.4285-1-toke@toke.dk>
	 <1471463348.5173.16.camel@sipsolutions.net>
	 <CAA93jw4+WTiFAdUJkPaf5aRDy81vMW34TPQt7xSgv95tsXU=cA@mail.gmail.com>
	 (sfid-20160817_220750_313180_B51CF7A4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> well, we're getting there. the results of both patch attempts were
> really nice, and brought encrypted performance with fq back into line
> with unencrypted. Still running crypted tests as I write...
> 
> So fixing TKIP would be next, forcing the AP to use that? What other
> scenarios do we have to worry about? WDS?
> 

I don't think there's anything else, I just don't really feel it's
getting anywhere. This is a mere symptom of the design.

Felix had worked around the SN assignment in a similar way, but I feel
that perhaps the whole thing isn't quite the right architecture. Why
are we applying FQ after the wifi conversion, when clearly that doesn't
work well? Seems to me that it would make more sense to let the frames
sit on the queues as they come in, and do most of the wifi handling
only when needed (obviously, things like control port would still have
to be done).
We even count those packets that are dropped for TX statistics, which
would seem to be a big behavioural difference vs. applying a qdisc.

Now, it's unlikely to be that simple - fragmentation, for example,
might mess this up.

Overall though, I'm definitely wondering if it should be this way,
since all the special cases just add complexity.

johannes
