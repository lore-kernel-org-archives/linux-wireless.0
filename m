Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE49C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 13:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 239EB2171F
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 13:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730929AbfB1Nkc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 08:40:32 -0500
Received: from 8bytes.org ([81.169.241.247]:55958 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbfB1Nkc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 08:40:32 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id DE3524A3; Thu, 28 Feb 2019 14:40:29 +0100 (CET)
Date:   Thu, 28 Feb 2019 14:40:29 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Rosen Penev <rosenp@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Samuel Sieb <samuel@sieb.net>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
Message-ID: <20190228134029.GC1594@8bytes.org>
References: <CAKxU2N8ioMszBCyQcH7CVhgBdW4aj7yZ+kYQe14DCV5OSAnxrg@mail.gmail.com>
 <20190115090400.GA2267@localhost.localdomain>
 <20190218143742.GA11872@redhat.com>
 <20190226100535.GA20740@8bytes.org>
 <20190226103450.GA2989@redhat.com>
 <20190226104413.GH20740@8bytes.org>
 <20190226112407.GB2989@redhat.com>
 <20190228090411.GA24938@redhat.com>
 <20190228104223.GA2749@redhat.com>
 <20190228121948.GD6072@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190228121948.GD6072@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Feb 28, 2019 at 01:19:48PM +0100, Stanislaw Gruszka wrote:
> Nevermind, the patch is wrong, s->dma_address is initalized in sg_num_pages().

Yes, it is. In sg_num_pages() the offset into the IOMMU mapping is
stored in s->dma_address, taking also the segment boundary mask into
account. map_sg() later only adds the base-address to that.

Regards,

	Joerg
