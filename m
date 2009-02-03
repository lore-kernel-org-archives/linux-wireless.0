Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbZBCKY1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 05:24:27 -0500
Subject: Re: [PATCH v2] mac80211: Remove bss information of the current AP
	when it goes out of range
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090203101911.GC8246@vasanth-laptop>
References: <1233635989-20664-1-git-send-email-vasanth@atheros.com>
	 <1233655853.5460.0.camel@johannes.local>
	 <20090203101911.GC8246@vasanth-laptop>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vTRu2UWenPsyIto0l70z"
Date: Tue, 03 Feb 2009 11:24:21 +0100
Message-Id: <1233656661.5460.4.camel@johannes.local> (sfid-20090203_112431_633401_773C0A7D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vTRu2UWenPsyIto0l70z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-02-03 at 15:49 +0530, Vasanthakumar Thiagarajan wrote:
> On Tue, Feb 03, 2009 at 03:40:53PM +0530, Johannes Berg wrote:
> > On Tue, 2009-02-03 at 10:09 +0530, Vasanthakumar Thiagarajan wrote:
> > > There is no point having the bss information of currently associated =
AP
> > > when the AP is detected to be out of range.
> >=20
> > Seems sane to me. There are a few other places I think where we hold on
> > to the bss info way too long, in fact, we hold on to it _forever_ most
> > of the time.
> >=20
>=20
> Yeah, we hold bss info when we get direct probe timeout, auth timeout and=
 assoc
> timeout. I will remove bss in those places also n the next version.

Not just that, but also when we've found a BSS and never connect to it,
we'll never time it out. It's nothing you need to fix though, I'm
perfectly ok with just putting this patch in as a start.

johannes

--=-vTRu2UWenPsyIto0l70z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJiBtTAAoJEKVg1VMiehFYPJ4QALn9dWlEtyI+LDnWKfWogYac
x/02nJirloL42lGlzbW1uA6k+N3VAN4hVYbDHB696n8MgB/ExoEFIMDR0bfubGsX
dXuR16u2bHkMI+hjDctmwGePU8Zq3hqsHASHnZTBZdF2IRsttinsLvAFYB8MTOJp
DgZ6QoijtYXPP5j/uaCy3yqn07kxu4h3IZAaZY7xH+d50gjLLRpnXWaGES1VUacr
P+S5yQrzzcOZP3yjAFBd4jUcHrtFuVismqjcRGT9meMHvAIGuPPBkHS4SyAEK3MR
YssxBZbi1C2crQlWjs3SJPSXV0cA5RItnD2iubBgjbusPt6FlrPS1BqyuMNR0dEZ
Kx90OQxd4k4qhc+69XolKtOLJJzYmTPjS+z4fseijRkQbZEcVMdHe0ngvO49LVWS
sNxzeifU0B5rvbaXzfxQu8xBLxB/vn6t1Kf4G0VvEk7nrqgbugjLqk0M1HXBMxEe
DCrveJHVGdEeg19uK/A71wjrItHNVg6tn9yw1zbT34NrEc96+nE/633Q0TtBAyba
NJEY+4KimeE2O+OlV1xdLZ/nijZ6L/lifwFXVqsc1K0aTxtxNINauMJeLMNK6LmQ
gyAcR5m6pISISLve+iuabA7ci++OnP2SG1n470DwrW+J+sLcWa5UaI2Fr2GsnugH
y5LoO6yJpa10hIIiIs8f
=BZy9
-----END PGP SIGNATURE-----

--=-vTRu2UWenPsyIto0l70z--

