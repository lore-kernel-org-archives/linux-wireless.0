Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45359 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423451AbXBPJSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 04:18:49 -0500
Subject: Re: renaming in debugfs?
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <greg@kroah.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070215224057.GA20464@kroah.com>
References: <1171540374.20204.2.camel@johannes.berg>
	 <20070215224057.GA20464@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7OC8x1aE1A4Ahq5bLk9g"
Date: Fri, 16 Feb 2007 10:18:41 +0100
Message-Id: <1171617521.5220.72.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7OC8x1aE1A4Ahq5bLk9g
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-02-15 at 14:40 -0800, Greg KH wrote:
> On Thu, Feb 15, 2007 at 12:52:53PM +0100, Johannes Berg wrote:
> > For the wiphy stuff I wanted to provide a debugfs as well as a sysfs di=
r
> > for drivers (or the d80211 stack).
> >=20
> > But then I decided that stable wiphy names will be a good thing instead
> > of just numbering them wiphy%d. Does anyone have any idea how to rename
> > directories in debugfs? I guess that for sysfs it'll just work if I
> > change the kobject name, but maybe that's wrong too?
>=20
> No, use kobject_rename() if you want to rename a kobject in sysfs (or
> the real device_rename() call if you have a struct device).

Ok.

> For debugfs, there is no rename function yet, but it would be pretty
> trivial to add one if you wish.

Alright, when I get around to actually doing renaming in cfg80211 (it's
not really high priority right now) it I'll check out how it would be
done.

johannes

--=-7OC8x1aE1A4Ahq5bLk9g
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF1Xbx/ETPhpq3jKURAjsZAJ9WxkFoCzBHx32RLUvoYMDKF1zRMACfR2HU
d0zyVx1JkzJv0PQLbEVG5/U=
=oIQu
-----END PGP SIGNATURE-----

--=-7OC8x1aE1A4Ahq5bLk9g--

