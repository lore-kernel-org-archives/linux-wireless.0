Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59293 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbYAMV6f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 16:58:35 -0500
Subject: Re: [RFC PATCH 01/10] mac80211: A-MPDU Tx add session's and low
	level driver's API
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <rindjon@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <c85cb4470801130717l7b455ea7pa4de50b5be2c0502@mail.gmail.com> (sfid-20080113_151811_074302_1E3342C7)
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
	 <11999857491583-git-send-email-ron.rindjunsky@intel.com>
	 <1200068953.3861.180.camel@johannes.berg>
	 <c85cb4470801130717l7b455ea7pa4de50b5be2c0502@mail.gmail.com>
	 (sfid-20080113_151811_074302_1E3342C7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LVJ2agT3lgJKoPzVWd7c"
Date: Sun, 13 Jan 2008 22:58:12 +0100
Message-Id: <1200261492.5887.25.camel@johannes.berg> (sfid-20080113_215848_596631_AB53E509)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LVJ2agT3lgJKoPzVWd7c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > It seems to me that this should be per-virtual interface instead of
> > per-hardware? I guess ultimately it won't make a difference because the
> > RA will be unique but I think we should still keep it per-vif where it
> > makes sense.
> >
> I can pass only vif in all the API i give, and that's something that i
> am not sure about since you introduced vif - generally all functions
> can get hw just from having the vif, but still there are plenty of
> places in the code that i see hw being passed back and forth. is it
> just because API compatibility or because something else i need to
> consider?

Basically I'm thinking that everything that could in theory be
per-interface should be getting a vif. Say you have a multi-BSS AP. I
don't think it's really legal for a STA to associate to multiple APs at
the same time but want to avoid the code falling over when a STA
actually does associate to multiple of our virtual BSSes... Maybe that's
just unnecessary.

> > You actually need to write kerneldoc in two different comments so it ca=
n
> > be embedded into output properly
>=20
> code duplication in comments :-)

Yeah, heh, I know.

> Gladly! the really basic functioanlity I have already showed in patch
> 0/10. I guess you are thinking about something more then that so lets
> talk about it in a diffrent thread. i also didn't understand what
> header file you mean.

Right. I'll try to find some time to resurrect the mac80211 book. Then
when I post that we can talk about an 11n chapter.

> > Also, should we just call it _irq instead of _irqsafe? I personally
> > dislike the rx_irqsafe naming too.
>=20
> it is the same as the naming of tx_status_irqsafe and rx_irqsafe. you
> want to change this convention?

Well I dislike it only because it implies that you can call it from
non-irq contexts too, which you shouldn't. But no, I don't feel strongly
about it, stick with the _irqsafe you have.

johannes

--=-LVJ2agT3lgJKoPzVWd7c
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4qJc6Vg1VMiehFYAQLmVw/9FzC61zGSQ7rAXTg/QcWZJVNBAYhMO6iN
O9eUpE/H1o2Xf6uZj+0ZcN50gXJNPnOb85jyWchwU0/HXDt0ccGY7awSIBh3cdG9
YalCaI0BFVZXNSjcMyx/p8qaHCpz9k9EueT4uhWPYm6Q90QkG2iCbJxxUhrAVedK
odGwk3RXPpcPFA/zR+Fw5859sGETNHuD+9Lm12fr8XS+VITphy6FwcJ4TekFoiYj
EjXG5WR6Qm2FsavkyiDZ1lAsM4YjCPBW9J15lmliyRzW5ABPidz+CO4SkPZvkKNX
RAackyJXYNOslgyrHFwNOpjUEfCBALACkio1uex5hCT9oO+TYHdkU3aX+LKxZ3/B
O2uNbgaN4NuYix18QpTXUNJHdQHRDwekMVODycOfA2j82iPUMlB5NJIcsIZiULDk
i7Thw6svQH2L0nGqS3efrCb764LLdoReqam4r2x9xUaxM/TD5+eqyT9dMsAdQ4bo
wuzsmzjcFYLY6HYH/Ogubtxi/jqLaDY+OIzXthXdwK5aKJzJuLEWmXqjhM7eTnSR
c4jQh1hqYLAEKjkc/VUmm1vR8xpED31f2OyHbfaLn15ylmoBqvQxyzGhDC4XFaGM
lltGdMuuHGIEvLgeX8miA+b3QsLEhbDFhzSaj/jgkWJecEfQm3l94yC/746ZU0qB
sD+Cc/czlQk=
=w3MX
-----END PGP SIGNATURE-----

--=-LVJ2agT3lgJKoPzVWd7c--

