Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55368 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932956Ab1IMW3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 18:29:23 -0400
Subject: Re: Bug#641424: iwlagn: fails to reconnect to WPA2-enterprise
 (Reason: 23)
From: Ben Hutchings <ben@decadent.org.uk>
To: Miguel Martinez <el.quark@gmail.com>
Cc: 641424@bugs.debian.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 13 Sep 2011 23:29:07 +0100
In-Reply-To: <20110913111546.6947.55565.reportbug@mark>
References: <20110913111546.6947.55565.reportbug@mark>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-xYSD4AqOTxTyG905tJI9"
Message-ID: <1315952954.14749.18.camel@deadeye> (sfid-20110914_002926_631089_7972829E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xYSD4AqOTxTyG905tJI9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[The previous message is logged at <http://bugs.debian.org/641424>.]

On Tue, 2011-09-13 at 12:15 +0100, Miguel Martinez wrote:
> Package: linux-2.6
> Version: 3.0.0-3
> Severity: normal
>=20
> Dear Maintainer,
>=20
> My laptop (T400, Intel WiFi Link 5300) is connected at university using
> Eduroam, an WPA2-enterprise network. After configuring the interface=20
> (either KDE or Gnome2 versions of network-manager), a connection will=20
> be established. After a while, however, the connection will be dropped
> (local reason 3), and will not be reestablished (Reason: 23) after an
> indefinite number of attempts. Apparently, nm is not able to renew the
> IP.=20
>=20
> >From the dmesg output, it seems the wifi card is struggling to decide
> which of two AP it should connect to. Extract from dmesg right after the
> first disconnect:

I think that's a symptom, not a cause of the failure.

> [  817.555025] wlan0: deauthenticating from 00:16:9d:7c:97:02 by local ch=
oice (reason=3D3)
> [  817.565665] cfg80211: Calling CRDA to update world regulatory domain
> [  817.575513] wlan0: authenticate with 00:16:c7:71:a1:42 (try 1)
> [  817.578148] wlan0: authenticated
> [  817.579185] cfg80211: World regulatory domain updated:
> [  817.579192] cfg80211:     (start_freq - end_freq @ bandwidth), (max_an=
tenna_gain, max_eirp)
> [  817.579200] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (30=
0 mBi, 2000 mBm)
> [  817.579209] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (30=
0 mBi, 2000 mBm)
> [  817.579216] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (30=
0 mBi, 2000 mBm)
> [  817.579224] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (30=
0 mBi, 2000 mBm)
> [  817.579232] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (30=
0 mBi, 2000 mBm)
> [  817.580656] wlan0: associate with 00:16:c7:71:a1:42 (try 1)
> [  817.583046] wlan0: RX AssocResp from 00:16:c7:71:a1:42 (capab=3D0x431 =
status=3D0 aid=3D78)
> [  817.583049] wlan0: associated
> [  818.626062] wlan0: deauthenticated from 00:16:c7:71:a1:42 (Reason: 23)
> [  818.634705] cfg80211: Calling CRDA to update world regulatory domain
> [  818.644952] cfg80211: World regulatory domain updated:
> [  818.644960] cfg80211:     (start_freq - end_freq @ bandwidth), (max_an=
tenna_gain, max_eirp)
> [  818.644969] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (30=
0 mBi, 2000 mBm)
> [  818.644977] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (30=
0 mBi, 2000 mBm)
> [  818.644985] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (30=
0 mBi, 2000 mBm)
> [  818.644993] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (30=
0 mBi, 2000 mBm)
> [  818.645000] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (30=
0 mBi, 2000 mBm)
> [  821.971502] wlan0: authenticate with 00:16:9d:7c:97:02 (try 1)
> [  821.974151] wlan0: authenticated
> [  821.977578] wlan0: associate with 00:16:9d:7c:97:02 (try 1)
> [  821.979659] wlan0: RX AssocResp from 00:16:9d:7c:97:02 (capab=3D0x431 =
status=3D0 aid=3D205)
> [  821.979668] wlan0: associated
> [  823.018591] wlan0: deauthenticated from 00:16:9d:7c:97:02 (Reason: 23)
>=20
> Disabling and reenabling the network helps to reconnect to Eduroam, but
> will not last for long, repeating the pattern described above.
>=20
> I first thought it was an issue with knetwork-manager in Wheezy's KDE
> [1], so I upgraded to testing.

'wheezy' is the testing suite at the moment.  Did you start from an
earlier installation of testing, or from stable ('squeeze')?

> The issue remains in all kernels I've
> tried. I've also tried installing Gnome 2.32 from testing and using
> nm-applet.
>=20
> Following suggestions in some bug reports [2], I've tried disabling 11n
> and/or disabling power management (seems to be off in any case), but it
> doesn't help. This is all more puzzling, since my Ubuntu 10.10 partition
> has no such problems with Eduroam. I should note that Ubuntu 10.10 does
> disable 11n, but it's reenabled for 11.04 and later. I will try OpenSUSE
> 11.4 from a live USB to see if the problem also exists there.
>=20
> Finally, it should be mentioned that WPA2 at home works without issues,
> and with 11n enabled (where I'm writing this from).
>=20
> Regards,
>=20
> Miguel
>=20
> [1] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D594452
> [2]
> https://bugs.launchpad.net/ubuntu/maverick/+source/linux-firmware/+bug/63=
0748
>=20
>=20
> -- Package-specific info:
> ** Version:
> Linux version 3.0.0-1-amd64 (Debian 3.0.0-3) (ben@decadent.org.uk) (gcc v=
ersion 4.5.3 (Debian 4.5.3-8) ) #1 SMP Sat Aug 27 16:21:11 UTC 2011
>=20
> ** Command line:
> BOOT_IMAGE=3D/boot/vmlinuz-3.0.0-1-amd64 root=3DUUID=3D26d17817-1add-4b72=
-8386-1039a90eb83a ro quiet acpi_sleep=3Dsci_force_enable intel_iommu=3Don =
pcie_aspm=3Dforce
[...]

I don't think it's likely to be relevant, but could you test without the
'pcie_aspm=3Dforce' option?

Ben.

--=20
Ben Hutchings
To err is human; to really foul things up requires a computer.

--=-xYSD4AqOTxTyG905tJI9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATm/ZM+e/yOyVhhEJAQqFDBAAkPU3mdP318FzHneXDyc8qjLMsMFoK2jG
Mps1dI6KTPK6xprJvPeOfILYAPlVSJdqOCbH91Nr2XOBwI900LYAJ6kcpiDKraXp
Ss4Mio7hQsDEx9awXs8UKT/G+5F7JrdT3nbYHAcXpXk+TXgx9PXKViBe/+wx1kGl
lIiVaFVd/jkjWmzSJMoc1qbvRZf51XFPyMZ2HBx9S/O5GjLwOn3MBgbhXCzmZPUk
BaaI49toskztwWWDpGjwqfSp/px6AmruBHOqaGLPp7oMbq+3qz7Q8SIXU3XlzECD
zd6DJNbXtMgd0FSgVMfhs8W58gv22ZhQWRVE93qX3VJUvNoq/bLn/aa28Wn/MCWX
CB4E70F4pBji1dJTsqw4iMO+xk9bybEfPNXn0nQO1YmV9aGpNe3cIHle00ek2oS0
KCTesSLqyDCtNh2OGjOXnyMrD/A+t3CMTv0bCQZkUhYUNO+bhmZBb/t1R6A/aX22
zMkd3qL1+FDtk0daK1Zxb7YSh2TVwl1zCyXJFm7Pt+jOaUOPyFkxvTeHHPHm4eNT
HGofvHoEkNPt2wIsmOHnFtDvXOgKf89sk+XrmZN7ghFsu3c8L1ert9TitR4yaYOC
EYXeaEQyNnaaPAcVtXQHGXLw5XgeZz7X/iVSUi8JKIHGPwqpkmHwk+fhwvmDYt8f
wnChB2meabs=
=+QCX
-----END PGP SIGNATURE-----

--=-xYSD4AqOTxTyG905tJI9--
