Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from daemonizer.de ([87.230.16.230]:33695 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbXE1OMU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2007 10:12:20 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: b44: regression in 2.6.22 (resend)
Date: Mon, 28 May 2007 16:12:12 +0200
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Jeff Garzik <jgarzik@pobox.com>,
	Gary Zambrano <zambrano@broadcom.com>, netdev@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070525172431.60affaca@freepuppy> <200705280240.17910.maxi@daemonizer.de> <200705281249.56106.mb@bu3sch.de>
In-Reply-To: <200705281249.56106.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart131155292.T37GDDYD6P";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705281612.15649.maxi@daemonizer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart131155292.T37GDDYD6P
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 28 May 2007, Michael Buesch wrote:
> Can you also test the following patch?
> I think there's a bug in b44 that is doesn't properly discard
> shared IRQs, so it might possibly generate a NAPI storm, dunno.
> Worth a try.
>
> Index: linux-2.6.22-rc3/drivers/net/b44.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.22-rc3.orig/drivers/net/b44.c	2007-05-27 23:01:44.000000000
> +0200 +++ linux-2.6.22-rc3/drivers/net/b44.c	2007-05-28 12:48:27.000000000
> +0200 @@ -911,6 +911,8 @@ static irqreturn_t b44_interrupt(int irq
>  	spin_lock(&bp->lock);
>
>  	istat =3D br32(bp, B44_ISTAT);
> +	if (istat =3D=3D 0xFFFFFFFF)
> +		goto out; /* Shared IRQ not for us */
>  	imask =3D br32(bp, B44_IMASK);
>
>  	/* The interrupt mask register controls which interrupt bits
> @@ -942,6 +944,7 @@ irq_ack:
>  		bw32(bp, B44_ISTAT, istat);
>  		br32(bp, B44_ISTAT);
>  	}
> +out:
>  	spin_unlock(&bp->lock);
>  	return IRQ_RETVAL(handled);
>  }

I did try this patch on a affected kernel, but I didn't notice any big=20
difference. Perhaps the kernel is a bit less slow during the test, but It's=
=20
hard to tell.

Maxi

--nextPart131155292.T37GDDYD6P
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGWuM/Oimwv528XGERAoUpAJ9FKsdLlvEpiWlkV2IhB/Xz3G+nWwCfUKiZ
GmNPAZpmjrs+C8scjd2yxM8=
=Pqqs
-----END PGP SIGNATURE-----

--nextPart131155292.T37GDDYD6P--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
