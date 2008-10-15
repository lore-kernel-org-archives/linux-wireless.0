Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56648 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbYJORlp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 13:41:45 -0400
Subject: Re: New Regulatory Domain Api.
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224091577.28173.9.camel@californication>
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
	 <43e72e890810100949i78c1d813x1b66c6bc0239ef28@mail.gmail.com>
	 <1223967581.2570.144.camel@debian.sh.intel.com>
	 <43e72e890810140004k6bfa72edsf39acbafcf317fa6@mail.gmail.com>
	 <1223969808.2570.153.camel@debian.sh.intel.com>
	 <43e72e890810140204ne135e72kefe379dd3d26f7bc@mail.gmail.com>
	 <20081014203510.GD3349@tuxdriver.com>
	 <1224018957.3027.9.camel@johannes.berg>
	 <20081014211912.GF3349@tuxdriver.com>
	 <1224019662.3027.13.camel@johannes.berg>
	 <1224085609.4764.18.camel@californication>
	 <1224086374.735.4.camel@johannes.berg>
	 <1224091577.28173.9.camel@californication>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zccDC6/KcQbBLvcGqqHv"
Date: Wed, 15 Oct 2008 19:40:18 +0200
Message-Id: <1224092418.735.17.camel@johannes.berg> (sfid-20081015_194148_359970_06FD4D2A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zccDC6/KcQbBLvcGqqHv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-15 at 19:26 +0200, Marcel Holtmann wrote:

> I can see it useful when companies actually start building products with
> two or more cards in the system and have different cards for different
> tasks in it. So if you stick one card for one band and another one for
> the other band in there, then it would make sense to do a per-band
> regulatory hinting.

The question is whether they'd use Intel cards that have channel-based
eeprom information ;) If it's anything else, then it needs crda anyway.

> Not sure if this really ever ends up in a product. However I can see the
> case where you have a laptop with a BG-card and then attach an A-card to
> it do access an A-network and then it doesn't work. It would be nice to
> just have this working. Currently this would not work.

Well, it won't work if the user doesn't use crda/iw to set the proper
regulatory domain, doesn't set the "old regulatory" kernel config option
_and_ has Intel wireless :)

I don't think we have to worry too much about all these special use
cases, we really want distros to pick up crda and provide location
information to the kernel.

> Also the case when we unplug the first card, does the regulatory hint
> gets reset and the next card could bring in a new one? I can see use
> cases where you don't wanna use the built-in card, because it is just
> too limited.

Not currently, no, it wouldn't get reset I think. Should be doable
though, in the current framework.

Care to look at it and come up with patches, also for the printk thing
you wanted?

johannes

--=-zccDC6/KcQbBLvcGqqHv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9ir+AAoJEKVg1VMiehFYFTIQAKT33rS+XkCzd/OFHnWt13bL
l256gWjgBSwpI5FW8ZqtXR6NJHRKnY7NYBTgopuYu8nmKqG3P7x5vs7QgMP2h2O0
TbXRjtOjq1zazzXrmVlru2WqtJNVSXAUIG/5AXEWZNhbYhNq7LYgfkLReB7wQMqQ
QMpQQ8ODZMHFkQYiRO4jMdhoRYNb57Lc6wphaDD/0jQWdeCC0WpkWcqCq2X2KGbi
q8eS9H1c+oycsnQCOFZibTDI+PjfKtk9kiZg/A73enHytZJ1G2UvGH/efg5KPpmX
SkCZFnEyQP2dS1CH5O6JCwaYu5rkqiP4slkzM7OcjrGWNsvPjhfh7UezAGiazC3f
c4ISv6vLYgFRAse9beiWPOICVT4cGyUtf9KWz0H1lIlSqvfgTBomlN9+FA24ALAv
HpJ2UeRWvShKGd4khygqwiHxeg5XgRnE7T4puDy7pvc7/IQBYnU9E/w7cxh6a6UJ
oLXzqJwMRedPO229mitm+qrfftqBrr0RcYanRFH+bV/LaAzEIoW8UQuvxua4agAM
MH22mJJLBcCKH8T3LcBj0qFjuEK+Wm95ht1SnoIiudJONI3QcXyFQWvWV7GK7xiF
kwP0dNk7WnQxdpA3CubrxxG7YGhLfsRRazBp+8URHOF0L1ahsmJXa+vJCvDi6hsp
AK2Vs324saYaJbKzPyB/
=Ljwf
-----END PGP SIGNATURE-----

--=-zccDC6/KcQbBLvcGqqHv--

