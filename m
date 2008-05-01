Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:60089 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbYEAQIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 12:08:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] Add API for weak DMA masks
Date: Thu, 1 May 2008 18:07:25 +0200
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
	John Linville <linville@tuxdriver.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Miller <davem@davemloft.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Ingo Molnar <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <200805011638.15910.mb@bu3sch.de> <200805011747.27469.mb@bu3sch.de> <20080501155826.GA11188@infradead.org>
In-Reply-To: <20080501155826.GA11188@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805011807.26036.mb@bu3sch.de> (sfid-20080501_180751_856667_0C028CD7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 01 May 2008 17:58:26 Christoph Hellwig wrote:
> On Thu, May 01, 2008 at 05:47:26PM +0200, Michael Buesch wrote:
> > We've discussed that and this behaviour is not acceptable, as the driver
> > must know about a possible fallback in case it can do 32bit DMA
> > more efficiently than 64bit DMA, for example.
> 
> That's what we have dma_get_required_mask() for.  See
> Documentation/DMA-API.txt.

So well. I'm still unsure about the advantage of having some opencoded
probe loop in the driver, instead of implementing it in a common place
and doing all of it with a single API call.
We can still call dma_get_required_mask() and adjust the mask to that
in dma_set_mask_weak(). That can _additionally_ be done there.

-- 
Greetings Michael.
