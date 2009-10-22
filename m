Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43332 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbZJWNfS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 09:35:18 -0400
Subject: Re: [RFC 1/3] mac80211: WIP - add operating BSSID to device
 configuration struct
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org, kalle.valo@nokia.com,
	juuso.oikarinen@nokia.com
In-Reply-To: <1255696042-28413-2-git-send-email-luciano.coelho@nokia.com>
References: <1255696042-28413-1-git-send-email-luciano.coelho@nokia.com>
	 <1255696042-28413-2-git-send-email-luciano.coelho@nokia.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0yEsO8kTiZKu5+Kvwr/S"
Date: Thu, 22 Oct 2009 10:55:19 +0200
Message-Id: <1256201719.12174.19.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0yEsO8kTiZKu5+Kvwr/S
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-16 at 15:27 +0300, Luciano Coelho wrote:

> @@ -2405,7 +2411,15 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_dat=
a *sdata,
>  	 *	to sleep and then change channel etc.
>  	 */
>  	sdata->local->oper_channel =3D req->bss->channel;
> -	ieee80211_hw_config(sdata->local, 0);
> +
> +	if (memcmp(sdata->local->hw.conf.oper_bssid,
> +		   req->bss->bssid, ETH_ALEN)) {
> +		config_changed |=3D IEEE80211_CONF_CHANGE_OPER_BSSID;
> +		memcpy(sdata->local->hw.conf.oper_bssid,
> +		       req->bss->bssid, ETH_ALEN);
> +	}
> +
> +	ieee80211_hw_config(sdata->local, config_changed);
> =20

Is this really necessary before you can auth?

If it is, you're going to have to do a lot more work and go all the way
up to userspace so wpa_supplicant with -Dnl80211 knows about this too,
and doesn't try to authenticate twice or do FT-OTA.

johannes

--=-0yEsO8kTiZKu5+Kvwr/S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK4B3zAAoJEODzc/N7+QmapPgQAL6P0xavQyAeBajlYbbsHKUQ
0lf84g+Bmc8RspNHGi7xaB27hdDxadsn2bykRDsw7T8uPwxF9zQVfAxvYg79Zq44
nKx6FY4OdmWNPfOCWjIJ4WLnfZi6REmD+fW04hhJE8F64BZ+Qm4fgB6hbHengFxE
zKylp5uo6SOAwDNJKfB8BR7DRN88XQhxNaQKMrB7dKwj9KRhCMfvl5r096DKo8EW
M+glSPzq1tbB6Zg2zYEeol/bhVMLFWpfcS8ygFgPUTJjpH/ae6V1Esc0E7+KywDA
E1u0uADe9kdBfBw8O+ZmPHMfnCCzyV2umTtTLqWkb7MwvvZYO/mEMwM/MSyeprev
4fNPpOLcnzroLMD9STR3BaMtoUn32qkvuSZIafqv5kjv9XxipIxUmERizFgllHwI
TuBtW1oG3kdWJXxQ296po2t28degCcJ96vDRMoLXhmU8KA92pLiTPU3idNaOWfru
/RzsR4KfZs0rOHgki+6ngnvfohtnwTLGqsfSi9k6ShFhfrrrxDzMtedd5PTB4ld8
kTggn5uE7eNvBbt58Rj16nEkedLA9jKPJy/vO1dtRmg5YSRHKtLhYnfS0wxkmX0g
PttZ5ReUbIBQ9x918nthM/nzwRIdANL8hipkI8haTx78qe4Vzw+PUg2VZXL3dgqt
+6tGKvuPkdbpTRTAfen1
=Qnh9
-----END PGP SIGNATURE-----

--=-0yEsO8kTiZKu5+Kvwr/S--

