Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:44092 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753248AbdJUJnh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Oct 2017 05:43:37 -0400
Date: Sat, 21 Oct 2017 11:09:43 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: gregkh@linuxfoundation.org, sudipm.mukherjee@gmail.com,
        akpm@linux-foundation.org, johannes@sipsolutions.net,
        dahinds@users.sourceforge.net, linux-pcmcia@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [BUG] ssb: Possible sleep-in-atomic bugs in ssb_pcmcia_read8
Message-ID: <20171021110943.0e4f3a24@wiggum> (sfid-20171021_114352_224839_6CB62BBC)
In-Reply-To: <b3252056-573d-2c69-81d6-dde291246748@163.com>
References: <b3252056-573d-2c69-81d6-dde291246748@163.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/y0rSksZreYQ/PWD.FzbsCIU"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/y0rSksZreYQ/PWD.FzbsCIU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Oct 2017 09:29:17 +0800
Jia-Ju Bai <baijiaju1990@163.com> wrote:

> According to pcmcia.c, the driver may sleep under a spinlock.
> The function call paths are:
> ssb_pcmcia_read8 (acquire the spinlock)
>    select_core_and_segment
>      ssb_pcmcia_switch_segment
>        ssb_pcmcia_cfg_write
>          pcmcia_write_config_byte
>            pcmcia_access_config (drivers/pcmcia/pcmcia_resource.c)
>              mutex_lock --> may sleep
>=20
> ssb_pcmcia_read8 (acquire the spinlock)
>    select_core_and_segment
>      ssb_pcmcia_switch_segment
>        sssb_pcmcia_cfg_read
>          pcmcia_read_config_byte
>            pcmcia_access_config (drivers/pcmcia/pcmcia_resource.c)
>              mutex_lock --> may sleep
>=20
> A possible fix is to use spinlock instead of mutex lock in=20
> pcmcia_access_config in drivers/pcmcia/pcmcia_resource.c.
>=20
> These bugs are found by my static analysis tool and my code review.



Thanks for scanning and your resulting bug notification.
I currently don't have the hardware at hand to develop and test a
proper fix for this.
That said, I'm not so sure anymore why bar_lock is a spinlock instead
of a mutex. It might be possible to convert this to mutex.

I will try to look into this.

--=20
Michael

--Sig_/y0rSksZreYQ/PWD.FzbsCIU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlnrDtcACgkQ9TK+HZCN
iw5CDBAAuQuyWnzGw+YuKW/XxqNI2PLODyIdO/TEnSSqb6976b+RlzpEXfAb8VWq
wa4shyBMHv2on575Eu2m11E3mIul+ULtGgQw7nAwloESVd4Szhrn/k/em96c/cOe
7tVq123saAhVgJ79SolZzt6TY01M0ljKzy+vPF6cy8Fk97LVrVmq6y0lMlR2pNjX
z59OxSv4YXDdCL7rbHvsGtPVEo0UGGgZC1gdMK3N/ROsgsdpisP+ZzyN/P9EbQUY
UQqIy118h+jaWQdLg7shebvkX21+Zh8Slr2geol54Ufy3YbCFI/jTefEoLwBmtcW
qhHx0eK9ks6UJPEEsvDTm7eO9JUoDFkBBSj/hO9rJsE3MDwci6YqBWbIK7JAquCb
iwzQwRe86xcGkOg+fm5rwCMhRTNRNiuAIWHKnYXoCIO2fEUTgZff0q4k/foiPb1b
vpsZzHVPdR5/f+lMchf6unsZoiWYQsL6MyczX4+tAhJSJkNOpOMOM73UtFGitbEQ
nqRXVTmaVSiR+4OGG0/Rgc9TEu9FLXk1u1h1glQ/swjKDTyCsNKJI5acWDKxKU7T
sg9OBETb/kIoRsvSWuNsAt4NUMbN6RJKWcvDjISx9dk00ITfWoLzdrp2kPelUwnE
yag6/tYZRWp1buPZHK3wmGqiI625NKsXBPwFgDrz/pLZdLhcZEI=
=MQN0
-----END PGP SIGNATURE-----

--Sig_/y0rSksZreYQ/PWD.FzbsCIU--
