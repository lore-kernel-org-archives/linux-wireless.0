Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:61184 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318AbYDNB5P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2008 21:57:15 -0400
Subject: Re: Latest compat-wireless build fails
From: Pavel Roskin <proski@gnu.org>
To: Brian Morrison <bdm@fenrir.org.uk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080412104207.478f9f14@fangio.fenrir.org.uk>
References: <20080412012305.76f1b7eb@fangio.fenrir.org.uk>
	 <20080412104207.478f9f14@fangio.fenrir.org.uk>
Content-Type: text/plain; charset=iso-8859-7
Date: Sun, 13 Apr 2008 21:57:13 -0400
Message-Id: <1208138233.5319.36.camel@dv> (sfid-20080414_025728_368823_4236360B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

Please don't use bcc: in public emails.  Put your addressees to to: and
cc: so that nobody wonders why he or she is getting your e-mail.

On Sat, 2008-04-12 at 10:42 +0100, Brian Morrison wrote:
> On Sat, 12 Apr 2008 01:23:05 +0100
> Brian Morrison <bdm@fenrir.org.uk> wrote:
>=20
> > If anyone is interested, the latest compat-wireless tarball fails t=
o
> > build. It complains about some missing led defines in the rt2x00
> > directory.
> >=20
> > I don't have the exact error messages to hand, but I imagine it's
> > trivial for someone to type make and find out.

It would be still useful if you provided the kernel version.
compat-wireless tries to support the latest kernels, but occasionally
new changes in the driver can break compatibility with the older
kernels, and need to be patched.

> FWIW, the 2008-04-04 and later compat-wireless tarballs fail in the
> same way.
>=20
> The error is:
>=20
> CC
> [M]  /home/bdm/compat-wireless-2008-04-04/drivers/net/wireless/rt2x00=
/rt2x00leds.o
> /home/bdm/compat-wireless-2008-04-04/drivers/net/wireless/rt2x00/rt2x=
00leds.c: In function =A1rt2x00leds_register=A2:
> /home/bdm/compat-wireless-2008-04-04/drivers/net/wireless/rt2x00/rt2x=
00leds.c:171: error: =A1struct led_classdev=A2 has no member named =A1b=
link_set=A2

blink_set is defined in include/linux/led.h in the wireless-testing
kernel.  I assume it's missing in the kernel you are using.

--=20
Regards,
Pavel Roskin
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
