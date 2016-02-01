Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35825 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbcBAM4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 07:56:12 -0500
Received: by mail-wm0-f51.google.com with SMTP id r129so69043243wmr.0
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2016 04:56:11 -0800 (PST)
From: Sven Eckelmann <sven@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, thomas@net.t-labs.tu-berlin.de,
	antonio@open-mesh.com, nbd@nbd.name
Subject: Re: [PATCH] mac80211: minstrel: Scale expected_throughput by 10
Date: Mon, 01 Feb 2016 13:56:08 +0100
Message-ID: <7460390.ua0GvOE4DE@bentobox> (sfid-20160201_135615_944357_33A51823)
In-Reply-To: <1454329837.3211.2.camel@sipsolutions.net>
References: <1454329450-31527-1-git-send-email-sven@open-mesh.com> <1454329837.3211.2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart8557171.Dp5HkQJJtj"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart8557171.Dp5HkQJJtj
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday 01 February 2016 13:30:37 Johannes Berg wrote:
> On Mon, 2016-02-01 at 13:24 +0100, Sven Eckelmann wrote:
> > The change from cur_tp to the function
> > minstrel_get_tp_avg/minstrel_ht_get_tp_avg changed the unit used for
> > the
> > current throughtput. For example in minstrel_ht the correct
> > conversion between them would be:
> > 
> >     mrs->cur_tp / 10 == minstrel_ht_get_tp_avg(..).
> > 
> > This factor 10 must also be included in the calculation of
> > minstrel_get_expected_throughput and
> > minstrel_ht_get_expected_throughput to
> > get similar results as before the change.
> > 
> 
> 10 is a pretty expensive factor, perhaps that should use 16 instead?

Not really funny but I will change the title.

Kind regards,
	Sven
--nextPart8557171.Dp5HkQJJtj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJWr1XoAAoJEF2HCgfBJntGKdIP/08+n8CrtbhawuwirBoGWPJk
RXKlu5GChV2ikKaHTy1xheIIgDzimIR5XQi5taqIfBe5B/PcDNdXJIH9QilZ6xCN
ixLENHjhrZKlEkP7RZcTi2UpUXZnVmLv4g09LAoBjXLrVeAa0DM3n4o1lu5kva9D
/bQ2Q9Ob7wPLlKp948y6HVHv1dZD1+ZJMKdypvybQJbwTFhTSCn03pEHcXWGYQ20
VR2LC80TIhffbs+wFz8VmFizBCK5lYybDeZHCwUl2o7nDZGhsuov58qULP7d4Eic
dCHPoz5G6OuIKnk7LPsS+Mu6l28HDYFmNlHceqvbZ5hmcBQ4oRMEJ+fzA6P9l7WH
R+LtpKzIyKvrH6SknS4TGvFOfxauMXXiu2BRDcc/G4nAU4UseZDQqXs2ZPyRlGdY
2Ys8T1iAhV1UQhbonETfEzzdkx5Smrs5rzNKfJR2rbyd/Sn9ntJ73BKUm6mq68Qo
Se1+HYQDApxcE14zUlYg/6pvRsQqgzX6t6qqmypkolnd4th6VbWPh430DcWgMpY9
JrDZ9kKSWAl9rfVOcEGSd/uybv5qNzyegT4axzs4xl4vvPWcGNwkanezBLJbwJo0
J5CuqubnbYI85KamIYtqJgQjrBgAObeJhBFPBAQW6mmAFZ2l0aFOtwEjE9xmKptw
75NYi7Z59LSSphKnkqwE
=st2y
-----END PGP SIGNATURE-----

--nextPart8557171.Dp5HkQJJtj--

