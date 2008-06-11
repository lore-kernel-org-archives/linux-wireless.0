Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42129 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbYFKV0b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 17:26:31 -0400
Subject: Re: [PATCH 1/1] mac80211: [RFC] do not fragment while aggregation
	is in use
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1213207296-14548-1-git-send-email-ron.rindjunsky@intel.com>
References: <1213207296-14548-1-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-50LFepEaROBcy1PZCni0"
Date: Wed, 11 Jun 2008 23:25:26 +0200
Message-Id: <1213219526.3827.0.camel@johannes.berg> (sfid-20080611_232635_755755_3D1AE7D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-50LFepEaROBcy1PZCni0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Thanks.

> -	/*
> -	 * Warn when submitting a fragmented A-MPDU frame and drop it.
> -	 * This is an error and needs to be fixed elsewhere, but when
> -	 * done needs to take care of monitor interfaces (injection)
> -	 * etc.
> -	 */
> -	if (WARN_ON(tx->flags & IEEE80211_TX_CTL_AMPDU ||
> -		    skb_get_queue_mapping(tx->skb) >=3D
> -			ieee80211_num_regular_queues(&tx->local->hw)))
> -		return TX_DROP;
> -

Should we keep that, just in case? If it ever happens and the hw rejects
a fragment for some reason, we'll otherwise clobber some state and
probably crash.

johannes

--=-50LFepEaROBcy1PZCni0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUELCAAoJEKVg1VMiehFYi1oP/j3AvE12HqeR1m1c9mIR9LI6
/LiFxGsVdVA8yMpme53RHBR7A7xza61Zm7FYUty/nvc4T4QoCgkF5S6lA6uwq1Hb
SWhZvtoVu4BaUpnU4hqFhj7AEdy0mM+Q2yLORC/zMmXQMyfSRwpZDCV9/fRYwEkk
Earsvw5PYdIOJ5GT6cO4vYSS3n5T3cmxZWzA/3u6gczXpEk/1U0ytJ2P2TN93n9N
xxHkkun7+2XKpxVXy4993x5m/qygbPdIXwTpDRp874nPuyDKn2LH2WmyJWsbW/OI
7UiYhGon2SxMZBAX31QPE+qndidf0ZUZo9CM34YpFXaa8uKdIrEIkTsbCMkLGJpz
sYmcVnQ1dM3Qp6ujAb8SJkMIq/tDdVzOi4WWVH18Ar7SuuR1yPcMrLUbwOTZi8Hf
GE255+48wsElSDZVjMxwPMXP066UO8vLGFQCjdChG/JR1RNI2lX94MCc8YUAjnLv
nm/AcluIw+IAqajmR262lF+I07GfngGQ5byK9o0U53WuDe19sgtmJCzKYS4EeSnx
rYDlM5CFC5b7FlMlb4ri/CgVEceOK7Z7AHUnvsRJSpEw/ubpHlvi7WbGZVCEnNCl
WElExAi6SBwooLBctyCBvI6DDd73BdLVH0AtQ+wOUcgDLIcjJtTJCxbxiIznX5r3
l/xtCmRCxv4OfawaNpSn
=rM6P
-----END PGP SIGNATURE-----

--=-50LFepEaROBcy1PZCni0--

