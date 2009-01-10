Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1764 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbZAJQrd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 11:47:33 -0500
Date: Sat, 10 Jan 2009 11:47:05 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [ath5k-devel] ath5k_tasklet_rx BUG_ON(bf->skb == NULL)
Message-ID: <20090110164705.GB10865@hash.localnet> (sfid-20090110_174747_276772_D078E92B)
References: <Pine.LNX.4.64.0901081318190.22793@blonde.anvils> <1231426017.922.2.camel@maxim-laptop> <Pine.LNX.4.64.0901081603410.8411@blonde.anvils> <b6c5339f0901080910x3d3b5758mae4e81411dcf1405@mail.gmail.com> <Pine.LNX.4.64.0901081740350.19523@blonde.anvils> <b6c5339f0901081041p3c9669f8ycd461b155da60f94@mail.gmail.com> <b6c5339f0901090541m1ac135bcta91bacb3f048a9ba@mail.gmail.com> <Pine.LNX.4.64.0901091400290.925@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <Pine.LNX.4.64.0901091400290.925@blonde.anvils>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 09, 2009 at 02:10:50PM +0000, Hugh Dickins wrote:
> Good, that should be a lot quicker.

Well I got a lockup doing that, I'll try again later but anyway I see
the bug already, read on if interested.  I should have a patch shortly.

ath5k_tasklet_rx creates a new skb for every packet that is handed to
the upper layers, and the buffer is moved to the end of the rxbuf list.
But ath5k_rxbuf_setup fails skb_alloc so the buffer is left in the rxbuf
list with a null skb.  Once another 40 packets are processed that buffer
comes up again and triggers the BUG_ON.  Disabling the BUG_ON is bad
because we could end up with no available buffers.

The fix would be to create a new skb when we accept a packet, and just
drop the packet if that skb creation fails.  Then swap in the new skb
after ieee80211_rx.  ath9k already does something like this.

-- 
Bob Copeland %% www.bobcopeland.com

