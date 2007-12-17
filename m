Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60763 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbXLQS02 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 13:26:28 -0500
Subject: Re: [PATCH 7/8] mac80211: A-MPDU Rx handling DELBA requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11979070791111-git-send-email-ron.rindjunsky@intel.com>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070791111-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-o7WIpmlmdcHKMTsUBfwY"
Date: Mon, 17 Dec 2007 19:26:26 +0100
Message-Id: <1197915987.4885.95.camel@johannes.berg> (sfid-20071217_182631_728061_0C8640E3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-o7WIpmlmdcHKMTsUBfwY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	params =3D le16_to_cpu(mgmt->u.action.u.delba.params);
> +	tid =3D (params & IEEE80211_DELBA_PARAM_TID_MASK) >> 12;
> +	initiator =3D (params & IEEE80211_DELBA_PARAM_INITIATOR_MASK) >> 11;
> +
> +#ifdef CONFIG_MAC80211_HT_DEBUG
> +	if (net_ratelimit())
> +		printk(KERN_DEBUG "delba from %s on tid %d reason code %d\n",
> +			print_mac(mac, mgmt->sa), tid,
> +			mgmt->u.action.u.delba.reason_code);
> +#endif /* CONFIG_MAC80211_HT_DEBUG */
> +
> +	if (initiator =3D=3D WLAN_BACK_INITIATOR)
> +		ieee80211_sta_stop_rx_BA_session(dev, sta->addr, tid,
> +						 WLAN_BACK_INITIATOR, 0);

Does this intentionally ignore the other cases, and if so, why?

johannes

--=-o7WIpmlmdcHKMTsUBfwY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2a/UaVg1VMiehFYAQIeEQ/+LpERHrLRPyJRmUp8AO+sQaxstV6AszaF
4yI/DYeEodqZ9zN8ccLztuEBgSZh50NlkoQFQlgMjF5pPhbXF2dB3arAzmSvUML+
m4an/E9/QAOaZOcvHHBI3bNQEs/3MOUnk6Wn9yTTxfHAD+IP4vljaxmqewhwq6Tx
4bpJWL61ci2WZcNo0DCv++NqLpqtBVEEwXuUtVroGrYEDEiskdqfsZ1SLd6Y6cU3
ea1nnTnawJSuJwihgxHrHTjJAoYwJXn4nbAOgo5BzoDYACo2++AB9fcjR85hkf/R
HjVGbUUKPsAUHMKllYNGd5GrN7tFrsNSnrfyIpmfgY23MRMffwemTm1lGxVn69cM
07RxNbKTdnoWPU98id3b7AIag2pOQo3TGj/o3FxTNvzV8rv/SQjpn+cTotIssiR9
hWpN52yMIlIXrFQAvBMngKAEThXxd7Jjl/gqub8zrYe1f0q3G4TzdKDkXKrt1FBs
WhAEOQbyBoU0m1qgRTQmdhLsrqMFok779QpxweYIRNTZavaSWNMeXaTJh1RWqgpe
2aFuk1OjylcsPOfJTXBxFylOcC+ZmAieByALLSIFirt2mFktUTiyrVLNA5Jt6MUV
M/teOQew+TuINw3OHjzpDxvB/TPcNsL25R7V4f6D+ewui4QWnns5g7zs15KIgzI+
KnZMIPeFAFs=
=Kzuj
-----END PGP SIGNATURE-----

--=-o7WIpmlmdcHKMTsUBfwY--

