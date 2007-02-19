Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35624 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596AbXBSTxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 14:53:07 -0500
Subject: Re: [PATCH v2] d80211: Add software sequence support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070219204004.6730a17a@griffin.suse.cz>
References: <200702141423.27823.IvDoorn@gmail.com>
	 <20070216135827.7d262ae3@griffin.suse.cz>
	 <1171660484.3575.34.camel@johannes.berg>
	 <200702162307.16826.IvDoorn@gmail.com>
	 <1171663926.3575.42.camel@johannes.berg>
	 <20070219204004.6730a17a@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VU/xgg+h0WYpZvwfwXPQ"
Date: Mon, 19 Feb 2007 20:52:50 +0100
Message-Id: <1171914770.15489.5.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VU/xgg+h0WYpZvwfwXPQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-02-19 at 20:40 +0100, Jiri Benc wrote:

> Per-MAC address counters would work but it's another overhead we need
> to add (allocate a new reference-counted structure, put a pointer to it
> into sdata, correctly deal with it when MAC address changes).

Yup, I agree. Put it into drivers :P

> I think we can live with the counter in sdata. It's not perfect but it
> should work for all useful cases. The only situation where it won't
> work I have been able to imagine is the case I described (STA and WDS
> with the same address) and this particular setup is currently being
> denied by d80211 (and it's not allowed by 802.11, btw).
>=20
> If we consider this as a problem later, we can always change to per-MAC
> address counters or something as it's completely internal to the stack
> and no driver changes would be required.

Ok. I'm fine with putting it into the stack. I'll take Michael by the
word though that he'll do dynamically registered tx handlers later ;)

johannes

--=-VU/xgg+h0WYpZvwfwXPQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF2gAS/ETPhpq3jKURAu60AJwPcElfA6BSlKkykTFdOBhv6goOOACfT231
9V95k9nhz7JjxRv3QEWIypQ=
=C/nu
-----END PGP SIGNATURE-----

--=-VU/xgg+h0WYpZvwfwXPQ--

