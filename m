Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43583 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbZJGWCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 18:02:47 -0400
Subject: Re: NULL pointer deref at wext ioctl (Re: [PATCH] compat-2.6:
 adding  ethtool.h to compat-2.6.31.h)
From: Johannes Berg <johannes@sipsolutions.net>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <3ace41890910071228i786d4097w69dc7a3dfeb64afe@mail.gmail.com>
References: <3ace41890910071216y69b8bc9la67b8f0ce5890cd8@mail.gmail.com>
	 <3ace41890910071228i786d4097w69dc7a3dfeb64afe@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-RbihFodzEDAbzSpNzdBz"
Date: Thu, 08 Oct 2009 00:01:26 +0200
Message-Id: <1254952886.3713.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RbihFodzEDAbzSpNzdBz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-10-07 at 20:28 +0100, Hin-Tak Leung wrote:
> On Wed, Oct 7, 2009 at 8:16 PM, Hin-Tak Leung <hintak.leung@gmail.com> wr=
ote:
>=20
> > It is probably just a transient problem with recent activities - I had
> > a NULL pointer deref from loading rtl8187 of compat-wireless
> > v2.6.32-rc3-39563-g98c2609 -
> >
> > BUG: unable to handle kernel NULL pointer dereference at 00000000000000=
3d
> > IP: [<ffffffff8147822c>] wext_ioctl_dispatch+0xd9/0x180
> > PGD 61c2b067 PUD 6246f067 PMD 0
> > Oops: 0000 [#1] SMP
> > ...
> > Call Trace:
> >  [<ffffffff814783f5>] wext_handle_ioctl+0x4d/0x98
> >  [<ffffffff813e53a5>] dev_ioctl+0x625/0x662
> >  [<ffffffff813cfa45>] sock_ioctl+0x225/0x248
> >  [<ffffffff811237a3>] vfs_ioctl+0x31/0xaa
> >  [<ffffffff811e1801>] ? security_d_instantiate+0x37/0x4d
> >  [<ffffffff81123c88>] do_vfs_ioctl+0x46c/0x4c3
> >  [<ffffffff81123d44>] sys_ioctl+0x65/0x9c
> >  [<ffffffff81012082>] system_call_fastpath+0x16/0x1b
> >
> > I'm sure whatever changes made this happen will go away soon, so I'll
> > just re-try in a few days... but if anybody knows what commit causes
> > this (and what fixes it!), I'd like to know.
> >
>=20
> Hiya, It looks like I last used compat-wireless successfully was on
> 25th (I am not saying it breaks after - I just haven't tried until
> yesterday, possibly), and most of the recent changes are per-driver,
> but there is a big code drop from Johannes dated 27th on 'wext:
> refactor' . Changes from that or dependent changes?

Probably -- but I don't see this problem on stock kernel and I'm not
sure what could be causing it for compat-wireless.

This will be the old copy of wext_ioctl_dispatch. It'd certainly help to
get disassembly/the source line of the oops.

johannes

--=-RbihFodzEDAbzSpNzdBz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKzQ+zAAoJEODzc/N7+QmaAGoQAIhI15Zo9LI/D732RRmSe7Ye
WofTa+snX6QhXR6ygbyLt2t+xwcmvHSYy2Ft6vT/u8hbbJ5olnGQGfcnq508M2UD
jijc1jx63txP5Vz6KnbZj+TRoXx8HFmvJRMpqZRHSdrcw48kzz/4AAaBECYs52yJ
9DkInlNs6HBMuLZz5ujWYwqn97xhZ1DLoFgroF7yZmZryVzuqzn5N1pFUU2eXZvu
wQF8XVV3cj6dCn1U2iUqn7YTioiMcHcm/KWC/VNLPKYRekiPfaCFkl+j70rIFEHI
rxU8IjMe4ql8Qn8zXgaLGkZp/E81cU6YlTfkMU5jZCa48Gn1j7GwE68toQIOruNB
0i7dxfMXIDi2NpDE8zoVQUAsK0BoAPLOSNNjbVFKYuB3KNSNG6Mzksr2rHAoo3jw
1sgwlmnpg9AcJghhGU10wF1oNzty2LqY9UVbSKgTqgwZPx2+w5Yuqwb4UGNE8b4v
OwMIICpFQbGxyQ5CXXoAVCFgD/IM3gWkw8NfhAQI8CX6kzu/vgD/qsWeijbP6Nvt
e3DsHX9fzClgVxkWugx4bGF/segypK/6sgMe2DdCqH/0UhTlbk0beqAqV9K7YtdN
/2nF+8stmWhV1bPOC9n88P4dAOcLCq6lbGQhIkM2VfoT7VX6eEFx12810YEkmZlL
zXgY0Hmi6EC8CFZiPNub
=z7Pg
-----END PGP SIGNATURE-----

--=-RbihFodzEDAbzSpNzdBz--

