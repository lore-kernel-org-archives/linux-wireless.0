Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:40513 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaA1Hao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 02:30:44 -0500
Message-ID: <52E75C4A.3030506@meshcoding.com> (sfid-20140128_083109_959297_1682169B)
Date: Tue, 28 Jan 2014 08:29:14 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: Re: IBSS can't beacon after rejoin / regression in TSF syncing code?
References: <201401241826.45121.sw@simonwunderlich.de>	<21221.57261.792711.70974@gargle.gargle.HOWL>	<201401271427.51372.sw@simonwunderlich.de> <21223.2785.44186.69761@gargle.gargle.HOWL>
In-Reply-To: <21223.2785.44186.69761@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bbxj7ihKQrIVMFQ9M1FtEae1VD9r3miok"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bbxj7ihKQrIVMFQ9M1FtEae1VD9r3miok
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 28/01/14 02:41, Sujith Manoharan wrote:
> Simon Wunderlich wrote:
>> Yeah, this patch works for my case. I'm not completely sure why we onl=
y unlink=20
>> for this special case (no stations & bssid =3D zero), I don't see why =
it would=20
>> hurt to always throw away that BSS and rescan on the next join?
>>
>> I'm CCing Teemu, who introduced this roughly 3.5 years ago ("mac80211:=
 remove=20
>> BSS from cfg80211 list when leaving IBSS",=20
>> 5ea096c0c85e80335889539899af9a4717976e0b) , maybe he can explain it mo=
re.  I=20
>> couldn't understand that from the commit message and the corresponding=
 mail=20
>> thread.
>=20
> I think we can drop the BSS when we leave an IBSS network. The only adv=
antage
> of not doing so is a slightly faster join command that is given after
> leaving - if there are more than 2 nodes in the cell, that is. But it w=
ould
> be prudent to scan and check if the network exists before trying to joi=
n it,
> so I'll send the patch for review.

Right now no scan takes place if you specify bssid and freq (+
fixed_freq attr). Then no matter if the BSS is already the scan list:
the join command will be fast.


Cheers,

--=20
Antonio Quartulli


--bbxj7ihKQrIVMFQ9M1FtEae1VD9r3miok
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS51xOAAoJEEKTMo6mOh1VAxEP/0py7kfTggVayCrefBEcgyPq
JCW2/MVxm5gBmX1vVWG635K7W71di8fzwrqonkl8Y+T4UrOuXUQ3qD387Xz17FR+
Ggb5jVduF/5/cE9jcTmN6J/TPDkGzzThDRYu0hF29OFiu8YR59hQDw6OL43jcWIB
mVcblGcNrnekmTQNtJGQbRqeOxq2qAp1ymynBYXhygUGocl66o5XzT2ylqi8yMKE
CGj0bkaLJwo9mqXA123h1kblr6m4C35hv5r9VdeAGxABu2h0pbPNy9aTpzsxtgoi
7BuNwkJwMVBtzru+aIemAc6ByoSZpp2qCPdQcpO9K1lI0WDWZMIH5g4OgSV17oBt
kDS8SPQhQgL4qh+j8rNPY4nNSASqSaAElhv43xcbGWD5n7BY0QYT7b/UFYNj7a7p
KmbHBki9e3+EdO8kY7wNN2aDHA/VNQnzLt+h5/FxpXfR94xsbb5F1DCjrXV97HEe
Zz86+3AW3HjLmpoHhB6NTESnF+ARlNiu8YsuKbpbu9oyjkgS3fy/szQDBWBIPZoW
vwVtlajxEqNWMRbbvnnjMvrewQwOOnt4cRJUF1g0fNoOjm+1rcglDMK3gv5TeHe+
rCRJ8DTRto/hBiSAMrjol3ThmK7uJkAOqpjge/irsJAC2iboMi1Ua8JX9t2+COZb
vkTioZbB8CsHg0Jw1YmU
=w8W2
-----END PGP SIGNATURE-----

--bbxj7ihKQrIVMFQ9M1FtEae1VD9r3miok--
