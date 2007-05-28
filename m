Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:43692 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752769AbXE1JMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2007 05:12:14 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/T #2] mac80211: Implementation of SIOCSIWRATE
Date: Mon, 28 May 2007 02:10:05 -0700
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	mabbas@linux.intel.com
References: <465a2d72.zG8j8542QjPLcafO%Larry.Finger@lwfinger.net>
In-Reply-To: <465a2d72.zG8j8542QjPLcafO%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6248433.WO0OpM1PFk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705280210.10893.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6248433.WO0OpM1PFk
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 27 May 2007 18:16, Larry Finger wrote:
> From: mabbas <mabbas@linux.intel.com>
>
> The WEXT ioctl SIOCSIWRATE is not implemented in mac80211. This patch
> adds the missing routine. It supports the 'auto' keyword, fixed rates,
> and the combination of 'auto' and a fixed rate to select an upper bound.
>
> Signed-off-by: mabbas <mabbas@linux.intel.com>
=46ull name please.

> Index: wireless-dev/net/mac80211/ieee80211_i.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-dev.orig/net/mac80211/ieee80211_i.h
> +++ wireless-dev/net/mac80211/ieee80211_i.h
> @@ -269,6 +269,7 @@ struct ieee80211_if_sta {
>  	unsigned long ibss_join_req;
>  	struct sk_buff *probe_resp; /* ProbeResp template for IBSS */
>  	u32 supp_rates_bits;
> +	u32 restricted_tx_rates; /* bitmap of user restricted tx rate */
>
No. max_ratectrl_rateidx and force_unicast_rateidx can do everything you ne=
ed.=20
Look more carefully at how the rate control code works with those two field=
s.=20
The only file that needs to be patched to add support for this is=20
ieee80211_ioctl.c because this feature was always supported. (with=20
non-standard prism2/hostap ioctls)

=2DMichael Wu

--nextPart6248433.WO0OpM1PFk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGWpxyT3Oqt9AH4aERAnnpAKCX0MHDZbUnhoTd/r/0mUWvlqv+iQCfa42S
aEgsaj+sxVMXOwA8yRXGrZE=
=glct
-----END PGP SIGNATURE-----

--nextPart6248433.WO0OpM1PFk--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
