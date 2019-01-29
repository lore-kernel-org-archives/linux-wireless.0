Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D61C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 09:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF90A20870
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 09:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbfA2J5N (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 04:57:13 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37584 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbfA2J5M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 04:57:12 -0500
Received: by mail-wm1-f67.google.com with SMTP id g67so16994448wmd.2
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2019 01:57:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GdWoVH7y+ay6+wG7XLoQ0pRM4nEtAIkhCG+BNUUiqEU=;
        b=axMFgLUKp/O7I7LE6tBFRNlUHrw3UqsO6r+afBM9jjX7TSsXetTIwZlBbQV6Ncqya2
         E25RyXDzjeVTIqTUspV9Ck00vqEOaT1aVL893/YTzgh3ZuUZ6jaj1tUoiD8aewH5HaSv
         FFd5ui2KrSBlb5H9W1kQJth19ZfJ9vcwWotD2N9jkSPQ1hpUYciLwJazlGtvxK5VIIn6
         zQOavHt4Q66CG/+cAjaP1kWoBkMrjwOBqi6kW+4PfwxQCSVeKImmOPhOAN+f58haDd7B
         TTjNVPEfZi0n7gCJd39h81usZbQSXMcitzWAohvzMLsCuX1nPt8YRSEwU7oHsbseUV8Y
         t/mQ==
X-Gm-Message-State: AHQUAuayzwTQLzbETEzTWF3w4gN5Z2tqQJtGm5pbEBL4gJciocWoyo5b
        SOg/UamxZyn17eo+yK4SKcVDMg==
X-Google-Smtp-Source: AHgI3Ib5/JgF/4lQkO3zAEVKx1KbaEFX/0iTEHKacmLxFF4xqkWxmR/nhoOPoJD7wjLOOv5rZPqeAw==
X-Received: by 2002:a1c:e10a:: with SMTP id y10mr10983897wmg.73.1548755830745;
        Tue, 29 Jan 2019 01:57:10 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id n82sm1864089wma.42.2019.01.29.01.57.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jan 2019 01:57:10 -0800 (PST)
Date:   Tue, 29 Jan 2019 10:57:07 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH wireless-drivers] mt76x0: eeprom: fix chan_vs_power map
 in mt76x0_get_power_info
Message-ID: <20190129095706.GA2460@localhost.localdomain>
References: <cover.1548587542.git.lorenzo.bianconi@redhat.com>
 <44789d3d0dee6e2e0bb7d75f755927d415aa56d4.1548587542.git.lorenzo.bianconi@redhat.com>
 <87tvhstujr.fsf@purkki.adurom.net>
 <20190128205002.GA2165@localhost.localdomain>
 <87bm40ym88.fsf@codeaurora.org>
 <CAJ0CqmVPK6R45F511Bnc4EXGFkEnwRsYhPTGpfvy59v8RbsOBg@mail.gmail.com>
 <87o97zx01i.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o97zx01i.fsf@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> 
> >>
> >> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> >>
> >> >> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> >> >>
> >> >> > Report correct eeprom per channel power value.
> >> >> > Fix chan_vs_power map in mt76x0_get_power_info routine
> >> >> >
> >> >> > Fixes: f2a2e819d672 ("mt76x0: remove eeprom dependency from mt76x0_get_power_info")
> >> >> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> >> >>
> >> >> So what's the actual bug this fixes? The commit log is not really clear
> >> >> on that. Wondering because you marked this for wireless-drivers.
> >> >
> >> > Hi Kalle,
> >> >
> >> > You are right, I have been not so clear in the commit log.
> >> > Offsets in chan_map were wrong since mt76x02_eeprom_get() reads at even addresses.
> >> > Moreover 'if' condition in the for loop was wrong (chan->hw_value and
> >> > chan_map[i].chan were swapped)
> >>
> >> But how does this affect from user's point of view? I mean what feature
> >> is broken and how does this fix that?
> >>
> >> --
> >> Kalle Valo
> >
> > mt76x0_get_power_info() is used to read from eeprom the global max tx
> > power according to the operating channel.
> > mt76x02_eeprom_get() reads just at even addresses and it reports -1
> > for odd ones (so offset must be a even).
> > This issue will affect the tx power that userspace is able to configure.
> > Do you think it is better to merge it in wireless-drivers-next?
> 
> Ok, I think this is fine for wireless-drivers. I just want to understand
> the bug being fixed before I apply the patch to w-d.
> 
> If no objections I'll queue this for 5.0.

ack, thx. I will be more clear next time :)

Regards,
Lorenzo

> 
> -- 
> Kalle Valo
