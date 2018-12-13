Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE53CC67839
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 701202086D
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:55:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rsalveti-net.20150623.gappssmtp.com header.i=@rsalveti-net.20150623.gappssmtp.com header.b="wKvPuvl/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 701202086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rsalveti.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbeLMOzw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 09:55:52 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41368 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728947AbeLMOzw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 09:55:52 -0500
Received: by mail-lf1-f67.google.com with SMTP id c16so1772323lfj.8
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2018 06:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rsalveti-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UuQVOzrXAfQSriIdjqRxDkVOGHp6Zmlx9hsRucn61FQ=;
        b=wKvPuvl/fwFdQDonAUNM7TC0B9Ka4dT0deegFXAmhi6O2xVuX1VK8IgrmuqLSBuwju
         gvAlDCJW00dSY2tDUh5A5J473OfJDJsWko0iuy1wDlWjvPFchz1Bdds3BXLZIAcY8b2d
         gpyDuwB7d/F1OTKru1+LJWwf+ghN4DXVCE3aZZhN4TYX2XAuzfF9NURi64u9RYaVIZ2w
         2MSWyQn7j2KVzrDuj8Yf+UVZ8wEfO4Ec1r/jmQAjPmjSbT78K8QjQ0CdcYaDVrQ3DgvD
         ib238Qv+SxKCQmraK6qwzoxtJL9I60e3mB031m8FWrLmil2r8xeKXxUL6/tqncbU9CTs
         1LjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UuQVOzrXAfQSriIdjqRxDkVOGHp6Zmlx9hsRucn61FQ=;
        b=Ckd3/HNVaczc9URMytt87+aVDRdcmSzWWWOAPa90zCHdA+ziJPW/3vpGoimjLQNfvM
         RQO6kMpPdVMVKDOVGAaLhEhMCKR0xLsboi4yBSK+kJSnUnwDKn4Zu5aCZjw71hVBPVd9
         eHUJDhHLmfc59L9iQCkJ5shRuJtChfN2A/+vrqIbrICbpDpN6iWpBzBziLRbbGhz34f7
         W5gKPlQKmCxpSb02kxF2J1boQiCxjVcZcDTxsFGOYTC4+FM+96qvm1AzITHsLQLWQ1dj
         KgqTfF0h6WCCBAE+okSjoGofAD+moecFHlNQWCgjFKa6QBQsdcLVB6RGZIRPo1CjuFRC
         YUIg==
X-Gm-Message-State: AA+aEWYqdS3EgkSpVS4ZCMQ+aJ7sK9cwRDj4cPDPnZnMu6mGNM7WKFc0
        DCn7onW8owABVLxFovhjAqMLrhPmEZUG19UFWAbo2A==
X-Google-Smtp-Source: AFSGD/Xln6autsgxvcaXMsNvhziWMHQg6PpGYh89LpyRQe8Je9Sbh8106ve4Uh7muoHE+uwpdvzF/Vnlgj+mbaWimjE=
X-Received: by 2002:a19:cc46:: with SMTP id c67mr14134444lfg.145.1544712949804;
 Thu, 13 Dec 2018 06:55:49 -0800 (PST)
MIME-Version: 1.0
References: <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
 <20181211201221.GY39861@atomide.com> <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
 <CAHYQr0qhqce2QcwMLRMWnqhZTL4KzHKJLzt6tfCNLHUcEt9pyQ@mail.gmail.com>
 <20181212014556.GC39861@atomide.com> <c8625c42f04a4721b7efb7d7b6b3931c@ti.com>
 <20181212183116.GH39861@atomide.com> <CAHYQr0ojkf3CvFb_zuEK4Vuz1w-rm9Sb=+dk5BkqYkWoxy8+aQ@mail.gmail.com>
 <9060b4655e064665a1812d9fae00f1ec@ti.com> <CAHYQr0r4eQNSqZEr-vbCiVN6G_O1CXxX9cxemANSRY-jqDMZ=A@mail.gmail.com>
 <20181213144522.GO39861@atomide.com> <12a609f677aa48f8b2aadba69edf342a@ti.com>
In-Reply-To: <12a609f677aa48f8b2aadba69edf342a@ti.com>
From:   Ricardo Salveti <rsalveti@rsalveti.net>
Date:   Thu, 13 Dec 2018 12:55:12 -0200
Message-ID: <CAHYQr0onjCz4YqrWoqLYu+omYmn_e2+uwWGCBFvkNf+kupYucQ@mail.gmail.com>
Subject: Re: [EXTERNAL] Re: wlcore getting stuck on hikey after the runtime PM
 autosuspend support change
To:     eyalr@ti.com
Cc:     Tony Lindgren <tony@atomide.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, anders.roxell@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Dec 13, 2018 at 12:53 PM Reizer, Eyal <eyalr@ti.com> wrote:
> > > I tried just increasing WL1271_PRE_POWER_ON_SLEEP from 20ms to
> > 50ms
> > > (which gets used before calling wl12xx_sdio_power_on), and that was
> > > already enough to fix my issues on both hikey and beaglebone black
> > > wireless.
> >
> > OK good to hear that helps :)
> >
> > > Should we define another pre power on sleep specifically for the sdio
> > > case (and use directly in wl12xx_sdio_power_on)?
> >
> > I'd probably prefer to just increase WL1271_PRE_POWER_ON_SLEEP,
> > chances are the same delay is needed in all cases.
> >
> > Up to Eyeal to decide though as far as I'm concerned.
> >
>
> I tend to agree with Tony. Probably better to just increase the value.

Cool, will do a bit more stress testing and send the patch then.

Thanks,
-- 
Ricardo Salveti de Araujo
