Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B39DECDE4B
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 14:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DF6F2081D
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 14:58:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DF6F2081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbeKIAee (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 19:34:34 -0500
Received: from mail-it1-f173.google.com ([209.85.166.173]:35248 "EHLO
        mail-it1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbeKIAee (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 19:34:34 -0500
Received: by mail-it1-f173.google.com with SMTP id v11so2039171itj.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2018 06:58:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iLGSUOmbfctq+Yh7p03DBPn6g898SJbhRjTQo0sPR8Q=;
        b=QihN1JjjLnKEhFUFVrI26fpMkkRv0ieWB0bG7yUvK55GEt/VJrgN3ObX7gdWYbc6JQ
         Xkko9VWvePOd/xvIIz5JDHtUSW36Z3U0LqSq04RbhcuFeWid/SXy+gmF22qu70RUNXCn
         Y7+oa4EqlqnrSk6exUeF3+XogQbMNI1VHhKM1fR91pp4zB3dZiALOj70WlP8x9s6WQiN
         ANB44mIPuIv1PgJBYlkP/V58ykuSJeJFMpokFfzpAj7xqxs6mK5vRWw2hftosyQ22MqS
         n1CXJCWLHqF4ELjY1TulE3RMXzwSflN7OJhWKIwlVb8tHUGhguIzbQTRH3C8wjNWtZIf
         uRTQ==
X-Gm-Message-State: AGRZ1gKCYhs+svOBP3qRNUDJ/9X/ULrv1TS8yFCa2uz7CpgTrBZw/A63
        Kg4z/Cd9Z3yAj+hGMgsx8rrFsd8onUJeUVCe+LbY3lDx
X-Google-Smtp-Source: AJdET5cW/aHPrAw7hnL/hYihtm3lAeDnb0sXLJ7b4R1Gt7GPinJU7C7Z0RI0y+aAF7diTZOswz+hG6lPlvclAgOD/Mw=
X-Received: by 2002:a24:19c6:: with SMTP id b189-v6mr1232460itb.52.1541689120579;
 Thu, 08 Nov 2018 06:58:40 -0800 (PST)
MIME-Version: 1.0
References: <1541688430-31855-1-git-send-email-sgruszka@redhat.com> <1541688430-31855-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1541688430-31855-2-git-send-email-sgruszka@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Thu, 8 Nov 2018 15:58:29 +0100
Message-ID: <CAJ0CqmXdvqdfQNXqxBmPn_t_EA7wg2hCd87rrwC+7N_y+8bh=g@mail.gmail.com>
Subject: Re: [RFC/RFT 1/4] mt76x02: configure basic rates and fallback on STA mode
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> For STA mode configure legacy basic rates according to info
> mac80211 provides to us, as well as follback registers, which
> are setup in vendor driver under CONFIG_STA_SUPPORT .
> For LB_FBK_CFG1 register use values from vendor driver, which
> are different for mt76x0 and mt76x2 .
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> index 87ce6a51fb05..2be4b527477f 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> @@ -678,6 +678,18 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
>                 tasklet_enable(&dev->pre_tbtt_tasklet);
>         }
>
> +       if (changed & BSS_CHANGED_BASIC_RATES &&
> +           vif->type == NL80211_IFTYPE_STATION) {
> +               mt76_wr(dev, MT_LEGACY_BASIC_RATE, info->basic_rates);
> +               mt76_wr(dev, MT_VHT_HT_FBK_CFG0, 0x65432100);
> +               mt76_wr(dev, MT_VHT_HT_FBK_CFG1, 0xedcba980);
> +               mt76_wr(dev, MT_LG_FBK_CFG0, 0xedcba988);
> +               if (is_mt76x2(dev))
> +                       mt76_wr(dev, MT_LG_FBK_CFG1, 0x87872100);
> +               else
> +                       mt76_wr(dev, MT_LG_FBK_CFG1, 0x00872100);
> +       }
> +

since these values are constant, why not put them init_vals?

Regards,
Lorenzo

>         if (changed & BSS_CHANGED_BEACON_INT) {
>                 mt76_rmw_field(dev, MT_BEACON_TIME_CFG,
>                                MT_BEACON_TIME_CFG_INTVAL,
> --
> 1.9.3
>
