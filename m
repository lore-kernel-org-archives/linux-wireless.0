Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48966 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbZHMJyq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 05:54:46 -0400
Subject: Re: [PATCH] cfg80211: set SME state machine correctly for roam
 event
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1250155399-17847-1-git-send-email-yi.zhu@intel.com>
References: <1250155399-17847-1-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tX4zDJOnzvSvjolNYGca"
Date: Thu, 13 Aug 2009 11:54:09 +0200
Message-Id: <1250157249.21250.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tX4zDJOnzvSvjolNYGca
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-08-13 at 17:23 +0800, Zhu Yi wrote:
> When we receive a successful status in CFG80211_SME_CONNECTED state,
> it is a roam event. We should mark it as a success result.

But there's a cfg80211_roamed() call for that? Can the driver not tell
the difference? It also sends a different event (ROAMED rather than
CONNECTED) to userspace.

johannes

> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  net/wireless/sme.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index 8e2ef54..1aa1190 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -393,7 +393,8 @@ void __cfg80211_connect_result(struct net_device *dev=
, const u8 *bssid,
>  	}
> =20
>  	if (status =3D=3D WLAN_STATUS_SUCCESS &&
> -	    wdev->sme_state =3D=3D CFG80211_SME_IDLE)
> +	    (wdev->sme_state =3D=3D CFG80211_SME_IDLE ||
> +	     wdev->sme_state =3D=3D CFG80211_SME_CONNECTED))
>  		goto success;
> =20
>  	if (wdev->sme_state !=3D CFG80211_SME_CONNECTING)


--=-tX4zDJOnzvSvjolNYGca
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKg+K+AAoJEODzc/N7+QmaNJ8P/1bHDHUrDoPvFTQML42YTrIw
zEyEqxFZKNkm7bzdRJhNFqHN3pTVaVif+scy12PW8mvRQFHfylkheI5BPsn4MEjf
W5revfUcfuomJGBdvUdF/owEeM6MWIqOhfSX7emBHRPDWVpiVcM35ac5wayDN4ZB
pMKPdPTYz9CAykjqQJY77rJ1sN11KajwxuXQM9r5RmcY+UIp0+T+RVuz8akC3G/f
YANNwJxfRvQ5SD+EGVQAj2JXlbj+EnhLkgNBJ3U4+0l2FCmfD6jvnP+oQsW/inuO
reb3SravFVyXmRwHpxa/q+RQnzUyC2qAlVRq6PeDFitB0JPqN6m94+PLsI31wK7S
Deug/EZOz6TL2hLsgNuYz89IrYwdWyG24ADi9wI982TVRFlGUwYZj0mloD20PZq3
mcFXpq+OaRclxzaFpE1KK7w6W1ugFGm8evA3DbejC2+xqy68cLnrP51ZqNH85nyN
qTbeOU9Wejz5lp9zoG2jFEn7QI6bExQe5GWJIjI4YpZgue65e5NoWF4/te5qDlV+
XCnn92jwIduJG/WX8Hw2HHVZPECnkJVOQsI0dcnViHLRpJCrd1ghhxmYSrFFdytn
LnvkpLcXLYoUR3xH4Of1xJcWRQwLftW/ILrpf+qml0N+vUlHQ2KwJX4L3hi+o92M
DPYTHbowO5ltX//1ZQkS
=2pzf
-----END PGP SIGNATURE-----

--=-tX4zDJOnzvSvjolNYGca--

