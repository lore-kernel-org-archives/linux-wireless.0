Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47421 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbZFBUes (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 16:34:48 -0400
Subject: Re: [PATCH] mac80211: add missing RCU lock/unlock on
 ieee80211_rx_bss_info()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1243974537-12774-1-git-send-email-lrodriguez@atheros.com>
References: <1243974537-12774-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9VvtgU2ERCvDbprqCQ27"
Date: Tue, 02 Jun 2009 22:34:46 +0200
Message-Id: <1243974886.7176.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9VvtgU2ERCvDbprqCQ27
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-02 at 16:28 -0400, Luis R. Rodriguez wrote:
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/mac80211/ibss.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index 0b30277..446cada 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -365,7 +365,9 @@ static void ieee80211_rx_bss_info(struct ieee80211_su=
b_if_data *sdata,
>  		       sdata->dev->name, mgmt->bssid);
>  #endif
>  		ieee80211_sta_join_ibss(sdata, bss);
> +		rcu_read_lock();
>  		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
> +		rcu_read_unlock();
>  	}

I see no reason for this to be necessary.

johannes

--=-9VvtgU2ERCvDbprqCQ27
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJYzjAAoJEODzc/N7+QmaGeIP/AtR1fgusP2BA7oKTxsGvVLu
z7O07Qw7o3+Qmi36qwpqhqgfWBHFnyJdD29eodOH5xHwjNmGGo5s2/lLhcX7KGAU
zz95Hii5WhWnJn4ehU25RAfZteKTrvbP5ZTe1Fvv+xL3qX/rCRoU+dogEjNdPl65
hUG6KflNEn7GO7LQ6JxnFhoOS8w+64k2NtKro9InhWJ2yPyoTaZADCA2m7WtS33e
67InoZXhP1ndUBxj5LOF5cfGl+pw9ZelLhCXDBFx1fTpkmDiGHakiAmBiep3U3hR
LKDOK8QIQx4vlRz0lP5ih1AQtqFQCgMVGY0wRK+Wy4Nns7BLco8MjdrNOs0dBQkO
XVXXHBTexeatr1LzFCV+RgP2GzYQUtXC57ymhE0puoTn58iDpApY6Z1Pac9fYMtY
J4nBJS1ZyLGVE1Wf2ziOkzvaxTiQYq1jN5SdjkNzalrJYe59CCEOvswGLT/LO2Ex
ZlM+wxZVESdBi/KnwcDl4T/PahVA/46O7qsfHL6bjVOMEtaLwCLyozNobT7V6lMu
rnfD78B8OwrT0kEJUnEqRrICh92HuBDRXCa+0qsXze8lZii5v91luJ7Tdpat3lC8
R6QPATTf+FDAhZ05nXqO5Phu/blt+WdktEmDHy/Qfh1GEUt6tZZuUkYyWFBreFSR
pJRJM1kD1EqUDWEAMaD6
=TAIX
-----END PGP SIGNATURE-----

--=-9VvtgU2ERCvDbprqCQ27--

