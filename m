Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:63806 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755959AbXFHFIN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 01:08:13 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH V2] mac80211: Implementation of SIOCSIWRATE
Date: Thu, 7 Jun 2007 22:07:37 -0700
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <4668a64b.VmU9f2GpA2itSuFx%Larry.Finger@lwfinger.net> <200706071819.45603.flamingice@sourmilk.net> <4668D4C4.1050808@lwfinger.net>
In-Reply-To: <4668D4C4.1050808@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2835992.goYs0OeqRJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706072207.37421.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2835992.goYs0OeqRJ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 07 June 2007 21:02, Larry Finger wrote:
> If sta->supp_rates is not changed, how do you lock in a single rate as
> would be expected from an 'iwconfig ethX rate 11M'? Won't the following
> code in the rate_control_rate_dec routine of rc80211_simple just decrease
> the rate if it wants to?
>
>          while (i > 0) {
>                  i--;
>                  if (sta->supp_rates & BIT(i) &&
>                      mode->rates[i].flags & IEEE80211_RATE_SUPPORTED) {
>                          sta->txrate =3D i;
>                          break;
>                  }
>          }
>
No, because the code right above it checks for force_unicast_rateidx and ex=
its=20
if it's set.

=2DMichael Wu

--nextPart2835992.goYs0OeqRJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGaOQZT3Oqt9AH4aERAoNEAKCcZinlw65X5d2XHBDdTzvyGeXQqACgnZ24
K+wSIR8xtUN0KuALCi5MtI0=
=VOvV
-----END PGP SIGNATURE-----

--nextPart2835992.goYs0OeqRJ--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
