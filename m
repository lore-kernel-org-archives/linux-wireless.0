Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:37408 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751889Ab0ELBjj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 21:39:39 -0400
Received: from vs3006.wh2.ocn.ne.jp (125.206.180.169)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0724738373
	for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 10:39:35 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [RFC PATCH 1/2] mac80211: Add nl80211 antenna configuration
Date: Wed, 12 May 2010 10:39:32 +0900
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, holgerschurig@gmail.com
References: <20100511083121.28289.96180.stgit@tt-desk> <20100511083900.28289.43864.stgit@tt-desk> <AANLkTilowwAyqLrIJ0_mlZxnqY-TqSHM3xdXkbO8aH6-@mail.gmail.com>
In-Reply-To: <AANLkTilowwAyqLrIJ0_mlZxnqY-TqSHM3xdXkbO8aH6-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201005121039.32882.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 May 2010 03:14:30 Luis R. Rodriguez wrote:
> Subject should be for cfg80211, not mac80211. In fact can you submit
> the mac80211 stuff in a separate secondary patch? Some more comments
> below.

ok.

> I think we should call this TX / RX chainmask given that with 802.11n
> hardware this is what this is called.

from the following discussion, i'll stick with antenna...

> > The antenna configuration is defined as a bitmap of allowed antennas.
> > This bitmap is 8 bit at the moment, each bit representing one antenna.
> 
> If you use chainmask for this instead of 'antenna configuration' the
> wording would be something like:
> 
> The chainmask is defined as a bitmap of chain configurations used for
> TX/RX. The bitmap allows for configuring up to up to 4 chains for both TX
> and RX, 4 bits for each TX chain, 4 bits for each RX chain.

actually we have 8 bit for TX and 8 bit for RX.
 
> > If multiple
> > antennas are selected, the driver may use diversity for receive and
> > transmit.
> 
> For 802.11n this is called "selection diversity" but typically just
> referred to as "diversity", for legacy this is called "antenna
> diversity". It may be good to elaborate how selection diversity or
> antenna diversity might be enabled, ie, will this be another command,
> or what. I think for legacy another command makes sense, and it may be
> possible for us to use the same command for enabling selection
> diversity, I am not sure if we can fine tune the diversity algorithm
> at this time, I will have to review this and get back to you.

my idea was that if multiple antennas are selected in the bitmap this means 
that "antenna diversity" will be enabled. for RX this is clear. for TX this is 
a bit ambigous: it could mean "send on both antennas", which i believe is 
impossible on legacy hardware, so it means "let HW diversity choose TX 
antenna". for 802.11n - i think the TX part is different, because multiple TX 
chains will mean "send on multiple antennas". but otherwise can't we think of 
it as some form of advanced antenna diversity?

of course there are more possibillities of antenna configurations which cannot 
be configured with this api - like the "multiple sector antennas + RTS/CTS on 
omni" configuration of ath5k, but i don't think these are very common. 

the most important use case, imho, is to limit the antennas to one fixed 
antenna, if we know only one antenna is connected. this might well apply for 
802.11n too, no?

bruno
