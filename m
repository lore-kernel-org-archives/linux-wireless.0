Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADDE9C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 14:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 890C320675
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 14:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393680AbfAPOjK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 09:39:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39470 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393563AbfAPOjK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 09:39:10 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C06E47AE81;
        Wed, 16 Jan 2019 14:39:09 +0000 (UTC)
Received: from localhost (unknown [10.40.206.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D34F611A2;
        Wed, 16 Jan 2019 14:39:06 +0000 (UTC)
Date:   Wed, 16 Jan 2019 15:39:06 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org, rosenp@gmail.com
Subject: Re: [RFC 0/4] do not use sg if not properly supported by usb
 controller
Message-ID: <20190116143905.GA18221@redhat.com>
References: <cover.1547549771.git.lorenzo.bianconi@redhat.com>
 <20190115153546.GA8387@redhat.com>
 <20190115154746.GA30564@localhost.localdomain>
 <20190116111946.GB5234@redhat.com>
 <20190116114432.GA2454@localhost.localdomain>
 <20190116122145.GA7472@redhat.com>
 <20190116134045.GB2454@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190116134045.GB2454@localhost.localdomain>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 16 Jan 2019 14:39:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jan 16, 2019 at 02:40:46PM +0100, Lorenzo Bianconi wrote:
> On Jan 16, Stanislaw Gruszka wrote:
> > On Wed, Jan 16, 2019 at 12:44:33PM +0100, Lorenzo Bianconi wrote:
> > > > On Tue, Jan 15, 2019 at 04:47:47PM +0100, Lorenzo Bianconi wrote:
> > > > > Hi Stanislaw,
> > > > 
> > > > Hi :-)
> > > > 
> > > > > > Not sure what is the problem , but this patch set look like a workaround
> > > > > > not fix. If this an issue with IOMMU and sg, seems there is something wrong
> > > > > > in sg page mappings eigher on mt76 dirver or IOMMU driver.
> > > > > 
> > > > > The main point here I guess is we do not need sg if fragment number is one (e.g
> > > > > usb2.0). Moreover this can fix IOMMU reported issues.
> > > > 
> > > > So there if diffrence for USB host driver when we have one usb->sg
> > > > sengment and if we just pass the buffer via urb->transfer_buf . I think
> > > > most USB host drivers behave the same in such cases. For what USB
> > > > hardware/driver this is needed ? Perhaps simpler fix could be done
> > > > in USB host driver?
> > > 
> > > According to https://github.com/torvalds/linux/blob/master/drivers/usb/core/hcd.c#L1557
> > > single sg urb and urb with a configured transfer_buf are managed in a different way.
> > 
> > But this should not make any difference for underlying low level USB
> > host driver, since we map 1 buffer of the same size, just by using
> > different routines for that.
> 
> probably amd iommu has some constraints on sg buffer layout respect to intel
> one, not sure
> 
> > 
> > > Please not I have not received any confirm that this series fixes the reported issue
> > > yet :)
> > 
> > What is reported issue ?
> 
> https://marc.info/?l=linux-wireless&m=154716096506037&w=2

So, this if for AMD IOMMU issue as I thought initally. For the moment I
thought you are trying to fix some diffrent problem with some 
non-standart usb host controler.

I still think not using sg is just workaround for the problem not worth
to do, since we have already workaround in form of disabling IOMMU.
Right fix will be fixing AMD IOMMU driver or fix sg usage in mt76-usb
if it does something wrong.

Regards
Stanislaw 
