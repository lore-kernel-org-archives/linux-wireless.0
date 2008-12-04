Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917AbYLDV5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 16:57:07 -0500
Subject: Re: [RFC] mac80211: remove WARN_ON() from ieee80211_hw_config
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1228425905-15666-1-git-send-email-reinette.chatre@intel.com>
References: <> <1228425905-15666-1-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CsGEhbPUhkDbDNz/PaBm"
Date: Thu, 04 Dec 2008 22:57:04 +0100
Message-Id: <1228427824.5692.52.camel@johannes.berg> (sfid-20081204_225720_099387_D223CE02)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CsGEhbPUhkDbDNz/PaBm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-04 at 13:25 -0800, Reinette Chatre wrote:
> ieee80211_hw_config can return an error when the hardware
> has rfkill enabled. A WARN_ON() is too harsh for this
> failure as it is a valid scenario. Only comment this warning
> as we would like to have it back when rfkill is integrated into
> mac80211.
>=20
> Also reintroduce number of printks that will happen in this case.
>=20
> This patch essentially reverts patch:
> 5f0387fc3337ca26f0745f945f550f0c3734960f
> "mac80211: clean up ieee80211_hw_config errors"
>=20
> Things not reverted is the reintroduction of a comment
> and debug statement.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> There are several places where ieee80211_hw_config's return code is not
> checked. I did not change those as it appears to be intended considering
> that the patch being reverted had nothing to do with them not using the
> return code.
>=20
> It may also be that in this patch only the second hunk be necessary. Plea=
se
> provide feedback in this regard.

I suppose the probability of the beacon interval changing is rather low,
but should we propagate the error in that case rather than just using
-EINVAL?

The scanning hunks I don't really care about, though it does seem a
little pointless to print something when changing channel fails, that
must be one of the most obvious failure modes and also rather unlikely.
Also, that might actually trigger with iwlwifi too in which case every
scan would log it, and there can be lots of scans with NM over time.

johannes

--=-CsGEhbPUhkDbDNz/PaBm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJOFIsAAoJEKVg1VMiehFYyjwP/1+eVgVDH3ktU5jP/dKpqpH3
KchkusQv67xgXS7UhldmjfLgBwKC6LGur6YEo3FYH/htKXP6OhMNRgTRbIrEUPMU
qfr4m57ekcsrO4JcUVc2GvNd2XyR5/6U+APm13xGu38MbZsHrqrmF5PFwXJDAtpa
ZtDxW2mJVaCAoRyvil+WWO1A2gqmv/pSUYPTXrTq0q2lMsZD42z1iwH2Wj6WRQdj
SkNEj9UlWdGI681CGZ83y5Pao7LIkEXt0Bpb1dGzBZLz5y193A6JM5oz+QNdZ0pd
sBZcpQWJ6wwGY1yOC+G6QqvGEG0XkhuPE+vs0naGTf75f53CiWPGnFzfTlw7YwKL
XCIxc2e6tjg8vMTZxa8PcqZ7DAQoclhxlm3o6T2aZ05it0UF0/ZZ9EBaR8F2emhu
zrITmhIh5T6U7zisCxttltl/bwIGb/RrRBCM5b+WxgCgP6dMw6wTNEKeJOxNgtx7
NB9uBerOtTFKO+BfKsdP3Zym3qsY4tenVaKWk8I36Nt3es3pZwO4OIYuAa2f7w3E
tso393yu9YlY3yQHdsNEmL3HhH+1Yn4RsiInYEfWzYlWdKNCBgafhIG7CsCc2Q06
nkawQbp0MW7QSOeEd7X6BtHi2CDEC461/ZLS6TqW4C12/zL0yM3lIp6T3rHk5x3a
QdGihFFKux+5wF6Df/sV
=6UB3
-----END PGP SIGNATURE-----

--=-CsGEhbPUhkDbDNz/PaBm--

