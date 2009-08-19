Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45644 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbZHSIN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 04:13:27 -0400
Subject: Re: [PATCH V2] cfg80211: allow cfg80211_connect_result with bssid
 == NULL
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1250669302-11362-1-git-send-email-yi.zhu@intel.com>
References: <1250669302-11362-1-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iyzpncUP8dtg+pR6lb5r"
Date: Wed, 19 Aug 2009 10:12:54 +0200
Message-Id: <1250669574.25419.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iyzpncUP8dtg+pR6lb5r
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-19 at 16:08 +0800, Zhu Yi wrote:
> In case of connection failure, the bssid info is not a must have.
>=20
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
> V2: change a __cfg80211_connect_result() caller to used NULL instead of z=
ero addr

Thanks.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

>  net/wireless/core.c |    4 +++-
>  net/wireless/sme.c  |    3 ++-
>  2 files changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index e630648..8eddf98 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -12,6 +12,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/notifier.h>
>  #include <linux/device.h>
> +#include <linux/etherdevice.h>
>  #include <linux/rtnetlink.h>
>  #include <net/genetlink.h>
>  #include <net/cfg80211.h>
> @@ -309,7 +310,8 @@ static void cfg80211_process_events(struct wireless_d=
ev *wdev)
>  		switch (ev->type) {
>  		case EVENT_CONNECT_RESULT:
>  			__cfg80211_connect_result(
> -				wdev->netdev, ev->cr.bssid,
> +				wdev->netdev, is_zero_ether_addr(ev->cr.bssid) ?
> +				NULL : ev->cr.bssid,
>  				ev->cr.req_ie, ev->cr.req_ie_len,
>  				ev->cr.resp_ie, ev->cr.resp_ie_len,
>  				ev->cr.status,
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index 8e2ef54..dbd8211 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -458,7 +458,8 @@ void cfg80211_connect_result(struct net_device *dev, =
const u8 *bssid,
>  		return;
> =20
>  	ev->type =3D EVENT_CONNECT_RESULT;
> -	memcpy(ev->cr.bssid, bssid, ETH_ALEN);
> +	if (bssid)
> +		memcpy(ev->cr.bssid, bssid, ETH_ALEN);
>  	ev->cr.req_ie =3D ((u8 *)ev) + sizeof(*ev);
>  	ev->cr.req_ie_len =3D req_ie_len;
>  	memcpy((void *)ev->cr.req_ie, req_ie, req_ie_len);


--=-iyzpncUP8dtg+pR6lb5r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKi7QDAAoJEODzc/N7+QmadlMP+QEmNdsLa9+VwFIHvONIfpaz
yy1c/PnZBDj3+V8/lD0IN9vURgp/ZNqX2Pb+1EVLl1XFyzKc/CgZ2M0rmuSX+rH/
EUgAaykH8wGfjUB6nTQkz9Wwl+2XNZvzJJ6zYONhf0+W+5F0lNAza37baqVBb9kM
YQIjtfqZcP128gQVua8pA+4ysamuieF6+Do8SX/xr5oXwWDITN6eVaI5vctiopm4
VWD0ovyfKoOOfwHXw+L5VYwgDFKoCyRUSWgJLjfpsLPfpvqHN4RLIMpJg522oAiP
k7cWK4yYG7l/P7Gx9OJHAnrb4j7vPATT8YRCnPP+tVA8B/VcOQEQP7qa1lLnAtvs
tZUT1CyU0hxhRN2ivJPOpHJWeNGGg+kAjOQcC79gI7UZzRFD7+x6hlLBSaSnrDOb
0FEcuWfpA2x0ziY/SiZQP7jh7NkiOnToqs1X2ankQp2k4D7U745PWF+3snMwMnMV
7RBmvlT3Mq1rrs93OLngdPpyWC9I2OUSwa8/ZoclXq3HFY92CPAh7vtDkANK7/NF
bcaNtvkSV1E0/W66joxFNe56QoHlQSNuKJU5lwdZwavazMF/5SBTaYZkncbwAMzN
/1gZQHvy34T+v01IKzUFtqwxtVthI9RzGZqUN5OgOpNoZ3XIGYQVrK3+35emLHW7
JKkNnPj9P6XvQb61xTB5
=r3YV
-----END PGP SIGNATURE-----

--=-iyzpncUP8dtg+pR6lb5r--

