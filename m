Return-Path: <SRS0=hJv2=OF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 636A5C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 21:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29B0C20817
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 21:15:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bv1BxT7q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29B0C20817
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbeK0IKr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 27 Nov 2018 03:10:47 -0500
Received: from mail-vk1-f193.google.com ([209.85.221.193]:46120 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbeK0IKr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Nov 2018 03:10:47 -0500
Received: by mail-vk1-f193.google.com with SMTP id j23so4530036vke.13
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2018 13:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VChPOLZTdUrKladjf7O2/ROqmWYu6HOoPvQdA4pzIa4=;
        b=bv1BxT7q6unAaN7VC+i0iZiIj+8yC0/wzJMly/46x8a8VzdaQzt+guBR2IdLqzi5pD
         h5gLfEdCIyjR4xz8WgklFZR+gtQctHmNx40cQxAtApD7NDoHpH7/bhgr6+XhiIkkQQrG
         F2VFBPXZX3M4Qgrx2KytpwgkV7ZAcYY1GFaAXh3YeT9hQ+kbyy4/zjRMUGJcqbe6vOGx
         esx2mblyDp3UxEw1Zggv+m0g3urfIlze3imQZCGIcZQWh07nmZDNIjVnd7te0TB6JWgd
         GLsQQrNkP/2bPqBGDogyGwP0mTDDzuGC7xEEq1mtuO490eQzCxCz71h3aEyUZGzy7JUt
         aSmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VChPOLZTdUrKladjf7O2/ROqmWYu6HOoPvQdA4pzIa4=;
        b=sJEvqmhmMLyK+Kozvo6QaolUE6bdRkA6n5hNeFy4zmDQCLmt/Rkjp9zwB9c9vZ/bx9
         VmI71FogqB+8QSxiPcv5lPE7Bg4UMOn+dps6LGHqiIZCli67+xSD4SkPuPE13yKosHkv
         LE0hr8EE9qHQYwpAXxm72pI+m3yaaKzYdO8iIdQZtjokXL1V5SxOiUbOwirK1JaIOh7x
         mDmqv/bdLskUPRnD6g0OV7LSh5ETZxAB7sR5K8q8TjvdtJe44wXWIBCZYtOBiL1SbJyL
         6bxVuD4HqaCMtnJngdc/WzOnRSWHTuRD5YEKAqQ9ZI1XHZRRrOWZP6K60cDfGTxvRoV2
         x1iQ==
X-Gm-Message-State: AA+aEWZEC5I6AgG1cPVmJc69BQla+pCIjLSw283NCGiOGKTiAUji0P/W
        iegXQL7HJIQiRwdRsB7Av8nn5bD+CKljojHjzOo=
X-Google-Smtp-Source: AFSGD/VyWVvKw1NoGXWEfu3RygPEuZNyWlk0UELy3DXNVsVUPwHBzGGjyThiK95yIxK7EEPtQ3DC695NmvrP4y8r4g4=
X-Received: by 2002:a1f:c703:: with SMTP id x3mr11661873vkf.87.1543266921485;
 Mon, 26 Nov 2018 13:15:21 -0800 (PST)
MIME-Version: 1.0
References: <20181123213724.14018-1-eduardoabinader@gmail.com>
 <CAJ0CqmV5byNc+Tmxh5rjHHv9TML31vSWToXq=Fb7aV7JwdJPBw@mail.gmail.com> <20181126095935.GA5710@redhat.com>
In-Reply-To: <20181126095935.GA5710@redhat.com>
From:   Eduardo Abinader <eduardoabinader@gmail.com>
Date:   Mon, 26 Nov 2018 22:15:10 +0100
Message-ID: <CAGoNHngacV2jd59FXYxsiBuQOXmdFPe=4TrHh5PYT7Bk8e-37g@mail.gmail.com>
Subject: Re: [PATCH] mt76: handle protocol error to proper deinit rx_tasklet
To:     sgruszka@redhat.com
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 26 Nov 2018 at 10:59, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> On Sat, Nov 24, 2018 at 10:25:52AM +0100, Lorenzo Bianconi wrote:
> > > During removal of usb dongle, noticed many unhandled rx urb
> > > below. This this patch, make it possible and early completion
> > > of the rx tasklet.
> > >
> > > mt76x2u 1-3.4.3.1.2:1.0: rx urb failed: -71
> > > mt76x2u 1-3.4.3.1.2:1.0: rx urb failed: -71
> > > mt76x2u 1-3.4.3.1.2:1.0: rx urb failed: -71
> > > mt76x2u 1-3.4.3.1.2:1.0: rx urb failed: -71
>
> If problem here is just printing errors, I think we are ok. If problem
> is some hung or infinity loop, it should be fixed.
>
> > Hi Eduardo,
> >
> > I think EPROTO is a more general error (it is not strictly related to
> > device removal)
> > and it could happen even during normal operation. In this case I guess we should
> > reinsert the urb to usb-core.
>
> Some (out of tree) usb host drivers returns EPROTO all the time
> in some error conditions. On rt2x00 resubmitting urb resulted in
> infinity loop:
> https://marc.info/?t=153375128700002&r=1&w=2
>
> Fix I proposed for that was counting EPROTO errors and
> mark device as removed if 10 of them happened in row:
> https://marc.info/?l=linux-wireless&m=153441755529960&w=2

Thanks for the feedback, guys.

Would it be ok for you if I respin the patch with the suggested
approach by Stanislaw?

Regards,
Eduardo
>
> Thanks
> Stanislaw
