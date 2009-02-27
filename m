Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48888 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbZB0BlO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 20:41:14 -0500
Subject: Re: pull request: wireless-next-2.6 2009-02-23
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, mcgrof <mcgrof@gmail.com>
In-Reply-To: <20090226161340.GA4430@tuxdriver.com>
References: <20090223192659.GB3553@tuxdriver.com>
	 <1235457113.4455.89.camel@johannes.local>
	 <20090224.235510.30497146.davem@davemloft.net>
	 <1235637360.29050.16.camel@johannes.local>
	 <20090226161340.GA4430@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kbKDvDmrKJf/QQRDVtBM"
Date: Thu, 26 Feb 2009 17:37:20 -0800
Message-Id: <1235698640.4936.6.camel@johannes.local> (sfid-20090227_024118_144187_56658767)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kbKDvDmrKJf/QQRDVtBM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-26 at 11:13 -0500, John W. Linville wrote:

> > Now I just have to get around to fixing it, it's proving to be harder
> > than I thought, and I don't have much time right now.
>=20
> I suppose I could just drop that one.  IIRC there was another patch
> from you that depended upon that one as well?

Ok, so I looked into this, and it turns out that it's harder to fix than
I thought. Fixing the genl code to call the pre_dumpit at the right
place is hard and requires netlink (not genl) changes. I'm not in a
position to do such changes right now, so I would suggest to revert it,
and for now take the easy way of restructuring nl80211 to take, in each
operation, the rtnl before any other locks instead of trying to do this
generically.

Luis, would you be up to that? Basically go from

        mutex_lock(&cfg80211_mtx)
        ...
        rtnl_lock()
        ...
        rtnl_unlock()
        ...
        mutex_unlock(&cfg80211_mtx)
       =20
to
       =20
        rtnl_lock()
        ...
        mutex_lock(&cfg80211_mtx)
        ...
        mutex_unlock(&cfg80211_mtx)
        ...
        rtnl_unlock()
       =20
everywhere.

johannes

--=-kbKDvDmrKJf/QQRDVtBM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJp0PNAAoJEKVg1VMiehFY050P/0O8hIUYTp+lHmBSKjlDPm7b
j1fqf2KnMO32TYGicxQ4vYlydUH6WoM30U7VKNgwjdittXGg0ABB4jrej7q6QaWw
fCngP2Z3BTnr3odXiZnEyCR7iw56wEOXEPHySR2gX2McOYMYJ9J3SV/cuQt8Dguk
1aYjohbhT4AbAwtxZuYBuhZAzZm0L9giqKKgF+HiZmtT/0ywwyqdePY3qU7o0WFd
sxgYxJyaLHAv6YOS01bGd54L/d2sKw5TzfIasn3cXj3hnFiuyWM6hfuDyfNW4MZR
2a57P54WWQm3KlRszkZJq6TvNVTRSDcjk+TfhZFeCpkA4nKbDGTS2/5H0s3fflTD
XmtxF4Mj5Tt42ySV72mY1nGLlasmEyX8PevSGnJKBVNsPpT1E0KaSAs/uPofRH/3
8DDAcLllTkWF4+dCEP0O13waKEwzED8H5Citpe59dB+np7WpN3+jNKXi8yB/PR7Y
oTJJvTb5ontRd0WKlyft7yHs/2ySwuHkpyU0HjZhYfXINSvzTr9uUEWBDR4GaLcK
qrlXIZyNXFtiGzvBmV3ik4ACjbtLeZetpmMmghE5vNYAlZRcyUAk9NzUP28iWrOR
zPBTSqrMmnDQiFBbl2qYmoCOfudUXYem5Eo4s7+2Y/ZfQYiQpjqSQ+DeiG8pdedK
p+mDwx03XMSc1oQ61aXF
=Yjqh
-----END PGP SIGNATURE-----

--=-kbKDvDmrKJf/QQRDVtBM--

