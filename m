Return-Path: <SRS0=h78J=OR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA1A8C04EB8
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Dec 2018 08:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81BFF2082D
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Dec 2018 08:35:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81BFF2082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbeLHIfS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 8 Dec 2018 03:35:18 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:41766 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbeLHIfS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Dec 2018 03:35:18 -0500
Received: by mail-io1-f68.google.com with SMTP id s22so5159709ioc.8
        for <linux-wireless@vger.kernel.org>; Sat, 08 Dec 2018 00:35:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zgkx1tzDkNidKpEGYWMJgv2m9sEQLotwySyIQzH6C/w=;
        b=T+bbnQYe1rmDqAj0zC3T3cdyARUTaDhOQO9qdRlrCijXODC7HCB07Tbhn7DoTpdIhZ
         wDzOggsvslwJennEaOCGbsvl1fCcpoPo9jrj+EPP2Wr0AaE6jz/W779HA3R2kzrZfBV1
         3cEdAGxPbKOWC8GeXeHUw4qb7RRI/GctcdryxKcT/uFFmuKzkVStiKf0cj+UOMUFhAAg
         2GuaihzHFJ8Y0C5FmKoSzV20OUxxZsDHVaRI1ZWrtkYXgtwF2X3COWDO/NFWOqiMHode
         YDon0kWE3uzpmA25IrArO0p8zdLBsSL+uxsvgv9B+q9qwgyH9FeO7zM1X/g7XMoOrM7D
         oDUg==
X-Gm-Message-State: AA+aEWaL6gKsNG39lylQaPSesgOkxmRv1X9PZPxlq53zr6HwSgtRiFDR
        RHOyYpPQmmT3UwR98A+cTvy+2IzgQ4q23kMWcn8G6vRfFLg=
X-Google-Smtp-Source: AFSGD/WYuH4B9R6RBDUefQ75oqojADTUVfTTW+n+CfDzvj3qwKjKo3ySXq1+uW9gd9mhBp5FwrgS6DfN72ufo+gDpTM=
X-Received: by 2002:a5d:9813:: with SMTP id a19mr3790818iol.181.1544258117589;
 Sat, 08 Dec 2018 00:35:17 -0800 (PST)
MIME-Version: 1.0
References: <1544189231-3676-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1544189231-3676-1-git-send-email-sgruszka@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sat, 8 Dec 2018 09:35:06 +0100
Message-ID: <CAJ0CqmVdNB8-A49mhRrRXdJ4c72BTKt=BWnER0ENP9D1iG-bhg@mail.gmail.com>
Subject: Re: [PATCH 1/5] mt76x02: do not set protection on set_rts_threshold callback
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Dec 7, 2018 at 2:27 PM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> Use set_rts_threshold calback to enable/disable threshold only for
> legacy traffic.
>
> Protection for HT and VHT traffic is defined by HT operation element
> and it's provided by remote AP or by hostapd.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c  | 16 +---------------
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.h  |  2 +-
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.c |  2 +-
>  3 files changed, 3 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> index c08bf371e527..9693d6140b3d 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> @@ -715,7 +715,7 @@ void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
>  }
>  EXPORT_SYMBOL_GPL(mt76x02_tx_complete_skb);
>

[...]

> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> index 3a70e5bf7d42..e7ee2cc76edf 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> @@ -463,7 +463,7 @@ int mt76x02_set_rts_threshold(struct ieee80211_hw *hw, u32 val)
>                 return -EINVAL;
>
>         mutex_lock(&dev->mutex);
> -       mt76x02_mac_set_tx_protection(dev, val);
> +       mt76x02_mac_set_rts_thresh(dev, val);
>         mutex_unlock(&dev->mutex);

I think this patch will not apply since I have recently fixed an
uninitialized mutex access setting rts threshold
1770f0fa978e ("mt76: fix uninitialized mutex access setting rts
threshold"). That patch is in Kalle's pending branch
now. You should probably respin on top of it.

Regards,
Lorenzo

>
>         return 0;
> --
> 1.9.3
>
