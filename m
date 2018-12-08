Return-Path: <SRS0=h78J=OR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9515C65BAF
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Dec 2018 09:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E12020892
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Dec 2018 09:14:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E12020892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbeLHJND (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 8 Dec 2018 04:13:03 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:33093 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbeLHJNC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Dec 2018 04:13:02 -0500
Received: by mail-io1-f66.google.com with SMTP id t24so5251052ioi.0
        for <linux-wireless@vger.kernel.org>; Sat, 08 Dec 2018 01:13:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z2/pMPFhG6qc3EK4v+6w3XwarbJ11IQGv9rl8fDWu0c=;
        b=Clxl1x8SVH9BGea1NSvPao/YjLJckyiQYF2woVvrJGTr1OZ5chTJ4ZDfsY1R/fN4Jv
         N+Eqm+fYGXZ7F9q3rUYYyufXlXdK5ugZdht00ONhSISmO+qKcxKtZSlr4LdmoBuV/6Of
         lE7awBj6nX82/rw64NrFqS+m7FeAbrYeRcod2oqoYdX/SgctLSWsPnSHa66otynQMsSH
         ubXUQyXAm383NfhvI+j3EYeeTtza1/NxAPbJ53KNMS6s4XZA18hVRSKi3W7BMcwWyGSX
         A4wJlAb2fpNMmt8KAogxMVJP4bfj8rjuLY8Z0gVx++wSxy9ERsvFHOLsCFEQPkTKl0w8
         TgZw==
X-Gm-Message-State: AA+aEWbCKJU3xKTi02PbTtPOqPvn68X3jdtHrWfd/CA+9lUj8Ww1VXEC
        INoZqVa3lwLkeloyQQYWo4YRnvbH20Yd0ylk/92Qgryy66Y=
X-Google-Smtp-Source: AFSGD/WZxxMDtqeRzmGDIfuq3SLzpFGALMSVxjkxqxofuhSo9vxPdC68CmSeJvruS0THjFtNLyCssAQFWMZmiQdFzIs=
X-Received: by 2002:a6b:490f:: with SMTP id u15mr4101644iob.297.1544260381911;
 Sat, 08 Dec 2018 01:13:01 -0800 (PST)
MIME-Version: 1.0
References: <1544189231-3676-1-git-send-email-sgruszka@redhat.com> <1544189231-3676-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1544189231-3676-2-git-send-email-sgruszka@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sat, 8 Dec 2018 10:12:51 +0100
Message-ID: <CAJ0CqmVXybKDdZJPwqvO60VOg_h2ajbmJ1G9wnQgmSu6yKJ+CA@mail.gmail.com>
Subject: Re: [PATCH 2/5] mt76x02: fixup MT_PROT_RATE_* defines
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> On new mt76 chips, phy mode is configured by last 3 bits
> of rate value. Hence OFDM bit is marked by 0x2000
> instead of 0x4000.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x02_regs.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
> index f7de77d09d28..d1ac847adce5 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
> @@ -440,9 +440,9 @@
>  #define MT_PROT_TXOP_ALLOW_GF40                BIT(25)
>  #define MT_PROT_RTS_THR_EN             BIT(26)
>  #define MT_PROT_RATE_CCK_11            0x0003
> -#define MT_PROT_RATE_OFDM_6            0x4000
> -#define MT_PROT_RATE_OFDM_24           0x4004
> -#define MT_PROT_RATE_DUP_OFDM_24       0x4084
> +#define MT_PROT_RATE_OFDM_6            0x2000
> +#define MT_PROT_RATE_OFDM_24           0x2004
> +#define MT_PROT_RATE_DUP_OFDM_24       0x2084
>  #define MT_PROT_TXOP_ALLOW_ALL         GENMASK(25, 20)
>  #define MT_PROT_TXOP_ALLOW_BW20                (MT_PROT_TXOP_ALLOW_ALL &       \
>                                          ~MT_PROT_TXOP_ALLOW_MM40 &     \
> --
> 1.9.3
>

Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
