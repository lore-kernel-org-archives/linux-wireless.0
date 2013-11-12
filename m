Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39413 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3KLIg3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 03:36:29 -0500
Message-ID: <1384245375.14301.1.camel@jlt4.sipsolutions.net> (sfid-20131112_093634_622558_B0822BC0)
Subject: Re: [PATCH net-next 3/6] random32: add prandom_reseed_late() and
 call when nonblocking pool becomes initialized
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Daniel Borkmann <dborkman@redhat.com>, davem@davemloft.net,
	shemminger@networkplumber.org, fweimer@redhat.com,
	netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 12 Nov 2013 09:36:15 +0100
In-Reply-To: <20131112003709.GA11824@gobelin> (sfid-20131112_013733_866376_8AB7C8FE)
References: <cover.1384160397.git.dborkman@redhat.com>
	 <2ea03f60bb65429cbe5d74a6d356fde3eefcf06c.1384160397.git.dborkman@redhat.com>
	 <20131111134357.GC10104@thunk.org>
	 <20131112000307.GB14929@order.stressinduktion.org>
	 <20131112003709.GA11824@gobelin> (sfid-20131112_013733_866376_8AB7C8FE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-12 at 01:37 +0100, Karl Beldan wrote:

> > > 1)  I'm pretty sure, but it would be good to get netdev confirmation,
> > > that the call to get_random_bytes() in
> > > net/mac80211/rc80211_minstrel.c's init_sample_table() can be replaced
> > > by calls to prandom_u32().
> > 
> > Would make sense. I added wireless-devel to confirm.
> > 
> > [...]
> > [    0.673260] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> > [    0.674024] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> > [    0.675012] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> > [    0.676032] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> > [    0.677020] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> > [    0.678011] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> > [    0.679011] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> > [...]
> > 
> > In total 80 calls to get_random_bytes.
> > 
> 
> It is already 8 times what rc80211_minstrel_ht_init uses.
> If you could apply on top of:
> http://marc.info/?l=linux-wireless&m=138392850030987&w=2
> although Johannes has not yet agreed/applied this.

I'll take the patch, I just wanted a more useful commit log :)

I guess if really needed I'll write that myself :(

Anyway, I can't comment on prandom_u32(), but it doesn't really have to
be all that random here, it's just sample tables for what order to try
things in. Technically that could even be static with some per-device
pertubation, I guess?

johannes

