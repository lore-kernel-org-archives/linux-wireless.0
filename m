Return-Path: <SRS0=ropy=UK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25750C43218
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Jun 2019 07:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 045EE208E3
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Jun 2019 07:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404525AbfFKHzI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Jun 2019 03:55:08 -0400
Received: from verein.lst.de ([213.95.11.211]:48948 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403815AbfFKHzI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Jun 2019 03:55:08 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id CC02568B02; Tue, 11 Jun 2019 09:54:39 +0200 (CEST)
Date:   Tue, 11 Jun 2019 09:54:39 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Christian Zigotzky <chzigotzky@xenosoft.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BISECTED REGRESSION] b43legacy broken on G4 PowerBook
Message-ID: <20190611075439.GB21815@lst.de>
References: <20190605225059.GA9953@darkstar.musicnaut.iki.fi> <73da300c-871c-77ac-8a3a-deac226743ef@lwfinger.net> <7697a9d10777b28ae79fdffdde6d0985555f6310.camel@kernel.crashing.org> <3ed1ccfe-d7ca-11b9-17b3-303d1ae1bb0f@lwfinger.net> <c91ccbddd6a58dbee5705f10ed1d98fb44bd8f8d.camel@kernel.crashing.org> <20190611060816.GA20158@lst.de> <fdfc817d1dcdc83f5bc45f0ab12cbce0c61e6702.camel@kernel.crashing.org> <b30ced162fa96d0ca63b8b9629d6fe9bc5c78746.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b30ced162fa96d0ca63b8b9629d6fe9bc5c78746.camel@kernel.crashing.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jun 11, 2019 at 04:59:54PM +1000, Benjamin Herrenschmidt wrote:
> Ah stupid me ... it's dma_set_mask that failed, since it has no idea
> that the calling driver is limited to lowmem.
> 
> That's also why the "wrong" patch worked.
> 
> So yes, a ZONE_DMA at 30-bits will work, though it's somewhat overkill.

Well, according to Larry it doesn't actually work, which is odd.
