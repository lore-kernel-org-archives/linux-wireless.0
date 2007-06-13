Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52647 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbXFNJGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 05:06:19 -0400
Subject: Re: [PATCH Try#12 2/3] cfg80211: Radiotap parser
From: Johannes Berg <johannes@sipsolutions.net>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
In-Reply-To: <20070613093943.634743151@warmcat.com>
References: <20070613093732.535166329@warmcat.com>
	 <20070613093943.634743151@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ekqKiCyDG08zSNMezy5g"
Date: Wed, 13 Jun 2007 20:47:47 +0200
Message-Id: <1181760467.29767.130.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ekqKiCyDG08zSNMezy5g
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Andy,

Sorry, I really hate doing this, but I found yet another problem :/

Hi Andy,

Sorry, I really hate having comments again and again but never really
thought about this earlier, the FCS removal thing you added made me
think...


> + * @max_length: total length we can parse into (eg, whole packet length)

> +	/* sanity check for allowed length and radiotap length field */
> +	if (max_length < le16_to_cpu(radiotap_header->it_len))
> +		return -EINVAL;

> +	iterator->max_length =3D le16_to_cpu(radiotap_header->it_len);

This is fine, at first sight, but if you let the caller modify the skb
like mac80211 now does with stripping the FCS, the max length really
needs to be passed to each invocation of
ieee80211_radiotap_iterator_next in order to catch invalid skbs. Mind
you, we wouldn't Oops since trimming just moves the skb tail pointer,
but something that indicated a longer length and then just have a packet
like

0x00, 0x00, // <-- radiotap version
0x08, 0x00, // <- radiotap header length
0x10, 0x00, 0x00, 0x00, // <-- bitmap, FCS bit set

which might not do the right thing and it'd be better IMHO to catch it
explicitly.

Also related to FCS, if you respin I think I'd like to have an explicit
"0x00" entry in rt_sizes for it so it's obvious that it's intentionally
0, otherwise I'll post a patch after the code goes in.

Another question: since there's no alignment requirement for the skb
that contains the radiotap header, I think you need something like

iterator->bitmap_shifter =3D=20
	le32_to_cpu(get_unaligned(iterator->next_bitmap))

instead of

> +                               iterator->bitmap_shifter =3D
> +                                   le32_to_cpu(*iterator->next_bitmap);

in many places.

johannes

--=-ekqKiCyDG08zSNMezy5g
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGcDvT/ETPhpq3jKURAttsAJ4+PssurHr+GtuB+sKb7tTraY1SYQCdG3sm
6UGnY6VhkpJNfWCMAGtJBBo=
=J+Xq
-----END PGP SIGNATURE-----

--=-ekqKiCyDG08zSNMezy5g--

