Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A2D2C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 16:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 108DA2147C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 16:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfCLQek (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 12:34:40 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37209 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfCLQej (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 12:34:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id y15so3436138wro.4
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 09:34:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=behQnk6qmedm5/SEJ1DUrC6NT4tuJxHcvwGRjOlX94Y=;
        b=EkIvyiIe5z7v2jRt2j971m7TDaksQGhCKQT2IGGdEh1gVozw0FnlTxL93q9zyE67Ov
         ZD8D6Uka9x3yPC2y/80e0wcaoIpAyktaKCkhrDdJb+KBAFgYE5LlOZOIS8Qoql4kLvx0
         wpBZFjP1EKJ+PIuoK0rCbJAu/VRgy8D8qBVV9SVgYuKRpOpQSZMVCyWKsX2yqDntwGDB
         cHnlQFttHBhhtwIQEt5OV8/NljEeJql2ZAghXhT3qyESL7oYGo3S7if3spWOQCmP7M/l
         wCfZY+WySlRgDsMVh786spfHovXmCk+yS5cdfq81suDE7WIPV0Zwjhx6+oizIwRXDieU
         Fapw==
X-Gm-Message-State: APjAAAWEC082i2HpOaTop+ZPvKy7Q/dkDtch6vkEcakjLbfDe0ywSFFY
        BjJ8nh22OS0rUh71/1GbLuai+Q==
X-Google-Smtp-Source: APXvYqzC1fCQVwbaLhZ+2GRapCfTZ5tOqtKeCsMUhMOFhWMYSSANxtqfE5LwEsVa7nKkw3YVK84tCQ==
X-Received: by 2002:adf:e987:: with SMTP id h7mr7836152wrm.89.1552408477680;
        Tue, 12 Mar 2019 09:34:37 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v1sm13186903wrt.88.2019.03.12.09.34.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Mar 2019 09:34:36 -0700 (PDT)
Date:   Tue, 12 Mar 2019 17:34:32 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC 11/12] mt76usb: allocate urb and sg as linear data
Message-ID: <20190312163431.GF2611@localhost.localdomain>
References: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
 <1552403166-3821-12-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FeAIMMcddNRN4P4/"
Content-Disposition: inline
In-Reply-To: <1552403166-3821-12-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--FeAIMMcddNRN4P4/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Alloc sg table at the end of urb structure. This will increase
> cache usage.
>=20

I am curious, have you observed any performance improvement doing so?

> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/usb.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wirel=
ess/mediatek/mt76/usb.c
> index 0b9f0b5fd37d..dd487f65f44e 100644
> --- a/drivers/net/wireless/mediatek/mt76/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> @@ -336,19 +336,19 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
>  static int
>  mt76u_urb_alloc(struct mt76_dev *dev, struct mt76_queue_entry *e)
>  {
> -	struct urb *urb;
> +	unsigned int size =3D sizeof(struct urb);
> +
> +	if (dev->usb.sg_en)
> +		size +=3D MT_SG_MAX_SIZE * sizeof(struct scatterlist);
> =20
> -	urb =3D usb_alloc_urb(0, GFP_KERNEL);
> -	if (!urb)
> +	e->urb =3D kzalloc(size, GFP_KERNEL);
> +	if (!e->urb)
>  		return -ENOMEM;
> -	e->urb =3D urb;
> =20
> -	if (dev->usb.sg_en) {
> -		urb->sg =3D devm_kcalloc(dev->dev, MT_SG_MAX_SIZE,
> -				       sizeof(urb->sg), GFP_KERNEL);
> -		if (!urb->sg)
> -			return -ENOMEM;
> -	}
> +	usb_init_urb(e->urb);
> +
> +	if (dev->usb.sg_en)
> +		e->urb->sg =3D (struct scatterlist *)((u8 *)e->urb + sizeof(struct urb=
));

You can avoid u8 cast doing:
(struct scatterlist *)(e->urb + 1)

Regards,
Lorenzo

> =20
>  	return 0;
>  }
> --=20
> 1.9.3
>=20

--FeAIMMcddNRN4P4/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXIffkwAKCRA6cBh0uS2t
rLEFAP0YUBBrTE2E9XYFst9aXbSomRa3PwQqE96FBgstbomBXAEAtkb0lva7rTGP
Hs/88vPbMxIJ0fcA4MOSM00WF5NngAU=
=uuJ7
-----END PGP SIGNATURE-----

--FeAIMMcddNRN4P4/--
