Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9491BC43612
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 13:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B13E2183F
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 13:20:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=airfi-aero.20150623.gappssmtp.com header.i=@airfi-aero.20150623.gappssmtp.com header.b="OCD3WO57"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbfAGMrd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 07:47:33 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:35952 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728622AbfAGMrb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 07:47:31 -0500
Received: by mail-io1-f66.google.com with SMTP id m19so186899ioh.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2019 04:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=airfi-aero.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EQNYAfMV4OfeP0LNNKBLpT8u32R3hvGyJUwPmKurJjg=;
        b=OCD3WO575psM6T5ojjhJ/FmChCq8f0Gi+fu207Og8eidhJ0PujtwCJF/Mg0vkUdp4H
         lkCf+6hN3jhEhn8uU0R9EP0LBkJz+ECU1rxJTgMWqCJD1Gnvgip/VVIj7a2fH2h1J/HL
         qvYB8Vgr3E9FXuPYa1IXIQTg1VuiRNmBETfRDbQy3uQsQHq3JriLJv+k4PNagTVNF1cg
         1Uy8PEufMiYTp9YfY0Q+6p3Ydcb3HRD385bd54L99a2MYiunVoiivSxwI/f8WzFdZKpf
         +jNmwvQeylr/O9DzSfUMlAo0FTfTxSSc/iYGOMv3vmOoPq7R52h+OY5V1SkmC/2ggWJx
         cG4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EQNYAfMV4OfeP0LNNKBLpT8u32R3hvGyJUwPmKurJjg=;
        b=OjSzH+GRNqjCp41kHRICBo3Mha6gYSPpLTwtB/RbnlaZgo2XrzpjMoyozQLxcdNEE8
         9pgVBD5PcZQFDEU/tp09SF+ignGvZSzQlHG/b3aXvSssiqwZFXpCaR8dGxTgIThL7V2r
         4We6IPCJJ2PrJwGwEbSjSq6VPD/gPsW2/kZy5fxYRlAaEe3D/Z/0aJ6OIUaG8oe8HyML
         A2DAgZfuKhuO37JYaOCcjMKzrbzA/bgqMm7cXF4lDXb9XsWPGdzKeQ6eTCbtbFaK7zsj
         OlexXtSRLmPwSGFKvwCVmpio5PLo8uxMQcM4oPo5ez30LhXM94NQsQRQBHyylxSMn2up
         rw5Q==
X-Gm-Message-State: AJcUukeGGhvtjTP18hWHU2N+z/MhbNofXxuUFNIUf2FJHiuLZjx+N5nh
        1cJJP4QegU6MAtFnpWFkDmw1KQmr98XgWTyIo1xlOg==
X-Google-Smtp-Source: ALg8bN4KBt4CtMhYr+LJ2gLXOTahnxHXFK9BMNfvcbPTWAJdT4XozghXINDhK1jdRHu0DDfSnjkfW0/t5aoSloBwO/U=
X-Received: by 2002:a5d:85c5:: with SMTP id e5mr39942110ios.125.1546865250179;
 Mon, 07 Jan 2019 04:47:30 -0800 (PST)
MIME-Version: 1.0
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com> <1545318971-28351-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1545318971-28351-2-git-send-email-sgruszka@redhat.com>
From:   Jeroen Roovers <jer@airfi.aero>
Date:   Mon, 7 Jan 2019 13:47:19 +0100
Message-ID: <CANCHnQoU-PPTotVD-MmCKCjtoVZEx7Nj4+5YGyfYBEKb2+VNdQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] rt2x00: check number of EPROTO errors
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        =?UTF-8?Q?Tomislav_Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 20 Dec 2018 at 16:16, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> Some USB host devices/drivers on some conditions can always return
> EPROTO error on submitted URBs. That can cause infinity loop in the
> rt2x00 driver.
>
> Since we can have single EPROTO errors we can not mark as device as
> removed to avoid infinity loop. However we can count consecutive
> EPROTO errors and mark device as removed if get lot of it.
> I choose number 10 as threshold.
>
> Reported-and-tested-by: Randy Oostdyk <linux-kernel@oostdyk.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> index 086aad22743d..60b8bccab83d 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> @@ -31,6 +31,22 @@
>  #include "rt2x00.h"
>  #include "rt2x00usb.h"
>
> +static bool rt2x00usb_check_usb_error(struct rt2x00_dev *rt2x00dev, int status)
> +{
> +       if (status == -ENODEV || status == -ENOENT)

I am not sure about this, but it looks to me like you would never see
ENOENT, but ETIMEDOUT:

https://github.com/torvalds/linux/blob/master/drivers/usb/core/message.c#L64

In usb_start_wait_urb ETIMEDOUT is returned instead of ENOENT and
passed up the chain.

     retval = (ctx.status == -ENOENT ? -ETIMEDOUT : ctx.status);


Maybe I am wrong about this, but then again I have neither ever seen
the driver respond to an ENOENT like this when an RT5592
"disappeared".


Kind regards,
     jer
