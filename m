Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:21037 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681AbYFLLDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 07:03:33 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1935944rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 04:03:33 -0700 (PDT)
Message-ID: <19f34abd0806120403k42d4454ej41b1b6c159c2c6fc@mail.gmail.com> (sfid-20080612_130336_947594_99A455C9)
Date: Thu, 12 Jun 2008 13:03:33 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH] b43: Fix possible NULL pointer dereference in DMA code
Cc: "John Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	"FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
	miles.lane@gmail.com, akpm@linux-foundation.org
In-Reply-To: <200806121158.57287.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200806121158.57287.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 12, 2008 at 11:58 AM, Michael Buesch <mb@bu3sch.de> wrote:
> This fixes a possible NULL pointer dereference in an error path of the
> DMA allocation error checking code. This is also necessary for a future
> DMA API change that is on its way into the mainline kernel that adds
> an additional dev parameter to dma_mapping_error().
>
> This patch moves the whole struct b43_dmaring struct initialization
> right before any DMA allocation operation.
>

Reported-by: Miles Lane <miles.lane@gmail.com>

> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Thanks :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
