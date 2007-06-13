Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:11557 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751624AbXFMFnG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 01:43:06 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: andy@warmcat.com
Subject: Re: [PATCH Try#11 3/4] cfg80211: Radiotap parser
Date: Tue, 12 Jun 2007 22:42:03 -0700
Cc: linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>
References: <20070612130435.896010304@warmcat.com> <20070612130502.157979021@warmcat.com>
In-Reply-To: <20070612130502.157979021@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9381852.uTGkktKxJt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706122242.08045.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart9381852.uTGkktKxJt
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 12 June 2007 06:04, andy@warmcat.com wrote:
> +typedef enum  {
> +       RADIOTAP_PARSER_OK = 0,
> +       RADIOTAP_PARSER_DONE,
> +       RADIOTAP_PARSER_INVALID
> +} ieee80211_radiotap_parser_retcode_t;
Yuck. I much prefer the standard error codes used in the previous version..

> +extern ieee80211_radiotap_parser_retcode_t ieee80211_radiotap_iterator_init(
> +   struct ieee80211_radiotap_iterator *iterator,
> +   struct ieee80211_radiotap_header *radiotap_header,
> +   int max_length
> +);
Move the end of the parenthesis up a line to max_length.

> +ieee80211_radiotap_parser_retcode_t ieee80211_radiotap_iterator_init(
> +    struct ieee80211_radiotap_iterator * iterator,
                                           ^

> +    struct ieee80211_radiotap_header * radiotap_header,
                                         ^

> +	/* find payload start allowing for extended bitmap(s) */
> +
> +	if (unlikely(iterator->bitmap_shifter &
> +		     IEEE80211_RADIOTAP_PRESENT_EXTEND_MASK)) {
> +		while (le32_to_cpu(*((u32 *)iterator->arg)) &
                                    ^                    ^

> +ieee80211_radiotap_parser_retcode_t ieee80211_radiotap_iterator_next(
> +    struct ieee80211_radiotap_iterator * iterator)
                                           ^

> +		if (((ulong)iterator->arg - (ulong)iterator->rtheader) &
> +		    ((rt_sizes[iterator->arg_index] >> 4) - 1))
> +			iterator->arg_index +=
> +				(rt_sizes[iterator->arg_index] >> 4) -
> +				((((int)iterator->arg) -
> +				 ((int)iterator->rtheader)) &
> +				 ((rt_sizes[iterator->arg_index] >> 4) - 1));
> +
This part would probably look better if you stored:

((ulong)iterator->arg - (ulong)iterator->rtheader) & ((rt_sizes[iterator->arg_index] >> 4) - 1)

into a temporary variable.

-Michael Wu

--nextPart9381852.uTGkktKxJt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGb4OwT3Oqt9AH4aERAqE2AKC0MluRB9r5qUGXwFrxLb07wfGSlwCgmTgm
oRhbTZke9YvCpEM86VH9opo=
=Hl4n
-----END PGP SIGNATURE-----

--nextPart9381852.uTGkktKxJt--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
