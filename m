Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab1AUVvm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 16:51:42 -0500
Subject: Re: [PATCH 1/3] libertas_spi: Use workqueue in hw_host_to_card
From: Dan Williams <dcbw@redhat.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Marek Vasut <marek.vasut@gmail.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>,
	Colin McCabe <colin@cozybit.com>
Date: Fri, 21 Jan 2011 15:52:19 -0600
In-Reply-To: <201101212324.29978.anarsoul@gmail.com>
References: <1295642690-16646-1-git-send-email-anarsoul@gmail.com>
	 <1295642690-16646-2-git-send-email-anarsoul@gmail.com>
	 <201101212222.37667.marek.vasut@gmail.com>
	 <201101212324.29978.anarsoul@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1295646740.1473.0.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-01-21 at 23:24 +0200, Vasily Khoruzhick wrote:
> On Friday 21 January 2011 23:22:37 Marek Vasut wrote:
> > On Friday 21 January 2011 21:44:48 Vasily Khoruzhick wrote:
> > > Use workqueue to perform SPI xfers, it's necessary to fix
> > > nasty "BUG: scheduling while atomic", because
> > > spu_write() calls spi_sync() and spi_sync() may sleep, but
> > > hw_host_to_card() callback can be called from atomic context.
> > > Remove kthread completely, workqueue now does its job.
> > > Restore intermediate buffers which were removed in commit
> > > 86c34fe89e9cad9e1ba4d1a8bbf98259035f4caf that introduced
> > > mentioned bug.
> > 
> > I have two questions:
> > 
> > 1) Why not leave kthread there? ie. why switch to workqueue
> 
> Because it's not easy to ensure that kthread did its job in suspend handler,
> and to make if_spi.c look similar to if_sdio.c.
> 
> > 2) This should be split into two patches I guess -- a) revert the change b)
> > convert to workqueue -- so they can be (N)ACKed separatedly
> 
> Actually just reverting commit does not make driver work (it will fail on 
> rmmod), and it can impact on future bisect (if it'll be necessary). But if 
> it's requirement - ok.

I'll disagree with Marek; I don't think it's a hard requirement as long
as there's a good reason.  And if the driver doesn't work by reverting,
then you're right bisect is broken and that sucks.  I don't have a
problem with the "mega" patch (given that it's not really that large).

Dan


