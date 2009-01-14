Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56059 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbZANNhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 08:37:34 -0500
Date: Wed, 14 Jan 2009 08:33:23 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Warning in latest wireless-testing
Message-ID: <20090114133322.GA18634@tuxdriver.com> (sfid-20090114_143741_101973_B3DEA1D2)
References: <496D2AE4.7000808@lwfinger.net> <1231891570.28311.0.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1231891570.28311.0.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 14, 2009 at 01:06:10AM +0100, Johannes Berg wrote:
> On Tue, 2009-01-13 at 17:59 -0600, Larry Finger wrote:
> > In the latest pull from wireless testing, I get the following warni=
ng:
> >=20
> >   CC [M]  drivers/net/wireless/b43/main.o
> > drivers/net/wireless/b43/main.c: In function =E2=80=98b43_op_set_ke=
y=E2=80=99:
> > drivers/net/wireless/b43/main.c:3636: warning: pointer type mismatc=
h
> > in conditional expression
>=20
> That looks like a merge error:

Yes, it is.

>                 b43dbg(wl, "%s hardware based encryption for keyidx: =
%d, "
>                        "mac: %pM\n",
>                        cmd =3D=3D SET_KEY ? "Using" : "Disabling", ke=
y->keyidx,
>                        sta ? sta->addr : "<group key>");
>=20
> It should be something like
>=20
> u8 bcast[ETH_ALEN] =3D {0xff,...}
>=20
> sta ? sta->addr : bcast
>=20
> there.

Yes, it should.

John
--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
