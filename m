Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40282 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab1AUV03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 16:26:29 -0500
Received: by ewy5 with SMTP id 5so1186502ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 13:26:28 -0800 (PST)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [PATCH 1/3] libertas_spi: Use workqueue in hw_host_to_card
Date: Fri, 21 Jan 2011 23:24:29 +0200
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>,
	Colin McCabe <colin@cozybit.com>
References: <1295642690-16646-1-git-send-email-anarsoul@gmail.com> <1295642690-16646-2-git-send-email-anarsoul@gmail.com> <201101212222.37667.marek.vasut@gmail.com>
In-Reply-To: <201101212222.37667.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Message-Id: <201101212324.29978.anarsoul@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 21 January 2011 23:22:37 Marek Vasut wrote:
> On Friday 21 January 2011 21:44:48 Vasily Khoruzhick wrote:
> > Use workqueue to perform SPI xfers, it's necessary to fix
> > nasty "BUG: scheduling while atomic", because
> > spu_write() calls spi_sync() and spi_sync() may sleep, but
> > hw_host_to_card() callback can be called from atomic context.
> > Remove kthread completely, workqueue now does its job.
> > Restore intermediate buffers which were removed in commit
> > 86c34fe89e9cad9e1ba4d1a8bbf98259035f4caf that introduced
> > mentioned bug.
> 
> I have two questions:
> 
> 1) Why not leave kthread there? ie. why switch to workqueue

Because it's not easy to ensure that kthread did its job in suspend handler,
and to make if_spi.c look similar to if_sdio.c.

> 2) This should be split into two patches I guess -- a) revert the change b)
> convert to workqueue -- so they can be (N)ACKed separatedly

Actually just reverting commit does not make driver work (it will fail on 
rmmod), and it can impact on future bisect (if it'll be necessary). But if 
it's requirement - ok.

> Cheers
