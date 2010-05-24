Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:45340 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754567Ab0EXAqG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 May 2010 20:46:06 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0837301960
	for <linux-wireless@vger.kernel.org>; Mon, 24 May 2010 09:46:02 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath5k-devel] [PATCH v2 13/20] cfg80211: Add nl80211 antenna configuration
Date: Mon, 24 May 2010 09:45:31 +0900
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	David Quan <David.Quan@atheros.com>,
	Sam Ng <Sam.Ng@atheros.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
References: <20100519012528.22206.77550.stgit@tt-desk> <201005211059.34081.br1@einfach.org> <20100521171102.GA27736@tux>
In-Reply-To: <20100521171102.GA27736@tux>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201005240945.31550.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 22 May 2010 02:11:02 Luis R. Rodriguez wrote:
> > > For legacy, keep it simple, use 3 settings, fixed_a, fixed_b,
> > > diversity, for all devices.
> > 
> > did you not understand my examples why i think it makes sense to use a
> > bitmask for "legacy"? i think they are perfectly valid use-cases. do i
> > need to re- iterate them a third time?
> 
> Hehe, well from what I gather is that you indicate some other legacy cards
> would have a very different setup than the typical two anntennas and
> diversity modes. I see those cases as being reallllllly rare and not
> worth considering. Did I miss anything, if so please smack me.

sorry, gotta smack you ;)

i'm talking about cards with 2 antennas (but still believe it's good to keep 
the API flexible enough to be able to handle more antennas). i agree that 
these setups are rare, but i think we should support them because it's easily 
possible. why limit possibilities? also please note that it's perfectly 
feasible to suport these modes with ath5k as well (it's just not implemented 
yet):

* case 1: send on antenna 1, receive on antenna 2: why would you want to do 
this? to have a low gain antenna for TX in order to keep within the regulatory 
constraints and a high gain antenna for RX in order to receive weaker signals. 
this means "speak softly, but listen harder". it can be useful especially for 
outdoor links.

that would translate to a RX antenna bitmap of 0b01 and TX antenna 0b10.

* case 2: is the same like above, but using RX diversity on both antennas.

that would be RX antenna 0, give that we use "0" for diversity, and TX antenna 
1.

* case 3: are special setups in research and development where people might 
have more than 2 antennas or might want to do things which don't apparently 
make much sense for normal operation. while this does not have a high 
priority, i think it's good to have an API which can support a wide variety of 
configurations.

> True, but note how the fact that you transmit over two antennas actually
> has regulatory implications. Now, ath9k handles this within ath9k_hw
> already but this itself seems like a worthy reason for this API to be
> separated. While I think it is great for ath9k_hw to do this, wouldn't it
> be nice if we can eventually instead expose the gain by using different
> chains at the same time and do the regulatory calculation for all devices
> within cfg80211?

yes, that would be good. i think we can add that in addition to the antenna 
API i suggested.

> Right, and while that *works*, I think it would be clearer to just use a
> clear "diveristy" knob.

yes i agree. so we could use the special value of "0" to indicate diversity, 
because it does not make sense to transmit on zero antennas - or create a flag 
for "use diversity".

> > most of the other things you mention (need a reset/reassociate,
> > regulatory concerns...) are driver implementation issues, which can be
> > dealt with in the driver.
> 
> Well so some of these things *could* be handled in mac80211 as well. For
> example, we may want to just dissociate upon a tx/rx chain setting change
> for all devices, but not for legacy. The regulatory stuff is another thing
> which could eventually be made more generic accross the board.

i see no reason why this could not be done with the bitmap API i suggested, or 
additionally to it.

bruno
