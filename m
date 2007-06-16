Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40678 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777AbXFPMZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2007 08:25:44 -0400
Subject: Re: [PATCH Try#12 2/3] cfg80211: Radiotap parser
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
In-Reply-To: <4671121C.3000705@warmcat.com>
References: <20070613093732.535166329@warmcat.com>
	 <20070613093943.634743151@warmcat.com>
	 <1181760467.29767.130.camel@johannes.berg>  <4671121C.3000705@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7mgbdd+kVS+AQieF2deW"
Date: Sat, 16 Jun 2007 14:26:10 +0200
Message-Id: <1181996770.9058.36.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7mgbdd+kVS+AQieF2deW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-06-14 at 11:02 +0100, Andy Green wrote:

> Looking at the code, I think this can be okay unless I didn't understand
> your point.  At the time that the skb length is modified, I have this:
>=20
> 				if (skb->len < (iterator.max_length + FCS_LEN))
> 					return TXRX_DROP;
>=20
> 				skb_trim(skb, skb->len - FCS_LEN);
>=20
> iterator.max_length is the claimed radiotap header total length, which
> was verified to be within the original skb length already.  So at skb
> length modification time, we take care beforehand that we have skb data
> after the radiotap area to trim, otherwise we bail.  Trimming into the
> radiotap header region would be a bug in the code calling the parser, so
> we trust that if the radiotap header length fitted in the skb at the
> start it does so during the parsing.

Ah, I missed that, I was under the impression that the iterator_next
call was responsible for this error handling, but yeah, this is just
fine.

> I'm sorry I wasn't able to understand this.  FCS presence is a feature
> of the IEEE80211_RADIOTAP_FLAGS radiotap entry which does have an entry
> in rt_sizes?

Yeah, my mistake, sorry.

johannes

--=-7mgbdd+kVS+AQieF2deW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGc9bi/ETPhpq3jKURAug8AJ0T3w/AgjXn39A8gDmeb3Nvd6XSPgCcCwaU
0H16Qp/4YxLo1CES9InqHPw=
=MZ5y
-----END PGP SIGNATURE-----

--=-7mgbdd+kVS+AQieF2deW--

