Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:55643 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbaGTMEE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 08:04:04 -0400
Date: Sun, 20 Jul 2014 14:03:34 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH 2/2] b43: N-PHY: support setting custom TX power
Message-ID: <20140720140334.5eda3110@wiggum> (sfid-20140720_140409_117640_AD37B1BD)
In-Reply-To: <CACna6rx-LFvQZrLmuQTm7B9wME9OmFBAf_qJPRio1D_hVzA1BQ@mail.gmail.com>
References: <1405854022-11833-1-git-send-email-zajec5@gmail.com>
	<1405854022-11833-2-git-send-email-zajec5@gmail.com>
	<20140720132634.2cb9e916@wiggum>
	<CACna6rx-LFvQZrLmuQTm7B9wME9OmFBAf_qJPRio1D_hVzA1BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Wb76VfQ_m/ratIue9yGxNGT"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/Wb76VfQ_m/ratIue9yGxNGT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 20 Jul 2014 13:50:39 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> On 20 July 2014 13:26, Michael B=C3=BCsch <m@bues.ch> wrote:
> > On Sun, 20 Jul 2014 13:00:22 +0200
> > Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:
> >> @@ -6656,5 +6721,4 @@ const struct b43_phy_operations b43_phyops_n =3D=
 {
> >>       .switch_channel         =3D b43_nphy_op_switch_channel,
> >>       .get_default_chan       =3D b43_nphy_op_get_default_chan,
> >>       .recalc_txpower         =3D b43_nphy_op_recalc_txpower,
> >> -     .adjust_txpower         =3D b43_nphy_op_adjust_txpower,
> >
> > recalc_txpower once was designed to just recalculate the txpower and no=
t write it
> > to hardware. adjust_txpower was supposed to write it to hardware afterw=
ards.
> > That had to do with some locking foo and stuff I forgot (AFAIR these ca=
llbacks are called
> > in different contexts, but I may be wrong).
> > But I don't think it really matters. Just as a general hint here.
>=20
> Yeah, I noticed that and was starring at it for a long time.
>=20
> First of all I verified if @config is allowed to sleep. It is, so our
> "recalc_txpower" can sleep as well if it needs to.
>=20
> I think that using adjust_txpower on G-PHY could have something to do
> with the way TX power is controlled on these devices. They don't have

adjustment of txpower may be very expensive there. So I think this was
the reason I split it in half and let the heavier part run in workqueue con=
text or
something. Also recalc used to be called from interrupt tasklet. Not sure if
that's still the case anymore, though.

> In N-PHY world there are two registers for setting TX power: 0x1E7 and
> 0x222 (one per core) and two for reading current state: 0x1ED and
> 0x1EE. However you don't really touch them unless you're doing some
> initialization/calibration. For most of the time hardware is supposed
> to adjust TX power, you simply tell the firmware what should it be
> (this is what 0x1EA register is for).

Yeah looks fine.

--=20
Michael

--Sig_/Wb76VfQ_m/ratIue9yGxNGT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTy7AaAAoJEPUyvh2QjYsOUPQP/08opircmyBYW5SWz6YG3yTt
7/On3hL155PPa+Xss0i2L7+Jo5ykGBDbjdVhZ3sF8CEtqKxbemtcbZM5G44tQ3Ls
lKHSnzH3vgEC1gDa8uo/4jLBeJq6eaCs7i4N+df9RvnQsWOy+h3SzUZMyDt5RHKD
rl4oGQfmX1OP8/wG87JZ9IOU2BdbmGxCLocnS9DET8uxBuVhtB1z2waoYhYrMUb3
NDhOqh1BJ9+Fs5+aioDCswxd0dCJIasGHWgUlPSAkyHUqK93G0ScCUWpADRL/vkJ
YvH/CbjqU7k+vsECEFja1fMF6C79x4ymfbb7yPlip9xp3PDLATr7kwsX3z3wbPX3
lWxeA0Ilp/RsrILiu9d+2VOU14PfpmMKTW2lBsOMMBqcBMRv0rONNCF8qJ4wpiYK
fw91pT1F7inwQzS4bJbpIG8HcMHNisFLgk8F7HNeIKDZmaBPoZgBC62H0zJNF8tP
LqJQdl/EjcTnwNo7E6gsl8ac4REZDDzyXKTe8tcTEB4DV7rIheaYfRgXnFNm9MHd
68030+EPcgEan7LNXoh1s1O/LQSK8pW62QIZv0PqftgJAR3tCNRllltKVyP7Rifb
HkwQeK3xgF8H5GZuemktiWgLpbQzPcxB3B8iz4f0MhgvLXrXhNl8ntMcbGfelPmk
eBknsYjN6PLvsyI9EQlU
=1Fzp
-----END PGP SIGNATURE-----

--Sig_/Wb76VfQ_m/ratIue9yGxNGT--
