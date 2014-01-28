Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:20796 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbaA1QCz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 11:02:55 -0500
Message-ID: <52E7D461.1020708@meshcoding.com> (sfid-20140128_170258_411296_B127B7F4)
Date: Tue, 28 Jan 2014 17:01:37 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Antonio Quartulli <antonio@meshcoding.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: removed useless ibss_joined notification on ibss_leave
References: <1390924815-3714-1-git-send-email-antonio@meshcoding.com>
In-Reply-To: <1390924815-3714-1-git-send-email-antonio@meshcoding.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XuCuwdD7QARn82qlJgCER6dptWoRxODN2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XuCuwdD7QARn82qlJgCER6dptWoRxODN2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 28/01/14 17:00, Antonio Quartulli wrote:
> When leaving an IBSS there is no need to send cfg80211 a
> fake notification about "having joined a cell with zero
> BSSID".
> This operation has the only effect to create a BSS object
> that is not going to be used.
>=20
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
> ---
>  drivers/net/wireless/ath/ath6kl/cfg80211.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/w=
ireless/ath/ath6kl/cfg80211.c
> index eba32f5..8ce1ce5 100644
> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -790,7 +790,6 @@ void ath6kl_cfg80211_connect_event(struct ath6kl_vi=
f *vif, u16 channel,
>  	if (nw_type & ADHOC_NETWORK) {
>  		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "ad-hoc %s selected\n",
>  			   nw_type & ADHOC_CREATOR ? "creator" : "joiner");


Of course I messed it up :)
This is not the right place for this change!!!
Will send v2.


Cheers,

--=20
Antonio Quartulli


--XuCuwdD7QARn82qlJgCER6dptWoRxODN2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS59RmAAoJEEKTMo6mOh1VBI0P/2gmQun+tJveKNqcjFW667r4
//BD9pGF/QzWnocIw32hO5vFmDAhVTNiXCzJcT/VwoiKxVEUY7uSdCO0UaeZcuND
VqA7gPpl+aW0d3kSGp5ops9EhF7nZ/PzSBDfC02nvbE//j9Vouh1Di1kq0n9Bp11
i5XdR3zItqAqFEbdtvYPjGtcXhrQSdgPfAi4VKPnRLT44IWaJCnHji+LlEQqeibL
ggyc2UPtOFdKbw9VBUyISsj+WmnYDomzfrqBtD0koB5vAUIVb6m0MSFVRmxv23f3
EfeTnqT0KdyAs4xaVSgG8H7yiJbqs4c863nPJXxHczGjOkdAUO6CmeYxIgzzo5ZQ
pWKgEYl3VOeELK0QwE+454ITGVUN4DgOeDCHxQs0IxOEfo5svBfEJTLDdaT0JZbq
0oW8hYAuT/aNJoGBIyNSCcAhlPB7CMZ3VH54q20BadcwHRXT+UeSDqRtcWCgwD5P
XFt+8eQpEmS8A3ZV7m1mlSsn7NmJFKPYk9rzQGWb03n9me6+/LbIlwaymF+KgBD7
E46eO8Deko1KB35T7d2mJxp1F5SEXPab0aTZh3rAYb6iiS5HIms8dJr+uhH+S0uC
x0BRemnJ/DKJ43Mme8GkrzMjXKtF5wc8+p+RGneCP3KrSikdg8+yWoaTVfkSY4GZ
Y6M/yzxxej4xSXbOovLb
=IWV4
-----END PGP SIGNATURE-----

--XuCuwdD7QARn82qlJgCER6dptWoRxODN2--
