Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56318 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419AbXHBLrd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 07:47:33 -0400
Subject: Re: [RFC V2] bcm43xx-mac80211: Provide information to allow   transmission rate decreases
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <200708021337.21285.mb@bu3sch.de>
References: <46b0f367.p35iGhSXwM+v4QLG%Larry.Finger@lwfinger.net>
	 <200708021311.25033.mb@bu3sch.de> <1186053497.24230.27.camel@johannes.berg>
	 <200708021337.21285.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-H6Qrt+YLNC6C4Yx7PznQ"
Date: Thu, 02 Aug 2007 13:48:39 +0200
Message-Id: <1186055319.24230.32.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H6Qrt+YLNC6C4Yx7PznQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-02 at 13:37 +0200, Michael Buesch wrote:

> If we just check the ack bit, rate control would throttle, just because
> we sent unacked frames.

Ah but rate control shouldn't actually care about frames that we never
expected an ACK for since there's no way to know for those anyway. So
IMHO the rate control algorithm shouldn't even be called for those
frames.

> So if we didn't get an ack, we need to check if we failed, or if...
> Oh, acutally. Why not simply check the noack bit in the tx_control... :)

Works too, but it seems mac80211 should do that.

johannes

--=-H6Qrt+YLNC6C4Yx7PznQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGscSX/ETPhpq3jKURAtlOAJ9wTvSoj4GTN2qYZiiTsfcu3pZaJQCfdL1n
+1UQJmZCredbGv2Xb3GkZW8=
=ZCm/
-----END PGP SIGNATURE-----

--=-H6Qrt+YLNC6C4Yx7PznQ--

