Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48942 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab0AUQcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 11:32:48 -0500
Subject: Re: [PATCH 1/1] mac80211: tell driver when dtim change detected
From: Johannes Berg <johannes@sipsolutions.net>
To: wey-yi.w.guy@intel.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1264089090-7014-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1264089090-7014-1-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-llljYdI/fJPWTxsc7Rg/"
Date: Thu, 21 Jan 2010 17:32:44 +0100
Message-ID: <1264091564.11396.58.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-llljYdI/fJPWTxsc7Rg/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-01-21 at 07:51 -0800, wey-yi.w.guy@intel.com wrote:
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>=20
> In current implementation, mac80211 send dtim_period update to driver dur=
ing
> association, but if no NetworkManager or similar application perform scan
> operation, plus tim_ie is not part of probe response; mac80211 will not g=
et
> beacon with dtim information later, then  mac80211 will not pass the=20
> information to driver for update.

Good catch.

> Call ieee80211_hw_config() with IEEE80211_CONF_CHANGE_PS flag set to
> allow driver make correct dtim adjustment if dtim_period change detected.

I don't think this is the right place or the right thing to do though,
this seems like an implementation detail from iwlwifi -- it only (and
maybe only it) uses the DTIM interval for power saving.

However, the internal power saving stuff from mac80211 should also be
recalculated if this happens, and then we can probably call it a PS
change?

johannes

--=-llljYdI/fJPWTxsc7Rg/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLWIGnAAoJEODzc/N7+QmauoAP/0cSirkDgtZvkQh9NeJ8Eb32
phgxvQzbcV9xJRiHQRHiBiP2fC3xQOLzH+/uou+K2PK92fE8RCds/rmVTzs8HSSl
zWysLN2seh9FBM1kpA/kC6TFfTl4CIX3yBYzKyKgR3x4qy9qWtd/6CO4on2J12f4
FfVCO6b1WSfznn6aIPlgrGWxrOwkSkMObITKvQ8htqL9XVwhcS+uvl41GlHF8mlD
MpObpnbqSmez3aAQImuE6ob4ccQYSBc7knfigxSZemtRPJy7Rz9w2Qt5Zi3YRqlb
eoBJHmwDZJJLeCkrPIflMHX3/zmzRUImcsN308Au+mgQF6CvOan9HX9GpKgWyhbw
MchX2shlnGI3n8JaU/vGSZ8cRQk1M0IwhUKEWjGT16Wyy3UoXs93B82fIuuMjicP
Xt4mAvrZGG3YVhzf4z88MMJaC67DibbSqowx/x6tB2R4TvxpGP3Nh2ngGvPe6kr9
xade3OdW8fbeK9Rc6SUPvPTBchGSZYYuuS5qObUOgVIr23qxBxjF26DvFoFElFk6
SSBw28Cmt2mDB/71fKCcnM07T3mWv195n3CjPDdjn+kn/FeYWQz+1+74fpAAuhOw
otn0/HDcaopncRKgB/rwtXmNmNkYsOTaJgPWQ1u5JxNwC1N6BxGOzHnu6eOuVgJX
PT8pBVYIkTf6RrIQF3vk
=cMh+
-----END PGP SIGNATURE-----

--=-llljYdI/fJPWTxsc7Rg/--

