Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39265 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbXIFMCk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 08:02:40 -0400
Subject: Re: [RFC] per-sta reassembly buffers
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070906020611.GJ5273@jm.kir.nu>
References: <1188988102.9942.89.camel@johannes.berg>
	 <20070906020611.GJ5273@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aQAzFv7bdqudNpDY6zuT"
Date: Thu, 06 Sep 2007 14:03:58 +0200
Message-Id: <1189080238.28781.63.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aQAzFv7bdqudNpDY6zuT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-05 at 19:06 -0700, Jouni Malinen wrote:

> I would have expected STAs to transmit only one MSDU at a time to any
> given destination STA.

Yeah, me too, but I came to challenge that expectation recently :)

> This was the way it was done before QoS and I did
> not find any clear point in QoS changes that would have changed the
> behavior. The changes in the duplicate detection are, though, implicitly
> pointing out that there may actually be separate fragmentation for each
> TID.

Right. Not very specific. Maybe something for 802.11ma, if it hadn't
been dissolved ;)

> The main reason for the original design was in being conservative with
> memory use. After all, this was used for embedded devices with very
> limited memory capabilities and the AP was actually allowing up to 2007
> STAs to be associated. If each associated STA were to use fragmentation
> and if there were large number of lost (un-ACK'ed) frames, the total
> memory buffers needed for the frames could go quite high.

Yes, I understand, hence my question.

> Since fragments are commonly sent out in a burst that includes the full
> MSDU, the number of pending fragments from unfinished MSDUs is often
> quite a bit smaller than the worst case.

Obviously. Since we're talking about a single station having a
fragmented frame outstanding in each access category, this would mean
that others stations would have to contend very much in the voice
category to even allow this situation to happen. Not very likely.

> Anyway, I would be fine with changing this as long as there is a way of
> enforcing the total number of buffered frames to be below a reasonable
> (and preferably configurable) limit.

Good plan actually, implementing it would probably require having the
skbs on two lists: one per station to lookup and one global list to age
them. Shouldn't be hard to implement at all, I'll look into it.

johannes

--=-aQAzFv7bdqudNpDY6zuT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3+yu/ETPhpq3jKURAno3AJkBkuROf2rXZp6mQptuzJkd19TW5ACdEAOB
NlfBKvSYH7+jtsnjm9VdOLg=
=zLTL
-----END PGP SIGNATURE-----

--=-aQAzFv7bdqudNpDY6zuT--

