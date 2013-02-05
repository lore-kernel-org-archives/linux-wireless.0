Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:37402 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3BEJ7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 04:59:52 -0500
Date: Tue, 5 Feb 2013 10:59:44 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Subject: Re: [ath9k] spectral scan update: HT40
Message-ID: <20130205095944.GB7865@pandem0nium> (sfid-20130205_105958_008989_902F62C6)
References: <CAJ-Vmom4nwFJK+zaPsrs5ZfoJiJKueUn2xV4vYVRYqJyP90_hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
In-Reply-To: <CAJ-Vmom4nwFJK+zaPsrs5ZfoJiJKueUn2xV4vYVRYqJyP90_hA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Adrian,

thanks a lot for your update!

On Fri, Feb 01, 2013 at 11:02:00AM -0800, Adrian Chadd wrote:
> Hi all,
>=20
> I've been tinkering with the HT40 spectral scan data (in FreeBSD,
> obviously :-) and I can finally state that I have it working and
> working reliably.
>=20
> The notes:
>=20
> * The "MAC does silly things to the spectral scan payload" problem
> there is in HT40 too, so you need similar correction code for that.
> I've not yet committed that to FreeBSD, but I will soon.
> * The HT40 lower and upper FFT bins in the radar / spectral scan are
> just that - lower and upper halves of a 40MHz wide FFT.
> * .. but the RSSI in the RX descriptor is Primary and Extension
> channel RSSI, so you need to match them up correctly with what's
> "lower" and "upper" - ie, in HT40- mode, the primary RSSI is the
> upper, and the extension RSSI is lower.
> * .. and yes, this means you calculate the bin power separately for
> the lower and upper bins.
> * On AR928x chips, the spectral scan FFT is done on chain 0. I don't
> think that's changed in AR93xx series chips. So, use RSSI and NF from
> chain 0, don't use the combined RSSI figures.

Ah, OK, that's probably relevant for the ath9k part as well.

> * RSSI can be below 0 dB, so make sure you factor that in.
> * IIRC, RSSI from the RX header is in half-dB increments, so make sure
> you factor that in.
> * Because of the MAC corruption bug, you can't disable "short report"
> - otherwise you don't know whether the spectral scan data results are
> corrupted or not. So yes, you have to enable short report and thus you
> get one result at a time in a PHY error.

Could we (in theory) enable short report stuff for newer chipsets, e.g.
93xx and newer? I thought there was a fix for that in "latest silicon",
although I don't know specifics

>=20
> I've mostly working code in FreeBSD's subversion tree -
> http://svn.freebsd.org/base/user/adrian/ath_radar_stuff/ - look in
> lib/libradarpkt and src/fft_eval .
>=20
> I've begun fleshing out some documentation about spectral scan -
> https://wiki.freebsd.org/dev/ath_hal%284%29/SpectralScan

Excellent! That's provides a good resource. :)
>=20
> I'm going to work on the invalid packet length detection and
> correction, based on what our reference driver does and what Zefir has
> done. But once that's done, the basic data parsing and power
> calculation bits are done - I'll work on exporting it in a
> jquery-compatible fashion over a network socket so people (read: not
> me :-) can write some visualisation apps using HTML/javascript. That
> way both Linux and FreeBSD (and whoever else!) wifi hackers can
> leverage the same visualisation apps when hacking on this stuff.

Again, thanks a lot for your work! I'm currently busy with a few other
things and probably won't find time to work on the 40 MHz spectral in the
next weeks, so if anyone else wants to pick up here - the code has been
prepared for that. :)

In any case, please keep us posted, and keep up your good work!
Thanks,
	Simon

--U+BazGySraz5kW0T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEQ2BAACgkQrzg/fFk7axbVkACgtDrK1YvBsjz7tTpAppDUkGze
znYAnRi1ExJgVOuvsBjDetg8onU4+DJv
=S6P0
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--
