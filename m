Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48076 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734Ab1HLStC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 14:49:02 -0400
Subject: Re: [PATCH -next 0/8] ath9k: ASPM fixes
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	"Allan, Bruce W" <bruce.w.allan@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"camilo@mesias.co.uk" <camilo@mesias.co.uk>,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	Adrian Chadd <adrian@freebsd.org>,
	"lrodriguez@atheros.com" <lrodriguez@atheros.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Fri, 12 Aug 2011 11:49:00 -0700
In-Reply-To: <20110812123509.GA13328@redhat.com>
References: <1312542639-4274-1-git-send-email-sgruszka@redhat.com>
	 <20110811160847.GD2566@tuxdriver.com> <20110812123509.GA13328@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-+aPHRAbGFkpcEWad7b6W"
Message-ID: <1313174941.2115.8.camel@jtkirshe-mobl> (sfid-20110812_204909_765839_F09BADA0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+aPHRAbGFkpcEWad7b6W
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-08-12 at 05:35 -0700, Stanislaw Gruszka wrote:
> On Thu, Aug 11, 2011 at 12:08:48PM -0400, John W. Linville wrote:
> > On Fri, Aug 05, 2011 at 01:10:31PM +0200, Stanislaw Gruszka wrote:
> > > This patch series try to fix ath9k ASPM. Some of patches are cleanup
> > > only or do merging common code (with e1000e driver).
> > >=20
> > > With CONFIG_PCIEASPM it's possible to change ASPM settings on runtime
> > > via /sys/module/pcie_aspm/parameters/policy . However most drivers
> > > I looked at assume this setting is constant. I add a callback to pci
> > > driver to inform about the change, and allow driver to do needed hw
> > > related changes. Currently only ath9k implement the callback, but
> > > I think it will be useful for other drivers i.e. iwlwifi, rtlwifi
> > > that do some own ASPM handling.
> > >=20
> > > Would be nice to get some testing on patches on different
> > > platforms with ath9k devices on kernel compiled with CONFIG_PCIEASPM
> > > (default) and mixing up commands:
> > >=20
> > > echo powersave > /sys/module/pcie_aspm/parameters/policy =20
> > > echo performance > /sys/module/pcie_aspm/parameters/policy =20
> > > ifconfig wlan0 down
> > > ifconfig wlan0 up
> > > pm-suspend
> > >=20
> > > Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > > Cc: linux-pci@vger.kernel.org
> > > Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > > Cc: e1000-devel@lists.sourceforge.net
> > > ---
> > >  drivers/net/e1000e/netdev.c                |   31 ----------
> > >  drivers/net/wireless/ath/ath9k/ar9002_hw.c |   12 ---
> > >  drivers/net/wireless/ath/ath9k/ar9003_hw.c |   12 ---
> > >  drivers/net/wireless/ath/ath9k/hw-ops.h    |    9 +-
> > >  drivers/net/wireless/ath/ath9k/hw.c        |   17 +++--
> > >  drivers/net/wireless/ath/ath9k/hw.h        |   12 +--
> > >  drivers/net/wireless/ath/ath9k/main.c      |    8 --
> > >  drivers/net/wireless/ath/ath9k/pci.c       |   88 ++++++++++++++++++=
++++-------
> > >  drivers/pci/pcie/Makefile                  |    3=20
> > >  drivers/pci/pcie/aspm.c                    |   46 ++++++++++++++-
> > >  include/linux/pci-aspm.h                   |    2=20
> > >  include/linux/pci.h                        |    3=20
> > >  12 files changed, 148 insertions(+), 95 deletions(-)
> >=20
> > I'm happy to take patches 1-3 through my tree.  But maybe patches 4-8
> > should go through a PCI tree?  Or at least get some ACKS from the
> > appropriate maintainers to take these changes through the wireless
> > trees?
>=20
> Getting ACKs from Jesse and Jeff would be best since ath9k patches
> 5 and 8 depends on 1-3. But, crap, seems my scripts does not eval Cc
> from email body to actual Cc list. Not sure if pci and e1000 guys
> saw these patches. If not, I'm gona repost this set and Cc it
> fully to pci and e1000 guys.
>=20
> Stanislaw

I did see the patches, sorry for not responding.  I wanted Bruce Allan
<bruce.w.allan@intel.com> to review the e1000e changes to ensure he did
not have any issues.  To me the change looks fine based on the aspm
changes.

--=-+aPHRAbGFkpcEWad7b6W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJORXWcAAoJECTsCADr/EWUxk4H/3QZw+AtAMQ2WB4GZkUxi/fX
tNOAQBsNUVNNsDSsQlyGUIBr/9mVLx7TrVjQ1QKvTBieW8xNKC148lZnobHqPd39
3g+qWiTAX4W6dpbHPvm+uKEKzyz2FTIsOhBt9g8Y73Y2NL1c8Lb8B+13/GkTdhl1
/JfZFIBvd6+gGwsccDITo7qLstuZlQGVboUuUjjTAdsvTXLqjL5AFqC9gaLjOkd5
OIXurtgGN/Tlu7n8N2WC2Pq2kDx9hxJiEOk/tGv5xZ8EwHRfq7NuryFnxnvVCEQy
PUWBNq6K/faP6nUH/5VcE+hnnf6MYvTN3/WoANq5Wsy/ukyiO1v9kAXoIjcxgCQ=
=G85S
-----END PGP SIGNATURE-----

--=-+aPHRAbGFkpcEWad7b6W--

