Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36595 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbZGAKlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 06:41:19 -0400
Subject: Re: Some thoughts about background scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200907011003.49857.helmut.schaa@gmail.com>
References: <200907011003.49857.helmut.schaa@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-exJEKfY+6rvNW8O6TWiY"
Date: Wed, 01 Jul 2009 11:37:18 +0200
Message-Id: <1246441038.4131.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-exJEKfY+6rvNW8O6TWiY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> just thought a bit about background scanning (not triggering scans at
> any time but just hopping back to the operating channel once in a while
> to allow RX/TX).

:)

> My current approach is quite easy but works well: Extend the scan state
> machine with a new state (OPERATION) which restores the channel and the
> correct filter flags and notifies the AP that we're back.=20

Makes sense. You can optimise scanning for the _current_ channel by a
combination of OPERATION and scanning, leaving the filter flags at the
scan version, and sending the probe requests. In fact, if you scan that
channel first, you can avoid IEEE80211_PROBE_DELAY since the NAV should
be known on that channel.

Tangentially related, we can also move into SCAN_SEND_PROBE _before_
IEEE80211_PROBE_DELAY has passed, if we receive a frame (which means NAV
update).

> The state
> machine moves there after every scanned channel. The result is that
> the complete scan can take quite some time, something a round 15 seconds.

That doesn't sound too bad. How long are you staying on the operational
channel though?

> Scanning multiple channels before switching back would allow us to
> reduce the amount of time the scan takes. So, what I'd like to have is
> integration with pm_qos in order to determine how much channels may be
> scanned at once before we have to switch back. Shouldn't be that
> difficult ;)=20

You might be able to use local->hw.conf.max_sleep_period from
ieee80211_recalc_ps? Or probably better move the calculation into a
helper function since it needs to work across all managed interfaces, if
there are multiple.

> However, the current scan state machine is very inflexible
> and I'd have to add a lot of ugly stuff to make it work really good (at
> least that's my impression currently).
>=20
> So, a completely new approach would be to pre-compute all necessary scan
> states. Based on the cfg80211 scan request, the current pm_qos values
> and the beacon characteristics we could derive a table of necessary scan
> states and extend it by operation states.=20
>=20
> For example:
> Channel 1, Active Scan, 30ms
> Channel 2, Active Scan, 30ms
> Channel 3, Active Scan, 30ms
> Channel 4, Active Scan, 30ms
> Channel 11, Operation Mode, 120ms
> Channel 52, Passive Scan, 120ms
> Channel 11, Operation Mode, 120ms
> ...

Sounds reasonable.

> Advantages:
>=20
> We could split the actual scan algorithm out of the scan state machine,
> for example if pm_qos allows us to stay away for 150ms we could reorder
> the channels to scan one active channel followed by one passive channel
> before switching back to the operating channel. Should allow us to use
> all sorts of insane optimizations.

:)
It might be better to have even more states, e.g. make the list look
like this:
 - SWITCH_TO 2412 MHz
 - NAV_WAIT max 33ms
 - SEND_PROBES
 - WAIT_PROBES
 - SWITCH_TO (operation channel)
 - OPERATION
...

That way we can short-circuit the NAV_WAIT on receiving a frame, for
example. We don't receive all frames, of course, so it would be useful
to have some driver assistance for that at some point too.

> Disadvantages:
>=20
> If we compute the table while we're associated but lose association in
> the middle of the scan we would either have to update the scan table to
> reflect the current state or leave it as is which of course lengthens the
> scan. And of course we need more memory to store the table.

The memory consumption wouldn't be a problem, and if we lose association
we can always skip the operational states, i.e. check whether we lost
association during that state and if not go to the next.

> In some cases we might shorten the pre-computed values. For example if
> we switch back to the operating channel and receive a beacon without
> TIM being set for our association and our TX queue is empty we might
> immediately proceed with the scan without having to stay on the channel
> for the full amount of time. Not sure if we can do this properly without
> recomputing the whole table (depends on the actual algorithm used).

I think short-circuiting states should be possible from the outside for
the NAV wait too.

> I'd like to first get some comments on that idea before thinking about
> implementing it :)
>=20
> Does that kind of approach sound useful? Is it overkill?

Seems useful to me :)

johannes

--=-exJEKfY+6rvNW8O6TWiY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKSy5KAAoJEODzc/N7+QmaO5YP/R155MN2Pzr6ubhZ9PpQkaTM
JxKeSeqo38euQSoi6jlFwufnsRSMZcSzsyQPne+KziUDTUmWzn6PjOrkOvnhPu6f
LtWUOc1uozWK9Er9LrLYI/YrtPqrpZxaElC0A+6qs4alxs3qURxBqbTGW7sfaoJK
wezJT/PObMEfEN2pqFPGm7aPris2prnQj7mOn3+pBKzpuY/iTPOz0N1UDeZwCu81
WkWstc2gS6VWeshBQfP3oAx3WSpF+gebAySlTN4AToPsxUY66wbXlkOQbPRTpasa
CbLEUpH80qZWhV/oamdkK+1hc1IjA6M8AOZ8ou+nczJHZTfyADlYfDXAAJQvopC3
aaFlSTzRlrTDm0odGyUyyHMPc79OcHVwSLIQ6BmBllFeqz6lizOOc53cQ5c4S+eF
OuvUJuC8w80bJJT36a4plpK4215tghjEHuqnwPt8D1mi/gyr/U4Q4rpXB9xb6yso
866i/udmQxVfOCH4HTemKgQpbRjB+q1z59w2NoCUYm9WKzbu6hsZxoA7wKy99116
96df2DF32jhXMabru85wYGuyVTvbyUoZojYzlmpz2aFnQ9ozJYQmKmKlIHh1BFjN
1ZkbY+9A/vS3LAn7s5xKXOWPHecKNovyv6kkpZmIvBYohiVtmF+3e23Oz9rtJUnq
uyoePSbLAX6mNTqT56yp
=U4R+
-----END PGP SIGNATURE-----

--=-exJEKfY+6rvNW8O6TWiY--

