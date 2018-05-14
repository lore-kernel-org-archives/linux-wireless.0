Return-Path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36195 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751992AbeENRt4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 13:49:56 -0400
Received: by mail-wm0-f68.google.com with SMTP id n10-v6so16738811wmc.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2018 10:49:56 -0700 (PDT)
Date: Mon, 14 May 2018 18:49:53 +0100
From: Chris Vine <vine35792468@gmail.com>
To: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Regression: bcm4312 lp-phy device not working in 4.17-rc5 kernel
Message-Id: <20180514184953.001c06412efcf2b16fdc59ac@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have an old netbook with a Broadcom bcm4312 802.11b/g lp-phy
[14e4:4315] (rev 01) wifi device.  This works up to and including the
4.16 kernel, but not with 4.17-rc5.

The b43, mac80211, cfg80211, ssb and mmc_core modules are loaded OK, as
is the firmware, and the wlan0 interface will come up, but any attempt
to use the interface fails and it cannot (for example) scan.

No useful error messages are given.  The interface (wlan0) is just
reported as not being ready.

Chris
>From linux-wireless-owner@vger.kernel.org Mon May 14 20:56:25 2018
Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Original-To: j@w1.fi
Delivered-To: j@w1.fi
Received: from localhost (localhost [127.0.0.1])
	by li674-96.members.linode.com (Postfix) with ESMTP id 1F60511A03
	for <j@w1.fi>; Mon, 14 May 2018 17:56:25 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at w1.fi
Received: from li674-96.members.linode.com ([127.0.0.1])
	by localhost (mail.w1.fi [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oU70Yhi8425U for <j@w1.fi>;
	Mon, 14 May 2018 17:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by li674-96.members.linode.com (Postfix) with ESMTP id 6040410F4D
	for <j@w1.fi>; Mon, 14 May 2018 17:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752251AbeENR4S (ORCPT <rfc822;j@w1.fi>);
        Mon, 14 May 2018 13:56:18 -0400
Received: from bues.ch ([80.190.117.144]:60014 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752024AbeENR4Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 13:56:16 -0400
Date:   Mon, 14 May 2018 19:55:39 +0200
From:   Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To:     Chris Vine <vine35792468@gmail.com>
Cc:     linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: Regression: bcm4312 lp-phy device not working in 4.17-rc5
 kernel
Message-ID: <20180514195539.74686870@wiggum>
In-Reply-To: <20180514184953.001c06412efcf2b16fdc59ac@gmail.com>
References: <20180514184953.001c06412efcf2b16fdc59ac@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/Ji.OWRUI1EkVOiswkG+_pal"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org
Content-Length: 1911

--Sig_/Ji.OWRUI1EkVOiswkG+_pal
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 14 May 2018 18:49:53 +0100
Chris Vine <vine35792468@gmail.com> wrote:

> I have an old netbook with a Broadcom bcm4312 802.11b/g lp-phy
> [14e4:4315] (rev 01) wifi device.  This works up to and including the
> 4.16 kernel, but not with 4.17-rc5.
>=20
> The b43, mac80211, cfg80211, ssb and mmc_core modules are loaded OK, as
> is the firmware, and the wlan0 interface will come up, but any attempt
> to use the interface fails and it cannot (for example) scan.
>=20
> No useful error messages are given.  The interface (wlan0) is just
> reported as not being ready.

Hi,

thanks for your report.

Can you please provide all kernel log messages anyway?
And what does "not ready" mean exactly?

It would be extremely helpful if you'd do a git bisect to find the
commit that broke it.

--=20
Michael

--Sig_/Ji.OWRUI1EkVOiswkG+_pal
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlr5zZsACgkQ9TK+HZCN
iw6QiA//Vh+LV9ZkLUG4zye21fP5i+XPonkuVwy5+vCKzc36akbHeGG/LdOx6gGG
paikZi4AG+e5vqowE/27Y+MIGX3xUZxETO5m5mfiXrb4AjQ5mTBZoO/MzWHz54sg
Ths5Ejs9o4QG6Us0/PaMqHsxRdajoR/76aEs8esglrTFtd48caIcJITbXS0t3Fwy
XOEzmRwx35INHZbLyb+NG7QYt2lBjgMxpFYv7sJ9aTWbJpqpbgrO4Pidg+s4LvLu
Zvb/an4px9y3v/sqNg2/URLiR6e2nhBbxUKX/hOSp/mg1qLSL2+QUByVQxTM7o5+
1ClYTUF4FBCPB28F3vZZmJz5lPaqlTanIAKbv1F8ONts7VxhEA77aSvJ3Pq5cHas
kt+BgK67Ls/MGHBjJNf7rkIdbEpLR9ZllYKCSe7BXPpXNGn+EIohmw0g78O3WE87
BIwTS9qtmtjnk0cjNEh9eLKqJF8iz0Mk+T8poEKwFmK7H+A6VMLMlpIiw/gl7KiP
S4nb4qpQXR35uw/RsCnGQIQLZ79ajyQ391d9GLIs5YW/REmLm/6Nff7qGkWy9XBR
DYbSkmCcwLxU/Xr1+gVc4jTrIoVInBEegyesBxvG7eUFuE2pE+JEF/Dj9nDNc8S0
M4lGmLMmqlhMpMje4G2iBlVB91hqJ9gAXXEoVBolO+x6SQIeSu8=
=y6Sh
-----END PGP SIGNATURE-----

--Sig_/Ji.OWRUI1EkVOiswkG+_pal--
