Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from flock1.newmail.ru ([82.204.219.207]:48128 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756488AbZAVECv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 23:02:51 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Dave <kilroyd@googlemail.com>
Subject: Re: [PATCH] orinoco: take the driver lock in the rx tasklet
Date: Thu, 22 Jan 2009 07:02:03 +0300
Cc: orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
References: <1231287835-17707-1-git-send-email-kilroyd@googlemail.com> <200901081128.30143.arvidjaar@mail.ru> <496644D0.6050301@gmail.com>
In-Reply-To: <496644D0.6050301@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7957227.OCnt6USIjV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200901220702.14152.arvidjaar@mail.ru> (sfid-20090122_050256_484936_CF805B17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart7957227.OCnt6USIjV
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 8 =D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2009 21:24:16 Dave wrote:
> Andrey Borzenkov wrote:
> > On 07 January 2009 03:23:55 David Kilroy wrote:
> >> Fix the warning reproduced below.
> >>
> >> We add to rx_list in interrupt context and remove elements in
> >> tasklet context. While removing elements we need to prevent the
> >> interrupt modifying the list.
> >>
> >> Note that commit 31afcef385bb8bf528c6fbe05b359af9f456f02a did not
> >> preserve locking semantics on what is now orinoco_rx.
> >>
> >> This patch reinstates the locking semantics and ensures it covers
> >> rx_list as well.
> >
> > [...]
> >
> >> --- a/drivers/net/wireless/orinoco/orinoco.c
> >> +++ b/drivers/net/wireless/orinoco/orinoco.c
> >> @@ -1613,6 +1613,16 @@ static void orinoco_rx_isr_tasklet(unsigned
> >
> > [...]
> >
> >> +	if (orinoco_lock(priv, &flags) !=3D 0)
> >> +		return;
> >
> > this effectively serializes rx list processing with the rest of
> > driver (specifically orinoco_interrupt) eliminating any benefit
> > from doing it in separate tasklet. It is more simple and less
> > confusing to just revert commit
> > 31afcef385bb8bf528c6fbe05b359af9f456f02a then.
>
> [adding orinoco-devel, who I missed of the original patch submission]
>
> The move to the RX tasklet was not motivated by improved performance,
> but the requirements of the crypto library (can't call from
> interrupt) and the need to do MIC calculations on RX.
>

What exactly prevents crypto library being called from interrupt (aka=20
can it sleep)? Because now it runs under spinlock with interrupts=20
disabled; how exactly does it differ from being called from interrupt=20
context?

> Unless the crypto routines have changed, reverting that commit will
> break WPA support.
>

=46or all I can tell, code now is functionally identical to code before=20
moving rx processing to tasklet. Meaning, if it was wrong before it=20
became just as wrong now.

--nextPart7957227.OCnt6USIjV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl3770ACgkQR6LMutpd94xx4ACcCaS4mRtuvPLeh7fenVM3V166
0pkAn2Pd7MJyGNwQr+WnQ+w8Pro8H6bI
=Wvu9
-----END PGP SIGNATURE-----

--nextPart7957227.OCnt6USIjV--
