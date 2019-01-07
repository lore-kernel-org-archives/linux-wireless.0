Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A28C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 17:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFDD62070B
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 17:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbfAGRvA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 12:51:00 -0500
Received: from mga06.intel.com ([134.134.136.31]:63257 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728413AbfAGRvA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 12:51:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2019 09:50:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,451,1539673200"; 
   d="scan'208";a="309725568"
Received: from jprestwo.jf.intel.com ([10.54.74.49])
  by fmsmga005.fm.intel.com with ESMTP; 07 Jan 2019 09:50:59 -0800
Message-ID: <6cc1ddae1bab8f71daa07c2c7082354507496f5f.camel@linux.intel.com>
Subject: Issue with Ath9k/PCI passthrough
From:   James Prestwood <james.prestwood@linux.intel.com>
To:     linux-wireless@vger.kernel.org
Date:   Mon, 07 Jan 2019 09:55:48 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

I am passing through PCI wireless adapters into a qemu VM and I am
seeing my host machine lock up/freeze when starting qemu if I try and
pass through an Atheros AR5B22 PCI card. After reboot I don't see
anything suspicious in /var/log/kern.log, although I don't really know
what to look for either (or maybe there is another log to look at?). I
have successfully done PCI passthrough with both an Intel 7260 and
3160. Its whenever I add the Atheros card into the mix (or by itself) I
get this lockup when starting the VM.

I have enabled the Ath9k drivers when building the kernel (same as with
Intel cards). This page I read online (https://wiki.debian.org/ath9k)
said the Ath9k cards don't require firmware like the Intel cards do, so
I have not added any firmware binaries for this card into the kernel
build. I also tried turning on the Ath9k debugging but saw no
additional prints in kern.log.

With PCI passthrough there is some configuration required, like
substituting the drivers for the vfio-pci driver on the host machine,
so it could be completely unrelated to the Ath9k driver. Still, I was
hoping that someone more knowledgeable than me may know whats going on,
or at least where to look. The fact that the Intel cards work fine was
what made me think it could be a driver problem.

I am more or less following this guide (except with wifi adapters
rather than GPU):
https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF

Using a custom built kernel based on 4.19.

Thanks,
James

