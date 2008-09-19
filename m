Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbYISDmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 23:42:31 -0400
Subject: Re: technology preview: scan with cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Dan Williams <dcbw@redhat.com>
In-Reply-To: <1221794329.10419.9.camel@johannes.berg> (sfid-20080919_052010_602864_D520EF40)
References: <1221794329.10419.9.camel@johannes.berg>
	 (sfid-20080919_052010_602864_D520EF40)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gHMMh4QsXT31el99NnqY"
Date: Fri, 19 Sep 2008 05:41:55 +0200
Message-Id: <1221795715.10419.15.camel@johannes.berg> (sfid-20080919_054235_013037_F5932A85)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gHMMh4QsXT31el99NnqY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-19 at 05:18 +0200, Johannes Berg wrote:
> This is totally incomplete:
>=20
> cfg80211 needs to
>  * actually hash on the BSSID instead of putting things into a list
>  * provide BSS list functions so mac80211 need not keep track
>  * allow a "private" area in each scan result with hw-provided size
>  * handle mesh properly
>  * provide a way for the hw to limit the number of SSIDs in a scan

 * provide a function to just pass in the whole beacon/probe response
   frame and pick it apart itself
 * handle aging
 * provide a wext "set scan" hook that creates a request and passes it
   off to ->scan(), provide wext "get scan" hook
 * parse the supported rates into a bitmap like mac80211 does now, based
   on the bitrate information the wiphy provides

> in mac80211, we need to
>  * pass the scan request to the hardware offload
>  * handle multiple SSIDs in a scan
>  * use BSS list stuff cfg80211 needs to provide
>  * handle active/passive properly

 * use all those helpers I mentioned above

Also, we need to think about
 * how fullmac stuff can integrate, can it provide this IE-based
   information, and if not, is it feasible to just synthesize it?
 * whether this should really be per wiphy as it is now, or somehow more
   per netdev, or not related to a netdev at all...

johannes

--=-gHMMh4QsXT31el99NnqY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0x9/AAoJEKVg1VMiehFY83wP/1RwT6WW4r994qS44PnF+XbR
yVG0l+qJEP8dIo6W7fPk7L6/zen4fcWbZzspzzavAMzDrbtELIXAX0fk64T8dP2E
/oAubwajOX0k3+ZbVRcwLnogM18J4z+Db6y8Wo31lZIwQVu/NQZE9v4wNkYKoQnE
5K/I8Y8+i9MkbbWSEM58qme9wUmKYFFVyP4JGw2hJVbG7/cCW7ky+g9WDkw3HwXL
7ZLpGgO9NMcqxX4+8Y8nIEj1ymTds11Shj5fSACyXkacPUwcRHaVEsb18bM0Fxhf
zTTRYpVLEg2r+XTz756SwxMHABohG0iYOImdShH0mpQ77trOsNsWjESmbnRR+qDw
DDuXDPQXLxul1gnagfftQN8Tc2oXS+N6/GRLV+qeWQu/GtaW/K8tW1d79OhBHRnJ
flF+eJQqGMq+MWUwYBBzrZsTpVBHEGpeKMJLwfzP6IFOJV4Ro27Yr0Ymnrx0X3en
SypJ/wNmOSP0X1SQnDutWbtDyBYxlPgwmMYwxcHTi4shbfT1etOWzgj1bZQijhM7
8MLBMcVvUhHlgZQ5rGKRnZPdYADkAXCQi3138W1u7OYrKVKkUoWqFNaxzpEpR7Bq
O9pK4fNPXFkkfj1Vwn2vFfM8Q1cB8ya78LUkd1ipIP9ov0rtlKFKve6J3rTietR9
zh30DOYRiS3RKNcASCkg
=b66M
-----END PGP SIGNATURE-----

--=-gHMMh4QsXT31el99NnqY--

