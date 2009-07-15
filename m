Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60277 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbZGOSSN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 14:18:13 -0400
Subject: Re: [PATCH] mac80211: don't sleep in mesh_path_add allocation
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com
In-Reply-To: <1247680936-21513-1-git-send-email-andrey@cozybit.com>
References: <1247680936-21513-1-git-send-email-andrey@cozybit.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1cDIsl19uis3CTk1vQZD"
Date: Wed, 15 Jul 2009 20:17:43 +0200
Message-Id: <1247681863.10754.26.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1cDIsl19uis3CTk1vQZD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-15 at 11:02 -0700, Andrey Yurovsky wrote:
> mesh_path_add allocates an mpath and a node but it is called with RCU
> held.  Use the GFP_ATOMIC flag to prevent these allocations from
> sleeping since otherwise we can hit the following sleep-while-atomic:

This isn't sufficient, quoting from the function, highlight added:

int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
{
...
        if (grow) {
                struct mesh_table *oldtbl, *newtbl;

                write_lock(&pathtbl_resize_lock);
                oldtbl =3D mesh_paths;
                newtbl =3D mesh_table_grow(mesh_paths);
                if (!newtbl) {
                        write_unlock(&pathtbl_resize_lock);
                        return 0;
                }
                rcu_assign_pointer(mesh_paths, newtbl);
                write_unlock(&pathtbl_resize_lock);

*******         synchronize_rcu();
                mesh_table_free(oldtbl, false);
        }
...
}

johannes

--=-1cDIsl19uis3CTk1vQZD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXh1DAAoJEODzc/N7+Qmar54P/2y3LcOmJtfBBsyEAOqVGj/I
98bPMLNn5J1KdTRp4h6DTnceJV5Q8S9yW8qUYMBmPq2pxWBr7R1l3pANuTdfUW5d
/XLXs2ywdk9nkFqe8FMJgOYsWr2ERwR6P4xtDfjM7q6UbZSn35Upfm1FsqL9hYiV
nPxlMCvEk0pTOpzdi46rzFOz/2ut7+EB/KtcIN/0DuL1Xa64VshTdb1ZYZz9DVSW
szz6dpvMowsns1xGSUXIoy7eHHXnjr9qj6Y3xf4ODNyfH8LJBNiDWYSYE0+Gmad9
E6G7I+mOkOMYvjU3JeqqSPcc7JVd2GWWx3Y5wtRLrRO+ug8IGmUxhFMEn6TshBCh
spNVKxYxvH61RsJDE4iRhrv/YWuJWZgcbc9AWNNHVueY+PmrwbLaVuDfH9umFQBt
+FUnSvVGn8dc7N3YoGHDuYC+vRV83dEE1XYdKPpuQEaLiQYnYx6fI5Ucb6YwXMTf
wcbFYrLbcoIIlrJfqFWRjqAbyfwLhn9Y9Iv5HgnM6DAds88CsV2vNSgPe3RFt4BD
h7Z1MUudVF5aep4yKt+ZOWXN32YnucaSDZMwUtmAWIx1qzAPOOxXIpRbEwSymMpC
MF82yBF9AauyR7wnfNuJzC3EuRCKUrc60NlX/QM7Ad89sJm5htbdeqBHYP6ZOj2F
MtmbDh140cAPJm+iXoZL
=yntJ
-----END PGP SIGNATURE-----

--=-1cDIsl19uis3CTk1vQZD--

