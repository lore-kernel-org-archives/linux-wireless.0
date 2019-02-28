Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C32C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 09:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D7902171F
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 09:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731165AbfB1Ji1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 04:38:27 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35862 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfB1Ji1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 04:38:27 -0500
Received: by mail-wm1-f66.google.com with SMTP id j125so8217758wmj.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 Feb 2019 01:38:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=g2FgB4OkWIOSvEoS5co2tuGFKAkl7qk44D8EpAOf3eM=;
        b=bs9WH+jpJ+AUSbNRwbnTEiIfY3uc4rWKk6WE7yO4OzUfZoNu/WM4R3ZdZq/tyg4j6D
         hYw3Z8eEdV+YRWpFQQortJghJG41Pm2/4RVJarxP0KXrZrMZFSGjVV4YhirZpdEfJz5e
         KQY+o5Q1PPK5085XiN6gRGaJpv9xgGmEtS6G1zWhwdf1sC9wLCYqLUHCive4BzitAXva
         4oqVBSvDvvx0rQOADWjwTSBWKktD3zruukOrD/hk8wUcXzWAsuOYnm1OOcRscUtHoEsb
         oYS7FKg/h6fNiRsVIPzPeX8pDxdOr4RWUdD3uBNZgd+wi0FScH4JrpypJ3+w6gFQWmF5
         FNdA==
X-Gm-Message-State: AHQUAubJXSOGDBsi92UOP8/+yQw7dSH6hCaSLb7XZzCK97LdKhVS/Zzh
        CtBGGKL8fUqpexT0xalmZX3tAe+Q1Dg=
X-Google-Smtp-Source: APXvYqzcMro2NRMB87J471TCzfou6sv2lqsdvc5abVrcuh6Dwby12puN3kFJk1m1l5+JQRm7/nwmIQ==
X-Received: by 2002:a05:600c:2143:: with SMTP id v3mr2238048wml.14.1551346705412;
        Thu, 28 Feb 2019 01:38:25 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id l130sm5772978wmf.13.2019.02.28.01.38.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Feb 2019 01:38:24 -0800 (PST)
Date:   Thu, 28 Feb 2019 10:38:20 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [RFC 07/12] mt76x02: fix hdr pointer in write txwi for USB
Message-ID: <20190228093819.GA2768@localhost.localdomain>
References: <1551341013-24519-1-git-send-email-sgruszka@redhat.com>
 <1551341013-24519-8-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <1551341013-24519-8-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Since we add txwi at the begining of skb->data, it no longer point
> to ieee80211_hdr. This breaks settings TS bit for probe response and
> beacons.
>=20
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/driv=
ers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
> index fdd6a021914d..bcf3126efda9 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
> @@ -85,8 +85,9 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void=
 *data,
> =20
>  	mt76x02_insert_hdr_pad(skb);
> =20
> -	txwi =3D skb_push(skb, sizeof(struct mt76x02_txwi));
> +	txwi =3D (struct mt76x02_txwi *)(skb->data - sizeof(struct mt76x02_txwi=
));
>  	mt76x02_mac_write_txwi(dev, txwi, skb, wcid, sta, len);
> +	skb_push(skb, sizeof(struct mt76x02_txwi));
> =20
>  	pid =3D mt76_tx_status_skb_add(mdev, wcid, skb);
>  	txwi->pktid =3D pid;
> --=20
> 2.20.1
>=20

Good catch :)
I think we should post it ontop of wireless-drivers since sw encryption is =
not
working now.

Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXHesBwAKCRA6cBh0uS2t
rGfMAP9EOfFtvsn5elKAfsusYkvfbZME9SOXEsQwB+DMIYMobgD+Lv0mbsy9edmF
/6jZe0QWXwYKKSnSkyJrW3Z6dpHfAAA=
=fQe2
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
