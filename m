Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F11EC282CA
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 09:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 045C6222BA
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 09:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732170AbfBMJo7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 04:44:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56224 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbfBMJo7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 04:44:59 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 859287EBC1;
        Wed, 13 Feb 2019 09:44:59 +0000 (UTC)
Received: from localhost (unknown [10.40.205.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEE3F5D9C8;
        Wed, 13 Feb 2019 09:44:51 +0000 (UTC)
Date:   Wed, 13 Feb 2019 10:44:50 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        lorenzo@kernel.org
Subject: Re: [PATCH 0/4] do not use sg if not properly supported by usb
 controller
Message-ID: <20190213094449.GA5749@redhat.com>
References: <20190212134550.GA12256@redhat.com>
 <20190212135100.GA15292@redhat.com>
 <CAJ0CqmVhH61P1V1fmhicPXwA7vHjv+Hh7h2DYbci1uDRJCyENA@mail.gmail.com>
 <20190212141725.GD12906@redhat.com>
 <20190212142528.GB24197@localhost.localdomain>
 <20190212145424.GE12906@redhat.com>
 <20190212150836.GA10823@localhost.localdomain>
 <20190212152559.GB23126@redhat.com>
 <20190212155001.GA12780@localhost.localdomain>
 <20190212220902.GA27836@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190212220902.GA27836@localhost.localdomain>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 13 Feb 2019 09:44:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Feb 12, 2019 at 11:09:03PM +0100, Lorenzo Bianconi wrote:
> > > On Tue, Feb 12, 2019 at 04:08:37PM +0100, Lorenzo Bianconi wrote:
> > > > > > > What unnecessary operation ?
> > > > > > 
> > > > > > the ones in mt76u_fill_bulk_urb()
> > > > > 
> > > > > Your patches also add extra operations on hotpath due to urb->num_sgs and
> > > > > dev->usb.sg_en checks.
> > > > 
> > > > here I guess you should use mt76u_check_sg() instead of
> > > > udev->bus->sg_tablesize > 0 so I think you need to precompute it since it is in
> > > > the hotpath
> > > 
> > > It's not necessary. If udev->bus->sg_tablesize > 0 is true and rest
> > > of mt76u_check_sg() is not, we will submit urb with urb->num_sgs = 1 to
> > > usb host driver, what is fine. 
> > > 
> > > > Moreover the RFC series has been tested by multiple users and on multiple
> > > > devices
> > > 
> > > I know. Perhaps you could test my patch on rpi ?
> > 
> > sure, I will do it later
> 
> I confirm that even with Stanislaw's patch the usb dongle is properly working
> on rpi3+

Thanks for testing. Would be ok to you to post my patch against
wireless-drivers tree and cc stable as fix for non-SG usb hosts,
drop your set for -next and work for fix for SG issue on AMD IOMMU?

Stanislaw
