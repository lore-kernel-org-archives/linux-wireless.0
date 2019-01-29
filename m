Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 749E6C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 12:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FE6A2083B
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 12:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfA2MlC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 07:41:02 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36047 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbfA2MlC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 07:41:02 -0500
Received: by mail-wr1-f65.google.com with SMTP id u4so21890609wrp.3
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2019 04:41:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lkNhQ2BBOGOWkitn7PXcWt8ps41CvM+FFdqdxDrKXaM=;
        b=TUeUqRAFvqFT3YWrOBpKjkhg3PeRKRPPbIMFeoLbDsessGTDgI1No7Zqct2arFrIJy
         58ORjN9evMHr7JW2Fj8bxHHA2czrjb4zIvK/reY3YlAzGkkS7stWGzeLMvx92VXgAx0c
         7pBjMRtkXKAcp7JaqiwrgAAEQaSC6qQ9wcwKQ2dceX5/FI1cJsPSfwQOY0KPYDcPslyl
         3SuUSGgZnIie38JNmvN7uyk3ZUzYVmXrqz5fGY//PCusQM128tQTvkAFDmLsBnLQOo2H
         6ngEZZC7O33ZMsxwkfRzTSApFph3QecRcQMMLRQsxULorte4XxNsTFAmSpRiNZSWnK06
         WB4w==
X-Gm-Message-State: AJcUuketx/0bodQ5UBKe8dijso6HsyaltfQbgsYDzVotwOwIup7PJ1M7
        k70VG3CUDBVUL4vxehmSCBqpPQ==
X-Google-Smtp-Source: ALg8bN7uMutyPbyNu57Oz3B9/fuzqubx+5k4NZqXQ37jHv1HWJZiglheR+dsIb+4Pi/zHFnpYhb+fg==
X-Received: by 2002:a5d:4f10:: with SMTP id c16mr26518975wru.177.1548765660236;
        Tue, 29 Jan 2019 04:41:00 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s16sm99417775wrt.77.2019.01.29.04.40.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jan 2019 04:40:59 -0800 (PST)
Date:   Tue, 29 Jan 2019 13:40:57 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 0/7] mt76x02: Beacon support for USB
Message-ID: <20190129124056.GB2460@localhost.localdomain>
References: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
 <87a7jju1mv.fsf@purkki.adurom.net>
 <8ec3b133-49eb-3c5f-4c3c-bc2bb4e84cde@nbd.name>
 <87k1inwtu5.fsf@codeaurora.org>
 <b6fb4aec-5e65-53aa-e14b-c1230e797786@nbd.name>
 <87fttbwtav.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fttbwtav.fsf@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Felix Fietkau <nbd@nbd.name> writes:
> 
> > On 2019-01-29 13:07, Kalle Valo wrote:
> >> Felix Fietkau <nbd@nbd.name> writes:
> >> 
> >>> On 2019-01-29 12:47, Kalle Valo wrote:
> >>>> Stanislaw Gruszka <sgruszka@redhat.com> writes:
> >>>> 
> >>>>> We can configure beaconing, but without TBTT interrupt we
> >>>>> can not support PS buffering. This can be added later using
> >>>>> kernel hrtimer, if we can keep it in sycn with device timer.
> >>>>>
> >>>>> I tested AP and IBSS modes.
> >>>> 
> >>>> So how does this work reliably so that there's no packet loss with
> >>>> clients using power save?
> >>>
> >>> There will be multicast packet loss for clients using power save.
> >> 
> >> Isn't that a problem? At least as a normal user I would very frustrated
> >> if sometimes my connection work and sometimes not, for example if I'm
> >> trying discover devices from my network. Hopefully nobody won't use USB
> >> devices for any real AP stuff, but still enabling something which we
> >> know doesn't work realiably is concerning.
> >
> > I agree. Maybe we should leave out the flag for AP mode in this patch
> > until we have PS buffering and leave the rest of the code intact.
> 
> At least for me that sounds good.

We can support ps buffering in AP as well using a hrtimer. In this way we
can reuse most of the existing code

Regards,
Lorenzo

> 
> -- 
> Kalle Valo
