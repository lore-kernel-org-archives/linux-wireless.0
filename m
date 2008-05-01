Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50667 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbYEAPgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 11:36:38 -0400
Date: Thu, 1 May 2008 11:36:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
	John Linville <linville@tuxdriver.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Miller <davem@davemloft.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Ingo Molnar <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Add API for weak DMA masks
Message-ID: <20080501153618.GA470@infradead.org> (sfid-20080501_173625_070134_0D1887D5)
References: <200805011638.15910.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200805011638.15910.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 01, 2008 at 04:38:15PM +0200, Michael Buesch wrote:
> This patchset adds API and one user for a "weak" dma_set_mask().
> Weak means that it will fallback to smaller masks in case the
> DMA subsystem rejects a big mask.
> Currently such rejection may happen if the driver requests a 64bit
> mask on a VIA machine, for example. dma_set_mask_weak() will fallback
> to 32bit, in that case, and tell the caller about it by modifying the
> passed mask.

Why do we need it?  Is the call to set the 32bit mask when it fails
a too big burden for the driver author?

