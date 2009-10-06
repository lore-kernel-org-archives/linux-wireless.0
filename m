Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42501 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933223AbZJFVQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 17:16:43 -0400
Date: Tue, 6 Oct 2009 17:13:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Albert Herranz <albert_herranz@yahoo.es>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: do not stack-allocate pio rx/tx header buffers
Message-ID: <20091006211337.GD2911@tuxdriver.com>
References: <1254846043-7121-1-git-send-email-albert_herranz@yahoo.es> <200910062252.17565.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200910062252.17565.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 06, 2009 at 10:52:15PM +0200, Michael Buesch wrote:
> On Tuesday 06 October 2009 18:20:43 Albert Herranz wrote:
> > The DMA-API debugging facility complains about b43 mapping memory from
> > stack for SDIO-based cards, as can be seen in the following two
> > stack traces.

<snip>

> > Indeed, b43 currently allocates the PIO RX and TX header buffers
> > from stack. The solution here is to use heap-allocated buffers instead.
> > 
> > Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>

<snip>

> Just embed it into struct b43_wl (surround it by #ifdef CONFIG_B43_PIO). No need
> to kzalloc then and it saves some memory.
> You also need to alloc 4 bytes for the tail buffer (that currently is on the stack, too).

Please make the changes Michael requested and resubmit -- I'll happily
make the adjustments to wireless-testing, etc.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
