Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47146 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab1BSJOz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 04:14:55 -0500
Subject: Re: [PATCH 1/2] mac80211: Fix a race on enabling power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: Vivek Natarajan <Vivek.Natarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110219061241.GA5881@vmraj-lnx.users.atheros.com>
References: <1298018776-6936-1-git-send-email-vnatarajan@atheros.com>
	 <1298027245.3772.3.camel@jlt3.sipsolutions.net>
	 <20110219061241.GA5881@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Feb 2011 10:14:50 +0100
Message-ID: <1298106890.3725.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-02-19 at 11:42 +0530, Rajkumar Manoharan wrote:

> > I know we currently don't allow powersave when there's more than one
> > interface, but we still allow it while there are monitor interfaces and
> > a monitor interface could be sending packets, which would violate the
> > flush() contract with the driver -- the driver may expect not to get any
> > packets during flush.

> AFIK we also are not stopping tx queue of monitor iface on offchannel.
> Doing so could help flush().

Hrm, indeed. And we can't even stop the queues there. We can pause them
for the flush though. In fact, why don't we just stop device queues for
flush and bypass this problem. I also think we should flush the status
tasklet when drv_flush() has returned so that all status processing is
also flushed out before we return to regular processing.

> > I'm not sure. Maybe we should disable powersave when there are monitor
> > interfaces after all, even though that would rob us of a way to debug
> > things. Thoughts?

> drivers like ath9k receives all frames from any bss on FIF_PROMISC_IN_BSS,
> since there is no specific hw filter for that. So in that case it would be
> better to disable power save.

Well, I'm not convinced yet -- it will likely also complicate the code
quite a bit when we want to implement NoA powersave etc. Of course we're
trying to get rid of monitor interfaces there anyway, but still ...

johannes

