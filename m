Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF4AC169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 17:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C090720B1F
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 17:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbfAaR1b (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 12:27:31 -0500
Received: from mga06.intel.com ([134.134.136.31]:60469 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726507AbfAaR1b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 12:27:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2019 09:27:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,545,1539673200"; 
   d="scan'208";a="143128892"
Received: from jprestwo.jf.intel.com ([10.54.74.69])
  by fmsmga001.fm.intel.com with ESMTP; 31 Jan 2019 09:27:30 -0800
Message-ID: <2475750488d9016b0b49ae98035e959a9fd388d3.camel@linux.intel.com>
Subject: Re: BCM43602 system freeze with PCI passthrough
From:   James Prestwood <james.prestwood@linux.intel.com>
To:     Steve deRosier <derosier@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Date:   Thu, 31 Jan 2019 09:32:38 -0800
In-Reply-To: <CALLGbRJ6ayYMCPvLCriFnLwW2vfy5azOC=yvT6tnHKkCyPWVsQ@mail.gmail.com>
References: <d5834c32f2ea0a619e848a9aef644161cfeab6b9.camel@linux.intel.com>
         <CALLGbRJ6ayYMCPvLCriFnLwW2vfy5azOC=yvT6tnHKkCyPWVsQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-01-31 at 09:16 -0800, Steve deRosier wrote:
> Hi James,
> 
> On Thu, Jan 31, 2019 at 9:08 AM James Prestwood
> <james.prestwood@linux.intel.com> wrote:
> > 
> > Hi,
> > 
> > I posted about a month ago about an Ath9k card that was causing my
> > host
> > machine to freeze/lock up when doing PCI passthrough into a VM.
> > This
> > was resolved by adding:
> > 
> > DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0034,
> > quirk_no_bus_reset);
> > 
> > to drivers/pci/quirks.c and rebuilding the host kernel.
> > 
> > Original thread:
> > https://marc.info/?l=linux-wireless&m=154689580213002&w=2
> > 
> > I am now trying to get this BCM43602 card working under the same
> > conditions but again I am seeing the host machine freeze when
> > starting
> > the VM. I did try adding a similar line for this card, which
> > actually
> > prevented the machine from freezing, but I am seeing this when
> > starting
> > the VM:
> > 
> 
> Since you've had the same issue with two totally unrelated cards, I'm
> going to suggest that perhaps the issue is not a Linux wireless one.
> You see, the only thing in common with those two cards, with
> different
> manufacturers, different drivers, different firmware, is the PCI bus
> and how you're using it (PCI passthrough on QEMU). Perhaps it's
> either
> a QEMU or a PCI bus driver issue. Have you brought up the question
> with either of those teams?

I followed up originally on the PCI mailing list for the Ath card with
a patch, no idea if they took it. The Ath card having this problem was
not as surprising as there are other Ath cards with the same fix in
quirks.c.

This setup has worked fine on another broadcom card (b43 driver), as
well as two Intel cards (iwlwifi driver). I will definitely ask those
teams.

Thanks,
James

> 
> - Steve

