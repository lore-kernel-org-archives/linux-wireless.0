Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A5DC282CE
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 13:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05B852075B
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 13:38:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z/p6YceY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfBKNis (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 08:38:48 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:36125 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbfBKNis (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 08:38:48 -0500
Received: by mail-it1-f194.google.com with SMTP id c9so26243159itj.1;
        Mon, 11 Feb 2019 05:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WhKlrGZjmlCl3ThGYqVEW35NyMfXaOR7ZnTpApxy1tk=;
        b=Z/p6YceYGGN8ISljGoHxMjZZauajd2nhm4Isaf74p0S9MKzaCG5vaxKsh6HZjZ3zEv
         i8GEJNGGfBnbRO0w3gDoflSqxe6EqZ6DYO2IE6Ee05T83q4Q19dgiQtjEDYf6WmU+a/e
         LoLxP4gzxzIqYn4KmombQxV/6x1hOlVNvk+XmBPxL5utnCCFLp6C4noDnrY0RnDH8uyR
         EGAewcwZo8s/s2FQoMI4HC5ats5GtSDVL9dmsvFBk2NuZE6Jbth8mQrYTRY/41Snpne1
         5dLRnQC4r7JpExn7097DDmL8MqrZCMV76Dg+mHCm4MJFSvepqa6sLAhw49Jq7w5755Er
         oqUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WhKlrGZjmlCl3ThGYqVEW35NyMfXaOR7ZnTpApxy1tk=;
        b=f37tZIWd81J4x2l65ZuAXG3burQf8ylcTnzQuHb7dGk5NNS7BhjDR03MEYqGkHjpnl
         a4b2/fa5wMKD+GUl1Ca18MxU9+/PF2YJxYTO08f79YflGxS1MOfDQ5qWktcrurRlnud4
         EeSSFkXizDnyjR2TIfxygz8ibTObcxh9B4tkKO3U+UJLhohz7IEwZ+jhQCk2NBL5GJ+t
         EYkSXTdUuhIxsX4iGk9CH6Dl3o1PspxwUzpUoWj0NdA51TZ0a0gFxnDB4DHFxsDUH7yo
         EunYPsCzL6FPRaBZfdU3B1s9J81kWlh8unRIc+bm9aazNygMpS8mETmStEohWLhPP0g9
         h7pg==
X-Gm-Message-State: AHQUAubFswrg43c9+2bxGQggir1xZTXKLqQy2O2NJ+90WJQE1z/ANLVw
        cTKpwi64qRTYJbma4vBgAzvA+vLT4ZkEKIS+6a8=
X-Google-Smtp-Source: AHgI3IbqZFoUOKTPAxht+wCBAwonXVtzdFPmdXUR46R3TGzFdwnR1nu9QF5SWzmX+IIC1HdEkaLACMuFCjS+Y6f4Rco=
X-Received: by 2002:a5e:de06:: with SMTP id e6mr6321710iok.4.1549892327420;
 Mon, 11 Feb 2019 05:38:47 -0800 (PST)
MIME-Version: 1.0
References: <20190210194749.18135-1-lkundrak@v3.sk>
In-Reply-To: <20190210194749.18135-1-lkundrak@v3.sk>
From:   Steve deRosier <derosier@gmail.com>
Date:   Mon, 11 Feb 2019 05:38:10 -0800
Message-ID: <CALLGbR+MiHDfgFxu=RZcr2GhYcyG4Jaq5m8O3VHPiTQCLUKGEA@mail.gmail.com>
Subject: Re: [PATCH] libertas_tf: don't set URB_ZERO_PACKET on IN USB transfer
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Feb 10, 2019 at 11:48 AM Lubomir Rintel <lkundrak@v3.sk> wrote:
>
> It doesn't make sense and the USB core warns on each submit of such
> URB, easily flooding the message buffer with tracebacks.
>
> Analogous issue was fixed in regular libertas driver in commit 6528d8804780
> ("libertas: don't set URB_ZERO_PACKET on IN USB transfer").
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> ---
>  drivers/net/wireless/marvell/libertas_tf/if_usb.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
> index 789337ea676a..6ede6168bd85 100644
> --- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
> +++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
> @@ -433,8 +433,6 @@ static int __if_usb_submit_rx_urb(struct if_usb_card *cardp,
>                           skb_tail_pointer(skb),
>                           MRVDRV_ETH_RX_PACKET_BUFFER_SIZE, callbackfn, cardp);
>
> -       cardp->rx_urb->transfer_flags |= URB_ZERO_PACKET;
> -
>         lbtf_deb_usb2(&cardp->udev->dev, "Pointer for rx_urb %p\n",
>                 cardp->rx_urb);
>         ret = usb_submit_urb(cardp->rx_urb, GFP_ATOMIC);
> --
> 2.20.1
>

Reviewed-by: Steve deRosier <derosier@cal-sierra.com>
