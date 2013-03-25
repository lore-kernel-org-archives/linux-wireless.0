Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:46993 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757419Ab3CYLL1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 07:11:27 -0400
Date: Mon, 25 Mar 2013 13:11:01 +0200
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <linux-wireless@vger.kernel.org>, <ido@wizery.com>, <balbi@ti.com>,
	<gregoire@alwaysinnovating.com>
Subject: Re: [PATCH] wlcore: move handling from hardirq to the irq thread
 function
Message-ID: <20130325111101.GD25656@arwen.pp.htv.fi> (sfid-20130325_121132_158002_D931BFBD)
Reply-To: <balbi@ti.com>
References: <1364208824-18751-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xm/fll+QQv+hsKip"
In-Reply-To: <1364208824-18751-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Xm/fll+QQv+hsKip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 25, 2013 at 12:53:44PM +0200, Luciano Coelho wrote:
> Spin locks and completions are expensive in hard IRQ context and cause
> problems with RT kernels.  In RT kernels, both spin locks and
> completions can schedule(), so we can't use them in hard irq context.
>=20
> Move handling code into the irq thread function to avoid that.
>=20
> Reported-by: Gregoire Gentil <gregoire@alwaysinnovating.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
>  drivers/net/wireless/ti/wlcore/main.c |   53 +++++++++++++--------------=
------
>  1 file changed, 21 insertions(+), 32 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless=
/ti/wlcore/main.c
> index 248daa9..c2730a7 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -651,6 +651,25 @@ static irqreturn_t wlcore_irq(int irq, void *cookie)
>  	unsigned long flags;
>  	struct wl1271 *wl =3D cookie;
> =20
> +	/* complete the ELP completion */
> +	spin_lock_irqsave(&wl->wl_lock, flags);
> +	set_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
> +	if (wl->elp_compl) {
> +		complete(wl->elp_compl);
> +		wl->elp_compl =3D NULL;
> +	}
> +
> +	if (test_bit(WL1271_FLAG_SUSPENDED, &wl->flags)) {
> +		/* don't enqueue a work right now. mark it as pending */
> +		set_bit(WL1271_FLAG_PENDING_WORK, &wl->flags);
> +		wl1271_debug(DEBUG_IRQ, "should not enqueue work");
> +		disable_irq_nosync(wl->irq);
> +		pm_wakeup_event(wl->dev, 0);
> +		spin_unlock_irqrestore(&wl->wl_lock, flags);
> +		return IRQ_HANDLED;
> +	}
> +	spin_unlock_irqrestore(&wl->wl_lock, flags);

I still think _irqrestore() here is wrong, since it will reenable the
IRQ line... other than that, it looks alright.

--=20
balbi

--Xm/fll+QQv+hsKip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUDDFAAoJEIaOsuA1yqREVBMP/AkoX8vkdM9ZevGFNdDRvCyX
fYedLUwqSNySXYtKGhagitDnc9tAfQ/nfL5pvzTVh7+O+jxZ+z4rnPe5H9Bt7eS3
BOvBJXJz+8YsR0/J74spJUA68KiC6OeVBR1nDUEFTwwgeBb1aycP5sAKhYh7xrH9
D8EnSBH7oeJW9fHNAPksLaVyW1bFZc3ihHioGBLIY2Wtq1Anys2/h7WfdtYBODS8
L0+tQXAytjxNtUVvopGePIlYiQCckuW1raDfjETZ3MXXpC4k84adWswRrb/UB445
ln3bjWhaHVtJTOPfxAY8Dd0YqEyCsSS2XuLodneXpZQTG7ctayf+Re/Mm2xoha1E
qs3na1m5n059YB1zzyPExmrq93OvRxYRUhCcru2zSKp8AJZ/bhGliTSNmjqLYO6V
FG5vokqNGsZbmYR/e/Ljy3dGIYfEEVLbo2KUlfJ5nI9absyUIv9XtUiNT0Zh8vrU
Mn2JdcGfpv7vlEHQON+fsRJPA8RBBnQqLGYr67GbSepk1PSo1EZCSc2g4izjrTLn
yXpA+J2ChvgDa1TylcpGMiMH5lZ7pmOAKna2WbGjg8G1ful41Ay1RdQXIWLHjZXK
/f/qdQq9mBUDli9NI8j8iTUaZrQTcll+ZvlLqgfRvc02Eb3AtVkBEUDelnZ+T4GM
6fY1cWGhKSSbvD4v10Bo
=+sl4
-----END PGP SIGNATURE-----

--Xm/fll+QQv+hsKip--
