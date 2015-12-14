Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:34546 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbbLNSMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 13:12:38 -0500
Received: by pfbo64 with SMTP id o64so30599981pfb.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 10:12:38 -0800 (PST)
Date: Mon, 14 Dec 2015 10:12:35 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: linux-mtd@lists.infradead.org,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mtd: bcm47xxnflash: really unregister NAND on device
 removal
Message-ID: <20151214181235.GA10460@google.com> (sfid-20151214_191241_698731_CDE887BE)
References: <1449623099-21634-1-git-send-email-computersforpeace@gmail.com>
 <20151214184907.3460eb71@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20151214184907.3460eb71@bbrezillon>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 14, 2015 at 06:49:07PM +0100, Boris Brezillon wrote:
> On Tue,  8 Dec 2015 17:04:59 -0800
> Brian Norris <computersforpeace@gmail.com> wrote:
> 
> > The field bcma_nflash::mtd is never set to be non-zero anywhere, but we
> > test for it in the removal path. So the MTD is never unregistered.
> > 
> > Also, we should use nand_release(), not mtd_device_unregister().
> > 
> > Finally, we don't need to use the 'platdata' for stashing/retrieving our
> > *driver* data -- that's what *_{get,set}_drvdata() are for.
> > 
> > So, kill off bcm_nflash::mtd, and stash the struct bcm47xxnflash in
> > drvdata instead. Also move the forward declaration of mtd_info up a bit,
> > since struct bcma_sflash should be using it.
> > 
> > Caught while inspecting other changes being made to this driver. Compile
> > tested only.
> > 
> > Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> > Cc: "Rafał Miłecki" <zajec5@gmail.com>
> > Cc: linux-wireless@vger.kernel.org
> 
> Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Applied to l2-mtd.git
