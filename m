Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C41C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 09:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D75FB20657
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 09:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbfAOJEH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 04:04:07 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:53595 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728093AbfAOJEG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 04:04:06 -0500
Received: by mail-wm1-f49.google.com with SMTP id d15so2431220wmb.3
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 01:04:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=g4GwKd1vqJ9FT0jY4PlKlJBpExf9ogISQDEr6omsm7w=;
        b=t9w0CXkS0dEhd5ctfSEApKoyYOro922b2R3z+5OFPMS+xDC1LCJpty6m/vAqTj4z+2
         xTb7IId5pbWYZcBPQfgivSjRio8N4UJ+cGWMrMpG9f165m48GXBWkDS6aqdIuW48OPHk
         RESbtePbrT3Ey2zREgD+5xEWu1l9Qhu32SooST9XAzxmzOzOlbk7MzVuGu+QgFpWsOpG
         MH9skjrnAxT3shTriLxdTf5+wojCFFsQ8pS7Kwb7HqtQWqTZ8OAure5W+tTmBPMcQT5I
         iXIBIYWR9a9letDm2AG7Mui9KHoZE9RrqmvEqce4GM1uNv5RzTuicNVvEg6SXkNSV+cZ
         AKcg==
X-Gm-Message-State: AJcUuke5y5WDfL6HrP0bodBo2WZZIu7fX1WGbkTwhinnYHUwyxVObaLa
        MIxIrVOmM+dV4k2COAMe6LO7Uw==
X-Google-Smtp-Source: ALg8bN4q3NnanrAN4bMRZ/dDYh/Hshu6fz072oYP9Nhi697TVvtJVQCLW11/mhhzDpqeqPsk8/3ymA==
X-Received: by 2002:a1c:b189:: with SMTP id a131mr2551192wmf.38.1547543044111;
        Tue, 15 Jan 2019 01:04:04 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id o64sm28233662wmo.47.2019.01.15.01.04.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Jan 2019 01:04:03 -0800 (PST)
Date:   Tue, 15 Jan 2019 10:04:01 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Rosen Penev <rosenp@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
Message-ID: <20190115090400.GA2267@localhost.localdomain>
References: <CAKxU2N9o5WeUwFMUwwXKHaPj7R+oiSKV1c2n8RtXwGNZRtw5Sw@mail.gmail.com>
 <CAJ0CqmVNF83bWgc+LSQ3_i=zfp-sXC5Nf=nKfqB3SWa8r7sKdQ@mail.gmail.com>
 <83A1D243-9073-48D1-9F26-5A2581DCB829@gmail.com>
 <CAJ0CqmUgPWNJtCW4Q__sOtB8w-YtwW+uZy7crxMNrmSgQ6OFyA@mail.gmail.com>
 <1547404075.1582.0@smtp.gmail.com>
 <CAJ0CqmU7k5i26g7dGPxNdts7Gm67W6qNsr4vYuW05ugsEF1ohw@mail.gmail.com>
 <CAKxU2N-+CTaRdJMFVRdozJ5TTpN+_4thiDRBJBFq8gGtuRVYvA@mail.gmail.com>
 <20190114091841.GA23045@localhost.localdomain>
 <CAKxU2N8ioMszBCyQcH7CVhgBdW4aj7yZ+kYQe14DCV5OSAnxrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKxU2N8ioMszBCyQcH7CVhgBdW4aj7yZ+kYQe14DCV5OSAnxrg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Mon, Jan 14, 2019 at 1:18 AM Lorenzo Bianconi
> <lorenzo.bianconi@redhat.com> wrote:
> >
> > > On Sun, Jan 13, 2019 at 11:00 AM Lorenzo Bianconi
> > > <lorenzo.bianconi@redhat.com> wrote:
> > > >
> > > > >
> > > > >
> > > > > On Sun, Jan 13, 2019 at 5:33 AM, Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
> > > > >
> > > > > Direct. No VM used. This is the only peripheral causing this issue.
> > > > >
> > > > > Is the device connected to a usb3.0 port? If so, could you please try to connect the dongle to a 2.0 one?
> > > > >
> > > > > I tried through a USB 2.0 port. Shouldn't make a difference as they both use the xhci driver.
> > > > >
> > > >
> > > > mt76x2u supports scatter-gather on usb 3.0 (not on 2.0)
> > > Tried a USB 3 port. Same result.
> > > >
> > > > > Could you please double check if IOMMU is enabled?
> > > > >
> > > >
> > > > Have you tried to disable it? Does it make any difference?
> > > No idea how. UEFI doesn't seem to show anything similar.
> > >
> > > Similar bug report: https://bugzilla.kernel.org/show_bug.cgi?id=202241
> >
> > You should be able to disable iommu using GRUB_CMDLINE_LINUX in
> > /etc/default/grub (I guess setting iommu=off and reinstalling grub)
> > https://wiki.gentoo.org/wiki/IOMMU_SWIOTLB
> Yep. Working great now. I wonder what mt76 is doing to cause the crash though...

Thanks for bisecting the issue. I think amd iommu does not support well usb scatter-gather
(used by default in mt76u). I am working on a series in order to add the possibility to
disable it.

Regards,
Lorenzo

> >
> > Regards,
> > Lorenzo
