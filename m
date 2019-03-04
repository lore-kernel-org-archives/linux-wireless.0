Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE63C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 11:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A990820643
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 11:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfCDLlS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 06:41:18 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37091 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbfCDLlS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 06:41:18 -0500
Received: by mail-wm1-f68.google.com with SMTP id x10so4338243wmg.2
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2019 03:41:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uCGNHQ20hGcSS+886YRZpPLBR45LzrwZ9hMz1YQdeCk=;
        b=h/BLwAqs2TEaHvt3UtshPM2Rash6Mc0fGj66D6vFFL2YA2o1OA9JseovDPmakva1JT
         pbE+4DCUQ19G5ohEjV962VOfrdBPdNF9PUBfB3aciDXZ/5Hka3KLpiFMFHwl0H19jlCS
         2f8h9CakUp9e48g49U24YmFsebMQYj0xiq1AOkVNuqaHThyR08QsRo6aQsGlLEa17qyc
         HUs71YopWBE2qRluSMxXjWF+ysekihK64NPbJJGlFTaOuLm+eRO/2LLLxp6n42dpHzCS
         sywO56upNBzXtXYh1gy/ZUqLlYuNQurS1NhfUuMDE5qE8hrQzGso2Bv2ESGzRzCKACjs
         6oXw==
X-Gm-Message-State: APjAAAV85oGsxyfvzrZbnIZbKnUKCVUPY4iM2asZtCsEQuPeq5u2gu8I
        Ghqcvk85/7yRWrwy095hEmSX56OLqsc=
X-Google-Smtp-Source: AHgI3IaZTtoDXPNEDXsuQxvOB6dOJEIoH21Ht1pXCuGcEG4s1XYGzB84Q2vDgS67sfXv7j11hUYJaQ==
X-Received: by 2002:a05:600c:210b:: with SMTP id u11mr10927080wml.11.1551699676414;
        Mon, 04 Mar 2019 03:41:16 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id p12sm4755489wrt.4.2019.03.04.03.41.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Mar 2019 03:41:15 -0800 (PST)
Date:   Mon, 4 Mar 2019 12:41:12 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Joe Perches <joe@perches.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: Re: [PATCH] mt76: usb: reduce code indentation in mt76u_alloc_tx
Message-ID: <20190304114111.GD3073@localhost.localdomain>
References: <cover.1551534029.git.lorenzo@kernel.org>
 <2ead6e0fc3222faa772a37d55736c03041c90a1f.1551534029.git.lorenzo@kernel.org>
 <c422bd435e6172424ac2c27f673a64316576e819.camel@perches.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="g7w8+K/95kPelPD2"
Content-Disposition: inline
In-Reply-To: <c422bd435e6172424ac2c27f673a64316576e819.camel@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--g7w8+K/95kPelPD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sat, 2019-03-02 at 14:50 +0100, Lorenzo Bianconi wrote:
> > Improve code readability reducing code indentation in
> > mt76u_alloc_tx
>=20
> Trivial note below:
>=20
> > diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wir=
eless/mediatek/mt76/usb.c
> []
> > @@ -787,6 +787,7 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
> >  {
> >  	struct mt76u_buf *buf;
> >  	struct mt76_queue *q;
> > +	size_t size;
> >  	int i, j;
> > =20
> >  	for (i =3D 0; i < IEEE80211_NUM_ACS; i++) {
> > @@ -810,15 +811,15 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
> >  			if (!buf->urb)
> >  				return -ENOMEM;
> > =20
> > -			if (dev->usb.sg_en) {
> > -				size_t size =3D MT_SG_MAX_SIZE *
> > -					      sizeof(struct scatterlist);
> > +			if (!dev->usb.sg_en)
> > +				continue;
> > =20
> > -				buf->urb->sg =3D devm_kzalloc(dev->dev, size,
> > -							    GFP_KERNEL);
> > -				if (!buf->urb->sg)
> > -					return -ENOMEM;
> > -			}
> > +			size =3D MT_SG_MAX_SIZE * sizeof(struct scatterlist);
> > +
> > +			buf->urb->sg =3D devm_kzalloc(dev->dev, size,
> > +						    GFP_KERNEL);
>=20
> Perhaps eliminate size and use devm_kcalloc instead like
> the allocation immediately above this.
> ---
>  drivers/net/wireless/mediatek/mt76/usb.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wirel=
ess/mediatek/mt76/usb.c
> index ae6ada370597..fc87ae223f8d 100644
> --- a/drivers/net/wireless/mediatek/mt76/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> @@ -806,15 +806,15 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
>  			if (!buf->urb)
>  				return -ENOMEM;
> =20
> -			if (dev->usb.sg_en) {
> -				size_t size =3D MT_SG_MAX_SIZE *
> -					      sizeof(struct scatterlist);
> -
> -				buf->urb->sg =3D devm_kzalloc(dev->dev, size,
> -							    GFP_KERNEL);
> -				if (!buf->urb->sg)
> -					return -ENOMEM;
> -			}
> +			if (!dev->usb.sg_en)
> +				continue;
> +
> +			buf->urb->sg =3D devm_kcalloc(dev->dev,
> +						    MT_SG_MAX_SIZE,
> +						    sizeof(*buf->urb->sg),
> +						    GFP_KERNEL);
> +			if (!buf->urb->sg)
> +				return -ENOMEM;
>  		}
>  	}
>  	return 0;
>=20

ack, I will post a v2, thx

Regards,
Lorenzo

>=20

--g7w8+K/95kPelPD2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXH0O1AAKCRA6cBh0uS2t
rN6dAQDP8wCjSS0mtaQSaekWinhzpmdrdnK6cyzmvz6DVktbEgEAnHnZh/0ZT66M
yNPomHY8KnYqdVjhITamyV8+vV5meQs=
=lIgX
-----END PGP SIGNATURE-----

--g7w8+K/95kPelPD2--
