Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36389 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbYEAPoN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 11:44:13 -0400
Date: Thu, 1 May 2008 11:43:58 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Christoph Hellwig <hch@infradead.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	John Linville <linville@tuxdriver.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Miller <davem@davemloft.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Ingo Molnar <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Add API for weak DMA masks
Message-ID: <20080501154358.GA3318@infradead.org> (sfid-20080501_174405_128360_ABB30D8A)
References: <200805011638.15910.mb@bu3sch.de> <20080501153618.GA470@infradead.org> <200805011742.05302.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200805011742.05302.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 01, 2008 at 05:42:04PM +0200, Michael Buesch wrote:
> Yeah. because it has to be done in every driver.
> So we put the implementation into a central place, instead of
> reimplementing the wheel over and over again. This way we avoid bugs,
> like the "b43 broken on VIA boards" in the first place.
> Currently every driver requesting a >32bit mask and not retrying with
> a lower mask is broken on VIA hardware. I dunno how many of the current
> drivers that are, but everybody can easily see that is not a b43-specific
> problem that we should solve for b43 only.

Yeah.  Personally I'd rather let set_dma_mask fall back silently,
I can't imagine a lot of cases where the driver cares that it only
gets dma in the lower 32bit.  And if there is any such case it
can still check the dma mask afterwards.

