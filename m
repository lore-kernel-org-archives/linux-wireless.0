Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:56989 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764271AbZANQ6H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 11:58:07 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Eliminate compilation warning in b43_op_set_key
Date: Wed, 14 Jan 2009 17:57:05 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <496d2fc9.UiHMYJR2melvWyoO%Larry.Finger@lwfinger.net> <20090114133417.GB18634@tuxdriver.com> <496E08FD.9030803@lwfinger.net>
In-Reply-To: <496E08FD.9030803@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200901141757.05441.mb@bu3sch.de> (sfid-20090114_175812_749101_36F4E478)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 14 January 2009 16:47:09 Larry Finger wrote:
> John W. Linville wrote:
> > On Tue, Jan 13, 2009 at 06:20:25PM -0600, Larry Finger wrote:
> >> A recent pull from wireless testing generates the following warnin=
g:
> >> =20
> >>    CC [M]  drivers/net/wireless/b43/main.o
> >>  drivers/net/wireless/b43/main.c: In function =E2=80=98b43_op_set_=
key=E2=80=99:
> >>  drivers/net/wireless/b43/main.c:3636: warning: pointer type misma=
tch
> >>  in conditional expression
> >>
> >> This fix was suggested by Johannes Berg <johannes@sipsolutions.net=
>.
> >>
> >> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> >> ---
> >>
> >> Index: wireless-testing/drivers/net/wireless/b43/main.c
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> --- wireless-testing.orig/drivers/net/wireless/b43/main.c
> >> +++ wireless-testing/drivers/net/wireless/b43/main.c
> >> @@ -3630,10 +3630,12 @@ static int b43_op_set_key(struct ieee802
> >> =20
> >>  out_unlock:
> >>  	if (!err) {
> >> +		u8 bcast[ETH_ALEN];
> >> +		memset(bcast, 0xff, ETH_ALEN);
> >=20
> > Isn't there a statically-allocated array w/ the broadcast MAC in it
> > somewhere already?
> >=20
>=20
> Not that I could find.
>=20
> There are several places in mac80211 where the broadcast MAC is
> created on the fly. None of them would benefit from having a static
> array - one would just substitute memcpy for memset and possibly tras=
h
> the cache.
>=20
> There is an array broadcast[MAX_ADDR_LEN] in struct net_device, but i=
t
> would need to be initialized with 0xFF's before usage.
>=20
> I still think that b43 needs to create this array, and that the best
> place to do it is in the error path that is unlikely to be executed.

This is not an error path.
Why don't you simply define
	static const u8 bcast_addr[] =3D { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,=
 };
It has zero runtime overhead and is much easier to understand.
And the linker will merge the arrays, if there are multiple of these ar=
rays
in the compilation unit.

Note that you might need to wrap this into
#if B43_DEBUG
#endif
to avoid a compilation warning on non-debug builds in any case

--=20
Greetings, Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
