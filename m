Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3222C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 20:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7358C2086E
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 20:09:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s5VafT97"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7358C2086E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbeJKDc7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 23:32:59 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40353 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbeJKDc7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 23:32:59 -0400
Received: by mail-ot1-f68.google.com with SMTP id w67so6644896ota.7
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2018 13:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Igo+VtLwWJo66k/rFQAmIia2D8Ewn1fb0behAxghebQ=;
        b=s5VafT97WrTksz5rulswTkJNa7vTjviUXETjBsHu/ZZHLLLyGQIUcZT/fV1qfRitps
         sGIY6/r1jVbx8Z57rJ3aLqQJ6IifQjrqRYQ3mU6Qt4NOvKHdOdTZEu/yR2fYsMlwB9Jc
         WKCdcSqx8FaKcsCRhECV3vGl+190Ed9cuZks8GcQM+rru38JXiQllLl2m5CnutUnJlGi
         AgwOg0lw2pAJSGCMgEcsHcInzEUY46Xn0bnpX39Az3Jn9LkDPfxiCPt3MWDsB6hLyxI8
         AdQd/Xjkp4P5eonEvYcl+Xv3GAeuHvzh5cxfkRsYnvRPxITxcb4nHkBx+BtThbyszIXU
         4Rpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=Igo+VtLwWJo66k/rFQAmIia2D8Ewn1fb0behAxghebQ=;
        b=Y/yeDmJj6ymus2L1yb9mmFC6cIkvTQCpl43CuUcJLO531vwe27m5t4ev8m+QhyA6F1
         kfG+HRsVIuysh38oJtYKJkogqhRXx14XmBr9dqGcsOSj+dSlhEGpdlYzlWMCiACcFgGB
         GoASEu8lfs0WMifK6zQkfW8yuejvoowaneRpE2LqERTKntzv7OjS8wGzpJE3U8vSEGBN
         GpYAoDtyAq9xWg2H5iZgCTgcbSbdUzvlhNJvGGe6gRnJSWwheRiF4HhAhZ9GHymcxJky
         texq+DeeQKmj6616D+l4XKKzpQv/ie4+ZtqT33BjQQzIDycnclj65+7J6sruL3ooeYLJ
         dzkg==
X-Gm-Message-State: ABuFfoj5aotJy0hSw1Ed5yBn8bGz5FNORtf0PaGfzn4PygENHz9ApWMi
        r7mwuQcUav4cbz4fTSP085Ypik2dvAbFPFUq8dA=
X-Google-Smtp-Source: ACcGV60QnpxSADd8wUR1T6dmBuSeK8upw+dru/mikIWwrF9GA3X1Z5Vfh3+VYs2CMh8SjFYX23sBsPrBAIRNxiNuUf4=
X-Received: by 2002:a9d:2314:: with SMTP id j20mr19804488otb.296.1539202155118;
 Wed, 10 Oct 2018 13:09:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Wed, 10 Oct 2018 13:09:14
 -0700 (PDT)
In-Reply-To: <1539186380-31949-5-git-send-email-sgruszka@redhat.com>
References: <1539186380-31949-1-git-send-email-sgruszka@redhat.com> <1539186380-31949-5-git-send-email-sgruszka@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 10 Oct 2018 22:09:14 +0200
Message-ID: <CAKR_QVJfQuFee4P-cnp_7bKGmoUTTxnkCfXoovqsGxs72+gCLg@mail.gmail.com>
Subject: Re: [PATCH 4/4] rt2800: comment and simplify AGC init for RT6352
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

it's 6352 dude

On 10/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> We do not need separate lines for calculating register values.
> Also add comment that value is different than in vendor driver.
>
> Suggested-by: Daniel Golle <daniel@makrotopia.org>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index a2cdd3a5034a..7b6effaa0740 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -3986,9 +3986,12 @@ static void rt2800_config_channel(struct rt2x00_dev
> *rt2x00dev,
>  		rt2800_bbp_write(rt2x00dev, 195, 141);
>  		rt2800_bbp_write(rt2x00dev, 196, reg);
>
> -		/* AGC init */
> -		reg = rf->channel <= 14 ? 0x1c : 0x24;
> -		reg += 2 * rt2x00dev->lna_gain;
> +		/* AGC init.
> +		 * Despite the vendor driver using different values here for
> +		 * RT6362 chip, we use 0x1c for now. This may have to be changed
> +		 * once TSSI got implemented.
> +		 */
> +		reg = (rf->channel <= 14 ? 0x1c : 0x24) + 2*rt2x00dev->lna_gain;
>  		rt2800_bbp_write_with_rx_chain(rt2x00dev, 66, reg);
>
>  		rt2800_iq_calibrate(rt2x00dev, rf->channel);
> --
> 2.7.5
>
>
