Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51379C282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 11:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BF9F21905
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 11:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfBML7Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 06:59:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbfBML7Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 06:59:25 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CE25E10F96;
        Wed, 13 Feb 2019 11:59:24 +0000 (UTC)
Received: from localhost (unknown [10.40.205.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5468062F8B;
        Wed, 13 Feb 2019 11:59:21 +0000 (UTC)
Date:   Wed, 13 Feb 2019 12:59:20 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        lorenzo@kernel.org
Subject: Re: [PATCH 0/4] do not use sg if not properly supported by usb
 controller
Message-ID: <20190213115919.GC5749@redhat.com>
References: <CAJ0CqmVhH61P1V1fmhicPXwA7vHjv+Hh7h2DYbci1uDRJCyENA@mail.gmail.com>
 <20190212141725.GD12906@redhat.com>
 <20190212142528.GB24197@localhost.localdomain>
 <20190212145424.GE12906@redhat.com>
 <20190212150836.GA10823@localhost.localdomain>
 <20190212152559.GB23126@redhat.com>
 <20190212155001.GA12780@localhost.localdomain>
 <20190212220902.GA27836@localhost.localdomain>
 <20190213094449.GA5749@redhat.com>
 <20190213110041.GI6376@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190213110041.GI6376@localhost.localdomain>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 13 Feb 2019 11:59:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 13, 2019 at 12:00:42PM +0100, Lorenzo Bianconi wrote:
> On Feb 13, Stanislaw Gruszka wrote:
> > On Tue, Feb 12, 2019 at 11:09:03PM +0100, Lorenzo Bianconi wrote:
> > > > > On Tue, Feb 12, 2019 at 04:08:37PM +0100, Lorenzo Bianconi wrote:
> > > > > > > > > What unnecessary operation ?
> > > > > > > > 
> > > > > > > > the ones in mt76u_fill_bulk_urb()
> > > > > > > 
> > > > > > > Your patches also add extra operations on hotpath due to urb->num_sgs and
> > > > > > > dev->usb.sg_en checks.
> > > > > > 
> > > > > > here I guess you should use mt76u_check_sg() instead of
> > > > > > udev->bus->sg_tablesize > 0 so I think you need to precompute it since it is in
> > > > > > the hotpath
> > > > > 
> > > > > It's not necessary. If udev->bus->sg_tablesize > 0 is true and rest
> > > > > of mt76u_check_sg() is not, we will submit urb with urb->num_sgs = 1 to
> > > > > usb host driver, what is fine. 
> > > > > 
> > > > > > Moreover the RFC series has been tested by multiple users and on multiple
> > > > > > devices
> > > > > 
> > > > > I know. Perhaps you could test my patch on rpi ?
> > > > 
> > > > sure, I will do it later
> > > 
> > > I confirm that even with Stanislaw's patch the usb dongle is properly working
> > > on rpi3+
> > 
> > Thanks for testing. Would be ok to you to post my patch against
> > wireless-drivers tree and cc stable as fix for non-SG usb hosts,
> > drop your set for -next and work for fix for SG issue on AMD IOMMU?
> 
> I agree that your patch works (since it does not use SG I/O :)) but

It still use SG in mt76usb driver (urb->sg, sg_set_page(),
sg_init_marker(), etc ...) for all usb host controllers. It just
not submit urb->num_sgs > 1 to USB host driver if it does not
support SG.

> I think it is more clear (and manageable) to have two separated
> routines for memory allocation.

Hmm, I disagree on that and don't understand how you consider clearer
and manageable design with two separate buffer allocation methods
and bunch of extra ->num_sgs and ->sg_en checks, compered to solution
with one allocation method and without those checks.

Also some additional cleanups/simplification can be done after
applying my patch in mt76usb not possible after applying your set.

> Moreover I think that this check has to be done in the control plane instead
> of the data plane, so I would like to spend some more time in order to see if it is
> possible to remove some checks in the hot-path

I'm not sure what you mean by data-pane and control-plane in this context.

I considered to do mt76u_fill_buk_urb:

urb->num_sgs = (buf->num_sgs > 1) ? buf->num_sgs : 0;

Instead of usb->bus->sg_tablesize check. It should work, but it's not
what usb_sg_init() does and as pointed by Alan that function always
do the right thing, so I just copied code from there.

Beside that I don't think this check in mt76u_fill_buk_urb()
affects performance whatsoever.

Stanislaw  
