Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52502 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab0BEKdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 05:33:00 -0500
Subject: Re: [PATCH] mac80211: Improved IBSS merges
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1265319990-25583-1-git-send-email-benoit.papillault@free.fr>
References: <1265319990-25583-1-git-send-email-benoit.papillault@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Y9yYLXPcHTfdnMwUdODH"
Date: Fri, 05 Feb 2010 11:32:57 +0100
Message-ID: <1265365977.3613.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y9yYLXPcHTfdnMwUdODH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-02-04 at 22:46 +0100, Benoit Papillault wrote:

> Next, we merge even if the BSSID from the received beacon is the same as
> our since merge can update more things that BSSID itself. This is
> specifically true for ath9k where the merge updates TBTT timers as a
> side effect and this is indeed needed if the TSF has been updated (if
> TSF is updated, we need to update TBTT timers as well).

> @@ -373,10 +370,6 @@ static void ieee80211_rx_bss_info(struct ieee80211_s=
ub_if_data *sdata,
>  				sdata->u.ibss.ssid_len))
>  		goto put_bss;
> =20
> -	/* same BSSID */
> -	if (memcmp(cbss->bssid, sdata->u.ibss.bssid, ETH_ALEN) =3D=3D 0)
> -		goto put_bss;
> -
>  	if (rx_status->flag & RX_FLAG_TSFT) {
>  		/*
>  		 * For correct IBSS merging we need mactime; since mactime is

NACK. This will create merges and merges and merges and merges whenever
you use hardware that doesn't have accurate timestamps all the time.

johannes

--=-Y9yYLXPcHTfdnMwUdODH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLa/PVAAoJEODzc/N7+QmaJa8QANLO/R8kLFjYug4m+xSQ2vFi
ceGlvpoYlq1AL3qXMUNW/z8ovI8hrkrwnXoIREO+rhQcHgd5nkKkAEyIf3gR8zmR
tdH5WsjA8HFZWQjXvWb1s5/E5rdBTVkq74sKNjNhUUsBo2MLCH5d1SR//24Jc7j/
kZavfEGS5uIJjb7mZOZHGHnM51oIpdvTZ906M1ys7/uasL2FbWdFT0P67jeR4Rwc
eUpNJNC+VS3K9G/ZPqASqXD8d6iAV8xjQzyHySSCWBoPtdPCbf8WGZBN0fuJmUNG
19wxPDjyWEp9nWEQaqg4/0E4Zb3DBcLIo0O3thZ5YmgUMIMToVoe0fK3XvEVtxwZ
NC3lYfma/BFn194CmdKhMhNLz+3JKrWoKzyx/x9kJEKuCaZHfdFWvYx3aE6U0Mjp
XXKfT8153NO/8/slxTNK67IOrBiuSnTCGdKlAp/vvfJa+NS/iXLgoUS6wixzEFgv
ToBvib+OEgiITMSQYhbv7d4O9V3L0b7vpncbsmuHC4bN3tkxw2EmuEMmqYEk3mAC
jp3F2ZyCTQBLXCX3fJbAY0+rmIUVX0isoxhUkDpCpQaPDy2szrYh9S4xKVZ6LZ1r
/9cE9C6X8Lty/ns/YgBEjRZJjaybt4YC+A7Vcp/EHUoAB/v8j99PKnwo3pFXXuMb
Ng+sT8A4IjYK9BOGL1fU
=jiFO
-----END PGP SIGNATURE-----

--=-Y9yYLXPcHTfdnMwUdODH--

