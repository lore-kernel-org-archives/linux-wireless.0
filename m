Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:20777 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966465AbXFHDNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 23:13:38 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH V2] mac80211: Implementation of SIOCSIWRATE
Date: Thu, 7 Jun 2007 20:12:52 -0700
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <4668a64b.VmU9f2GpA2itSuFx%Larry.Finger@lwfinger.net> <200706071819.45603.flamingice@sourmilk.net> <4668C577.4030008@lwfinger.net>
In-Reply-To: <4668C577.4030008@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3266336.lrfYDDyjEG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706072012.56652.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3266336.lrfYDDyjEG
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 07 June 2007 19:56, Larry Finger wrote:
> When I leave this part out, the rate _NEVER_ gets set, no matter what you
> say. My experiments say that it is needed.
>
That's because force_unicast_rateidx and max_ratectrl_rateidx is being set =
in=20
the wrong struct ieee80211_if_ap. (how did I miss that..) sdata->u.ap is on=
ly=20
valid when sdata->type =3D=3D IEEE80211_IF_TYPE_AP, yet it's being accessed=
=20
without any mode checks. sdata->bss should be used instead.

=2DMichael Wu

--nextPart3266336.lrfYDDyjEG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGaMk4T3Oqt9AH4aERAvv+AKDZ5f5pVSfA06tvhaHJze6aOn+EUwCeJm1M
sGSr0vqaL+SvvazpsDkDrNs=
=wSdt
-----END PGP SIGNATURE-----

--nextPart3266336.lrfYDDyjEG--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
