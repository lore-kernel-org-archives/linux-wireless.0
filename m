Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 334ACC10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 13:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BD6D20685
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 13:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbfDWN1j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 09:27:39 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:59086 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727467AbfDWN1i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 09:27:38 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hIvSP-0000Oa-SC; Tue, 23 Apr 2019 16:27:34 +0300
Message-ID: <6621404e5ce6c24ff617314c4427bcb821052ae1.camel@coelho.fi>
Subject: Re: [PATCH] iwlwifi: don't panic in error path on non-msix systems
From:   Luca Coelho <luca@coelho.fi>
To:     Kirtika Ruchandani <kirtika@google.com>,
        Michal Hocko <mhocko@kernel.org>
Cc:     kvalo@codeaurora.org, Johannes Berg <johannes@sipsolutions.net>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        linuxwifi@intel.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>
Date:   Tue, 23 Apr 2019 16:27:32 +0300
In-Reply-To: <CAOXD1ic49hhkPb6ABPgBEim_iyxvDP82Hfn0yvz7vyFR4Rp53Q@mail.gmail.com>
References: <748205b02961167b0926d4afe8d9ad9cb37bf6ef.camel@coelho.fi>
         <20190417073516.24250-1-luca@coelho.fi>
         <20190422180723.GA20259@dhcp22.suse.cz>
         <CAOXD1idHq35qKy4PSjvqt4fEvVjgT6cpfxJD7s6gs07m43qepA@mail.gmail.com>
         <CAOXD1ic49hhkPb6ABPgBEim_iyxvDP82Hfn0yvz7vyFR4Rp53Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-04-22 at 19:34 -0700, Kirtika Ruchandani wrote:
> On Mon, Apr 22, 2019 at 4:56 PM Kirtika Ruchandani <
> kirtika@google.com> wrote:
> > On Mon, Apr 22, 2019 at 11:07 AM Michal Hocko <mhocko@kernel.org>
> > wrote:
> > > On Wed 17-04-19 10:35:16, Luca Coelho wrote:
> > > > From: Shahar S Matityahu <shahar.s.matityahu@intel.com>
> > > > 
> > > > The driver uses msix causes-register to handle both msix and
> > > > non msix
> > > > interrupts when performing sync nmi.  On devices that do not
> > > > support
> > > > msix this register is unmapped and accessing it causes a kernel
> > > > panic.
> > > > 
> > > > Solve this by differentiating the two cases and accessing the
> > > > proper
> > > > causes-register in each case.
> > 
> > Are you sure reading CSR_INT from trans.c without explicitly
> > getting irq_lock.c
> > like rx.c does, is thread-safe? I don't claim to understand this
> > fully, but this
> > smells wrong from past experience with this driver. I'll see if I
> > can cook up
> > a test case with a race condition here.
> 
> Sorry for the typos. I meant "writing (not reading) to CSR_INT in
> iwl_trans_pcie_sync_nmi
> without explicitly getting trans_pcie->irq_lock like
> iwl_pcie_irq_handler does".
> I spent some time playing around this, and while I don't have a
> black-and-white
> test-case to show this patch has side-effects (at the very least), I
> have some notes:
> 
> 1. Repeatedly sending fw_nmi is a good test-case for the problem this
> patch
> is trying to solve. i.e.  I had
> $ cd /sys/kernel/debug/iwlwifi/${PCI_ID}/iwlmvm/
> $ while true; do echo 1 > fw_nmi ; done  # this is likely too harsh
> and needs a sleep in b/w
> 
> With the current ToT driver in wireless-drivers-next, this ramoops-es
> super quickly after hitting
> the problematic MSI-X read.
> 
> 2. With this patch applied, I hit an ADVANCED_SYSASSERT 0x0 and it
> took ~800ms
> and dozens of kernel warnings before the driver "recovered".
> I've sent the full dmesg to Luca off-list.
> It didn't get any better with adding spin_lock(&trans_pcie->irq_lock)
> / spin_unlock(&trans_pcie->irq_lock)
> around the problematic CSR_INT write in iwl_trans_sync_nmi.
> 
> So I still don't have any concrete reasoning or proof, except a dmesg
> after a test that doesn't look right.
> Apologies if this discussion is moot - FWIW, the thing that caused a
> code smell in the first place
> was that historically, nothing in trans.c had mucked with writing to
> CSR_INT, except when enabling interrupts again
> with a 0xFFFFFFFF at _initialization time_ (and we've seen race
> conditions there in the past).
> You can check this with `git grep -p -w CSR_INT trans.c`.


Hi Kirtika,

I think the SYSASSERT issue you found is unrelated.  Can we track that
separately? Again, it seems that we're doing something wrong during
recovery, which causes the many warnings and long time to recover...

Regarding the spinlock, I'm not sure.  It seems that we don't need it,
because we're just writing to the register.  Maybe some of the other
blocks that are spinlocked must have a guarantee that no one will
change the register in the middle of it.  But before we add the
spinlocks, we should check if that really is the case.

We'll check the dmesg you sent us, but I think it's better to create a
new issue in the tracker for it.

--
Cheers,
Luca.

