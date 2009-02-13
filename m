Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36544 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZBMGxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 01:53:11 -0500
Subject: Re: [PATCH 2/6] cfg80211: add wiphy_idx_valid to check for
	wiphy_idx sanity
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1234503363-11014-3-git-send-email-lrodriguez@atheros.com>
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-2-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-3-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jgACXGNrBxD9en++7c5B"
Date: Fri, 13 Feb 2009 07:53:05 +0100
Message-Id: <1234507985.1327.15.camel@johannes.local> (sfid-20090213_075315_106246_EFB8807F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jgACXGNrBxD9en++7c5B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-12 at 21:35 -0800, Luis R. Rodriguez wrote:

> -	if (unlikely(drv->wiphy_idx < 0)) {
> +	if (!wiphy_idx_valid(drv->wiphy_idx)) {

> +/* Note 0 is valid, hence phy0 */
> +static inline
> +bool wiphy_idx_valid(int wiphy_idx)
> +{
> +	return (likely(wiphy_idx >=3D 0));
> +}

Does that really work properly with the likely in there?

johannes

--=-jgACXGNrBxD9en++7c5B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJlRjOAAoJEKVg1VMiehFYspsP/0WGmjkoJN8fY9fGsNv8E1X0
lGCruypweiXi0jVWSr/v4Jtqn4vCsS34znbh3MlNksKVJKQZK2QV0+k796Bszbr6
1xXI/Uy/PG9exWu+RJADTmivB+6LqFkTkL2QW5jPVWyzyF00uIuHzSPyS8H9rQvL
BO+tk0AOYHmIEqcEnbKYg28JlwhJBWxlvjZKJDOZZwWSYHDZu1I/6yJhWt1YtdAZ
IwoZfbONBBEm4EfSaUZmW+/SMtPte2I79ZktLnXxngDPNd4UU8n5zUJc0feCJARj
ZUdmhNDHWRxMPz3q3mf1XDqOdomZXjvNtFVdcNrSWHvq79ZseRMwYd8H1iOnUX4l
BvZ953By+V7CxsgsW6m9IWSTlLxfSSf39PelgYD+iaSkjVxXuS2u31ZFL1OmQjwP
vlg+TqCQCWgqxdGuJtO9PTXcmEhHx8doRMKNMy6fJZiA7WaFXiqou720Q+3tdSAW
4oNNvPP9OXaOPW8l89YzVT2mdq1iVAhLJ6NUoOByt7kkZrWO+ubQ2CClsitrMeOc
6UjXPc4MfErFmLewVIdfLNF9J2MYkU/7+PkxAeK+eT4MdKtV1o5LgHYRtzP1Af+6
ceYKg5ihqxqlpixftx/54wC9AqUg7N6XEJQp7+rupHgR+Y9cI4Eql8NgSs7cLqK2
6Y7wRC8Idi+lR/CZt1mL
=ZLv6
-----END PGP SIGNATURE-----

--=-jgACXGNrBxD9en++7c5B--

