Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41025 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab0AUUo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 15:44:59 -0500
Subject: Re: [PATCH v2 1/1] mac80211: tell driver when dtim change detected
From: Johannes Berg <johannes@sipsolutions.net>
To: wey-yi.w.guy@intel.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1264105908-10757-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1264105908-10757-1-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vtRIEO/QAgQnuWLck8Qv"
Date: Thu, 21 Jan 2010 21:44:55 +0100
Message-ID: <1264106695.11396.77.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vtRIEO/QAgQnuWLck8Qv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-01-21 at 12:31 -0800, wey-yi.w.guy@intel.com wrote:

> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c

This is all in mlme.c, so ...

> +static void ieee80211_update_dtim(struct ieee80211_sub_if_data *sdata,
> +				  struct ieee80211_local *local,
> +				  struct ieee80211_bss *bss)
> +{
> +	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
> +		return;
> +
> +	if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION &&

I don't think you need this check?

> +	    sdata->vif.bss_conf.dtim_period !=3D bss->dtim_period) {
> +		sdata->vif.bss_conf.dtim_period =3D bss->dtim_period;
> +		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
> +		mutex_lock(&local->iflist_mtx);
> +		ieee80211_recalc_ps(local, -1);
> +		mutex_unlock(&local->iflist_mtx);

And afaict recalc_ps() will call hw_config() if appropriate.

johannes

--=-vtRIEO/QAgQnuWLck8Qv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLWLzDAAoJEODzc/N7+QmaqTMP/10F4F03edi3q+fruLnAlm4K
bmyqXJm3c9JpshYCkOtoD5tRa+/D9ZwNXZdLcvuxoIt4EEMa6bdeo0/ewOiQm6mm
5I943AbJi5NRsellaKiL5k8+6sT/QZjJpb6EHoc7eR2ri6BkXIRfMNwfNSdIIkv3
OPA5iuh7PwrVDur6Rn1qYZve3po4GlMXMMVqWE9N3uADd8dcqehPGqUYlbyubVvo
ZtC3bCDLtBnK/QTpvwa5/gVDBMahwDx6L6+4Wb75nNYhi2mNVk3MSPjJobAUvqUJ
iYKOV/IaRg3JUuMocUUUo2EdqDeqTdFUQGQUA4ZpRwsAhl/cnsvQLQCfWYAAk8tH
1Myfz4kbMXJ9SVN/zINjWeN70c6zKGO5GetRmz7EhcPmchrR2Xsfn+h3QVyqKrKb
nr70LJ+idvgCYPp+QMW5wEL5/zhPBLCIedfxcCTlaAIAT+0Ms+Aumv0Ls6IQDy0K
qeJ3DRd0myCpRLqxlZO+ywvg7xZSh/fAeUdKkeUhyFQCZGiMpURilPRuMypvaqvQ
5JnbSrXtu6EfizoKB18ru4dAcNZGqknUssmfB1qD/bwA/7LhXvGu1KgaWnGeOUG2
LJTYpF5xQO7hzFdJEUYQ5Em9beYneHGhjBDcSND/W4W8n2hOts5zFhLjA6pVAKkn
oUW9zHHOu89IxbD1azl1
=Es8H
-----END PGP SIGNATURE-----

--=-vtRIEO/QAgQnuWLck8Qv--

