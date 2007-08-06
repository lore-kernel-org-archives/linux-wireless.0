Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759877AbXHFIHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 04:07:50 -0400
Subject: Re: [BUG] timer.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian =?ISO-8859-1?Q?Sch=E4fer?= <schaefer@in.tum.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070803123240.519c5a38.akpm@linux-foundation.org>
References: <46B1F896.8090005@in.tum.de> <46B2EA43.8070305@in.tum.de>
	 <20070803123240.519c5a38.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vy5HCHNea/3kqOK/boG9"
Date: Mon, 06 Aug 2007 08:35:46 +0200
Message-Id: <1186382146.21957.40.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vy5HCHNea/3kqOK/boG9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-03 at 12:32 -0700, Andrew Morton wrote:

> > I was able to reproduce the bug without a tainted kernel (i.e. without=20
> > the nvidia binary module). Please let me know if you need more infos.

What sort of wireless code are you using? That _rtl suffix *looks* like
some weird vendor driver added _rtl to all function and module names.
It's definitely not pristine upstream source; looks to me like vendor
source to that r8187 module you have since the official driver is called
rtl8187.

> >   [<f8e4600c>] ieee80211_associate_procedure_wq_rtl7+0x0/0x78  [ieee802=
11_rtl]

> You'll need to hunt down the authors of ieee80211_rtl (where'd that come
> from?) and tell them not do do add_timer() or an already-pending timer.

There's no such nor any similar function in any code I know. No use
blaming linux-wireless.

johannes

--=-vy5HCHNea/3kqOK/boG9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGtsFC/ETPhpq3jKURAtGMAJ92hd3dLhwTo+WqKmwcrFo+GKNPYQCeJDtk
gzqSw1uwSdiDINg9VpxWtaw=
=vdOl
-----END PGP SIGNATURE-----

--=-vy5HCHNea/3kqOK/boG9--

