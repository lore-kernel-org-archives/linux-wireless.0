Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9B2C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 13:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49C3B21736
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 13:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfAGN0x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 08:26:53 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50363 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbfAGN0w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 08:26:52 -0500
Received: by mail-wm1-f68.google.com with SMTP id n190so882883wmd.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2019 05:26:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gWtfqtwwXsroEOno3osSOx/NrKH4lWMnTvckcV0LI8k=;
        b=Cwfbp7J2kclMKRAtl1q1dEDMw/sgTnIaB5CsRieePkpZX/fmicVnzfQ5ypsPLd4qWH
         efpcMH20fYV1HM+POrF24z49VEWLP11szupYzcBuMH6co1cmOH/MRt1yMpfnquWCDYJZ
         rpqhN4ukPJ4Dga2ifYV009NtmbijmtzcI9b0IuyrO6KQ40IK/CbTcWgKslxA24zsVMC2
         uVSDjuvxEiLn5G39LAWvpmh4KdAeXNTjjJ48BO6PUHac4Ltv3e8jN6sK7cduUbRc+MC/
         5xFRAKMCUly77cAxiM2/0u6b7onT8hW12KgSmfkfjM0R52HEfsVGr6J31UQg78V0R7vH
         VhcA==
X-Gm-Message-State: AJcUukcRyO7lqXvkyLPfYT/uvOjj/MmYkRijaG3/cyZ3mUw3zJ2kEwXg
        kG1oxul6Jq7z0UohoOygoLjWqQ==
X-Google-Smtp-Source: ALg8bN6AfMR/CeE27jf0LeDQPI9MYMa6t/RC9YHocFnQee5dIEzn+PN8ojS0k3FMA9YxhkowivsXlg==
X-Received: by 2002:a1c:ab87:: with SMTP id u129mr8790996wme.104.1546867611245;
        Mon, 07 Jan 2019 05:26:51 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id q3sm54941038wrn.84.2019.01.07.05.26.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Jan 2019 05:26:50 -0800 (PST)
Date:   Mon, 7 Jan 2019 14:26:48 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@01.org, nbd@nbd.name,
        linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: Re: [PATCH v2] mt76: mmio: introduce mt76x02_check_tx_hang watchdog
Message-ID: <20190107132647.GA4645@localhost.localdomain>
References: <82a9efd24a70b701808d4ecd8ad2c8289463ae35.1546004654.git.lorenzo.bianconi@redhat.com>
 <201812290207.LUUmFHNB%fengguang.wu@intel.com>
 <87ef9o7i2n.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ef9o7i2n.fsf@purkki.adurom.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> kbuild test robot <lkp@intel.com> writes:
> 
> > Hi Lorenzo,
> >
> > I love your patch! Yet something to improve:
> >
> > [auto build test ERROR on wireless-drivers-next/master]
> > [also build test ERROR on next-20181224]
> > [cannot apply to v4.20]
> > [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> >
> > url:    https://github.com/0day-ci/linux/commits/Lorenzo-Bianconi/mt76-mmio-introduce-mt76x02_check_tx_hang-watchdog/20181228-224737
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
> > config: i386-randconfig-sb0-12290140 (attached as .config)
> > compiler: gcc-4.9 (Debian 4.9.4-2) 4.9.4
> > reproduce:
> >         # save the attached .config to linux build tree
> >         make ARCH=i386 
> >
> > All errors (new ones prefixed by >>):
> >
> >    In file included from drivers/net/wireless/mediatek/mt76/mt76x02.h:23:0,
> >                     from drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c:21:
> >    drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c: In function 'mt76x02_watchdog_reset':
> >>> drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c:435:36: error: 'MT_TXOP_ED_CCA_EN' undeclared (first use in this function)
> 
> Didn't check the sources but looks like a valid error to me. Can you fix
> this, please?

Hi Kalle,

This patch needs to be applied on top of 'add EDCCA support to mt76x{0,2}e drivers'
series (https://patchwork.kernel.org/cover/10727149/). I forgot to
point it out, sorry. However Felix has already applied them in the correct order,
so nothing to do here.

Regards,
Lorenzo

> 
> -- 
> Kalle Valo
