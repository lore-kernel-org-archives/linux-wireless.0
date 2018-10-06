Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B0AC64EB8
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 08:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 429AB20875
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 08:25:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 429AB20875
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727596AbeJFP2U (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 11:28:20 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:36730 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbeJFP2T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 11:28:19 -0400
Received: by mail-it1-f195.google.com with SMTP id c85-v6so5943193itd.1
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2018 01:25:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2greCOtddFNcoRfLB4Yk23H2iKVDQcvhV9CVi51N3VI=;
        b=SOubCUS6co1+MIHX1gURprV5zxfGoq9EYVYp77aRDy5JCHpA/flT5+KTYSEdcr5E/w
         g5RLuB0r5m9S2eBZ0UQX1npMrqQfMXvtAc2+WCq8h2d9t5w3rzGwp2Bplps0BfsB6PwN
         tQgB6XPqPCATFLf83qRv+xGWoBPPVDyM/SS8W4CXM+nrUCG42OUJ9+uE7zD1RBSV0X43
         C6dXYxGQ0KxF1FbU50hTQPoHsQGUWPYEdg089pkNVs9mCTCXLtjivElHC4Oc6cLgdm5R
         prl1G8creBose9+pnHBYUU/61va0tFG73e24Qi/pXhQnEnoiVL785Er9Z0y/GDL4C9G+
         efQQ==
X-Gm-Message-State: ABuFfohGWXF9CmQGW+DS53/HKgLsTedRqc8Zz2FVtXbbvLvfm4CDBPiy
        WHHnKKXi8eP7hydex4UcalPeCW61th867EBdQk39yw==
X-Google-Smtp-Source: ACcGV63H+3JgXT89Raags1IqUG9Hh3dYNK4Iuca0BJns2tkNkuk9C3QfKJ7s21NcCfgjpunGF5KwZKE55PBDU0Pywro=
X-Received: by 2002:a24:b30e:: with SMTP id e14-v6mr8137736itf.82.1538814354942;
 Sat, 06 Oct 2018 01:25:54 -0700 (PDT)
MIME-Version: 1.0
References: <1538647495-15213-1-git-send-email-sgruszka@redhat.com> <1538647495-15213-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1538647495-15213-3-git-send-email-sgruszka@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sat, 6 Oct 2018 10:25:43 +0200
Message-ID: <CAJ0CqmXRQ5pgx5v-DGjWsvgKZdQEncxSuUexKCdduiRU+r+A3Q@mail.gmail.com>
Subject: Re: [PATCH 2/5] mt76x0: correct RF access via RF_CSR regiser.
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> PCIe version don't use MCU for RF regsisters access. We need
> to correct RF CSR method to support up to 127 RF registers.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x0/phy.c   | 6 ++----
>  drivers/net/wireless/mediatek/mt76/mt76x02_regs.h | 4 ++--
>  2 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> index cbbfd5193d9c..da4569f00794 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> @@ -37,7 +37,7 @@
>         bank = MT_RF_BANK(offset);
>         reg = MT_RF_REG(offset);
>
> -       if (WARN_ON_ONCE(reg > 64) || WARN_ON_ONCE(bank) > 8)
> +       if (WARN_ON_ONCE(reg > 127) || WARN_ON_ONCE(bank) > 8)

I guess there is a typo here, it should be:

if (WARN_ON_ONCE(reg > 127) || WARN_ON_ONCE(bank > 8))

>                 return -EINVAL;
>
>         mutex_lock(&dev->phy_mutex);
> @@ -76,7 +76,7 @@ static int mt76x0_rf_csr_rr(struct mt76x02_dev *dev, u32 offset)
>         bank = MT_RF_BANK(offset);
>         reg = MT_RF_REG(offset);
>
> -       if (WARN_ON_ONCE(reg > 64) || WARN_ON_ONCE(bank) > 8)
> +       if (WARN_ON_ONCE(reg > 127) || WARN_ON_ONCE(bank) > 8)

same as above

Regards,
Lorenzo

>                 return -EINVAL;
>
>         mutex_lock(&dev->phy_mutex);
> @@ -119,7 +119,6 @@ static int mt76x0_rf_csr_rr(struct mt76x02_dev *dev, u32 offset)
>
>                 return mt76_wr_rp(dev, MT_MCU_MEMMAP_RF, &pair, 1);
>         } else {
> -               WARN_ON_ONCE(1);
>                 return mt76x0_rf_csr_wr(dev, offset, val);
>         }
>  }
> @@ -138,7 +137,6 @@ static int mt76x0_rf_csr_rr(struct mt76x02_dev *dev, u32 offset)
>                 ret = mt76_rd_rp(dev, MT_MCU_MEMMAP_RF, &pair, 1);
>                 val = pair.value;
>         } else {
> -               WARN_ON_ONCE(1);
>                 ret = val = mt76x0_rf_csr_rr(dev, offset);
>         }
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
> index 24d1e6d747dd..f7de77d09d28 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
> @@ -205,8 +205,8 @@
>  #define MT_TXQ_STA                     0x0434
>  #define        MT_RF_CSR_CFG                   0x0500
>  #define MT_RF_CSR_CFG_DATA             GENMASK(7, 0)
> -#define MT_RF_CSR_CFG_REG_ID           GENMASK(13, 8)
> -#define MT_RF_CSR_CFG_REG_BANK         GENMASK(17, 14)
> +#define MT_RF_CSR_CFG_REG_ID           GENMASK(14, 8)
> +#define MT_RF_CSR_CFG_REG_BANK         GENMASK(17, 15)
>  #define MT_RF_CSR_CFG_WR               BIT(30)
>  #define MT_RF_CSR_CFG_KICK             BIT(31)
>
> --
> 1.9.3
>
