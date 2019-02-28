Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39409C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 11:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CA5D20863
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 11:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730976AbfB1L7D (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 06:59:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbfB1L7C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 06:59:02 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C350BC0ADB4C;
        Thu, 28 Feb 2019 11:59:02 +0000 (UTC)
Received: from localhost (unknown [10.43.2.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A0F05D9C9;
        Thu, 28 Feb 2019 11:59:00 +0000 (UTC)
Date:   Thu, 28 Feb 2019 12:58:58 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: usb: grab rx_page_lock for legacy mode in
 mt76u_refill_rx
Message-ID: <20190228115857.GC6072@redhat.com>
References: <cover.1551350717.git.lorenzo@kernel.org>
 <ec679a39f00e9f8fabc698ef3d977ff97c841873.1551350717.git.lorenzo@kernel.org>
 <20190228112445.GA6072@redhat.com>
 <20190228113746.GC2768@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190228113746.GC2768@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 28 Feb 2019 11:59:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Feb 28, 2019 at 12:37:48PM +0100, Lorenzo Bianconi wrote:
> > On Thu, Feb 28, 2019 at 12:08:45PM +0100, Lorenzo Bianconi wrote:
> > > Grab rx_page_lock in mt76u_refill_rx allocating rx buffer for 'legacy'
> > > mode. Remove gfp from mt76u_refill_rx signature since we need to
> > > use GFP_ATOMIC
> > > 
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > 
> > I'm doing some cleanup/optimization work which amongs other things
> > will remove rx_page_lock. Please drop this patch.
> 
> Oh, ok. IIRC we need rx_page_lock to fix this:
> 481bb0432414f790066205fe77226b7d1877385d. Is it still necessary?
> Moreover maybe we need this patch for 5.1 since net-next is almost close, no?

It is not neccessery now in -next after removing concurrent access to
mt76u_buf_alloc(), can be removed.

Stanislaw
