Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.fenrir.org.uk ([81.168.115.223]:53119 "EHLO mx.fenrir.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622AbYDNH7W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 03:59:22 -0400
Date: Mon, 14 Apr 2008 08:59:18 +0100
From: Brian Morrison <bdm@fenrir.org.uk>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Latest compat-wireless build fails
Message-ID: <20080414085918.5116823b@peterson.fenrir.org.uk> (sfid-20080414_085930_202386_03ED10B1)
In-Reply-To: <1208138233.5319.36.camel@dv>
References: <20080412012305.76f1b7eb@fangio.fenrir.org.uk>
	<20080412104207.478f9f14@fangio.fenrir.org.uk>
	<1208138233.5319.36.camel@dv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 13 Apr 2008 21:57:13 -0400
Pavel Roskin <proski@gnu.org> wrote:

> Hello!
>=20
> Please don't use bcc: in public emails.  Put your addressees to to: a=
nd
> cc: so that nobody wonders why he or she is getting your e-mail.

Yes, it was an error on my part when I accidentally sent the mail back
to myself and then I did a redirect to the list rather than re-address
the mail. Not intentional, but I didn't think it through as I was in a
hurry.

>=20
> On Sat, 2008-04-12 at 10:42 +0100, Brian Morrison wrote:
> > On Sat, 12 Apr 2008 01:23:05 +0100
> > Brian Morrison <bdm@fenrir.org.uk> wrote:
> >=20
> > > If anyone is interested, the latest compat-wireless tarball fails=
 to
> > > build. It complains about some missing led defines in the rt2x00
> > > directory.
> > >=20
> > > I don't have the exact error messages to hand, but I imagine it's
> > > trivial for someone to type make and find out.
>=20
> It would be still useful if you provided the kernel version.
> compat-wireless tries to support the latest kernels, but occasionally
> new changes in the driver can break compatibility with the older
> kernels, and need to be patched.

This was with 2.6.24.4-64.fc8 on Fedora 8.

>=20
> > FWIW, the 2008-04-04 and later compat-wireless tarballs fail in the
> > same way.
> >=20
> > The error is:
> >=20
> > CC
> > [M]  /home/bdm/compat-wireless-2008-04-04/drivers/net/wireless/rt2x=
00/rt2x00leds.o
> > /home/bdm/compat-wireless-2008-04-04/drivers/net/wireless/rt2x00/rt=
2x00leds.c: In function =E2=80=98rt2x00leds_register=E2=80=99:
> > /home/bdm/compat-wireless-2008-04-04/drivers/net/wireless/rt2x00/rt=
2x00leds.c:171: error: =E2=80=98struct led_classdev=E2=80=99 has no mem=
ber named =E2=80=98blink_set=E2=80=99
>=20
> blink_set is defined in include/linux/led.h in the wireless-testing
> kernel.  I assume it's missing in the kernel you are using.
>=20

Looks like it isn't, so possibly there needs to be a way of providing
missing headers for kernels without their own complete set. Not sure ho=
w
that might be done.

--=20

Brian Morrison

bdm at fenrir dot org dot uk

   "Arguing with an engineer is like wrestling with a pig in the mud;
    after a while you realize you are muddy and the pig is enjoying it.=
"
   =20
GnuPG key ID DE32E5C5 - http://wwwkeys.uk.pgp.net/pgpnet/wwwkeys.html
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
