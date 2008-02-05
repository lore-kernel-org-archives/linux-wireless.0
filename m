Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57567 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbYBELI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 06:08:26 -0500
Subject: Re: [PATCH 2/2] mac80211: enable IBSS merging
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <bruno@thinktube.com>
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
In-Reply-To: <20080205104949.9379.61874.stgit@one>
References: <20080205104543.9379.47253.stgit@one>
	 <20080205104949.9379.61874.stgit@one>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-33VfSrU8fKOfQXOEW75Z"
Date: Tue, 05 Feb 2008 12:08:13 +0100
Message-Id: <1202209693.4395.29.camel@johannes.berg> (sfid-20080205_110832_391556_1A2FD585)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-33VfSrU8fKOfQXOEW75Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	/* check if we need to merge IBSS */
> +	if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_IBSS && beacon &&
> +	    !local->sta_sw_scanning && !local->sta_hw_scanning &&
> +	    mgmt->u.beacon.capab_info & WLAN_CAPABILITY_IBSS &&
> +	    memcmp(elems.ssid, sdata->u.sta.ssid, sdata->u.sta.ssid_len) =3D=3D=
 0) {

This needs to test whether elems.ssid_len =3D=3D sdata->u.sta.ssid_len
(before doing the memcmp to not overrun the frame).

> +		if (rx_status->flag & RX_FLAG_TSFT)
> +			/* in order for correct IBSS merging we need mactime */
> +			mactime =3D rx_status->mactime;

This needs to be documented (with the RX flag I guess) and b43(legacy)
should be changed to include the TSFT in beacon frames in IBSS mode...

johannes

--=-33VfSrU8fKOfQXOEW75Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6hDnKVg1VMiehFYAQImCxAAjWo8EnNH/oIqVCPekYLPS41CX9Yah56x
SSmJMu2fFL6fF1qSbq/nyGCSYcNiu01YJbqFRiqqgBLAaMm6Z/bOV42qT3UuKkFC
WQcTJqBITI8Hkpr5VBr/8HxJJyj0vevN1X4CLVvKAJmn/Kywhq5ZZzSI1d2+NFx/
sf/jtaOPJ5WOVHzcO/AM/oZmhKnLQYWO2P6MFvVu1I4FU0lbfcHJnYBIobyQcChV
TJCr+9YvSHkfBqmPjpq/3v8m2Xjx/wA1T9vhjE6wQsTgnlzgX6Nn1GTRbe5GwzFD
/Dfjmycz4fuZLmADU8hH1i3AecszHmPOkQdRFMmyQjcjNBVqnxpYdVOuVeUokAGF
0lqRkDNVBrpQT2ICBjXNMsOHtAQyM9shX6MHQZ5gtELSB3JkH0wUBD6mhrtTvpNW
V6iJXk6L3k39rtqAB6KIRELKjOb8SA1MST548mJmoiobWzpiTOMgSUa3LyBhbnqC
g1BG29/HQhjlckq3DrPxr+uqoASOMbdzX5rVsaXGDv6XWyUQfHYxKnw6/nRVBXf9
+UBf5nhR56MW6hikY8c8lNowHkya1/6MbRwIUURAvnhqVZtxkqzu7LxAAQbuA36R
zw/1aZIooa/X4+WK6SSSUXnsIb1UC4MmBCf6N5D3d3xbzimgjeV+AbofpZMeQjRP
f5iRdhywyRI=
=Vk9P
-----END PGP SIGNATURE-----

--=-33VfSrU8fKOfQXOEW75Z--

