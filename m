Return-Path: <SRS0=FFSH=OD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AED6C43441
	for <linux-wireless@archiver.kernel.org>; Sat, 24 Nov 2018 09:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D5DA20868
	for <linux-wireless@archiver.kernel.org>; Sat, 24 Nov 2018 09:26:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D5DA20868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbeKXUOB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 24 Nov 2018 15:14:01 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:40340 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbeKXUOB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Nov 2018 15:14:01 -0500
Received: by mail-it1-f196.google.com with SMTP id h193so20843564ita.5
        for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2018 01:26:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4k29CxI+dRUP80RKmNCSDajOoJ1PhjLNkcODnQRvyoQ=;
        b=YmfaCU8ffbfmjJO/s4tCFy7JlhVfv/EM8xugkB3teWP8Fd8QRj0voZC/fak9CkAT7+
         2wgy3jXOQdpfppuJ/mIKrnrpLGG3LBHfa4AcvFGH+a/+Z8rHXDXRrxUZ4wRcBGX6MsfJ
         akmshzcNlGFWcJN68l16wa9irAXov4lPt2lSYkGtCQUqAl2Kg3zQ2835YH9s8BjtKx4S
         fwQ+6hXJI+jB8cKiJCUWYIgobS61A/twLgLJJrdwSn7YKVh/uupJ4uxCAi1pvktnxfHT
         O6DXAbWmM5/S09I94aWf3wNqk48+VOX+5t0MsXLI6Ngcv72V9GHBqNNV2J5tuCl4gaf4
         rLaw==
X-Gm-Message-State: AA+aEWYhv6UT/mwF3mwgQzqSVr5nkNb2IZDkrw+gK7YLLit6AgOvrq5z
        OH8NlgvSBpinkb/gnqpouWtJE6gNi1GirZ9BOSkUtg==
X-Google-Smtp-Source: AFSGD/Xyx/sbfyHMepr5kOGx+PBsDwsgbvqciAlfZz/eMQYgs9v5FyrF/d1hN4apDHoPe5TpiH6/bgMw/NfsubxIaTY=
X-Received: by 2002:a02:1dc8:: with SMTP id 191mr14262116jaj.55.1543051562008;
 Sat, 24 Nov 2018 01:26:02 -0800 (PST)
MIME-Version: 1.0
References: <20181123213724.14018-1-eduardoabinader@gmail.com>
In-Reply-To: <20181123213724.14018-1-eduardoabinader@gmail.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sat, 24 Nov 2018 10:25:52 +0100
Message-ID: <CAJ0CqmV5byNc+Tmxh5rjHHv9TML31vSWToXq=Fb7aV7JwdJPBw@mail.gmail.com>
Subject: Re: [PATCH] mt76: handle protocol error to proper deinit rx_tasklet
To:     eduardoabinader@gmail.com
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> During removal of usb dongle, noticed many unhandled rx urb
> below. This this patch, make it possible and early completion
> of the rx tasklet.
>
> mt76x2u 1-3.4.3.1.2:1.0: rx urb failed: -71
> mt76x2u 1-3.4.3.1.2:1.0: rx urb failed: -71
> mt76x2u 1-3.4.3.1.2:1.0: rx urb failed: -71
> mt76x2u 1-3.4.3.1.2:1.0: rx urb failed: -71
> ...

Hi Eduardo,

I think EPROTO is a more general error (it is not strictly related to
device removal)
and it could happen even during normal operation. In this case I guess we should
reinsert the urb to usb-core.

Regards,
Lorenzo

>
> Signed-off-by: Eduardo Abinader <eduardoabinader@gmail.com>
> ---
>  drivers/net/wireless/mediatek/mt76/usb.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
> index 5f0faf07c346..dc33df9cd155 100644
> --- a/drivers/net/wireless/mediatek/mt76/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> @@ -446,6 +446,7 @@ static void mt76u_complete_rx(struct urb *urb)
>         case -ECONNRESET:
>         case -ESHUTDOWN:
>         case -ENOENT:
> +       case -EPROTO:
>                 return;
>         default:
>                 dev_err(dev->dev, "rx urb failed: %d\n", urb->status);
> --
> 2.19.1
>
