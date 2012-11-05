Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37009 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab2KENUt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 08:20:49 -0500
Message-ID: <1352121685.9466.7.camel@jlt4.sipsolutions.net> (sfid-20121105_142105_013613_132C01A8)
Subject: Re: [PATCH] mac80211: sync acccess to tx_filtered/ps_tx_buf queues
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 05 Nov 2012 14:21:25 +0100
In-Reply-To: <1352104072-7199-1-git-send-email-arik@wizery.com> (sfid-20121105_092806_116083_BAE1FAF2)
References: <1352104072-7199-1-git-send-email-arik@wizery.com>
	 (sfid-20121105_092806_116083_BAE1FAF2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-05 at 10:27 +0200, Arik Nemtsov wrote:
> These are accessed without a lock when ending STA PSM. If the
> sta_cleanup timer accesses these lists at the same time, we might crash.
> 
> This may fix some mysterious crashes we had during
> ieee80211_sta_ps_deliver_wakeup.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Ido Yariv <ido@wizery.com>

Applied, thanks!

johannes

