Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54444 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbYDAMZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 08:25:44 -0400
Subject: Re: mac80211 MLME scanning - BSS list trouble
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Javier Cardona <javier@cozybit.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>,
	Bill Moss <bmoss@CLEMSON.EDU>, Daniel Drake <dsd@gentoo.org>,
	Dan Williams <dcbw@redhat.com>, Vladimir Koutny <vlado@ksp.sk>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <20080331200536.GA13799@tuxdriver.com> (sfid-20080331_213426_952103_78087899)
References: <1206865999.22530.187.camel@johannes.berg>
	 <20080331200536.GA13799@tuxdriver.com>
	 (sfid-20080331_213426_952103_78087899)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OVR3YWmqOWmZmZR8Y56/"
Date: Tue, 01 Apr 2008 14:25:39 +0200
Message-Id: <1207052739.5143.73.camel@johannes.berg> (sfid-20080401_132547_258337_BD4C8BCF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OVR3YWmqOWmZmZR8Y56/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-03-31 at 16:05 -0400, John W. Linville wrote:
> On Sun, Mar 30, 2008 at 10:33:19AM +0200, Johannes Berg wrote:
>=20
> > The first one is that there is no actual expiration of BSS structs. Eac=
h
> > BSS struct has a 'last_update' member that contains (in jiffies) the
> > time this item was last updated. This means that we accumulate BSS
> > information forever, but due to the 'last_update' only the last few
> > items will be returned to the user on asking for a scan result. This
> > obviously has problems since a rogue station could bombard us with fake
> > probe responses and cause us to build a huge BSS list which is never
> > again freed until the hardware is deregistered. This will need to be
> > fixed, of course.
>=20
> Assuming this was fixed, does the rest of this issue go away?
> It seems like it would.

Sort of, it'll go away as soon as the info is expired, but you still
won't be able to switch over right away.

> Should we consider allowing the beacon to update the info if
> last_update is old enough to keep the BSS out of the scan results?

That, maybe, and maybe also if we don't want to associate with that
network right away or something.

Really, I think this needs somebody to dig into the specs, figure out
which things can change from where, and mostly rewrite it all
appropriately. I for sure won't have time to do that.

johannes

--=-OVR3YWmqOWmZmZR8Y56/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/IpwqVg1VMiehFYAQI9Bg/+OD4o0cYPD3vxHoZ0EvyUpz1vUUcwT5Mg
K05Q8P+1ApXWBsQD+SH1gnUchI08rH4oH8d5z2tOd6rX2zgFbVtZrE1F/qnEhoxu
EjUgxuJE/2itKog85nRg9y+clSQj8/is52e+7vaHA0ScOnpz8rt+La3KuGPW74Ig
+6OsQDc9lF6IaPVAqzMF4uSgoWvdqtLiZF5mck6HU5tOlAsiNXbGxFbzwEFqawdf
5oNZNkSP+4yU0miVygxDLqHzSbZlW/XO79ibFkVX8wFcn1yQGLwyGsxN30vWBOj2
Jmuid/bfhONuJY1o+lx0Bdnfa6wbpH8yd4j241u7b/OyxjhoOJUk0sr6QuNKafaq
FPPVJgLLFcWmsBhdEapXBuOLbwvJ7LGREytdCNnvAFtR5dVAlnbYqTiPI7kgESs+
jlgkbc8oH0sego6hInuAPX34dLLaHRIkEL15pGnafrJ/dK7HYLaZX6JGDVD3K07k
QVdxUfKolW8yGyXYalWcF0mSNliVWOwGphtKk65KzFglNzwswZDGdy7r9Ijhc21g
jcLAr/3g9Dzm5iz5ozGpbsFUF8Ij7W57O9xNcHhLtrKICSjm+8Ay46SxeHxHy8x/
fglDcsNIh74Eyhn0zjjmEhyZunOWqWNu1rFN4kAO5qNa9aDLY4CQzgW3bjji/3/b
y5NbTe23+yg=
=72w9
-----END PGP SIGNATURE-----

--=-OVR3YWmqOWmZmZR8Y56/--

