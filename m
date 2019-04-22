Return-Path: <SRS0=tUzJ=SY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C88EC10F11
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 23:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60F8920665
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 23:56:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="buBuj9f4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbfDVX4T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Apr 2019 19:56:19 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:43634 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729484AbfDVX4S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Apr 2019 19:56:18 -0400
Received: by mail-oi1-f196.google.com with SMTP id t81so9821790oig.10
        for <linux-wireless@vger.kernel.org>; Mon, 22 Apr 2019 16:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WxRI1SxnMmuoUYu4OXHuMBaZUSvFVESEx/P0NYwM8zs=;
        b=buBuj9f4zXuqIXpMxUPgOU73BSulFe9EEaYzgYc1j5dMfKZq4WYvhimbY6AOq8IElt
         FqIygXi803XIHxXMNI2/9Dj2tPm8s5pPlJKoS90YWrdcZdINFxxcfxRnT6PMSrgu2Xwo
         1qdddvTpSIBObRaxbyYYGlRYCzpa4h3MMPYn2y0EzscD6c+clU17Y0/9Z6ra0OdvDS6I
         M17d5ufPSSA3Cempfjh4gzhYNuSZ3IDdXQ8qeqatWqeETr2mzx7Vd7/wJvQXagfYQWkQ
         Dv8+qRYXhi42wOHzZh70VMx/NG9mWIQW/NMajOu6i1Z0mwVw8FFr4dPq7KGugaumR+X5
         IpVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WxRI1SxnMmuoUYu4OXHuMBaZUSvFVESEx/P0NYwM8zs=;
        b=NjbNXLYNH+nq0ysjXkEDdAqtlbttxddbJggW+eLOMgdS6FYg9jNRAYlm2DIvVz2V+k
         W+3BM0rJdS30mJzJuhoJsM9X+OD+o7UpuHSL6xiGe/fpyNqSy8x83cEiYNmK2ndrQ+iG
         H/mP7XnDQHPotBH+sUJ+aI8/OdGefPiWOPFC+hkJOuQhxWC9zz2GBqaK7YFR24dvlCaW
         t8OpunuXuX+w3W2AKcGaxUlsi104VEhT4s98acUJzeYwgsy+4dBTofbnVfb44RzXzMyg
         7cZtH5C1tt7FafTpvXP8mnU4ok2RG2pSccH1tMlC6ABOu2SpnK4VmSIzDXZ6POR3hdki
         ROKg==
X-Gm-Message-State: APjAAAVUT0Uu9EyadrXFrMFBoVZIxjdMnAHKtoMFxzlR9Tz8/oq6D9wq
        5HH9ySlt4T2isN69Sa//Y/d2baGTsdBVEoTr9ybysAvL
X-Google-Smtp-Source: APXvYqxC3aDhJyIm3NZAgu8RFmQMCO8eer2kU9ljJ1ILfwfJouxkEu5lypjNvd7qO7H+vvnGS6hOOoTc9g1QNnnm8yg=
X-Received: by 2002:aca:e054:: with SMTP id x81mr3814oig.146.1555977376816;
 Mon, 22 Apr 2019 16:56:16 -0700 (PDT)
MIME-Version: 1.0
References: <748205b02961167b0926d4afe8d9ad9cb37bf6ef.camel@coelho.fi>
 <20190417073516.24250-1-luca@coelho.fi> <20190422180723.GA20259@dhcp22.suse.cz>
In-Reply-To: <20190422180723.GA20259@dhcp22.suse.cz>
From:   Kirtika Ruchandani <kirtika@google.com>
Date:   Mon, 22 Apr 2019 16:56:02 -0700
Message-ID: <CAOXD1idHq35qKy4PSjvqt4fEvVjgT6cpfxJD7s6gs07m43qepA@mail.gmail.com>
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

On Mon, Apr 22, 2019 at 11:07 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Wed 17-04-19 10:35:16, Luca Coelho wrote:
> > From: Shahar S Matityahu <shahar.s.matityahu@intel.com>
> >
> > The driver uses msix causes-register to handle both msix and non msix
> > interrupts when performing sync nmi.  On devices that do not support
> > msix this register is unmapped and accessing it causes a kernel panic.
> >
> > Solve this by differentiating the two cases and accessing the proper
> > causes-register in each case.

Are you sure reading CSR_INT from trans.c without explicitly getting irq_lock.c
like rx.c does, is thread-safe? I don't claim to understand this fully, but this
smells wrong from past experience with this driver. I'll see if I can cook up
a test case with a race condition here.

> >
> > Reported-by: Michal Hocko <mhocko@kernel.org>
> > Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>
> $ dmesg | grep "Error sending SCAN_CFG_CMD:"
> [49786.288548] iwlwifi 0000:01:00.0: Error sending SCAN_CFG_CMD: time out after 2000ms.
> [53457.166877] iwlwifi 0000:01:00.0: Error sending SCAN_CFG_CMD: time out after 2000ms.
>
> without the oops and with the iwlwifi internal dump IIUC which is the
> previous behavior.
> [53457.166877] iwlwifi 0000:01:00.0: Error sending SCAN_CFG_CMD: time out after 2000ms.
> [53457.166882] iwlwifi 0000:01:00.0: Current CMD queue read_ptr 224 write_ptr 225
> [53457.414973] iwlwifi 0000:01:00.0: HW error, resetting before reading
> [53457.421339] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
> [53457.421345] iwlwifi 0000:01:00.0: Status: 0x00000100, count: 1269232956
> [53457.421347] iwlwifi 0000:01:00.0: Loaded firmware version: 36.9f0a2d68.0
> [53457.421350] iwlwifi 0000:01:00.0: 0x45E91306 | ADVANCED_SYSASSERT
> [53457.421352] iwlwifi 0000:01:00.0: 0x2F58D384 | trm_hw_status0
> [53457.421353] iwlwifi 0000:01:00.0: 0x7F1A8CFD | trm_hw_status1
> [53457.421355] iwlwifi 0000:01:00.0: 0x07E787FD | branchlink2
> [53457.421357] iwlwifi 0000:01:00.0: 0xE9E54368 | interruptlink1
> [53457.421359] iwlwifi 0000:01:00.0: 0x470D9BBF | interruptlink2
> [53457.421361] iwlwifi 0000:01:00.0: 0xAF040E7E | data1
> [53457.421362] iwlwifi 0000:01:00.0: 0xE7FBCA48 | data2
> [53457.421364] iwlwifi 0000:01:00.0: 0x4E4A8288 | data3
> [53457.421366] iwlwifi 0000:01:00.0: 0x861DEA98 | beacon time
> [53457.421368] iwlwifi 0000:01:00.0: 0xE8F23466 | tsf low
> [53457.421369] iwlwifi 0000:01:00.0: 0xD7B19307 | tsf hi
> [53457.421371] iwlwifi 0000:01:00.0: 0xE58934E3 | time gp1
> [53457.421373] iwlwifi 0000:01:00.0: 0xB013FEBE | time gp2
> [53457.421375] iwlwifi 0000:01:00.0: 0x962DCC75 | uCode revision type
> [53457.421376] iwlwifi 0000:01:00.0: 0xFF8FB30F | uCode version major
> [53457.421378] iwlwifi 0000:01:00.0: 0x0DD08E17 | uCode version minor
> [53457.421380] iwlwifi 0000:01:00.0: 0x87FD70DE | hw version
> [53457.421382] iwlwifi 0000:01:00.0: 0x853F6851 | board version
> [53457.421384] iwlwifi 0000:01:00.0: 0x08D7F330 | hcmd
> [53457.421385] iwlwifi 0000:01:00.0: 0x6B7E5FEE | isr0
> [53457.421387] iwlwifi 0000:01:00.0: 0x2B1E7CD4 | isr1
> [53457.421389] iwlwifi 0000:01:00.0: 0x3F133B16 | isr2
> [53457.421391] iwlwifi 0000:01:00.0: 0x5D480C5A | isr3
> [53457.421392] iwlwifi 0000:01:00.0: 0x34E93EBA | isr4
> [53457.421394] iwlwifi 0000:01:00.0: 0x42AD8E83 | last cmd Id
> [53457.421396] iwlwifi 0000:01:00.0: 0x1F5BBCFF | wait_event
> [53457.421398] iwlwifi 0000:01:00.0: 0x6808B2C1 | l2p_control
> [53457.421399] iwlwifi 0000:01:00.0: 0x0D5B1F33 | l2p_duration
> [53457.421401] iwlwifi 0000:01:00.0: 0xF4C94535 | l2p_mhvalid
> [53457.421403] iwlwifi 0000:01:00.0: 0x3DCE6EBB | l2p_addr_match
> [53457.421405] iwlwifi 0000:01:00.0: 0xFDDC41FE | lmpm_pmg_sel
> [53457.421406] iwlwifi 0000:01:00.0: 0xB53A17F5 | timestamp
> [53457.421408] iwlwifi 0000:01:00.0: 0x5A6A4113 | flow_handler
> [53457.421474] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
> [53457.421477] iwlwifi 0000:01:00.0: Status: 0x00000100, count: 1182976748
> [53457.421478] iwlwifi 0000:01:00.0: 0x62D2BDB3 | ADVANCED_SYSASSERT
> [53457.421480] iwlwifi 0000:01:00.0: 0x4D9E5019 | umac branchlink1
> [53457.421482] iwlwifi 0000:01:00.0: 0x8CB69F6E | umac branchlink2
> [53457.421484] iwlwifi 0000:01:00.0: 0x9868662D | umac interruptlink1
> [53457.421486] iwlwifi 0000:01:00.0: 0x9800F8F7 | umac interruptlink2
> [53457.421488] iwlwifi 0000:01:00.0: 0xC71449B8 | umac data1
> [53457.421489] iwlwifi 0000:01:00.0: 0xAB0AB17F | umac data2
> [53457.421491] iwlwifi 0000:01:00.0: 0x6C6F9753 | umac data3
> [53457.421493] iwlwifi 0000:01:00.0: 0xFC49D724 | umac major
> [53457.421495] iwlwifi 0000:01:00.0: 0xA61CC627 | umac minor
> [53457.421496] iwlwifi 0000:01:00.0: 0x45BAA0B8 | frame pointer
> [53457.421498] iwlwifi 0000:01:00.0: 0x319D112B | stack pointer
> [53457.421500] iwlwifi 0000:01:00.0: 0xEFD9E2E9 | last host cmd
> [53457.421502] iwlwifi 0000:01:00.0: 0x82640FF7 | isr status reg
> [53457.421506] ieee80211 phy0: Hardware restart was requested
> [53457.941685] iwlwifi 0000:01:00.0: Queue 0 is inactive on fifo 0 and stuck for 2500 ms. SW [224, 225] HW [0, 0] FH TRB=0x02b759ca1
>
> Feel free to add
> Tested-by: Michal Hocko <mhocko@suse.com>
>
> Thanks for your quick patch and sorry it took so long from my side.
>
> --
> Michal Hocko
> SUSE Labs
