Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:21793 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968377AbXHMH4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 03:56:45 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Volker Braun <volker.braun@physik.hu-berlin.de>
Subject: Re: [PATCHv2] mac80211: dynamic wep
Date: Mon, 13 Aug 2007 00:54:53 -0700
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>
References: <pan.2007.08.10.23.31.32@physik.hu-berlin.de>
In-Reply-To: <pan.2007.08.10.23.31.32@physik.hu-berlin.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1484344.Uocg1elFt6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708130054.57899.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1484344.Uocg1elFt6
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 10 August 2007 16:31, Volker Braun wrote:
> This patch fixes my problems with "dynamic wep" (widely used in
> universities), and I can now successfully associate and transfer
> data using mac80211+iwl4965. Main changes:
> 1) Allow privacy mismatch until associated
> 2) Decrypt unicast frames with the per-STA key, not making any
>    assumptions about it being key index 0.
>
> Signed-off-by: Volker Braun <volker.braun@physik.hu-berlin.de>
> ---
Hm, you somehow got a copy of this to me without actually putting me on the=
 CC=20
list.. you should probably use CC instead.

> -0400 @@ -357,7 +357,7 @@ struct ieee80211_cts {
>  #define WLAN_CAPABILITY_IBSS		(1<<1)
>  #define WLAN_CAPABILITY_CF_POLLABLE	(1<<2)
>  #define WLAN_CAPABILITY_CF_POLL_REQUEST	(1<<3)
> -#define WLAN_CAPABILITY_PRIVACY		(1<<4)
> +#define WLAN_CAPABILITY_PRIVACY		(1<<4) /* Force WEP on data packets */
Anyone interested in what this bit is can read the spec. Also, your comment=
 is=20
inaccurate, as this bit is not specific to WEP.

> +	if (rx->fc & IEEE80211_FCTL_PROTECTED && /* WEP */
Inaccurate and unnecessary comment.

> -			if (keyidx >=3D 0 && keyidx < NUM_DEFAULT_KEYS &&
> -			    (!rx->sta || !rx->sta->key || keyidx > 0))
> -				rx->key =3D rx->sdata->keys[keyidx];
So it looks like the keyidx > 0 check here is the source of the RX problems=
=2E I=20
think we can store the keyidx of the individual key to compare against=20
instead of assuming all individual keys have a keyidx of 0.

> -0400 @@ -1131,10 +1131,11 @@ static int ieee80211_privacy_mismatch(st
>  	bss =3D ieee80211_rx_bss_get(dev, ifsta->bssid);
>  	if (!bss)
>  		return 0;
> -
> -	if (ieee80211_sta_wep_configured(dev) !=3D
> -	    !!(bss->capability & WLAN_CAPABILITY_PRIVACY))
> -		res =3D 1;
> +
> +	if (ifsta->associated && ieee80211_sta_wep_configured(dev) !=3D
> +	    !!(bss->capability & WLAN_CAPABILITY_PRIVACY)) {
> +		res =3D 1;  /* associated and WEP encryption mismatch */
> +	}
Another unneeded comment. Don't add braces when it's not needed.

This part seems fairly evil. I suspect a better solution here is to allow=20
unencrypted frames when the interface is dormant (netif_dormant()) and then=
=20
we might be able to get rid of the specific check for WEP.

=2DMichael Wu

--nextPart1484344.Uocg1elFt6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGwA5RT3Oqt9AH4aERAuFDAJwL5XfGQbP5RAzk99bnSYc1A8W8fQCdGfcs
Ny1z5raVvAjk26+aPF4qSj0=
=ijut
-----END PGP SIGNATURE-----

--nextPart1484344.Uocg1elFt6--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
