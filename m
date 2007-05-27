Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:41064 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752590AbXE0SL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 May 2007 14:11:56 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [RFC/T] mac80211: Implementation of SIOCSIWRATE
Date: Sun, 27 May 2007 11:09:51 -0700
Cc: mabbas@linux.intel.com, Jiri Benc <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
References: <46585cd1.xDmttJDPjdAQW3Wz%Larry.Finger@lwfinger.net> <200705261631.05971.flamingice@sourmilk.net> <4658E023.3020800@lwfinger.net>
In-Reply-To: <4658E023.3020800@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1888684.D0B5M9XkAU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705271109.55908.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1888684.D0B5M9XkAU
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 26 May 2007 18:34, Larry Finger wrote:
> Michael Wu wrote:
> > No. Use force_unicast_rateidx and max_ratectrl_rateidx.
>
> I did a quick check for a description of the hostap (prism2) ioctl's, but
> didn't find them, and I'm not sure how these parameters are used. Could y=
ou
> suggest a reference?
>
force_unicast_rateidx is exactly as it sounds - it forces the rate of unica=
st=20
frames to a particular rate. max_ratectrl_rateidx also does as you'd expect=
 -=20
it sets an upper bound for the rates that are used. These two are exactly=20
what you need to implement siwrate as specified in the iwconfig man page an=
d=20
it works for client, adhoc, and master mode. Just grep for these two fields=
=20
and you'll see how the code sets and uses it.

=2DMichael Wu

--nextPart1888684.D0B5M9XkAU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGWclzT3Oqt9AH4aERAmFjAJ41yekjrB1g5JN6lwbybs9DFTAlGQCfTr+N
HX06FEyS1mN6UZR/yxmBlT4=
=Heb8
-----END PGP SIGNATURE-----

--nextPart1888684.D0B5M9XkAU--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
