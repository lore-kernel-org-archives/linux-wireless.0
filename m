Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9692C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 19:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98303218FE
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 19:25:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1P7kS4Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbfCVTZl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 15:25:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38977 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfCVTZl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 15:25:41 -0400
Received: by mail-wm1-f67.google.com with SMTP id t124so3233441wma.4
        for <linux-wireless@vger.kernel.org>; Fri, 22 Mar 2019 12:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n7ngg4JF+rzvOfnPjOAg1BjIpI8zb7UwgqF93+Q0lA0=;
        b=N1P7kS4Qr4ZSBzAMlhgmGU+deVD1JC6gfUN2kC5PCcGHCBZik9xOn2vJkWUxaAnmWL
         yJ6gHYn/yJ5FuFnadb2R7r8fZEprx2GQ6fvVakxHnRs3QKDuNNJ75lGMZjKOusvnjtfL
         7F12VcT1xfTgTWZG5NdHYugGVDPh2Fy54W0bSfCis/jOpK6QGP5lXdToEJEmDEfWglww
         NyX9PtX+8qO1h4bTajmK81X4m3pHbTIuZaI7tIPijIRRdYSq0SeA8P+MadPjP1ICYMPv
         CBicD3iVMbWhlF0RjIOBEknRNB3p41ghfMhQC37ZL8bBNqbVqgvweGeZTeAIwJi+uZ3/
         70+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n7ngg4JF+rzvOfnPjOAg1BjIpI8zb7UwgqF93+Q0lA0=;
        b=lFLQ7CUDHqCLyyrPh0AgNnk3Q/QbDA7anzn0lm+hwSfTsU/p+ZT3zFK+qEsy6dB5Dx
         xdEoZfgdqE+FsKMX0D2iZ6yrxAkkatlDqjgU/0pQJpTLt3lmCnHUA0F4CUraioh/OuLP
         FwwCTforcBu9GMaBZWagq0gIEqDViqPpcG0ZkHvrvSnpJ6ee09BAnoYwKAEbqmu0O1Hj
         LJ3MHRBSrRs8CoOmRy6JzUKkDP93eoOG/0OU7s78t8I68HrUCRDzYrbAgl0J1zueBTbb
         E+FB9LOxoQSJqDcBBjT8nsTJ+rAPstSWCF/W9quJ5jv9utDTv1/7CjXpn8IZk+heSoWc
         +3bg==
X-Gm-Message-State: APjAAAXdhMPnv85pU54sx2TKGiL7fW9Cz/UQLyuMuYa8sR46GCCYRzBA
        4IX9oP52mdeWKw2iMKp/yog=
X-Google-Smtp-Source: APXvYqwYi75bxOchVq/AbZfBFqtwipHe5PVz4hvt/BNcZY2FMUEtOzrXal/WIiCd9vjTbr0bWmit6g==
X-Received: by 2002:a1c:b455:: with SMTP id d82mr4338823wmf.153.1553282739280;
        Fri, 22 Mar 2019 12:25:39 -0700 (PDT)
Received: from debian64.daheim (p5B0D7465.dip0.t-ipconnect.de. [91.13.116.101])
        by smtp.gmail.com with ESMTPSA id v1sm9576373wrt.88.2019.03.22.12.25.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Mar 2019 12:25:38 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1h7PnO-0000h6-0g; Fri, 22 Mar 2019 20:25:38 +0100
From:   Christian Lamparter <chunkeey@gmail.com>
To:     Tomislav =?utf-8?B?UG/FvmVnYQ==?= <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org, openwrt-devel@lists.openwrt.org,
        kalle@codeaurora.org
Subject: Re: [PATCH] ath10k: reset chip after supported check
Date:   Fri, 22 Mar 2019 20:25:37 +0100
Message-ID: <3337086.qEUs9xMCTV@debian64>
In-Reply-To: <1553281120-22139-1-git-send-email-pozega.tomislav@gmail.com>
References: <1553281120-22139-1-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Friday, March 22, 2019 7:58:40 PM CET Tomislav Po=C5=BEega wrote:
> When chip reset is done before the chip is checked if supported
> there will be crash. Previous behaviour caused bootloops on
> Archer C7 v1 units, this patch allows clean device boot without
> excluding ath10k driver.
>=20
You need

=46ixes: 1a7fecb766c8 ("ath10k: reset chip before reading chip_id in probe")

too
> Signed-off-by: Tomislav Po=C5=BEega <pozega.tomislav@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/pci.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless=
/ath/ath10k/pci.c
> index e24403c..ec681da 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -3619,12 +3619,6 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
>  		goto err_deinit_irq;
>  	}
> =20
> -	ret =3D ath10k_pci_chip_reset(ar);
> -	if (ret) {
> -		ath10k_err(ar, "failed to reset chip: %d\n", ret);
> -		goto err_free_irq;
> -	}
> -
>  	bus_params.dev_type =3D ATH10K_DEV_TYPE_LL;
>  	bus_params.link_can_suspend =3D true;
>  	bus_params.chip_id =3D ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
> @@ -3639,6 +3633,12 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
>  		goto err_free_irq;
>  	}
> =20
> +	ret =3D ath10k_pci_chip_reset(ar);
> +	if (ret) {
> +		ath10k_err(ar, "failed to reset chip: %d\n", ret);
> +		goto err_free_irq;
> +	}
> +
>  	ret =3D ath10k_core_register(ar, &bus_params);
>  	if (ret) {
>  		ath10k_err(ar, "failed to register driver core: %d\n", ret);
>=20




