Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smp.if.uj.edu.pl ([149.156.82.206]:56630 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934922Ab1IOVWz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 17:22:55 -0400
Date: Thu, 15 Sep 2011 23:22:48 +0200
From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Michael Witten <mfwitten@gmail.com>
Subject: Re: [PATCH] ipw2x00: fix rtnl mutex deadlock
Message-ID: <20110915212248.GQ23706@smp.if.uj.edu.pl> (sfid-20110915_232258_554451_0E5C42FE)
References: <1316011670-6787-1-git-send-email-sgruszka@redhat.com>
 <1316020961.3506.4.camel@dcbw.foobar.com>
 <20110915074249.GA2262@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_smp.if.uj.edu.pl-32711-1316121772-0001-2"
In-Reply-To: <20110915074249.GA2262@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_smp.if.uj.edu.pl-32711-1316121772-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09-15 09:42, Stanislaw Gruszka wrote:
> On Wed, Sep 14, 2011 at 12:22:40PM -0500, Dan Williams wrote:
> > On Wed, 2011-09-14 at 16:47 +0200, Stanislaw Gruszka wrote:
> > > This fix regression introduced by:
> > >=20
> > > commit: ecb4433550f0620f3d1471ae7099037ede30a91e
> > > Author: Stanislaw Gruszka <sgruszka@redhat.com>
> > > Date:   Fri Aug 12 14:00:59 2011 +0200
> > >=20
> > >     mac80211: fix suspend/resume races with unregister hw
> > >=20
> > > Above commit add rtnl_lock() into wiphy_register(), what cause deadlo=
ck
> > > when initializing ipw2x00 driver, which itself call wiphy_register()
> > > from register_netdev() internal callback with rtnl mutex taken.
> > >=20
> > > To fix move wiphy_register() outside register_netdev(). This solution
> > > have side effect of not creating /sys/class/net/wlanX/phy80211 link,
> > > but that's a minor issue we can live with.
> >=20
> > Unfortunately that path is one of the ways that programs distinguish
> > wifi devices from plain ethernet devices.  The other way is to poke it
> > with WEXT.  Should poking it with nl80211 be added to the mix instead?
>=20
> Not sure, maybe device/ieee80211/phy0 could be used?
>=20
> [stasiu@dhcp-27-172 ~]$ readlink -f /sys/class/net/wlan0/phy80211
> /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0
> [stasiu@dhcp-27-172 ~]$ readlink -f /sys/class/net/wlan0/device/ieee80211=
/phy0
> /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0

I conifrm that (with patch applied)
/sys/class/net/eth1/device/ieee80211/phy0 does exist
(both ieee80211 and phy0 are real directories not symlinks,
only eth1 -> ../../devices/pci0000:00/0000:00:1e.0/0000:0b:02.0/net/eth1,
and device -> ../../../0000:0b:02.0 are symlinks),
only .../eth1/phy80211 symlinks is missing.

I am using NetworkManafer 0.9.0-1 and do not have any visible
problems now.

Regards,
Witek

--=20
Witold Baryluk

--=_smp.if.uj.edu.pl-32711-1316121772-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk5ybKgACgkQ7ZLFFOttZ4KYggCfRfu77NjDab5qNcnyJSBx51TG
FAgAoM/rK758If6QzH220aanwMSBdt5M
=Psry
-----END PGP SIGNATURE-----

--=_smp.if.uj.edu.pl-32711-1316121772-0001-2--
