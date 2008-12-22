Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbYLVQ52 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 11:57:28 -0500
Subject: Re: [RFC] mac80211: A couple of fixes to dynamic power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081223025735.GB11534@myhost.users.atheros.com> (sfid-20081222_142412_070619_0D315137)
References: <20081223025735.GB11534@myhost.users.atheros.com>
	 (sfid-20081222_142412_070619_0D315137)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aKdjC89Cc+83l/wN0QHr"
Date: Mon, 22 Dec 2008 17:57:26 +0100
Message-Id: <1229965047.10883.6.camel@johannes.berg> (sfid-20081222_175731_938149_DACDC29B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aKdjC89Cc+83l/wN0QHr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-22 at 18:57 -0800, Vivek Natarajan wrote:
> a) hw_config() should not be called from siwpower() for the drivers which=
 do not support
>    dynamic powersave.
> b) IEEE80211_HW_NO_STACK_DYNAMIC_PS needs to be verified in set_associate=
d() also before
>    enabling the power save timers.
>=20
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>

Seems good to me.

> ---
>  net/mac80211/mlme.c |    3 ++-
>  net/mac80211/wext.c |    9 +++++----
>  2 files changed, 7 insertions(+), 5 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index c75d0ea..b23e62b 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -746,7 +746,8 @@ static void ieee80211_set_associated(struct ieee80211=
_sub_if_data *sdata,
>  	bss_info_changed |=3D BSS_CHANGED_BASIC_RATES;
>  	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
> =20
> -	if (local->powersave) {
> +	if (local->powersave &&
> +			!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS)) {
>  		if (local->dynamic_ps_timeout > 0)
>  			mod_timer(&local->dynamic_ps_timer, jiffies +
>  				  msecs_to_jiffies(local->dynamic_ps_timeout));
> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index 7162d58..673c5d7 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -865,9 +865,9 @@ set:
>  	local->powersave =3D ps;
>  	local->dynamic_ps_timeout =3D timeout;
> =20
> -	if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
> -		if (!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS) &&
> -		    local->dynamic_ps_timeout > 0)
> +	if (!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS) &&
> +			(sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)) {
> +		if (local->dynamic_ps_timeout > 0)
>  			mod_timer(&local->dynamic_ps_timer, jiffies +
>  				  msecs_to_jiffies(local->dynamic_ps_timeout));
>  		else {
> @@ -875,8 +875,9 @@ set:
>  				conf->flags |=3D IEEE80211_CONF_PS;
>  			else
>  				conf->flags &=3D ~IEEE80211_CONF_PS;
> +			ret =3D ieee80211_hw_config(local,
> +					IEEE80211_CONF_CHANGE_PS);
>  		}
> -		ret =3D ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
>  	}
> =20
>  	return ret;

--=-aKdjC89Cc+83l/wN0QHr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJT8byAAoJEKVg1VMiehFYnxgP/jarZmPXSNJQZB5UeTkKeiC4
I+TA5eWbLU+61svChV4IEeBdYYcdYtlvUVzsO0aOm4zjuWvYumEXD1kYuWciUDCW
cmWBh2K/3dY9m6Sq1vNcXE6oXWfo1z0cMts9xqKyDc8w+I7cxdEwem8i+DlieOIZ
hnPK3Sks0zFP2W0eOCjeoMKgtGgMO5ZunC92+HYLnzpGrXzGInduVXHlI/zLPOAk
vLr2P+2ay4bRyjMSQV3kDrYMt2GMj+npy3+sHYcTSP/r09mAF5fVvhjddwEju1wn
vq+9UJ1v3J942etBU39ZC0oqZDo6zYoSp9UG1/K5H8f2vcGiKF1igHdG3I3ibmbp
MdkhHwZkzfPlRFInKebQsp37xE0FPQPxTl0pc70XsnnzbkSvTdQ/49qjnfY6vma3
NdlkAA4O20xgAAZ1R+geFeECcUD05bqrvXT4PoQ+B3F8ruxgvSiY/ZPkRkAEqWWG
GV5OtG68EQRWVNUpXK1krwHWFtcXPPmbG2t+k1eux/9+xSttEFax6ZMvXj7BKeXu
qI4XjlNvkRjIbrWNhRsaPuB3z9KRltakzWybsHkWBPH31dMSEF8yPC/FfY0+wxw3
yT1XZ8q+CS3MsypH8hqVtxYtNGn70wzhWIpzkby3QpqEReW5CCL1o1iAO42FmW/z
fzz1VZ/TPXWOa1ORdEhv
=II+b
-----END PGP SIGNATURE-----

--=-aKdjC89Cc+83l/wN0QHr--

