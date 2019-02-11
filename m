Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB91DC169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 14:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A368222B7
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 14:11:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EO0AJQCr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfBKOL1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 09:11:27 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:55295 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbfBKOL1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 09:11:27 -0500
Received: by mail-it1-f193.google.com with SMTP id i145so26525798ita.4;
        Mon, 11 Feb 2019 06:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yxZvn/pOD6Wixmg3HHtdl8nPkaQNZIock1gY9YkyAm4=;
        b=EO0AJQCrJxYUwarJ5K+zlqjx0YtYaC4yHni2nXLgkcA7hWtsu4au5vUt8VToo8YtJb
         8dPzuOAvM6mR1sPqWDgVDUbN7DHfwcPRjT/gCXbusBMeMXiMNQ/St+iRNP8i+pDstV4J
         TbhK07JrCA5bl4DEdjnAKhQbXCTfyHaSgRBUL0+fOmVUyWhAKyW1QhSW9AkxlUVGNERp
         LQmsiUzr46KDCC2A1+arjL6p0GOrqqaUxBhhiC5g+4aH9VW99pv0jTTp8qtmzyFARulD
         +JVih39pGmuBrEWRiFj2ROxr4Zrj1+EtGkXKqlz9v69uI16CK+wGFo7b1q3rW6sPb8Ml
         Wmsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yxZvn/pOD6Wixmg3HHtdl8nPkaQNZIock1gY9YkyAm4=;
        b=LW/Cn7ze9+3v4askmD4GoytSoQkIMjdIwxicxx9yQVcmQQR37Pxp6fObEqhdeXwsP8
         CltCDko5v/jyG1BlF5o+QGWX+i4g9zqlwYYN2iVUAHsXoU17IZH6SvfLo+36oS/R5Y7o
         HWUtAlnWze2hg8mpchPU1gFVfSf3RsvRPxWpLaLQVf/1j836P2Gnk3jM4Ax6TsufzU4F
         LnPd5HhA7FOsss66zoBR9Fn4pvwtGdL2hmmYbdSwB1g3vgcGg7btjdqva1zY3zs6+jYo
         S+rWdGDnkYjiBo26eyLnfWiXN5ik9QZuu4sAst6QyjzbQ4liWPKcJOXChY5O7Ni5tMyb
         +5ag==
X-Gm-Message-State: AHQUAuYXuG2ztHT3ljmkuUdRYWyL+5qgvK731vecbKnI0IuK1KF8KDsl
        YbK6GRBmMG+FufW018pPXS2HpgVFNYtSZR17F9o=
X-Google-Smtp-Source: AHgI3IYiEAYmDLefz/FalYFxl3CpGm8YVtarSGl3SQ8sOzP0f246eiLv82afidhsHKOgLfZHLZkhT+ClkFOL7bfUNJc=
X-Received: by 2002:a5e:a608:: with SMTP id q8mr8781816ioi.82.1549894286268;
 Mon, 11 Feb 2019 06:11:26 -0800 (PST)
MIME-Version: 1.0
References: <20190210195217.18817-1-lkundrak@v3.sk> <20190210195217.18817-3-lkundrak@v3.sk>
In-Reply-To: <20190210195217.18817-3-lkundrak@v3.sk>
From:   Steve deRosier <steve.derosier@gmail.com>
Date:   Mon, 11 Feb 2019 06:10:49 -0800
Message-ID: <CALLGbRJFFeZjLmUvm58xu2KsQ+Vx+TysZaBRfT7MqoSD6T_y-Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] libertas_tf: don't defer firmware loading until start()
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

On Sun, Feb 10, 2019 at 11:52 AM Lubomir Rintel <lkundrak@v3.sk> wrote:
>
> In order to be able to get a MAC address before we register the device
> with ieee80211 we'll need to load the firmware way earlier.
>
> There seems to be one problem with this: the device seems to start
> with radio enabled and starts sending in frames right after the firmware
> load finishes. This might be a firmware bug. Disable the radio as soon
> as possible.
>

I've got a quibble with calling the behavior a bug. As far as I
remember, it's behaving as designed/specified and was quite
appropriate back when this driver originally went upstream. This is a
10 year old fw and driver and needs have changed - which doesn't mean
it was wrong to do originally.

Now, I'm not saying there's no bugs in the fw. Nor that it wouldn't be
nice to change the behavior to accommodate this change. If I still had
access to the firmware source I even might do so.

...
> @@ -648,6 +642,19 @@ struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev,
>
>         INIT_WORK(&priv->cmd_work, lbtf_cmd_work);
>         INIT_WORK(&priv->tx_work, lbtf_tx_work);
> +
> +       if (priv->ops->hw_prog_firmware(priv)) {
> +               lbtf_deb_usbd(&udev->dev, "Error programming the firmware\n");
> +               priv->ops->hw_reset_device(priv);
> +               goto err_init_adapter;
> +       }
> +
> +       /* The firmware seems to start with the radio enabled. Turn it
> +        * off before an actual mac80211 start callback is invoked.
> +        */
> +       priv->radioon = RADIO_OFF;

Maybe move this up a few lines to before you program the fw? Seems
appropriate to initialize it first. While I expect there's no chance
of a race as the
mac80211 start callback hasn't been invoked yet, superficially it
looks like there could be.


> +       lbtf_set_radio_control(priv);
> +
>         if (ieee80211_register_hw(hw))
>                 goto err_init_adapter;
>
> --
> 2.20.1
>

Reviewed-by: Steve deRosier <derosier@cal-sierra.com>
