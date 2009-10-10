Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761948AbZJJQZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2009 12:25:07 -0400
Subject: Re: deauthentication and disassociation nl80211 commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1254708707.24430.68.camel@maxim-laptop>
References: <1254708707.24430.68.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oenLuIt1RNko3lR0vlxi"
Date: Sat, 10 Oct 2009 18:24:26 +0200
Message-Id: <1255191866.4095.32.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oenLuIt1RNko3lR0vlxi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-10-05 at 04:11 +0200, Maxim Levitsky wrote:

> My hacky patch that was rejected on the grounds that it is not right to
> introduce the driver dependent behavior might actually be the correct
> solution. It just makes the wpa_supplicant_disassociate do both
> disassociation and deauthentication, as was always assumed by the
> wpa_supplicant core.

Jouni just wanted to have what he felt was a workaround in
driver_nl80211.c rather than the core code.

> Or kernel should became smarter and do the work for wpa_supplicant.=20

I still disagree. Why should the kernel deauthenticate when userspace
disassociated.

On the other hand, I think Jouni's argument is that you should be able
to authenticate (force an auth frame exchange) even while authenticated.
I don't really disagree with that all that much, but I'm not sure how to
cleanly fit it in. mac80211 would have to reset the auth state without
sending a deauth.

johannes

(NB: I'm off to Japan on Monday. Sorry I've been slow with email, but
had lots of stuff to do and then planning the next trip, I hope it'll
improve once I return on the 22nd -- well after the weekend then)

--=-oenLuIt1RNko3lR0vlxi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK0LU3AAoJEODzc/N7+QmaM6MP/ivcVz9toPRlmD/VlYGPZuvD
MgepynFAXxEPeqUuQVqcreu0Z8A+95ZTdq+LN1uvsKBGUm8OZgJfJDNzjNG6RDH+
wiHGFNbLdIsPNfr6AJRyYzFlXRrgBaDG+ELWKNsNCnCWU0rbLkubzIo8YSUPRepa
zMoSM9o+IE2eBgxz6z5XO9a053FlggwEV2Za8I6seTPc4KQFtQJ517AmNGVJO/Cp
PSUNvzm4snMacIsud9sfEFwaxLbU/yRQkLaPqN2WAg7yN0r/d4DWJ5qFpdBiLRuF
6UC/s2iQnmpegIyY9OajoOLNuTcBVNAw073NYdilkYq6Mo2Hb5m+WSqExyOD/xy2
wKUDckuHSuPaeujAZVa/PsKnCjSZboMcZnPYFakDcE8QhmijBAvTdDeux5TaPTKY
YfPThtvaEFR50OpJDB2tyl9tTOb8CDnG2yRv2ETKMTaPk46o2OekMTwI0UWK8XP4
yiAckfHLOSA8moNPeL0CDny6iXQovKsKkb7WGrs7ASvS3s3xmZwUaxPpkd+C9/Ue
HgHMfU/71CLF+QNCH8s2HQZgnEr82N22IZbEY4kwircUxzUrjDjk1ir+8fpOL0QL
KYHn0nlwlp5B6XZ2eQc+y9KmZ/SQjwHYTewsK+Ws/jTPvJpVXcYv4TLr6qZXzlaD
8W/jJ+ihXjGWw0zWx/yj
=GCam
-----END PGP SIGNATURE-----

--=-oenLuIt1RNko3lR0vlxi--

