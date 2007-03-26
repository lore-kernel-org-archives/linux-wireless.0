Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49045 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbXC1JGM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:06:12 -0400
Received: from [131.234.78.148]
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.66)
	(envelope-from <johannes@sipsolutions.net>)
	id 1HWU6b-00047C-Rh
	for linux-wireless@vger.kernel.org; Wed, 28 Mar 2007 10:06:11 +0100
Subject: mac80211 qdisc bugs [Fwd: Re: [patch] d80211: use pfifo_qdisc_ops  rather than d80211-specific qdisc]
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xGWS/qRRW8vFeE/xxwb4"
Date: Mon, 26 Mar 2007 19:55:33 +0200
Message-Id: <1174931733.25887.34.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xGWS/qRRW8vFeE/xxwb4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Has anybody addressed these points yet? I don't understand much about
qdiscs myself... Add to todo list?

johannes

-------- Forwarded Message --------
> From: Patrick McHardy <kaber@trash.net>
> To: David Kimdon <david.kimdon@devicescape.com>
> Cc: netdev@vger.kernel.org, John W. Linville <linville@tuxdriver.com>,
> Jiri Benc <jbenc@suse.cz>
> Subject: Re: [patch] d80211: use pfifo_qdisc_ops rather than
> d80211-specific qdisc
> Date: Thu, 26 Oct 2006 03:21:10 +0200

[...]

> BTW, I noticed a few bugs while looking at the qdisc handling in
> wireless-dev:
>=20
> - wme_qdiscop_enqueue doesn't increment q.qlen for packets queued
>   to q->requeued[], which might cause upper layer code to stop
>   dequeueing if q.qlen reaches zero.
>=20
> - classify_1d doesn't care about tc_classify return values.
>   tc_classify may decide to steal packets, drop them, etc. In case
>   of stolen packets this causes use-after-free, otherwise just
>   malfunctions.
>=20
> - classify_1d returns res.class if it is !=3D -1, which can never happen
>   (except with an empty classifier list because of the explicit
>   initialization, but you should check the return code) since ->get()
>   and ->bind_tcf() both return 0 for invalid classes and the classid
>   otherwise. There's also an off-by-one, classids start at one, so it
>   should return res.class - 1 (or better res.classid - 1, which is
>   meant to be a numerical identifier).
>=20
> - wme_discop_destroy leaks classifier module references and memory
>   when destroying classifiers, it should use tcf_destroy()
>=20
> Considering that it is possibly and may be desirable to attach a
> different qdisc than the built-in multiband qdisc, it might also
> make sense to split the 80211 specific classification in a seperate
> classifier module to allow simple classification of management traffic
> with other qdiscs.


--=-xGWS/qRRW8vFeE/xxwb4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCAkV/ETPhpq3jKURAkUgAJ4mLufK35VYbu50Q6ISmq4CyPybcACgsIN6
IuVUVkt+vcZ3KxL6PKxCSL8=
=/UqC
-----END PGP SIGNATURE-----

--=-xGWS/qRRW8vFeE/xxwb4--

