Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59520 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbZHDDn0 (ORCPT
	<RFC822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 23:43:26 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 31-rc3-mmotm0716 - wonky wireless statistics..
In-Reply-To: Your message of "Wed, 29 Jul 2009 09:19:12 +0200."
             <1248851953.13742.12.camel@johannes.local>
From: Valdis.Kletnieks@vt.edu
References: <5934.1248814870@turing-police.cc.vt.edu> <1248831078.3747.1117.camel@debian>
            <1248851953.13742.12.camel@johannes.local>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1249357220_4761P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Date: Mon, 03 Aug 2009 23:40:20 -0400
Message-ID: <30110.1249357220@turing-police.cc.vt.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--==_Exmh_1249357220_4761P
Content-Type: text/plain; charset=us-ascii

On Wed, 29 Jul 2009 09:19:12 +0200, Johannes Berg said:

> > > # cat /proc/net/wireless
> > > Inter-| sta-|   Quality        |   Discarded packets               | Missed | WE
> > >  face | tus | link level noise |  nwid  crypt   frag  retry   misc | beacon | 22
> > >  wlan0: 0000   63.  -47.  -256        0      0      0      0      0
> > >  wlan1: 0000    0     0     0        0      0      0      0      0
> > >  wlan2: 0000    0     0     0        0      0      0      0      0

> and since we have dBm for the signal strength (and dBm is "all or
> nothing") you get -256 since we don't fill noise right now.
> 
> However, it goes on like this:
> 	stats->qual.updated & IW_QUAL_NOISE_UPDATED ? '.' : ' '
> 
> so you're right -- the tool shouldn't be using the value unless followed
> by a dot (".").

OK, went back and checked a -mmotm0702 kernel, and there I see:

 cat /proc/net/wireless
Inter-| sta-|   Quality        |   Discarded packets               | Missed | WE
 face | tus | link level noise |  nwid  crypt   frag  retry   misc | beacon | 22
 wlan0: 0000   64.  -46.  -127.       0      0      0      0      0        0
 wlan1: 0000    0     0     0        0      0      0      0      0        0
 wlan2: 0000    0     0     0        0      0      0      0      0        0

so yes, it appears that the userspace program (gkrellm-wifi) is failing to
notice the lack of a trailing '.'.  Looks like I need to write a patch and push
it upstream, make it do something sensible with the S/N ratio when N is
missing. Too bad probably no easy way to compute an estimate based on the level
and link-quality values....


--==_Exmh_1249357220_4761P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKd62kcC3lWbTT17ARAhH+AJoC0ZgDA5A9A0voYTVbI+ucFBgqEACgtG5W
ETdKZa/+dsJPA5ie/xdDyeA=
=c1nt
-----END PGP SIGNATURE-----

--==_Exmh_1249357220_4761P--
