Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11ED4C10F06
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E176520657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfCKNRd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:17:33 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33099 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfCKNRd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 09:17:33 -0400
Received: by mail-wm1-f67.google.com with SMTP id c13so13909505wmb.0
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2019 06:17:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gNH+UB+4omSf/E3Nfp0ZICKuQr/hYGERyIUyfOrIZT4=;
        b=s1aOlmRQ2hvM1wjFsZzRNSLqZ0XEQBegSodBy33QpPwmHAwmsWk3Wzd+/6gsjrJ+w2
         PI/tY3xAycg3G6GpfqiHlvCaPSHjuV8efQMV45HraFqMSSJlx9r9CvozI+ku1mjZeJFc
         ltC470hP6JztYXZCWTj3kMwfZcHS0c9p3ae/P9Ycg3BUUhiYXO0HeTPka6cFe2MpPknO
         l5zMzFXO6E6+mJNo1ftutH9sE71aCUY1WYs/AXEJAYTRN+JstC2WXXnlGFFirqgAUyak
         DBBUrpE3Krx+DP0d6A/PjRrxQWol4DR6EB25jz9mO8qEuK3R46vk41PGCYko7PbFzsL7
         O88Q==
X-Gm-Message-State: APjAAAXSOj7cHrpTehdTF+Y8tZsvluEFKoY3RMbyXadC4D2Pe4UtejMF
        miHdzch8IoIgvPeDlsz1kT5YeQ==
X-Google-Smtp-Source: APXvYqy8WDP/2utCAvdCvwJHiiiv+n3KkWARfanHfCq4NlUeXXv81bXQa9Eot78Yl/4NiQtQA6fn6g==
X-Received: by 2002:a1c:2885:: with SMTP id o127mr18494347wmo.135.1552310250931;
        Mon, 11 Mar 2019 06:17:30 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id b195sm36693803wmg.36.2019.03.11.06.17.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Mar 2019 06:17:29 -0700 (PDT)
Date:   Mon, 11 Mar 2019 14:17:24 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     nbd@nbd.name, ryder.lee@mediatek.com, roychl666@gmail.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] move skb mapping before configuring txwi
Message-ID: <20190311131723.GB15418@localhost.localdomain>
References: <cover.1552306908.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline
In-Reply-To: <cover.1552306908.git.lorenzo@kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Move skb dma mapping before configuring txwi since new chipsets
> (e.g. mt7615) will need dma addresses to properly configure txwi.
> Introduce temporary tx_aligned4_skbs variable in order to tell mt76 layer
> if it is necessary to align the 802.11 header (it will be removed as soon
> as mac80211 will take care of it)
>=20
> Lorenzo Bianconi (4):
>   mt76: move mt76x02_insert_hdr_pad in mt76-core module
>   mt76: mmio: move mt76_insert_hdr_pad in mt76_dma_tx_queue_skb
>   mt76: move skb dma mapping before running tx_prepare_skb
>   mt76: introduce mt76_tx_info data structure
>=20
>  drivers/net/wireless/mediatek/mt76/dma.c      | 55 +++++++++----------
>  drivers/net/wireless/mediatek/mt76/mt76.h     | 25 ++++++++-
>  .../net/wireless/mediatek/mt76/mt7603/mac.c   |  2 +-
>  .../wireless/mediatek/mt76/mt7603/mt7603.h    |  2 +-
>  .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  1 +
>  drivers/net/wireless/mediatek/mt76/mt76x02.h  |  3 +-
>  .../net/wireless/mediatek/mt76/mt76x02_txrx.c | 21 +++----
>  .../net/wireless/mediatek/mt76/mt76x02_usb.h  |  2 +-
>  .../wireless/mediatek/mt76/mt76x02_usb_core.c |  4 +-
>  .../net/wireless/mediatek/mt76/mt76x02_util.c | 16 ------
>  .../net/wireless/mediatek/mt76/mt76x2/pci.c   |  1 +
>  11 files changed, 68 insertions(+), 64 deletions(-)

I forgot to mention this series is based on:
'introduce mt76_sw_queue data structure'
https://patchwork.kernel.org/cover/10836583/

Regards,
Lorenzo

>=20
> --=20
> 2.20.1
>=20

--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXIZf4AAKCRA6cBh0uS2t
rLjnAP9EoBaCY+Gnp2YsXUYmqWNfXsdt+jS2Z2XYBoxGICdHwgD/VWIkxYKfweEn
6u/4LAYjwahZ6Odt0sufjGfiOSgP1AI=
=73cM
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
