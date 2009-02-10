Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gold.linx.net ([195.66.232.40]:39832 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbZBJBuI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 20:50:08 -0500
Subject: Re: IWL5300, 2.6.29-rc4, CRDA 1.0.1: Missing out 802.11A frequency
 ranges
From: Tony Vroon <tony@linx.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	reinette chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20090210013941.GA4386@tesla>
References: <1234202993.21570.18.camel@localhost>
	 <43e72e890902091020p65235e3ds833560974c785318@mail.gmail.com>
	 <1234203811.21570.19.camel@localhost> <20090209183924.GA6069@tuxdriver.com>
	 <1234207263.6694.1.camel@localhost> <1234208152.6694.4.camel@localhost>
	 <20090210013941.GA4386@tesla>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1WMjzMPcV1Nnu1yIEKWX"
Date: Tue, 10 Feb 2009 01:51:29 +0000
Message-Id: <1234230689.3793.15.camel@localhost> (sfid-20090210_025013_261010_DD8EF93E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1WMjzMPcV1Nnu1yIEKWX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-09 at 17:39 -0800, Luis R. Rodriguez wrote:=20
> In Intel's case the first regulatory domain is ignored (world). To see,
> before associating to an AP try running 'iw list'.

I will remove NetworkManager & gdm from the default runlevel and try
that, yes.

> I noticed that, what ends up happening then is the static world regulator=
y
> domain is used from the kernel. I take it you used an initramfs with the
> sda driver in there?

No. There's an initramfs, but it's only used to unlock the encrypted
root filesystem. The actual driver for sda (ata_piix) is in the kernel.

> I've been using initramfs too but for some reason
> on my system udev triggers the request eventually after the drive
> is mounted. So this is the first time I hear of this.

I have another user reporting it on PowerPC, without an encrypted root.

> I also noticed though:
>=20
> cfg80211: Calling CRDA for country: GB
> cfg80211: Current regulatory intersected:
>         (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>         (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>=20
> This seems to indicate to me you manually ran:
>=20
> sudo iw reg set GB
>=20
> Is that the case?=20

Eventually, yes. To see if that would clear things up, but it didn't.
Even if I just leave the AP 802.11d info to fill in the regulatory
information (which you can see higher up, as it has the information
slightly wrong and includes channel 14 together with very high radio
power) the 5GHz channels are not included.

As said, will do an iw list with no other software having fiddled with
anything yet. The Cisco APs are in the vicinity so I may not be able to
stop them picking up the 80211d info though.

Regards,
Tony V.

--=-1WMjzMPcV1Nnu1yIEKWX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmQ3aEACgkQp5vW4rUFj5oxMwCfYo6e2zjkoyjw2g6CiGhHm5fv
K9wAnRCgj5MOXIao+tNym5RYcUrkX6BT
=IrK7
-----END PGP SIGNATURE-----

--=-1WMjzMPcV1Nnu1yIEKWX--

