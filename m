Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:19061 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754722AbXKAT1A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 15:27:00 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: use IW_AUTH_PRIVACY_INVOKED rather than IW_AUTH_KEY_MGMT
Date: Thu, 1 Nov 2007 15:22:58 -0400
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Dan Williams <dcbw@redhat.com>, dragoran <drago01@gmail.com>
References: <1193671155.5197.71.camel@johannes.berg>
In-Reply-To: <1193671155.5197.71.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5798557.EWhWmnDVed";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200711011523.03063.flamingice@sourmilk.net> (sfid-20071101_192705_918024_D36D65EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5798557.EWhWmnDVed
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 29 October 2007 11:19:15 Johannes Berg wrote:
> -	if (ieee80211_sta_wep_configured(dev) !=
> -	    !!(bss->capability & WLAN_CAPABILITY_PRIVACY))
> +	privacy = !!(bss->capability & WLAN_CAPABILITY_PRIVACY);
> +	if ((ieee80211_sta_wep_configured(dev) != privacy) &&
> +	    !!((ifsta->flags & IEEE80211_STA_PRIVACY_INVOKED) != privacy))
!! for the wrong set of parenthesis, AFAICT.

-Michael Wu

--nextPart5798557.EWhWmnDVed
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHKieXT3Oqt9AH4aERAg5LAKCViYoJO+9YxOZlCmHNcgil4mFYXgCdENr4
fUpwmTy+9lTh6r/1BI8Y4QM=
=wvJA
-----END PGP SIGNATURE-----

--nextPart5798557.EWhWmnDVed--
