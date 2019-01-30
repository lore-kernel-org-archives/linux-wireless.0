Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4497C282D5
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 08:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9199D2184D
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 08:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbfA3I3t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 03:29:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53246 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfA3I3t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 03:29:49 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 25F52C0BEAA4;
        Wed, 30 Jan 2019 08:29:49 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68DE110021B2;
        Wed, 30 Jan 2019 08:29:45 +0000 (UTC)
Date:   Wed, 30 Jan 2019 09:29:39 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCH v2 0/7] mt76x02: Beacon support for USB
Message-ID: <20190130082937.GA2720@redhat.com>
References: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
 <87a7jju1mv.fsf@purkki.adurom.net>
 <8ec3b133-49eb-3c5f-4c3c-bc2bb4e84cde@nbd.name>
 <87k1inwtu5.fsf@codeaurora.org>
 <b6fb4aec-5e65-53aa-e14b-c1230e797786@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6fb4aec-5e65-53aa-e14b-c1230e797786@nbd.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 30 Jan 2019 08:29:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jan 29, 2019 at 01:10:08PM +0100, Felix Fietkau wrote:
> On 2019-01-29 13:07, Kalle Valo wrote:
> > Felix Fietkau <nbd@nbd.name> writes:
> > 
> >> On 2019-01-29 12:47, Kalle Valo wrote:
> >>> Stanislaw Gruszka <sgruszka@redhat.com> writes:
> >>> 
> >>>> We can configure beaconing, but without TBTT interrupt we
> >>>> can not support PS buffering. This can be added later using
> >>>> kernel hrtimer, if we can keep it in sycn with device timer.
> >>>>
> >>>> I tested AP and IBSS modes.
> >>> 
> >>> So how does this work reliably so that there's no packet loss with
> >>> clients using power save?
> >>
> >> There will be multicast packet loss for clients using power save.
> > 
> > Isn't that a problem? At least as a normal user I would very frustrated
> > if sometimes my connection work and sometimes not, for example if I'm
> > trying discover devices from my network. Hopefully nobody won't use USB
> > devices for any real AP stuff, but still enabling something which we
> > know doesn't work realiably is concerning.
> I agree. Maybe we should leave out the flag for AP mode in this patch
> until we have PS buffering and leave the rest of the code intact.

But how serious problem of dropping multicast frames for PS stations is?
I don't think from user perspective this is "sometimes my connection
work and sometimes not", but something much less annoying. 

Another thing is that this (D)TIM PS is not reliable by design,
that why UAPSD was introduced.

Moreover in the tree we have already bunch of drivers that do 
advertise AP mode support without HOST_BROADCAST_PS_BUFFERING 
like iwlwifi or brcm80211 .

So I don't think we should drop AP flag, AP mode works with
this patch set quite well.

Thanks
Stanislaw

