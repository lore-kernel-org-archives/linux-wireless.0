Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59850 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbYK2VdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 16:33:12 -0500
Subject: Re: [PATCH 1/3] mac80211: add power state transition callbacks
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	Stefan Steuerwald <salsasepp@googlemail.com>
In-Reply-To: <200811291806.20309.chunkeey@web.de>
References: <200811282345.48379.chunkeey@web.de>
	 <200811291315.01685.chunkeey@web.de>
	 <1227961293.3542.7.camel@johannes.berg>
	 <200811291806.20309.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pnCCqraw0ZtptXv7s4lg"
Date: Sat, 29 Nov 2008 22:33:06 +0100
Message-Id: <1227994386.3542.15.camel@johannes.berg> (sfid-20081129_223315_274155_4DA929E9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pnCCqraw0ZtptXv7s4lg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-29 at 18:06 +0100, Christian Lamparter wrote:

> > The only thing I was thinking is that it's not a good plan to have a
> > callback that has different locking requirements depending on a
> > parameter.
>=20
> yeah...  go back to the extra sta_notify_ps callback approach?

Fine with me, yeah. It's not very complicated so we can always change it
again later.

> I tried to do this with workqueues, but It turned out that queue_work
> doesn't work since we disabled the irqs in the rx path.
> ( http://linux.derkeiler.com/Mailing-Lists/Kernel/2005-02/3350.html
>  has a story about the bitter consequences of queue_work & irq_disabled)=20

Interesting.

johannes

--=-pnCCqraw0ZtptXv7s4lg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJMbUPAAoJEKVg1VMiehFYylsQAJ9JoCPf5dISHZzjUr/BoBCx
UvmtDJoFnpa0hwhhbdM5ZU3APYGa9M6TIjn+xNIXm4SQ6NKZP5N/p0VPG8xkpPb8
uuUQiDHmC0JiNk1OMLaX44zxa+KaS71V6mcLV55r2I3PzLQhPXTcI645h95CsXue
tJPVD3Ca0+tWDkY1S8UPPSx1ZFlh5md28XK1b4220pzul1J9l1VpXtKrCh0lEP0N
ljuFpNCzKpG+FvMWESgmAFikS5TMo9gt4Zju4LWaEyCapWLXNZWzwLboVyXiwwu0
T738UOl8nMQ4HUw9x6VUhj6f1LqVT0Bu4uoNd5RANdMv/4Vbn0BYSbu0J+tMrN8m
dRXbaT0QWGdE3CWUqPH/o3mkGyoaleIBEjhFZiqXc9jpjkZU5WEj2vEd8MVFJJRu
KDvQjpMIxCPGlAzD8kVk6FbUx8li2D+uEvHKgOkMmABzx8Yc9l/p6hVGpNWrXn6R
QcLjmlTYS+jMrhjT88SFNPcQVFZvoesFYvfg1D2LyMZ6+h2tGGqRsxi1qoejdyGs
CtNlmdANs0ZH9ul6XEkQZumzbseqhfrIXiqPs/8uoOV9nmaOB9NHtXYXw+0ybEbb
I1/a0NFsoQU+XtNhvvOFnM1nx8/dT0dq/VMfwltFFuewO9XshsC5drKB3nFbWiMZ
iVOx684DDgkWMO38/yK1
=j5jf
-----END PGP SIGNATURE-----

--=-pnCCqraw0ZtptXv7s4lg--

