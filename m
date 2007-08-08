Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:13401 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752983AbXHHH6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:58:00 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: probe for hidden SSIDs in pre-auth scan
Date: Wed, 8 Aug 2007 00:56:11 -0700
Cc: linux-wireless@vger.kernel.org
References: <20070807203315.GG3330@tuxdriver.com>
In-Reply-To: <20070807203315.GG3330@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1265889.lsN5W6nE26";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708080056.16195.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1265889.lsN5W6nE26
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 07 August 2007 13:33, John W. Linville wrote:
> The ternary conditionals are a bit ugly.  I guess I could recode it
> with temp vars initialized before calling ieee80211_sta_start_scan.
>
Something more like:

if (ifsta->auto_ssid_sel && ifsta->ssid_len)
  ieee80211_sta_start_scan(dev, NULL, 0);
else
  ieee80211_sta_start_scan(dev, ifsta->ssid, ifsta->ssid_len);

would be better.

-Michael Wu

--nextPart1265889.lsN5W6nE26
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGuXcgT3Oqt9AH4aERAoEbAKDcEOxpjwXf26QV8iusYSu+tXXnjACeNuBn
yX7L3de/v0lZpAoWQxhSObg=
=/H13
-----END PGP SIGNATURE-----

--nextPart1265889.lsN5W6nE26--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
