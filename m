Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42321 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbXHVJ1B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2007 05:27:01 -0400
Subject: Re: [RFC 1/2] mac80211: allow drivers to indicate failed FCS/PLCP  checksum
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200708212307.59926.IvDoorn@gmail.com>
References: <20070821161845.165557000@sipsolutions.net>
	 <20070821161942.159647000@sipsolutions.net>
	 <200708212307.59926.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-i/JvcUUpHu43Tj2ZEpCq"
Date: Wed, 22 Aug 2007 11:22:41 +0200
Message-Id: <1187774561.4314.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-i/JvcUUpHu43Tj2ZEpCq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-21 at 23:07 +0200, Ivo van Doorn wrote:

> Do we need another flag to indicate ICV errors?
> rt2x00 has the following fields to indicate problems during hardware decr=
yption:
> 	ICV error -> How to report this to mac80211?
> 	MIC error -> The RX_FLAG_MMIC_ERROR flag can be set
> 	invalid key -> Could best be done by just not setting RX_FLAG_DECRYPTED =
I assume.

I think you either just drop the packet or give it to mac80211 decrypted
but with ICV still on so that mac80211 will verify the ICV (again) and
do whatever is appropriate. But I think dropping it ought to be fine. Do
we want this for monitoring maybe?

johannes

--=-i/JvcUUpHu43Tj2ZEpCq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGzABh/ETPhpq3jKURAv5fAJ4u0nvtlR2ShU1pH4GW4UmLX2OkJQCgs4NY
cHYjh90JSNnxQUl8eAxpLNo=
=gpl2
-----END PGP SIGNATURE-----

--=-i/JvcUUpHu43Tj2ZEpCq--

