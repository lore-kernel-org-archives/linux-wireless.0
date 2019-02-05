Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A55C282CC
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 15:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80DFD217D6
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 15:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbfBEPCn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 10:02:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6679 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728574AbfBEPCn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 10:02:43 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 729465944F;
        Tue,  5 Feb 2019 15:02:42 +0000 (UTC)
Received: from localhost (unknown [10.43.2.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D6951059593;
        Tue,  5 Feb 2019 15:02:41 +0000 (UTC)
Date:   Tue, 5 Feb 2019 15:58:23 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 0/7] mt76x02: Beacon support for USB
Message-ID: <20190205145823.GD7510@redhat.com>
References: <87a7jju1mv.fsf@purkki.adurom.net>
 <8ec3b133-49eb-3c5f-4c3c-bc2bb4e84cde@nbd.name>
 <87k1inwtu5.fsf@codeaurora.org>
 <b6fb4aec-5e65-53aa-e14b-c1230e797786@nbd.name>
 <87fttbwtav.fsf@codeaurora.org>
 <20190129124056.GB2460@localhost.localdomain>
 <20190130083747.GB2720@redhat.com>
 <ae2324b4-e79c-6984-b29e-5fef77ede672@nbd.name>
 <20190130100748.GA5655@redhat.com>
 <20190130152255.GA24113@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190130152255.GA24113@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 05 Feb 2019 15:02:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jan 30, 2019 at 04:22:55PM +0100, Stanislaw Gruszka wrote:
> On Wed, Jan 30, 2019 at 11:07:48AM +0100, Stanislaw Gruszka wrote:
> > > >> We can support ps buffering in AP as well using a hrtimer. In this way we
> > > >> can reuse most of the existing code
> > > > 
> > > > Yes, but there is issue to address, since kernel timer and device TBT
> > > > timer are independed, they possibly can get out of sync after some time,
> > > > for example few hours or days. So there is need to prevent/fix this
> > > > somehow.
> > > We could read the TSF timer value from the hardware and sync the hrtimer
> > > against that.
> > 
> > Ok then. I'll implement hrtimer solution and repost this set. Patch
> > 6 will no longer be necessery.
> 
> This require more changes than I expected to allow programming registers
> from atomic context for mt76-usb. So I'll repost without AP support for
> now.

There are more obstacles here. On USB we do not have PSD queue available 
via endpoinds. I have some solutions to this problem, but non of them work
satisfactory so far. Still experimenting ...
 
Stanislaw
