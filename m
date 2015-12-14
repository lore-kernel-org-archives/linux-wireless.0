Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33811 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbbLNRaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 12:30:15 -0500
Received: by pacwq6 with SMTP id wq6so106771494pac.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 09:30:15 -0800 (PST)
Date: Mon, 14 Dec 2015 09:30:11 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-mtd@lists.infradead.org, linux-wireless@vger.kernel.org,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH] mtd: nand: bcm47xxnflash: fix bcm47xxnflash_remove()
Message-ID: <20151214173011.GA15605@localhost> (sfid-20151214_183022_923362_41EEFD7A)
References: <1450113250-12036-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1450113250-12036-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 14, 2015 at 06:14:10PM +0100, Boris Brezillon wrote:
> bcm47xxnflash_remove() is supposed to unregister the NAND device previously
> registered in bcm47xxnflash_probe(), but the current implementation just
> test for the always NULL ->mtd platform data field (and does not call the
> right function to unregister it).
> 
> Kill the useless ->mtd field in struct bcma_nflash, and release the real
> NAND device in bcm47xxnflash_remove().
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Fixes: a5401370c520 ("mtd: prepare place for BCMA NAND flash driver(s)")
> Cc: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/mtd/nand/bcm47xxnflash/main.c       | 7 ++++---
>  include/linux/bcma/bcma_driver_chipcommon.h | 4 ----
>  2 files changed, 4 insertions(+), 7 deletions(-)

Hmm, looks awfully similar...

http://patchwork.ozlabs.org/patch/554164/
