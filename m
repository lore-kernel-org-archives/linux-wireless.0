Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D035BC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 12:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94CDF2177E
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 12:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfCMMOO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 08:14:14 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40709 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfCMMOO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 08:14:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id t5so1728684wri.7
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2019 05:14:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=U2bReYqA5i3DoXBC7FqZ76VPEEuiRX0LY/KgXRj+LGA=;
        b=iCbLJthbOG7vxdtJlIs/T7JvGjtzPLAs6xsaZHa+RB++s3cz1GXyBdQ8ea0EHbq8iI
         1wYfNiIOWQT52DzPW9V8uvxf928PwqBG1x2K2iySYk6ugsq8u/pcuki389JPiYz4hOIl
         hto8TJvOfsVH6/AlStlr/0IyQYmSh/RhBgH/iy9bhjkI3Hx8ZdBCa4AdoYm8PQ65ksnp
         OwBzW2rJCb2eroDk7W3EZJqS/bvhw+QaopdTx+Sj5Fp/fGfdvOiTEOV6Poc6fHclPywY
         pekHIL8x5jt/SrbJQ1j8Qr0ecyzUdwk7qnOv8SspL8xAUR0aVklLYSfIWcQP5kevf6Tc
         fspQ==
X-Gm-Message-State: APjAAAWMXz2KK8gWEQOY1C1RMGGO5KNSrQDPScp17kzk8jUiw6CzxjcQ
        b8NkhXV8lo7vbi8gHl1Y020kVA==
X-Google-Smtp-Source: APXvYqwXhZmhN8mzq1jN5VunmLI6y1DKsU1EK1roNJ/Ln0dinnlXqmEM9V8sS0KnrA5GJ0jwREGaNw==
X-Received: by 2002:adf:f686:: with SMTP id v6mr10402722wrp.241.1552479252496;
        Wed, 13 Mar 2019 05:14:12 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id h126sm1914346wmf.2.2019.03.13.05.14.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 Mar 2019 05:14:11 -0700 (PDT)
Date:   Wed, 13 Mar 2019 13:14:08 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        roychl666@gmail.com, ryder.lee@mediatek.com
Subject: Re: [PATCH 4/5] mt76: introduce mt76_sw_queue data structure
Message-ID: <20190313121407.GB4389@localhost.localdomain>
References: <cover.1551533068.git.lorenzo@kernel.org>
 <f76120bea93ac19b82c63765aab27a003e6b187e.1551533068.git.lorenzo@kernel.org>
 <425244db-1638-1175-fa79-f4bda4cd7150@nbd.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uZ3hkaAS1mZxFaxD"
Content-Disposition: inline
In-Reply-To: <425244db-1638-1175-fa79-f4bda4cd7150@nbd.name>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 2019-03-02 14:47, Lorenzo Bianconi wrote:
> > Introduce mt76_sw_queue data structure in order to support new
> > chipsets (e.g. mt7615) that have a shared hardware queue for all traffic
> > identifiers. mt76_sw_queue will be used to track outstanding packets
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/wireless/mediatek/mt76/debugfs.c  |  7 ++-
> >  drivers/net/wireless/mediatek/mt76/dma.c      | 12 ++--
> >  drivers/net/wireless/mediatek/mt76/mac80211.c |  4 +-
> >  drivers/net/wireless/mediatek/mt76/mt76.h     | 16 ++++--
> >  .../wireless/mediatek/mt76/mt7603/beacon.c    |  8 +--
> >  .../net/wireless/mediatek/mt76/mt7603/dma.c   | 13 ++++-
> >  .../net/wireless/mediatek/mt76/mt7603/mac.c   |  4 +-
> >  .../net/wireless/mediatek/mt76/mt7603/main.c  |  2 +-
> >  .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 19 +++++--
> >  .../wireless/mediatek/mt76/mt76x02_usb_core.c |  2 +-
> >  .../net/wireless/mediatek/mt76/mt76x02_util.c |  2 +-
> >  drivers/net/wireless/mediatek/mt76/tx.c       | 55 ++++++++++---------
> >  drivers/net/wireless/mediatek/mt76/usb.c      | 23 +++++---
> >  13 files changed, 100 insertions(+), 67 deletions(-)
> >=20
> Turns out this causes a crash on cleanup if not all queues are
> initialized. I will fold in the following fix:
> ---
> --- a/drivers/net/wireless/mediatek/mt76/debugfs.c
> +++ b/drivers/net/wireless/mediatek/mt76/debugfs.c
> @@ -45,7 +45,7 @@ mt76_queues_read(struct seq_file *s, void *data)
>  	for (i =3D 0; i < ARRAY_SIZE(dev->q_tx); i++) {
>  		struct mt76_sw_queue *q =3D &dev->q_tx[i];
> =20
> -		if (!q->q->ndesc)
> +		if (!q->q)
>  			continue;
> =20
>  		seq_printf(s,
> --- a/drivers/net/wireless/mediatek/mt76/dma.c
> +++ b/drivers/net/wireless/mediatek/mt76/dma.c
> @@ -152,7 +152,7 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_t=
xq_id qid, bool flush)
>  	bool wake =3D false;
>  	int last;
> =20
> -	if (!q->ndesc)
> +	if (!q)
>  		return;
> =20
>  	spin_lock_bh(&q->lock);

ack, thx for fixing it.

Regards,
Lorenzo

--uZ3hkaAS1mZxFaxD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXIj0DAAKCRA6cBh0uS2t
rFQ0APwMNZIdQbFhjgX9EMXg7EJX21Epc0P4Mic1BfflLqoKEwEAiU1CdL0OsKxP
elJtJHByCgqYCXgQXE0Whz6vxyOooAg=
=nEn7
-----END PGP SIGNATURE-----

--uZ3hkaAS1mZxFaxD--
