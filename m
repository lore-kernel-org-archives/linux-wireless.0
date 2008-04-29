Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50539 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYD3OGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 10:06:38 -0400
Subject: Re: [PATCH RFC v2] mac80211: no BSS changes to driver from beacons
	processed during scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1207785375-13470-1-git-send-email-reinette.chatre@intel.com>
References: <1207785375-13470-1-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PR0ouoNcVOki9KHppxMV"
Date: Tue, 29 Apr 2008 17:26:47 +0200
Message-Id: <1209482807.3960.42.camel@johannes.berg> (sfid-20080430_160633_321096_4C66FEC2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PR0ouoNcVOki9KHppxMV
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-04-09 at 16:56 -0700, Reinette Chatre wrote:
> There is no need to send BSS changes to driver from beacons processed
> during scanning. We are more interested in beacons from an AP with which
> we are associated - these will still be used to send updates to driver as
> the beacons are received without scanning.
>=20
> This change=C2=B7removes the requirement that bss_info_changed needs to b=
e atomic.
> The beacons received during scanning are processed from a tasklet, but if=
 we
> do not call bss_info_changed for these beacons there is no need for it to=
 be
> atomic. This function (bss_info_changed) is called either from workqueue =
or
> ioctl in all other instances.

Should we do the same for conf_tx, i.e. ieee80211_sta_wmm_params? I'm
not entirely sure the IBSS code doesn't still call it in a non-blocking
context though.

johannes

--=-PR0ouoNcVOki9KHppxMV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBc+NqVg1VMiehFYAQIJ1RAAreCDnK4cEGKxIPFOcUu3NWczeBvCDurK
N0pRlDLfabNAFrsxjhMXvgtdYpXk+DyfEYoIO9i+ozl2r8uysdXGGigapf2x6ul3
H9D3F9Y6SGKte03qnYB4VthfVpMQpmNC7zWRc1187O01nkY7eIJF5GDeBrN5DWmc
qRaafKD6WzzcYxuQF0BKtSk4EnMr1SdPa4oDFXyFrXF2H2XJCDkIev0P7bWQ1T4B
MRoNo4/XdhFuxhMkxPvt91o2kLsjFSDyRd7Yntf6KqISeYmKz2j1s92AlJ1yQfFM
VpyDqDD5ydyorbsxZNxYLHrTJ+apzqse65hQBI19GUbB7r3pbql+aj7aattmVtpB
XQOS6fMKEdVWLSEw2UFXYsTmpB5D5AyT3/sZ4th/dRZgabxi/EL3X7duLeg2ninM
xF0UWJCKx7cI4ykIGf3+XgrZgF1tTUg9jjWaWU41S5bUG1GLac1ftFsX9Y6ZzVVf
7AunA9eXl4MXn+hWGlYx9aREwvu+o6YpKaSdEVE64ki0u4gWAK2aJcJsFY0J90lJ
aUqNyjbvz04x7g5TgU0E2eVdQMf7ySrHs2L8FsXvw7xTeuicpisHVV9zr2pzFSFZ
sdxYGhK43vUbNXaDfGAP56EZRqtI6C/+Iz1r6oQfCF7KFh98Kp+HDj5hT/gjXU+J
CL1YiXG2lXQ=
=30/J
-----END PGP SIGNATURE-----

--=-PR0ouoNcVOki9KHppxMV--

