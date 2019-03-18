Return-Path: <SRS0=49bh=RV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17DD5C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 10:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCF0520850
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 10:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbfCRKHv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Mar 2019 06:07:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29387 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbfCRKHu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Mar 2019 06:07:50 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3B3F530789BE;
        Mon, 18 Mar 2019 10:07:50 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EDAC1001E7B;
        Mon, 18 Mar 2019 10:07:47 +0000 (UTC)
Date:   Mon, 18 Mar 2019 11:03:13 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCH 08/11] mt76x02u: implement pre TBTT work for USB
Message-ID: <20190318100313.GB3323@redhat.com>
References: <1551692896-7062-1-git-send-email-sgruszka@redhat.com>
 <1551692896-7062-9-git-send-email-sgruszka@redhat.com>
 <5844c0b8-3db9-d985-da75-a11318df37c5@nbd.name>
 <20190318095014.GA3323@redhat.com>
 <541c8464-7422-5045-217c-420ca074b36d@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541c8464-7422-5045-217c-420ca074b36d@nbd.name>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 18 Mar 2019 10:07:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 18, 2019 at 10:57:47AM +0100, Felix Fietkau wrote:
> On 2019-03-18 10:50, Stanislaw Gruszka wrote:
> > On Sat, Mar 16, 2019 at 08:44:21PM +0100, Felix Fietkau wrote:
> >> On 2019-03-04 10:48, Stanislaw Gruszka wrote:
> >> > Program beacons data and PS buffered frames on TBTT work for USB.
> >> > We do not have MT_TXQ_PSD queue available via USB endpoints. The way
> >> > we can send PS broadcast frames in timely manner before PS stations go
> >> > sleep again is program them in beacon data area. Hardware do not modify
> >> > those frames since TXWI is properly configured. mt76x02_mac_set_beacon()
> >> > already handle this and free no longer used frames.
> >> > 
> >> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> >> I think it's a nice idea, but there is one problem with that approach:
> >> beacon slots only have 1024 bytes for TXWI + data.
> >> I think to support this properly, you probably need to adjust beacon
> >> offsets for USB dynamically and limit the number of frames to what you
> >> can fit in SRAM.
> > That would be good since we could sent more buffered frames (ARP frames
> > are small), but for now I would prefer simpler solution to enable 
> > AP support for USB: increase slot size to 1600 and make only 5 slots
> > available.
> Then you should probably limit the number of AP interfaces for USB as
> well. Otherwise, people are going to do crazy things like bring up 4
> virtual AP interfaces and expect multicast to work :)
Yes, sure, for now only one is allowed. Multi vifs for USB is on my
TODO list.

Stanislaw
