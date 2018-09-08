Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:43563 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbeIHMb4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Sep 2018 08:31:56 -0400
Received: by mail-io1-f67.google.com with SMTP id y10-v6so3263751ioa.10
        for <linux-wireless@vger.kernel.org>; Sat, 08 Sep 2018 00:47:07 -0700 (PDT)
MIME-Version: 1.0
References: <30971.1536347293@turing-police.cc.vt.edu>
In-Reply-To: <30971.1536347293@turing-police.cc.vt.edu>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Sat, 8 Sep 2018 09:46:55 +0200
Message-ID: <CAJ0CqmVOFcU1fE=0=b1ahfT6PsAJqA7MWkD0y908CQgHp=YxPg@mail.gmail.com> (sfid-20180908_094711_068650_16A780CF)
Subject: Re: [PATCH] mt76: another missing 'select' in Kconfig
To: valdis.kletnieks@vt.edu
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> commit b40b15e1521f7764ea8c68d5a00ecc971b673d21
> Author: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Date:   Tue Jul 31 10:09:19 2018 +0200
>
>     mt76: add usb support to mt76 layer
>
> add a new mt76-usb.c for MT76x2U USB devices, but failed to wire
> it up for MT76x0U USB devices.
>
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> ---
> diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
> index 6a270e759006..cec977b81305 100644
> --- a/drivers/net/wireless/mediatek/mt76/Kconfig
> +++ b/drivers/net/wireless/mediatek/mt76/Kconfig
> @@ -17,6 +17,7 @@ config MT76x2_COMMON
>  config MT76x0U
>         tristate "MediaTek MT76x0U (USB) support"
>         select MT76_CORE
> +       select MT76_USB
>         depends on MAC80211

This fix is contained in latest series sent by Stanislaw:
https://patchwork.kernel.org/patch/10590265/

Regards,
Lorenzo
