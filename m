Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:59651 "EHLO
        smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbdB0WwY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 17:52:24 -0500
Date: Mon, 27 Feb 2017 23:48:13 +0100
From: Alban <albeu@free.fr>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Aban Bedel <albeu@free.fr>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Richard Weinberger <richard@nod.at>,
        Marek Vasut <marek.vasut@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath9k: ahb: Add OF support
Message-ID: <20170227234813.2a077471@tock> (sfid-20170227_235313_811661_8BD25E53)
In-Reply-To: <CACna6rzZ-UiJR8oBJ9oHE+ZNT=nm6oLiKyW4bsiZ34TMRDh5Xw@mail.gmail.com>
References: <1488227292-18906-1-git-send-email-albeu@free.fr>
        <1488227292-18906-4-git-send-email-albeu@free.fr>
        <CACna6rzZ-UiJR8oBJ9oHE+ZNT=nm6oLiKyW4bsiZ34TMRDh5Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/MW3MdBHVqa4kZABoZWusz6I"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/MW3MdBHVqa4kZABoZWusz6I
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Feb 2017 22:13:21 +0100
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> Why you didn't cc linux-wireless?!?!

I first wanted to be sure that the devdata part was generally
acceptable, this patch was just included as an example of a user.
But it sound like that part will have to move to nvmem first.
I'll come back with a new patch once MTD support for nvmem is
done.

> On 27 February 2017 at 21:28, Alban <albeu@free.fr> wrote:
> > @@ -513,6 +515,43 @@ static void ath9k_eeprom_release(struct ath_softc =
*sc)
> >         release_firmware(sc->sc_ah->eeprom_blob);
> >  }
> >
> > +#ifdef CONFIG_OF
> > +static int ath9k_init_of(struct ath_softc *sc)
> > +{
> > +       struct device_node *np =3D sc->dev->of_node;
> > +       struct ath_hw *ah =3D sc->sc_ah;
> > +       const void *macaddr;
> > +       struct clk *clk;
> > +       int ret =3D 0;
> > +
> > +       if (!np) {
> > +               dev_err(sc->dev, "no platform data or OF node\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       clk =3D clk_get(sc->dev, "ref");
> > +       if (!IS_ERR(clk)) {
> > +               ah->is_clk_25mhz =3D (clk_get_rate(clk) =3D=3D 25000000=
);
> > +               clk_put(clk);
> > +       }
> > +
> > +       ah->disable_2ghz =3D of_property_read_bool(np, "qca,disable-2gh=
z");
> > +       ah->disable_5ghz =3D of_property_read_bool(np, "qca,disable-5gh=
z"); =20
>=20
> Please use ieee80211-freq-limit:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?i=
d=3Db330b25eaabda00d74e47566d9200907da381896
>=20
> Most likely with the wiphy_read_of_freq_limits helper:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?i=
d=3De691ac2f75b69bee743f0370d79454ba4429b17
>=20
> Example:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?i=
d=3D0f83ff69735651cc7a3d150466a5257ff829b62b

Thanks, I'll check this.

Alban

--Sig_/MW3MdBHVqa4kZABoZWusz6I
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJYtKytAAoJEHSUmkuduC28JA8P/i6QEpEY4xC7WIBBSwhWnFXi
4VNHVwLq0o09RKvPXPjoup6CTHBo+kbn0HZH3nrEHcfQRpvZJjrFCfPid+KtnjRv
xuXVE2pugX0QBSy7qRg4Jaqq93OV147gcTDYER1UQrmDn0QNSB3+KtcXP60nFN1U
Kwd7M82oJrFVMALzWkGAyTQXugpqfl/x98LApy5+7pBggqD9Tq5JFh89G/9TgkbC
u0riOjcj0OITbEeECrNDp2encPoI1gtB6kL/flmiiVEwF4in289GHO7bmtmRw+Wk
fHUl1P0cKCLr2jB5xrXevc6m7pfqmXIkNgVDurpsy8EdDENuTZMexokR+YV0SN0j
g0Mo/Kvex55jdK80S47OHrJ5BGctTuMON4G5JterXPwBJtcXnjlzMJoktoCxVBFV
BmsAmABjWPiDo8O6XjAO/U4Q5WgWlL8m3oluVvvbmdntCnR58CFgdmhHUkAtQadG
dLZJ1uekDTNt6mF0pC2m9izyaoYURUxyNPxSiWLW7CHhLuEDZButgQ9LXqFAuQGE
T7S+59BURnfQQ+YSl0P+S0LadlRgWbcDdrCxorH75lIFr55LcOo16RmBiZ4RG5e6
uVQlvm7ylypTnSBCH1uKoeXOPx8CLzfQaWGTXOHlj7nV0GUXYS0D5Z+FN2m20kx+
Ed1SbH/9mGzoh+RtAMWz
=X97h
-----END PGP SIGNATURE-----

--Sig_/MW3MdBHVqa4kZABoZWusz6I--
