Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60312 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab1HVXCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 19:02:45 -0400
Received: by eyx24 with SMTP id 24so3228630eyx.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 16:02:43 -0700 (PDT)
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, hharte@broadcom.com
Subject: Re: BCM4325 support in brcm80211 or newer versions of bcm4329 driver
Date: Tue, 23 Aug 2011 01:02:40 +0200
Message-ID: <1555247.YGCuatTnBA@flatron> (sfid-20110823_010249_060299_A91D9545)
In-Reply-To: <20110822221352.GJ2250@broadcom.com>
References: <1514181.3grperja2F@flatron> <20110822221352.GJ2250@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 of August 2011 at 15:13:52, Henry Ptasinski wrote:
> On Sun, Aug 14, 2011 at 11:31:09AM -0700, Tomasz Figa wrote:
> > Hi,
> > 
> > I'm looking into running current Linux kernel on a platform equipped with the
> > BCM4325 full mac combo chip, but unfortunately the shipped DHD driver (v.
> > 4.217.*) is outdated and designed for stock 2.6.29 kernel with much hardcoding
> > done to glue everything together.
> > 
> > I did some reasearch and it led me to a newer version of the DHD driver,
> > designed for BCM4329 (v. 4.218), which after some modifications (BCD protocol
> > version 2, some event IDs, etc.) started to work on my hardware, with one
> > exception: waiting for RxCtrl after sending an "iscanresults" request times
> > out. I'm attaching driver debug output at the bottom of this message.
> > 
> > A bit more details about my hardware: a Samsung S3C6410-based board connected
> > to a BCM4325 chip using 4-bit SDIO interface, without dedicated IRQ pin (using
> > SDIO IRQ feature), so undefining of OOB_INTR_ONLY and HW_OOB and defining of
> > SDIO_ISR_THREAD was needed.
> > 
> > Do you have any suggestions?
> 
> Tom,
> 
> The brcmfmac driver (in staging) doesn't yet support the BCM4325.  As you
> found, there are a variety of older driver sources available in other repos.
> You can contact Howard Harte <hharte@broadcom.com> to see about a combination
> of those sources and firmware that will support your platform in the near term.

Henry,

Thanks for your response.

Well, I already found that this chip isn't supported yet. Basically, what I'm
into is getting it or any other driver compatible with Linux 3.0 and
Android 2.3 to work with our hardware. The problem is that the newest
firmware-driver pair I can get for this chip is 4.217.95.x and it would require
pretty much work to make it compatible with our software target, because
the driver was designed for Linux 2.6.32 sources specific for this hardware
with much hardcoding done.

I'm already in contact with Franky Lin <frankyl@broadcom.com> about our issue,
should I also discuss this topic with Howard?

Best regard,
Tom

