Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbZDEI6f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Apr 2009 04:58:35 -0400
Subject: Re: [PATCH 1/6] wl12xx: update to 2.6.29 mac80211 hw scan API
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: kalle.valo@nokia.com, linux-wireless@vger.kernel.org
In-Reply-To: <1238897428-19639-2-git-send-email-me@bobcopeland.com> (sfid-20090405_041128_490081_5FFF7983)
References: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
	 <1238897428-19639-2-git-send-email-me@bobcopeland.com>
	 (sfid-20090405_041128_490081_5FFF7983)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gyQj0OZ3vj3a6M9QA6sN"
Date: Sun, 05 Apr 2009 10:58:26 +0200
Message-Id: <1238921906.3782.5.camel@johannes.local> (sfid-20090405_105838_813990_B6859D5D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gyQj0OZ3vj3a6M9QA6sN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-04 at 22:10 -0400, Bob Copeland wrote:
> The ops->hw_scan callback now takes a struct *cfg80211_scan_request,


> -static int wl12xx_op_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t l=
en)
> +static int wl12xx_op_hw_scan(struct ieee80211_hw *hw,
> +			     struct cfg80211_scan_request *req)
>  {
>  	struct wl12xx *wl =3D hw->priv;
>  	int ret;
> +	u8 *ssid =3D NULL;
> +	size_t ssid_len =3D 0;
> =20
>  	wl12xx_debug(DEBUG_MAC80211, "mac80211 hw scan");
> =20
> +	if (req->n_ssids) {
> +		ssid =3D req->ssids[0].ssid;
> +		ssid_len =3D req->ssids[0].ssid_len;
> +	}
> +
>  	mutex_lock(&wl->mutex);
> -	ret =3D wl12xx_hw_scan(hw->priv, ssid, len, 1, 0, 13, 3);
> +	ret =3D wl12xx_hw_scan(hw->priv, ssid, ssid_len, 1, 0, 13, 3);

This will work for mac80211, but only by accident, and will not allow
userspace to request directed scans -- you need to add
	hw->wiphy->max_scan_ssids =3D 1;
somewhere. Supporting scan IEs would also be good, if possible.

johannes

--=-gyQj0OZ3vj3a6M9QA6sN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ2HKtAAoJEKVg1VMiehFYDesQAJIMI0guskM0LJnbfnaVWXPM
Ku165vIuwEeQ80VW2PHwUYqZKTsTTtVoYI/FGaejZg5XmTHlV8G5kbveK2Cxe6uP
0TB4gdwrMHe/DRVwj5kPRSDAnqFOa3GSlU2sgqvap4Jz7irQptBvIKCl4znT8Y0l
HiPRZdNvXpmKnnrn+H0qmLLSKDW8Wz4HdviAWI5V1fXb8jhC34kvgffxjXdLaPfW
QYshXwb90yXv59o2b4rk5NWcunXu1RlQHCgx12WaYqU1WuQEI57gZ182uf5Wh1oQ
zlehBlAyqeaaqTFS07DBzn0zhWj8+GNhBc7T982R5sDNkJToJQdWh/ueIFBFtqKr
ZchAvtwRr7yxSf6g3CYm/iD28XFswyAcksA4UXlTd5geeUTHH1zvYVg13rZemjvy
/iq8FyxOtu4JLClX+/Bq33TWYq3DpxtT4dPEnIYnJV+VB8H8wtm/+cSZHMBEbEsR
avAdIevmEf6QY+EBMV1PbGXKYbt4wLwgZ6HOpdKs0S9DBXbglGOA6QX7cKIBxnU0
EyDYeQRENY79VqPPsj84xSs+Z8nS0SNJofkD27zYF/pCanD7VsqReBGPx2EDO02Q
3aic0e/fwTYu4AHnvFo+hvha9uy8rirlzvCipT4tD15XrDeGiXLW8JMToNCrUba4
eQWjodaCicsDN/6u4GPN
=foYU
-----END PGP SIGNATURE-----

--=-gyQj0OZ3vj3a6M9QA6sN--

