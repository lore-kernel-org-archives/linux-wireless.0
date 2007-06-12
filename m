Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:48952 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751082AbXFLUva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 16:51:30 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH V2] mac80211: Implementation of SIOCSIWRATE
Date: Tue, 12 Jun 2007 13:50:22 -0700
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <4668a64b.VmU9f2GpA2itSuFx%Larry.Finger@lwfinger.net> <200706071819.45603.flamingice@sourmilk.net> <466F037C.9080403@lwfinger.net>
In-Reply-To: <466F037C.9080403@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1307476.pkSekkCMCL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706121350.26402.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1307476.pkSekkCMCL
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 12 June 2007 13:35, Larry Finger wrote:
> Michael Wu wrote:
> > One last thing - max_ratectrl_rateidx should be set to -1 to indicate no
> > maximum. Not doing this will cause problems when switching from one hw
> > mode to another with a different number of rates.
>
> I don't understand this last part. If we use the upper-limit form of the
> rate command, isn't that indicated to the rate-setting routine by having
> max_ratectrl_index set to the upper limit, and force_unicast_rateidx set =
to
> -1?
Yes. However, when you're not setting the upper limit, max_ratectrl_index=20
needs to be set to -1. The current code sets max_ratectrl_index to the=20
highest rate index it can find to configure full auto rate selection or fix=
ed=20
rate when it should set -1 instead.

=2DMichael Wu

--nextPart1307476.pkSekkCMCL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGbwcST3Oqt9AH4aERAswLAKDFVTcNn5XyBbUnkZMfiyhBKAoBYgCeP3DA
Sbc/K5MGjr5bDPpjt9rxmC8=
=2ukC
-----END PGP SIGNATURE-----

--nextPart1307476.pkSekkCMCL--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
