Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57076 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbYIPLI1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 07:08:27 -0400
Subject: Re: [RFC V2] mac80211: re-enable aggregation on 2.6.27
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com, ron.rindjunsky@intel.com,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1ba2fa240809160217i4f57132ck76d5b532a56a4131@mail.gmail.com> (sfid-20080916_111801_447750_AEB8169E)
References: <1221550508-3338-1-git-send-email-tomas.winkler@intel.com>
	 <1221552471.8916.17.camel@johannes.berg>
	 <1ba2fa240809160136w7af27d48ud979c0e3d68b933@mail.gmail.com>
	 <9f26451d5e126b98b80e38137152ef55.squirrel@secure.sipsolutions.net>
	 <1ba2fa240809160217i4f57132ck76d5b532a56a4131@mail.gmail.com>
	 (sfid-20080916_111801_447750_AEB8169E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TrRMHrbPQg7z9y2cnFTc"
Date: Tue, 16 Sep 2008 13:07:37 +0200
Message-Id: <1221563257.8916.23.camel@johannes.berg> (sfid-20080916_130830_510282_16065275)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TrRMHrbPQg7z9y2cnFTc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-16 at 12:17 +0300, Tomas Winkler wrote:

> > ath9k is sw scan. I just had another idea, it might be possible to do
> > everything under the sta spinlock to avoid having to stop queues, but I=
'm
> > not sure that can work out.
>=20
> Are you cooking any code?

No. And forget the sta spinlock, I don't think it can work after all
since you won't know that select_queue hasn't just returned and
hard_start_xmit isn't invoked yet.

johannes

--=-TrRMHrbPQg7z9y2cnFTc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIz5NzAAoJEKVg1VMiehFY1DIP/AqdCufcdGQEn7fMzo0KSRek
T1yzGDLGFqgyrV+SJKpP4Y+BN6Z/3J+F+L+71JoKeQDyTFsfe3QGXO+a7ROmuXTj
G/Zygjp1+35BPbrIj8+J4jRlzjFubpaZ4s4LnE/U4XDeeVc/Xkq/1A7FVgpsA/a/
iGBj49Gz9spXk2BBeso+ALITYHlv3cMayqGY55jnEZEU2HmgQp+vfBtGezc6kY4f
UCa5JVtynPGmh/DxFGkbMjap7xeJ9dewAcjB0fL6vSe+8TMZyPd7I4uL2y0GdJug
e9y4RFBiUs6QZRG+QMWBOKvlRDJ3W11Ljcu4U2e6Az4D0iOS1dFjWerZm0dA2C5A
a3xfRqHGB7HF7L2wt8WuZ+PEVwzxUcg95leGql+8KkHQR0pCESrX5NWpzR/Bp4so
EWhO+Xt9w0OxYqGw5W84Usn8rV8lOW8CvlB3/6BDOuI1H7z71pygddualWdu4Fmj
fZKSFN43Yus7CO/saCTUffn+dO+bAqSIbwfQK/WLRe58A8hU3YI4aGituULeaq62
RrOefQ3UWHZPlxyf1ndqGXsRD5W72R9zfWGaMsKS6mm1/WFKYsorRIljvqrIcZWX
XyKdDaNKZCEofcofIoywoLtaGU+/drkSt5jWEmEPyUQ6sGLguRtYMKMB8kISV1pr
XDzKlM6FMO6+C0xIhZbV
=Z/Tj
-----END PGP SIGNATURE-----

--=-TrRMHrbPQg7z9y2cnFTc--

