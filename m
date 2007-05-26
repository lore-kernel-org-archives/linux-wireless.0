Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:56634 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751209AbXEZXdC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 19:33:02 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <Larry.Finger@lwfinger.net>, mabbas@linux.intel.com
Subject: Re: [RFC/T] mac80211: Implementation of SIOCSIWRATE
Date: Sat, 26 May 2007 16:31:00 -0700
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <46585cd1.xDmttJDPjdAQW3Wz%Larry.Finger@lwfinger.net>
In-Reply-To: <46585cd1.xDmttJDPjdAQW3Wz%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2741602.C36GTJp2VS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705261631.05971.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2741602.C36GTJp2VS
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 26 May 2007 09:14, Larry Finger wrote:
> From: mabbas@linux.intel.com
>
> The WEXT ioctl SIOCSIWRATE is not implemented in mac80211. This patch
> adds the missing routine. It supports the 'auto' keyword, fixed rates,
> and the combination of 'auto' and a fixed rate to select an upper bound.
>
> Signed-off-by: mabbas@linux.intel.com
Please sign off with both your name and email address.

> Index: wireless-dev/net/mac80211/sta_info.h
> ===================================================================
> --- wireless-dev.orig/net/mac80211/sta_info.h
> +++ wireless-dev/net/mac80211/sta_info.h
> @@ -58,6 +58,9 @@ struct sta_info {
>  	unsigned int wep_weak_iv_count; /* number of RX frames with weak IV */
>
>  	unsigned long last_rx;
> +	u32 restricted_tx_rates; /* bitmap of user restricted tx rates in
> +				  * u.sta.restricted_tx_rates, if 0 use all
> +				  * available rates */
No. Use force_unicast_rateidx and max_ratectrl_rateidx.

-Michael Wu

--nextPart2741602.C36GTJp2VS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGWMM5T3Oqt9AH4aERApvIAKDN8nI9Zb0FFskq595Ct7U1w82/OgCeJJzA
FS/l+trzCXvxuOird0D4IjY=
=vShG
-----END PGP SIGNATURE-----

--nextPart2741602.C36GTJp2VS--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
