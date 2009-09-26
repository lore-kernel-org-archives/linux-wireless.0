Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZIZNBB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 09:01:01 -0400
Subject: Re: 2.6.31-git wireless broken
From: Johannes Berg <johannes@sipsolutions.net>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0909251506260.11390@sister.anvils>
References: <Pine.LNX.4.64.0909241737390.20846@sister.anvils>
	 <1253813740.3868.324.camel@johannes.local>
	 <Pine.LNX.4.64.0909241859020.25022@sister.anvils>
	 <1253816614.3868.406.camel@johannes.local>
	 <Pine.LNX.4.64.0909242036270.7469@sister.anvils>
	 <1253856038.3868.500.camel@johannes.local>
	 <Pine.LNX.4.64.0909250838420.3783@sister.anvils>
	 <1253868214.3868.713.camel@johannes.local>
	 <Pine.LNX.4.64.0909251506260.11390@sister.anvils>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CxhKh95bEL4qZfx2lkbh"
Date: Sat, 26 Sep 2009 15:00:49 +0200
Message-Id: <1253970049.5122.31.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CxhKh95bEL4qZfx2lkbh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-09-25 at 15:15 +0100, Hugh Dickins wrote:

> That bisection, focussing on wpa_supplicant running versus ESSID:off/any
> (indeed they match up), now completed on the Aspire One (I'll assume for
> the moment that the laptop would show the same).
>=20
> Yes, it does appear that the patch I originally pointed to introduced a
> problem which later got fixed, but was enough to throw the bisection off
> when I just looked for "wireless not working".
>=20
> But you can't escape, you've been too busy, the guilty patch is...=20
>=20
> a9a11622c5c742c115fad371c0397ae86dd3bb67 is first bad commit
> commit a9a11622c5c742c115fad371c0397ae86dd3bb67
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Mon Jul 27 12:01:53 2009 +0200
>=20
>     cfg80211: self-contained wext handling where possible

Heh, fun.

Well the problem appears to be that wpa_supplicant isn't getting started
by your distro any more. Unfortunately I'm not familiar with opensuse.
It seems it thinks the device isn't wireless but wired, since it starts
ifplugd. OTOH maybe it wants ifplugd for wireless too? It's possible in
theory.

I'm downloading a livecd to figure out what might be going wrong.

Can you try running wpa_supplicant manually to make sure it's a problem
in the distro/kernel interaction and not in wpa_supplicant/kernel?

johannes

--=-CxhKh95bEL4qZfx2lkbh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKvhB+AAoJEODzc/N7+Qman8gQAJDmR5o4OtwYLnyiXWmBKrrp
xaCcHtNOKzhwfhKkJSTcT7TvhDBdfCjUYGP/0eYtcAEml5MYnDwWbX+KzZEwaTrL
e0ndR+Kg9Gjg9/JullAIdPAQfojfHrArwt6I4tA7AXIVYjryow5HSYye7F+eCq0i
ECXebdA3PRLUW9ugdWLS+Nl1KvHE8OkKAt1HTVEQW0Wu3egtNxTW8yXyrD6D8jgF
4W4DRtKZ24644I7Q0uvTzmqrT3GtSZhZSFmXviy9nN+2/nmU9TKRJ6s8GV7JV+fB
6MZryzUFhy5L2PG/NTX/V1IYxS9M+46olgZm9wv6NuSgL/9xcV5UZE1Dd8S5d2WV
uNfACpJtqC8grhq+q+aEdbhOv0YgT+pYMm63/gRNGUlNfdr4L+DRYnvcOiy6FCss
oBFZbFCJpMioGIZxaRvAsjFVPdvTq+2DD0kVeZ1gM+HMg9HFVNHTBxTm7tA/a+DT
7SXQmQKzqwJ/k2zXc31cDZO/WNMapHqMFJZROqxAx4uH35+UOPyokix8CHdoMEFt
xjb49pTb2S8zOrhXWWyxYyCkY2BO/wNOL7NgpxeV+93zS9uYNjEY2ZisjKKvrvPo
SrkZ5Gcp94VQKpXqd4F39DTtbkT4AattdiKldRDvMkr7rz7pIH/zv6RrFhmxjjg/
SzYYkE2nDY5wtA35il7x
=GMUL
-----END PGP SIGNATURE-----

--=-CxhKh95bEL4qZfx2lkbh--

