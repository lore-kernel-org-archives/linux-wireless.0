Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:52518 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753126AbbLNRwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 12:52:20 -0500
Date: Mon, 14 Dec 2015 18:52:17 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-mtd@lists.infradead.org, linux-wireless@vger.kernel.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH] mtd: nand: bcm47xxnflash: fix bcm47xxnflash_remove()
Message-ID: <20151214185217.395e9dde@bbrezillon> (sfid-20151214_185229_914170_A43A3EE2)
In-Reply-To: <20151214173011.GA15605@localhost>
References: <1450113250-12036-1-git-send-email-boris.brezillon@free-electrons.com>
	<20151214173011.GA15605@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

On Mon, 14 Dec 2015 09:30:11 -0800
Brian Norris <computersforpeace@gmail.com> wrote:

> On Mon, Dec 14, 2015 at 06:14:10PM +0100, Boris Brezillon wrote:
> > bcm47xxnflash_remove() is supposed to unregister the NAND device previously
> > registered in bcm47xxnflash_probe(), but the current implementation just
> > test for the always NULL ->mtd platform data field (and does not call the
> > right function to unregister it).
> > 
> > Kill the useless ->mtd field in struct bcma_nflash, and release the real
> > NAND device in bcm47xxnflash_remove().
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > Fixes: a5401370c520 ("mtd: prepare place for BCMA NAND flash driver(s)")
> > Cc: Rafał Miłecki <zajec5@gmail.com>
> > ---
> >  drivers/mtd/nand/bcm47xxnflash/main.c       | 7 ++++---
> >  include/linux/bcma/bcma_driver_chipcommon.h | 4 ----
> >  2 files changed, 4 insertions(+), 7 deletions(-)
> 
> Hmm, looks awfully similar...
> 
> http://patchwork.ozlabs.org/patch/554164/

My bad, I completely overlooked it, even though I was in Cc of this
patch.
I acked it, could you apply it before my series so that I can can
adjust the bcma patch?

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
