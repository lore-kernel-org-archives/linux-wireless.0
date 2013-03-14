Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:34334 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab3CNS7p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 14:59:45 -0400
Date: Thu, 14 Mar 2013 19:55:49 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, zajec5@gmail.com, isedev@gmail.com,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [RFC/RFT] b43: A fix for DMA transmission sequence errors
Message-ID: <20130314195549.56fea051@milhouse> (sfid-20130314_195948_574914_4582F7BA)
In-Reply-To: <51421afb.xUa3KbaBuvmUk4RG%Larry.Finger@lwfinger.net>
References: <51421afb.xUa3KbaBuvmUk4RG%Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bwe7=k2+wzGp14pmuZ/Q_qL"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/bwe7=k2+wzGp14pmuZ/Q_qL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Mar 2013 13:46:19 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

>  	if (unlikely(slot !=3D firstused)) {
>  		/* This possibly is a firmware bug and will result in
> -		 * malfunction, memory leaks and/or stall of DMA functionality. */
> +		 * malfunction, memory leaks and/or stall of DMA functionality.
> +		 */
>  		b43dbg(dev->wl, "Out of order TX status report on DMA ring %d. "
>  		       "Expected %d, but got %d\n",
>  		       ring->index, firstused, slot);
> -		return;
> +		if (slot =3D=3D firstused + 2) {

I guess you need to handle wrap-over here.
This would probably do:
		if (slot =3D=3D next_slot(ring, next_slot(ring, firstused)))

--=20
Michael

--Sig_/bwe7=k2+wzGp14pmuZ/Q_qL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQh01AAoJEPUyvh2QjYsOBvYP/RLL7/YH3dpdBtJp+9/xoJh5
L+dVVok7h1UMFcA0s97GIycVSUWz5Q9t2DyOeUlsJ0oLLMq28GxIjzoMj4lPOUUL
gsrdDTdtngC9vlnnnPrDQlasUGiz8UxT9Vd0by5jZD/h7I57y8lpanYyK4Mixsm6
7eqPesJQ//ezGIBpPu7rC3Vhivlq8lr5UUXdvigi6tp0PkSZ9SK2NmDPsutXtXYp
pJH1bbXVupyocS9P2JA494lYS0DLKaVTSPM64LiaYyqa/O1p7kaudl6ZDfLTkPHe
WB5Bdlmib2xulXAu5TKrpzOYUu6CnsbN/JJbgjkpYiRkkluP01KHbrpcM0IpmsPL
SirbaIMUAruthP7brdeR17UPWSe+8Cl7R1eMuUCxvf8Jo7b0c5obS/czdld4QbwH
z8h3XzBMIQSGt+qKlBf8oYDdpH84EGYT3H0kz8eb3U8zucH+9isPKHUmplKY1hA5
7kYLInpEIK6UMp6b1XCrjFN8gNT1Wfav19R6MSyt5RPwgUYwF4owyZSJs+wxSFZA
rJk1GryhjcAlqqlsTsf0mRlaPSBSEvzFPcKiGj6HBn9pFLlCh41bw4ezLSumCUMJ
KFjoxeaGXF77AusIbDkLfVG1UKy7riqD90IqEsphRfWLMuhO6xOaSOuFa5TU49Zk
+YK10yzSyH/uGTCuZeDX
=k121
-----END PGP SIGNATURE-----

--Sig_/bwe7=k2+wzGp14pmuZ/Q_qL--
