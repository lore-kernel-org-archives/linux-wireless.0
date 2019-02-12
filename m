Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 478F4C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 14:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20FE6218E0
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 14:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730155AbfBLORj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 09:17:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57574 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728649AbfBLORi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 09:17:38 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 87D731838;
        Tue, 12 Feb 2019 14:17:38 +0000 (UTC)
Received: from localhost (ovpn-204-125.brq.redhat.com [10.40.204.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9863B16934;
        Tue, 12 Feb 2019 14:17:26 +0000 (UTC)
Date:   Tue, 12 Feb 2019 15:17:25 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        lorenzo@kernel.org
Subject: Re: [PATCH 0/4] do not use sg if not properly supported by usb
 controller
Message-ID: <20190212141725.GD12906@redhat.com>
References: <cover.1549977282.git.lorenzo@kernel.org>
 <20190212134550.GA12256@redhat.com>
 <20190212135100.GA15292@redhat.com>
 <CAJ0CqmVhH61P1V1fmhicPXwA7vHjv+Hh7h2DYbci1uDRJCyENA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ0CqmVhH61P1V1fmhicPXwA7vHjv+Hh7h2DYbci1uDRJCyENA@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 12 Feb 2019 14:17:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Feb 12, 2019 at 03:09:53PM +0100, Lorenzo Bianconi wrote:
> >
> > (repost with corrected Lorenzo email)
> >
> > On Tue, Feb 12, 2019 at 02:45:50PM +0100, Stanislaw Gruszka wrote:
> > > On Tue, Feb 12, 2019 at 02:24:47PM +0100, LorenzoBianconilorenzo@kernel.org wrote:
> > > > From: Lorenzo Bianconi <lorenzo@kernel.org>
> > > >
> > > > Use linear fragment and not a single usb scatter-gather buffer in mt76u
> > > > {tx,rx} datapath if the usb controller has sg data length constraints.
> > > > Moreover add disable_usb_sg module parameter in order to explicitly
> > > > disable scatter-gather. SG I/O is not supported by all host drivers and
> > > > some users have reported sg issues on AMD IOMMU.
> > >
> > > Again. This is not right approach. SG issues should be fixed
> > > not workarounded.
> 
> Hi Stanislaw,
> 
> here we do not use SG, so num_sg is 0 and we use transfer_buffer. I do
> not see how I am working around the issue.

By avoiding SG buffer allocation and configuration which most likely
need to be fixed.

> Moreover with this approach we avoid some unnecessary operation in the hotpath

What unnecessary operation ?

Stanislaw
