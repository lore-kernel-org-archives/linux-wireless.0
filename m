Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42804 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762136AbXHHJjV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 05:39:21 -0400
Subject: Re: [PATCH] mac80211: probe for hidden SSIDs in pre-auth scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1186565651.11717.23.camel@johannes.berg>
References: <20070807203315.GG3330@tuxdriver.com>
	 <200708080056.16195.flamingice@sourmilk.net>
	 <1186565651.11717.23.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1CjQGVQyWhcXX8wLaeOe"
Date: Wed, 08 Aug 2007 11:41:11 +0200
Message-Id: <1186566071.11717.28.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1CjQGVQyWhcXX8wLaeOe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-08 at 11:34 +0200, Johannes Berg wrote:
> On Wed, 2007-08-08 at 00:56 -0700, Michael Wu wrote:
> > On Tuesday 07 August 2007 13:33, John W. Linville wrote:
> > > The ternary conditionals are a bit ugly.  I guess I could recode it
> > > with temp vars initialized before calling ieee80211_sta_start_scan.
> > >
> > Something more like:
> >=20
> > if (ifsta->auto_ssid_sel && ifsta->ssid_len)
> >   ieee80211_sta_start_scan(dev, NULL, 0);
> > else
> >   ieee80211_sta_start_scan(dev, ifsta->ssid, ifsta->ssid_len);
>=20
> Except you got the condition inverted.

Well, not fully inverted. Shouldn't it be

if (!ifsta->auto_ssid_sel && ifsta->ssid_len)
	...(dev, ifsta->ssid, ifsta->ssid_len)
else
	...(dev, NULL, 0)

On the other hand, calling with a "anything, 0" probably has the same
effect as calling with "NULL, 0" so the "ifsta->ssid_len" condition can
go away just as linville had it.

johannes

--=-1CjQGVQyWhcXX8wLaeOe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGuY+3/ETPhpq3jKURAhhqAJ4sIwYPYvMcAefbVwT6S3vR7+kqXQCginsX
HSfBB75Ik3Vfzp+4y2sbiOY=
=vjbF
-----END PGP SIGNATURE-----

--=-1CjQGVQyWhcXX8wLaeOe--

