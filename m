Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E45C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 21:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97EEC2147C
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 21:16:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eZp7JZbb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbfAGVQf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 16:16:35 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36524 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfAGVQe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 16:16:34 -0500
Received: by mail-wm1-f68.google.com with SMTP id p6so2292813wmc.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2019 13:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IWzJsh0unFRL1ceuTjzc1mdZ2xwOanMahZHS5CRMYzk=;
        b=eZp7JZbb5+G91gdiId8oCuUv9XD+PubRbMKc8j8zpUMuiB8AyxtNRqgDxiL86l2C/M
         trA4tBDGkuEtYzxE+5MfY0FwjQawfV2a3bXiEi1xUGwzeaLtt/NZLeGtpWF0ECtifkjC
         xA8BzRAX8HVlbJRKQNvw5iafrNhxqtsBhvBDFNFcdQG6tJXB+o6IuGQZfNF0roYsvVog
         EsoqoB/4upDHX8lZ6cJYP+eJMHSCCZeEKuPGBCyqC8UwCI8gL/dQihOtJsgC/Wa7BYO9
         kXLwO6SOqT4AbGOsvHvb8x8YfRRoJyefhTC8xePtXI1j7JREN0cWPvYgHm8fVXb/PF+C
         igKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IWzJsh0unFRL1ceuTjzc1mdZ2xwOanMahZHS5CRMYzk=;
        b=kcS/TBasurT2ST+NGcORRBuyS/OHyYeVLkoCeJZw62oyZsxZK11YiXkxxzt5iLn59O
         nLX3UDAnfy1sUckFVTX4z4jQyX46awFzw28MwCSPGZmocq8JEWVDNWZ0mtp2AHM4ZWl9
         BmmXxbrP0T6y9gWDI0vw6EwYtjTyoR0Da32kFRWBLSdPU8KPufZmbsA3zueGwBjUs4/B
         BGtI1bQvy2djUudCYnRgxvfMDyYk3sRLpEYvHnt1zarqUqmq7b8lSRk5Rs7wSox51kJi
         2gJxJYZJgKKjqbQEcIPCwPmzKFF9r06ZRAiLgSGlpktRkFRk0QqP9S/ioNE0YQeVV7Er
         2+kw==
X-Gm-Message-State: AJcUukfGNtoM+5dkc1Jch9Pluma+Nr4JwaSsIXPjR7KDBTbxraUtsPqa
        szRMxlcKuMFBFb0Bb31kSMk=
X-Google-Smtp-Source: ALg8bN5p7YkrcyPzY04jVcQWvlDGVDhx+WHK6l+c3sGum7vyfvjJJqye3CFyh0O/yoK6I/eMRQRRKg==
X-Received: by 2002:a1c:c60e:: with SMTP id w14mr10611344wmf.18.1546895792099;
        Mon, 07 Jan 2019 13:16:32 -0800 (PST)
Received: from debian64.daheim (p4FD09848.dip0.t-ipconnect.de. [79.208.152.72])
        by smtp.gmail.com with ESMTPSA id g16sm54060405wru.41.2019.01.07.13.16.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Jan 2019 13:16:30 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.92-RC4)
        (envelope-from <chunkeey@gmail.com>)
        id 1ggcG5-0007sx-83; Mon, 07 Jan 2019 22:16:29 +0100
From:   Christian Lamparter <chunkeey@gmail.com>
To:     James Prestwood <james.prestwood@linux.intel.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: Issue with Ath9k/PCI passthrough
Date:   Mon, 07 Jan 2019 22:16:29 +0100
Message-ID: <1905551.BziccMvNYi@debian64>
In-Reply-To: <929694d281fd5ce0f61aa0e033131b4f837402b5.camel@linux.intel.com>
References: <6cc1ddae1bab8f71daa07c2c7082354507496f5f.camel@linux.intel.com> <1679312.s8Z9idQJ2K@debian64> <929694d281fd5ce0f61aa0e033131b4f837402b5.camel@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Monday, January 7, 2019 9:22:59 PM CET James Prestwood wrote:
> On Mon, 2019-01-07 at 21:00 +0100, Christian Lamparter wrote:
> > On Monday, January 7, 2019 7:53:49 PM CET James Prestwood wrote:
> > > On Mon, 2019-01-07 at 19:24 +0100, Christian Lamparter wrote:
> > > > On Monday, January 7, 2019 6:55:48 PM CET James Prestwood wrote:
> > > > > Hi,
> > > > > 
> > > > > I am passing through PCI wireless adapters into a qemu VM and I
> > > > > am
> > > > > seeing my host machine lock up/freeze when starting qemu if I
> > > > > try
> > > > > and
> > > > > pass through an Atheros AR5B22 PCI card. After reboot I don't
> > > > > see
> > > > > anything suspicious in /var/log/kern.log, although I don't
> > > > > really
> > > > > know
> > > > > what to look for either (or maybe there is another log to look
> > > > > at?). I
> > > > > have successfully done PCI passthrough with both an Intel 7260
> > > > > and
> > > > > 3160. Its whenever I add the Atheros card into the mix (or by
> > > > > itself) I
> > > > > get this lockup when starting the VM.
> > > > > 
> > > > > I have enabled the Ath9k drivers when building the kernel (same
> > > > > as
> > > > > with
> > > > > Intel cards). This page I read online (
> > > > > https://wiki.debian.org/ath9k)
> > > > > said the Ath9k cards don't require firmware like the Intel
> > > > > cards
> > > > > do, so
> > > > > I have not added any firmware binaries for this card into the
> > > > > kernel
> > > > > build. I also tried turning on the Ath9k debugging but saw no
> > > > > additional prints in kern.log.
> > > > > 
> > > > > With PCI passthrough there is some configuration required, like
> > > > > substituting the drivers for the vfio-pci driver on the host
> > > > > machine,
> > > > > so it could be completely unrelated to the Ath9k driver. Still,
> > > > > I
> > > > > was
> > > > > hoping that someone more knowledgeable than me may know whats
> > > > > going
> > > > > on,
> > > > > or at least where to look. The fact that the Intel cards work
> > > > > fine
> > > > > was
> > > > > what made me think it could be a driver problem.
> > > > > 
> > > > > I am more or less following this guide (except with wifi
> > > > > adapters
> > > > > rather than GPU):
> > > > > https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF
> > > > > 
> > > > 
> > > > You could be a victim of:
> > > > 
> > > > > /*
> > > > > * Some Atheros AR9xxx and QCA988x chips do not behave after a
> > > > > bus
> > > > > reset.
> > > > > * The device will throw a Link Down error on AER-capable
> > > > > systems
> > > > > and
> > > > > * regardless of AER, config space of the device is never
> > > > > accessible
> > > > > again
> > > > > * and typically causes the system to hang or reset when access
> > > > > is
> > > > > attempted.
> > > > > * http://www.spinics.net/lists/linux-pci/msg34797.html
> > > > > */
> > > > > DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0030,
> > > > > quirk_no_bus_reset);
> > > > > DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0032,
> > > > > quirk_no_bus_reset);
> > > > > DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003c,
> > > > > quirk_no_bus_reset);
> > > > > DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0033,
> > > > > quirk_no_bus_reset);
> > > 
> > > Adding this to my guest kernel and rebuilding didn't change
> > > anything:
> > > 
> > > DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0034,
> > > quirk_no_bus_reset);
> > > 
> > > But would I need to make this change on the host kernel as well?
> > 
> > It can matter. I have a mainboard that does a bus reset before
> > booting the kernel and as a result I was never able to get a
> > ath10k/ath9k card working on the machine. The kernel would just
> > get suck either during decompressing or shortly after in random
> > places. It had no issues with intel or broadcom cards.
> 
> Looks like I did indeed need the change in the host kernel! No lockup
> and I see the Ath9k inside the VM. Thanks!
> 
> Is this something that should be upstreamed (adding the vendor ID to
> that list)? If so do you know the list by chance? A quick google it
> would seem https://patchwork.kernel.org/project/linux-pci/list/ is the
> right place?

That. Or if you already have the patch, you could just run it through the
scripts/get_maintainer.pl [0]

 
script




