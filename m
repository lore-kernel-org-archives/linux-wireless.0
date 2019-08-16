Return-Path: <SRS0=l5SL=WM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDDEC3A59E
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Aug 2019 16:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 404602077C
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Aug 2019 16:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfHPQnF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Aug 2019 12:43:05 -0400
Received: from verein.lst.de ([213.95.11.211]:56730 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbfHPQnF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Aug 2019 12:43:05 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 951D168B05; Fri, 16 Aug 2019 18:43:01 +0200 (CEST)
Date:   Fri, 16 Aug 2019 18:43:01 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nicoleotsuka@gmail.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, iommu@lists.linux-foundation.org,
        tobias.klausmann@freenet.de
Subject: Re: regression in ath10k dma allocation
Message-ID: <20190816164301.GA3629@lst.de>
References: <8fe8b415-2d34-0a14-170b-dcb31c162e67@mni.thm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fe8b415-2d34-0a14-170b-dcb31c162e67@mni.thm.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Tobias,

do you have CONFIG_DMA_CMA set in your config?  If not please make sure
you have this commit in your testing tree, and if the problem still
persists it would be a little odd and we'd have to dig deeper:

commit dd3dcede9fa0a0b661ac1f24843f4a1b1317fdb6
Author: Nicolin Chen <nicoleotsuka@gmail.com>
Date:   Wed May 29 17:54:25 2019 -0700

    dma-contiguous: fix !CONFIG_DMA_CMA version of dma_{alloc, free}_contiguous()

