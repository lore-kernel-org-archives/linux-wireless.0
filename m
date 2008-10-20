Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54488 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYJTIbZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 04:31:25 -0400
Subject: Re: [RFC] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Luis.Rodriguez@Atheros.com, tomasw@gmail.com
In-Reply-To: <18684.16351.638713.791015@gargle.gargle.HOWL>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nUSLO1tGsUnX13gpWhW5"
Date: Mon, 20 Oct 2008 10:31:20 +0200
Message-Id: <1224491480.18024.32.camel@johannes.berg> (sfid-20081020_103128_344384_947C5AAE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nUSLO1tGsUnX13gpWhW5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

=20
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -244,6 +244,11 @@ typedef unsigned char *sk_buff_data_t;
>   *	@tc_verd: traffic control verdict
>   *	@ndisc_nodetype: router type (from link layer)
>   *	@do_not_encrypt: set to prevent encryption of this frame
> + *	@requeue: set to indicate that the wireless core should attempt
> + *		a software retry on this frame if we failed to
> + *		receive an ACK for it



> + *	@is_part_ampdu: set to indicate that the wireless core should should
> + *		treat this frame as part of an AMPDU

I thought we said we could keep the flag instead of moving to the skb
here?

The next step, imho, is to remove all the "if (hw->num_ampdu_queues)"
stuff and figure out what kind of services mac80211 should provide.

johannes

--=-nUSLO1tGsUnX13gpWhW5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/EHUAAoJEKVg1VMiehFYcd4P/iW/MY63Dt7/fA3jGenH3skK
bG/PyGNAt+MNUt2Gz8DwyLfbizWQTWjX2c9PmhpFvF1fT67N87rjngn508G/bSnY
0NMMYpM8rRF9rlsTBRjjK1k0AP881r0GBwYMsQxBpPhMknZxLi/OwhSnxe9XWDNZ
DXTZGGDt4ZPHwuAo6VOSU+oIYpwvCJeoj2+8iABQktxTvRvSuyv1sPbzB+rIJZD3
pGQwABjRAQafgxGC6z4ANR+PykStsidj2NZg9PRAvU8ahJBYJ5mPB7K1nIE59VG/
3qpOh4NBzUMxlQztxUHLPXcB11+RZ0Qnzt/jnr6pLbg9wXttQBWV3QfMv+idPniU
22LVX5j83koqRTiG5bTP25AxBK1oEMxa6NbnyrsJQjGwxVS+PAroHiXaIk8Qr1bQ
WS+RYiwy0gpAdsH+aMugr08xCLPqlKNCoBH5YQS8IcYbK6rA5u7EGwSGTQHAMtjt
QhwspPMG/ZN3uPLKd+RBjoOFkCjTn4lOWrK4N6oLFNXFSL3v0tzxF3cESQi35wXA
lKXEmmtVOpF5KRSf9GQYyV2dJeTYa9ou9Kka/7N32SAyAj/74icqKAV7fnWSGZp8
PaNQjFHQ6ExH/bjhWXoYVeb0nKsFYlUPTDscvg/VC06S3FnJTn7Z7/LA+izPT5x7
BgcwKF1cdt++WlHCPLt/
=vAt3
-----END PGP SIGNATURE-----

--=-nUSLO1tGsUnX13gpWhW5--

