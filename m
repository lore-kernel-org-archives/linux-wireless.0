Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37925 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab2B0PqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 10:46:17 -0500
Subject: Re: mac80211 queue handling in multi-channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>, Jouni Malinen <j@w1.fi>
In-Reply-To: <CAGXE3d_SNsrA-KLuPVe_TWnbaVGK3ABr_4TWbtJWU568=BgWbw@mail.gmail.com> (sfid-20120227_163842_268823_6D7AF64F)
References: <1330343374.3483.46.camel@jlt3.sipsolutions.net>
	 <CAGXE3d_SNsrA-KLuPVe_TWnbaVGK3ABr_4TWbtJWU568=BgWbw@mail.gmail.com>
	 (sfid-20120227_163842_268823_6D7AF64F)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Feb 2012 16:46:15 +0100
Message-ID: <1330357575.3483.57.camel@jlt3.sipsolutions.net> (sfid-20120227_164620_233351_1C9E1D08)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-27 at 16:38 +0100, Helmut Schaa wrote:
> On Mon, Feb 27, 2012 at 12:49 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > Then of course, the driver needs to tell mac80211 about queue mapping.
> > For this, there's one global queue:
> >  * off-channel TX queue
> > Additionally, there are per-interface queues:
> >  * 4 per AC
> >  * CAB for this interface
> 
> Ralink devices have only the 4 hw queues and no CAB queue. So, would
> each interface point to the same hw queue or would the driver have to do
> some sort of translation?

No, just like today I'd expect each interface to point to the same hw
queue. In fact, even in devices that do have more queues I would expect
multiple interfaces to point to the same hw queue, if they share
channels.

This will be somewhat tricky when an the mapping isn't static, but for
that the netdev queues can be stopped and then the reassignment is
probably not so much of a problem.

> Also Ralink devices don't have a CAB queue :)

You just said that ;-)

But in that case I suppose the CAB queue would simply point to the BE
queue or so as well. But I think they are also quite broken wrt. sending
multicast-after-DTIM anyway, no? In any case I'd then expect this to
either point to a "virtual" queue that the driver simply has in
software, or to the real BE queue, depending on the desired queue-full
semantics.

johannes

