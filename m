Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D921C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 20:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFFB4206B7
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 20:00:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uoDeJPSi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbfAGUAo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 15:00:44 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40250 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbfAGUAn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 15:00:43 -0500
Received: by mail-wm1-f67.google.com with SMTP id f188so2093853wmf.5
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2019 12:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6Th5978HnDKB/vlRCaeZPDz0W8Kt5ItPSucxzDVhkMg=;
        b=uoDeJPSirMMDXM+AoeEYJuLSu/G7c8ld6nbreQYTZddBDLWbYFOeh8q1dMe9eA/LZm
         AOA/T7MjHwAqOmo4NwYhNfkUnvE6idzC82mKuFSkbWZHPcBOio37vT2n0hhi4usXws2Q
         Q30AcqWo7Qdc+6zJLetP1fC7KP8MsApqkO4BjUc/EFTKpLbWVW4gqDGbiVhBt3pBf/mx
         JdXltB8sfd6r0mApzlfsRw/+E9kQlQft6pLhlwuWLdTZYjM1geG+6svo5GmRhTalOEMC
         h4KEgEl7OpAuIxNQr9mH1kivu+81nxk3buLnK3Pm/Y1b9ye7Z+tPhr1m/oDOXTssPf85
         psjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6Th5978HnDKB/vlRCaeZPDz0W8Kt5ItPSucxzDVhkMg=;
        b=i3GFuEKJO6TJmM5BDgdcGiTqNBhJ5C1+aj7anyUawLFqTp+SMI5hEItxKHxNEJDVH9
         YWYGDn0ErPDeWItPleopEdhkzfzc2MOU1px9j9KbsCB+Snv3lfN4BL5oTwLeAnkbVVoF
         E7id8GC8s1rkT0IB2mSFlIqljUa4pN8evamhrKJFWgLqpREYrNBv4xBnoHIeyFFQVMyi
         TsYFY4wRrH3B5hT3TW1xF7eC/YoN6O/lwX+AyCyXU2FHK9lakFFAeMNCTFsSPqcaKGBZ
         wPPTCVq81p3JjtsW1SlcR7V0OH2iIH1J4lTzu85G9ZMSViPGXrF156kcRyIdI22/4glR
         7IDg==
X-Gm-Message-State: AJcUukcqLEM87C2YOnQsozotfYX9cmy/tYCVIgn17id0RZ8UbFihWGxi
        dqapBgueI+EP47L7ilxOIMaPTHtb
X-Google-Smtp-Source: ALg8bN5Vmcuc/WuQl/zULFd7vKtwxYij1cqANOiVmtLFBbkT/pC0L3A4xNB145cguwGjUjA+k0Vyww==
X-Received: by 2002:a1c:a913:: with SMTP id s19mr9238863wme.4.1546891241037;
        Mon, 07 Jan 2019 12:00:41 -0800 (PST)
Received: from debian64.daheim (p4FD09848.dip0.t-ipconnect.de. [79.208.152.72])
        by smtp.gmail.com with ESMTPSA id m15sm47093678wrr.95.2019.01.07.12.00.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Jan 2019 12:00:40 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.92-RC4)
        (envelope-from <chunkeey@gmail.com>)
        id 1ggb4h-0007AI-Qa; Mon, 07 Jan 2019 21:00:39 +0100
From:   Christian Lamparter <chunkeey@gmail.com>
To:     James Prestwood <james.prestwood@linux.intel.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: Issue with Ath9k/PCI passthrough
Date:   Mon, 07 Jan 2019 21:00:39 +0100
Message-ID: <1679312.s8Z9idQJ2K@debian64>
In-Reply-To: <58b874c2ecd865ff5abc52e037f63d3a1cc7ecc5.camel@linux.intel.com>
References: <6cc1ddae1bab8f71daa07c2c7082354507496f5f.camel@linux.intel.com> <3155667.IrPEAHJHAv@debian64> <58b874c2ecd865ff5abc52e037f63d3a1cc7ecc5.camel@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Monday, January 7, 2019 7:53:49 PM CET James Prestwood wrote:
> On Mon, 2019-01-07 at 19:24 +0100, Christian Lamparter wrote:
> > On Monday, January 7, 2019 6:55:48 PM CET James Prestwood wrote:
> > > Hi,
> > > 
> > > I am passing through PCI wireless adapters into a qemu VM and I am
> > > seeing my host machine lock up/freeze when starting qemu if I try
> > > and
> > > pass through an Atheros AR5B22 PCI card. After reboot I don't see
> > > anything suspicious in /var/log/kern.log, although I don't really
> > > know
> > > what to look for either (or maybe there is another log to look
> > > at?). I
> > > have successfully done PCI passthrough with both an Intel 7260 and
> > > 3160. Its whenever I add the Atheros card into the mix (or by
> > > itself) I
> > > get this lockup when starting the VM.
> > > 
> > > I have enabled the Ath9k drivers when building the kernel (same as
> > > with
> > > Intel cards). This page I read online (
> > > https://wiki.debian.org/ath9k)
> > > said the Ath9k cards don't require firmware like the Intel cards
> > > do, so
> > > I have not added any firmware binaries for this card into the
> > > kernel
> > > build. I also tried turning on the Ath9k debugging but saw no
> > > additional prints in kern.log.
> > > 
> > > With PCI passthrough there is some configuration required, like
> > > substituting the drivers for the vfio-pci driver on the host
> > > machine,
> > > so it could be completely unrelated to the Ath9k driver. Still, I
> > > was
> > > hoping that someone more knowledgeable than me may know whats going
> > > on,
> > > or at least where to look. The fact that the Intel cards work fine
> > > was
> > > what made me think it could be a driver problem.
> > > 
> > > I am more or less following this guide (except with wifi adapters
> > > rather than GPU):
> > > https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF
> > > 
> > 
> > You could be a victim of:
> > 
> > > /*
> > > * Some Atheros AR9xxx and QCA988x chips do not behave after a bus
> > > reset.
> > > * The device will throw a Link Down error on AER-capable systems
> > > and
> > > * regardless of AER, config space of the device is never accessible
> > > again
> > > * and typically causes the system to hang or reset when access is
> > > attempted.
> > > * http://www.spinics.net/lists/linux-pci/msg34797.html
> > > */
> > > DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0030,
> > > quirk_no_bus_reset);
> > > DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0032,
> > > quirk_no_bus_reset);
> > > DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003c,
> > > quirk_no_bus_reset);
> > > DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0033,
> > > quirk_no_bus_reset);
> 
> Adding this to my guest kernel and rebuilding didn't change anything:
> 
> DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0034,
> quirk_no_bus_reset);
> 
> But would I need to make this change on the host kernel as well?

It can matter. I have a mainboard that does a bus reset before
booting the kernel and as a result I was never able to get a
ath10k/ath9k card working on the machine. The kernel would just
get suck either during decompressing or shortly after in random
places. It had no issues with intel or broadcom cards.

You should also follow the thread at least a bit:

<https://www.spinics.net/lists/linux-pci/msg34797.html>

I know Bjorn Helgaas provided instructions on how to do a bus reset
from userspace with setpci tool.

> 
> > 
> > <
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/pci/quirks.c#n3400
> > >
> > 
> > I know that the AR93xx and AR94xx cards have problems with PCIe
> > Passthrough:
> > <https://patchwork.kernel.org/patch/9141239/> and
> > <https://www.spinics.net/lists/linux-pci/msg34797.html> so maybe you
> > can get
> > it to work, once you add a entry to the fixup list.
> > 
> > Regards,
> > Christian
> > 
> > 
> 
> 




