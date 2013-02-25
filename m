Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:56029 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab3BYUsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 15:48:07 -0500
Date: Mon, 25 Feb 2013 15:48:05 -0500 (EST)
Message-Id: <20130225.154805.1538752246011578467.davem@davemloft.net> (sfid-20130225_214817_245226_0939AC3B)
To: Larry.Finger@lwfinger.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] b43: Fix lockdep splat on module unload
From: David Miller <davem@davemloft.net>
In-Reply-To: <1361808564-22684-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1361808564-22684-1-git-send-email-Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 25 Feb 2013 10:09:24 -0600

> On unload, b43 produces a lockdep warning that can be summarized in the
> following way:
> 
>  ======================================================
>  [ INFO: possible circular locking dependency detected ]
>  3.8.0-wl+ #117 Not tainted
>  -------------------------------------------------------
>  modprobe/5557 is trying to acquire lock:
>   ((&wl->firmware_load)){+.+.+.}, at: [<ffffffff81062160>] flush_work+0x0/0x2a0
> 
>  but task is already holding lock:
>   (rtnl_mutex){+.+.+.}, at: [<ffffffff813bd7d2>] rtnl_lock+0x12/0x20
> 
>  which lock already depends on the new lock.
>  [ INFO: possible circular locking dependency detected ]
>  ======================================================
> 
> The full output is available at http://lkml.indiana.edu/hypermail/linux/kernel/1302.3/00060.html.
> To summarize, commit 6b6fa58 added a 'cancel_work_sync(&wl->firmware_load)'
> call in the wrong place.
> 
> The fix is to move the cancel_work_sync() call to b43_bcma_remove() and
> b43_ssb_remove(). Thanks to Johannes Berg and Michael Buesch for help in
> diagnosing the log output.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Applied.
