Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbYGCRIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 13:08:35 -0400
Subject: Re: [PATCH 1/1] mac80211: move netif_carrier_on to after
	ieee80211_bss_info_change_notify
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org, Guy Cohen <guy.cohen@intel.com>
In-Reply-To: <1215104173-8918-1-git-send-email-tomas.winkler@intel.com>
References: <1215104173-8918-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-m8f43Jtgh4kZjxRo6DLj"
Date: Thu, 03 Jul 2008 19:07:50 +0200
Message-Id: <1215104870.9975.17.camel@johannes.berg> (sfid-20080703_190838_095772_EDBC615A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-m8f43Jtgh4kZjxRo6DLj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> -		netif_carrier_on(dev);
>  		ifsta->flags |=3D IEEE80211_STA_PREV_BSSID_SET;
>  		memcpy(ifsta->prev_bssid, sdata->u.sta.bssid, ETH_ALEN);
>  		memcpy(wrqu.ap_addr.sa_data, sdata->u.sta.bssid, ETH_ALEN);
>  		ieee80211_sta_send_associnfo(dev, ifsta);
>  	} else {
> +		netif_carrier_off(dev);
>  		ieee80211_sta_tear_down_BA_sessions(dev, ifsta->bssid);
>  		ifsta->flags &=3D ~IEEE80211_STA_ASSOCIATED;
> -		netif_carrier_off(dev);

Maybe it should then be symmetric so that callers of the function have
to do it in both cases? Other than that, looks good.

johannes

--=-m8f43Jtgh4kZjxRo6DLj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIbQdiAAoJEKVg1VMiehFY0eIP/R3nd4bHqTx9BbYvzy5gGVLl
NGsqonyvpfkc5AJnA1MeAfG7m2FfoyMXAHuQwcH7mCUy4s9nqU3faRJ6m3lPEYml
hxvdnSGbj71B7IL9pcmgNNUblRsA5qZ3ltV067PCJddfuzhJEATtsgxOdZEb1CZ5
WBFIbpDM9qNuAPACAwtTvE2djkJVjaBv6YMLc8XRrxjWFye1/6cXVNkqhdvjivl7
dy8RI0Gf+8QONP5VQaqkofw1hzYNpT15K17yvzOGODiiSZ26hRNfbvcqctYNCLfA
sihmwWb7l8sv5xCW09aZHIWp+438sOaogI3HV54XtCuTvGKVC0NuIFaj/wtjbaa2
sgMp4H1kjjf56xVFRFqsKbIMVzRAPeCtj085ECSWjNIedudi8AxFWAH31hHBShds
MVPsSRAx2voeCmU8m0FgQYs+E/OXd3diiF6qTtRsqBRPqYBjl77yXimxwYPIZuTN
CQS1S10vdiLA0UYiv/Ir36F+F+k920hR5kk71OM9C3OSL3MoM/S7SqeHJrtXWLZi
WAyyvmNbsCc20bbZFkjNTMk0d/ZxEOZylXqQE4yBwGZyxnJ9TRrMHAYpmTSO0baI
LujfgfTIi4jA4l9AT2C/Kbx1R83thTC9IX/fhbbmkdVOpu8joZlGi470DeeTXKR7
nGgHsv+VqZoblr2XIZ4o
=vZvo
-----END PGP SIGNATURE-----

--=-m8f43Jtgh4kZjxRo6DLj--

