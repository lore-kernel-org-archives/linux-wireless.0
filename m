Return-Path: <SRS0=hJv2=OF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD7B0C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 21:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71C5B208E4
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 21:38:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YMobKxtd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71C5B208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbeK0Idj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 27 Nov 2018 03:33:39 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:39867 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbeK0Idi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Nov 2018 03:33:38 -0500
Received: by mail-ua1-f68.google.com with SMTP id k10so6876792ual.6
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2018 13:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sO5PrQ7NBk4u+vGbTV7VksXw30IXp9y0UspuvKctWTM=;
        b=YMobKxtd1BU/TjcUtF9ELgUc8vRUFkZcFZcvnv+OmNyjS2wa+zAFN6nc85b0jw1T7S
         l7VTgxKuTDH7NiBuD9N9wYT9pIKzxOAII9C+oZqXuzonVkqV+3frU2iPPfVrf9SqUCEb
         tEScmWsC51RLsLFDfz3Tnmd3ug4qoweNBBpDdKXjJBPet8zBkp22gj3qGpBsaHgfSCU6
         N9PWXH9ZYqNjSMxODAcZ0lOP60ZLdwo0G0X9iJr7FU5W4DXcbvjYnXc7k+M5i6EG0MTo
         T/BMijHtDCyOE+tDRFJaRJWTj4rGibNWQWo+9plZ1ZgSLoFhR2Uo6pXKqAoRAsN1STNz
         b+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sO5PrQ7NBk4u+vGbTV7VksXw30IXp9y0UspuvKctWTM=;
        b=XIg944M4VlW5JP+bMAs3brfwqNR8xSXMyRCg4cmFE1bWrk9I2bJBNo/lLM7XLNGsUN
         phLFb0/V3qnaxTxlNsXrSnWagY4Gd8nvlUF2Rojk0BIgwiwYIFJRfjiwD5r0czHf3Fp2
         P9DVQ0kO+J+bZ0JXHemzoL+er1YiuqQZ2FnlhQvSTD06pBomKPrNIGBj5NVGvMHuMkec
         FIKjDYK9KS1kn8VqGQLIri2ZvDPND124BMAUl88FEWU4FQ11Tfudd+kk/nGp//3G20sL
         iaH+TnOLasQOIauPsJLBYgH7Yl3paN+bq7reNrNCxoU6tfqZ5EQzO+y/ia9UCd+fU3MC
         gPPg==
X-Gm-Message-State: AA+aEWYnlD6mTMrqoR31GWXaA5WOwNDcN0U97V6tv2M1lLt4l0QmFa3l
        b2krRoPYh22eXXN9N0IBkRHPEHBcxuOky7oxdLR8Sz2q
X-Google-Smtp-Source: AFSGD/WbDOfGABUWniRF13RSd4Z4VlD8uSIt0GOcaA+eOTSo1wT+KVi8xp4wILaR9AUF6k77Fj2ZKOeSIbOhmUyh9lU=
X-Received: by 2002:ab0:526:: with SMTP id 35mr12296266uax.25.1543268288417;
 Mon, 26 Nov 2018 13:38:08 -0800 (PST)
MIME-Version: 1.0
References: <20181123213724.14018-1-eduardoabinader@gmail.com>
 <CAJ0CqmV5byNc+Tmxh5rjHHv9TML31vSWToXq=Fb7aV7JwdJPBw@mail.gmail.com>
 <20181126095935.GA5710@redhat.com> <CAGoNHngacV2jd59FXYxsiBuQOXmdFPe=4TrHh5PYT7Bk8e-37g@mail.gmail.com>
 <CAJ0CqmWTzkh_=XuhSYAwD4Uu1_W6D-mCFSqAwhQUdRD=ciJ7cg@mail.gmail.com>
In-Reply-To: <CAJ0CqmWTzkh_=XuhSYAwD4Uu1_W6D-mCFSqAwhQUdRD=ciJ7cg@mail.gmail.com>
From:   Eduardo Abinader <eduardoabinader@gmail.com>
Date:   Mon, 26 Nov 2018 22:37:56 +0100
Message-ID: <CAGoNHnguGbWWSNjG=XUt8wHeti1fOtUd0gfX4j4x9C0GDi77fg@mail.gmail.com>
Subject: Re: [PATCH] mt76: handle protocol error to proper deinit rx_tasklet
To:     lorenzo.bianconi@redhat.com
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 26 Nov 2018 at 22:31, Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> > > > > During removal of usb dongle, noticed many unhandled rx urb
> > > > > below. This this patch, make it possible and early completion
> > > > > of the rx tasklet.
>
> [...]
>
> > > > Hi Eduardo,
> > > >
> > > > I think EPROTO is a more general error (it is not strictly related to
> > > > device removal)
> > > > and it could happen even during normal operation. In this case I guess we should
> > > > reinsert the urb to usb-core.
> > >
> > > Some (out of tree) usb host drivers returns EPROTO all the time
> > > in some error conditions. On rt2x00 resubmitting urb resulted in
> > > infinity loop:
> > > https://marc.info/?t=153375128700002&r=1&w=2
> > >
> > > Fix I proposed for that was counting EPROTO errors and
> > > mark device as removed if 10 of them happened in row:
> > > https://marc.info/?l=linux-wireless&m=153441755529960&w=2
> >
> > Thanks for the feedback, guys.
> >
> > Would it be ok for you if I respin the patch with the suggested
> > approach by Stanislaw?
>
> Hi Eduardo,
>
> AFAIU the -EPROTO error is reported only during device removal or just
> sporadically
> (you have never experienced any infinity loop). Is it correct?
> If so I guess we do not need to develop any intrusive workaround since
> it is just an annoying log message
>

It is reported only during device removal as I've been seen with my
comfast dongle.
The device removal does not lead to an infinity loop, but there's a
bouncing around 100 urb failed msgs...

Thanks,
Eduardo

> Regards,
> Lorenzo
>
> >
> > Regards,
> > Eduardo
> > >
> > > Thanks
> > > Stanislaw
