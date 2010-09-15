Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lennier.cc.vt.edu ([198.82.162.213]:41363 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab0IOPmg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 11:42:36 -0400
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, Jeremy Kerr <jk@ozlabs.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Julia Lawall <julia@diku.dk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-omap@vger.kernel.org,
	linuxppc-dev@ozlabs.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 00/15] change default_llseek action
In-Reply-To: Your message of "Tue, 14 Sep 2010 22:22:28 +0200."
             <1284495763-7506-1-git-send-email-arnd@arndb.de>
From: Valdis.Kletnieks@vt.edu
References: <1284495763-7506-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1284565136_4463P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Date: Wed, 15 Sep 2010 11:38:56 -0400
Message-ID: <9828.1284565136@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--==_Exmh_1284565136_4463P
Content-Type: text/plain; charset=us-ascii

On Tue, 14 Sep 2010 22:22:28 +0200, Arnd Bergmann said:

> This changes *all* instances of struct file_operations in
> the kernel to have a .llseek operation and then changes
> the default to no_llseek, which returns -ESPIPE, which
> is what we had decided some time ago in a discussion
> with Christoph Hellwig.

I don't suppose there's any clean way to throw a build error or a
printk_on_once() or something if we encounter an unconverted 'struct
file_operations', is there? I have this creeping fear that this patch will go
upstream during the merge window - as will 12 new staging/ drivers from authors
who didn't get the memo yet.

Other than the "missed converting a new usage" issue, it looks OK to me.



--==_Exmh_1284565136_4463P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMkOiQcC3lWbTT17ARAqwmAKDtt7WLCtHcS+CHyD0HhQqZdVYOywCgg7fS
U3JZpm40giJnTm/uyS6JlMA=
=9mVq
-----END PGP SIGNATURE-----

--==_Exmh_1284565136_4463P--

