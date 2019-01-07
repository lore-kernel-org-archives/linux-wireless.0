Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3838C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 15:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81E142089F
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 15:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbfAGPJP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 10:09:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34952 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729402AbfAGPJP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 10:09:15 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 17CDA369A9;
        Mon,  7 Jan 2019 15:09:15 +0000 (UTC)
Received: from localhost (unknown [10.40.205.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C1565E7D0;
        Mon,  7 Jan 2019 15:09:14 +0000 (UTC)
Date:   Mon, 7 Jan 2019 16:09:13 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Jeroen Roovers <jer@airfi.aero>
Cc:     linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH v2 2/3] rt2x00: check number of EPROTO errors
Message-ID: <20190107150912.GA9516@redhat.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-2-git-send-email-sgruszka@redhat.com>
 <CANCHnQoU-PPTotVD-MmCKCjtoVZEx7Nj4+5YGyfYBEKb2+VNdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANCHnQoU-PPTotVD-MmCKCjtoVZEx7Nj4+5YGyfYBEKb2+VNdQ@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 07 Jan 2019 15:09:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 07, 2019 at 01:47:19PM +0100, Jeroen Roovers wrote:
> On Thu, 20 Dec 2018 at 16:16, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >
> > Some USB host devices/drivers on some conditions can always return
> > EPROTO error on submitted URBs. That can cause infinity loop in the
> > rt2x00 driver.
> >
> > Since we can have single EPROTO errors we can not mark as device as
> > removed to avoid infinity loop. However we can count consecutive
> > EPROTO errors and mark device as removed if get lot of it.
> > I choose number 10 as threshold.
> >
> > Reported-and-tested-by: Randy Oostdyk <linux-kernel@oostdyk.com>
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> 
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> > index 086aad22743d..60b8bccab83d 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> > @@ -31,6 +31,22 @@
> >  #include "rt2x00.h"
> >  #include "rt2x00usb.h"
> >
> > +static bool rt2x00usb_check_usb_error(struct rt2x00_dev *rt2x00dev, int status)
> > +{
> > +       if (status == -ENODEV || status == -ENOENT)
> 
> I am not sure about this, but it looks to me like you would never see
> ENOENT, but ETIMEDOUT:
> 
> https://github.com/torvalds/linux/blob/master/drivers/usb/core/message.c#L64
> 
> In usb_start_wait_urb ETIMEDOUT is returned instead of ENOENT and
> passed up the chain.
> 
>      retval = (ctx.status == -ENOENT ? -ETIMEDOUT : ctx.status);
> 
> 
> Maybe I am wrong about this, but then again I have neither ever seen
> the driver respond to an ENOENT like this when an RT5592
> "disappeared".

According to Documentation/driver-api/usb/error-codes.rst 
ENOENT is valid error code when interface does not exist or
when URB was unlinked.

Regards
Stanislaw
