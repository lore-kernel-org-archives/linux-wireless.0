Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60975 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbXHOKpp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:45:45 -0400
Received: from [131.234.209.34] (helo=[131.234.237.45])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1ILGNj-0000er-ET
	for linux-wireless@vger.kernel.org; Wed, 15 Aug 2007 11:45:43 +0100
Subject: Re: retry count?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1186914007.5363.9.camel@johannes.berg>
References: <1186914007.5363.9.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U7dQGZyvDf8Mfp9Fdx5Q"
Date: Wed, 15 Aug 2007 11:27:08 +0200
Message-Id: <1187170028.3960.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-U7dQGZyvDf8Mfp9Fdx5Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-08-12 at 12:20 +0200, Johannes Berg wrote:
> struct ieee80211_tx_status contains "retry_count" and I just noticed
> that bcm43xx sets it to -1 if the frame was acked right away. Should it
> be -1 in that case or should it be 0? A comment indicating either way
> would be good. If it should be -1, then I suppose the radiotap tx status
> needs to be fixed, it defines data_retries as a u8 so can't really be
> less than 0.

Turns out that was wrong and b43 used to set it to -1 when the frame
wasn't transmitted at all due to some error.

johannes

--=-U7dQGZyvDf8Mfp9Fdx5Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwsbs/ETPhpq3jKURAmSgAJ9tfM9Dj/9t0huYkgJwEMsL+rCvvgCfRzXw
+oQqqVAKijMZ0SfKzSR9ACc=
=NeTY
-----END PGP SIGNATURE-----

--=-U7dQGZyvDf8Mfp9Fdx5Q--

