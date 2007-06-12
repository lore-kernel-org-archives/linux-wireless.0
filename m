Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:27875 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752793AbXFLIKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 04:10:16 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: andy@warmcat.com
Subject: Re: [PATCH Try#9 3/4] cfg80211: Radiotap parser
Date: Tue, 12 Jun 2007 01:09:19 -0700
Cc: linux-wireless@vger.kernel.org
References: <20070611152120.078733592@warmcat.com> <20070611152210.586082766@warmcat.com>
In-Reply-To: <20070611152210.586082766@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1539777.EUgCPdAmBt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706120109.23291.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1539777.EUgCPdAmBt
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 11 June 2007 08:21, andy@warmcat.com wrote:
> +struct ieee80211_radiotap_iterator {
> +	struct ieee80211_radiotap_header *rtheader;
> +	int max_length;
> +	int this_arg_index;
> +	u8 * this_arg;
            ^
Eliminate the space here between * and this_arg.

> +
> +	int arg_index;
> +	u8 * arg;
And here.   ^

> +	__le32 *next_bitmap;
> +	u32 bitmap_shifter;
> +};
> +
> +extern int ieee80211_radiotap_iterator_init(
> +   struct ieee80211_radiotap_iterator * iterator,
Here.                                     ^

> +   struct ieee80211_radiotap_header * radiotap_header,
You get the idea.                       ^

> Index: wireless-dev/net/wireless/radiotap.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- /dev/null
> +++ wireless-dev/net/wireless/radiotap.c
> @@ -0,0 +1,256 @@
> +/*
> + * Radiotap parser
> + *
> + * Copyright 2007		Andy Green <andy@warmcat.com>
> + */
> +
> +#include <linux/if.h>
Don't think anything from here is used.

> +#include <linux/err.h>
> +#include <linux/mutex.h>
We don't touch any mutexes in this file..

> +#include <linux/device.h>
Nor do we care about devices.

> +#include <net/genetlink.h>
Or netlink.

> +#include <net/cfg80211.h>
> +#include <net/wireless.h>
Or wiphys.

> +#include "nl80211.h"
> +#include "core.h"
nl80211.h and core.h seem unnecessary too.

All these includes might be pulling some other header that you do need,=20
however. (linux/kernel.h probably covers it..)

> +int ieee80211_radiotap_iterator_init(
> +    struct ieee80211_radiotap_iterator * iterator,
> +    struct ieee80211_radiotap_header * radiotap_header,
> +    int max_length)
> +{
> +	/* Linux only supports version 0 radiotap format */
> +
I think the code would look better without a blank line following the comme=
nt.

> +	if (radiotap_header->it_version)
> +		return -EINVAL;
> +
> +	/* sanity check for allowed length and radiotap length field */
> +
> +	if (max_length < (le16_to_cpu(radiotap_header->it_len)))
Unnecessary parenthesis. ^                                    ^

> +		return -EINVAL;
> +
> +	iterator->rtheader =3D radiotap_header;
> +	iterator->max_length =3D le16_to_cpu(radiotap_header->it_len);
> +	iterator->arg_index =3D 0;
> +	iterator->bitmap_shifter =3D le32_to_cpu(radiotap_header->it_present);
> +	iterator->arg =3D ((u8 *)radiotap_header) +
Ditto.                  ^                     ^

> +			sizeof(struct ieee80211_radiotap_header);
I usually like to use sizeof on a variable (eg., sizeof(*radiotap_header))=
=20
since it's shorter and doesn't need to be changed if the variable type=20
changes.

> +	iterator->this_arg =3D 0;
> +
> +	/* find payload start allowing for extended bitmap(s) */
> +
> +	if (unlikely(iterator->bitmap_shifter &
> +	    IEEE80211_RADIOTAP_PRESENT_EXTEND_MASK)) {
            +--------^
Indenting this a bit more to the right should look better.

> +		while (le32_to_cpu(*((u32 *)iterator->arg)) &
> +		    IEEE80211_RADIOTAP_PRESENT_EXTEND_MASK) {
                    +--------------^
Ditto.

> +			iterator->arg +=3D sizeof(u32);
> +
> +			/*
> +			 * check for insanity where the present bitmaps
> +			 * keep claiming to extend up to or even beyond the
> +			 * stated radiotap header length
> +			 */
> +
> +			if ((((int)iterator->arg) - ((int)iterator->rtheader)) >
> +			    iterator->max_length)
=46or pointer arithmetic, you should use unsigned long. The parenthesis are=
 a=20
little too paranoid here too.

> +		if ((((int)iterator->arg)-((int)iterator->rtheader)) &
unsigned long for pointer arithmetic and reduce parenthesis, as before. See=
ms=20
to be a lot of this, so I won't mention it again.

> +		    ((rt_sizes[iterator->arg_index] >> 4) - 1))
> +			iterator->arg_index +=3D
> +				(rt_sizes[iterator->arg_index] >> 4) -
> +				((((int)iterator->arg) -
> +				 ((int)iterator->rtheader)) &
> +				 ((rt_sizes[iterator->arg_index] >> 4) - 1));
> +
> +		/*
> +		 * this is what we will return to user, but we need to
> +		 * move on first so next call has something fresh to test
> +		 */
> +
> +		iterator->this_arg_index =3D iterator->arg_index;
> +		iterator->this_arg =3D iterator->arg;
> +		hit =3D 1;
> +
> +		/* internally move on the size of this arg */
> +
> +		iterator->arg +=3D rt_sizes[iterator->arg_index] & 0x0f;
> +
> +		/*
> +		 * check for insanity where we are given a bitmap that
> +		 * claims to have more arg content than the length of the
> +		 * radiotap section.  We will normally end up equalling this
> +		 * max_length on the last arg, never exceeding it.
> +		 */
> +
> +		if ((((int)iterator->arg) - ((int)iterator->rtheader)) >
> +		    iterator->max_length)
> +			return -EINVAL;
> +
> +	next_entry:
> +
A blank line after a label doesn't look right to me..

> +		iterator->arg_index++;
> +		if (unlikely((iterator->arg_index & 31) =3D=3D 0)) {
> +			/* completed current u32 bitmap */
> +			if (iterator->bitmap_shifter & 1) {
> +				/* b31 was set, there is more */
> +				/* move to next u32 bitmap */
> +				iterator->bitmap_shifter =3D le32_to_cpu(
> +					*iterator->next_bitmap);
Move "le32_to_cpu(" down to the next line.

> +				iterator->next_bitmap++;
> +			} else {
> +				/* no more bitmaps: end */
> +				iterator->arg_index =3D sizeof(rt_sizes);
> +			}
> +		} else { /* just try the next bit */
> +			iterator->bitmap_shifter >>=3D 1;
> +		}
> +
> +		/* if we found a valid arg earlier, return it now */
> +
> +		if (hit)
> +			return iterator->this_arg_index;
> +
Another unnecessary blank line. ;)

Thanks,
=2DMichael Wu

--nextPart1539777.EUgCPdAmBt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGblSzT3Oqt9AH4aERAkHbAJ4vhxKSl2egCaQiYK0fILj2Y/ZSiQCgpSmB
KOsn4RYlVWnYjCk9v8cKuDE=
=UnBv
-----END PGP SIGNATURE-----

--nextPart1539777.EUgCPdAmBt--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
