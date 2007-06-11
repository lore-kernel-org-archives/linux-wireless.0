Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41763 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbXFKLRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 07:17:19 -0400
Subject: Re: [PATCH Try#8 3/4] cfg80211: Radiotap parser
From: Johannes Berg <johannes@sipsolutions.net>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org,
	Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20070611095846.511945296@warmcat.com>
References: <20070611095400.206844675@warmcat.com>
	 <20070611095846.511945296@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JV5fI8yC5Y/gG6NnlPF8"
Date: Mon, 11 Jun 2007 13:17:48 +0200
Message-Id: <1181560668.29767.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JV5fI8yC5Y/gG6NnlPF8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Andy,

Thanks for the repost.

> +/* Radiotap header iteration
> + *   implemented in net/wireless/radiotap.c
> + *
> + * call __ieee80211_radiotap_iterator_init() to init a semi-opaque itera=
tor
> + * struct ieee80211_radiotap_iterator (no need to init the struct before=
hand)
> + * then loop calling __ieee80211_radiotap_iterator_next()... it returns =
-1
> + * if there are no more args in the header, or the next argument type in=
dex
> + * that is present.  The iterator's this_arg member points to the start =
of the
> + * argument associated with the current argument index that is present,
> + * which can be found in the iterator's this_arg_index member.  This arg
> + * index corresponds to the IEEE80211_RADIOTAP_... defines.
> + */

I don't think this will show up in the kdoc output, but it sure would be
nice. Maybe it could be part of the description of
ieee80211_radiotap_iterator as a 'how to use this iterator' section (see
kernel-doc-nano-HOWTO.txt, it talks about sections)? Or maybe as
kernel-doc for the functions themselves.

> +/**
> + * ieee80211_radiotap_iterator_init - radiotap parser iterator initializ=
ation

Oh, you have kerneldoc comments in the source file. Does anyone know
which is preferable? I usually put everything into the header file that
is not implementation-detail.

> +		 * no need to check again for blowing past stated radiotap
> +		 * header length, becuase ieee80211_radiotap_iterator_next
                                    ^^^^^^^
typo

> + * care of alignment handling and extended present fields.  interator->t=
his_arg

typo: "interator", also I don't understand why you would want to change
this_arg?

johannes

--=-JV5fI8yC5Y/gG6NnlPF8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGbS9c/ETPhpq3jKURAtZNAKCHCs2IRLA0R26UVxCHXam2daHyZACgjfqO
+zGWWOWL/5ytzg2Sag1KSIw=
=P0++
-----END PGP SIGNATURE-----

--=-JV5fI8yC5Y/gG6NnlPF8--

