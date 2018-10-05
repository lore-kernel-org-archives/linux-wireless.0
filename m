Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B1D3C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B71BB20652
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 10:34:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B71BB20652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbeJERcs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 13:32:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34028 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727572AbeJERcs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 13:32:48 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4579030E684D;
        Fri,  5 Oct 2018 10:34:37 +0000 (UTC)
Received: from localhost (unknown [10.43.2.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4BC168DB8;
        Fri,  5 Oct 2018 10:34:36 +0000 (UTC)
Date:   Fri, 5 Oct 2018 12:34:34 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH 0/5] rt2800mmio txdone/interrupts/flush rework
Message-ID: <20181005103434.GA23025@redhat.com>
References: <1537957497-7790-1-git-send-email-sgruszka@redhat.com>
 <1538697102-3764-1-git-send-email-pozega.tomislav@gmail.com>
 <20181005074422.GA1931@redhat.com>
 <363e4d1a-2a1f-2ab9-dad6-91d36fe38d53@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <363e4d1a-2a1f-2ab9-dad6-91d36fe38d53@nbd.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 05 Oct 2018 10:34:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Oct 05, 2018 at 12:05:56PM +0200, Felix Fietkau wrote:
> On 2018-10-05 09:44, Stanislaw Gruszka wrote:
> > My experience is that performance between two rt2800 devices vary with
> > no apparent reason. There are two problems I know that maigh affect
> > performance at random (and I think there are also some other low level
> > problems that I'm not aware of that cause performance fluctuations).
> > 
> > First problem is that HW aggregate RATE_PROBE frames with other frames
> > at different rate, so we can not do rate probing properly for rate
> > control algorithm.
> I believe this is fixable. On MT76x2, I was able to use the QSEL field
> in the DMA descriptor to force the hw to send it out as a single frame.
> It is normally set to 2, you can set it to 0 for frames with
> IEEE80211_TX_CTL_RATE_CTRL_PROBE set.
> Theoretically, the same should also work on RT2800 devices.

I created a patch that do this 
https://github.com/sgruszka/wireless-drivers-next/commit/846d205edd8c36d1b7828fee54bf4cf40bf8cb1a
but coused problems on some devices and I did not observed correct
behaviour - probe frames were still aggregated.

Perhaps patch has some bug (i.e. some registers have to be initialized
to make QSEL work) or maybe this will only work on some chipsets i.e.
MT7620 and QSEL should be used only conditionally on those chips.

> > Second problem: we send BAR when we fail to send a frame and this might
> > have positive and negative effect, depend what remote hardware do when it
> > gets BAR. This seems to be problem when two rt2800 devices are connected
> > and not a problem if rt2800 is connected with ath or iwl devices.
> On the receiver side, BAR is typically processed in software. mac80211
> handles that, so I don't think there is a lot of room for chipset
> specific behavior here.

This is not what I observed. For me looks like BA is send by FW/HW for
both AMPDU frames and for BAR. And behaviour differs. I have one older
device that send completely bogus SSN (seq num) in solicit BA frame
not correpond to BAR SSN or frames in AMPDU at all. 

Some devices send solicit BA SSN and then send BA with older SSNs,
for frames which should already be flushed.

And some devices send several BA with solicit SSN until catch up to
ack frame that has bigger sequence number than solicit SSN.

Regards 
Stanislaw 
