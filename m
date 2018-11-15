Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7830EC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 18:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3777A2146D
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 18:44:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="E0m6Svp+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3777A2146D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388329AbeKPExE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 23:53:04 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38329 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbeKPExE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 23:53:04 -0500
Received: by mail-pl1-f196.google.com with SMTP id p4-v6so9887593plo.5
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2018 10:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MJqJPDLhiEc6Ze//c46l5fgBIbQKAy8EIF1v7Gp3a8g=;
        b=E0m6Svp+IStTIctOI1e3eB9HDoju1P1u6HlVf2sQaTFSNcCmKiwkt0i5N4EMcxTB22
         O7m2n8k++Z/9eYYTa48p4RkI9EjWmFkCy7khrCPlBCD1F1fnbTNEWMH+09LLrtq/Tmjk
         kII6+geQCAQSzCk/0C0T78fpyJqkEjr1uDsx0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MJqJPDLhiEc6Ze//c46l5fgBIbQKAy8EIF1v7Gp3a8g=;
        b=XwOlneBsd5TomvjSA3KrX4/ElrPru7y3it8hVIkoTRPlPJ0l84M7cixWXrFrCVfcKv
         tRbaSoUQan4sYu18zcrjDEUHsEAAS8630MdQuqwteo+4Jo38EQl9UQzEzw757YF2wPIw
         tXhJlVvXk9NylihUAqfEx50J+DKbiOIqM0e4/u9BDHHYve9PeWiAdozfxw8+xpo4nwBb
         xmuya8mQEnxnte6Q7p8yn6M5RKqIboAYjTtNXqG1N9iHBnxbf7FUz/zRMDew/AS8hukU
         rxZWvwUI9b8cdhAxCGYenebyZCcK+NnnObJRTcPRv+dCTogjp7rMfuuYgg5adG5Spg/R
         lEQA==
X-Gm-Message-State: AGRZ1gLqgzJWGQCP1eTS0yNxXy3wKRSfL8UHvbjhtqnM0h3qfJWvNMwH
        kagSBbxBOFxl+h8oTUfRvI4KYg==
X-Google-Smtp-Source: AJdET5ecljU/Ke8j4pdj7P58IFuPg525lnA/sboKj0dJKU4zsR2/qzj5Hn3ADX0/7g/0pEWb1RwZIg==
X-Received: by 2002:a17:902:9a04:: with SMTP id v4-v6mr7240995plp.247.1542307448314;
        Thu, 15 Nov 2018 10:44:08 -0800 (PST)
Received: from google.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id t4-v6sm29064911pfh.21.2018.11.15.10.43.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Nov 2018 10:43:52 -0800 (PST)
Date:   Thu, 15 Nov 2018 10:43:33 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Wen Gong <wgong@qti.qualcomm.com>
Cc:     Wen Gong <wgong@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: support PCIe enter L1 state
Message-ID: <20181115184333.GA87504@google.com>
References: <1542163848-837-1-git-send-email-wgong@codeaurora.org>
 <20181115002836.GA71934@google.com>
 <c94346b26a6d4b11a045a176ca854051@aptaiexm02f.ap.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c94346b26a6d4b11a045a176ca854051@aptaiexm02f.ap.qualcomm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Thu, Nov 15, 2018 at 06:38:25AM +0000, Wen Gong wrote:
> > -----Original Message-----
> > From: ath10k <ath10k-bounces@lists.infradead.org> On Behalf Of Brian Norris
> > 
> > Is there some reason L1 was disabled in the first place? Was it known to be
> > unreliable?
>
> Hi Brian,
> It is a BUG for power, and it is not considered this BUG before.
> So this change will fix the bug.

I understand that the existing behavior is suboptimal for power, but on
the other hand, code that goes out of its way to *clear* the L1 flag
doesn't just pop up out of nowhere. Somebody clearly wrote that! If it
just meant "we didn't verify L1 at first", then maybe it's fine to
enable it unconditionally and see what happens, but if it meant "we
tried L1 on some old chip XXXX and it caused problems", then it would be
nice to know what those problems were.

Or maybe that is hard to figure out, given there's no public git history
tracking the original code, and we just need to try it out.

Anyway, I'm giving it a try here, but I just wanted to ask :)

Thanks,
Brian
