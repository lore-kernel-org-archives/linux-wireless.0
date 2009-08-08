Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41197 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbZHHInL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 04:43:11 -0400
Subject: Re: [PATCH v4] cfg80211: validate channel settings across
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1249712383.30019.5561.camel@rc-desk>
References: <1249649261.4215.7.camel@johannes.local>
	 <1249649433.7194.0.camel@johannes.local>
	 <1249652951.7194.2.camel@johannes.local>
	 <1249658555.7194.8.camel@johannes.local>
	 <1249712383.30019.5561.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yzdvPVoJH9/j8e6wDD6s"
Date: Sat, 08 Aug 2009 10:43:04 +0200
Message-Id: <1249720984.31670.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yzdvPVoJH9/j8e6wDD6s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> I am able to bring the interface up and scan, but when I try to
> associate I get a hang.
>=20
> For example, when I run:
> $ iwconfig wlan0 channel <ch> essid <essid>
>=20
> then the command prompt never returns and system becomes progressively
> unresponsive. The logs do not contain any details of the problem.

Hmm, yes, that's a pretty obvious deadlock, I obviously didn't test
managed-mode 'iwconfig wlan0 channel' setting. I'll send a fix, I'm
sorry.

johannes

--=-yzdvPVoJH9/j8e6wDD6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKfTqVAAoJEODzc/N7+QmaESEP/1OsfK6XwLTSXY2o/0Yvby0Y
zATpxNGmfylmDWV4LyH6eoYPMemRZPQkTn30FxjYwUoYMmvFvgDq8VdRdmFF7U7v
OczENE8ChoSwlTvkFkJfysiRu8SF1mbmDt6SztT47YDychp0FRioZqqOqMPDCtfR
SLqe0yVNeZ482+oJ/PhUw1DivdOVXITRdTxKyAjPae49Fj5WRrhtW+/u2/6mYt7Y
Aq6i9a+BAIKpwcez8KcvJSDT2E8xtHPQ3BGCk3fZhgd0ta2k3RUCssKiaAYVbatg
TCmp/KLqW7O+w7P5xLhit02lb07LhP8DSs0ekEq/61f3sQx8Syu9P575Zw9nmjBz
vQ1uaMcpAp7WwjseZODRALQtY/ZJzLmrEK/ul48x+1PzdNom5kS3gim4yzHFtjwA
qfjtUlG7EutHyhlrN4BbB9gT461h/Oyc7tfTkpSBejgEj8mcXacykDoZAA5Lta+y
SRZ7NV4I7eUHvud0nkk3U3/GJjwS97L1vbBY15fcivGGwZf+qNNd3KHEglYduLJE
CSPnAJ9SvjcHmv4iE6f5pIjn2oYNmnfIU8QBU65wjvPP65XGgVs+wepvpnfR2tYg
Bsl79USVVxB83U7jBiXvntmm3AIGsOU2XGV6Hwb9BHW/o01eHCnqYdeaR3HENGqw
eoRBZthUwJbJDO50AQ8/
=CSwP
-----END PGP SIGNATURE-----

--=-yzdvPVoJH9/j8e6wDD6s--

