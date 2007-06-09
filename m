Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34197 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbXFIMOo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2007 08:14:44 -0400
Subject: Re: your nl80211 work
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lamparter <lists@diac24.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070609113859.GA10836@charon.n2.diac24.net>
References: <1181380044.3566.11.camel@johannes.berg>
	 <20070609113859.GA10836@charon.n2.diac24.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bmqxENtDki6Xs7XYIG4m"
Date: Sat, 09 Jun 2007 14:14:58 +0200
Message-Id: <1181391299.3566.17.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bmqxENtDki6Xs7XYIG4m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-06-09 at 13:39 +0200, David Lamparter wrote:

> Ah, I didn't think about that. Well, next try next luck... Hmm. Maybe we
> should include the list of interfaces into the GET_WIPHY command and have
> GET_INTERFACE never return a list?

Actually, I only thought about that yesterday too when thinking about
the userspace MLME thing (see my other post)

> Yeah, I was hoping for feedback on this one. For one, do we even bother t=
o
> return the frequency via nl80211? There's no attribute for it yet, and I
> don't know if this is too useful. Maybe it can be included in the channel
> list, so if an application really wants to know the frequency, it can loo=
k
> up the table using channel+phymode as key and get it.

I think Dan said that he'd really like to see the kernel have a
frequency table somehow so not all userspace programs need to convert
themselves and introduce bugs and be updated all the time for new
things. But just having it in the channel list seems sufficient, or have
it in cfg80211 and pass it via nl80211 but not read it on incoming
requests nor bother the driver with it, i.e. create it from
channel/phymode in nl80211.c itself.

johannes

--=-bmqxENtDki6Xs7XYIG4m
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGapnB/ETPhpq3jKURAjusAKCZrDNrE1swX9Us0FEBCFb5isFNQgCgpuZk
UsW3nkQUr/qom4GkERzq0II=
=EE4e
-----END PGP SIGNATURE-----

--=-bmqxENtDki6Xs7XYIG4m--

