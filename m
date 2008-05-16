Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38704 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbYEPVMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 17:12:30 -0400
Subject: Re: [RFC-PATCH] mac80211: add helpers for frame control tests
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1210971848.5915.58.camel@brick> (sfid-20080516_230412_000613_CA74646C)
References: <1210966154.5915.50.camel@brick>
	 <1210966704.5915.51.camel@brick>
	 (sfid-20080516_213833_934385_1E372539)  <1210969866.6381.46.camel@johannes.berg>
	 <1210971848.5915.58.camel@brick> (sfid-20080516_230412_000613_CA74646C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HzJNnqBrGEh+WXjydsVK"
Date: Fri, 16 May 2008 23:12:15 +0200
Message-Id: <1210972335.6381.52.camel@johannes.berg> (sfid-20080516_231234_710145_F6075027)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HzJNnqBrGEh+WXjydsVK
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> > > +static inline int ieee80211_fctl_has_a4(struct ieee80211_hdr *hdr)
> >=20
> > That seems fine too.
> >=20
> > > +static inline int ieee80211_ftype(struct ieee80211_hdr *hdr, u16 fty=
pe)
> >=20
> > That, I think, is misnamed, it should be ieee80211_is_ftype()
>=20
> Well, I didn't expect this to be used directly that much, hence the
> following three helpers...ftype_mgmt/ctl/data

Right. Still, I think it should be named with _is_ in there.

> > > +static inline int ieee80211_stype(struct ieee80211_hdr *hdr, u16 sty=
pe)
> > > +{
> > > +	return (hdr->frame_control & cpu_to_le16(stype)) !=3D 0;
> > > +}
> >=20
> > And that even seems implemented wrongly? stype is a 4-bit field, this
> > doesn't make much sense to me.
>=20
> It was meant to be used to replace code like:
>=20
> =EF=BB=BFfc & IEEE80211_STYPE_QOS_DATA
>=20
> =EF=BB=BFieee80211_stype(hdr, IEEE80211_STYPE_QOS_DATA)
>=20
> As most users of the stype bits test against a specific constant,
> otherwise you could add a bunch of helpers, one for each stype
> constant (similar to the ftype helpers I added.  There were only
> 3 in the ftype case, so I just added them all and dropped the second
> parameter, in the stype case, there are more options, so I just
> left one two-parameter helper.

Well, yes, but that's semantically unclear because of the way these bits
are used vs. how they are called. The subtype (stype) is a four-bit
field in the frame control field which isn't actually defined to have
"flags" or bits like that in it. Look at the table in IEEE 802.11-2007,
it's at the beginning of clause 7 somewhere.

Hence, hiding this simple AND behind a function that claims to check the
subtype is confusing.

johannes

--=-HzJNnqBrGEh+WXjydsVK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC34rqVg1VMiehFYAQJgUhAAxXq2q14ona+rtl8PYDLSK+lEH9taQavN
nCI1tVCYhOXMG4/aVV6183bR30UOrknBVTZIGjw6OTo1Ts0x/iAlxVnnGYxN+9+h
99XG0w0dAeRpf2S1YYIJ2xF9kdaB8Rt+RqX0rnJGemnk4aYc4EIT3yRlb7Qkkkv3
QN988wEMTbgYysEefj6IGzxSZYX1+sdFFCcle9wIVjbVAXtkaWtGIobOmh4eXG0C
E/U63tqO1MSgwIQ0+EUaKIL7c1QTqTn1uSp6KucLcc0ezZ0hhcK3IGs9/Yqr0390
AwPIXuUnmz/FmYmpRjapnJ9d3rkkj/uzqh/0go96Rb5503P8JEk8sBttZX3xwil2
XJ2cCNVXjfx3XxDyjlqsoXgS8aERXlj8C/52XFCjcVpkqDSr8LycYQnEkz7nop1/
rdYpcc8KK2RI0MjJvy1z8HJMldg00tYBPZ96+1nMPI3keM+JqAFEHC5ox0FIxWsr
TOOsW4KHntYmA4XEQ56HF3k5Y5f3kLICPhkbaxB5zhZk2PlueGR3zqRFMdV31O5i
wLyyw4fRpscizKrcyd5coVxGRFbTHVNeoLqLMbj/USUGvqhyqDEisLDcex9uIrFl
nQVB8sS9G106PDPu9dn0nue6ynIz1dsmJr2dx8VBS9bceU4WxGaJXaWjwpUNtF2I
9HXrI5AEe0E=
=pfMn
-----END PGP SIGNATURE-----

--=-HzJNnqBrGEh+WXjydsVK--

