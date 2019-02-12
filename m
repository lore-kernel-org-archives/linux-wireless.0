Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F998C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 00:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D241D20844
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 00:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfBLAGN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 19:06:13 -0500
Received: from mail-it1-f179.google.com ([209.85.166.179]:36040 "EHLO
        mail-it1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727606AbfBLAGM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 19:06:12 -0500
Received: by mail-it1-f179.google.com with SMTP id c9so3008420itj.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2019 16:06:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QYxSQAP/sAXs5BmkeD2ZY8H0RGnNhPEkrj3DvetQz/A=;
        b=oIyShpGtl5GyuqXQ1/sSYO2GIJ2BXr/hJhHtixvcP73fx0LkqH6ltLB4ce+fN3X7Na
         Ft488t/gCT+06m6rVYz6J7wCxYwFE459Od8hc32iluedITaCKCzy7DimFVXal3OIGLEV
         sdw42mCD1bWdX1d2oPOgVcgbzNk7yKpiyr0mtWlAbvDnejqhwmeLNZQDwtq4cvB5iBPQ
         7bISGWTMM7TJQPVrS+uqKQCCVMnQRpfOyTBCM9Rq3sr2d1T8/kWyZQOAZxHB8aAqj/xr
         KhOjg2LERz3g65bN9Z3YYuJOvlw9oppaSTjJojBZkWxQk2Yl1PyX1+MrDx9ExSjk+WvL
         W5xA==
X-Gm-Message-State: AHQUAubIvNW7w+sOz9NWbbojBbBwnFyjQPgUvRI8VtvPlvytDuSakh4A
        3oPC2LsYrIBvixPxN/HbN2xYhKeP0xESGIRdwudl2g==
X-Google-Smtp-Source: AHgI3IZ4ArGcWpk+jx9wckOFAM5XjadmX9q15UVCwJjGlHXKH6pDG8ZdHfSk3HxJLO2vV1y/7WYq9dAgLaGb4NtehpQ=
X-Received: by 2002:a5d:9418:: with SMTP id v24mr460578ion.181.1549929971912;
 Mon, 11 Feb 2019 16:06:11 -0800 (PST)
MIME-Version: 1.0
References: <20190211173315.GE6292@redhat.com> <Pine.LNX.4.44L0.1902111246410.1543-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1902111246410.1543-100000@iolanthe.rowland.org>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Tue, 12 Feb 2019 01:06:00 +0100
Message-ID: <CAJ0CqmVFVBXi5E07-ZsYojC7mP4ogpwbcDkDTeebHwX+ayz2DQ@mail.gmail.com>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> On Mon, 11 Feb 2019, Stanislaw Gruszka wrote:
>
> > On Mon, Feb 11, 2019 at 10:12:57AM -0500, Alan Stern wrote:
> > > On Mon, 11 Feb 2019, Lorenzo Bianconi wrote:
> > >
> > > > Here it is a different issue respect to the AMD IOMMU one, dwc2 host driver
> > > > does not implement SG I/O so probing fails. I guess it is still useful to
> > > > implement a 'legacy' mode that enable mt76 on host controllers that do not implement
> > > > SG I/O (rpi is a very common device so it will be cool to have mt76 working on
> > > > it). Moreover we are not removing functionalities, user experience will remain
> > > > the same
> > >
> > > Has anyone considered adding SG support to dwc2?  It shouldn't be very
> > > difficult.  The corresponding change for ehci-hcd required adding no
> > > more than about 30 lines of code.
> >
> > That would be cool. Perhaps somebody with dwc2 hardware could do this.
> >
> > However in mt76x02u we possibly would like to support other usb host
> > drivers with sg_tablesize = 0 . I would like to clarify what is correct
> > to do with such drivers.
> >
> > Is ok to pass buffer via urb->sg with urb->num_sgs = 1 ? Or maybe
> > urb->num_sgs should be 0 to pass buffer via urb->sg on such drivers ?
> > Or maybe non of above is correct and the only option that will work
> > in 100% is pass buffer via urb->transfer_buffer ?
>
> See the kerneldoc for usb_sg_init(), usb_sg_wait(), and usb_sg_cancel()
> in drivers/usb/core/message.c.  These routines will always do the right
> thing -- however usb_sg_wait() must be called in process context.
>
> Alan Stern
>

Hi Alan,

I actually used usb_sg_init()/usb_sg_wait() as reference to implement
mt76u {tx/rx} datapath, but I will double-check.
I guess we should even consider if there are other usb host drivers
that do not implement SG I/O and it is worth to support.
I am wondering if the right approach is to add SG to the controller
one by one or have legacy I/O in mt76 (not sure what is the 'best'
approach)
What do you think?

Regards,
Lorenzo
