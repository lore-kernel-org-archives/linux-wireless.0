Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A442C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 02:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F2A8217F4
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 02:42:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="daipzmQK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfCTCmI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 22:42:08 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:55284 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfCTCmH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 22:42:07 -0400
Received: by mail-it1-f195.google.com with SMTP id w18so29331243itj.4;
        Tue, 19 Mar 2019 19:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Kr+RfcbNmLFGxezrVVwyPZmhnYgmN1h2XaSmiI3F1s8=;
        b=daipzmQKeiDGAuOkK5KJp4dQdISACL1QOaKns5W8Bq+2Kvb8bcdNwtAz3+rtczy4aD
         I0AeTdJhDYpEL1tYsEj43yT9zDA+KBbwoyk/q0SuXN4Yk5mI2+BuGQwUv1MU9JY0sxbX
         T1Hkam9xuyPusEgxBasUYSVcy2VGb3l9+bTt5oy3N7h/9aad/c3JJJ67lyM4q2K2BlFi
         0qvqYV3qe3dasc5dUhLMQP2YeZiiar96ov4eledprPm8TdERvOPdzFBWQ4GMNfZZpygG
         HohjDT6+2Rh017TXkI6APRm8dL2rJHgThHPOTcF7hFKHs0PNjKqt/9s+1QHYC3iYSIBU
         2Eig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Kr+RfcbNmLFGxezrVVwyPZmhnYgmN1h2XaSmiI3F1s8=;
        b=M+jr7hAs6xD2/qjdDpmtL+MvqiQ4OMgXu48MgxNJmWD1G8UxrZuqFNoXtiC+A5SfRA
         gVNaI8IlPU2Xtp4q57GHRZ7hqPpqijQX7Q3pnCAn7Vl7iQs6yR5NyUudi9jRCTcrflYL
         cZ3v/sJuyL1XcO4zw88Ws5CK/ATJwXbaifikDYoWCcjnBMrCyQAbxtQ04iccukiW+WsV
         gBSwEEO8xjIml3zDveF3TzR2eAOVyrUG6nw1Rtihjonv7iI4P8RBfV7j8oUgJCLdB6Ke
         +pHuinmcx0Vuz7pcoWuKYqUx+uVxdHZJG9dOzVAgYWTh07WRuWug1lE87ma42zVXThSU
         RseQ==
X-Gm-Message-State: APjAAAVyNcwFZl4VjHigsd+mv8c0Yz+4c5VKoITODzKL6Vd7sU14YWal
        d6W9sq6MVhEZUEhmuhc5IYGDUxthc8wqQy90F58=
X-Google-Smtp-Source: APXvYqxxndfQViHK4a7LCZOilcf9GKOWE5QEz/a3HewfH5jOdzoAYSl9GXJ8TRVZwsB84b3FatuA5JaV/YEAz3pkT1w=
X-Received: by 2002:a24:9:: with SMTP id 9mr3519924ita.127.1553049726641; Tue,
 19 Mar 2019 19:42:06 -0700 (PDT)
MIME-Version: 1.0
References: <1553005870-28018-1-git-send-email-chongguiguzi@gmail.com> <1553049084.13542.2.camel@realtek.com>
In-Reply-To: <1553049084.13542.2.camel@realtek.com>
From:   =?UTF-8?B?6LCi5qyi?= <chongguiguzi@gmail.com>
Date:   Wed, 20 Mar 2019 10:41:54 +0800
Message-ID: <CAJ3e5OY-vuuenepfugTwZesksAhzAjHC8rENKcrWLJTqiYm8=Q@mail.gmail.com>
Subject: Re: [PATCH] net:rtlwifi:move spin_lock_bh to spin_lock in tasklet
To:     Pkshih <pkshih@realtek.com>
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Thank you so much for your useful advice.

Pkshih <pkshih@realtek.com> =E4=BA=8E2019=E5=B9=B43=E6=9C=8820=E6=97=A5=E5=
=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=8810:31=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, 2019-03-19 at 22:31 +0800, Jeff Xie wrote:
> > It is unnecessary to call spin_lock_bh in a tasklet.
> >
> > Signed-off-by: Jeff Xie <chongguiguzi@gmail.com>
> >
> > ---
> >  drivers/net/wireless/realtek/rtlwifi/pci.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c
> > b/drivers/net/wireless/realtek/rtlwifi/pci.c
> > index 48ca521..4055e0a 100644
> > --- a/drivers/net/wireless/realtek/rtlwifi/pci.c
> > +++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
> > @@ -499,16 +499,16 @@ static void _rtl_pci_tx_chk_waitq(struct ieee8021=
1_hw
> > *hw)
> >
> >                       memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc))=
;
> >
> > -                     spin_lock_bh(&rtlpriv->locks.waitq_lock);
> > +                     spin_lock(&rtlpriv->locks.waitq_lock);
> >                       if (!skb_queue_empty(&mac->skb_waitq[tid]) &&
> >                           (ring->entries - skb_queue_len(&ring->queue) =
>
> >                            rtlhal->max_earlymode_num)) {
> >                               skb =3D skb_dequeue(&mac->skb_waitq[tid])=
;
> >                       } else {
> > -                             spin_unlock_bh(&rtlpriv->locks.waitq_lock=
);
> > +                             spin_unlock(&rtlpriv->locks.waitq_lock);
> >                               break;
> >                       }
> > -                     spin_unlock_bh(&rtlpriv->locks.waitq_lock);
> > +                     spin_unlock(&rtlpriv->locks.waitq_lock);
> >
> >                       /* Some macaddr can't do early mode. like
> >                        * multicast/broadcast/no_qos data
>
> The mail subject should be 'rtlwifi: move ....', and the other looks good=
 to me.
>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
>
>
