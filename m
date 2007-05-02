Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:15553 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766739AbXEBQuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2007 12:50:44 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] mac80211: Add support for SIOCGIWRATE ioctl to provide rate information
Date: Wed, 2 May 2007 12:50:27 -0400
Cc: Jiri Benc <jbenc@suse.cz>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
References: <4638a51c.ohaY83u2vcHGHvr4%Larry.Finger@lwfinger.net>
In-Reply-To: <4638a51c.ohaY83u2vcHGHvr4%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1415705.hAoENg8LOo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705021250.32440.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1415705.hAoENg8LOo
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 02 May 2007 10:50, Larry Finger wrote:
> +static int ieee80211_ioctl_giwrate(struct net_device *dev,
> +				  struct iw_request_info *info,
> +				  struct iw_param *rate, char *extra)
> +{
> +	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +	struct sta_info * sta;
> +	struct ieee80211_sub_if_data * sdata;
> +
> +	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +	sta =3D sta_info_get(local, sdata->u.sta.bssid);
Need to check if the interface is IEEE80211_IF_TYPE_STA or=20
IEEE80211_IF_TYPE_IBSS before you can do this.

=2DMichael Wu

--nextPart1415705.hAoENg8LOo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGOMFYT3Oqt9AH4aERAk+nAKCWpSND0WFJzTfUQX7VuqHtSqlV0gCdEDrf
c6lsn9duKbUfY2TzD7lWkIM=
=dBDw
-----END PGP SIGNATURE-----

--nextPart1415705.hAoENg8LOo--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
