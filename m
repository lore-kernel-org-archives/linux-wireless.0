Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbYE0RZa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 13:25:30 -0400
Subject: Re: [PATCH 1/1] mac80211: sends HT IE to user level through wext
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Tomas Winkler <tomas.winkler@intel.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <20080527172032.GN4932@jm.kir.nu>
References: <1211907611-27979-1-git-send-email-tomas.winkler@intel.com>
	 <1211907892.3930.19.camel@johannes.berg>  <20080527172032.GN4932@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oHuZ378yKw2aVBDPSnUA"
Date: Tue, 27 May 2008 19:24:15 +0200
Message-Id: <1211909055.3930.23.camel@johannes.berg> (sfid-20080527_192533_298143_C8BA74F1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oHuZ378yKw2aVBDPSnUA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I would prefer to get all IEs in one blob (assuming WEXT does not have
> length limits on this data that could be up to about 2250 bytes long).

Good point. That should actually be doable quite easily.

> This would avoid need to add new IEs one by one in the future (e.g., for
> IEEE 802.11r).

Yeah, precisely.

> wpa_supplicant should be able to combine multiple IEs (or even multiple
> IE groups) together, so I'm not too concerned of this being done
> separately, but in general, it would be simpler to just pass all IEs as
> a single blob. It might even be worthwhile to start storing the IEs as a
> single buffer and have helper functions to fetch pointer to the
> beginning of whatever IE is needed in the MLME code (this is how the
> current wpa_supplicant processes IEs from scan results).

Actually, we do store them in one blob and then hand out pointers to the
various parts.

johannes

--=-oHuZ378yKw2aVBDPSnUA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDxDvqVg1VMiehFYAQIGJg//W6ledNiOI8EhtbV1dt/uJQGfbeFdieeg
oqZ837Wy4NkChWQzlJTUplvH/UUrJpiX1yTJc+EwQPzgJVuTvx/cQM01ATA7Lm6Y
nax9803QdOJLvUmxeemCSDM7Hl5/4G7AV3qjyQ+orAr5AzmtmidvfkxV+2wJDG7Y
akBsBBNMR+RTN8UyurwACxcVQLWqrdv2E9qNt9540t128Nd9Lxyvb48Nuq7U5da7
q82P1OVLorOSbKZjut88EkH5enKpgbE1GetEnNBSSZTl8lPwY0JgFlvYQPMQup8u
/kbCnSg8CfMZC4FuA3KC9RAeRwJTJET3CWVH7UrQ5njab5olnqnqRyF9tlE7cjBa
LSNrGm8sgSPgfGqv/oQRg7j/8tnEIhv/Szhr31F9jNVoRGeMwiqipSbOTD0OrW2z
lo32FIbOnynVDHAGZ2SsIhemADjjURckkeJCEk8wTsADcTGGiR1m5hnzFsq2FVpB
8C/dshkC5lDdechYlZS+ctaK/WPdO+0lNf55c5iLcEOTOgLaLkxqzEgAodEts6QZ
lek2Yb/+IcdQh7ujvV0lHKXd9ZPbXjO0NgFSd+VfOAMJNrWyJFE6+FBNvIeUXXq0
eRBNzKmdeQQ5ocBf6MT4yb57MfeRdPE/OaQo8+x/kT1mFxvQ0C2LfrDUCo88k8m/
X48ZeXEX0ng=
=/9Vh
-----END PGP SIGNATURE-----

--=-oHuZ378yKw2aVBDPSnUA--

