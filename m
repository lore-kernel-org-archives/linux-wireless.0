Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56212 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab1KJOkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 09:40:02 -0500
MIME-Version: 1.0
In-Reply-To: <1320933501.3967.68.camel@jlt3.sipsolutions.net>
References: <1320933501.3967.68.camel@jlt3.sipsolutions.net>
Date: Thu, 10 Nov 2011 15:40:01 +0100
Message-ID: <CAGXE3d-_RFgW_zwfX2vTBe1psXmgoBFO5pd5cAgtYo=Jwpddhw@mail.gmail.com> (sfid-20111110_154010_358765_E2870511)
Subject: Re: creating netdev queues on the fly?
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Nov 10, 2011 at 2:58 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> But on wireless we really transmit to slow stations only with a slow
> speed, so our outgoing speed differs. I think the scenario is quite
> different, also because the speed can vary obviously.
>
> So to get to my question: What if we could create netdev queues on the
> fly?
>
> The reason to do that is that we really don't want to reserve some 8000
> queues just because somebody could possibly try to create 2000
> connections (2007 is the theoretical max due to protocol restrictions)
> to the AP interface. We also don't really want to create a netdev for
> each peer (though you could implement it that way today).
>
> I looked at this and it doesn't seem terrible. Creating & destroying the
> queues might be tricky though. I think ndo_select_queue might return the
> queue pointer instead of an index, and then that queue could be used.
> The normal queues would still be in an array, with maybe a linked list
> of extra queues that were dynamically created. Obviously the driver
> would have to be able to manage that.
>
> Ultimately, all the frames will of course end up on the same four
> hardware queues again. But this would some better management, and piled
> up traffic to one station that suddenly dies wouldn't impact performance
> for all others as badly as it does today since we wouldn't let all those
> frames pile up on the hardware queues, they'd only get there with some
> mechanism that might take airtime into account.
>
> I think this might also make implementing reservation (tspec) easier.
> Not sure if anyone wants/needs that though.

Wouldn't it be possible to implement something like this as a qdisc on top of
mq that makes use of the current tx rate per station to distribute the airtime
equitably?

Of course this would require the qdisc to know the tx rate a priori but for
mac80211 drivers we could just use last_tx_rate as an estimate ...

Helmut
