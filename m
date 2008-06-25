Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53613 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYFYUVY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 16:21:24 -0400
Subject: Re: [PATCH] rt2x00: Fix lock dependency errror
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <a32f33a40806251318n4f0bac2cs7ada6e23afe0cb6e@mail.gmail.com> (sfid-20080625_221835_923416_D8569C55)
References: <200806252127.00971.IvDoorn@gmail.com>
	 <1214422400.21847.54.camel@johannes.berg>
	 <a32f33a40806251318n4f0bac2cs7ada6e23afe0cb6e@mail.gmail.com>
	 (sfid-20080625_221835_923416_D8569C55)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UYFlgON+1bzD+z4bDKk+"
Date: Wed, 25 Jun 2008 22:20:39 +0200
Message-Id: <1214425240.21847.57.camel@johannes.berg> (sfid-20080625_222127_722551_39B9B2D0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UYFlgON+1bzD+z4bDKk+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-06-25 at 22:18 +0200, Ivo Van Doorn wrote:
> >> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wirele=
ss/rt2x00/rt2x00.h
> >> index 611d983..73dacbb 100644
> >> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> >> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> >> @@ -821,6 +822,7 @@ struct rt2x00_dev {
> >>       /*
> >>        * Scheduled work.
> >>        */
> >> +     struct workqueue_struct *workqueue;
> >
> > Do you really need a whole workqueue (kernel thread) per device? I woul=
d
> > think that using schedule_work / cancel_work_sync for this task and kee=
p
> > using the mac80211 wq would be sufficient?
>=20
> True, but this is a quick patch to resolve the bug for sure.

Fair enough, this is a fix for 2.6.26 after all.

johannes

--=-UYFlgON+1bzD+z4bDKk+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYqiUAAoJEKVg1VMiehFYDqAP/31GEO1npY7bV4g3snY57Ypb
R7hdakySuAz6s7xWVdChGNxvRl0TiY2tyTf/YYQ8jj/+/hMuKolHfpO/ke99INIH
0o8xfnfroLNDxY5JxMKItzGKNdNWs5r9/Gg5Q5/PKVMLbldYJ9lgpSTc+FikXQ9W
HPnH+bBdX3KHlfl14ERAmnK7LvcrrZTJ2tcpwKbwE/H/Z1SLQdPJw9dTjylfBG9T
GiNdkOXQEWJtnDb/LHHPA+SZyeDJ9MGbccy3NjsSvdUCQsx7F5miDnqyOIzc69wV
u9GiIulFemrLWl34FIY4MpaR+7/Y5GDMtAvqGyGtqOupEEfjkolnMxpeb3Cc+q+m
EhqAc/X5oqZNBW2Ojt76Fr+1x0RvOb24xthzZGLH3+nJvrmkm6SvVHfYXCnJPMdn
SLjJ9fo8R5JElud6UwW306uUNiDAaLqLjtpvzmmQtWDnZfgxgddA1b1UP7QVqd+A
kB5/eZeHyFaILacM+HfMnLSWlYDy959pqGgJZssBw6vGaFRAdDE0yn+5vkqxJ2Ay
duhMADDHE31O39YhqROttYMeXHxMDiRaE4tSgwjMEWNdz7VtYh1gdfWyetPxKfXU
i1D+C/cWscyNozfTtAUcx4S3totaK2Qz0SElltuwQPOxkIpZyNeBIiLrwnE6XDS1
yO4Hx0sYolYmOylNQIO8
=5aYB
-----END PGP SIGNATURE-----

--=-UYFlgON+1bzD+z4bDKk+--

