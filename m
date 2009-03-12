Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54047 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbZCLHRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 03:17:00 -0400
Subject: Re: [PATCH] cfg80211/nl80211: remove usage of CONFIG_NL80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1236812988-31827-1-git-send-email-reinette.chatre@intel.com>
References: <1236812988-31827-1-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-P/TBtC58mSqWrBy1TPx/"
Date: Thu, 12 Mar 2009 08:16:50 +0100
Message-Id: <1236842210.4175.8.camel@johannes.local> (sfid-20090312_081705_075618_F8C9FAAE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-P/TBtC58mSqWrBy1TPx/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-11 at 16:09 -0700, Reinette Chatre wrote:
> From: Reinette Chatre <reinette.chatre@intel.com>
>=20
> The scan capability added to cfg80211/nl80211 introduced a
> dependency on nl80211 by cfg80211. We can thus no longer have
> just cfg80211 without nl80211. Specifically, cfg80211_scan_done()
> calls nl80211_send_scan_aborted() or nl80211_send_scan_done().
>=20
> Now we remove the option for user to select nl80211. It will always
> be compiled if user selects cfg80211.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

I agree, it's quite pointless to make this configurable, and we keep
breaking it like in this case.

> --- a/net/wireless/nl80211.h
> +++ b/net/wireless/nl80211.h
> @@ -3,7 +3,6 @@
> =20
>  #include "core.h"
> =20
> -#ifdef CONFIG_NL80211
>  extern int nl80211_init(void);
>  extern void nl80211_exit(void);
>  extern void nl80211_notify_dev_rename(struct cfg80211_registered_device =
*rdev);
> @@ -31,6 +30,5 @@ static inline void nl80211_send_scan_aborted(
>  					struct cfg80211_registered_device *rdev,
>  					struct net_device *netdev)
>  {}
> -#endif /* CONFIG_NL80211 */

This doesn't seem quite right though, there's an #else with inlines in
the file which we need to remove entirely.

johannes

--=-P/TBtC58mSqWrBy1TPx/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJuLbfAAoJEKVg1VMiehFYoDcP/28YzrJ1uFCd7/JRLkBFZX7x
wWZvzr03nkxCYO75yzsjmdq5cSMADcIRZhe+vJmkcGsIXJIzey44zXDuDz/5jo0B
SLDZqW4b3RfWF28uevF9jh+gvtrLWSCANJ0AzAQbqEx5+4ReY0111O4yGvSSYq1m
1HfyatnkvH7pQkFgabOgArD9+UyB9Jx/xqipsReuG0mHgBnOhPwOsf7eYNOWbsDR
j1MWbrCB6q5ntU35ayNCKOqFMA5BCiwDTddkt79JHwyABWuIt8vjvdlP9UxBegJx
jpubWbWvUHP2Rvg//hFk7saOAOLf+wqjN1fpZNRcSL/u1YaY8PBX3tfHYuq7we/R
YGgUgVkPOLkXDCWdoSHqAmSyzn2sJCSwRSdue071iBaGJpFIcNTUuAwFdI2qeRzw
I+HXYzWZ4KsucozxsnsJaUEo01EqJwFACU/igY60h8oO05wdiP+fe/nkTE+5k+yM
kzfqi+Zc60+G6LvCVvH2xUKzsuRYhS+yPMPLNXnFNKMMDaYmD23gkHNN4c53EOY5
9V8Nlw2Z3Dq1+c7m8wBzhQ8WpBNhYpMK7fiP4c3GLQ9qWmeggYR+7u4A8fYzZ0iZ
352yNo4Yg2wfWj2W7aWwmqn+m7hL054rfpUg8zHEFPOaNnDFSt2dXJb89Oha4Yvd
JOZ8sjrYXPEw1SNFFY1v
=HYNq
-----END PGP SIGNATURE-----

--=-P/TBtC58mSqWrBy1TPx/--

