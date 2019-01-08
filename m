Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E573EC43612
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 19:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B533F2063F
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 19:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731905AbfAHTpw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:45:52 -0500
Received: from mga03.intel.com ([134.134.136.65]:23136 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731621AbfAHTpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 14:45:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2019 11:45:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,455,1539673200"; 
   d="scan'208";a="124421314"
Received: from jprestwo.jf.intel.com ([10.54.74.49])
  by orsmga002.jf.intel.com with ESMTP; 08 Jan 2019 11:45:51 -0800
Message-ID: <330c3472d7db27ac555147d3867bdf4a95f20fe8.camel@linux.intel.com>
Subject: Ath9k hang with pci passthrough
From:   James Prestwood <james.prestwood@linux.intel.com>
To:     linux-wireless@vger.kernel.org
Date:   Tue, 08 Jan 2019 11:50:40 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

This is a followup to my original PCI passthrough issue, which has been
resolved, though not as smoothly as I would like. Here is a brief
recap:

I am using PCI passthrough to a VM with an Ath9k wifi adapter. This was
causing my host machine to lock up/freeze when starting the VM. Adding
a line to drivers/pci/quirks.c resolve the issue. Here is the original
thread:

https://marc.info/?l=linux-wireless&m=154689580213002&w=2

By "resolved" I mean the host doesn't lock up, but I am still seeing
weird behavior. When starting the VM I see this:

qemu-system-x86_64: vfio-pci: Cannot read device rom at 0000:08:00.0
Device option ROM contents are probably invalid (check dmesg).
Skip option ROM probe with rombar=0, or load from file with romfile=
[    5.312843] irq 11: nobody cared (try booting with the "irqpoll"
option)
[    5.312843] handlers:
[    5.312843] [<0000000002e29ed0>] vp_interrupt
[    5.312843] [<00000000d9d80d45>] ath_isr
[    5.312843] Disabling IRQ #11

At this point it hangs for a minute or two, sometimes re-printing the
same "irq 11: nobody cared" message with a stack trace (sometimes up to
3 times). But eventually it boots into the VM and the adapter appears
to work as expected.

I have tried to get rid of the ROM contents print by adding "rombar=0",
which didn't seem to change anything. Similarly I tried "irqpoll" which
again didn't change the behavior (note both changes were on the guest
kernel boot, not host).

I don't see any such prints in my host kernel log during boot, so it
seems to be specific to PCI passthrough.

Since the adapter appears to work I could care less about these prints,
I am just hoping to resolve the 1-2min hang when booting the VM.

Thanks,
James



