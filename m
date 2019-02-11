Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2C6C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 10:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC21920863
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 10:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfBKKEN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 05:04:13 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36369 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfBKKEN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 05:04:13 -0500
Received: by mail-wm1-f68.google.com with SMTP id j125so1081586wmj.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2019 02:04:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=d3QKq1t66tQ686bibqss9uE+gpbEaaipQE9SNoXIOHs=;
        b=odbTLLfOnkPLe7xLxgVFYorG+2b3B5c9If1i7awHaIBeDRJruQwhTkcw9HX6QLXbZ8
         1bKZwz7Si+INes0SJXyDFKLv/LM4KK6lG5MWiO02Ac8fXOkOAOvsaLrYPyk2m1fDvu1e
         vN0+dUm2oNZYgi745EnxHmQoluSCDA7Km/xF0T6gqFvKdK07Vl7GTZ9d2UvxVJsjGHtW
         VYIRpvMJUszsiHCG6PIa0hedINJh5q7Q1QFkGZI2KHAMhxTUN+GivXShImVRqlbxap2F
         xLPL5ZsiEcZSnbHYttKNXf8zoW/su5OEgTG6DQ2gas2h47oAMFPk3yeLeultdUU0gUsB
         Udgg==
X-Gm-Message-State: AHQUAuaydSFSK+KEWNXLOJwNXAOLQ/ewu5CdG2TWiHlJmWlUW2IjokjT
        1bNd1+J/U5XN6KiSqFmmwqqf1w==
X-Google-Smtp-Source: AHgI3Iam4sDv6SY5gSKmWKWj/0aac8dnQD8kSG3/TMZJLESNkgDz2f0EApJowiimN8CVOmtYAZMKaw==
X-Received: by 2002:a05:6000:1287:: with SMTP id f7mr3480999wrx.203.1549879450340;
        Mon, 11 Feb 2019 02:04:10 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id t199sm55072856wmt.1.2019.02.11.02.04.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Feb 2019 02:04:09 -0800 (PST)
Date:   Mon, 11 Feb 2019 11:04:06 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190211100405.GD3467@localhost.localdomain>
References: <2003727085.234456.1549714119945@email.ionos.de>
 <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com>
 <165515185.283024.1549744145982@email.ionos.de>
 <20190210094123.GB2913@redhat.com>
 <CAJ0CqmXp2a-zwPMyMFu+UCqTHP7qNRiJFopDSdZWdms7dVef4Q@mail.gmail.com>
 <20190211074455.GA6292@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190211074455.GA6292@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Sun, Feb 10, 2019 at 11:22:25AM +0100, Lorenzo Bianconi wrote:
> > > On Sat, Feb 09, 2019 at 09:29:05PM +0100, Stefan Wahren wrote:
> > > > > could you please test the following series:
> > > > > https://patchwork.kernel.org/cover/10764453/
> > > >
> > > > yeah this fixed the probing timeout and the driver will probe successful. AFAIK the dwc2 host mode doesn't support scatter-gather yet.
> > >
> > > So this is either dwc2 scatter-gather problem which should be addressed in
> > > this driver or mt76x0u does something wrong when configuring SG.
> > >
> > > Disabling SG is just workaround, which do not address actual problem.
> > >
> > > I think I found mt76x0u issue that could cause this USB probe error
> > > (and possibly also address AMD IOMMU issue). We seems do not correctly
> > > set URB transfer length smaller than sg buffer length. Attached  patch
> > > should correct that.
> > 
> > Hi Stanislaw,
> > 
> > I think 'sg[0].length' is already set in mt76u_fill_rx_sg().
> 
> It is, buf->len and sg[0].length are initialized to the same value for 1
> segment. But then buf->len (assigned to urb->buffer_transfer_length) change
> to smaller value , but sg[0].length stay the same. What I think can be
> problem for usb host driver.
> 
> > Moreover applying this patch I got the following crash (rpi-5.0.y):
> 
> Ok, so with patch probe fail instantly and trigger yet another bug(s)
> on error path. You seems to address that already. 
> 
> > Moreover for mt76x0u SG is 'already' disabled since we use just one
> > buffer so from performance point of view I do not see any difference
> > of using a standard usb buffer.
> > This patch has been tested in multiple scenarios and seems to fix
> > reported issues (for usb2.0).
> 
> Ok, so passing buffer via urb->transfer_buffer works. But why urb->sg
> does not work for 1 segment ?

Here it is a different issue respect to the AMD IOMMU one, dwc2 host driver
does not implement SG I/O so probing fails. I guess it is still useful to
implement a 'legacy' mode that enable mt76 on host controllers that do not implement
SG I/O (rpi is a very common device so it will be cool to have mt76 working on
it). Moreover we are not removing functionalities, user experience will remain
the same

> 
> > Are you concerned about increasing code complexity?
> 
> That's one of my concerns. Another, more important one, is that
> changing to urb->transfer_buffer just hide the problems. And they will
> pop up when someone will start to use SG (BTW how this can be tested
> for more than one fragment, IOW how multiple fragments skb's can
> be generated ? ).

You need:
- usb 3.0 controller/device
- A-MSDU capable AP

> 
> And now I think the bugs can be in mt76 driver taking that problems
> happened on different platforms (rpi and AMD IOMMU), i.e. we do not
> correctly set urb->nub_seg or length or do some other thing wrong.

We still need to fix it on usb3.0 with AMD cpu/motherboard :)

Regards,
Lorenzo

> 
> Stanislaw
