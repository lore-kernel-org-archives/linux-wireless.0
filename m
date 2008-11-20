Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbYKTGuZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 01:50:25 -0500
Subject: Re: [PATCH] mac80211 : Fix setting ad-hoc mode and non-ibss channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1227141512-5636-1-git-send-email-abhijeet.kolekar@intel.com> (sfid-20081120_013837_745962_A235554D)
References: <> <1227141512-5636-1-git-send-email-abhijeet.kolekar@intel.com>
	 (sfid-20081120_013837_745962_A235554D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RElN8UKC7NQxIb0NtzF/"
Date: Thu, 20 Nov 2008 07:49:48 +0100
Message-Id: <1227163788.17336.14.camel@johannes.berg> (sfid-20081120_075029_344244_0911956A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RElN8UKC7NQxIb0NtzF/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 16:38 -0800, Abhijeet Kolekar wrote:
> Patch fixes the kernel trace when user tries to set
> ad-hoc mode on non IBSS channel.
> e.g iwconfig wlan0 chan 36 mode ad-hoc
>=20
> Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> ---
>  net/mac80211/wext.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index 63f36e9..5a9bc8c 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -271,6 +271,7 @@ static int ieee80211_ioctl_siwmode(struct net_device =
*dev,
>  				   __u32 *mode, char *extra)
>  {
>  	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct ieee80211_local *local =3D sdata->local;
>  	int type;
> =20
>  	if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN)
> @@ -281,6 +282,15 @@ static int ieee80211_ioctl_siwmode(struct net_device=
 *dev,
>  		type =3D NL80211_IFTYPE_STATION;
>  		break;
>  	case IW_MODE_ADHOC:
> +		/* Following check added to avoid misconfiguration if
> +		 * you set mode and frequency at the same time.
> +		 */

The way that comment is written it belongs in the changelog.

> +		if (local->oper_channel && local->oper_channel->flags &
> +					IEEE80211_CHAN_NO_IBSS) {
> +			printk(KERN_DEBUG "Not a valid IBSS channel\n");

And that's some extremely odd indentation/wrapping there. Also, imho the
printk is unnecessary.

johannes

--=-RElN8UKC7NQxIb0NtzF/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJQiJAAoJEKVg1VMiehFYD5AQAI+XoaMsRwIFqHwK5BUjiNh6
qgW/gKPYVatOsiNH41FD0b+jItiI3jlwHRQErmmdO8jT2b18eFuvSQNcPu4CB/bA
ca054yGYA4560bRuoEGRc8ZfaEDSNjTeMwoGcaeB77bKp/9EYI85kk3yEzaURUJY
58jIiSLgFJKoWXZVDIrBPcj1yIcMLNkipZteoMKn5U9yVgv9B371BI2Lu1q7cWUe
SBCMZyTG7a7w9Fyw4aJUkEj0QtJquiXHFeWZyURV5LmJCR3ugxwjVZOk1ONoPtyg
zenM1tx/yWvUbFiUsq2U5T4KSWXm7sNjZeiLF+1INXm5NZ01Ju7YZR4TwW3qPwIz
5r4tfKIOJ8Tk/gViegNbbX+Ex0qiAKx5ovqYqw7Drh180R/QTHiIKKe1wYYU7hGG
pc/kNbsV0izESPlQX8zVrlvWmPRlleK97q8B2MfrqoerK1PwE3UIk52mCLfeKp0H
1i7Dfe1Yhr6XL+jdZ+ujraLiH/fdOKTpa3M6WW07LAuYxw2cXg4nCfGakxCv2qgO
SIv80C838HamMltwTUtS7ZjI0tOtlvaSsbQtVbjxqMIl34ULatSHClbMGFLm7Wx7
kJUtQwx0oUIfoIY5blfxsgdOffXJAEIuy1I/XEPdv0oLQDiZo3F2lYNOsikwclwE
YhgsKnKt918ZeZaM4sYf
=iPvb
-----END PGP SIGNATURE-----

--=-RElN8UKC7NQxIb0NtzF/--

