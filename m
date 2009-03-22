Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33122 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZCVJCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 05:02:30 -0400
Subject: [RFC] regulatory information interpretation rules
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>,
	Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-XKxhcCecLELhqGMwyKnX"
Date: Sun, 22 Mar 2009 10:02:22 +0100
Message-Id: <1237712542.5100.766.camel@johannes.local> (sfid-20090322_100234_495492_0385D4F0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XKxhcCecLELhqGMwyKnX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Ok, so I'm thinking about the interpretation rules for the regulatory
information. I even dreamt about this tonight, unfortunately...

Long mail ahead, sorry, but I felt it was best to include some
background information and examples.

To recap, our information for each country currently consists of
multiple sub-band rules as follows:
	(MIN - MAX @ MAXBW), (MAXAG, TXPWR), FLAGS

Where:
	MIN	lower band edge
	MAX	upper band edge
	MAXBW	maximum usable bandwidth
	MAXAG	maximum permitted antenna gain
	TXPWR	maximum transmit power
	FLAGS	special restriction flags:
		- NO_OFDM	no OFDM use permitted
		- NO_CCK	no CCK use permitted
		- INDOOR	indoor use only
		- OUTDOOR	outdoor use only
		- DFS		DFS required
		- PTP_ONLY	PTP only
		- PTMP_ONLY	PTMP only
		- PASSIVE_SCAN	passive scan
		- NO_IBSS	no IBSS (should be applied to mesh also)

The flags should be fairly self-explanatory.

The maximum antenna gain is a little useless because there's no way to
enforce this by changing antennas, nor are antenna gain values always
known to the host software -- and in any case it seems a little
restrictive to disable the wireless entirely if the AG is higher. Needs
thought on what to do with this -- maybe keep for informational purposes
only.

The maximum usable bandwidth specifies how much of the (sub)band you are
allowed to use at once, at least that was my current interpretation -- I
now think we should document the interpretation rules and slightly
change it from what I've been thinking. This is relevant for example for
HT40, apparently not all countries permit using 40 MHz of the ISM
spectrum by a single transmitter.

For a simple interpretation case, let me give an example:
country ZW:
        (2402.000 - 2482.000 @ 40.000), (N/A, 20.00)

This means that you can use channels 1 through 13 with 20 MHz bandwidth,
or HT40+ on channels 1 through 11, or HT40- on channels 3 through 13, or
anything with a lower bandwidth, of course. Theoretically you would be
allowed to use a 10 MHz channel on 2407 MHz, but that isn't possible in
802.11 implementations. [1]


More complex rules exist for 5 GHz, though. Take this example:
country DK:
        (2402.000 - 2482.000 @ 40.000), (N/A, 20.00)
        (5170.000 - 5250.000 @ 40.000), (N/A, 20.00)
        (5250.000 - 5330.000 @ 40.000), (N/A, 20.00), DFS
        (5490.000 - 5710.000 @ 40.000), (N/A, 27.00), DFS

Here, we have a DFS requirement on anything above 5250 MHz. This does
not, however, preclude using HT40- on channel 52 (5260 MHz) [2], but
would require DFS for that combination. Similar things can happen for
transmit power.

Interesting things happen where you have overlaps, like Japan's 2.4 GHz
band:
        (2402.000 - 2472.000 @ 40.000), (N/A, 20.00)
        (2457.000 - 2482.000 @ 20.000), (N/A, 20.00)
        (2474.000 - 2494.000 @ 20.000), (N/A, 20.00), NO-OFDM

Luis says this is meant to specify:

        Channels 1-11 allow 40 width channels, so HT40 is allowed.
       =20
        Channels 12, 13 only allow 20 MHz width channels, so HT40 is
        disallowed.
       =20
        Channel 14 only allows non-OFDM.

But how can we arrive at that interpretation? I would argue that we need
to change the interpretation rules in a way that lets us remove overlap
and specify what is really required. This means more dynamic flags
calculations, but we can live with that. To this end, let me propose
that the rules for 2.4 GHz Japan be rewritten to (where I have marked
changes with *):

        ( 2402.000 - *2452.000 @ 40.000), (N/A, 20.00)
        (*2452.000 -  2482.000 @ 20.000), (N/A, 20.00)
        (*2482.000 -  2494.000 @ 20.000), (N/A, 20.00), NO-OFDM

Now how should you interpret this? I'll propose the following
interpretation rules (and show how you arrive at the required
interpretation from above):

 1) MIN values are really something like MIN+, i.e. approaching the MIN
    from above, that means that the value "2452 MHz" falls into the
    first of the ranges, not the second [3]

 2) The entire band a channel occupies needs to be covered by (any
    number of) contiguous rules.

 3) The MAXBW value specifies what maximum bandwidth a channel can use
    which has its center frequency (!) falling into the given range.

 4) The FLAGS specify restrictions that any channel _overlapping_ the
    given range has to operate under.

That is all. Now let me show how to interpret this.

"Channels 1-11 allow 40 width channels, so HT40 is allowed."

        Channel 11 has center frequency 2462, but when used with HT40
        the center of the used bandwidth falls to 2452 or 2472. 2452
        falls into the first range, so can use 40 MHz, 2472 falls into
        the second range so cannot use 40 MHz, so only HT40- is
        permitted.

"Channels 12, 13 only allow 20 MHz width channels, so HT40 is disallowed."

        Channels 12/13 have center frequencies 2467/2472 respectively,
        with HT40 falling to center frequencies 2457, 2477, 2462, 2482.
        None of those fall into a range where 40 MHz bandwidth is
        allowed, but 2467/2472 fall into the second range so can be used
        with 20 MHz (e.g. HT20), the 20 MHz channel 13 covers 2462-2482
        MHz so it is not subject to the NO_OFDM restriction.

"Channel 14 only allows non-OFDM."

        Channel 14's center frequency is 2484, so it clearly falls into
        the third range, its HT40 use would be 2474 or 2494 MHz none of
        which are permitted to use 40 MHz, and anything with 2494 center
        frequency would not be covered by a permitted range anyway.
        Channel 14 (as a regular 20 MHz channel) covers 2474-2494 so
        overlaps with the third range and as such is subject to the
        NO_OFDM restriction.


Note that currently, due to our regulatory rules, this interpretation
doesn't actually require changes in any regulatory domain but Japan (JP)
and North Korea (KP) because no other domain has overlaps, and all the
other examples are like Denmark -- which doesn't apply to us (cf. [2]).

Comments?

johannes


[1] mind you, we are simplifying a little here, HT40 really seems to
affect about 45-50 MHz of the spectrum, but that seems not very relevant

[2] which is not valid, and due to the way the regulatory information
was derived we currently only have invalid examples, but this is likely
to change as the rules are adapted to match the real legislation rather
than how they apply to 802.11 -- after all we want this database to be
usable for other things too

[3] this is arbitrary, but needs to be specified. If you need the other
way, you need to use 2451.999 MHz for both values of 2452 above, which
should be good enough in the granularity we require.


--=-XKxhcCecLELhqGMwyKnX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxf6bAAoJEKVg1VMiehFY68EP+wSjUKys11iVgcB1VR0kUHgk
BzmUnWL/pZHo4vouxX3VXuWhtyDM9YrZnwPhBzOh+POr/4ctqBINV9+oB5rlkn+n
rez7UqaCsxyfOL++WqGYKknpqGMSE2iqe5cDuYP6sHdMLrvoB6Ma9eIiT2toZa/A
J/H1sYrDE213eDMZkaDUhe4I5bMz2D9SbvjKdL7WaUF1NNsNAylVfGefpnIZD7Ut
ELKqF4xvZCN98ZXdGkZIn25A4cFVLY/f5nPRZV6BPAWYVT4V1rB4kkgjwXj9ay/4
PIIxWdBVcFwxPe8ueAf9v/e9nyG1t9xGh6vkohEtaSTmk/onPVHzeh2PTNNAB9gC
O+EZ8t89HCfUHduRmWmnL9qOR1TtlTuF4JsIN7BbZKylr5/+gqt//u6p+m7gybGI
zc29ijDbhTLO8mKQ1Ml0j7FfEMXP0/4R9OVIGUvSC36TbN4xkChQ8qMhjXzCkNDp
LGutvxtiE2PuOYOLky/JHf78Vw/jJspBoZfA7hRjzZwkkGoCA7gl8/Yf695td2RA
+OOTa46mdO2Ea0RCLc1DWQFfQzDFQuLNlCK/cnM6mz/4zIZ3HEP0xIibP7Cin9Lj
B6sD8r72zjKzXS+v83EYv86qRkBZovFER8h50AeB9FtjsIUOzrbsmiabSXof6fUp
XjH//XGfoVNDekDpF2Uv
=Uz0S
-----END PGP SIGNATURE-----

--=-XKxhcCecLELhqGMwyKnX--

