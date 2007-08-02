Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39221 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbXHBJI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 05:08:26 -0400
Subject: Re: [RFC V2] bcm43xx-mac80211: Provide information to allow   transmission rate decreases
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
In-Reply-To: <200708020014.15072.mb@bu3sch.de>
References: <46b0f367.p35iGhSXwM+v4QLG%Larry.Finger@lwfinger.net>
	 <200708020014.15072.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-21XF6Hb3XGpeYnj5RyHm"
Date: Thu, 02 Aug 2007 11:09:47 +0200
Message-Id: <1186045787.24230.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-21XF6Hb3XGpeYnj5RyHm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-02 at 00:14 +0200, Michael Buesch wrote:

> Though, I have no idea how we can easily track the information for each
> packet if it was sent with LONGFRAME bit or without.
> It needs to be a per-frame-attribute.
> I think the txstatus doesn't tell us (but I'm not sure).

Why do you need to know when you get a tx status? Oh I see. Hm. Well,
mac80211 tells you how much to retry now (Daniel made a patch); you can
select long/short based on that and on tx status simply compare with
that number from the tx control struct.

johannes

--=-21XF6Hb3XGpeYnj5RyHm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGsZ9b/ETPhpq3jKURAqMiAJ9Y41FmsuQo5SKAgZTGP03130BEjgCggZUJ
JholYVmqJpA1LceMkvyRXSg=
=a72W
-----END PGP SIGNATURE-----

--=-21XF6Hb3XGpeYnj5RyHm--

