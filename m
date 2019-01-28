Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119E1C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 09:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6AE620880
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 09:38:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bznIMOwE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfA1Jie (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 04:38:34 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:44876 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfA1Jid (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 04:38:33 -0500
Received: by mail-ua1-f67.google.com with SMTP id d19so5353712uaq.11
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 01:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yQGciy/TVIqRy6bnW5uSCEGl6lEeOf1DkpboxzmhWvo=;
        b=bznIMOwEhmfbtI3NT0Lb94U95oWDV0kbKfqLbgiqM00FopxgVAfNqT7JDq8AmK1DMk
         DQlIayQNDNZc1fVkJm5CKRr+gT4NFh9EJkWcXh7Ckch6HFtWCPWb8lm6yDfsb1NQXNL1
         n3XaSabJtADEG1EYRrJAdxj+h/spy3BSJKcWyra4XSgvSgFOUG1/O91zVihWXiWBZirO
         Y3NQBxbgkli6rCiLrDtaN9ATf8Fdv/l+GpkSHOaLVr72u+6MKgOzBDq/wPrg1iyJ7jxk
         TJkcgE4lFewXTsWcdhhjafGELD5l+bgNQIIV2H15EtADPKNtTtEjINaiS61xukMnrhXT
         nfBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yQGciy/TVIqRy6bnW5uSCEGl6lEeOf1DkpboxzmhWvo=;
        b=oB0fpEVW4TXdH5DHYOr+/BS7d8dIsS0hmdHnl521DqylSbTATMNRWGuxgg0XTsVz00
         rFZFaEwrGvLK3bcfBkIDLW4E2GWhtoew89AhMMbvDxXRlaFjIZRnnDO2H4ckrQ41R0IU
         DZRAvMV0HtpcjidQmtxhAqPT/d40lRG01KePOTSltVKL0WGYhNoYc7EpIVHKScgXahjg
         IyAKurVzgNCxPw4oQHSgIsLMPDD6PTyU4Pdijvc/HRaHkOjYH3Q0Tya06/VyF6j0qHZ/
         KS09sDGkNPf0rt6eNb7WGoZiSiUmeT7zWQykw0N+CXIrkjz7J+tzkxafiKZRtGJiUDaU
         wZYg==
X-Gm-Message-State: AJcUukdtnTUftgChoMqXV7gLbLWZV0VGH8xNXl60jJyMPxCye1lOgTQb
        0DZgMY1T4DFTUt2NMcBwOBZ4Gq0JeIkW21dS0fw=
X-Google-Smtp-Source: ALg8bN4goPSFMjEXIHjj7mpc27/o7MEHU36u3goWYZV4zsoSN4rquDoYBWWE90E5echKn5uZmiZ5JR5dmnRTtx3Uaeo=
X-Received: by 2002:a9f:2e0b:: with SMTP id t11mr8721917uaj.79.1548668312627;
 Mon, 28 Jan 2019 01:38:32 -0800 (PST)
MIME-Version: 1.0
References: <1548397802-12180-1-git-send-email-siva8118@gmail.com>
 <1548397802-12180-3-git-send-email-siva8118@gmail.com> <87d0oh166p.fsf@codeaurora.org>
In-Reply-To: <87d0oh166p.fsf@codeaurora.org>
From:   Siva Rebbagondla <siva8118@gmail.com>
Date:   Mon, 28 Jan 2019 15:08:20 +0530
Message-ID: <CANGSkXS1F_72pAKeeT1hXTxEqOBUevjwuEqhrL0bFf4Ep5M=ng@mail.gmail.com>
Subject: Re: [PATCH 2/5] rsi: add hci detach for hibernation and poweroff
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Linux Wireless <linux-wireless@vger.kernel.org>,
        Rishikesh Basu <rishikesh.basu@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>,
        Krishna Babu Pedda <krishna.pedda@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,
On Mon, Jan 28, 2019 at 2:59 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Siva Rebbagondla <siva8118@gmail.com> writes:
>
> > From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> >
> > As we missed to detach HCI, while entering power off or hibernation,
> > an extra hci interface gets created whenever system is woken up, to
> > avoid this we added hci_detach() in rsi_disconnect(), rsi_freeze(),
> > and rsi_shutdown() functions which are invoked for these tests.
> > This patch fixes the issue
> >
> > Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> > ---
> >  drivers/net/wireless/rsi/rsi_91x_sdio.c | 21 +++++++++++++++++++--
> >  drivers/net/wireless/rsi/rsi_91x_usb.c  |  6 ++++++
> >  2 files changed, 25 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
> > index b412b65e..59ff778 100644
> > --- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
> > +++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
> > @@ -1131,7 +1131,12 @@ static void rsi_disconnect(struct sdio_func *pfunction)
> >
> >       rsi_mac80211_detach(adapter);
> >       mdelay(10);
> > -
> > +#ifdef CONFIG_RSI_COEX
> > +     if (adapter->priv->coex_mode > 1 && adapter->priv->bt_adapter) {
> > +             rsi_bt_ops.detach(adapter->priv->bt_adapter);
> > +             adapter->priv->bt_adapter = NULL;
> > +     }
> > +#endif
>
> Ifdefs are ugly, avoid them as much as possible. Would this work:
>
>         if (IS_ENABLED(CONFIG_RSI_COEX) &&
>             adapter->priv->coex_mode > 1 &&
>             adapter->priv->bt_adapter)
>
> BTW, why do you need the ifdef anyway, isn't it enough to check for
> coex_mode?
Agreed. It's enough to check coex_mode with above if condition. I will
make the changes and will submit v2.

Thanks,
Siva Rebbagondla
>
>
> --
> Kalle Valo
