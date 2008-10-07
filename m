Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39694 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbYJGTex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 15:34:53 -0400
Subject: Re: [PATCH] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Christoph Hellwig <hch@infradead.org>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240810071228m52a60861r5558529426b9b487@mail.gmail.com> (sfid-20081007_212834_461753_187EE1B3)
References: <1223311803.15196.36.camel@johannes.berg>
	 <1ba2fa240810061135t24f2dfbv2a5eb0cd5d9e8cd7@mail.gmail.com>
	 <200810070821.56462.hs4233@mail.mn-solutions.de>
	 <20081007071529.GA5010@infradead.org> <20081007131615.GR3448@tuxdriver.com>
	 <1ba2fa240810070703j471faa30mce3678febf3c20e8@mail.gmail.com>
	 <1223398724.7328.45.camel@johannes.berg>
	 <1ba2fa240810071228m52a60861r5558529426b9b487@mail.gmail.com>
	 (sfid-20081007_212834_461753_187EE1B3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-J5+c8dOZL+V05lrkSmRi"
Date: Tue, 07 Oct 2008 21:34:44 +0200
Message-Id: <1223408085.3618.2.camel@johannes.berg> (sfid-20081007_213457_543385_F66BFE62)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-J5+c8dOZL+V05lrkSmRi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-07 at 21:28 +0200, Tomas Winkler wrote:

> > And please keep the 10 pairs -> 20 addresses, it's a lot easier to
> > understand :)

> I don't like on this solution two things one is that it 32 bit
> variables sits on unaligned address

That doesn't matter at all since it's packed, and the bitwise accesses
you did previously are way less efficient.

>  and second
> it doesn't mach HW description which defines this as  descriptor couple

Then tell the HW engineers to fix the HW docs. It makes no sense at all
to say this is 10 pairs rather than 20 single ones if there's nothing
that uses a pair, the whole thing entirely uses single entries in the
numbering etc.

johannes

--=-J5+c8dOZL+V05lrkSmRi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI67nRAAoJEKVg1VMiehFYKPsP/1FBWMo6tHYv0SrZ+VUYHRdO
bQFDySlY2db/utkUFMHTBEMPZdrQzxB65J9nuZoPmsVJnGWWbpISgv1lHLFwBQFH
52IbPYNmYkq/ERMHFGE49RJjDInUn+KlEMRwCaR5WHQUUZ5Wg1cKHFQSHLQEC/AB
zlf4CaIDa+91yaiu9NCHgXRxFP69O9Kq1Uj/pkAOo5zY/DxyrrXIsCDhkaxcF9W4
ibJV+W5GF9laAHpvZumLa5NQxYNOcomwJYJecgU/pJXf1Spi2J7BjvJafXjatr/l
qfqrd9t6EXOiNaH31GUrNY0nKmVDqp3YKSsI3EDNv+MTw8rc282bl1sZc2PCZKdp
NFcTgA3FVtN8E57FE+rxiyWnA+0k6O5qTNTwwj9Cwnt12ieGCTofwQ/Zvj9sa44M
LdnJM9CiDvrVK3nq/VjxGM6HZhAdM0r6If8+Bfhlp2n3XjpeQT0JFfP0irKYiQC4
XIx9mRJRXc2vxDLYtNYY18Kz84kbNLhK/eWtwejj2+hX6vE4QBcuiQmoQ4HFPLiW
mUv/eD5hJ1tNp7m4kMsBFBAexE+1UEWoEgM50hWp65zQyAjz394Hi9RVoCfVLGTt
gPoQqQszKKIp7sV+qdEmVRlLgjtAF/lITrElpjeVYkfVADe8p6ZFK/827/ogQhrK
6QI39wEFnImN4Tz3q/iu
=FBmS
-----END PGP SIGNATURE-----

--=-J5+c8dOZL+V05lrkSmRi--

