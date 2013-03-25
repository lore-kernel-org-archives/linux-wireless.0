Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:56637 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309Ab3CYLie (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 07:38:34 -0400
Date: Mon, 25 Mar 2013 13:38:03 +0200
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <balbi@ti.com>, <linux-wireless@vger.kernel.org>, <ido@wizery.com>,
	<gregoire@alwaysinnovating.com>
Subject: Re: [PATCH] wlcore: move handling from hardirq to the irq thread
 function
Message-ID: <20130325113803.GF25656@arwen.pp.htv.fi> (sfid-20130325_123837_669214_694A5B20)
Reply-To: <balbi@ti.com>
References: <1364208824-18751-1-git-send-email-coelho@ti.com>
 <20130325111101.GD25656@arwen.pp.htv.fi>
 <1364211205.23210.18.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KJY2Ze80yH5MUxol"
In-Reply-To: <1364211205.23210.18.camel@cumari.coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--KJY2Ze80yH5MUxol
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 25, 2013 at 01:33:25PM +0200, Luciano Coelho wrote:
> On Mon, 2013-03-25 at 13:11 +0200, Felipe Balbi wrote:
> > On Mon, Mar 25, 2013 at 12:53:44PM +0200, Luciano Coelho wrote:
> > > Spin locks and completions are expensive in hard IRQ context and cause
> > > problems with RT kernels.  In RT kernels, both spin locks and
> > > completions can schedule(), so we can't use them in hard irq context.
> > >=20
> > > Move handling code into the irq thread function to avoid that.
> > >=20
> > > Reported-by: Gregoire Gentil <gregoire@alwaysinnovating.com>
> > > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > > ---
> > >  drivers/net/wireless/ti/wlcore/main.c |   53 +++++++++++++----------=
----------
> > >  1 file changed, 21 insertions(+), 32 deletions(-)
> > >=20
> > > diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wire=
less/ti/wlcore/main.c
> > > index 248daa9..c2730a7 100644
> > > --- a/drivers/net/wireless/ti/wlcore/main.c
> > > +++ b/drivers/net/wireless/ti/wlcore/main.c
> > > @@ -651,6 +651,25 @@ static irqreturn_t wlcore_irq(int irq, void *coo=
kie)
> > >  	unsigned long flags;
> > >  	struct wl1271 *wl =3D cookie;
> > > =20
> > > +	/* complete the ELP completion */
> > > +	spin_lock_irqsave(&wl->wl_lock, flags);
> > > +	set_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
> > > +	if (wl->elp_compl) {
> > > +		complete(wl->elp_compl);
> > > +		wl->elp_compl =3D NULL;
> > > +	}
> > > +
> > > +	if (test_bit(WL1271_FLAG_SUSPENDED, &wl->flags)) {
> > > +		/* don't enqueue a work right now. mark it as pending */
> > > +		set_bit(WL1271_FLAG_PENDING_WORK, &wl->flags);
> > > +		wl1271_debug(DEBUG_IRQ, "should not enqueue work");
> > > +		disable_irq_nosync(wl->irq);
> > > +		pm_wakeup_event(wl->dev, 0);
> > > +		spin_unlock_irqrestore(&wl->wl_lock, flags);
> > > +		return IRQ_HANDLED;
> > > +	}
> > > +	spin_unlock_irqrestore(&wl->wl_lock, flags);
> >=20
> > I still think _irqrestore() here is wrong, since it will reenable the
> > IRQ line... other than that, it looks alright.
>=20
> As we discussed earlier, it won't re-enable, since it was not enabled
> when we saved.  But, in any case, as we agreed, I'll send a separate
> patch removing it.  Don't want to mix two things in the same patch.

alright...

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--KJY2Ze80yH5MUxol
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUDcbAAoJEIaOsuA1yqREY58QAKBY3CItAQqJQgnICtxFoHnK
ejGMZTLg5UHuF5bK5rbNl6P9BYXlZJ68xD4hQXTGJ3L3YPKfrewSOR1STQ3Y2AXT
lY1WMab0ZalBEvJENt5NjIyj2QM8hT47X8MHzVZxe3qu0Z/W9ataR5Cb6H6ebS/E
xe+ZxNxpxP+EAIc1A/eWPpCqXCYq0c52J8hDpY6eRG1qqYciZMS7mKrqa9Bu0qoJ
5afpGQp6+V8tZGy0KUczibfd+5+DgSJV3Sn0Kon/f4UcA2Mgbw20fMvE4WosWzJO
zpM2D2rPBJvu4QsaY0SuoSWyI7Z8x6PUyt5pRfr6xljjuNKRDeQWNNtX0SzRAZLn
RJuiHxoQVTZSTka9uR6jx2ediJZbzmSCidjVrbtA/aBKqBddllTzfjj8ADJPK/1y
LiGAcFKYrbQ3/dlbX3fLjb66yubg2qAig1Kh8ypnEZJ5p9Nx3HZLcAOMP3fg2o98
W2iV+4DyPXijwHg4pEsTvbqmQGVRemyZPAco9wjUQw/W4OqU/F5ZayliIyHfEAdg
fq4nNdn6xfJpWNaXZct8dZNk1SazzY5wURT940DeJ39pR7qPAz4W5kwRchndL9oG
I9VqA5j4w5q5Hd1CaT//exTcGAHsQrXQygCO6uAe1HtVYP7ahllyu1SXCUHPie9K
i9NdesxFsUB7lv8Dq1ys
=rOR1
-----END PGP SIGNATURE-----

--KJY2Ze80yH5MUxol--
