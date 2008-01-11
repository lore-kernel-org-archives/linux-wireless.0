Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42145 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862AbYAKLjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 06:39:47 -0500
Subject: Re: [PATCH] mac80211: fix alignment warning
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1200013371.3861.132.camel@johannes.berg>
References: <1200013371.3861.132.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PGSD/Hb545RzNtyzZu/i"
Date: Fri, 11 Jan 2008 02:18:36 +0100
Message-Id: <1200014316.3861.149.camel@johannes.berg> (sfid-20080111_113955_508476_55003308)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PGSD/Hb545RzNtyzZu/i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Hmm. This alignment isn't strictly necessary because we actually copy
> all the payload within an A-MSDU frame. I think we can get rid of that
> though if we're a bit more careful what we do with the frame, i.e. if we
> copy it before passing it back to mac80211 for multicast frames we can
> optimise the common non-multicast case by using only a clone.

In fact, I'm not sure we can do this. Asking on netdev, I guess we
shouldn't merge this patch until we know. If we can't give a cloned skb
to netif_rx() then we don't care at all and don't need to align A-MSDU
packets at all...

johannes

--=-PGSD/Hb545RzNtyzZu/i
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4bD6qVg1VMiehFYAQLWbBAAokEo6SumcPTUpC+whJROs9NU7v8t42TX
ybNq6vFGU+1fex3TfKfU8IM/huFWj0jodu0k/iMs7RoZ+QuFw4+K/nACKrGa1B0O
ssADWzcbJMXnHSix2RWHmCLn3Ar0+4Lim+WdbIf5KLXf66kG2V6tXPvDELkmPy2c
XMVzESvo1ullPevTR0mOm0GA9akyhxzpzlREREEEtKSEV8iFmLdrsn4xmQ8Bq7Rx
qS7p929ZyU7V8d+4bsRqR7+8BXY+4nvTcg/dtzYvbSckw+SOVIpEO7VtRWMkUIbh
+IqkdF3nMtC06TCF75+o4PnCS0n0iqOADycSjXMPu7Db2109ZZuDof+wBIzMJjm0
F7s/q4nNsoDkdzrjA5csFbqPch0eWizOU5X6oW0rJhSspau/PcWfRwsq0WFP2FJe
kCjFYlz0SS46AnneUKD5ZTvVIq9RUbFd25s6p7X2lTdZ8SFCrK5AQC7wouxatFyM
YE6UTd85MdEcNIf5963LvJj/sgaJK933hL7pk+/ZeK1KFyhvXoW/jaH+SQ6lzCQt
YTCZh1FM6WFW/sawZTw6pVQ/UP6RNgvA+78rlZpqt4VOpcsbyfeHHe4DLqsIuF8q
IVW1d19LavSpzeQvgsl/4xEpu4hcgdvuoO42bZ0gVEDgdQ9eN14Zdb2vgLyt5ttV
7Xs5hobMN4w=
=kCJl
-----END PGP SIGNATURE-----

--=-PGSD/Hb545RzNtyzZu/i--

