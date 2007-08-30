Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41925 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbXHaKKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 06:10:17 -0400
Subject: blocking in dev->open (was: [ipw3945-devel] chaning mode only when  interface down?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
	dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	network manager <networkmanager-list@gnome.org>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1186140019.22438.6.camel@xo-13-A4-25.localdomain>
References: <C07C4589BE74A34981C3C3525EE1F801024CF2CB@hasmsx412.ger.corp.intel.com>
	 <1186058047.24230.38.camel@johannes.berg>
	 <1186080675.9527.10.camel@xo-13-A4-25.localdomain>
	 <1186134177.4647.19.camel@johannes.berg>
	 <1186140019.22438.6.camel@xo-13-A4-25.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cYmooENU0BnbGznjKVKW"
Date: Fri, 31 Aug 2007 00:24:19 +0200
Message-Id: <1188512659.7585.5.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cYmooENU0BnbGznjKVKW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[picking up on this old mail again, somehow remembered it]

On Fri, 2007-08-03 at 07:20 -0400, Dan Williams wrote:

> > Not sure I understand? Drivers can fully well block the userspace task
> > that is doing the IFF_UP until they're read? bcm43xx does that.
>=20
> Well, I'd rather that the driver actually not block (NM uses netlink
> here anyway, not an ioctl) but there be some flag to look for when the
> device actually is up.  That implies that the device not set IFF_UP on
> itself until it actually _is_ up.

Well, since IFF_UP is set by the networking core after ->open() returns
there isn't much a device can do about when to set it. However, if it
blocks in ->open() until it is ready, the right behaviour falls out
automatically, IFF_UP is only set when it's ready. I think blocking
there is definitely the right behaviour. NM simply needs to wait for the
netlink reply a little longer then.

How do you think not blocking should work? The device can't influence
IFF_UP, when its open() callback returns IFF_UP is set and it is assumed
that the device is operating. It's designed to be blocking. And besides,
if you don't like that, you can spawn a thread to do the flag setting,
no?

> I think the biggest offender for
> up-misbehavior used to be prism54 FullMAC, because it had to reload the
> firmware for almost every operation, and that could take over a second
> or two to load & reboot the firmware.  There wasn't a good way of
> telling when that was done and the firmware was ready for business.  So
> you end up having sleep(2) calls littering the code to deal with these
> sorts of little things.

Well, I think it should just block for all that and you should simply do
it out of the main thread if it's such a big deal.

johannes

--=-cYmooENU0BnbGznjKVKW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG10OT/ETPhpq3jKURAjRqAJwIm+C/fvkmcoX7L2kq2cGHccy2MQCeLliz
FuPl6lP+YgHE51RwlRwsgu4=
=BJJZ
-----END PGP SIGNATURE-----

--=-cYmooENU0BnbGznjKVKW--

