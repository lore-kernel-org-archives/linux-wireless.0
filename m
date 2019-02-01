Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33774C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 15:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F33DD2086C
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 15:32:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A5BGhsl+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbfBAPco (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 10:32:44 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:45587 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfBAPco (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 10:32:44 -0500
Received: by mail-vs1-f67.google.com with SMTP id x28so4388229vsh.12
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2019 07:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XSIDPthZZ+K08ISXNoxB98xt2kVAy3zqCXmdasp2PH4=;
        b=A5BGhsl+RdROgYkyTI8dA3UM2DIaXlUKxSSeuJiA+g8dEHEXDEuP20EIj0ommUt3k7
         n4nkqBaKRma85zvH75THCZEUpNWJBn1A98FfKXhACR4QVt71/vebCeGumZF4p0tyVnd5
         mRWaQ1R7ZgrlIv5mEqNir12LKK2Ar7kmrlnNpuUZlgiXZ2hee/oagtHKFlFlKUtEygah
         +KSIajpo8RnX7ldb1EjdufnobOOJoHsgrwCq6Dc8PqJB1aeZilMyg6KAeFyD3MzT54uV
         xTu4P5dvL1vR1wM739uyenb960rGASBIDqkYuy3EI3jWakyenGKScDC8G9qyauClCw++
         w/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XSIDPthZZ+K08ISXNoxB98xt2kVAy3zqCXmdasp2PH4=;
        b=leMJM2XEnLKsRvwTlutQ6cFjeEJ4xsIsfiv5AzqZadFn5u4Zcb7Txa+U+rz85Hc9W2
         tgaRGlZrnKCQdIVwrBmEAm+ZG9+s7t+Njin4IF/+5P5cfp7uytCsL3vlhCP3FpuV+Ua7
         F7ixqAv2aC8EfJE93H3kKaMaC9NeZ3onVOxpauxhuvxRZ8+RjDj68tpr4ZUDVAvDbeNr
         bwK2uiRf9WB4Hw7RPPSYOOvjo65+JGi+rC0dtNJyejUhJlUSzb4eD/2LTutSUL4Q4/yq
         HCmUx8buKIBS5pQ7DRkt6hBXI6G+kr+FSNzlohnQA7+ZHaf3RbWwYZY0g1DaWX15VRq0
         WxrA==
X-Gm-Message-State: AJcUukehchU7ZoSAcl1WBiL5JawJmK4bz8tfoM5yvBvswvax7goikvFY
        jxzeyxBxCSsOg6GbVuMhJ/7jBh79xnpp4QY7uYw=
X-Google-Smtp-Source: ALg8bN5hQHDy2P78Ps3Sr0VHMpV9KcXVehHOi109yWPn4qbsZo249HjDG1qpIGwjLxv5q4QcuyovgpTLgj2SmtZy3k8=
X-Received: by 2002:a67:4cd8:: with SMTP id h85mr16275467vsg.110.1549035162252;
 Fri, 01 Feb 2019 07:32:42 -0800 (PST)
MIME-Version: 1.0
References: <1548913985-7180-1-git-send-email-siva8118@gmail.com> <1548913985-7180-3-git-send-email-siva8118@gmail.com>
In-Reply-To: <1548913985-7180-3-git-send-email-siva8118@gmail.com>
From:   Siva Rebbagondla <siva8118@gmail.com>
Date:   Fri, 1 Feb 2019 21:02:28 +0530
Message-ID: <CANGSkXT2-UJreyf71NBpXQjpaKf6RsRVzdz1wtys-8njd5hwdA@mail.gmail.com>
Subject: Re: [v2 2/5] rsi: add hci detach for hibernation and poweroff
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Linux Wireless <linux-wireless@vger.kernel.org>,
        Rishikesh Basu <rishikesh.basu@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Krishna Babu Pedda <krishna.pedda@redpinesignals.com>,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,
On Thu, Jan 31, 2019 at 11:23 AM Siva Rebbagondla <siva8118@gmail.com> wrote:
>
> From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>
> As we missed to detach HCI, while entering power off or hibernation,
> an extra hci interface gets created whenever system is woken up, to
> avoid this we added hci_detach() in rsi_disconnect(), rsi_freeze(),
> and rsi_shutdown() functions which are invoked for these tests.
> This patch fixes the issue
>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> ---
>  drivers/net/wireless/rsi/rsi_91x_sdio.c | 15 +++++++++++++++
>  drivers/net/wireless/rsi/rsi_91x_usb.c  |  6 ++++++
>  2 files changed, 21 insertions(+)
>
> diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
> index b412b65e..4005c1d 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
> @@ -1132,6 +1132,11 @@ static void rsi_disconnect(struct sdio_func *pfunction)
>         rsi_mac80211_detach(adapter);
>         mdelay(10);
>
> +       if (adapter->priv->coex_mode > 1 && adapter->priv->bt_adapter) {
> +               rsi_bt_ops.detach(adapter->priv->bt_adapter);
> +               adapter->priv->bt_adapter = NULL;
> +       }
> +
>         /* Reset Chip */
>         rsi_reset_chip(adapter);
>
> @@ -1308,6 +1313,11 @@ static int rsi_freeze(struct device *dev)
>                 rsi_dbg(ERR_ZONE,
>                         "##### Device can not wake up through WLAN\n");
>
> +       if (common->coex_mode > 1 && common->bt_adapter) {
> +               rsi_bt_ops.detach(common->bt_adapter);
> +               common->bt_adapter = NULL;
> +       }
> +
>         ret = rsi_sdio_disable_interrupts(pfunction);
>
>         if (sdev->write_fail)
> @@ -1355,6 +1365,11 @@ static void rsi_shutdown(struct device *dev)
>         if (rsi_config_wowlan(adapter, wowlan))
>                 rsi_dbg(ERR_ZONE, "Failed to configure WoWLAN\n");
>
> +       if (adapter->priv->coex_mode > 1 && adapter->priv->bt_adapter) {
> +               rsi_bt_ops.detach(adapter->priv->bt_adapter);
> +               adapter->priv->bt_adapter = NULL;
> +       }
> +
>         rsi_sdio_disable_interrupts(sdev->pfunction);
>
>         if (sdev->write_fail)
> diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
> index f360690..38b4880b 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_usb.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
> @@ -816,6 +816,12 @@ static void rsi_disconnect(struct usb_interface *pfunction)
>                 return;
>
>         rsi_mac80211_detach(adapter);
> +
> +       if (adapter->priv->coex_mode > 1 && adapter->priv->bt_adapter) {
> +               rsi_bt_ops.detach(adapter->priv->bt_adapter);
> +               adapter->priv->bt_adapter = NULL;
> +       }
> +
>         rsi_reset_card(adapter);
>         rsi_deinit_usb_interface(adapter);
>         rsi_91x_deinit(adapter);
> --
> 2.5.5
>
Kindly ignore this patch series as kbuild test got failed. It is
because of "rsi_bt_ops". These ops are defined in
drivers/bluetooth/btrsi.c and this file is under CONFIG_RSI_COEX flag.
I was overlooked on this.
As you suggested in v1 series, I will resend these patches with
"IS_ENABLED(CONFIG_RSI_COEX)" check.

Thanks,
Siva Rebbagondla
