Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.142]:56107 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754928AbdBGQxP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 11:53:15 -0500
From: Tobias Guggenmos <slartibartfas421@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Dmitry Osipenko <digetx@gmail.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rtlwifi: rtl8192c_common: "BUG: KASAN: slab-out-of-bounds"
Date: Tue, 07 Feb 2017 17:45:47 +0100
Message-ID: <46454409.lUoPi3ZtJt@slartibartfas> (sfid-20170207_175355_255005_1FE980A9)
In-Reply-To: <fbe5786e-54eb-b8a7-1540-64a913692361@lwfinger.net>
References: <beff9033-0051-fd0f-87fe-8269a0d9c8d0@gmail.com> <1486376979.14226.9.camel@sipsolutions.net> <fbe5786e-54eb-b8a7-1540-64a913692361@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3654023.x75vBVevz6"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3654023.x75vBVevz6
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Montag, 6. Februar 2017, 09:45:31 CET schrieb Larry Finger:
> On 02/06/2017 04:29 AM, Johannes Berg wrote:
> > On Sat, 2017-02-04 at 12:41 -0600, Larry Finger wrote:
> >> On 02/04/2017 10:58 AM, Dmitry Osipenko wrote:
> >>> Seems the problem is caused by rtl92c_dm_*() casting .priv to
> >>> "struct
> >>> rtl_pci_priv", while it is "struct rtl_usb_priv".
> >> 
> >> Those routines are shared by rtl8192ce and rtl8192cu, thus we need to
> >> make that
> >> difference in cast to be immaterial. I think we need to move "struct
> >> bt_coexist_info" to the beginning of both rtlpci_priv and
> >> rtl_usb_priv. Then it
> >> should not matter.
> > 
> > I think you really should consider putting a struct rtl_common into
> > that or something, and getting rid of all the casting that causes this
> > problem to start with?
> 
> The fix you suggest is prepared and will be submitted soon. As it is much
> more invasive with ~150 insertions and ~160 deletions, I decided not to
> have it be the one that is pushed to all stable kernels from 4.0 onward.
> 
> Larry

This is possibly related to the following Fedora Bug:
https://bugzilla.redhat.com/show_bug.cgi?id=1391987


--nextPart3654023.x75vBVevz6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJYmfm7AAoJEHWN/oaUcOECveQH/3YtI204WhAQc2HCAIfnsBjm
a6BGPdR8jdnv9xt2h63srh/R4N0SNLgmFYHQjqr4G9CSn1TbLe+G0v9R/F6a2UBG
/8h4z+7k81uXf7VpUUpFA4rCSdYz0LFEe9wsqY6v1FtQPyfpRPb7fZgZf4s1c5Di
DYVV4P64bRiRQT+lf9k7+S3pqjQ1Tf2VHBAVun66J0zCinG0qc9tSegwxjGINsQp
PeeyZh/og3tCiLYakUpCZjVWJL5HbtL06yFLRTm8kz0YYC4TdzrValU573pnCAKp
LoxIA/MppDemzKzQbPH4RtTxESFTmgo09LgOD6RmU+FNy4lrrbGL1LKn0wsEQI0=
=ZNPy
-----END PGP SIGNATURE-----

--nextPart3654023.x75vBVevz6--
