Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48242 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbZAGPha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 10:37:30 -0500
Subject: Re: [PATCH 12/14] mac80211: 802.11w - Optional software CCMP for
	management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <20090107153052.GA24894@jm.kir.nu>
References: <20090107112346.369581673@atheros.com>
	 <20090107112707.370907962@atheros.com> <1231330118.3545.28.camel@johannes>
	 <20090107122427.GA20019@jm.kir.nu> <1231332428.3545.33.camel@johannes>
	 <20090107140956.GA22424@jm.kir.nu> <1231340944.3545.38.camel@johannes>
	 <20090107153052.GA24894@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-McY0Uid7OT6BsXeoLgxR"
Date: Wed, 07 Jan 2009 16:37:51 +0100
Message-Id: <1231342671.3545.43.camel@johannes> (sfid-20090107_163734_901668_4255DB8E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-McY0Uid7OT6BsXeoLgxR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 17:30 +0200, Jouni Malinen wrote:

> Sure. Enabling optional MFP automatically whenever driver/hw supports it
> would be nice (there is a separate policy selection of requiring MFP and
> that's something that users will need to configure if they want it).

Indeed

> For
> this feature, I would be fine having the optional-MFP configuration in
> wpa_supplicant mean that it will be disabled if driver does not support
> it, i.e., NM would not actually need to care and it could just always
> set ieee80211w=3D1 in wpa_supplicant configuration (or well, at this
> point, it would need to care a bit since wpa_supplicant would reject the
> configuration if it was not built with 802.11w support, but that is
> probably fine when done over dbus and not config file).

Right.

> As far as wpa_supplicant is concerned, I can make it determine this by
> trying to enable MFP mode at startup to figure out whether the driver is
> capable, so there is no need to add an explicit capability flag for this
> if we do not want to modify WEXT.

Makes sense, yeah.

> For nl80211, we can add capability
> flag for MFP and then driver_nl80211.c can skip this validation step.

Would be nice to be able to print it out in iw, just for information.

> However, we would still need to add a driver-mac80211 flag for
> indicating whether the driver supports MFP.

Right, and once we have that the polarity of this key flag doesn't
matter at all, though I suspect there are much fewer drivers that will
be able to support it in hardware.

johannes

--=-McY0Uid7OT6BsXeoLgxR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZMxLAAoJEKVg1VMiehFYM9wP/2MT2wXBCDeRGqWRUWvqKjQS
/6c7DGaEGrFszqZXrMubVGe70nFh9nJGoI2/iWxKoWEdBl8PjDTdHB9BArgnk0FN
aZotCCDDYs6Yk4M8CDCmm4lk6Wt+X8uvdi1upSECfeYLDuDJRrZso8uHA58kHGBd
MKsLkPkXm5rdYUxPmkMdpONQZgPyUNrcRmlhXoC2iAJ6NgldbLmO4GVsrG0cN/vh
eWrv3Rs+z+4/Sf481emAFS8uLkJk8uhyBABKDlUYl9IEWz6ZLDUwZMmysTlUtaL9
bh1TadD3mnX61EbNOw/tbMmzqaIaN8PzjaYJoiOcnHujDywgqQB+YqXoRa9g5UvN
rjCbsFKuO0KtVgBTPeaRX97Yq+QR5WScOtwQ8v0MbqmMaYLzmMb3utlMj7bq1wcx
VZXtNASRzcRJQLViD9J5y71jB2fKuoXMuhUnp7EEMdjTZQR+hcb3naS/JdcbMhwz
WClPIyd/Om3jorOZUdyU+rO2Vl7b+Kr8FxQnzLgBHr/IPgH1MygvR5bX5LqTqfbF
zBoX5uTGEN/2q4eaMIrqUhOd3nUR+hMdMEP8HThkzR0kthtAcl+lH2vhbvmGCVzb
sxvMhIkrixgFlFvsk7kxTG7jZP/FL+TlLAmvZaRybCWY4kXZ9wOT6c0M2khnoVUh
uz+wfJPf1r6SHWXx/uEy
=oBT9
-----END PGP SIGNATURE-----

--=-McY0Uid7OT6BsXeoLgxR--

