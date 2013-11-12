Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:50605 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab3KLLNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 06:13:41 -0500
Date: Tue, 12 Nov 2013 12:13:10 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Daniel Borkmann <dborkman@redhat.com>, davem@davemloft.net,
	shemminger@networkplumber.org, fweimer@redhat.com,
	netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next 3/6] random32: add prandom_reseed_late() and
 call when nonblocking pool becomes initialized
Message-ID: <20131112111310.GA22775@magnum.frso.rivierawaves.com> (sfid-20131112_121349_699145_49D051B5)
References: <cover.1384160397.git.dborkman@redhat.com>
 <2ea03f60bb65429cbe5d74a6d356fde3eefcf06c.1384160397.git.dborkman@redhat.com>
 <20131111134357.GC10104@thunk.org>
 <20131112000307.GB14929@order.stressinduktion.org>
 <20131112003709.GA11824@gobelin>
 <1384245375.14301.1.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1384245375.14301.1.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 12, 2013 at 09:36:15AM +0100, Johannes Berg wrote:
> On Tue, 2013-11-12 at 01:37 +0100, Karl Beldan wrote:
> 
> > > > 1)  I'm pretty sure, but it would be good to get netdev confirmation,
> > > > that the call to get_random_bytes() in
> > > > net/mac80211/rc80211_minstrel.c's init_sample_table() can be replaced
> > > > by calls to prandom_u32().
> > > 
> > > Would make sense. I added wireless-devel to confirm.
> > > 
> > > [...]
> > > [    0.673260] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> > > [    0.674024] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> > > [    0.675012] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> > > [    0.676032] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> > > [    0.677020] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> > > [    0.678011] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> > > [    0.679011] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> > > [...]
> > > 
> > > In total 80 calls to get_random_bytes.
> > > 
> > 
> > It is already 8 times what rc80211_minstrel_ht_init uses.
> > If you could apply on top of:
> > http://marc.info/?l=linux-wireless&m=138392850030987&w=2
> > although Johannes has not yet agreed/applied this.
> 
> I'll take the patch, I just wanted a more useful commit log :)
> 
The commit log still feels very right to me, but I don't want you to go
grumpy ;) and will reword the log - Hannes, have you staged replacing
get_random_bytes with prandom_u32 already or can I do it in a reworded
v2 for minstrel ?

> I guess if really needed I'll write that myself :(
> 
> Anyway, I can't comment on prandom_u32(), but it doesn't really have to
> be all that random here, it's just sample tables for what order to try
> things in. Technically that could even be static with some per-device
> pertubation, I guess?
> 
The LFSR is way enough for minstrel, as for moving from prandom to
handcrafted sample table, this will be another discussion I guess.
 
Karl
