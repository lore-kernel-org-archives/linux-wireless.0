Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CDD7C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 11:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F90721900
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 11:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbfCVLCb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 07:02:31 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41824 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbfCVLCb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 07:02:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id p1so1834487wrs.8
        for <linux-wireless@vger.kernel.org>; Fri, 22 Mar 2019 04:02:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6ANzRJ0k+3+goLh3LfiFr7ME1Atee7NUlBLgpI+ki2Q=;
        b=PCRLxUZ6jJYoIXDVFX3ggBh0COOskZnCs7AGWrcyPPtk+LPtsuJ0mFAJkV1TpKdfRw
         gon7yp1toDM/nu7r8tYmqdtE4l+o8QoSLHv2UwWbVPDeHiMu0aAIl99My5MTxczdUxZZ
         /4Ru3KgSsYaGGwyoRtwwLSb7nNvBBZydaCEnZm1bJkL/eXTl5FXo58G3xmLt9ZuiwE4M
         cPo8vLJZzdhLXjdHsFi+G+eJGUwtpOPBCVR6e62rZOXix44807DZocTE0BD1fZFWDdNK
         N13XoqraIu8U4MpxtrP4Qv4JWMe7Vcif5xyZTfyoF8FVplGd92Ax2huOD/4fLQlTXHje
         RkqA==
X-Gm-Message-State: APjAAAX2DAYDVjLFPiJv2q2FkQYO2AxFByKYg0B3TJvqDK69PCqOpwZZ
        DRbxi/d6NR3OsYr1ae5d7tEr7pXW1OA=
X-Google-Smtp-Source: APXvYqz23/qPuV8OIlGjMlBB/bQou/s9icJjEjcq0HcUvkyjS0h14wDP+9S9MGCHIZ0fBCGZiC9KqQ==
X-Received: by 2002:a5d:4710:: with SMTP id y16mr5779877wrq.176.1553252549276;
        Fri, 22 Mar 2019 04:02:29 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s21sm6282263wmh.22.2019.03.22.04.02.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Mar 2019 04:02:28 -0700 (PDT)
Date:   Fri, 22 Mar 2019 12:02:26 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/12] mt76usb: some cleanups and optimizations
Message-ID: <20190322110226.GB22889@localhost.localdomain>
References: <20190321152537.19105-1-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <20190321152537.19105-1-sgruszka@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Significant change is remove mt76u_buf and use urb directly
> and allocate urb and sg as linear data for better cache usage.
> Other that that, set consist only of some minor cleanups.
>=20
> RFC -> v1:
> - introduce mt76u_tx_setup_buffers
> - calculate data_len differently
> - fix *usb->sg bug on intermediate patches
> - use (struct scatterlist *)(e->urb + 1) trick
>=20
> Rebased on latest tree and=20
> [PATCH v2 00/12] mt76x02: AP support for USB with PS
> https://lore.kernel.org/linux-wireless/1552991867-5087-1-git-send-email-s=
gruszka@redhat.com/
>  =20
> Not rebased on
> [PATCH 1/6] mt76: use mac80211 txq scheduling
> https://lore.kernel.org/linux-wireless/20190316204242.73560-1-nbd@nbd.nam=
e/
> It easer to rebase '[PATCH 5/6] mt76: move tx tasklet to struct mt76_dev'
> from that set of top of my 2 pending sets.=20

LGTM

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

>=20
> Stanislaw Gruszka (12):
>   mt76usb: change mt76u_submit_buf
>   mt76: remove rx_page_lock
>   mt76usb: change mt76u_fill_rx_sg arguments
>   mt76usb: use usb_dev private data
>   mt76usb: remove mt76u_buf redundant fileds
>   mt76usb: move mt76u_buf->done to queue entry
>   mt76usb: remove mt76u_buf and use urb directly
>   mt76usb: remove MT_RXQ_MAIN queue from mt76u_urb_alloc
>   mt76usb: resue mt76u_urb_alloc for tx
>   mt76usb: remove unneded sg_init_table
>   mt76usb: allocate urb and sg as linear data
>   mt76usb: remove queue variable from rx_tasklet
>=20
>  drivers/net/wireless/mediatek/mt76/mt76.h     |  15 +-
>  .../net/wireless/mediatek/mt76/mt76x0/usb.c   |   2 +-
>  .../net/wireless/mediatek/mt76/mt76x2/usb.c   |   4 +-
>  drivers/net/wireless/mediatek/mt76/usb.c      | 243 ++++++++----------
>  4 files changed, 118 insertions(+), 146 deletions(-)
>=20
> --=20
> 2.20.1
>=20

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXJTAvgAKCRA6cBh0uS2t
rKT0AQD+G40GFyJ0qyDcO6m27Yl/CeM6kLhgTyghuDaKxV7exwEAo5GeELz/jNB0
VEz6FPwvOV+oIvZ3XNye+syp5SCEbAg=
=QzUz
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
