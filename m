Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:60189 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697AbaELOu6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 10:50:58 -0400
Date: Mon, 12 May 2014 09:49:28 -0500
From: Felipe Balbi <balbi@ti.com>
To: <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
	<linux-rdma@vger.kernel.org>, <linux-acenic@sunsite.dk>,
	<nios2-dev@lists.rocketboards.org>,
	<linuxppc-dev@lists.ozlabs.org>,
	<e1000-devel@lists.sourceforge.net>,
	<devel@linuxdriverproject.org>, <linux-usb@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>,
	<linux-wireless@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
	<linux-s390@vger.kernel.org>, <devel@driverdev.osuosl.org>,
	<b.a.t.m.a.n@lists.open-mesh.org>,
	<bridge@lists.linux-foundation.org>, <dev@openvswitch.org>,
	<trivial@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [resend] net: get rid of SET_ETHTOOL_OPS
Message-ID: <20140512144928.GA31882@saruman.home> (sfid-20140512_165128_448353_4215121B)
Reply-To: <balbi@ti.com>
References: <20140511001231.GC7875@kaos.lebenslange-mailadresse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
In-Reply-To: <20140511001231.GC7875@kaos.lebenslange-mailadresse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 11, 2014 at 12:12:32AM +0000, Wilfried Klaebe wrote:
> net: get rid of SET_ETHTOOL_OPS
>=20
> Dave Miller mentioned he'd like to see SET_ETHTOOL_OPS gone.
> This does that.
>=20
> Mostly done via coccinelle script:
> @@
> struct ethtool_ops *ops;
> struct net_device *dev;
> @@
> -       SET_ETHTOOL_OPS(dev, ops);
> +       dev->ethtool_ops =3D ops;
>=20
> Compile tested only, but I'd seriously wonder if this broke anything.
>=20
> Suggested-by: Dave Miller <davem@davemloft.net>
> Signed-off-by: Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>

for drivers/usb/gadget/:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTcN94AAoJEIaOsuA1yqRE2R0P/RhVi/Qfz54HMVfE28wnFO0q
QnlKuoHAVxYrJGy2DMEWK0M3Pur63qxiFZjkcZeoltPuas2EyP/SYGeb7RssNOSt
jLvDOYvpOF6UVmmz+FMPXXDHjOwjlZI/GKLpAnpnBsUUjH1KAHiYQztgZaIr+tAC
u09I9dYOPzEiZS0JVsS2H3OMzmjD0qEAIyJD/8JCSyTTod8TV/8M4oIupKyvamR4
lI8L+9pNJlzc1q9lk8JdLg0uX5nFwkN3LElRESG865TMNTkMhsK+t1Xwj22LBJYL
aB5o2Fdt1z0PPvpcRu8Yq6NvGFRXjufFXt+ERizVIo4ZYyGoE+8SvG134PDSkL3E
GN6C+SmC/eoN4KZqh9sDEINNYSsnW7/qzwKOfjUt6vnBJQtMeOvFs6N11JBe5XGm
OdS5NVjt8E9ojjN82eg8xYHM69GW8fUgsTDstLA67mOiKTLhTbZtSTT3Vxc91fJf
FRN+zqJ1haKeNThtM0WP15V7YEcaNuO0ImGoX4OUgWOCCwvbrlTQesC+ndbj4fA+
Eoa9CWBXt+7yR7iPHRbvn1aOexmXT+kBMN0z3CzHSuBDHdFAvNKZQapR9IsSEZbD
nTGr4DCWBVQBTkzt9eKslLeRwS53guWFS9veXqbL9XZMAP6oCbeiVPzb9FnW+vb4
w8H5mRK9If342xMOpRq0
=//u0
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
