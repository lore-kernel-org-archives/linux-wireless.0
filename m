Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:54850 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2LLKPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 05:15:12 -0500
Date: Wed, 12 Dec 2012 11:14:15 +0100
From: Antonio Quartulli <ordex@autistici.org>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] cfg80211/nl80211: Enable drivers to implement mac
 address based ACL
Message-ID: <20121212101415.GH3458@ritirata.org> (sfid-20121212_111527_136292_E58114F5)
References: <1354880763-12309-1-git-send-email-vthiagar@qca.qualcomm.com>
 <1354880763-12309-2-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PPYy/fEw/8QCHSq3"
In-Reply-To: <1354880763-12309-2-git-send-email-vthiagar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--PPYy/fEw/8QCHSq3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Vasanthakumar,

On Fri, Dec 07, 2012 at 05:16:03PM +0530, Vasanthakumar Thiagarajan wrote:
> This patch enables drivers to implement mac address based
> access control in AP/P2P GO mode. There is a new flag in
> nl80211_ap_sme_features (NL80211_AP_SME_FEATURE_MAC_ACL)
> for drivers to advertise this capability. There are two acl
> policies, white and black list under which an acl list can
> be configured in the driver. Driver has to advertise the
> maximum number of mac address entries in acl list through
> max_acl_mac_addrs of wiphy.
>=20
> Driver can enable its ACL either with the initial list passed
> through NL80211_CMD_START_AP or a list passed through
> NL80211_CMD_SET_MAC_ACL. ACL information passed in these
> commands is an array of acl configuration containing acl
> policy and list of mac address. With the acl policy as
> NL80211_ACL_POLICY_ACCEPT, driver will accept Auth request
> from any client matching any one of the mac addresses in the acl list.
> When acl policy is NL80211_ACL_POLICY_DENY, driver will reject any
> Auth request from the clients having their mac address listed in the
> acl list. Driver must make sure to clear it's acl list when doing
> stop ap.
>=20

I'm curious about this feature: at the moment mac ACL is implemented and wo=
rking
in hostapd. What would the advantage of implementing this in the driver?
I don't think this can be offloaded on the device, so the advantage is that=
 this
would move the ACL mechanism from the user to the kernel-space? Or am I mis=
sing
something else?


Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--PPYy/fEw/8QCHSq3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQyFj3AAoJEADl0hg6qKeOPxcQAIqblytqbaA139LYaLuY+vCz
A0+xgitXa4ldYEj9LFWWKCNe509F1k7fhCfQAxopHkDhNeXZU4juU1rZ/StBNFkj
QQW996CJbJT1zBTJxMffh63UejEqOHcGm/os7iAeyjO4DHkrW2lhMk0Y+o9YU34U
0Sv/D8pVjAdNaYA5/3PJz0+weBG16i9kKl3/qRrJyVOgFcIn309ju/OqIJnEuLrN
v68T8YqnUuTFLfqzHvnFSVJQWJf51V8TiZp3Je6WOAaJe9nj+Ae3H9304zbVmc2X
QvtXYbdq+23NtZZ4vMXM1M+ppBL6lExm3fxSiHlFRmawU0s2ILcOaVdiss8I4lMA
UycNsODbYjVOdZDsJNmqgNgPN0GjYLeDd5bjfyo1uDSk3m+SHmTPE6UsBKxJmn+N
qFT7kFkFSHc9X99Tn6tlFjBCGfjFPWPLZZntqhbPUXzb1qR03+OEfY4/f5tvl7uA
IO/NrmeezA9jHCOcytKR1w0Ii2JPVJf7TfVCaUSzUPH16aUdJXhzuLK9DcgwDcA9
Rwmlsx7PUl1lKuR3TzfjWr8XB4Wwdf3BOTFOselaNoiebxVjPbTR/AwZlSbSogYV
J07qmhTG48///VLrXxfut3QslNtIrxFPx5TWyPndhYNstaE8QPEiZWVCAwb1aNv0
9RVUxZ4ON+kIrjMH0ilk
=snzq
-----END PGP SIGNATURE-----

--PPYy/fEw/8QCHSq3--
