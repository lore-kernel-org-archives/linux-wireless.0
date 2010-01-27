Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59321 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab0A0TN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 14:13:56 -0500
Subject: Re: [PATCH] mac80211: wait for beacon before enabling powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"kalle.valo@iki.fi" <kalle.valo@iki.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"j@w1.fi" <j@w1.fi>,
	"buytenh@wantstofly.org" <buytenh@wantstofly.org>
In-Reply-To: <1264616062.8619.22.camel@wwguy-ubuntu>
References: <1264511993.25642.9.camel@johannes.local>
	 <43e72e891001271001r2cc39da4ka00a3eef06f6e139@mail.gmail.com>
	 <1264615477.8619.20.camel@wwguy-ubuntu>
	 <43e72e891001271014j667221bqa11d56f3a68f6099@mail.gmail.com>
	 <1264616062.8619.22.camel@wwguy-ubuntu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-E4Dv4BIrlVRG5oaDIi5/"
Date: Wed, 27 Jan 2010 20:13:47 +0100
Message-ID: <1264619627.25642.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-E4Dv4BIrlVRG5oaDIi5/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-01-27 at 10:14 -0800, Guy, Wey-Yi wrote:

> > > It will be nice to see a respective solution for stable since this
> > > impact power save which is very important for certain platform.
> >=20
> > Well how about your patch for stable then?
> >=20
> if ok with you and Johannes, I will like to see it happen, the only
> issue is, my patch only address iwlwifi but not mwl8k.

It might be possible to port this patch to stable by changing the way we
determine whether or not we received a beacon already -- it currently
relies on Jouni's cfg80211 change (look for beacon_ies) but that could
be changed, for instance to use the dtim_period in the BSS struct as a
flag.

johannes

--=-E4Dv4BIrlVRG5oaDIi5/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLYJBnAAoJEODzc/N7+QmaKg8P/jjKqchMOlL2C1pwjAM55FFX
HfaZgO9DaEZlVJ4yn9XfnR2EvTAikFdTgUCyq7zemuewLGO4xmHeZ7/AQaam/bH2
gUPKDppjlzLAd7/HEwGsqtDtHP4onncYmw0ZUhOQqjoSfZH4Qu2gXsn7Rz5JNyHn
gb6tjryd9KLZjDx0buyMLEQw/QbqSQHRKZSq8ZNPHedZfqnfZSYtqnwHEmNSoexM
uYhewsWaATqvbkY8P34g7E7TuAefPB12SFqgCBV1yhCqztULCgKSQ6TpiMuOOv9i
1EFQFW1pMP7m+YJHoaBhynab1ME0ziocKHeGtQjSkwj4eJHWZaMZEAbGpsvV1IKl
B+tRysfTb8aYRa+iQ7PggXnwanaf3uqqRARdr8cQhMZS6acxoFY8nnJ9lBNie7z6
j7Qq6ayyofNrs23tuWntnkaHo8tG6ftq1jupmcf/QuOvT2UC8SJ3P0K6PsRgx/Ec
r1dvKTN6gDO0OSSs217u7ZpOiTyAx/fl99fxLnpEpYWKBoFWYi6kyuURwmID24S+
7YiE79mdEYvZTgU1sk3ycMCLePsDUWpIADvJX9S3LxrMu472Dw+ZYk+nllXyMNbz
IHE7zNKgar1OHVBqobdPpy7i/9ONlh9yHtEEScrldIxll2oG3owTeG2jGltIgUyM
jEsE3QdjL/Hs75d1MwUG
=FZYq
-----END PGP SIGNATURE-----

--=-E4Dv4BIrlVRG5oaDIi5/--

