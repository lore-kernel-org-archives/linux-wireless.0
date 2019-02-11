Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5807C282CE
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 13:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B69C121B24
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 13:39:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EfAztYj1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbfBKNjf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 08:39:35 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:52722 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbfBKNje (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 08:39:34 -0500
Received: by mail-it1-f196.google.com with SMTP id r11so20913375itc.2;
        Mon, 11 Feb 2019 05:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XwfpBCZF5NOsTvb05M7RC8PKzgolWriR9Dd/nmp5qug=;
        b=EfAztYj1W7tIlHu13Auz9TG5r9/LbqtXTQuiGNqqk83n4TEkTnjMQFh7csbF77wiNo
         BxNYXod7KIn7o20J1l1k6HCGy+iEGMe5NyZwd25t8krgCRVEskvPIsqiQui5D2XZnE+P
         Kq7V3xXv7lEXkd0rsarzX/AYdIH2rzDQan+CM00gH6Fyy2I5NY7lzE8o2dYLcu2UgZnH
         diJwa0ALGMY1HSJK8eqsNDG0xtHf3n+j+ykuTwf23MYi5Ekky/TQ0aFA/OSMeJWW4geO
         qGDi0iEj8hp38UuS8jXfDpEiJfKyOEs1xoCtmF6/MvxNCLvD0Tl6Fdj0UidnjXG+SaiC
         d41g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XwfpBCZF5NOsTvb05M7RC8PKzgolWriR9Dd/nmp5qug=;
        b=UWyFHQaI43xXz0aHRD/DJ/ZgZPzyORLCYzMwMiw5LqO0ksKAQTl2nbSzWNlcl8Ff59
         eBWk+xqQlX9AUnR1UK39PizSBUWKGq3ccMwZ5yX9DW6w473DIFgR8XKqcWEDVs2gF5AS
         yw3uoutIA9YCoJWeV9XmhxErRYYYjlbeChK+TQxHkJ2ghP55e8cdAZoqP08BZufM78Zq
         9t95Oq+XszL15LXIa+EswHnU3uQCncU5E863Q8N2+2u91pMMQOuEGdbl6WMaC0Ssx0Iz
         7XJn89ohlq19OBv7I9/LuUBz6ol286Szglq9Z/zt8ogJz9tSMWSjqP3qfbxflPjdQE+8
         HDIA==
X-Gm-Message-State: AHQUAubkWFzaixhPrQo7WmW78DgcqL5dNBMdujWzunRUa4AC2mq2+RFH
        6vpuEECTrEvFJNgvCaB3tOX7kvzMDjaDkMfKE04jOmCB
X-Google-Smtp-Source: AHgI3IbipUVBORl4rft8ALP4aB96waphzZC1cvVJzd5EkGzTFNPT4GQ4pKI3dHaUPXcyW9FBRKp8UUMA1rofoXzvqo8=
X-Received: by 2002:a02:15da:: with SMTP id 87mr822048jaq.2.1549892373982;
 Mon, 11 Feb 2019 05:39:33 -0800 (PST)
MIME-Version: 1.0
References: <20190210194811.18345-1-lkundrak@v3.sk>
In-Reply-To: <20190210194811.18345-1-lkundrak@v3.sk>
From:   Steve deRosier <derosier@gmail.com>
Date:   Mon, 11 Feb 2019 05:38:57 -0800
Message-ID: <CALLGbR+YCrY3SMC_1qgBpO2AKmRXXU4WrkBR-gmXqrCpi5L6qA@mail.gmail.com>
Subject: Re: [PATCH] libertas_tf: move the banner to a more appropriate place
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Feb 10, 2019 at 11:48 AM Lubomir Rintel <lkundrak@v3.sk> wrote:
>
> Also, turn it to a dev_info() to make checkpatch.pl happy.
>
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> ---
>  drivers/net/wireless/marvell/libertas_tf/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/marvell/libertas_tf/main.c b/drivers/net/wireless/marvell/libertas_tf/main.c
> index 1d45da187b9b..c71ad87cdc44 100644
> --- a/drivers/net/wireless/marvell/libertas_tf/main.c
> +++ b/drivers/net/wireless/marvell/libertas_tf/main.c
> @@ -318,7 +318,6 @@ static int lbtf_op_start(struct ieee80211_hw *hw)
>                 goto err_prog_firmware;
>         }
>
> -       printk(KERN_INFO "libertastf: Marvell WLAN 802.11 thinfirm adapter\n");
>         lbtf_deb_leave(LBTF_DEB_MACOPS);
>         return 0;
>
> @@ -649,6 +648,7 @@ struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev)
>         if (ieee80211_register_hw(hw))
>                 goto err_init_adapter;
>
> +       dev_info(dmdev, "libertastf: Marvell WLAN 802.11 thinfirm adapter\n");
>         goto done;
>
>  err_init_adapter:
> --
> 2.20.1
>

Reviewed-by: Steve deRosier <derosier@cal-sierra.com>
