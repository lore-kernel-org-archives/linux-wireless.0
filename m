Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50371 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbZHMSUA (ORCPT
	<RFC822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 14:20:00 -0400
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] mmotm0812 - something in linux-next killed iwl-3945.c
In-Reply-To: Your message of "Thu, 13 Aug 2009 13:28:19 EDT."
             <20090813172819.GD2647@tuxdriver.com>
From: Valdis.Kletnieks@vt.edu
References: <19728.1250182794@turing-police.cc.vt.edu>
            <20090813172819.GD2647@tuxdriver.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1250187563_3970P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Date: Thu, 13 Aug 2009 14:19:23 -0400
Message-ID: <28042.1250187563@turing-police.cc.vt.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--==_Exmh_1250187563_3970P
Content-Type: text/plain; charset=us-ascii

On Thu, 13 Aug 2009 13:28:19 EDT, "John W. Linville" said:
> On Thu, Aug 13, 2009 at 12:59:54PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > Build bombs out:
> > 
> >   CC      drivers/net/wireless/iwlwifi/iwl-3945.o
> > drivers/net/wireless/iwlwifi/iwl-3945.c: In function 'iwl3945_pass_packet_to_mac80211':
> > drivers/net/wireless/iwlwifi/iwl-3945.c:580: error: 'hdr' undeclared (first use in this function)
> > drivers/net/wireless/iwlwifi/iwl-3945.c:580: error: (Each undeclared identifier is reported only once
> > drivers/net/wireless/iwlwifi/iwl-3945.c:580: error: for each function it appears in.)
> > make[1]: *** [drivers/net/wireless/iwlwifi/iwl-3945.o] Error 1

> > Sorry, don't have a linux-next git tree, so no 'git blame' for what did it.
> > Hopefully somebody recognizes their handiwork... ;)
> 
> I think this is the LEDS-related build failure, which already has a patch.

Found Kalle Valo's patch removing the #ifdef's in the linux-wireless
archives, build is now proceeding thanks...

Now to figure out how I managed to trip over it, CONFIG_IWLWIFI_LEDS looks
like a config option I would have selected...

--==_Exmh_1250187563_3970P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKhFkrcC3lWbTT17ARAi0fAJ9OQyXD3P8XXIMNjVTHH5o9gBNhmgCdGi0l
yBJWPe7t+Nsrkyrzrj7nzvQ=
=695o
-----END PGP SIGNATURE-----

--==_Exmh_1250187563_3970P--
