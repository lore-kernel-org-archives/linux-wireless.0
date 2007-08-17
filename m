Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253AbXHQKLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 06:11:38 -0400
Subject: Re: mac80211 IPv6 problems
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, jbenc@suse.cz,
	Michael Buesch <mb@bu3sch.de>, Daniel Drake <dsd@gentoo.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
In-Reply-To: <20070806170500.GE6442@tuxdriver.com>
References: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net>
	 <1186094778.6701.6.camel@shinybook.infradead.org>
	 <20070803005517.GA4261@tuxdriver.com>
	 <200708030102.17358.flamingice@sourmilk.net>
	 <20070806170500.GE6442@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iCoAty4GrmotscNfNYOA"
Date: Fri, 17 Aug 2007 02:52:56 +0200
Message-Id: <1187311977.23489.93.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iCoAty4GrmotscNfNYOA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-06 at 13:05 -0400, John W. Linville wrote:

> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -3030,9 +3030,10 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx=
)
>  		memcpy(dst, hdr->addr1, ETH_ALEN);
>  		memcpy(src, hdr->addr3, ETH_ALEN);
> =20
> -		if (sdata->type !=3D IEEE80211_IF_TYPE_STA) {
> +		if (sdata->type !=3D IEEE80211_IF_TYPE_STA ||
> +		    (is_multicast_ether_addr(dst) &&
> +		     !compare_ether_addr(src, dev->dev_addr)))
>  			return TXRX_DROP;

I can confirm that this works (applies if you s/ieee80211.c/rx.c/) for
IPv6 link local addresses, and it's definitely the right thing to do
here.

johannes

--=-iCoAty4GrmotscNfNYOA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxPFo/ETPhpq3jKURAvG8AKCZmSq80efTxxcKlnlkrZuuOXSvOwCfdZXI
fF97FnuQzUKlCMmM5XLCJz0=
=qNPV
-----END PGP SIGNATURE-----

--=-iCoAty4GrmotscNfNYOA--

