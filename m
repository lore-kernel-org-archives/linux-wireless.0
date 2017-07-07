Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35518 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbdGGQ7T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 12:59:19 -0400
Date: Fri, 7 Jul 2017 18:59:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [Patch net] wl1251: add a missing spin_lock_init()
Message-ID: <20170707165917.GA14179@amd> (sfid-20170707_185923_120872_176C1CEC)
References: <1499378437-4971-1-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
In-Reply-To: <1499378437-4971-1-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This fixes the following kernel warning:
>=20
>   [ 5668.771453] BUG: spinlock bad magic on CPU#0, kworker/u2:3/9745
=2E..
>   [ 5668.777343] [<c06a4f94>] (ieee80211_subif_start_xmit) from
>   [<c0578848>] (dev_hard_start_xmit+0x80/0x118)
>   ...
>=20
> by adding the missing spin_lock_init().
>=20
> Reported-by: Pavel Machek <pavel@ucw.cz>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Looks very reasonable.

Acked-by: Pavel Machek <pavel@ucw.cz>

I tried testing it, and resulting kernel works, but even going back to
broken kernel I can't reproduce the problem on demand...

Best regards,
								Pavel

> +++ b/drivers/net/wireless/ti/wl1251/main.c
> @@ -1571,6 +1571,7 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
> =20
>  	wl->state =3D WL1251_STATE_OFF;
>  	mutex_init(&wl->mutex);
> +	spin_lock_init(&wl->wl_lock);
> =20
>  	wl->tx_mgmt_frm_rate =3D DEFAULT_HW_GEN_TX_RATE;
>  	wl->tx_mgmt_frm_mod =3D DEFAULT_HW_GEN_MODULATION_TYPE;

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllfveUACgkQMOfwapXb+vLW7gCfdyCsZKPRytciLgFwu8s800n6
mXIAoJsQFneQIERNXrID507oRP3hGCV4
=OJa0
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
