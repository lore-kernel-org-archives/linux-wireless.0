Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 938DEC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 09:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AFFD20835
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 09:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438088AbfBNJyZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 04:54:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437796AbfBNJyY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 04:54:24 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 68802B272B;
        Thu, 14 Feb 2019 09:54:24 +0000 (UTC)
Received: from localhost (ovpn-204-123.brq.redhat.com [10.40.204.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B05445D704;
        Thu, 14 Feb 2019 09:54:21 +0000 (UTC)
Date:   Thu, 14 Feb 2019 10:54:20 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190214095420.GB17273@redhat.com>
References: <20190211173315.GE6292@redhat.com>
 <Pine.LNX.4.44L0.1902111246410.1543-100000@iolanthe.rowland.org>
 <CAJ0CqmVFVBXi5E07-ZsYojC7mP4ogpwbcDkDTeebHwX+ayz2DQ@mail.gmail.com>
 <20190212093035.GB12906@redhat.com>
 <404607590.373282.1550126997144@email.ionos.de>
 <20190214092530.GA17273@redhat.com>
 <878a7160-2e91-d057-6d27-c6b9d85f700e@i2se.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878a7160-2e91-d057-6d27-c6b9d85f700e@i2se.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 14 Feb 2019 09:54:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Feb 14, 2019 at 10:48:15AM +0100, Stefan Wahren wrote:
> Hi Stanislaw,
> 
> Am 14.02.19 um 10:25 schrieb Stanislaw Gruszka:
> > On Thu, Feb 14, 2019 at 07:49:57AM +0100, Stefan Wahren wrote:
> >> Hi Stanislaw,
> >>
> >>> Stanislaw Gruszka <sgruszka@redhat.com> hat am 12. Februar 2019 um 10:30 geschrieben:
> >>>
> >>>
> >>>
> >>> In usb_sg_init() urb->num_sgs is set 0 for sg_tablesize = 0 controllers.
> >>> In mt76 we set urb->num_sgs to 1. I thought it is fine, but now I think
> >>> this is bug. We can fix that without changing allocation method and
> >>> still use SG allocation. Attached patch do this, please check if it works
> >>> on rpi. Patch is on top of your error path fixes.
> >> your patch didn't apply cleanly to yesterdays next. After some minor manual fixup, i was able to build them and here are the results starting from boot (please ignore the invalid time in the kernel log):
> >> https://gist.github.com/lategoodbye/33bd5bc75b9fc935faa231bc472defa8
> > I think this is due to urb->transfer_length and sg[0]->length mismatch,
> > which should be addressed by my other patch. I'm attaching the patch
> > rebased on -next with this line integrated, please test. 
> >
> > But there could be other bug's in mt76-usb SG code.
> Will retry
> >
> >> Using multi_v7_defconfig i'm getting a warning on the first connect and always this flood of rx urb failed on disconnect. The driver seems to probe but isn't functional even after 2 tries.
> >>
> >> Using arm64_defconfig i don't get any warning. But except of this i'm getting similiar results to multi_v7_defconfig.
> >>
> >> So in comparison, Lorenzo's workaround behaves better.
> > I'm pretty sure problem is mt76x0u 4.19 -> 4.20 regression intrduced by
> > integrating mt76x0u in mt76-usb (things do not work from day 0
> > for mt76x2u). We should find fix(es) that will be proper for -stable.
> So i should also try 4.19 without any patches?

That would be good. Thanks.

Stanislaw

