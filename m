Return-Path: <SRS0=hJv2=OF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC559C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 21:31:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1EF92082F
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 21:31:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1EF92082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbeK0I0x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 27 Nov 2018 03:26:53 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:40206 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbeK0I0w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Nov 2018 03:26:52 -0500
Received: by mail-io1-f67.google.com with SMTP id n9so15222526ioh.7
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2018 13:31:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jr7wxwZ6zwVcHFGroII8jF/HDLulJpn6DU7TuHJaOVA=;
        b=f7E8+JysVCpqyLLiGl6v2Wg/NiYfgg/b8ikZpubSFs5VUWAXuV8YntT7qc/L1Bx+pD
         5O26ts4lyjWfHBaoOrKd3ttMEeZ6iVba9ZMIjFa2JVida28TwvbrQOZCit/PqRcIOVqQ
         xO3KiDWc3/PH7fLg0QyNtFCHeFh5W+rDbIc9WpOeNA4xRhztPSg2WTWIiNnT0mJ7V2Cd
         EpsKZRWX4410Nrk2oTYYw+kqCRl3fWzzfT4+mgrbaRJMXjfpBzbTSpqtDCZkENzlYiLd
         afz8s01XeReKSWwns7fOqXQzmVmUzBM4l7qtAhYV8Pu9n2m9wXa2W0MGKvJHDM0V7efW
         tVSw==
X-Gm-Message-State: AA+aEWYcNMn3alAren/XP4wHTkbMpVD/e/ZfnS+S1DocnmBcWkgU2/7M
        /RlRvnEXzwb0saekhd5yC01o92YF/8BhobV4N7jmug==
X-Google-Smtp-Source: AFSGD/X1Qc7EMYhdkLeTkfpHNYkBuKqblkJ142DZ2EUZ8q6uT0KGMwmWqzMyyecwZw36ip/qqDbrkB465j5t40+ShIc=
X-Received: by 2002:a5d:834f:: with SMTP id q15mr2778034ior.181.1543267884492;
 Mon, 26 Nov 2018 13:31:24 -0800 (PST)
MIME-Version: 1.0
References: <20181123213724.14018-1-eduardoabinader@gmail.com>
 <CAJ0CqmV5byNc+Tmxh5rjHHv9TML31vSWToXq=Fb7aV7JwdJPBw@mail.gmail.com>
 <20181126095935.GA5710@redhat.com> <CAGoNHngacV2jd59FXYxsiBuQOXmdFPe=4TrHh5PYT7Bk8e-37g@mail.gmail.com>
In-Reply-To: <CAGoNHngacV2jd59FXYxsiBuQOXmdFPe=4TrHh5PYT7Bk8e-37g@mail.gmail.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Mon, 26 Nov 2018 22:31:13 +0100
Message-ID: <CAJ0CqmWTzkh_=XuhSYAwD4Uu1_W6D-mCFSqAwhQUdRD=ciJ7cg@mail.gmail.com>
Subject: Re: [PATCH] mt76: handle protocol error to proper deinit rx_tasklet
To:     eduardoabinader@gmail.com
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > > > During removal of usb dongle, noticed many unhandled rx urb
> > > > below. This this patch, make it possible and early completion
> > > > of the rx tasklet.

[...]

> > > Hi Eduardo,
> > >
> > > I think EPROTO is a more general error (it is not strictly related to
> > > device removal)
> > > and it could happen even during normal operation. In this case I guess we should
> > > reinsert the urb to usb-core.
> >
> > Some (out of tree) usb host drivers returns EPROTO all the time
> > in some error conditions. On rt2x00 resubmitting urb resulted in
> > infinity loop:
> > https://marc.info/?t=153375128700002&r=1&w=2
> >
> > Fix I proposed for that was counting EPROTO errors and
> > mark device as removed if 10 of them happened in row:
> > https://marc.info/?l=linux-wireless&m=153441755529960&w=2
>
> Thanks for the feedback, guys.
>
> Would it be ok for you if I respin the patch with the suggested
> approach by Stanislaw?

Hi Eduardo,

AFAIU the -EPROTO error is reported only during device removal or just
sporadically
(you have never experienced any infinity loop). Is it correct?
If so I guess we do not need to develop any intrusive workaround since
it is just an annoying log message

Regards,
Lorenzo

>
> Regards,
> Eduardo
> >
> > Thanks
> > Stanislaw
