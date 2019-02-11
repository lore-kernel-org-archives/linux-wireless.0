Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB22C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 13:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB17C2184E
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 13:24:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tVk4ZTyX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfBKNXz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 08:23:55 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:51563 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727383AbfBKNXz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 08:23:55 -0500
Received: by mail-it1-f195.google.com with SMTP id y184so19886016itc.1;
        Mon, 11 Feb 2019 05:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5uLOz++MITu17HAQVYwsjQDpj8/P8DP456xdXTRIqPo=;
        b=tVk4ZTyXrLA4/9MOzRCA7QEFgRgdi29Hp7cze2Moul8aj9nBaNKYkRlZtW4JD/lu07
         Q4BZsdVl1TIMtCs5HsWWPoaRGL/DK//OrQlDOeKKN91GAiELRM5tdYU5WoqrLUvniB9C
         Fz8qN8QCZaztMQZQkJQsR1Q5rala7PK6sX0O97aITLWUynZ4qpNQ3LD+5AZOsRLCEXTd
         F5Wk8q2mBHKdxSZqJbRYXLScpG+6n61tXKoQ7KTJC4Olhr3LVHBulloldJBtafF8ECJb
         b8cUEhYwrEEOMS3J9RaV5BeyzPgtnV5mpSk523kDg3jupkNXOJid+sJdLGAfbpJ39RGt
         +eSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5uLOz++MITu17HAQVYwsjQDpj8/P8DP456xdXTRIqPo=;
        b=Un0Cwq7iOPYd43ovjOYkfzKiyQ/o3U5UkDWYverB55rYEX75kP5VZd7OSC4r0fH9H0
         Lb+r/XYrrsXEcw9Mi4WOXrSEeMvFHmHUNKCnoOyQ/47OEDTkRF5rv/6WOij0h0F3crJL
         kvclwH2m3Yh9Hks4tRHpB43ncNHJB6W2YsaKOpH22GYhmu/x/KBOgSzCuxe/SBaLf2vO
         sy5rP2/qpSt1Koj09PrYkt3QneQcvINlu2nJFOhcCzl0RETj0p4IQh2+UczRRGk1/v/w
         RG03D+FTjPtmxfS2bDktuOLRHdADuKpYd4pnjNs5s1+dydDtNfeyzeslD+mVy4ROe7oz
         CO2Q==
X-Gm-Message-State: AHQUAuZlu31EebiTUMUwZUu5OLS7HmmCVp3EKgtPjpQgMGeMvT3wOcug
        bElLtBwSz72/ydWytgWwPq3+ODoYosLxBv4CzXKSpg==
X-Google-Smtp-Source: AHgI3IZUsuTKU8CY8hyyMZVMwclBomsz9/WBXBL7Tp7g7U16+fEv64LuA0h33JbMWx7ijf7zGwvL2ja/OKHr1+LfRwo=
X-Received: by 2002:a5e:de06:: with SMTP id e6mr6285983iok.4.1549891433974;
 Mon, 11 Feb 2019 05:23:53 -0800 (PST)
MIME-Version: 1.0
References: <20190210194735.17939-1-lkundrak@v3.sk>
In-Reply-To: <20190210194735.17939-1-lkundrak@v3.sk>
From:   Steve deRosier <derosier@gmail.com>
Date:   Mon, 11 Feb 2019 05:23:17 -0800
Message-ID: <CALLGbRLZGJGjJuYsno-y8=5UWZ9xjwvgTeM4hZRGNXS-Y+WF9Q@mail.gmail.com>
Subject: Re: [PATCH] libertas_tf: lower the debug level of command trace
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

On Sun, Feb 10, 2019 at 11:47 AM Lubomir Rintel <lkundrak@v3.sk> wrote:
>
> Logging each and every command response is way too much for INFO level.
> Silence this, unless CONFIG_LIBERTAS_THINFIRM_DEBUG has been enabled.
>
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> ---
>  drivers/net/wireless/marvell/libertas_tf/cmd.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/libertas_tf/cmd.c b/drivers/net/wireless/marvell/libertas_tf/cmd.c
> index 909ac3685010..64b147dd2432 100644
> --- a/drivers/net/wireless/marvell/libertas_tf/cmd.c
> +++ b/drivers/net/wireless/marvell/libertas_tf/cmd.c
> @@ -737,10 +737,9 @@ int lbtf_process_rx_command(struct lbtf_private *priv)
>         respcmd = le16_to_cpu(resp->command);
>         result = le16_to_cpu(resp->result);
>
> -       if (net_ratelimit())
> -               pr_info("libertastf: cmd response 0x%04x, seq %d, size %d\n",
> -                       respcmd, le16_to_cpu(resp->seqnum),
> -                       le16_to_cpu(resp->size));
> +       lbtf_deb_cmd("libertastf: cmd response 0x%04x, seq %d, size %d\n",
> +                    respcmd, le16_to_cpu(resp->seqnum),
> +                    le16_to_cpu(resp->size));
>
>         if (resp->seqnum != priv->cur_cmd->cmdbuf->seqnum) {
>                 spin_unlock_irqrestore(&priv->driver_lock, flags);
> --
> 2.20.1
>

Reviewed-by: Steve deRosier <derosier@cal-sierra.com>
