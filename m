Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:49196 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1031121Ab2CFVJA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 16:09:00 -0500
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ 57/72] genirq: Unmask oneshot irqs when thread was not woken
Date: Tue, 6 Mar 2012 22:08:40 +0100
Cc: Sven Joachim <svenjoac@gmx.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jonathan Nieder <jrnieder@gmail.com>,
	linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
References: <20120228010511.GA8453@kroah.com> <8762eh1p7d.fsf@turtle.gmx.de> <alpine.LFD.2.02.1203062101040.2742@ionos>
In-Reply-To: <alpine.LFD.2.02.1203062101040.2742@ionos>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4115602.SlyyiuZHj3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201203062208.41340.s.L-H@gmx.de> (sfid-20120306_220938_300497_573B654E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4115602.SlyyiuZHj3
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi

On Tuesday 06 March 2012, Thomas Gleixner wrote:
> On Tue, 6 Mar 2012, Sven Joachim wrote:
> > Am 06.03.2012 um 20:31 schrieb Thomas Gleixner:
> >=20
> > > Stephan, Sven: Can you please provide the output of /proc/interrupts ?
> >=20
> > Here is mine, from a freshly booted 3.3-rc6 kernel.
> >=20
> > Cheers,
> >        Sven
> >=20
> >            CPU0      =20
> >   0:      25050    XT-PIC-XT-PIC    timer
[=E2=80=A6]
> >  10:        341    XT-PIC-XT-PIC    uhci_hcd:usb4, snd_hda_intel, b43
>=20
> Ah, XT-PIC uses handle_level_irq(). /me bangs head against desk.
>=20
> Does the patch below fix the problem for you ?
>=20
> Thanks,
>=20
> 	tglx
>=20
> ----------------->
> Subject: genirq: Clear action->thread_mask if IRQ_ONESHOT is not set
>=20
> commit ac5637611(genirq: Unmask oneshot irqs when thread was not
> woken) fails to unmask when a !IRQ_ONESHOT threaded handler is handled
> by handle_level_irq. This happens because thread_mask is or'ed
> unconditionally in irq_wake_thread(), but for !IRQ_ONESHOT interrupts
> never cleared. So the check for !desc->thread_active fails and keeps
> the interrupt disabled.
>=20
> Keep the thread_mask zero for !IRQ_ONESHOT interrupts.
[=E2=80=A6]

I can confirm that this patch, applied to 2.6.9, including "genirq:=20
Unmask oneshot irqs when thread was not woken", and + the current=20
stable queue-3.2 fixes b43 wlan operations. Feel free to add=20
Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
if you like.

Thanks a lot
	Stefan Lippers-Hollmann


--nextPart4115602.SlyyiuZHj3
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAk9WfNkACgkQORbEMfgJlPZY3ACfWQW+3tFoxAojuUpCYtuoCOfs
RqQAni9KJcwGvsmM9Yz3I9mI/hbXtLz9
=ZEcA
-----END PGP SIGNATURE-----

--nextPart4115602.SlyyiuZHj3--
