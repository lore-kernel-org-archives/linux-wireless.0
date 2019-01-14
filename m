Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0138C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A12DB20660
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 09:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfANJSr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 04:18:47 -0500
Received: from mail-wr1-f44.google.com ([209.85.221.44]:38328 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfANJSr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 04:18:47 -0500
Received: by mail-wr1-f44.google.com with SMTP id v13so21912133wrw.5
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 01:18:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tX7Ow4wXSQ0YnZSgiGlzoKWxpRv36ifWdB1dIUEI4Fc=;
        b=b+37Imrsk2OVeMJRLF8DfAR2ZtIrKRxZqlufkB3V3d0MXnpVVB2tMhBWiFd7SQkzwX
         aCFlXcR+Jl7wyKmmpw+b3Qcg2m8WJdU8HmBsk60eFRqYbSxwWsf46PguA5sYMFwTHVey
         lGpDDnLohgiwiNqQPGjtJUDgkzI1AdWOMu5Hyh4VQLBkIen5JzuTexXKqFOM4mKz45b8
         28S/1s/OD5tljSixUTPbAjR7/vXTUQdPeNUCo4cd/a1CE4XIEZuV8H1L2+7dAcG9FWM4
         gF7yfguU9Fgz7/JwZCbE42ArZKD+sohdPXI7UnaR2IrRX/2zH6RQlo3cDAOVt9u7gLBE
         z2ag==
X-Gm-Message-State: AJcUukcwEP1uVxz8lzn4oWBNImhUZVL9uUOFTwyi20034Y73v4Pg4z9H
        1n7MYygjH+Po+4j0HyhdzsdJgg==
X-Google-Smtp-Source: ALg8bN7AvEc4WEVsmMjNK0pDoPXYdAdvw8EjpnvfqjrOE8ozvQSPgHdsynmBD6wbHcGc9dX6OTGzzg==
X-Received: by 2002:adf:a4d9:: with SMTP id h25mr22053486wrb.167.1547457525669;
        Mon, 14 Jan 2019 01:18:45 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y12sm19654412wmi.7.2019.01.14.01.18.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Jan 2019 01:18:44 -0800 (PST)
Date:   Mon, 14 Jan 2019 10:18:42 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Rosen Penev <rosenp@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
Message-ID: <20190114091841.GA23045@localhost.localdomain>
References: <CAKxU2N9o5WeUwFMUwwXKHaPj7R+oiSKV1c2n8RtXwGNZRtw5Sw@mail.gmail.com>
 <CAJ0CqmVNF83bWgc+LSQ3_i=zfp-sXC5Nf=nKfqB3SWa8r7sKdQ@mail.gmail.com>
 <83A1D243-9073-48D1-9F26-5A2581DCB829@gmail.com>
 <CAJ0CqmUgPWNJtCW4Q__sOtB8w-YtwW+uZy7crxMNrmSgQ6OFyA@mail.gmail.com>
 <1547404075.1582.0@smtp.gmail.com>
 <CAJ0CqmU7k5i26g7dGPxNdts7Gm67W6qNsr4vYuW05ugsEF1ohw@mail.gmail.com>
 <CAKxU2N-+CTaRdJMFVRdozJ5TTpN+_4thiDRBJBFq8gGtuRVYvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKxU2N-+CTaRdJMFVRdozJ5TTpN+_4thiDRBJBFq8gGtuRVYvA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Sun, Jan 13, 2019 at 11:00 AM Lorenzo Bianconi
> <lorenzo.bianconi@redhat.com> wrote:
> >
> > >
> > >
> > > On Sun, Jan 13, 2019 at 5:33 AM, Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
> > >
> > > Direct. No VM used. This is the only peripheral causing this issue.
> > >
> > > Is the device connected to a usb3.0 port? If so, could you please try to connect the dongle to a 2.0 one?
> > >
> > > I tried through a USB 2.0 port. Shouldn't make a difference as they both use the xhci driver.
> > >
> >
> > mt76x2u supports scatter-gather on usb 3.0 (not on 2.0)
> Tried a USB 3 port. Same result.
> >
> > > Could you please double check if IOMMU is enabled?
> > >
> >
> > Have you tried to disable it? Does it make any difference?
> No idea how. UEFI doesn't seem to show anything similar.
> 
> Similar bug report: https://bugzilla.kernel.org/show_bug.cgi?id=202241

You should be able to disable iommu using GRUB_CMDLINE_LINUX in
/etc/default/grub (I guess setting iommu=off and reinstalling grub)
https://wiki.gentoo.org/wiki/IOMMU_SWIOTLB

Regards,
Lorenzo
