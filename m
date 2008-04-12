Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.fenrir.org.uk ([81.168.115.223]:36445 "EHLO mx.fenrir.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761325AbYDLJwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Apr 2008 05:52:40 -0400
Received: from fangio.fenrir.org.uk ([10.0.0.4])
	(TLSv1:AES256-SHA:256)
	by mx.fenrir.org.uk with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1JkcPW-0001es-LX
	for <linux-wireless@vger.kernel.org>; Sat, 12 Apr 2008 10:52:38 +0100
Date: Sat, 12 Apr 2008 10:42:07 +0100
From: Brian Morrison <bdm@fenrir.org.uk> (by way of Brian Morrison
	<bdm@fenrir.org.uk>)
To: Brian Morrison <bdm@fenrir.org.uk>
Message-ID: <20080412104207.478f9f14@fangio.fenrir.org.uk> (sfid-20080412_105318_939979_FC9DF4C9)
In-Reply-To: <20080412012305.76f1b7eb@fangio.fenrir.org.uk>
References: <20080412012305.76f1b7eb@fangio.fenrir.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: Re: Latest compat-wireless build fails
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 12 Apr 2008 01:23:05 +0100
Brian Morrison <bdm@fenrir.org.uk> wrote:

> If anyone is interested, the latest compat-wireless tarball fails to
> build. It complains about some missing led defines in the rt2x00
> directory.
>=20
> I don't have the exact error messages to hand, but I imagine it's
> trivial for someone to type make and find out.
>=20
> Cheers!
>=20

=46WIW, the 2008-04-04 and later compat-wireless tarballs fail in the
same way.

The error is:

CC [M]  /home/bdm/compat-wireless-2008-04-04/drivers/net/wireless/rt2x0=
0/rt2x00leds.o
/home/bdm/compat-wireless-2008-04-04/drivers/net/wireless/rt2x00/rt2x00=
leds.c: In function =E2=80=98rt2x00leds_register=E2=80=99:
/home/bdm/compat-wireless-2008-04-04/drivers/net/wireless/rt2x00/rt2x00=
leds.c:171: error: =E2=80=98struct led_classdev=E2=80=99 has no member =
named =E2=80=98blink_set=E2=80=99
/home/bdm/compat-wireless-2008-04-04/drivers/net/wireless/rt2x00/rt2x00=
leds.c:174: error: =E2=80=98struct led_classdev=E2=80=99 has no member =
named =E2=80=98blink_set=E2=80=99
make[4]: *** [/home/bdm/compat-wireless-2008-04-04/drivers/net/wireless=
/rt2x00/rt2x00leds.o] Error 1
make[3]: *** [/home/bdm/compat-wireless-2008-04-04/drivers/net/wireless=
/rt2x00] Error 2
make[2]: *** [/home/bdm/compat-wireless-2008-04-04/drivers/net/wireless=
] Error 2
make[1]: *** [_module_/home/bdm/compat-wireless-2008-04-04] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.24.4-64.fc8-x86_64'
make: *** [modules] Error 2

so it looks like a missing define or variable definition.

--=20

Brian

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
