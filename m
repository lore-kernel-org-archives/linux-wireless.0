Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34626 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750854AbdLZSRf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Dec 2017 13:17:35 -0500
Date: Tue, 26 Dec 2017 19:17:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Colin King <colin.king@canonical.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wl1251: check return from call to
 wl1251_acx_arp_ip_filter
Message-ID: <20171226181733.GA20068@amd> (sfid-20171226_191752_816263_BDEC621F)
References: <20171226173318.5076-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
In-Reply-To: <20171226173318.5076-1-colin.king@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-12-26 17:33:18, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>=20
> Currently the less than zero error check on ret is incorrect
> as it is checking a far earlier ret assignment rather than the
> return from the call to wl1251_acx_arp_ip_filter. Fix this by
> adding in the missing assginment.
>=20
> Detected by CoverityScan, CID#1164835 ("Logically dead code")
>=20
> Fixes: 204cc5c44fb6 ("wl1251: implement hardware ARP filtering")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Hmm. So yes, it might be correct. OTOH, this change may also break
something. So... how was it tested?

								Pavel

> ---
>  drivers/net/wireless/ti/wl1251/main.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless=
/ti/wl1251/main.c
> index 6d02c660b4ab..037defd10b91 100644
> --- a/drivers/net/wireless/ti/wl1251/main.c
> +++ b/drivers/net/wireless/ti/wl1251/main.c
> @@ -1200,8 +1200,7 @@ static void wl1251_op_bss_info_changed(struct ieee8=
0211_hw *hw,
>  		WARN_ON(wl->bss_type !=3D BSS_TYPE_STA_BSS);
> =20
>  		enable =3D bss_conf->arp_addr_cnt =3D=3D 1 && bss_conf->assoc;
> -		wl1251_acx_arp_ip_filter(wl, enable, addr);
> -
> +		ret =3D wl1251_acx_arp_ip_filter(wl, enable, addr);
>  		if (ret < 0)
>  			goto out_sleep;
>  	}

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlpCkj0ACgkQMOfwapXb+vLVowCeOA0Rjtsw4LnRwNJiNkfg7HtN
DVYAoLoSk+haIRvza6qopc0KmurI9S/8
=feMQ
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
