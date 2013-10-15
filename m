Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43723 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933198Ab3JORAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 13:00:35 -0400
Date: Tue, 15 Oct 2013 12:59:38 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org,
	Sven Neumann <s.neumann@raumfeld.com>,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>,
	Dylan Reid <dgreid@chromium.org>,
	Paul Stewart <pstew@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: Re: [PATCH 3.12] mwifiex: fix SDIO interrupt lost issue
Message-ID: <20131015165938.GA7615@tuxdriver.com> (sfid-20131015_190050_287573_8348B182)
References: <1380304538-2816-1-git-send-email-bzhao@marvell.com>
 <525D1B3A.8090805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <525D1B3A.8090805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 15, 2013 at 12:38:50PM +0200, Daniel Mack wrote: > On 27.09.2013 19:55, Bing Zhao wrote:
> > From: Amitkumar Karwar <akarwar@marvell.com>
> > 
> > 601216e "mwifiex: process RX packets in SDIO IRQ thread directly"
> > introduced a command timeout issue which can be reproduced easily on
> > an AM33xx platform using a test application written by Daniel Mack:
> > 
> > https://gist.github.com/zonque/6579314
> > 
> > mwifiex_main_process() is called from both the SDIO handler and
> > the workqueue. In case an interrupt occurs right after the
> > int_status check, but before updating the mwifiex_processing flag,
> > this interrupt gets lost, resulting in a command timeout and
> > consequently a card reset.
> > 
> > Let main_proc_lock protect both int_status and mwifiex_processing
> > flag. This fixes the interrupt lost issue.
> 
> John, could you take this patch trough your tree?

I already did, and it is already in Dave's tree too...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
