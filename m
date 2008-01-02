Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47553 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbYABIiO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 03:38:14 -0500
Subject: Re: Warning emited by 2.6.24-rc6-git5
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: chris2553@googlemail.com, linux-wireless@vger.kernel.org
In-Reply-To: <200712291614.55732.IvDoorn@gmail.com> (sfid-20071229_151440_586991_1DD83E1A)
References: <200712290942.37396.chris2553@googlemail.com>
	 <200712291529.10357.IvDoorn@gmail.com>
	 <1198939208.4172.46.camel@johannes.berg>
	 <200712291614.55732.IvDoorn@gmail.com>
	 (sfid-20071229_151440_586991_1DD83E1A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-e+WMG9NyVXw8PfyCGsum"
Date: Wed, 02 Jan 2008 09:11:12 +0100
Message-Id: <1199261473.4172.58.camel@johannes.berg> (sfid-20080102_083824_559634_5B4DF635)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-e+WMG9NyVXw8PfyCGsum
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Happy New Year! I was out since Saturday just before you sent your
message, sorry for the late reply.

> 	header_size =3D ieee80211_get_hdrlen_from_skb(entry->skb);
> 	if (header_size % 4 =3D=3D 2) {
> 		/*
> 		 * Move entire frame 2 bytes to the front.
> 		 */
> 		skb_push(entry->skb, 2);
> 		memmove(entry->skb->data, entry->skb->data + 2,
> 			entry->skb->len - 2);
> 	}

That doesn't really look right, I'd think the skb will be two bytes too
long after this. It's probably more efficient to decide where to copy
the frame and do the realignment while you're copying it anyway rather
than doing a copy and then a memmove.

I guess you should also try talk to Ralink to get firmware to do it
(where possible), it's probably not too hard to insert padding before
the frame.

If you absolutely can't get the hardware to do it and would otherwise do
DMA right into the skb we should try to evaluate the performance hit on
platforms where unaligned access *is* possible to be able to balance it
against the performance hit caused by the memmove(). Ultimately, though,
I value correctness on all platforms over performance on some, hence the
warning when unaligned packets are handed up to mac80211.

johannes

--=-e+WMG9NyVXw8PfyCGsum
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3tHH6Vg1VMiehFYAQKGuBAAu2qQwkbagavEkLpo/Zv1aydXILEdYZQD
0EyzY1ZpNCuog+ttB6GrSoe036r5jrwT5KDulu+tRqzaoW7l1/NS3emz3No3eP/4
KPrnmrUlk7eAmHWtNmbRyNnO4y6Pw4RgOsAn1fxM/KnS/tQEG4DJvBq6/P8f0oKh
Rli24Ah9ozUOXNs/e8qPduGV4apimCj+GQh7lp3dPqLIB2bSbch6cTJiaoAeBcNK
CQDHheaOZ7Aty+zFeDFcminWzczbKs54XzM7WZijdNATb0j3yXn2ZG29Pvyk5qDe
b+0M9Fk8aSogrx3iVETlQViZ9D5S/wqXH9ogTb86tBL9oPB/lqR7B52lpa02MswY
8c9LCc2RngK7gyO4TGi1LEucpvKlSwmHg8dhTT19rriyKuTl6ssYJ0uElXkh1Ij5
+sYMgdx+WsU5ucruGnbhK7BN9nK1i0zq6DQc94XD/agzOqUDr7Yyh7tXkvzgJUQv
JAGMb2yGYvM+D6oKrkd/3tM/nVQNIfISYQc+OT/GCK7fqFr2T7kOnMsFCIw1whRC
zlKYY3oqlaZvmuaGXx+UA7KR93+7nnFdflRg9GYXdY/WcS8SunwaqHCcc72HMycq
ABSPgfvTozPg9uSLgG4vkfw1BSTdQa2Db2m7/w29SwXs6JVZOGNaKsYZQfu0JbAG
EKvEoTv8rG4=
=Y0Wz
-----END PGP SIGNATURE-----

--=-e+WMG9NyVXw8PfyCGsum--

