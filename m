Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59490 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758572Ab0EURLF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 May 2010 13:11:05 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 21 May 2010 10:11:04 -0700
Date: Fri, 21 May 2010 10:11:02 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bruno Randolf <br1@einfach.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	David Quan <David.Quan@Atheros.com>,
	Sam Ng <Sam.Ng@Atheros.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH v2 13/20] cfg80211: Add nl80211 antenna
 configuration
Message-ID: <20100521171102.GA27736@tux>
References: <20100519012528.22206.77550.stgit@tt-desk>
 <AANLkTilk0CIkmmIsBzPwchd6EBIVavw9R1amiSgCZOrx@mail.gmail.com>
 <AANLkTinPVSkrawZ4OCjp6vb-f4bA7nSrmnXjRDi-Pvvm@mail.gmail.com>
 <201005211059.34081.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201005211059.34081.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 20, 2010 at 06:59:33PM -0700, Bruno Randolf wrote:
> On Friday 21 May 2010 07:05:48 Luis R. Rodriguez wrote:
> > For legacy, keep it simple, use 3 settings, fixed_a, fixed_b,
> > diversity, for all devices.
> 
> did you not understand my examples why i think it makes sense to use a bitmask 
> for "legacy"? i think they are perfectly valid use-cases. do i need to re-
> iterate them a third time?

Hehe, well from what I gather is that you indicate some other legacy cards
would have a very different setup than the typical two anntennas and
diversity modes. I see those cases as being reallllllly rare and not
worth considering. Did I miss anything, if so please smack me.

> > Lets use a different API for 802.11n. Reason being that even the case
> > I mentioned of an 802.11n device connecting on a legacy network needs
> > to be treated differently actually.
> > 
> > For 802.11n you have a few more considerations. You can actually TX at
> > the same time on two or more different antennas at the same time. The
> > data you transmit will be the contents on both chains on a dual stream
> > device. So both antenna 0 and antenna 1 will both be transmitting the
> > data for both stream 0 and stream 1. As it turns out the combination
> > of TX'ing on two antennas at the same time at a certain dBm power will
> > yield a higher received frame on the RX side. This is why when you use
> > multiple chains you have to take regulatory rules into considerations
> > as well, since adding more chains will increase the overall output
> > power. Today ath9k handles this itself since this data is calibrated
> > but the max EIRP is passed out from cfg80211. Devices which do not
> > deal with these regulatory considerations likely won't support
> > changing chainmasks unless they use an API to respect regulatory
> > internally somehow. Perhaps the iwlagn firmware does this, beats me.
> > 
> > The right terminology for antenna control for both TX and RX is
> > chainmask and a bitmap of 8 will suffice for existing hardware and up
> > to the not-yet-existant 600mbps 4 stream devices. Supporting 8 bits
> > will support up to 8 streams and we do not envision using beyond that
> > at this point. There is some considerations in the future for
> > supporting something other than HT40, like maybe HT80 and so forth but
> > those things won't be using more streams it seems.
> > 
> > Then, some devices won't support all possible chainmask settings. This
> > will vary depending on the chipset. I work for Atheros so I can only
> > tell you what we can support, we'll have to check with the Intel folks
> > about their chipset limitations and settings.
> > 
> > AR5416, AR5418 can only support chainmask settings which always keep
> > the first chain on. The AR9001 family and beyond cannot support the
> > 0b110 chaimask (David, you had pointed out some other restrictions,
> > what were they again?), the details are complex and I did not get a
> > chance to review them.
> > 
> > I would not be surprised if other vendors had similar restrictions so
> > I'm thinking maybe we can express this as a requirement mask, or a set
> > of requirement masks. This way userspace utilities for debugging would
> > only expose certain chainmask settings.
> > 
> > Now technically then you can incorporate the legacy API with the
> > 802.11n API here somehow but it just seems cleaner to keep them
> > separate.
> > 
> > Also, David indicated that when we change the chainmask when are are
> > associated we have to do an actual chip reset, this is different than
> > the antenna diversity settings which an be done on the fly. We likely
> > will need to reassociate for a chainmask setting, not sure.
> 
> so from my point of view this is not very different from what we can support 
> with the API i suggested. for RX it seems to be 100% equivalent.

Well I agree, the API *supports it* but I want *clean, clear and consistant
API*. And it just seems cleaner to separate the two.

> the main difference as i see it is that with 802.11n you transmit on more than 
> one antenna, while with 'legacy' we can only transmit on one antenna at a 
> time.

True, but note how the fact that you transmit over two antennas actually
has regulatory implications. Now, ath9k handles this within ath9k_hw already
but this itself seems like a worthy reason for this API to be separated.
While I think it is great for ath9k_hw to do this, wouldn't it be nice
if we can eventually instead expose the gain by using different chains
at the same time and do the regulatory calculation for all devices within
cfg80211?

> actually i have to admit that on legacy "antenna set tx 3 (b11)" (select two 
> antennas for transmit) does not make much sense. i have defined it before as 
> "use diversity" but what about a different definition: like "bitmap of 
> antennas/chains to TRANSMIT".

Right, and while that *works*, I think it would be clearer to just use a
clear "diveristy" knob.

> so for 802.11n that would allow you to select  multiple trasmit chains.

Instead of leaving the API to be interpreted by the mode of operation
I think it would be much cleaner to just make your desires clearer and
have the API define it well, and let the driver reject/accept it.

> on legacy you are only allowed to select one antenna 
> in the bitmap. if it is set to "0" (or a separate flag) this could enable 
> "follow RX antenna diversity" on legacy.

Sure that is one way, but it seems cleaner and easier for legacy purposes
to just define an API that only fits legacy.

> most of the other things you mention (need a reset/reassociate, regulatory 
> concerns...) are driver implementation issues, which can be dealt with in the 
> driver.

Well so some of these things *could* be handled in mac80211 as well. For
example, we may want to just dissociate upon a tx/rx chain setting change
for all devices, but not for legacy. The regulatory stuff is another thing
which could eventually be made more generic accross the board.

Additionally, suppose you write an iw-tweak-gui thingy, and you want to
provide expose tx/rx chainmask settings. Since some cards do not support
some chainmask settings we may want to allow for a query of unsupported
chainmasks and that way the GUI application could just grey-out the
unsupported chainmask settings instead of letting the user figure out
by trial and error that they are indeed not supported.

> i would just suggest to let the driver reject antenna/chainmask 
> configurations which it cannot support.

The unified API works, but I think we can provide a cleaner API
if we split them. What real benefit do we get if we keep them together?
I just imagine this resulting in more convoluted code.

  Luis
