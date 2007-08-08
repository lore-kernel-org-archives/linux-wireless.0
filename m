Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:51374 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759320AbXHHDUt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 23:20:49 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: mac80211 IPv6 problems
Date: Tue, 7 Aug 2007 20:19:03 -0700
Cc: David Woodhouse <dwmw2@infradead.org>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	jbenc@suse.cz, Michael Buesch <mb@bu3sch.de>,
	Bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
References: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net> <200708030102.17358.flamingice@sourmilk.net> <20070806170500.GE6442@tuxdriver.com>
In-Reply-To: <20070806170500.GE6442@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1501887.QnvLX6rT66";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708072019.03635.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1501887.QnvLX6rT66
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 06 August 2007 10:05, John W. Linville wrote:
> -		if (sdata->type != IEEE80211_IF_TYPE_STA) {
> +		if (sdata->type != IEEE80211_IF_TYPE_STA ||
> +		    (is_multicast_ether_addr(dst) &&
> +		     !compare_ether_addr(src, dev->dev_addr)))
>  			return TXRX_DROP;
> -		}
Looks fine to me, though I haven't tested.

-Michael Wu

--nextPart1501887.QnvLX6rT66
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGuTYnT3Oqt9AH4aERArHyAJ9LL0Vn+DtiBpTLukHJM+pSVNkv6gCgm4Zi
GoTFTQrq1kLdfVbvcpbL6PI=
=nzqb
-----END PGP SIGNATURE-----

--nextPart1501887.QnvLX6rT66--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
