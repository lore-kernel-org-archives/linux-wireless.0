Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53696 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172AbZJaKCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 06:02:45 -0400
Subject: Re: [PATCH 1/2] Allow scanning while in authenticated only state
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
In-Reply-To: <1256982381.3089.10.camel@maxim-laptop>
References: <1256939391.31271.11.camel@maxim-laptop>
	 <1256939549.31271.14.camel@maxim-laptop>
	 <1256967782.3555.69.camel@johannes.local>
	 <1256982381.3089.10.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EbkFh5ptUx/hxm0uEkTV"
Date: Sat, 31 Oct 2009 11:02:46 +0100
Message-ID: <1256983366.3555.119.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EbkFh5ptUx/hxm0uEkTV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-10-31 at 11:46 +0200, Maxim Levitsky wrote:

> > I think you just need this wpa_supplicant patch:
> > http://johannes.sipsolutions.net/patches/hostap/all/2009-10-26-12%3a59/=
deauth-on-disassoc.patch
>=20
> Nope, this patch doesn't help.
>=20
> if I remove the bssid_changed, then it seems to work when connecting to
> same AP, but still scan hangs when connecting to different.

Hmm, Luis said it worked when connecting to a different AP. But he got
assoc refused and/or disassoc from the AP

> The problem is that wpa_supplicant doesn't do deauthentication
> explicitly, and I was told that this is right thing to do. This confuses
> all the nl80211 and mac80211...

I thought Jouni committed that workaround. I'm still not convinced that
wpa_supplicant is doing the right thing.

> I also think that its best just to do both deauthentication and
> disassociation in same time.

But then why do we bother?

> Yet, I think this path is ok, that is, when you disallow scanning, you
> can be sure that wifi will be dead, and this patch catches the situation
> when it for sure will disallowed  forever.

True, in some sense, but the real problem is that the authentication is
lingering along. If we really need to clean that up in the kernel then
we'd have to time out authentication structs that didn't get promoted to
association, instead of just ignoring them like your two patches
implement [1]. However, since we put control of all this into
wpa_supplicant, I don't know whether the kernel really should be
required to clean up -- I was going to write "clean up after it" but
that's not true [2], you're proposing that the kernel clean up *while*
wpa_supplicant is in control. I don't think that's right, since it might
actually want to hang on for an authentication while doing something
else, for a while at least. How can we calculate an upper bound on that
in the kernel?

Now, I can kinda agree that we should allow authentication frames to go
through while already authenticated, but that's something quite
different although your patches here would also allow that in some
hackish way (by accumulating more and more authentication structs that
are then ignored).

Now, especially since you say that this still runs into problems while
connecting to a new AP, I think that wpa_supplicant should
deauthenticate from the old AP. After all, it wants to eventually
control FT and anything we do in the kernel will come back and interfere
with that.

johannes

[1] and that'd have to be in cfg80211
[2] Except when the interface is taken down, but that is already cleaned
up by cfg80211.


--=-EbkFh5ptUx/hxm0uEkTV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7AtDAAoJEODzc/N7+QmaiwsQAMhhRM9JvkTNUW+D7iZrAL2H
zc6gBXydZQEPMCGptmP74UoyjrJgHCM1b81RSFKyo1CD5sr1mbMEryuA3efAMikr
cIRa/VYGhJze/DMGubRjqaoLcmHOUzrPUh9fQMqcY5PVsvS3CqaG8zLFa2sw4w34
ss2Nt1KfASe0CC3fpJu0bDyhOqcqhWoQKzhQ3pwsD+KfBYCAmvntvXKdWqIejEy/
anwoHM1muTXVEq6I3Tg/mhjO/za2YdThj981DyK2OjC9RIi5UPlMm57fVmQRHBgw
98hG34tS1dXPaLrZdpga/ozEMIScCa8X112li4ywkadHnjqtxSLfhP4Q36BefeB3
4HxM2q3UPAz3+vsw1JXSqgf3OBdKSzxdaCY9geMvCLq3cWxSRqt+h2T9X1MuhL1I
emTvWB2C+8xoLyB0zclNWE4kQWEtRTUGcajC3D8yxfI2desMH0gr/eG9ona5ys7I
8yQMcqlHXUo7CWHc7ZAWBIECrSJFmkMtNfJNY6vxp3ima1EpPbgJwERt0DKqGWB5
oYYc3Z5Yj5m5ZRXKgKBxbOBchHlpR62az/xUcgUg4YyYKPWEvsmvK36a1N7EpXBi
wRBMIppKupdOY4MO+OWKrAVl2orjw2BtzGHPNC22X3pC0lX7+4yskOT6y42MQOjC
5PkqCW5jOZBM8w/FDCr4
=W1Ya
-----END PGP SIGNATURE-----

--=-EbkFh5ptUx/hxm0uEkTV--

