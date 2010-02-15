Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44285 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab0BOJeq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 04:34:46 -0500
Subject: Re: [PATCH 1/2] mac80211: Drop protected data frames that have not
 been decrypted
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4B78FBA5.7090109@free.fr>
References: <1266190653-2453-1-git-send-email-benoit.papillault@free.fr>
	 <69e28c911002141610q737465b4s1d825d6dcd3aea26@mail.gmail.com>
	 <4B78FBA5.7090109@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-70pZfPavh8MCKr+1IHS4"
Date: Mon, 15 Feb 2010 10:34:43 +0100
Message-ID: <1266226483.7084.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-70pZfPavh8MCKr+1IHS4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-15 at 08:45 +0100, Benoit PAPILLAULT wrote:

> > I'm not familiar with this part of the code; but have you tested if
> > this doesn't break monitor-while-operating mode (i.e. doesn't remove
> > other-STA frames from monitor interfaces)?
> >
> >  =20
> Yes, it has been tested in this case. In fact, this patch changes RX=20
> path only in ieee80211_rx_h_data / ieee80211_rx_h_action and=20
> ieee80211_rx_h_mgmt. In all 3 cases, it returns RX_DROP_MONITOR.

???

        if (ieee80211_drop_unencrypted(rx, mgmt->frame_control))
                return RX_DROP_UNUSABLE;

However. GUYS!!! Read the code! Real monitor mode bypasses _ALL_ the RX
handlers, frames just short-circuit up right after they are received
from the driver.

johannes

--=-70pZfPavh8MCKr+1IHS4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLeRUvAAoJEODzc/N7+Qmar5wQALoE+V43JES3x0HOVz4At+cR
gnWIxiCGNa85xGuLmCH9blyJQZtT4F34BGGsR4BKky+ccdMP/NeTRQp9O63x/3bK
hiqZKClRPLkueiKa14RGKd38+HpqW3jgPDT8Qf102EloDzq0kBk2N6NLLCOM/cOc
9rrC5toL35z/Uve5LnZJl0G+ZTuBhX9fKisGOwuONW9o8y3kNSZAGpvCpNPkQLp+
PkJ/8npewf8m7HQDv3Wc2TKy1mmNLsGf0HcxzUKvyWzpgE/Tow1WhDgjP2IXk68P
8qaV6tMna5Lovn6TOpZB6WCOaopzNBwQkAvupfIOx4M5cwJk4RezHMMFmk+FRq/4
2xdLSUeqnB6IuYcKSU46pDd/OKu0HgLjjDSQIWD8KnTJ4el3Ngyb6J8hk6tr+F9a
W1oyoX/ma0zDsPNGLHxuqOBytuBY57E1cfmllfhlW5mGZA8O8C8ka7cyGZDuy/ZL
cM5PmgZDsHTj1biwANm3jATXLV+yWUyY1+5M//Pfa4tDlmTRK8siNPgU9+AoOX7Z
FZzlBQEtxz17htazBjRscESdelqDQs5RG1ZeAC8DdIuARZ+nTKQ0LNzRjEaEPNy9
KzRVe5ezXp1S/w2X36vukWkWjmE71hd2oS6EkiUFPaXq/1DBKkU/WD6PQEcrzdlS
x+YNzlg+cHIiw9Tyj21m
=GGvc
-----END PGP SIGNATURE-----

--=-70pZfPavh8MCKr+1IHS4--

