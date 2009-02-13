Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45231 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZBMII5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 03:08:57 -0500
Subject: Re: [PATCH 6/6] cfg80211: move regulatory hints to workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890902122357g26bf3dd4j930de7c1f6c28280@mail.gmail.com> (sfid-20090213_090325_171722_FA5880AF)
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-6-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-7-git-send-email-lrodriguez@atheros.com>
	 <1234508187.1327.19.camel@johannes.local>
	 <43e72e890902122309q61036a23k2efeb14fe3a6e814@mail.gmail.com>
	 <43e72e890902122314m2966471dm3a9485a91e8e927@mail.gmail.com>
	 <43e72e890902122314r6b9e881cg5538523780e808ef@mail.gmail.com>
	 <1234509436.1327.25.camel@johannes.local>
	 <43e72e890902122335l6580dbc1m44702996cc8200e4@mail.gmail.com>
	 <1234511334.1327.34.camel@johannes.local>
	 <43e72e890902122357g26bf3dd4j930de7c1f6c28280@mail.gmail.com>
	 (sfid-20090213_090325_171722_FA5880AF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6HVfxYN+OiNLjuGMzAgp"
Date: Fri, 13 Feb 2009 09:08:49 +0100
Message-Id: <1234512529.1327.38.camel@johannes.local> (sfid-20090213_090902_173447_5D19B81B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6HVfxYN+OiNLjuGMzAgp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-12 at 23:57 -0800, Luis R. Rodriguez wrote:

> To answer that question -- reg_mutex just protects the
> reg_requests_list linked list. That's it. Without that you could
> potentially have two userspace reg hints while the workqueue runs.
> Remember that the hints no longer lock except to just add a new
> regulatory_request into the reg_requests_list.

Right, ok.

> >> Driver hint also does the same so it seems your fix on nl80211 would
> >> probably just tap this series on the nl80211_req_set_reg().
> >
> > Yeah, I think I'll work on top of your series anyway so I don't clash
> > with the cleanups.
>=20
> Any other comments on the series?

Not really, looks pretty good to me. It does seem a little dubious to
return an error from a hint function and then not attach the hardware,
but that's up to you what you want to do in ath9k I guess -- seems it
should work ok even if the hint failed, though of course then you'll not
have memory for anything else either...

johannes

--=-6HVfxYN+OiNLjuGMzAgp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJlSqOAAoJEKVg1VMiehFY9YkQAIPadnYZpgJIs76UvS9K0UgB
npWJHd1FAV4AqO5e4vaW5D9yBa/Qg6WLx4ImB0tdtZVFnf5Mw52ANTE6cxpEFi0i
xxfstijKNxlQTHtId7V30IQD7UIavlgYnt+ORXfVleEKvVFwLz89cUaBz/FU+iQY
pz9a07f4QGUoyGDV7jSGU0r/Knpkl6ErXTICXtiNdGY+oSrLngLG3sWkBofAkcgN
vmLppTZQaRzmQhgKCFe/pwKyvVecX4nbFC+srEGW6XBCkiEJ5vm9zpQ6VJYnK0/n
SfHS+ty5xl9IdfK1V3nDJCphLhsaUs24WRUsXPSz/ByXNH64akkP4X6UsIr1IITo
RNkX5/ZUuSrFhmupjIoGGFJUS9MqL6sPZfmqzawGz590G0dw3FHqcpjCzyOK6LI6
Q2CZJteZE/foWL5GahBWPFGXD+ZxTNFpJSJOYpKa24tGqAA3WnQzcDRqaj2l3b0A
iX1FUohH4/cPBXrowK4GoPU03k+pgAn7MbChhErdVuBKaxLWV8bpRg+1kb4F90m0
bNB8ZjVlqRep6El3gl/4L23BpOFoRkUb1QP5HCw9uVM6U1/x1Sqh0PekzQNvhE66
8nPnYO3061ld0E8XxYiQXxZhPEc1qe5+Ft8ovwuo9q119AjPBVG0vT499ES6+OTG
3cdVtrNhukebHP7+xxPh
=6FfJ
-----END PGP SIGNATURE-----

--=-6HVfxYN+OiNLjuGMzAgp--

