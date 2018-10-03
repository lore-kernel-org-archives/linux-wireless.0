Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F3E9C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 20:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2F8920684
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 20:22:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2F8920684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bues.ch
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbeJDDL4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 23:11:56 -0400
Received: from bues.ch ([80.190.117.144]:33006 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727144AbeJDDLz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 23:11:55 -0400
X-Greylist: delayed 996 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2018 23:11:53 EDT
Received: by bues.ch with esmtpsa (Exim 4.89)
        (envelope-from <m@bues.ch>)
        id 1g7nOe-00041w-DF; Wed, 03 Oct 2018 22:05:24 +0200
Date:   Wed, 3 Oct 2018 22:04:35 +0200
From:   Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ssb: chipcommon: fix fall-through annotation
Message-ID: <20181003220435.6f7c27b4@wiggum>
In-Reply-To: <20181003120102.GA22824@embeddedor.com>
References: <20181003120102.GA22824@embeddedor.com>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/PfFJg7Ygci4F8ZR17VKQECj"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/PfFJg7Ygci4F8ZR17VKQECj
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Oct 2018 14:01:02 +0200
"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> Replace "Fallthough" with a proper "fall through" annotation.
>=20
> This fix is part of the ongoing efforts to enabling
> -Wimplicit-fallthrough
>=20
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/ssb/driver_chipcommon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/ssb/driver_chipcommon.c b/drivers/ssb/driver_chipcom=
mon.c
> index 99a4656..3861cb6 100644
> --- a/drivers/ssb/driver_chipcommon.c
> +++ b/drivers/ssb/driver_chipcommon.c
> @@ -425,7 +425,7 @@ void ssb_chipco_get_clockcontrol(struct ssb_chipcommo=
n *cc,
>  			*m =3D chipco_read32(cc, SSB_CHIPCO_CLOCK_M2);
>  			break;
>  		}
> -		/* Fallthough */
> +		/* Fall through */
>  	default:
>  		*m =3D chipco_read32(cc, SSB_CHIPCO_CLOCK_SB);
>  	}

Acked-by: Michael B=C3=BCsch <m@bues.ch>


--=20
Michael

--Sig_/PfFJg7Ygci4F8ZR17VKQECj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlu1INMACgkQ9TK+HZCN
iw7Q1Q//QwsYOThlhR3DB4BrrCQ9NkS+STG/k+i+aQp61yUMcILepSaXvHsGvEx3
rTMScS6I98q2FnwD3IwfKsdGKxvtjacMRTfEiiuaqNaX9ikOpYnAHdAiNf16/4d4
uY0+D6Vb2z6e2wgVMWlKVaZKukFjGpNcK66Gt3EYfIw+QoMe0N/fZd0wwHkvkUDT
vMIU01pxNWXZ3DA/A1c4UKY8QkCwN1Fx9f9RqPqw+zTiyBV7BjRSaiZC2YUNxeCF
L4sRLSTQbxDH8DZukv0xGzyZhXsmhZl1n8/FqGI56IHJ7urLt3OqwH07OelwE9vT
bObJkwe7pFIzay66TWnC4tMmGvio4C995brrsyuEyUSlG7+MmuouHRQ5hK1KuoWr
+2gdSncJgPzZ026pSh2LTtAZvvrmI11wz1auKLdGmerm69+AJnpRTxF93WzOj95j
mvc0dvE96fnFewNSisC4adQwEl/leRAFpKhm+AvAB0AlXA9azSNb4KUR8vBS3Kc8
DgJL5HSEekVapySvkl7Dvb7NOj9kjnSY5JL+aN3oaJpJXXhtNxsViy5KE7lGrFXm
CLbuAhvsM8178u8gzOHknqHQjfASJvFTmapkQMJ7RQoSkR6NdXbjvBEEXTTZG9nV
/aLGKwc7tfyVDQxsgeoKxEVxPZSEUVWjx+NKBZXEEyNXJYDJ6AE=
=zgWz
-----END PGP SIGNATURE-----

--Sig_/PfFJg7Ygci4F8ZR17VKQECj--
