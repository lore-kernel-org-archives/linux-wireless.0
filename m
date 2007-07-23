Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:63218 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755263AbXGWBvl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2007 21:51:41 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH] mac80211: missing dev_put in ieee80211_master_start_xmit
Date: Sun, 22 Jul 2007 18:50:04 -0700
Cc: jbenc@suse.cz, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <20070722235839.950277B409F@zog.reactivated.net>
In-Reply-To: <20070722235839.950277B409F@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1330352.Kimn5tDjAm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200707221850.12083.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1330352.Kimn5tDjAm
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 22 July 2007 16:58, Daniel Drake wrote:
> @@ -1662,6 +1662,7 @@ static int ieee80211_master_start_xmit(struct sk_buff
> *skb, if (skb_headroom(skb) < headroom) {
>  		if (pskb_expand_head(skb, headroom, 0, GFP_ATOMIC)) {
>  			dev_kfree_skb(skb);
> +			dev_put(odev);
>  			return 0;
>  		}
>  	}
Acked-by: Michael Wu <flamingice@sourmilk.net>

This should also go to stable.

Thanks,
-Michael Wu

--nextPart1330352.Kimn5tDjAm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGpAlUT3Oqt9AH4aERAi+cAJ4nW7ETNIZ5l9Ryxt4/0pdozFc2owCfZ9Jy
jMW9iRE+behjvG4l/k3/KuM=
=MU3M
-----END PGP SIGNATURE-----

--nextPart1330352.Kimn5tDjAm--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
