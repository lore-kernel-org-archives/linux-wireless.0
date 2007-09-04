Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47103 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbXIDOMr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 10:12:47 -0400
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
In-Reply-To: <1188872746.13078.411.camel@debian.sh.intel.com>
References: <1188192012.13078.177.camel@debian.sh.intel.com>
	 <20070831205524.GA11128@tuxdriver.com>
	 <1188872746.13078.411.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uLNAx3LJj/xujfjfdckc"
Date: Tue, 04 Sep 2007 16:13:49 +0200
Message-Id: <1188915229.9942.29.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uLNAx3LJj/xujfjfdckc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-04 at 10:25 +0800, Zhu Yi wrote:

> Since they are device specific rate scale algorithm, I don't think they
> will help to increase performance for other devices.

What exactly is device specific?

> If so,
> the rate scale interface has to be abstracted from internal mac80211.
> The current dependencies are as below:
>=20
> iwl3945-rs -> rate_control_ops (ieee80211_rate.h)
> rate_control_ops -> sta_info (sta_info.h)
> rate_control_ops -> ieee80211_local (ieee80211_i.h)
> ieee80211_local -> ieee80211_key (ieee80211_key.h)

I never liked exporting ieee80211_local to the rate control algorithms.
That just means the interface is badly defined. And sta_info I'm not too
sure about either, on the one hand the rate control algorithms need
access to some flags but on the other hand some things if they need to
store per-sta information then it can't really be in the sta_info struct
since that info varies per algorithm

> If we want to avoid a big restructure of the mac80211 headers, the
> easiest way is to move four header files from net/mac80211 to
> include/net/ and rename them with mac80211_ prefix (especially for
> sta_info.h). This way, for any mac80211 based wireless drivers want to
> create their own rate scale algorithm, they can smiply include
> <net/mac80211_rate.h> and implement all the callback functions.
> Comments?

I don't like this, especially not ieee80211_i.h. I'm ok with _rate.h,
but let's get rid of the ieee80211_local dependency in rate control
algorithms.

johannes

--=-uLNAx3LJj/xujfjfdckc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3Wgd/ETPhpq3jKURAk7cAJwMwZP1cqRwZpiQZKGbCyuBIt2S8wCgjJF+
AGHzdX5iZTZYo6J235RpXeQ=
=Uhii
-----END PGP SIGNATURE-----

--=-uLNAx3LJj/xujfjfdckc--

