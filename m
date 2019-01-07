Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F1FCC43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 20:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3EB92085A
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 20:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbfAGUSL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 15:18:11 -0500
Received: from mga14.intel.com ([192.55.52.115]:40600 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbfAGUSK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 15:18:10 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2019 12:18:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,451,1539673200"; 
   d="scan'208";a="112862889"
Received: from jprestwo.jf.intel.com ([10.54.74.49])
  by fmsmga007.fm.intel.com with ESMTP; 07 Jan 2019 12:18:09 -0800
Message-ID: <929694d281fd5ce0f61aa0e033131b4f837402b5.camel@linux.intel.com>
Subject: Re: Issue with Ath9k/PCI passthrough
From:   James Prestwood <james.prestwood@linux.intel.com>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 07 Jan 2019 12:22:59 -0800
In-Reply-To: <1679312.s8Z9idQJ2K@debian64>
References: <6cc1ddae1bab8f71daa07c2c7082354507496f5f.camel@linux.intel.com>
         <3155667.IrPEAHJHAv@debian64>
         <58b874c2ecd865ff5abc52e037f63d3a1cc7ecc5.camel@linux.intel.com>
         <1679312.s8Z9idQJ2K@debian64>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-01-07 at 21:00 +0100, Christian Lamparter wrote:
> On Monday, January 7, 2019 7:53:49 PM CET James Prestwood wrote:
> > On Mon, 2019-01-07 at 19:24 +0100, Christian Lamparter wrote:
> > > On Monday, January 7, 2019 6:55:48 PM CET James Prestwood wrote:
> > > > Hi,
> > > > 
> > > > I am passing through PCI wireless adapters into a qemu VM and I
> > > > am
> > > > seeing my host machine lock up/freeze when starting qemu if I
> > > > try
> > > > and
> > > > pass through an Atheros AR5B22 PCI card. After reboot I don't
> > > > see
> > > > anything suspicious in /var/log/kern.log, although I don't
> > > > really
> > > > know
> > > > what to look for either (or maybe there is another log to look
> > > > at?). I
> > > > have successfully done PCI passthrough with both an Intel 7260
> > > > and
> > > > 3160. Its whenever I add the Atheros card into the mix (or by
> > > > itself) I
> > > > get this lockup when starting the VM.
> > > > 
> > > > I have enabled the Ath9k drivers when building the kernel (same
> > > > as
> > > > with
> > > > Intel cards). This page I read online (
> > > > https://wiki.debian.org/ath9k)
> > > > said the Ath9k cards don't require firmware like the Intel
> > > > cards
> > > > do, so
> > > > I have not added any firmware binaries for this card into the
> > > > kernel
> > > > build. I also tried turning on the Ath9k debugging but saw no
> > > > additional prints in kern.log.
> > > > 
> > > > With PCI passthrough there is some configuration required, like
> > > > substituting the drivers for the vfio-pci driver on the host
> > > > machine,
> > > > so it could be completely unrelated to the Ath9k driver. Still,
> > > > I
> > > > was
> > > > hoping that someone more knowledgeable than me may know whats
> > > > going
> > > > on,
> > > > or at least where to look. The fact that the Intel cards work
> > > > fine
> > > > was
> > > > what made me think it could be a driver problem.
> > > > 
> > > > I am more or less following this guide (except with wifi
> > > > adapters
> > > > rather than GPU):
> > > > https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF
> > > > 
> > > 
> > > You could be a victim of:
> > > 
> > > > /*
> > > > * Some Atheros AR9xxx and QCA988x chips do not behave after a
> > > > bus
> > > > reset.
> > > > * The device will throw a Link Down error on AER-capable
> > > > systems
> > > > and
> > > > * regardless of AER, config space of the device is never
> > > > accessible
> > > > again
> > > > * and typically causes the system to hang or reset when access
> > > > is
> > > > attempted.
> > > > * http://www.spinics.net/lists/linux-pci/msg34797.html
> > > > */
> > > > DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0030,
> > > > quirk_no_bus_reset);
> > > > DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0032,
> > > > quirk_no_bus_reset);
> > > > DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003c,
> > > > quirk_no_bus_reset);
> > > > DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0033,
> > > > quirk_no_bus_reset);
> > 
> > Adding this to my guest kernel and rebuilding didn't change
> > anything:
> > 
> > DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0034,
> > quirk_no_bus_reset);
> > 
> > But would I need to make this change on the host kernel as well?
> 
> It can matter. I have a mainboard that does a bus reset before
> booting the kernel and as a result I was never able to get a
> ath10k/ath9k card working on the machine. The kernel would just
> get suck either during decompressing or shortly after in random
> places. It had no issues with intel or broadcom cards.

Looks like I did indeed need the change in the host kernel! No lockup
and I see the Ath9k inside the VM. Thanks!

Is this something that should be upstreamed (adding the vendor ID to
that list)? If so do you know the list by chance? A quick google it
would seem https://patchwork.kernel.org/project/linux-pci/list/ is the
right place?

Thanks,
James

