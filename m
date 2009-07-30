Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53958 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZG3Hnm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 03:43:42 -0400
Subject: Re: [PATCH 2/2] cfg80211: decouple regulatory variables from
 cfg80211_mutex
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1248914792-6010-3-git-send-email-lrodriguez@atheros.com>
References: <1248914792-6010-1-git-send-email-lrodriguez@atheros.com>
	 <1248914792-6010-3-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-o4+ppf6iQOk9fKrrFBV7"
Date: Thu, 30 Jul 2009 09:43:01 +0200
Message-Id: <1248939781.8925.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-o4+ppf6iQOk9fKrrFBV7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-29 at 17:46 -0700, Luis R. Rodriguez wrote:
> We change regulatory code to be protected by its own regulatory
> spinlock and alleviate cfg80211_mutex to only be used to protect
> cfg80211_rdev_list, the registered device list.
>=20
> By doing this we will be able to work on regulatory core components
> without having to have hog up the cfg80211_mutex. An example here is
> we no longer need to use the cfg80211_mutex during the country IE
> regulatory hint; by doing so we end up curing this new lockdep warning:

This is ok with me, but be sure that it changes the API between drivers
and cfg80211 -- the reg notifier can no longer sleep now.

johannes

--=-o4+ppf6iQOk9fKrrFBV7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcU8CAAoJEODzc/N7+QmaDhkQAKyVrCtv020j7u+GzSIiBG/1
+BNsHRzmgkDPyegK/3gYZrYnW1cikNQpVFgNcRs4M28xYJRG0Tz4kstS8t9Mb3Yl
9eR17opWUko7zqB2T0wwWPDwspjpoVg6JHjbSpadDnamNs0U4oHtb/WrG7XP9K65
2f/FXV92413cryenLhaTHEfv2V2wGEDxG76IxosjMRzYHi5iFm+77+xyr1DbbziY
4XBFkjdjCt/S5KJ86uSlKhZ1D6JgG8oee7t+ux4Goe9qhWSV89Lda/NKLD6jEais
++T7196OxI14AXOjipqr1F0ZfMyLscSORmfWfQVe4a7k8piCNm+qDVd2DpEG+bv0
cuWtw0aGW08dkpIPP8kaG8towJAgwlaVcntHSAN+YKkZkjdRx28EQbpLPo+Xt2yN
ldx9o5b11eF26OqTAam3b+iftDHs3z2JT42hcvJxCZOR3r3sEGrRhWPFJMaYBsD3
SQCLePps9DS/VIacA0Hrl+TA2xij1RtM1wNVLDUpennA+Xex0iEfyS9pCxkP4m41
IFhAOZGt6vHBzHxbURMfUdpNYIHD7VF/XFOJCeaV/j9KCuG0CtimSUcx6V8oGMtO
2jsybk/Ksu9QfxsbwU87NiykeM8Foi2tmN8ZTY9yNd4OK+UhXmeBCYj8QreElPl1
qoFyWlVDCMtsP7aK8CKS
=B/hQ
-----END PGP SIGNATURE-----

--=-o4+ppf6iQOk9fKrrFBV7--

