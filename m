Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from liberdade2.minaslivre.org ([74.50.53.203]:50376 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab0KETp5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 15:45:57 -0400
Date: Fri, 5 Nov 2010 17:45:50 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	seno <senada@t-online.de>
Subject: Re: [PATCH 9/9] rtl8187: restore anaparam registers after reset
 with 8187B
Message-ID: <20101105194549.GD3836@barata.holoscopio.com>
References: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
 <1288659579-4986-10-git-send-email-herton@mandriva.com.br>
 <20101104153057.GA4610@barata.holoscopio.com>
 <20101104135037.4a465ea8@gotham.conectiva>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C1iGAkRnbeBonpVg"
In-Reply-To: <20101104135037.4a465ea8@gotham.conectiva>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--C1iGAkRnbeBonpVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 04, 2010 at 01:50:37PM -0200, Herton Ronaldo Krzesinski wrote:
> On Thu, 4 Nov 2010 13:30:57 -0200
> Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:
>=20
> > On Mon, Nov 01, 2010 at 10:59:39PM -0200, Herton Ronaldo Krzesinski wro=
te:
> > > Current 8187B initialization misses anaparam registers restore after
> > > 8187 reset. This causes ANAPARAM register to stay zeroed out (ANAPARA=
M2
> > > kept its value on my tests). To avoid this, call rtl8187_set_anaparam
> > > right after chip reset (to be on the safe side, as it makes sure we
> > > restore all ANAPARAM registers).
> > >=20
> >=20
> > Hello, Herton.
> >=20
> > Thank you very much for these patches. I am in the process of testing
> > them right now. The first thing I've noticed is a drop in the signal
> > level by 10dBm when using this last patch. Is this something we should
> > be concerned with?
>=20
> I think not, may be the signal is a bit weaker with the anaparam now being
> what Realtek uses/recomends (unfortunately it's a magic number and not
> disclosed what each bit/parameter is doing..., probably the buggy previous
> behaviour of the setting being zero after reset was making the signal too
> high when not needed), but as with it we can get higher rate and bandwidth
> on same distance, it shouldn't be a concern (my iperf test results showed
> improvements too with the last two changes).
>=20

Hello, again.

I've done some more tests around here and I also get throughput
improvements with the last patch when my AP is in my desk. It does
happen that I have what seems to be a badly assembled card in my
notebook. I can try to get one I can plug outside in the external USB
port.

However, the tests I've done with my card with the AP a little further
away (about 2.7 meters), I cannot ping the machine for more than the
first seconds. Without the last patch, I get 50% loss, and, sometimes,
iperf works and gives me more than 2Kbits/s (that's right, that little).

I have also tried with the AP whithin about 1 meter of distance.
Without the patch, I get no loss and iperf gives me something between
1Mbit/s and 2Mbit/s. With the patch, sometimes I get 4Mbit/s, sometimes
less than 10Kbit/s. In any occasion, with lots of losses using ping.

For reference, my "AP" is, in fact, a netbook using hostapd and a rt73
USB dongle. I am going to send the patches for experimentation in an
environment with many devices far away from the AP. As soon as I get the
results (it may take a while), I'll send them to the list.

Anyway, although I am not very confident about this last patch, perhaps
it should go forward and we get can revert it later if people does
complain about it. Or we should add a comment stating in the code that
it does improve throughput, but may cause packet losses when the devices
are distant. Any thoughts on how to turn this on or off depending on the
case too?

Regards,
Cascardo.

> >=20
> > I will do some tests with the distance to the Access Point and send my
> > results later.
> >=20
> > Regards,
> > Cascardo.
> >=20
> > > Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> > > Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
> > > Cc: seno <senada@t-online.de>
> > > ---
> > >  drivers/net/wireless/rtl818x/rtl8187_dev.c |    2 ++
> > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > >=20
> > > diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net=
/wireless/rtl818x/rtl8187_dev.c
> > > index 4448647..eeee244 100644
> > > --- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > > +++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > > @@ -771,6 +771,8 @@ static int rtl8187b_init_hw(struct ieee80211_hw *=
dev)
> > >  	if (res)
> > >  		return res;
> > > =20
> > > +	rtl8187_set_anaparam(priv, true);
> > > +
> > >  	/* BRSR (Basic Rate Set Register) on 8187B looks to be the same as
> > >  	 * RESP_RATE on 8187L in Realtek sources: each bit should be each
> > >  	 * one of the 12 rates, all are enabled */
> > > --=20
> > > 1.7.3.2
> > >=20
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> []'s
> Herton

--C1iGAkRnbeBonpVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJM1F7sAAoJEEWxSg7udFZIIUsP/3mMEAnyEGLP9nAq816MXbj+
jlt/ttgdFIf+lrcBHpIU64oW2fFRkmoR8mWEvuUn0W7IiPyarSxPzvBk+RX5S8c2
b5M6v7DetFms9uAfJyAyR1COGzYt1JkPV698ov1j6+GhPJ81Fyh4ngnCktCOwShV
NmMYGmwXZvGwDxly8H4eI4TUS1lZTmTqTrOhrPWBxmfyoJTyIn8sFK2LvLXCR173
dZBfMK7AxEbn+NcwagQ5cbFanne3soK0kK6vDvSTqyPqnassmU8EhR7klt+DaI92
j4LIs/7r/g569HaOfcElPwTibdvJNvHNrOhxyBf+oh9ic+pyqTCLdg4LyJOAOJsJ
lmbr+cq0h+i/4wT2tHBWc1vW2gS1XlKNBjLcIf76fXVG3gpanF4SZ4EyCpXyQAQq
2FJmPpdbLqXUg9E0I0NsbQ4lAWJsh0j3zjV7MwveJ/w+hyAwYwsCoZADtPP78uUU
Bg+2lFtWnpFI9X77CUEZyPvO7IK9ChYQK1s1Af/3OVEncXGtdok8PQZNM6Y0X4Yf
qtSc9Ck+Q8pRNlCBcVV3IIWYvPzSkg6NwfXDTTA6yTWegJ3DgdgEiM+6ifOfI54u
AT0OLt4M8/8ZBzbskHT5xb/1GYrWllt1ntQE6pXtS05S9l57ILN2Irz9qpUvzAA/
tB84KVKY4dpJHljrwuqQ
=+80E
-----END PGP SIGNATURE-----

--C1iGAkRnbeBonpVg--
