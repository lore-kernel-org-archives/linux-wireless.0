Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51899 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3KLAh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 19:37:28 -0500
Date: Tue, 12 Nov 2013 01:37:09 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Daniel Borkmann <dborkman@redhat.com>, davem@davemloft.net,
	shemminger@networkplumber.org, fweimer@redhat.com,
	netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next 3/6] random32: add prandom_reseed_late() and
 call when nonblocking pool becomes initialized
Message-ID: <20131112003709.GA11824@gobelin> (sfid-20131112_013733_866376_8AB7C8FE)
References: <cover.1384160397.git.dborkman@redhat.com>
 <2ea03f60bb65429cbe5d74a6d356fde3eefcf06c.1384160397.git.dborkman@redhat.com>
 <20131111134357.GC10104@thunk.org>
 <20131112000307.GB14929@order.stressinduktion.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20131112000307.GB14929@order.stressinduktion.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 12, 2013 at 01:03:07AM +0100, Hannes Frederic Sowa wrote:
> On Mon, Nov 11, 2013 at 08:43:57AM -0500, Theodore Ts'o wrote:
> > On Mon, Nov 11, 2013 at 12:20:34PM +0100, Daniel Borkmann wrote:
> > > From: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > > 
> > > The Tausworthe PRNG is initialized at late_initcall time. At that time the
> > > entropy pool serving get_random_bytes is not filled sufficiently. This
> > > patch adds an additional reseeding step as soon as the nonblocking pool
> > > gets marked as initialized.
> > > 
> > > On some machines it might be possible that late_initcall gets called after
> > > the pool has been initialized. In this situation we won't reseed again.
> > > 
> > > (A call to prandom_seed_late blocks later invocations of early reseed
> > > attempts.)
> > > 
> > > Joint work with Daniel Borkmann.
> > 
> > Acked-by: "Theodore Ts'o" <tytso@mit.edu>
> > 
> > I wasn't cc'ed on the full series (I didn't see the 0/3 or the 4/6
> > messages) but there are two other things that you might want to
> > consider.
> > 
> > 1)  I'm pretty sure, but it would be good to get netdev confirmation,
> > that the call to get_random_bytes() in
> > net/mac80211/rc80211_minstrel.c's init_sample_table() can be replaced
> > by calls to prandom_u32().
> 
> Would make sense. I added wireless-devel to confirm.
> 
> [...]
> [    0.673260] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> [    0.674024] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> [    0.675012] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> [    0.676032] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> [    0.677020] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> [    0.678011] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> [    0.679011] random: rc80211_minstrel_ht_init+0x47/0xaa get_random_bytes called with 3 bits of entropy available
> [...]
> 
> In total 80 calls to get_random_bytes.
> 

It is already 8 times what rc80211_minstrel_ht_init uses.
If you could apply on top of:
http://marc.info/?l=linux-wireless&m=138392850030987&w=2
although Johannes has not yet agreed/applied this.

 
Karl
