Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32901 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZCYLH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 07:07:57 -0400
Subject: Re: wireless powersaving (in NM?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Dan Williams <dcbw@redhat.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <87ab7bqa21.fsf@litku.valot.fi> (sfid-20090324_151840_285025_0FC0535D)
References: <1237891149.4320.73.camel@johannes.local>
	 <87ab7bqa21.fsf@litku.valot.fi> (sfid-20090324_151840_285025_0FC0535D)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tAe8iXZjm1xlq4G7jwL4"
Date: Wed, 25 Mar 2009 11:57:10 +0100
Message-Id: <1237978630.4320.150.camel@johannes.local> (sfid-20090325_120759_081272_7B96C76E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tAe8iXZjm1xlq4G7jwL4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-24 at 16:17 +0200, Kalle Valo wrote:

> > Therefore, I think the "power saving level" needs to be determined
> > by pm_qos. The design of how to do that, however, is still up in the
> > air.
>=20
> Maybe. At least it "feels" a lot better than the five magic numbers :)
>=20
> Unfortunately I haven't thought about this so I cannot comment on it.
> And by the looks of it, I won't find the time for some time.

By the way, do you have any numbers on how the timeout affects actual
network latency? It's also related to the beacon interval and the listen
interval, of course.

> > The alternative would be to expose all the possible parameters and/or
> > levels to mac80211 and have it make choices based on pm_qos, but it
> > seems that this interface would rapidly become extremely complex,
> > fragile and buggy.
>=20
> I think this alternative would be better in the long run. My feeling
> is that the settings between different hardware don't wary that much
> based on what I have seen and we would eventually find settings which
> work for all, maybe small hackery needed somewhere but that's it.

I'm just worried that we'll require a whole bunch of different
interfaces. Yes, in theory there isn't much to control, but iwlwifi
firmware for example can, as far as I interpret the code, dynamically
vary the listen interval.

Some of the decisions might also depend on the hardware, I could
imagine, the point where turning off power saving is required might be
different depending on hardware due to wakeup time maybe?

> Also remember that in !IEEE80211_HW_SUPPORTS_DYNAMIC_PS case the
> dynamic timer is in mac80211. So the driver cannot make all decisions.

Right.

> > Kalle, there's a related question here -- what's the value of exposing
> > the sleep timeout to users? It seems to be quite unnecessary, since you
> > seem to be using a fixed value of 500ms anyway.=20
>=20
> In Maemo products (n800, n810 etc) we use it to select the power save
> aggressiveness. IIRC in diablo it was so that when the display was on
> 200 ms timeout value was used, and then it was off the value was set
> to 100 ms. The decision was made in userspace, in wlancond (our dbus
> WE wrapper). The idea here was that user won't most probably mind if
> the network is slower then the display is off.
>=20
> > Can we remove that, leaving wext only with turning on/off power
> > saving? [2][3]
>=20
> I would hate to loose it, at least in the near future. If there's a
> good alternative and a proper deprecation period, I don't mind it
> going away.

The trivial alternative would be to use /dev/network_latency and
register the requirements instead, but do it "globally" based on display
state rather than "properly" based on applications.

> Disabling the power save should always be a visible option for the
> users because of the broken APs. There are still APs which have
> problems with power save enabled clients.

Ok.

> > However, by putting the burden onto drivers, drivers can choose a
> > conservative power saving level when no application has registered its
> > pm_qos requirements, and once applications start using the it deeper
> > power levels can be chosen as appropriate.
>=20
> It will take years for the applications to adapt this, I would not
> want to depend on that. I would like to have usable already without
> application support.

As I said above, you can always have a single application register
requirements for the other apps.

johannes

--=-tAe8iXZjm1xlq4G7jwL4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyg4DAAoJEKVg1VMiehFYrfMQAJRhcf3GDrQk2/s7E6mp7Ue/
yPuxbuybZzrY8XJYY01HT6qVKtiPbS2SyXtKKCS+ZzpOUr7EQOc85pwcEUhDfCKS
x+r3Zq+JoHzo4HQKHWKrjXcZwObq+DwEDrgqdw9CutxKqmLKUG+I/cw5/LTns779
8v99T7WXcSu81KAkGQTdF4trzWtyL4tgpithRp40Ckgg+nO34ra0qKv49IfZhajx
vtNvFuARlX4QnMaJ/BoulrMMLZ9tEgUeLoYBVhidSJCIOivA69kOmA76HczmjO3M
En8zxGFKcxwIdHL8/raB/QzWU3nqf8udKNmRlOuY+HVUvcCX2L/9tHzr+da30J31
q1TeitpcDVqvRJqrnSubNPu+UDAi8UuHwC7tK7ZKGDze/+5JpFhMWPQGF4m8qhJ4
mypU+7iScPO/BiFGduUHMdBtels+V6DWgGvMg9zhiY1yWCVVPBeGPiLs98tcvjQX
UHIanbZcnn9AiD51t1tXF9l1m86H8Jo2NG5oZmS2fYQyMYp67yevOK6K4YqHO0Cn
uicw3BrFkYL+A1qSvL4xDpyKrjyA5teNLmfjNuGsmhURe1gngWQ3f0UnQsDGQ6GT
G1RBP+pImYSp4b9KusTH4Opd+ZchYSx3X+23vAA1JlQw9boes0EPsjXRwXBSG+ov
w/DVIwxSRid/lvsxCDP5
=coon
-----END PGP SIGNATURE-----

--=-tAe8iXZjm1xlq4G7jwL4--

