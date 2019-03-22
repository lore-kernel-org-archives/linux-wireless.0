Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E58C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 10:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C356218B0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 10:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbfCVKKp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 06:10:45 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51128 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbfCVKKp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 06:10:45 -0400
Received: by mail-wm1-f66.google.com with SMTP id z11so1568171wmi.0
        for <linux-wireless@vger.kernel.org>; Fri, 22 Mar 2019 03:10:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LG687TCkgRGLaDW8ASv+EU4WIYD1utSnjOpswG9RSQg=;
        b=ZjwxW7xiGEXE8tJ5RoXZDW7k8KBHdswXI85bzdCwtwfKcRxMP+Puw+PJGhO8trJSmk
         I1SR/8gXSZt4Javac2UdstyDYFYEYU+Ea8jsJqfWSGT+HUUtSNfTOMMrQXeRcUZOev2j
         HjVB92yxdQpUQkH0boft7TDwSf2ualKutDxoH7F/e2fi2wk4kDl1T7E3YwAH+2lk4dOn
         g5VyhlJZFnatustGg7kODOtB8Kle+nHlfymnE453FJ7UpnKmcPzS+3UVDGpOJmSA4uv1
         JALN7AfqP6XVk7CEl5zpDE28QXkfs66G7MabkV32ctz5P+8R8psk7DX3Qi9iloeFjc2l
         B2jg==
X-Gm-Message-State: APjAAAVp1j7Yy/9FqrzC4xcvqaHsFB7d8ptrwXW5rBsBp+STrKVCxniE
        nnFuh4IywB6QQvp7xcKHomHha4C0z4Q=
X-Google-Smtp-Source: APXvYqywSUD32L4i01gQeOE1CZkgxPGrVB3+mfaSDVkvXYfrWuuLfg+EIA/q6cdHg66A1zCqVYQpWw==
X-Received: by 2002:a7b:c769:: with SMTP id x9mr2531276wmk.103.1553249443141;
        Fri, 22 Mar 2019 03:10:43 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id w16sm6723916wrt.84.2019.03.22.03.10.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Mar 2019 03:10:42 -0700 (PDT)
Date:   Fri, 22 Mar 2019 11:10:40 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 03/12] mt76usb: change mt76u_fill_rx_sg arguments
Message-ID: <20190322101038.GA22889@localhost.localdomain>
References: <20190321152537.19105-1-sgruszka@redhat.com>
 <20190321152537.19105-4-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <20190321152537.19105-4-sgruszka@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> We do not need to pass len and sglen to the function.
> Additionally pass gfp to control allocation context.
>=20
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/usb.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wirel=
ess/mediatek/mt76/usb.c
> index 3f21599d52de..56e7a2ca8930 100644
> --- a/drivers/net/wireless/mediatek/mt76/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> @@ -285,11 +285,13 @@ mt76u_set_endpoints(struct usb_interface *intf,
>  }
> =20
>  static int
> -mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
> -		 int nsgs, int len, int sglen)
> +mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf, int nsgs,
> +		 gfp_t gfp)
>  {
>  	struct mt76_queue *q =3D &dev->q_rx[MT_RXQ_MAIN];
> +	int sglen =3D SKB_WITH_OVERHEAD(q->buf_size);
>  	struct urb *urb =3D buf->urb;
> +

please drop newline here

>  	int i;
> =20
>  	for (i =3D 0; i < nsgs; i++) {
> @@ -297,7 +299,7 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_b=
uf *buf,
>  		void *data;
>  		int offset;
> =20
> -		data =3D page_frag_alloc(&q->rx_page, len, GFP_ATOMIC);
> +		data =3D page_frag_alloc(&q->rx_page, q->buf_size, gfp);
>  		if (!data)
>  			break;
> =20
> @@ -326,8 +328,7 @@ mt76u_refill_rx(struct mt76_dev *dev, struct mt76_que=
ue *q,
>  		struct mt76u_buf *buf, int nsgs, gfp_t gfp)
>  {
>  	if (dev->usb.sg_en) {
> -		return mt76u_fill_rx_sg(dev, buf, nsgs, q->buf_size,
> -					SKB_WITH_OVERHEAD(q->buf_size));
> +		return mt76u_fill_rx_sg(dev, buf, nsgs, gfp);
>  	} else {
>  		buf->buf =3D page_frag_alloc(&q->rx_page, q->buf_size, gfp);
>  		return buf->buf ? 0 : -ENOMEM;
> --=20
> 2.20.1
>=20

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXJS0mgAKCRA6cBh0uS2t
rJigAQCsxg8QaFt93oV5wqN4FuftxtQQnJvLE3uE/iTd6cl+YQEAh0vSVTq4vOvQ
4YmLSHk7Ofsrcc9UJ+O/C69lOKLh1QE=
=8x+M
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
