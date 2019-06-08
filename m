Return-Path: <SRS0=2AcT=UH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD4DC28CC5
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Jun 2019 07:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B055B208E3
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Jun 2019 07:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfFHHXu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 8 Jun 2019 03:23:50 -0400
Received: from verein.lst.de ([213.95.11.211]:60411 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbfFHHXu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Jun 2019 03:23:50 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 7E63E68B02; Sat,  8 Jun 2019 09:23:22 +0200 (CEST)
Date:   Sat, 8 Jun 2019 09:23:22 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Christoph Hellwig <hch@lst.de>,
        Christian Zigotzky <chzigotzky@xenosoft.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BISECTED REGRESSION] b43legacy broken on G4 PowerBook
Message-ID: <20190608072322.GA18896@lst.de>
References: <20190605225059.GA9953@darkstar.musicnaut.iki.fi> <73da300c-871c-77ac-8a3a-deac226743ef@lwfinger.net> <7697a9d10777b28ae79fdffdde6d0985555f6310.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7697a9d10777b28ae79fdffdde6d0985555f6310.camel@kernel.crashing.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Jun 08, 2019 at 02:21:23PM +1000, Benjamin Herrenschmidt wrote:
> 
> > Please try the attached patch. I'm not really pleased with it and I will 
> > continue to determine why the fallback to a 30-bit mask fails, but at least this 
> > one works for me.
> 
> Your patch only makes sense if the device is indeed capable of
> addressing 31-bits.
> 
> So either the driver is buggy and asks for a too small mask in which
> case your patch is ok, or it's not and you're just going to cause all
> sort of interesting random problems including possible memory
> corruption.

Well, my patches changes ZONE_DMA to be 30-bits instead of 31, and
thus should allow requesting a 30-bit mask to succeed.
