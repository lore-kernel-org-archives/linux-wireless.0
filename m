Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43495 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbZK0JkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 04:40:02 -0500
Subject: Re: [PATCH v2 2/2] iwmc3200wifi: rx aggregation support
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1259291917-1399-2-git-send-email-yi.zhu@intel.com>
References: <1259291917-1399-1-git-send-email-yi.zhu@intel.com>
	 <1259291917-1399-2-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6fPDoi7zWCQZWuebimnt"
Date: Fri, 27 Nov 2009 10:40:00 +0100
Message-ID: <1259314800.5428.13.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6fPDoi7zWCQZWuebimnt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-11-27 at 11:18 +0800, Zhu Yi wrote:

> +	__skb_queue_head_init(&list);
> +	ret =3D ieee80211_amsdu_to_8023s(skb, &list, ndev->dev_addr,
> +				       wdev->iftype);
> +	if (ret) {
> +		IWM_ERR(iwm, "decode A-MSDU frame failed\n");
> +		return -EINVAL;
> +	}

You did the right thing in mac80211, but not here -- if it returns an
error it hasn't freed 'skb', only modified it.

I think that we should have ieee80211_amsdu_to_8023s() consume it in all
cases, just not fill the list (and return an error I guess) when it
can't be decoded properly.

johannes

--=-6fPDoi7zWCQZWuebimnt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLD55pAAoJEODzc/N7+QmaWNMQAIzvyBPKH7pHh4DE41Enb7pi
HUnj7WzVPQAGwC6CPqYxCGf/dVWdTebKuLFqp7oaXVJQGRTUGkTYUS8oC7pIvsbe
udG+eRgTc2Lw9XZEcijR5ED7QMOSSAuml7nEKo/7KvdG9j/dfVxUkVxHHkA5hjBp
wFZR/b0Hj6Jejz5qyPdspxoE2q3FCUE+bqgLmCo5nHtUTSh+NIgZtydjFBZc8Lud
ovkvKIBxF8pzNovRNoZYONwrzv3eJjI4JAoIfS1XvcpdW1wdlxtp/JH4f2ffKAxY
ND3jsrfc2l/7P10Mg3S9/PbaZ3pu78elzxY80s5yQEdAUmyYMmWriG7kGH1jG5V2
ZyXsFAe6Oy8R74KdlfWRDtHkyRvbehe55GhBDtF8Ndaemkf6xSLaz35ay3Lp9O3F
ySgzEbCfJgD+SDsZfaSctuGzGuYC/vkJUCuc5mi1Jw4KkeZsrLA/CqLo6GxeVt0K
Cxa9s1du85Y+LkAbFS2l7NtaTPhtBa2oZ5i6Y7+vx4fUPkhVjfupPbpY75ikJN45
tBpb24kKmylOojRvNRunCI1XFBaFE7Z37NCpS2FB6FyBWPkZGiG3toH0gk8zcoZZ
XM5UNwUKZprQ79LsPyI1AzFRAdRdDJZSAf/b71MLGCCUrG7EXo5UiAlIBDcEiyRQ
Rl8A/ti0r53Mj9iGo8I+
=Ry8Z
-----END PGP SIGNATURE-----

--=-6fPDoi7zWCQZWuebimnt--

