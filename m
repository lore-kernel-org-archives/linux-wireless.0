Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1725C282CA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 22:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 790CF222C1
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 22:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732776AbfBLWJJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 17:09:09 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36241 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732475AbfBLWJI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 17:09:08 -0500
Received: by mail-wm1-f66.google.com with SMTP id j125so280592wmj.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 14:09:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zNgaCX7sbhz3ErNxypNc/Q5KfciH0S4BUyaJEs3LA+Y=;
        b=UVeN9R1NNzqk78UQs2YMO89z0EeSX8U51p7zZDjs4VFjIPIwEHnaV2WuEI74f0wTvN
         nflp7JDg3NeBIdof9KzeoxkjbxhumS2H8xPB5MBwfypAyWmDZGv4Kw7ohOfffIGq1VFJ
         Cmx/wthdQBF+JDFb4FS7fxaPUBNKh0SpicEq2tgevaqR2QUD3BJ3jt5rR5TIISzqjM4b
         mpIeN2oX2guNcZBjZA6OX4vb5DpG7G+BIz4WDhxiEJfu7iqVULnH94xRiFpObEbEU7JI
         kMVx06lNe6eMIat0227ZLWJjqIGbrL7VQv7BwzzAvcRrosWMuCTnRodrYRwyEHfrgGLM
         I4IA==
X-Gm-Message-State: AHQUAua4d0a37hOr4kLJHF60YOhdApbCEY7S4x/fogQ/lh8yWXaX5WO7
        WUjF6PA/5PyopJycck5IShv/tqSzaMU=
X-Google-Smtp-Source: AHgI3IYKe4DNRm/S4UDHob0wIUulWeWYDU7GNJXUMXfc4MwaP74mq1Z2U7JtRELtK7+diIALHku8Eg==
X-Received: by 2002:a1c:a6c9:: with SMTP id p192mr779898wme.58.1550009346882;
        Tue, 12 Feb 2019 14:09:06 -0800 (PST)
Received: from localhost.localdomain ([151.66.10.5])
        by smtp.gmail.com with ESMTPSA id n26sm1622868wmk.29.2019.02.12.14.09.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Feb 2019 14:09:06 -0800 (PST)
Date:   Tue, 12 Feb 2019 23:09:03 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        lorenzo@kernel.org
Subject: Re: [PATCH 0/4] do not use sg if not properly supported by usb
 controller
Message-ID: <20190212220902.GA27836@localhost.localdomain>
References: <cover.1549977282.git.lorenzo@kernel.org>
 <20190212134550.GA12256@redhat.com>
 <20190212135100.GA15292@redhat.com>
 <CAJ0CqmVhH61P1V1fmhicPXwA7vHjv+Hh7h2DYbci1uDRJCyENA@mail.gmail.com>
 <20190212141725.GD12906@redhat.com>
 <20190212142528.GB24197@localhost.localdomain>
 <20190212145424.GE12906@redhat.com>
 <20190212150836.GA10823@localhost.localdomain>
 <20190212152559.GB23126@redhat.com>
 <20190212155001.GA12780@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190212155001.GA12780@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > On Tue, Feb 12, 2019 at 04:08:37PM +0100, Lorenzo Bianconi wrote:
> > > > > > What unnecessary operation ?
> > > > > 
> > > > > the ones in mt76u_fill_bulk_urb()
> > > > 
> > > > Your patches also add extra operations on hotpath due to urb->num_sgs and
> > > > dev->usb.sg_en checks.
> > > 
> > > here I guess you should use mt76u_check_sg() instead of
> > > udev->bus->sg_tablesize > 0 so I think you need to precompute it since it is in
> > > the hotpath
> > 
> > It's not necessary. If udev->bus->sg_tablesize > 0 is true and rest
> > of mt76u_check_sg() is not, we will submit urb with urb->num_sgs = 1 to
> > usb host driver, what is fine. 
> > 
> > > Moreover the RFC series has been tested by multiple users and on multiple
> > > devices
> > 
> > I know. Perhaps you could test my patch on rpi ?
> 
> sure, I will do it later

I confirm that even with Stanislaw's patch the usb dongle is properly working
on rpi3+

Regards,
Lorenzo

> 
> Regards,
> Lorenzo
> 
> > 
> > Stanislaw 
> > 
> > 

