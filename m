Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60772 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbZBXGgS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 01:36:18 -0500
Subject: Re: Lockdep rtnl_mutex and genl_mutex circular dependency
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090220023144.GE4740@tesla> (sfid-20090220_033236_226088_BAC87115)
References: <20090220023144.GE4740@tesla>
	 (sfid-20090220_033236_226088_BAC87115)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pspzLgWtiTKjFxF93OzY"
Date: Mon, 23 Feb 2009 22:35:52 -0800
Message-Id: <1235457352.4455.94.camel@johannes.local> (sfid-20090224_073621_026588_C3A80F8E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pspzLgWtiTKjFxF93OzY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-19 at 18:31 -0800, Luis R. Rodriguez wrote:
> Just running 'iw list' a few times I got this. I have a few patches on
> top of wl, but this doesn't seem to be related to those.

I see what's going on, it's the genetlink change, the code is:

        if (nlh->nlmsg_flags & NLM_F_DUMP) {
                if (ops->dumpit =3D=3D NULL)
                        return -EOPNOTSUPP;

                genl_unlock();
                err =3D 0;
                if (family->pre_dumpit)
                        err =3D family->pre_dumpit();
                if (!err)
                        err =3D netlink_dump_start(genl_sock, skb, nlh,
                                                 ops->dumpit, ops->done);
                if (family->post_dumpit)
                        family->post_dumpit();
                genl_lock(); =20
                return err;
        }

pre_dumpit does rtnl_lock(), and netlink_dump_start() will re-do
genl_lock(), so here we end up with a dependency of rtnl -> genl. But
in the non-dump path, we do the pre_doit() with genl held, getting
genl -> rtnl. We thus have to change the genetlink change, patch coming
in a minute.

johannes

--=-pspzLgWtiTKjFxF93OzY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo5VFAAoJEKVg1VMiehFY0LMP/2rAL27cXy4oTnw8c2ZXIxCM
YdZE6mZCgRFzyQf6EXH0IMSgo0c0GlvbqEX5b1nHQSHxu55zQto0O/eaXLNgGaYT
G7vOjLfmdyY+kCidHnGxUvIwwP5ss1YrdKz0/4Sv48E56IbfgxznzeAsqQvX6mwF
llom/hzOu22aAANdcpGAXSC+RPor6VcRq5CoQ6ieyT/HQ7CSKvtol3W5Kdwo8p/J
vK9syjA1uysjGEhxaEZDRhQo2pgNuLbaaQ9zkLfOBbaRsvyetQt7uMOH2FRcw3NL
wz1ZxMETa/xr6lbB5Y7rjYnmojUpizR3ejDEa4LkGz/+5FUwKQjDe5ZvhOtSQu4c
pHT6a1j6mXv9PH4R3aDf2rQdl8X6CJT7Us3he7Amtr4qj0ymElLndCK8Qcx7uBjU
GP9CjgxVsreUkDB3ESvutAd7maRnaemvM/dD2Yqp1psnmRzDoFuSo71tAIIvliKz
z+NxVwV93IxRNlYE7idXhJjVbj55iyJAQXZXZhyfAQyO9Lh1xSDIHnHUBJD4lDRj
VrzSR/VJ1WCYtXqMIs5ZJkLmEARTwFHcavwn9+ryK9x/5xYSjYpXUEltB/cXZh+R
3tp5gSmh925qDHAQ7rQuLTEEv9yaCC1MThOJLYuuigaZy+iHNa7SmmC9kSO6AQMd
JFRmQYW+nkbXEcTVphLe
=qkmt
-----END PGP SIGNATURE-----

--=-pspzLgWtiTKjFxF93OzY--

