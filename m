Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2748C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 15:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A77FC21773
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 15:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbfBLPIm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 10:08:42 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37061 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfBLPIm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 10:08:42 -0500
Received: by mail-wm1-f68.google.com with SMTP id x10so3356256wmg.2
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 07:08:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+XIpe6omsHtUr7oQ4mgtI2FUd8MIkCATfMgFayyTfSg=;
        b=kqqme4+UA+6OyVOj/uOse9SP2GpFl4Dw36fyZjrb4yrSnK7eBqLJui8T7c2YMtfkz1
         kYhR5wrppX3erqAY1u+eH+UkBFAPKrB1Frvrcjt0RZ6+MAxFoyUaNYmRa85laY5RAwuN
         txmE/iHbuA7UwXnIG8ga6erTBDrvC0nGmSNlJgZU9U8UcOg1RgeR74Pm3Q/kmUmrOblp
         HjzH0BM8O/2G9jQ5Qs0186TFHnWjWfHXR9vyGlUxXSPH0ZURqpan51PD7Zs2sCAztWTk
         Dy61JZiv2/DJCmz46bP3yhhvt2Ak+kDdfqmfx8OT5cqUKioiL+ceO9CuYsqsRHZIGgQF
         Kzyw==
X-Gm-Message-State: AHQUAuahKC3I+BMlw+UZnMF6DLVZB0SalN0w4EBlnVAx3AAq1Bosmqsr
        ySFE8ty8ZkrCEUCe5Qo0wj8DRQ==
X-Google-Smtp-Source: AHgI3IaZuMuJAwvHkWeY2C8xCVi2CDfqAzCwWRmnDZe4Rm1S3H8Z8TERBjglwELrOx9Z+2Q9DOtfeQ==
X-Received: by 2002:a05:600c:2184:: with SMTP id e4mr3119286wme.129.1549984120745;
        Tue, 12 Feb 2019 07:08:40 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id p68sm2369045wmp.17.2019.02.12.07.08.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Feb 2019 07:08:40 -0800 (PST)
Date:   Tue, 12 Feb 2019 16:08:37 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        lorenzo@kernel.org
Subject: Re: [PATCH 0/4] do not use sg if not properly supported by usb
 controller
Message-ID: <20190212150836.GA10823@localhost.localdomain>
References: <cover.1549977282.git.lorenzo@kernel.org>
 <20190212134550.GA12256@redhat.com>
 <20190212135100.GA15292@redhat.com>
 <CAJ0CqmVhH61P1V1fmhicPXwA7vHjv+Hh7h2DYbci1uDRJCyENA@mail.gmail.com>
 <20190212141725.GD12906@redhat.com>
 <20190212142528.GB24197@localhost.localdomain>
 <20190212145424.GE12906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190212145424.GE12906@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Tue, Feb 12, 2019 at 03:25:30PM +0100, Lorenzo Bianconi wrote:
> > > On Tue, Feb 12, 2019 at 03:09:53PM +0100, Lorenzo Bianconi wrote:
> > > > >
> > > > > (repost with corrected Lorenzo email)
> > > > >
> > > > > On Tue, Feb 12, 2019 at 02:45:50PM +0100, Stanislaw Gruszka wrote:
> > > > > > On Tue, Feb 12, 2019 at 02:24:47PM +0100, LorenzoBianconilorenzo@kernel.org wrote:
> > > > > > > From: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > > >
> > > > > > > Use linear fragment and not a single usb scatter-gather buffer in mt76u
> > > > > > > {tx,rx} datapath if the usb controller has sg data length constraints.
> > > > > > > Moreover add disable_usb_sg module parameter in order to explicitly
> > > > > > > disable scatter-gather. SG I/O is not supported by all host drivers and
> > > > > > > some users have reported sg issues on AMD IOMMU.
> > > > > >
> > > > > > Again. This is not right approach. SG issues should be fixed
> > > > > > not workarounded.
> > > > 
> > > > Hi Stanislaw,
> > > > 
> > > > here we do not use SG, so num_sg is 0 and we use transfer_buffer. I do
> > > > not see how I am working around the issue.
> > > 
> > > By avoiding SG buffer allocation and configuration which most likely
> > > need to be fixed.
> > 
> > In my series I:
> > 1- set num_sg to 0
> > 2- use transfer_buffer
> >
> > please correct me if I am wrong but in your solution you did the same since AFAIK
> > PageHighMem is always 0 so you end up setting num_sg to 0 and using
> > transfer_buffer as well. Is my understanding correct?
> 
> Yes. But it still using all existing SG allocation and setup code and
> buffer is tracked in urb->sg[0].

both of them are from page_frag_alloc()

> 
> > > > Moreover with this approach we avoid some unnecessary operation in the hotpath
> > > 
> > > What unnecessary operation ?
> > 
> > the ones in mt76u_fill_bulk_urb()
> 
> Your patches also add extra operations on hotpath due to urb->num_sgs and
> dev->usb.sg_en checks.

here I guess you should use mt76u_check_sg() instead of
udev->bus->sg_tablesize > 0 so I think you need to precompute it since it is in
the hotpath

Moreover the RFC series has been tested by multiple users and on multiple
devices

Regards,
Lorenzo

> 
> Stanislaw
