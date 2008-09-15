Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51063 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbYIOSEs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 14:04:48 -0400
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221501417.4511.49.camel@localhost> (sfid-20080915_195731_733752_74D2117C)
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <200809151911.32834.IvDoorn@gmail.com> <1221501417.4511.49.camel@localhost>
	 (sfid-20080915_195731_733752_74D2117C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-R6cjaWHimPsCXTbIF4ta"
Date: Mon, 15 Sep 2008 20:03:06 +0200
Message-Id: <1221501786.3700.68.camel@johannes.berg> (sfid-20080915_200452_054671_5A0D6DEC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-R6cjaWHimPsCXTbIF4ta
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-15 at 19:56 +0200, Mattias Nissler wrote:
> [ I've added Johannes to the CC, I hope he can provide us with some more
> informed comments regarding mac80211 architecture ]

I'd actually written half a reply but then decided to give up on it for
now, what do you want to know?

we currently use status reporting for three things:
 * hostapd needs to know whether some frames were acked
 * the rate control algorithms use it
 * we only report sent frames on monitor interfaces when we get a status
   report and incorporate information from the status report


> I've also spent some time thinking about this. IMHO, he difficult part
> is to come up with an interface between mac80211 and the driver which is
> convenient to use for driver writers and integrates well with mac80211.
> The following ideas came to my mind:
>=20
> 1. Add another callback to struct ieee80211_ops that would be used for
> TX frame housekeeping. The standard implementation would just pass the
> frame on the regular tx handler, but we could provide an alternate
> implementation that keeps track of the packets we are expecting ACKs for
> before handing the packet to the hardware. Similarly, the RX path would
> provide new functions in addition to the existing ieee80211_rx[_irqsafe]
> handlers that would do the matching ACK matching and pass the packet on
> to ieee80211_rx() afterwards.

That seems way too much overhead, but we definitely want to use the
IEEE80211_TX_CTL_REQ_TX_STATUS less in the future (we currently always
set it). I suppose by "expect ACKs for" you mean "expect status
information for"?

> 2. Make the ACK queue approach generic and wrap it in some library
> functions that become part of mac80211 and are called from the driver's
> tx and rx handlers, respectively. This has the advantage that it is less
> invasive than 1. It is essentially what Ivo has described above. Driver
> writers would be free to use this framework, but are not required to do
> so.

I think this is what we want.

> 3. Make mac80211 unconditionally keep track about the packets it has
> passed down to the driver and do TX status matching on all ACKs that are
> received in the mac80211 rx path. (Note that this has the tendency of
> duplicating the ring buffers that most drivers probably already have for
> their TX queues. Maybe introduce a generic ring buffer framework and
> allow the drivers to store private data in data and that?) The advantage
> of this approach is that mac80211 has information about all packets that
> are still in processing (don't know if that actually helps) and it's
> more convenient for driver writers.

I think this punishes hardware that can provide all information
needlessly imho. Also, with drivers that do provide the information we
don't need to process control packets at all which is good (if not
necessary) for drivers on slow busses.

> > > This doesn't use timers so a message might in theory be
> > > stuck in the queue indefinitely.
> >=20
> > Well you wouldn't need timers actually, if you have a list of packets
> > waiting to be acked you can expect the frames to be acked in the order
> > of which they were send (when using the same queue).

Yes, hence you have to keep track of things per queue.

johannes

--=-R6cjaWHimPsCXTbIF4ta
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIzqNWAAoJEKVg1VMiehFYMHkP/A3zKETNURUdKgy01LyHu4hP
UDwESBkQHUbfa2X8omql9+zf7MwGjhXoExRL1vjKTU9QAInQgcoxzx3o0tXn9wWg
pkVvEg0rfZBQ/tUkyA6nEAllkdnJNlW6PM/N91C5CjpR2bvxnJSvepBlphAqYeRY
MNkJd/drskRnQupg0Ih1zwtlkC3LTkd5jP7Ir0X/b0F40Sw+G0kBr5TCxRRVe9AN
wipQOCVp/gX7X1f0ziHoanUaza7PMCPRAuKucn2s4EnoqgjeHTUykOw07cJsPjvO
MCStbceiTohmRChIoBJvbXF6wKOUnqpUQq0FAP6yGLCpiZ2GEPCMI787WbX6NuqV
05locY/NfjKLo0bfaex8qWf2G3JQ0ULkooajJVE/TsMJfmE/zT8EIAZnO5r+Nrv1
bLFll3We8yZs1XrAPgVFZpD7Hq2NozDC21VfCyin71zvZyDgQznCLosLSBbimRq0
AqcE7zUL77DO7BdijYgROKwBDyxYsVVGP8Te90bFGPiI2HD7JgZ+k6NeYzS1OCOU
4rp2Wd+AK7azqM3QiT76bG9aWMvLtx3dDyGeQcf7zs7PvvlFbFMXvKR2SbQQRaC2
QEAp/vc6W/dPTMiIdBwgnBid3ibyF41Lpc8DxwMCfxFaOva6H6ONU9xemYkM/s4N
kFh2wDuJC1gXGvn0Y8/z
=7oqx
-----END PGP SIGNATURE-----

--=-R6cjaWHimPsCXTbIF4ta--

