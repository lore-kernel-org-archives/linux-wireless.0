Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:61834 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754848AbXI1SeI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 14:34:08 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] Adds configure_filter() support for zd1211rw-mac80211
Date: Fri, 28 Sep 2007 14:32:35 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <20070928170109.GC5687@pogo>
In-Reply-To: <20070928170109.GC5687@pogo>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1303544.3MeQJu4ai0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200709281432.39759.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1303544.3MeQJu4ai0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 28 September 2007 13:01, Luis R. Rodriguez wrote:
> -static int zd_op_stop(struct ieee80211_hw *hw)
> +void zd_op_stop(struct ieee80211_hw *hw)
static

> +	/* Only deal with supported flags */
> +	changed_flags &=3D SUPPORTED_FIF_FLAGS;
> +	*new_flags &=3D SUPPORTED_FIF_FLAGS;
> +
> +	/* changed_flags is always populated but this driver
> +	 * doesn't support all FIF flags so its possible we don't
> +	 * need to do anything */
> +	if (!changed_flags)
> +		return;
> +
> +	if ((*new_flags & (FIF_PROMISC_IN_BSS | FIF_ALLMULTI)) ||
> +	     has_monitor_interfaces(mac)) {
Inconsistent use of SUPPORTED_FIF_FLAGS vs. FIF_PROMISC_IN_BSS | FIF_ALLMUL=
TI.

Also, mac address configuration should be moved to add_interface from the=20
start callback.

=2DMichael Wu

--nextPart1303544.3MeQJu4ai0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBG/UjHT3Oqt9AH4aERAkeQAKCM1JO7ivtQn/6azlQ9AEfbf3RdGACgmtUS
RwcinR6lpnEYUUNaTXD23Xw=
=DV7N
-----END PGP SIGNATURE-----

--nextPart1303544.3MeQJu4ai0--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
