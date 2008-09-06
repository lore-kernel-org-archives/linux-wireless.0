Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56751 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYIFW0o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 18:26:44 -0400
Subject: Re: [RFC PATCH 2/3] mac80211: disassociate when moving to new BSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220739259-16918-3-git-send-email-tomas.winkler@intel.com>
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220739259-16918-2-git-send-email-tomas.winkler@intel.com>
	 <1220739259-16918-3-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Lhlu3wNcIT9852Fajzka"
Date: Sun, 07 Sep 2008 00:26:39 +0200
Message-Id: <1220739999.21016.8.camel@johannes.berg> (sfid-20080907_002647_342175_44690DF4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Lhlu3wNcIT9852Fajzka
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-09-07 at 01:14 +0300, Tomas Winkler wrote:
> This patch cleans current association when leaving to new BSS. this is
> needed as old configuration and data were still stored in station table
> and in low level driver, causing problems (e.g. 11n mlme) in new BSS
>=20
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  net/mac80211/mlme.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index ba255e2..aa5367e 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -3414,9 +3414,14 @@ void ieee80211_sta_req_auth(struct ieee80211_sub_i=
f_data *sdata,
>  		return;
> =20
>  	if ((ifsta->flags & (IEEE80211_STA_BSSID_SET |
> -				IEEE80211_STA_AUTO_BSSID_SEL)) &&
> +			     IEEE80211_STA_AUTO_BSSID_SEL)) &&
>  	    (ifsta->flags & (IEEE80211_STA_SSID_SET |
> -				IEEE80211_STA_AUTO_SSID_SEL))) {
> +			     IEEE80211_STA_AUTO_SSID_SEL))) {
> +
> +		if (ifsta->state =3D=3D IEEE80211_STA_MLME_ASSOCIATED)
> +			ieee80211_set_disassoc(sdata, ifsta, 1, 1,
> +					       WLAN_REASON_DEAUTH_LEAVING);
> +
>  		set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
>  		queue_work(local->hw.workqueue, &ifsta->work);
>  	}

Looks sane to me

johannes

--=-Lhlu3wNcIT9852Fajzka
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIwwOcAAoJEKVg1VMiehFYTu4P/inUIYfZTzbWu7qDnfgDd/4D
XbDxDB8guVnjbBhEfHhO64BpdCDGhwSERPfyc1bM/iWoCL5CdsWcvyk8Zog+ZEVG
9Y+QU52KVsxnZmk6EzBHjm4VCnGfWMLB0BwO+SjON/yvpSBKAR3bJxxbw7Ng/B/s
D1lbsOxOQJ2u5Q8i0Kmvr94KH9Z8/yIgCsFk/Dgf8yzCrGpFAR7QjqUS62kpGZiz
Q8W29qyzhRkxgEL/dhHtCjfd8Vz9dS3TwS0H73UagmVhSBS7KiPoqcuviQf1BnER
4GQaCSXHXSrgRJHrkMYjG8qAG2c6D96wslOYIrL0cR1orV8DEnX69mD+Y07/mBvw
XPLg9wSlj3qnSxgU12OkNGBQIHHWlhyOquyAV/BMUsaLdh6RSpB5ufGWAUA7ADKs
3y92E5dXAvLXk6uWJkc+pynHd/kEdOv55dEscGOexeMRtxzXzhGMsyVbebnOZ+qn
QA4qvFAZTO6ef3D1/1sBRHp4LwKSGjrtZrcQCdGrarmhBPwFeCVlqLB5LPkap3ke
fnK1/R3Hz0nwlvqa1liwkJKKTTrOW3Zee1CIKBwXiaPdJuqpp7Yk5ivRqop2jhAU
XpnQDpVKW6Gtch2OGwfl4zpF7Qoj7TAFmnCQMN+8VBWqDcosZHjdYBXUoC1Rv4wl
DgYZ+MwjTbvX43nalCSm
=G0gF
-----END PGP SIGNATURE-----

--=-Lhlu3wNcIT9852Fajzka--

