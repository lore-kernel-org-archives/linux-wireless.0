Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39254 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbZK0Jd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 04:33:27 -0500
Subject: Re: [RFC 1/2] wireless: add ieee80211_asmdu_to_8023s
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1259314217.12157.3.camel@debian>
References: <1259215413-16753-1-git-send-email-yi.zhu@intel.com>
	 <1259229943.32372.50.camel@johannes.local>
	 <1259290376.13126.219.camel@debian>
	 <1259313653.5428.5.camel@johannes.local>  <1259314217.12157.3.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xjCJEzVgZTLp9dcW4bbl"
Date: Fri, 27 Nov 2009 10:33:27 +0100
Message-ID: <1259314407.5428.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xjCJEzVgZTLp9dcW4bbl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-11-27 at 17:30 +0800, Zhu Yi wrote:
> On Fri, 2009-11-27 at 17:20 +0800, Johannes Berg wrote:
> > Is it? I don't think so. Many drivers go up beyond that as far as I
> > know. Then some do different things like putting it in a different DMA
> > block.
> >=20
> > > While for those drivers really need a bigger
> > > extra headroom and support Rx aggregation, this probably means
> > > ieee80211_skb_resize. But the resize should always happen for every
> > > packet from the IP stack, right?
> >=20
> > No, davem and I optimised that away a long time ago via using
> > netdev->needed_headroom and netdev->needed_tailroom. It even works for
> > bridges and their slave devices, iirc.=20
>=20
> I missed this. Will check it. If so, I'll add another parameter to pass
> the extra hw tx headroom to ieee80211_asmdu_to_8023s.

The thing is that I'm not even sure if we can possibly forward a frame
after this deaggregation. I'll poke at the code.

johannes

--=-xjCJEzVgZTLp9dcW4bbl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLD5zkAAoJEODzc/N7+QmaF94QAIODJ8eym78eUMCWjbi9/Kpw
gs95Fms5X4SpNNU5calL4d8l5/PKyzWI0OG505q8u2TsF6aNW8bkyjNaJd23+lbp
lqkzKuTE37Pyhdju3Psbtkbt5LfyG8YkFPolfQOqxwLWf2cdTJr9cFr4N5N/TzRe
+ZYgKTlHAhvKa4JEy4t8/gh4fXbmbJp4XOHp8duEIrDF08k00jQ5dkHCmAZED0RN
c+ZomM13kSa1W75Wf5wVvw2cESEiTS0HkR4mDhzAd+6SsMzfPFQ7npFVKFUaHd4g
2mC0EgzIY1XKLrMdUlSMHtI4aAMsuMc4zg5sAPakjWx6fXIg4/83ajCYKER0C8Vf
qQIFf8GmF40XyF5iCjsgTRcNuaXxBYXjpH5Nst+aDxN9iqmlqu4tlQoqgnR4ajA2
MHDh8W6UNiIX4ZTj7LItMMjnC2E56669UxG/UjAUPYr+iayHYhQ9hTBrilihcHIG
XGGSIJ/YX0mTNE3SSAgKm5+reYQi2q/winIlYGFQQAc6o9WTLxiYt/xpNjc+tqpG
WM5oYUEFblUvm0dBLZfbR0Tm6oKogn81Vctr8mQ19PtS1FiGExw6+2wPy4PE+H9I
F6kcCo2xRSNaz3PDm2jbd8XGigFy0baIXKQ7ysGzNjlBohuhKq6RcEQqH4hheLBt
mbmTCkVl+sx4i2Z4zOpT
=/z01
-----END PGP SIGNATURE-----

--=-xjCJEzVgZTLp9dcW4bbl--

