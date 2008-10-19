Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbYJSK06 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 06:26:58 -0400
Subject: Re: Power saving on mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <87y70l59p4.fsf@nokia.com> (sfid-20081019_092443_483129_2042AF58)
References: <43e72e890810171810t1c65642g998db601cfe2a390@mail.gmail.com>
	 <87bpxh6t1n.fsf@nokia.com>  <87y70l59p4.fsf@nokia.com>
	 (sfid-20081019_092443_483129_2042AF58)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aE0xrl6hhgJVtS8urEVp"
Date: Sun, 19 Oct 2008 12:26:46 +0200
Message-Id: <1224412006.6324.45.camel@johannes.berg> (sfid-20081019_122716_043792_5F4E48FD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aE0xrl6hhgJVtS8urEVp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-19 at 10:24 +0300, Kalle Valo wrote:

> > Nokia is very interested about client side PSM. Currently it's only
> > on/off type, but I would like to see a dynamic version of this there
> > the PSM will be enabled when the data path has been idle long enough
> > (eg. 200 ms). I will be sending patches later.
>=20
> Oh, I forgot about beacon filtering. stlc45xx firmware (but no support
> in driver yet) supports beacon filtering in PSM mode, meaning that the
> beacons are not delivered to the host (not even DTIM beacons). This
> improves power consumption because the host CPU is not woken up all
> the time.
>=20
> I'm sure that stlc4560 isn't the only chip supporting this feature
> because it's quite essential in low power devices. I have been
> planning to implement support to mac80211 in the near future. Though
> don't know yet what is needed, I haven't investigated this at all.

I thought about it recently, it's fairly easy.

As a preliminary step, I'd change mac80211 to not trigger the timer
continuously, but rather reset it ever time we get a beacon from the AP,
so that the timer only fires when we haven't seen a beacon for too long.
This helps with powersave already because then we only wake up for
beacons, not for the timer too.

Then add a new flag to mac80211 hw description that says "driver will
watch beacons". This means that the code above that rearms the timer for
the future 'nothing from AP' check is skipped.

Also add a way for mac80211 to tell the driver after how many beacons
(or calculate the timeout in ms, it's convertible) it should tell
mac80211 about the situation. Finally, to make it possible to have the
driver tell mac80211, extend the MLME callback (ieee80211_notify_mac)

johannes

--=-aE0xrl6hhgJVtS8urEVp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI+wtiAAoJEKVg1VMiehFY2wcQALynqy2sC9205bsJR//YnH4e
7Z1Ee9Jitd7DFI5KM1pNuHu82PfEDbkybYzcO6b7TA6/+HkxAm0E9tyxY9svNbiZ
Zl/hmIMlMbfYAz2s8Z4IHCE7tyYCzcVpIkuLp/rjYKAsVXMH0ZK87joiepDrdfIc
gmmZFedVTmO/YpPgh16YPEVEHsUJqgfWewDir48JDjILDAFIbQs2ooBa6NYjOsaC
/o3hupYtVEq1az82zJCEkXCsEtp4ySSSIbVAaPC2J7GoRyyqxaKlwMCzFcC/GHAX
v8+rdgB0wgLQcNui0U+M+UE8p1/4kOw2+rF9W/lT4yuBewAe05ZcMSauKgJQw5G+
a1nHz4tOPr/+W6UIIpiGNGeIDUHUxsTM39/S99SaT3vhESGmonR2oI68yFd5uyRL
hBJme2CX+kDpGc9xB8+0SHxVaTZ5mxgMSWchzDOeEVgHY8o5nZ7FjgIZt6PuUadJ
73oGG4ycdP7RU2FNcXnRcYRnLne3G1hKGG9eMgmyD5ab01T8nAohuYGWuAlW/6LM
d8bhvbk307A8ctsAt2pCL0KavtguFS8b32+CiKPeE6tCn9KHUGr+hsGKmHEQntYY
VlN1EonfC/X3gLvYoOfRmu0GLQC7RZ/SKpWGL49wiJE5lXFNgvF7JOmw2sK9o5H/
hFXh/48BiLY+yZhm4Ibc
=9Czo
-----END PGP SIGNATURE-----

--=-aE0xrl6hhgJVtS8urEVp--

