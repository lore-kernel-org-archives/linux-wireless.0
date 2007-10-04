Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:35231 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757661AbXJDV2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 17:28:08 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ieee80211_if_set_type: make check for master dev more explicit
Date: Thu, 4 Oct 2007 17:26:11 -0400
Cc: Daniel Drake <dsd@gentoo.org>, johannes@sipsolutions.net,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20071004113343.552139D502B@zog.reactivated.net> <20071004180900.GG6037@tuxdriver.com>
In-Reply-To: <20071004180900.GG6037@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2193734.nSyxz73F79";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200710041726.11744.flamingice@sourmilk.net> (sfid-20071004_222815_650404_FECAC4E0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2193734.nSyxz73F79
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 04 October 2007 14:09, John W. Linville wrote:
> diff --git a/net/mac80211/ieee80211_iface.c
> b/net/mac80211/ieee80211_iface.c index be7e77f..6607b80 100644
> --- a/net/mac80211/ieee80211_iface.c
> +++ b/net/mac80211/ieee80211_iface.c
> @@ -106,7 +106,7 @@ void ieee80211_if_set_type(struct net_device *dev, int
> type) * which already has a hard_start_xmit routine assigned
>  	 * which must not be changed.
>  	 */
> -	if (!dev->hard_start_xmit)
> +	if (dev->type != ARPHRD_IEEE80211)
The standard way of checking for the master device is
dev == sdata->local->mdev

wme.c doesn't quite follow this but that code needs to die anyway.

This does look nicer than the other patch.

-Michael Wu

--nextPart2193734.nSyxz73F79
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBHBVpzT3Oqt9AH4aERAhzbAKCVUUi42jfCZfPcf7VrO1d6AGaG6gCgqZna
Saxfk2SRBLpjRoaQF2k5AVI=
=/YjF
-----END PGP SIGNATURE-----

--nextPart2193734.nSyxz73F79--
