Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCBAC64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 07:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BF472064A
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 07:44:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="NmzjdXJQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BF472064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbeJIO74 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 10:59:56 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40771 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbeJIO74 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 10:59:56 -0400
Received: by mail-io1-f68.google.com with SMTP id w16-v6so445515iom.7
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2018 00:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=7Dh3HO+79JZ4SsgFgxdKSrjMkewSeif97sthF1sRhXE=;
        b=NmzjdXJQeDXQKj+i0fHVXHI8J1u7LHQT8l6DAI6+CVPs3b8kF55BV7OztHH6MuJ/Cd
         ag3bxFsSGqmhEMAE5V8czy3/1IIqzQE7xuXYPxtIDLhEVWMpeaRdOHdVaME8JQJaL8rm
         KCVa7AF7E1G+9qXGLXf0B0WZCVhYqqC7TJH8M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=7Dh3HO+79JZ4SsgFgxdKSrjMkewSeif97sthF1sRhXE=;
        b=hhVlAoPcLMidSI38SooDbNPiiA1yXux8S4xSfxiWqBeQXqX4tg10W+3RpQt9o05lHk
         yYLSPd140QHFBZKSM2kANf5GMYGR6FqKeqHEoAL33PEVee4+Ta6Up1+NgCPJ9bkx8yAa
         K69Ix6MzccLVl293tfx6JPIxUl6kQHaR9sDrPX1g3Ao5ur31HP1sWwdQmWZX4cwIte+X
         Xc0OR0wY+TMucIVBHI/NKBGHGnjDcraMIdJQ6JVZKTyk5nFQmXjNpyqGspMQRm50RAL3
         Rugv6FIZorRBl2Y9aH26WBZ42eWpO6XANmRwewzAs0NXWFRc6utnNjAAo4qQvZ7hfxXp
         6gAg==
X-Gm-Message-State: ABuFfoghr0gjVdKhUBw8ou847LZBXdm9I9+TImtpJ/g8lrUqlkGPf6JI
        HFf5Wqfvc00BlnKWIoIoogaFUDobV7rwTA/W8Lu4Gw==
X-Google-Smtp-Source: ACcGV61S7llcRjyt2atg8Sujq2dA4WZTY3aDqI67gr+kvhklQdgudCwsexLTkDtmxZ6YGC5wcHadbwx1mtr5bprM1wI=
X-Received: by 2002:a6b:8fcb:: with SMTP id r194-v6mr7432691iod.266.1539071058797;
 Tue, 09 Oct 2018 00:44:18 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a02:3941:0:0:0:0:0 with HTTP; Tue, 9 Oct 2018 00:43:38 -0700 (PDT)
In-Reply-To: <20181008200357.10819-1-daniel@zonque.org>
References: <20181008200357.10819-1-daniel@zonque.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 9 Oct 2018 09:43:38 +0200
Message-ID: <CAPDyKFoo-gnjUg9Khc3EPm=cvHgyR_VNW8xgjP1Tea7wjRfvSw@mail.gmail.com>
Subject: Re: [PATCH] libertas: call into generic suspend code before turning
 off power
To:     Daniel Mack <daniel@zonque.org>
Cc:     Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 8 October 2018 at 22:03, Daniel Mack <daniel@zonque.org> wrote:
> When powering down a SDIO connected card during suspend, make sure to call
> into the generic lbs_suspend() function before pulling the plug. This will
> make sure the card is successfully deregistered from the system to avoid
> communication to the card starving out.
>
> Fixes: 7444a8092906 ("libertas: fix suspend and resume for SDIO connected cards")
> Signed-off-by: Daniel Mack <daniel@zonque.org>

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

BTW, if you need this to reach 4.19 I have already queued some other
mmc fixes so I can take this as well, if it helps. I need and ack of
course.

Kind regards
Uffe

> ---
> If possible, this should go in for 4.19.
>
>  drivers/net/wireless/marvell/libertas/if_sdio.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/wireless/marvell/libertas/if_sdio.c b/drivers/net/wireless/marvell/libertas/if_sdio.c
> index 43743c26c071..39bf85d0ade0 100644
> --- a/drivers/net/wireless/marvell/libertas/if_sdio.c
> +++ b/drivers/net/wireless/marvell/libertas/if_sdio.c
> @@ -1317,6 +1317,10 @@ static int if_sdio_suspend(struct device *dev)
>         if (priv->wol_criteria == EHS_REMOVE_WAKEUP) {
>                 dev_info(dev, "Suspend without wake params -- powering down card\n");
>                 if (priv->fw_ready) {
> +                       ret = lbs_suspend(priv);
> +                       if (ret)
> +                               return ret;
> +
>                         priv->power_up_on_resume = true;
>                         if_sdio_power_off(card);
>                 }
> --
> 2.17.1
>
