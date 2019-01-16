Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE19C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 11:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96D5120657
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 11:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392462AbfAPLoi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 06:44:38 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38702 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389613AbfAPLoi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 06:44:38 -0500
Received: by mail-wm1-f67.google.com with SMTP id m22so1662682wml.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jan 2019 03:44:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yeMoGzHXMTwfT0JJkdZLOXQ32Q61Fwv3pTpg9cKSAeg=;
        b=YhiRR6jtIDv+kmxq36xLaS1K9XJ6mFg3gRe9HKrRya0Or2Fq52KOzntgVFF56bdjDQ
         eDySBwqHpyfoIquXA6VYoXoFNYtz7KIJOkVMOvQMSvphlX/YV9BoSY6aWQOl8Wz1V3l2
         7APfvpS4kbqdUXRWcAyx1x9eG3kbTFO72CBq73JpbyHUBatxYg9srXhd1uQMdy7gLFyw
         iwF8hK6pkP14148lSGnwwSPsVxpxVKn/VSAfn7swyWbA0f1W2x2Dcrr+KvqSLNrflQ26
         BvQ+mHj6Z7kIfv6aQdoQFg0DT224nSU6fWnybzcsDaeNIwCLM4lMpViBM/ytFHFny401
         DeYA==
X-Gm-Message-State: AJcUukeLk1VAmFXdEzXllUZ1EGkZH7+kEOmKI+H6Tpz567OA0afa8kmL
        N2cQ+coFqnb062Bj0ppwf0YYmw==
X-Google-Smtp-Source: ALg8bN43EuyPB4y5T78qVLHnfRdPwdNR2y+ka9esJH9uwrGuzQnhTmWnTJkTImO1WIu5QT/GleBoNQ==
X-Received: by 2002:a1c:47:: with SMTP id 68mr6893854wma.89.1547639075919;
        Wed, 16 Jan 2019 03:44:35 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id q3sm80072647wrn.84.2019.01.16.03.44.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Jan 2019 03:44:35 -0800 (PST)
Date:   Wed, 16 Jan 2019 12:44:33 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org, rosenp@gmail.com
Subject: Re: [RFC 0/4] do not use sg if not properly supported by usb
 controller
Message-ID: <20190116114432.GA2454@localhost.localdomain>
References: <cover.1547549771.git.lorenzo.bianconi@redhat.com>
 <20190115153546.GA8387@redhat.com>
 <20190115154746.GA30564@localhost.localdomain>
 <20190116111946.GB5234@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190116111946.GB5234@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Tue, Jan 15, 2019 at 04:47:47PM +0100, Lorenzo Bianconi wrote:
> > Hi Stanislaw,
> 
> Hi :-)
> 
> > > Not sure what is the problem , but this patch set look like a workaround
> > > not fix. If this an issue with IOMMU and sg, seems there is something wrong
> > > in sg page mappings eigher on mt76 dirver or IOMMU driver.
> > 
> > The main point here I guess is we do not need sg if fragment number is one (e.g
> > usb2.0). Moreover this can fix IOMMU reported issues.
> 
> So there if diffrence for USB host driver when we have one usb->sg
> sengment and if we just pass the buffer via urb->transfer_buf . I think
> most USB host drivers behave the same in such cases. For what USB
> hardware/driver this is needed ? Perhaps simpler fix could be done
> in USB host driver?

According to https://github.com/torvalds/linux/blob/master/drivers/usb/core/hcd.c#L1557
single sg urb and urb with a configured transfer_buf are managed in a different way.
Please not I have not received any confirm that this series fixes the reported issue
yet :)

> 
> Also I'm not sure for what this new module parameter is needed ?
>  

This is used to disable sg on usb3.0 since it is enabled by default

> > @Rosen: could you please try this series enabling IOMMU?
> > 
> > > 
> > > If things need to be fixed in mt76 I whould check if page mappings for
> > > sg are correct. Or remove sg usage from mt76_usb completly, mt76 MMIO
> > > version do not use sg for framgments, so most likely USB don't need it
> > > as well.
> > 
> > usb scatter-gather is used to properly support non-linear skbs (A-MSDU,
> > with usb3.0) since the hw (unlike pci counterpart) does not support it,
> > so we need it.
> 
> Ok, having separe URB for each fragment make no sense since we have
> embedded sg structure in URB.

In this case each fragment will be mapped independently I guess

Regards,
Lorenzo

> 
> Regards
> Stanislaw
