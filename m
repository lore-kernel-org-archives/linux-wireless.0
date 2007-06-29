Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:48364 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751888AbXF2Ff0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2007 01:35:26 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: separate monitor/subif_start_xmit
Date: Thu, 28 Jun 2007 22:35:41 -0700
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Andy Green <andy@warmcat.com>
References: <1182433144.21939.6.camel@johannes.berg>
In-Reply-To: <1182433144.21939.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1244695.TvKuT6PDWx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706282235.46522.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1244695.TvKuT6PDWx
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 21 June 2007 06:39, Johannes Berg wrote:
> +	skb_set_network_header(skb, len + sizeof(struct ieee80211_hdr));
> +	skb_set_transport_header(skb, len + sizeof(struct ieee80211_hdr));
> +
Hm, just noticed a potential problem with this. sizeof(struct ieee80211_hdr=
)=20
can't be used since ieee80211 headers are variable sized and the smallest=20
frames can end up being smaller than the 4 addr header.

=2DMichael Wu

--nextPart1244695.TvKuT6PDWx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGhJoyT3Oqt9AH4aERAlgzAKC6cGqiUGnE06arKfDGPU+XZxvE2wCggsft
2Ha7IA2ty7QPfqr/6IU5oK4=
=ojbu
-----END PGP SIGNATURE-----

--nextPart1244695.TvKuT6PDWx--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
