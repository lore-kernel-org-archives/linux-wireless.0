Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43539 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1FSILw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 04:11:52 -0400
Subject: Re: [PATCH] mac80211: quiesce vif before suspending
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1308214173-26950-1-git-send-email-eliad@wizery.com> (sfid-20110616_104858_553374_6C008F9A)
References: <1308214173-26950-1-git-send-email-eliad@wizery.com>
	 (sfid-20110616_104858_553374_6C008F9A)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Jun 2011 10:11:50 +0200
Message-ID: <1308471110.4145.7.camel@jlt3.sipsolutions.net> (sfid-20110619_101156_398454_0F322DC0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-06-16 at 11:49 +0300, Eliad Peller wrote:
> Cancel all relevant timers/works before suspending (wowlan).
> 
> This patch handles the following warning:
> WARNING: at net/mac80211/util.c:565 queueing ieee80211 work while going to suspend
> Backtrace:
> [<bf07b598>] (ieee80211_can_queue_work+0x0/0x4c [mac80211])
> [<bf07c28c>] (ieee80211_queue_work+0x0/0x30 [mac80211])
> [<bf0690dc>] (ieee80211_sta_timer+0x0/0x3c [mac80211])
> [<c00a3008>] (run_timer_softirq+0x0/0x220)
> [<c009e530>] (__do_softirq+0x0/0x130)
> [<c009e660>] (irq_exit+0x0/0xb4)
> [<c004c4a0>] (ipi_timer+0x0/0x4c)
> [<c0046350>] (do_local_timer+0x0/0x88)
> [<c00488ec>] (cpu_idle+0x0/0xe0)
> [<c05294e8>] (rest_init+0x0/0xe0)
> [<c0008958>] (start_kernel+0x0/0x314)

Yeah I think this was the patch you told be about earlier, thanks.

johannes

