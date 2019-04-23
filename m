Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BFDEC282E1
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 02:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB8B620896
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 02:35:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fKqXPPex"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730957AbfDWCfL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Apr 2019 22:35:11 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:39126 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730710AbfDWCfK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Apr 2019 22:35:10 -0400
Received: by mail-oi1-f195.google.com with SMTP id n187so10072981oih.6
        for <linux-wireless@vger.kernel.org>; Mon, 22 Apr 2019 19:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/I/Tf1VpKsvh5Uxp8CHXyH8KfnFBPHA/kp4u9RlX6VQ=;
        b=fKqXPPex1zl43XCAtjRz/NKH+nGg6RJa2Av7fTJKoQhryih3wGvi/BqCUx+78S3ye9
         jpKh45oml9kcDDTLjL+XSlgzOWsLERkYnoG+zyzEljjYVUz9pUCJvjZWTTUycw3yeWjv
         2PPc60XnFADuXbMiySBXQo+yuDQVW6A8biuxh2iKRH9loitvvhAXwK4+9Rv1D+bRT4oP
         H/gtI1lM48x0nYG3fNzGpdZAdWmiUOLXfnMZdCJAOOQ/4QhrhV4I+ExcltoF6bCiuLgn
         jRql9OFZQ16rVJTnuA3LrGgSiUsviN5TFZvGWcM1COa1D/xJmfBmu8WguOVFIrG8vtux
         GRgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/I/Tf1VpKsvh5Uxp8CHXyH8KfnFBPHA/kp4u9RlX6VQ=;
        b=ajsbv6pi+CCi8xbZTWiKgoOZpvyGYkhd5gdDT1XcpTjE65rl9q7FLykq5zf/TfVFjL
         WLSeVFX5brVrQGhJTBNYuCeGXyNKDZEHIPaBaU9FIac7mnIRZDi+FaVYRM0At+bNQjI+
         /HFD/ntsh/wt2QdS76kaWV2ilR1Vp+jIFQy0zDgQntnPC99TVN5kf+MX3RvIhHJOaV0D
         5XpGToRqx9OAZQBS269imtPsrnSnvCmsKHBG3UMtCB3hTgzkjSEhOxUCEA/vgdi1K60l
         4A434BmqjgGQR1rD8eDETIPglFauelf371s+HGINKfqFwrT72uigf5JZJrAiRvr0A2XN
         SVsg==
X-Gm-Message-State: APjAAAUgGrn3ilXD2hgK8sJsMF/eOQDpl0N8hQdzwjqAmzjFND0kMMYc
        XnO1tTXKynYaVDUhXGc0B7UdbINhIqxWTOpmf9ee3w==
X-Google-Smtp-Source: APXvYqzaIYt+nXa2vXaE8gCFX78l2hGhNYsEIE+bQGBg9AIZgpkx5tI9u+hx/qukjCmMu1LlDBDdn406wQ1VXZFhmF4=
X-Received: by 2002:aca:bd02:: with SMTP id n2mr325451oif.70.1555986908203;
 Mon, 22 Apr 2019 19:35:08 -0700 (PDT)
MIME-Version: 1.0
References: <748205b02961167b0926d4afe8d9ad9cb37bf6ef.camel@coelho.fi>
 <20190417073516.24250-1-luca@coelho.fi> <20190422180723.GA20259@dhcp22.suse.cz>
 <CAOXD1idHq35qKy4PSjvqt4fEvVjgT6cpfxJD7s6gs07m43qepA@mail.gmail.com>
In-Reply-To: <CAOXD1idHq35qKy4PSjvqt4fEvVjgT6cpfxJD7s6gs07m43qepA@mail.gmail.com>
From:   Kirtika Ruchandani <kirtika@google.com>
Date:   Mon, 22 Apr 2019 19:34:54 -0700
Message-ID: <CAOXD1ic49hhkPb6ABPgBEim_iyxvDP82Hfn0yvz7vyFR4Rp53Q@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: don't panic in error path on non-msix systems
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Luca Coelho <luca@coelho.fi>, kvalo@codeaurora.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        linuxwifi@intel.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Apr 22, 2019 at 4:56 PM Kirtika Ruchandani <kirtika@google.com> wrote:
>
> On Mon, Apr 22, 2019 at 11:07 AM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Wed 17-04-19 10:35:16, Luca Coelho wrote:
> > > From: Shahar S Matityahu <shahar.s.matityahu@intel.com>
> > >
> > > The driver uses msix causes-register to handle both msix and non msix
> > > interrupts when performing sync nmi.  On devices that do not support
> > > msix this register is unmapped and accessing it causes a kernel panic.
> > >
> > > Solve this by differentiating the two cases and accessing the proper
> > > causes-register in each case.
>
> Are you sure reading CSR_INT from trans.c without explicitly getting irq_lock.c
> like rx.c does, is thread-safe? I don't claim to understand this fully, but this
> smells wrong from past experience with this driver. I'll see if I can cook up
> a test case with a race condition here.

Sorry for the typos. I meant "writing (not reading) to CSR_INT in
iwl_trans_pcie_sync_nmi
without explicitly getting trans_pcie->irq_lock like iwl_pcie_irq_handler does".
I spent some time playing around this, and while I don't have a black-and-white
test-case to show this patch has side-effects (at the very least), I
have some notes:

1. Repeatedly sending fw_nmi is a good test-case for the problem this patch
is trying to solve. i.e.  I had
$ cd /sys/kernel/debug/iwlwifi/${PCI_ID}/iwlmvm/
$ while true; do echo 1 > fw_nmi ; done  # this is likely too harsh
and needs a sleep in b/w

With the current ToT driver in wireless-drivers-next, this ramoops-es
super quickly after hitting
the problematic MSI-X read.

2. With this patch applied, I hit an ADVANCED_SYSASSERT 0x0 and it took ~800ms
and dozens of kernel warnings before the driver "recovered".
I've sent the full dmesg to Luca off-list.
It didn't get any better with adding spin_lock(&trans_pcie->irq_lock)
/ spin_unlock(&trans_pcie->irq_lock)
around the problematic CSR_INT write in iwl_trans_sync_nmi.

So I still don't have any concrete reasoning or proof, except a dmesg
after a test that doesn't look right.
Apologies if this discussion is moot - FWIW, the thing that caused a
code smell in the first place
was that historically, nothing in trans.c had mucked with writing to
CSR_INT, except when enabling interrupts again
with a 0xFFFFFFFF at _initialization time_ (and we've seen race
conditions there in the past).
You can check this with `git grep -p -w CSR_INT trans.c`.

> > >
> > > Reported-by: Michal Hocko <mhocko@kernel.org>
> > > Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
> > > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> >
> > $ dmesg | grep "Error sending SCAN_CFG_CMD:"
> > [49786.288548] iwlwifi 0000:01:00.0: Error sending SCAN_CFG_CMD: time out after 2000ms.
> > [53457.166877] iwlwifi 0000:01:00.0: Error sending SCAN_CFG_CMD: time out after 2000ms.
> >
> > without the oops and with the iwlwifi internal dump IIUC which is the
> > previous behavior.
> > [53457.166877] iwlwifi 0000:01:00.0: Error sending SCAN_CFG_CMD: time out after 2000ms.
> > [53457.166882] iwlwifi 0000:01:00.0: Current CMD queue read_ptr 224 write_ptr 225
> > [53457.414973] iwlwifi 0000:01:00.0: HW error, resetting before reading
> > [53457.421339] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
> > [53457.421345] iwlwifi 0000:01:00.0: Status: 0x00000100, count: 1269232956
> > [53457.421347] iwlwifi 0000:01:00.0: Loaded firmware version: 36.9f0a2d68.0
> > [53457.421350] iwlwifi 0000:01:00.0: 0x45E91306 | ADVANCED_SYSASSERT
> > [53457.421352] iwlwifi 0000:01:00.0: 0x2F58D384 | trm_hw_status0
> > [53457.421353] iwlwifi 0000:01:00.0: 0x7F1A8CFD | trm_hw_status1
> > [53457.421355] iwlwifi 0000:01:00.0: 0x07E787FD | branchlink2
> > [53457.421357] iwlwifi 0000:01:00.0: 0xE9E54368 | interruptlink1
> > [53457.421359] iwlwifi 0000:01:00.0: 0x470D9BBF | interruptlink2
> > [53457.421361] iwlwifi 0000:01:00.0: 0xAF040E7E | data1
> > [53457.421362] iwlwifi 0000:01:00.0: 0xE7FBCA48 | data2
> > [53457.421364] iwlwifi 0000:01:00.0: 0x4E4A8288 | data3
> > [53457.421366] iwlwifi 0000:01:00.0: 0x861DEA98 | beacon time
> > [53457.421368] iwlwifi 0000:01:00.0: 0xE8F23466 | tsf low
> > [53457.421369] iwlwifi 0000:01:00.0: 0xD7B19307 | tsf hi
> > [53457.421371] iwlwifi 0000:01:00.0: 0xE58934E3 | time gp1
> > [53457.421373] iwlwifi 0000:01:00.0: 0xB013FEBE | time gp2
> > [53457.421375] iwlwifi 0000:01:00.0: 0x962DCC75 | uCode revision type
> > [53457.421376] iwlwifi 0000:01:00.0: 0xFF8FB30F | uCode version major
> > [53457.421378] iwlwifi 0000:01:00.0: 0x0DD08E17 | uCode version minor
> > [53457.421380] iwlwifi 0000:01:00.0: 0x87FD70DE | hw version
> > [53457.421382] iwlwifi 0000:01:00.0: 0x853F6851 | board version
> > [53457.421384] iwlwifi 0000:01:00.0: 0x08D7F330 | hcmd
> > [53457.421385] iwlwifi 0000:01:00.0: 0x6B7E5FEE | isr0
> > [53457.421387] iwlwifi 0000:01:00.0: 0x2B1E7CD4 | isr1
> > [53457.421389] iwlwifi 0000:01:00.0: 0x3F133B16 | isr2
> > [53457.421391] iwlwifi 0000:01:00.0: 0x5D480C5A | isr3
> > [53457.421392] iwlwifi 0000:01:00.0: 0x34E93EBA | isr4
> > [53457.421394] iwlwifi 0000:01:00.0: 0x42AD8E83 | last cmd Id
> > [53457.421396] iwlwifi 0000:01:00.0: 0x1F5BBCFF | wait_event
> > [53457.421398] iwlwifi 0000:01:00.0: 0x6808B2C1 | l2p_control
> > [53457.421399] iwlwifi 0000:01:00.0: 0x0D5B1F33 | l2p_duration
> > [53457.421401] iwlwifi 0000:01:00.0: 0xF4C94535 | l2p_mhvalid
> > [53457.421403] iwlwifi 0000:01:00.0: 0x3DCE6EBB | l2p_addr_match
> > [53457.421405] iwlwifi 0000:01:00.0: 0xFDDC41FE | lmpm_pmg_sel
> > [53457.421406] iwlwifi 0000:01:00.0: 0xB53A17F5 | timestamp
> > [53457.421408] iwlwifi 0000:01:00.0: 0x5A6A4113 | flow_handler
> > [53457.421474] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
> > [53457.421477] iwlwifi 0000:01:00.0: Status: 0x00000100, count: 1182976748
> > [53457.421478] iwlwifi 0000:01:00.0: 0x62D2BDB3 | ADVANCED_SYSASSERT
> > [53457.421480] iwlwifi 0000:01:00.0: 0x4D9E5019 | umac branchlink1
> > [53457.421482] iwlwifi 0000:01:00.0: 0x8CB69F6E | umac branchlink2
> > [53457.421484] iwlwifi 0000:01:00.0: 0x9868662D | umac interruptlink1
> > [53457.421486] iwlwifi 0000:01:00.0: 0x9800F8F7 | umac interruptlink2
> > [53457.421488] iwlwifi 0000:01:00.0: 0xC71449B8 | umac data1
> > [53457.421489] iwlwifi 0000:01:00.0: 0xAB0AB17F | umac data2
> > [53457.421491] iwlwifi 0000:01:00.0: 0x6C6F9753 | umac data3
> > [53457.421493] iwlwifi 0000:01:00.0: 0xFC49D724 | umac major
> > [53457.421495] iwlwifi 0000:01:00.0: 0xA61CC627 | umac minor
> > [53457.421496] iwlwifi 0000:01:00.0: 0x45BAA0B8 | frame pointer
> > [53457.421498] iwlwifi 0000:01:00.0: 0x319D112B | stack pointer
> > [53457.421500] iwlwifi 0000:01:00.0: 0xEFD9E2E9 | last host cmd
> > [53457.421502] iwlwifi 0000:01:00.0: 0x82640FF7 | isr status reg
> > [53457.421506] ieee80211 phy0: Hardware restart was requested
> > [53457.941685] iwlwifi 0000:01:00.0: Queue 0 is inactive on fifo 0 and stuck for 2500 ms. SW [224, 225] HW [0, 0] FH TRB=0x02b759ca1
> >
> > Feel free to add
> > Tested-by: Michal Hocko <mhocko@suse.com>
> >
> > Thanks for your quick patch and sorry it took so long from my side.
> >
> > --
> > Michal Hocko
> > SUSE Labs
