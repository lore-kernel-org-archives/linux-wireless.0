Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from flock1.newmail.ru ([82.204.219.207]:56253 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752932AbZAHI2h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 03:28:37 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: David Kilroy <kilroyd@googlemail.com>
Subject: Re: [PATCH] orinoco: take the driver lock in the rx tasklet
Date: Thu, 8 Jan 2009 11:28:27 +0300
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
References: <1231287835-17707-1-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1231287835-17707-1-git-send-email-kilroyd@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8438500.fNtyfo5qWZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200901081128.30143.arvidjaar@mail.ru> (sfid-20090108_092841_335646_ABA38897)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart8438500.fNtyfo5qWZ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On =D0=A1=D1=80=D0=B5=D0=B4=D0=B0 07 =D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2=
009 03:23:55 David Kilroy wrote:
> Fix the warning reproduced below.
>
> We add to rx_list in interrupt context and remove elements in tasklet
> context. While removing elements we need to prevent the interrupt
> modifying the list.
>
> Note that commit 31afcef385bb8bf528c6fbe05b359af9f456f02a did not
> preserve locking semantics on what is now orinoco_rx.
>
> This patch reinstates the locking semantics and ensures it covers
> rx_list as well.=20
[...]
> --- a/drivers/net/wireless/orinoco/orinoco.c
> +++ b/drivers/net/wireless/orinoco/orinoco.c
> @@ -1613,6 +1613,16 @@ static void orinoco_rx_isr_tasklet(unsigned
[...]
> +	if (orinoco_lock(priv, &flags) !=3D 0)
> +		return;
>

this effectively serializes rx list processing with the rest of driver=20
(specifically orinoco_interrupt) eliminating any benefit from doing it=20
in separate tasklet. It is more simple and less confusing to just revert=20
commit 31afcef385bb8bf528c6fbe05b359af9f456f02a then.



--nextPart8438500.fNtyfo5qWZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklluS0ACgkQR6LMutpd94waqQCcCmaglr00DIuh630ZneFbywbU
A1YAnRjQJCmNRIormrip896iVbDrL2eP
=Q1zP
-----END PGP SIGNATURE-----

--nextPart8438500.fNtyfo5qWZ--
