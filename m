Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:34972 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab0FUSps (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 14:45:48 -0400
Subject: Re: [PATCH 2/2] wl1251: fix ELP_CTRL register reads
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	"John W.Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimLKDqDn_97BbOYr1cdxbFdPvyTz_lxJ59LVJ1b@mail.gmail.com>
References: <1275693948-3189-1-git-send-email-notasas@gmail.com>
	 <1275693948-3189-2-git-send-email-notasas@gmail.com>
	 <AANLkTinqgUGCjCBzg8j7bXGY05EW3-jfW7vlnrvCuwRd@mail.gmail.com>
	 <1277124410.28895.23.camel@gnutoo-laptop>
	 <AANLkTimLKDqDn_97BbOYr1cdxbFdPvyTz_lxJ59LVJ1b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 20:45:01 +0200
Message-ID: <1277145901.28895.29.camel@gnutoo-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-21 at 13:54 -0400, Bob Copeland wrote:
> On Mon, Jun 21, 2010 at 8:46 AM, Denis 'GNUtoo' Carikli
> <GNUtoo@no-log.org> wrote:
> 
> > Hi, me and some other people are trying to run standard GNU/Linux (not
> > android ) on the htcdream.
> 
> > [ 1556.425354] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> > [ 1556.734130] mmc0: Command timeout
> 
> In this case it was only up for 1/3 second before it quit
> responding to reads.  With power saving disabled it works?
In this case I think only some command timeout(If I remember well it
worked for a bit and then stopped working)
But I'm sure that you can ping with the command timeout and have some
transfers etc...

With power saving disabled it works fine,until the battery goes out.
Disabling power saving also stop the flow of timeout messages...

> Probably not relevant to power saving, but:
> 
> Are you using the dedicated irq line or sdio interrupt?
> It makes a big difference in overall throughput to use
> the former.
I don't know. what should I grep for?

> > +       /*
> > +        * FIXME: scanning while associated causes lockups,
> > +        * so we don't allow that
> > +        */
> > +       if (wl->associated)
> > +               return -EBUSY;
> 
> Any idea why?  Could you turn on lockdep?
No I just used the patches that weren't mine
I took them from openpandora wireless repository,looked if they were
already included,and include the one that weren't.

Denis.


