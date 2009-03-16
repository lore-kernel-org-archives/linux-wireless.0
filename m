Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52900 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZCPRj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 13:39:58 -0400
Subject: Re: [PATCH v2] mac80211: don't drop null frames during software
 scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Kalle Valo <kalle.valo@nokia.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090316085741.GA29986@jm.kir.nu>
References: <20090315200738.17370.29374.stgit@tikku>
	 <20090316085741.GA29986@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mt8yhGQ0dYJjPCV8kViX"
Date: Mon, 16 Mar 2009 15:00:30 +0100
Message-Id: <1237212030.16396.13.camel@johannes.local> (sfid-20090316_184002_568860_EF80E026)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mt8yhGQ0dYJjPCV8kViX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-16 at 10:57 +0200, Jouni Malinen wrote:
> On Sun, Mar 15, 2009 at 10:07:39PM +0200, Kalle Valo wrote:
> > ieee80211_tx_h_check_assoc() was dropping everything else than probe
> > requests during software scan. So the null frame with the power save
> > bit was dropped and AP never received it. This meant that AP never
> > buffered any frames for the station during software scan.
> >=20
> > Fix this by allowing to transmit both probe request and null frames
> > during software scan. Tested with stlc45xx.
>=20
> I would assume the nullfunc frames are sent only just before the scan
> and just after the scan, not really "during" the scan. Or am I missing
> something here?

Correct, but if we wanted to do this properly we'd have to iterate the
list twice and generally make the scan start code quite a bit more
complex. I don't think it's worth it, since we _should_ control quite
tightly what we're sending during scan.

> >  	if (unlikely(tx->local->sw_scanning) &&
> > -	    !ieee80211_is_probe_req(hdr->frame_control))
> > +	    !ieee80211_is_probe_req(hdr->frame_control) &&
> > +	    !ieee80211_is_nullfunc(hdr->frame_control))
> > +		/*
> > +		 * When software scanning only null frames (to notify the
> > +		 * sleep state to the AP) and probe requests (for the
> > +		 * active scan) are allowed, everything else should be
> > +		 * dropped.
> > +		 */
> >  		return TX_DROP;
>=20
> While this is probably the easiest way of fixing the issue you are
> seeing, the more correct operation would be to allow nullfunc frames
> only at the beginning and end of the scan operation, not during it,
> i.e., there is no point allowing those frames to go out when we are not
> on our operational channel. I would hope we do not currently send those
> frames at such time, so this should not matter much, but the comment
> could be made more clear about the different needs for nullfunc frames
> (please also s/null frames/nullfunc frames/) and probe request frames.
> The former are sent only on the operational channel in the beginning and
> end of scan while the latter are sent on the channels to be scanned
> during an active scan.

The other thing is -- we shouldn't ever actually run into this code
dropping frames at all. Or rather, we should find a way to avoid it.

You have to realise that when the quoted piece of code executes for
frames other than nullfunc/preq frames, all is lost already! That means
we've had so many frames on the queues that we have frames stuck on the
software queues, and we'll start sending them while on the wrong
channel...

The proper way to fix this involves stopping the software queues,
flushing the the driver/hardware queues, and only _then_ leaving the
operational channel. Broadcom firmware will reject off-channel
transmissions (if set up correctly), but even that is not really
desirable here because it means we lose the packets too.

Once scanning starts, we have to start the voice queue again, of course,
and because it might contain frames still we should change the code
above to queue up the frames internally instead of simply dropping them.

If anyone wants to do anything about it, I would ask to wait for my
pending frames rework though, since that will make the last part simpler
and would most likely clash with any work done here.

Drivers implementing hw_scan are not affected, of course, if they do
things correctly. Which is probably only iwlwifi with its firmware
assisted scanning.

johannes

--=-mt8yhGQ0dYJjPCV8kViX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJvlt7AAoJEKVg1VMiehFYKC4P/2COAEBv3M/mA5L8MHYxkKj5
KDkfn1DNE9eNQ2e59K5z/lSApcFygCCGtI4E+zegyEwqzwN7tMPUZLolO437VkUK
KquSjL0rcZAp4OWVOJaFSbmxBTeL5hooGK6ZZpVABhNJyZZtpob6ZoBSPhbGpeSt
ZTlVKR8p6f6Mq8uUY0sfucMjzSPeSkSBqmJM+9JRAeCLKPw8Al9zVOoLXqMFKpiS
3BBclwCr0p98LUwABambS4+U7BNY3X+5AcGx49tkQTbeUkNscwpaE9iwJfTM0qrb
9cVCbQa+h5bpaMaRgEsEE03OS6z0YZs1sbfpxm5yeNQDhV2kCSykog9dyE4ds85o
SFXJ/kj+ry/YOpUm2EEIe/MRIuLfAYl2bI3cL8fmKmgpsIeq2UN4yVAAucvKlQAz
4oqqNpJ9hxvve0N8az9nJObDH8l8sq+mo5SDOjFQEAzShH64Hc0nsmMew4qGmCOL
K2XbJVa/0d6OKwX0P6bFUeO45aV2lGxAmCtk2fyjyDg45PqSvdkbwcBNeeLKTqix
1mSksj0KT12puafDfc8Vwt6Z5UAJwQFJzb1fa9GxbtMBozGpOI+LoN+SvUAY5DH9
30qigT6T27SFOdpeM8/hqjRoLyhcxo0itw/XOr2AzaQqoEX36C4HCT09ADbvqbKH
UsNzJi1JwpptDcWQuNuX
=IvYo
-----END PGP SIGNATURE-----

--=-mt8yhGQ0dYJjPCV8kViX--

