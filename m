Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC05C10F05
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 07:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EDE721871
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 07:08:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RBKnLfOa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfCTHIx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 03:08:53 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:52446 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727246AbfCTHIw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 03:08:52 -0400
Received: by mail-it1-f194.google.com with SMTP id g17so30002384ita.2;
        Wed, 20 Mar 2019 00:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pT/tFO87Fgg1H9sne6N3fiyT9w1xy0s9QxvBKnrOsNg=;
        b=RBKnLfOaoYZH6YSRrbOOjqP5okECkvx5w3jxFNXbU+A3iqb7XzbkXbtAEh6dI+eJeM
         A92Xat6XcYslJigA3vgnud583kbULVb4jviFiexBmtmGSOH0udiT6rc7GhVuYRgLjWcC
         iVbdA/GGfPJajnlNj1M853xZohkaNyYvxt8hQjdITu4L48ePXT0G3gUIqC3dBrfKVC/r
         wwAHUAMlDEs9SGSnRaBLoInQ3Wq/J4ziupbnl6ZdHiskzDq0Vs7v8sEFKL7bxQKY7/d+
         TgLRz7KWRURpMDboNT6MOobRGubn3HD7LQUYpw8FAl1wPIkjWjSz8Gai39LExbkfDJet
         dcPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pT/tFO87Fgg1H9sne6N3fiyT9w1xy0s9QxvBKnrOsNg=;
        b=YkZzuPKZX17GsKVdIV333Hc1MYcDzOLSMTtXyFfxVQ9azugN9l4p4ub6+WKaQ6fDvA
         nVx+zPtyRi0t07+PCZIcgDUr35do6QYVkS9I7X6TYKe2WJPcVhD7+0puPBHqAhOruCcV
         d48t9qz/OzOF8GpMw2hskJGakhyV1Pe13DtwQSjUpUbp2lJ3wOu0O5NFirUBRwVTmcvz
         DRZGhUSk9nn/IliiMveghBtdY4/cc/ZzULsTpvEv0OLxb4IrHUAFN1plrDxnavAXZl2y
         qf8XAE+9XcalBmftrGy4S6lD52HFecQ/WfTB0yMQHtSe2lWI9fhi9lr0SDZzScJBD8xe
         gUUw==
X-Gm-Message-State: APjAAAUW3gWlWG0q+Y9Ccf6l+di2YL8/J86ZZT/1jgtlVKjq5DxgMGKi
        QIq1EFw+VkZ+090lIwYUN0RQR/ZNxhAndXlteTI/cu4G
X-Google-Smtp-Source: APXvYqwLTODjbF1xk7xH3NiAxu0gsXWKnF/C0FMAZ2mRagTLLlseCUjnu5dVkyVrMnQ7owXByFvRGVeXkH0t1PtWJVE=
X-Received: by 2002:a05:660c:a54:: with SMTP id j20mr4241072itl.158.1553065731632;
 Wed, 20 Mar 2019 00:08:51 -0700 (PDT)
MIME-Version: 1.0
References: <1553012645-28989-1-git-send-email-chongguiguzi@gmail.com>
In-Reply-To: <1553012645-28989-1-git-send-email-chongguiguzi@gmail.com>
From:   Menion <menion@gmail.com>
Date:   Wed, 20 Mar 2019 08:08:40 +0100
Message-ID: <CAJVZm6dUfAB8Q5CDCpiZhwAJcRiL=N8d3Aa-wxQx3_2ybzZROg@mail.gmail.com>
Subject: Re: [PATCH] net:mwl8k:move spin_lock_bh to spin_lock in tasklet
To:     Jeff Xie <chongguiguzi@gmail.com>
Cc:     buytenh@wantstofly.org, kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Is it possible that this solves this long standing issue? :
https://www.spinics.net/lists/linux-wireless/msg151171.html
Bye

Il giorno mar 19 mar 2019 alle ore 17:25 Jeff Xie
<chongguiguzi@gmail.com> ha scritto:
>
> It is unnecessary to call spin_lock_bh in a tasklet.
>
> Signed-off-by: Jeff Xie <chongguiguzi@gmail.com>
> ---
>  drivers/net/wireless/marvell/mwl8k.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
> index 8e4e9b6..21a86cc 100644
> --- a/drivers/net/wireless/marvell/mwl8k.c
> +++ b/drivers/net/wireless/marvell/mwl8k.c
> @@ -4631,7 +4631,7 @@ static void mwl8k_tx_poll(unsigned long data)
>
>         limit = 32;
>
> -       spin_lock_bh(&priv->tx_lock);
> +       spin_lock(&priv->tx_lock);
>
>         for (i = 0; i < mwl8k_tx_queues(priv); i++)
>                 limit -= mwl8k_txq_reclaim(hw, i, limit, 0);
> @@ -4641,7 +4641,7 @@ static void mwl8k_tx_poll(unsigned long data)
>                 priv->tx_wait = NULL;
>         }
>
> -       spin_unlock_bh(&priv->tx_lock);
> +       spin_unlock(&priv->tx_lock);
>
>         if (limit) {
>                 writel(~MWL8K_A2H_INT_TX_DONE,
> --
> 2.7.4
>
