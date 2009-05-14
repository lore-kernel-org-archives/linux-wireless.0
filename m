Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZENTHI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 15:07:08 -0400
Subject: Re: Scan while TX/RX'ing a lot of data
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com
In-Reply-To: <1242327298.4227.25.camel@localhost.localdomain>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
	 <1242327298.4227.25.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eVOGB4mhInuZji5uP2VU"
Date: Thu, 14 May 2009 21:06:35 +0200
Message-Id: <1242327995.5799.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eVOGB4mhInuZji5uP2VU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-14 at 14:54 -0400, Dan Williams wrote:

> Libertas splits scans up into 3 parts with a short return to the
> operating channel between each part.  There's nothing that requires
> cfg80211 for that to work...

Yeah that was my idea too, just return to the operating channel after
having scanned a channel or two and wait for the next beacon, and
possibly receive traffic if indicated in that beacon. It takes a bit of
synchronisation and isn't easy to implement, but it's definitely
possible.

> The problem here is that at any time an application (say, wifi location
> app) could ask for the list of access points.  If you don't scan
> periodically, all APs other than your associated AP (and others on the
> same channel) will gradually drop off because their beacons are
> received.  Hard to wifi position or get area statistics if there's only
> one AP in the list.

The other thing we should do is bump the AP list timeout, I think -- 10
seconds is very small. But then again we really need such apps to query
NM anyway.

> Secondarily, scanning is a tradeoff between better roaming latency and
> continuous high throughput.  If you don't scan, you have no idea what's
> around, and when you move and the current AP becomes marginal, you
> *have* to take the hit no matter what, so you can scan and find a new AP
> to associate with.

Yeah, that too.

> I would have though that the periodic scanning would be more of an
> annoyance when doing VOIP or SSH other latency sensitive tasks, but when
> just downloading a file, a few second drop in transfer rate gets lost in
> the bucket in the grand scheme of things.

ssh isn't too bad, at least not after I fixed the timings... before I
got very annoyed with ar9170. OTOH with VoIP it would suck to have a
small hiccup every 2 minutes -- maybe then we should postpone
indefinitely and only do it if the signal strength fluctuates?

johannes

--=-eVOGB4mhInuZji5uP2VU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKDGu2AAoJEODzc/N7+QmajtQP/1b2jtlz+r5PGcPrCVL5QHIH
H/2WpYeoYn5W9RnxzTgQiPnZ/1Glcos1hLfOhqiAEQUJX5oXh5pPl50qFrLkZ7pR
7GF1Jc3SxsXzeI4temiTvLa51cQDFfjcMhbLtfyCoEFaXNZ438/AA5I1c+fVk435
WNRyzLDEMPCq37fk9xNI/5kqtD2skL/HRNCHuDAFxvsIqUMijARxK61tVNRITSWW
o1d/HOLJ6paJ6pCzKW1XoD0PBb7sHW232QhM7y2AEvOiFoD1PvBzgpD001TZgpJE
fW5wvrxV7Nb4ixyzRdW3ZzM9c2u0b4WvRmYJhWsB4ksB0Nl2doqpJRz2/yhQj09h
HbeRvgXU/5YSg1pSZ7SpCeZAClXs19O/++VhDqwpfHU6b76rmJm/YgsXWR7EQC66
NlbQ405zvzYD416J7aTgiZTES38+l2TQGRg6yxYl2DktwmTH7e8g+iYh/btVeaLS
jXTj5gC7ywtNjNlJEvK0NmxxsbA1O2y3EX5RUS8J6paLt/CDyn4NX1Mke7dSWsTr
W00tc0qtwyK92Zy8HIR+bjBZDP/pZGv6RxFsWHtGMUi7tclb0IHowzqrBCnm8zmc
5bbK3gKLzmiQSWMWympvApwViasDSKHbrCz+wSBOb97cp+Wz8LCuEeYMsDEnxUSq
SWQIX6oq/gfBr+fTfl6s
=FBKm
-----END PGP SIGNATURE-----

--=-eVOGB4mhInuZji5uP2VU--

