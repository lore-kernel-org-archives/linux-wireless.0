Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E7BECDE4B
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 15:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5F0B2081D
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 15:02:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5F0B2081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbeKIAiA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 19:38:00 -0500
Received: from mail-io1-f42.google.com ([209.85.166.42]:44998 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbeKIAh7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 19:37:59 -0500
Received: by mail-io1-f42.google.com with SMTP id c6-v6so14795143iob.11
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2018 07:02:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4NmFVb1Wa2FtmNv0jVNt/3728SPGeyyI8ZIDNtIxhus=;
        b=G95TfrUfuj0u+tBxt0tkBdsD2sBj3qFrBGZZCa8EXYexNyXqwZL343MufL6h/Hg1Ki
         /BAMXFjUKf0wr38mxeHPWeGoQTAp+zNKZUHzv2R31h3dV5Ru7U+o5q8g1w/KtDQdPP3h
         pDdvuuMpd7ulQ6uTAIXIdK1ZfZtWrLtGOqxwnRIxb5YW5YOlIZAh7Om2k0muYn2PnmfO
         ZRFLnLXgHQzvoGXnsgYFIlxbaf4adBRVT7f3q84dJI33tEcCkjCjYSmZgK0i0RzSBs5M
         bT0wKDc/vYRYNXpk7r+or23NcN8jNiSNTAQeD00KafQAykLOc+jmG3zrrDfbXZfuH/FC
         CcgA==
X-Gm-Message-State: AGRZ1gKhsL7PnVWNxFN0KNAqdDoGRzKCpWVWZDI+brdf0S0b4CULEeUw
        rdr/w4jhvffpnM/yUKyn1the7UcYQbIgh1jmvWodBU1G
X-Google-Smtp-Source: AJdET5edHJ2DNnyp1LBRRjez7Vybie9hzADbXrimM2f+wsbeoLLbknr61xREV7b9HFyx+x2XQpw7EvixlCSOfq5xGNQ=
X-Received: by 2002:a6b:4905:: with SMTP id u5-v6mr3617763iob.181.1541689325290;
 Thu, 08 Nov 2018 07:02:05 -0800 (PST)
MIME-Version: 1.0
References: <1541688430-31855-1-git-send-email-sgruszka@redhat.com> <1541688430-31855-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1541688430-31855-3-git-send-email-sgruszka@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Thu, 8 Nov 2018 16:01:54 +0100
Message-ID: <CAJ0CqmXS6zkJf3FHb5wYyPPzvqG5OBZDfcYWSjbaJY_nhcErzA@mail.gmail.com>
Subject: Re: [RFC/RFT 2/4] mt76x02: reserve wcid 0 for global traffic
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Restore behaviour on mt76x0 before commit  1bb04bb4b838 ("mt76: move
> mt76x02_init_device in mt76x02-lib module"). This will allow to use
> wcid 1 for AP when we work in station mode. It's not clear if this
> is needed, but this is how vendor driver assign wcid's in STA mode.
> This should be harmless for mt76x2.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> index 2be4b527477f..e624397b3d8b 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> @@ -113,7 +113,11 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
>         ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
>         ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
>
> -       dev->mt76.global_wcid.idx = 255;
> +       /* Reserve WCID 0 for mcast - thanks to this APs WCID will go to
> +        * entry no. 1 like it does in the vendor driver.
> +        */
> +       dev->mt76.wcid_mask[0] |= 1;
> +       dev->mt76.global_wcid.idx = 0;
>         dev->mt76.global_wcid.hw_key_idx = -1;
>         dev->slottime = 9;
>

Does it make any difference in AP mode? What about using 0 instead of
255 for global_wcid.idx?

Regards,
Lorenzo

> --
> 1.9.3
>
