Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE77C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 13:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 241D620675
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 13:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733178AbfAPNkv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 08:40:51 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40326 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730657AbfAPNkv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 08:40:51 -0500
Received: by mail-wm1-f65.google.com with SMTP id f188so2015540wmf.5
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jan 2019 05:40:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=N574C3rL5Y5MuGTGY+KLRIDd/goEyeXn/yHDYeKkPbA=;
        b=Vd1yrdJW0NQa0gDYZhzZYBoskgkOdilJMJHSxulCbRWMDaVwERppG4vgncHp0QAegn
         ytEvpLJaYZbpPRB2ASY3nsP1vo89OqlPDhfZfKxyqzxz4qrIvc7VSa4LxF6J21qeS3Oy
         JpwOIQB3RNcyu0C810ZlT81hP2TAsrEFrUONdOStO7LzXaYenJdBBFkkY1cbVCa1nxRe
         GmlavfINCzw8qPv31FOo8ljSuZ7UaUPdi8ymjJf3OMC/vZYVW3iegWuJnH2vXm7EwUdu
         tihRUXcCvxRxRDjaCcZJNCEwD8pHiXDUK5gi1lhbUdrjr7bhhVUjvTpvw/jFAmJFNAQb
         zXEw==
X-Gm-Message-State: AJcUukclvx+F8BLF1uiQEoyHrNc7uBEhSQaMnMyVfkfLolbWxecLnjw/
        8myArowpQAn0a8tpWky0hriCVQ==
X-Google-Smtp-Source: ALg8bN6MWGsQ2k/IDRe7X5ofjrNPzroeUEZGQqPyIr00ZG7sEPEGsn+xHzB/Hh8R6FJAanB4aBDI0w==
X-Received: by 2002:a7b:c853:: with SMTP id c19mr7203297wml.61.1547646049440;
        Wed, 16 Jan 2019 05:40:49 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id c65sm35973673wma.24.2019.01.16.05.40.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Jan 2019 05:40:48 -0800 (PST)
Date:   Wed, 16 Jan 2019 14:40:46 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org, rosenp@gmail.com
Subject: Re: [RFC 0/4] do not use sg if not properly supported by usb
 controller
Message-ID: <20190116134045.GB2454@localhost.localdomain>
References: <cover.1547549771.git.lorenzo.bianconi@redhat.com>
 <20190115153546.GA8387@redhat.com>
 <20190115154746.GA30564@localhost.localdomain>
 <20190116111946.GB5234@redhat.com>
 <20190116114432.GA2454@localhost.localdomain>
 <20190116122145.GA7472@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190116122145.GA7472@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Jan 16, Stanislaw Gruszka wrote:
> On Wed, Jan 16, 2019 at 12:44:33PM +0100, Lorenzo Bianconi wrote:
> > > On Tue, Jan 15, 2019 at 04:47:47PM +0100, Lorenzo Bianconi wrote:
> > > > Hi Stanislaw,
> > > 
> > > Hi :-)
> > > 
> > > > > Not sure what is the problem , but this patch set look like a workaround
> > > > > not fix. If this an issue with IOMMU and sg, seems there is something wrong
> > > > > in sg page mappings eigher on mt76 dirver or IOMMU driver.
> > > > 
> > > > The main point here I guess is we do not need sg if fragment number is one (e.g
> > > > usb2.0). Moreover this can fix IOMMU reported issues.
> > > 
> > > So there if diffrence for USB host driver when we have one usb->sg
> > > sengment and if we just pass the buffer via urb->transfer_buf . I think
> > > most USB host drivers behave the same in such cases. For what USB
> > > hardware/driver this is needed ? Perhaps simpler fix could be done
> > > in USB host driver?
> > 
> > According to https://github.com/torvalds/linux/blob/master/drivers/usb/core/hcd.c#L1557
> > single sg urb and urb with a configured transfer_buf are managed in a different way.
> 
> But this should not make any difference for underlying low level USB
> host driver, since we map 1 buffer of the same size, just by using
> different routines for that.

probably amd iommu has some constraints on sg buffer layout respect to intel
one, not sure

> 
> > Please not I have not received any confirm that this series fixes the reported issue
> > yet :)
> 
> What is reported issue ?

https://marc.info/?l=linux-wireless&m=154716096506037&w=2

Regards,
Lorenzo

> 
> Thanks
> Stanislaw
