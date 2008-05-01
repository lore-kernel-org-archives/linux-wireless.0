Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:51794 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbYEAOpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 10:45:10 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
	John Linville <linville@tuxdriver.com>
Subject: [PATCH 0/3] Add API for weak DMA masks
Date: Thu, 1 May 2008 16:38:15 +0200
Cc: Andi Kleen <andi@firstfloor.org>,
	David Miller <davem@davemloft.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Ingo Molnar <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	"linux-kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805011638.15910.mb@bu3sch.de> (sfid-20080501_164457_457052_1AEB245A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds API and one user for a "weak" dma_set_mask().
Weak means that it will fallback to smaller masks in case the
DMA subsystem rejects a big mask.
Currently such rejection may happen if the driver requests a 64bit
mask on a VIA machine, for example. dma_set_mask_weak() will fallback
to 32bit, in that case, and tell the caller about it by modifying the
passed mask.

I'm not sure how we should merge this patchset.
I'd suggest we merge it all through John Linville for 2.6.27, as the
only current user of the API is the b43 wireless driver.
We could split it and push the nonwireless parts to somebody else's tree,
but I'm not sure it's worth the trouble.

-- 
Greetings Michael.
