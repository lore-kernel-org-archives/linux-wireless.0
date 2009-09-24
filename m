Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33841 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbZIXRfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 13:35:42 -0400
Subject: Re: 2.6.31-git wireless broken
From: Johannes Berg <johannes@sipsolutions.net>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0909241737390.20846@sister.anvils>
References: <Pine.LNX.4.64.0909241737390.20846@sister.anvils>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zQP4/TBq1gZ1kWjoca51"
Date: Thu, 24 Sep 2009 19:35:40 +0200
Message-Id: <1253813740.3868.324.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zQP4/TBq1gZ1kWjoca51
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-24 at 18:18 +0100, Hugh Dickins wrote:
> I've noticed for a while that wireless is broken in linux-next, on both
> the machines I use it on (a Fujitsu Siemens laptop using iwl3945 and an
> Acer Aspire One using ath5k: both running openSUSE 11.1, with WPA):
> I hoped to find it fixed later, but no, Linus's git is broken now.
>=20
> Only found time to bisect it a couple of days ago (on the Aspire One:
> guess the other would show the same, but that's no more than a guess).
> It arrived at the commit below as the culprit, which from your own
> words doesn't seem like a very hopeful place to land :-(
>=20
> That commit does give me a "WARNING: at net/mac80211/mlme.c:1904",
> followed by "WARNING: at net/mac80211/mlme.c:2308" every few seconds;
> and those do get fixed later on (don't appear with latest git).
> But I think there's another problem that comes in later, because
> at this commit iwconfig does show my ESSID, whereas with later
> git it just says "ESSID:off/any" (I have not bisected when that
> change comes in).
>=20
> I expect you'll need a lot more info from me: please do ask
> (but bear in mind that I'm wireless and network ignorant).

Thanks. I'm not sure why you'd get the warning there every few seconds,
but I suppose we don't really care all that much.

I think you're probably running afoul of a bugfix that I did while at
the wireless summit, and then the fix to it made it in, but not yet the
fix to the fix :(

Are you using an encrypted network, or an open one? If it's open, can
you try this patch?
http://johannes.sipsolutions.net/patches/kernel/all/2009-09-24-17%3a32/010-=
cfg80211-fix-wpas-open.patch

johannes

--=-zQP4/TBq1gZ1kWjoca51
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKu63oAAoJEODzc/N7+QmanAUP/0WuwyDQX6WwvumXRbiGOSx6
3k2erulOYw1m/O6FdWOP/oUgNaTdkYZ/gptpfmvyfMXOCCFGWB0O2QGBN8Od7IqX
h8VUm/0M+FESOE7SjvnAJMAKYVUMlaEymvxvjgisrv1QJGmlCR03CBvWnwhgVFTU
J1oPXxqLRRNp0Ig63bfDi2/Fq5psazbhd+/8M7T2T++P3OwltybzvbOD6sdN0iyQ
sVPzenOYhTQmCVhNmyVPWyTYCUEvLFGTQDJVR/VnoMEkgJJtUvkhNILVbmkLNvV3
kaniwx6HMRNjZVQoagknuntAhVjqkgBYpns6ZhwQ4RxU/eCTypfeldfzJbAhPSi8
BUt2oc9YLehTcFY6QHB8zgMjLqdO5JHxBtatG0PQ5ltz82NH1RXcdN2zQMqfrKka
GHkRLYdQ2lD9ClQsGZYPxHBoAQT/j+i8MKzr7g4DnbVCKOeeoCHRxTWT484vJr4e
kPWSTon+1Lj8LZUbEIdBuLlbCm+bA320Kwz155H8hPSzZc4aOKox3+lkKtmJinjG
dRGwQd0NlrDjuXCchEVxr1LPwlaM68gDvHkeOFTrurMSAkQ/BTzWwty+rP6ql3Ay
v+vaR53PhmVb+5oal7Dol7Ga/EeKa9KUNHJcS/dX1owUBG+ClaypNda8UsC1lvlB
NjbLyNKggQqegWh5WGP3
=h9zM
-----END PGP SIGNATURE-----

--=-zQP4/TBq1gZ1kWjoca51--

