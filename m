Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35537 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbYLIVUI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 16:20:08 -0500
Subject: Re: [Patch 2/2 v2] Add signal strength and bandwith to
	nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@googlemail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Henning Rogge <rogge@fgan.de>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812092058.32251.hrogge@googlemail.com> (sfid-20081209_205836_039420_8AF1B951)
References: <200811252131.30161.hrogge@googlemail.com>
	 <200812071917.07075.hrogge@googlemail.com>
	 <1228765415.22164.107.camel@johannes.berg>
	 <200812092058.32251.hrogge@googlemail.com>
	 (sfid-20081209_205836_039420_8AF1B951)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-X88J44czKYopA14VEFeQ"
Date: Tue, 09 Dec 2008 22:19:32 +0100
Message-Id: <1228857572.1029.28.camel@johannes.berg> (sfid-20081209_222012_008976_EAEF0DF6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-X88J44czKYopA14VEFeQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-09 at 20:58 +0100, Henning Rogge wrote:

> -		if (!(sinfo->txrate.flags & RATE_INFO_FLAGS_MCS))
> -			NLA_PUT_U16(msg, NL80211_RATE_INFO_LEGACY,
> -				    sinfo->txrate.legacy);
> -		else
> +		NLA_PUT_U16(msg, NL80211_RATE_INFO_BITRATE,
> +				nl80211_calculate_bitrate(&sinfo->txrate));

If you do:

if (sinfo->txrate.flags & RATE_INFO_FLAGS_MCS) {
	if (sinfo->txrate.mcs < 32)
		NLA_PUT_U16(msg, ..., calculate());
} else
	NLA_PUT_U16(msg, ..., legacy);


and add a big comment to the calculate function that it only works for
MCS < 32, I'm fine with it.

johannes

--=-X88J44czKYopA14VEFeQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPuDgAAoJEKVg1VMiehFYB9AP+wa1LrpOn+pVvkfNRgxnuzly
lSUfunCpFgO40q/0vGZ4cPY5sV3ppLGL4HJTQh9FKP1ce7gEL1IMx76cxMASZJvW
ATLq44kRSbkcI3qZziNti8r4IjvGrIHCjIM2no34kw0A8xk+NAoQPSN4UtEx5iwB
NunJhYulRc/deVBAJoYv+Vil5HMqjZUNWO2A6f3LpKYcYCXJAY4nMaTMXQ+zVvHf
beIhPSW7/Vc10oCDtMGPRHupdV+XfiR9bcPeK03eaPiUVXcQ3d9ThvAZW7lJkzNs
KZR+181t5wtE7mt7dCNF6HCLdhS7I7u+DQIZ7qxpdPo/JCrnEBPKZPdrxoMv8fW6
IFMRi2sFgSIxuFjNMoyS7sbD7Flg/dPiBbZeSa/apCpwE93wVRKjy9QOtYBzmWfs
ZvlhXwGHtkmfqzMSQm3HS7ZbfjnixqCXZjktipsGYs3pIBlTHk8o+0KITtDSyokM
humt68t4NGNlNiLLr4Is+O7seLcvqL68eARE6uJGPgClLZfYnCWfY4GAJxf0TczO
IUnT4lrtmB/iZry+nHMyqyFvdJJI56XgCMdTPp6PTKXuooh8Ayv4UbKezgw55VOw
UbyhUc+yM4XcP88AzqYB4bign9eSzBC7ZztcDGJ+Tb3MpQiJScMn4FBblGCJU7DJ
9Q5FIi7xNbWQnIEfzCsM
=Npue
-----END PGP SIGNATURE-----

--=-X88J44czKYopA14VEFeQ--

