Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53199 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbbIGOxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 10:53:32 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Lin <dlin@marvell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Chor Teck Law" <ctlaw@marvell.com>
Subject: Re: [PATCH v6] Add new mac80211 driver mwlwifi.
References: <20456de5ab0b43b69441b19abb282c31@SC-EXCH02.marvell.com>
Date: Mon, 07 Sep 2015 17:53:26 +0300
In-Reply-To: <20456de5ab0b43b69441b19abb282c31@SC-EXCH02.marvell.com> (David
	Lin's message of "Thu, 9 Jul 2015 23:19:27 +0000")
Message-ID: <87zj0yb7rt.fsf@kamboji.qca.qualcomm.com> (sfid-20150907_165335_507237_C79F4158)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Lin <dlin@marvell.com> writes:

> The Linux driver for WRT1900AC. The work was initially developed as part of
> openwrt effort and maintained on https://github.com/kaloz/mwlwifi.
>
> This is still work in progress, with 8864 chipset more mature and tested,
> while 8897 for the similar use case is added recently.
>
> Signed-off-by: David Lin <dlin@marvell.com>

The commit log is really short. For a new driver you should explain a
lot more, for example what works and what doesn't. Also it should
contained detailed info about how and why (!) this conflicts with
mwifiex and the way that problem was solved.

Also no new BUG_ON() calls in drivers, please:

fwcmd.c:        BUG_ON(tid >= SYSADPT_MAX_TID);
mac80211.c:     BUG_ON(queue > SYSADPT_TX_WMM_QUEUES - 1);
mac80211.c:             BUG_ON(stream->state != AMPDU_STREAM_IN_PROGRESS);
tx.c:   BUG_ON(tid > 7);
tx.c:   BUG_ON(tid >= SYSADPT_MAX_TID);
tx.c:   BUG_ON(!tx_skb);

We should start to get rid of all 200+ calls we already have, wireless
drivers should never call BUG_ON(). Instead use descriptive error
message (WARN_ON() etc) and bail out nicely with an error. That's much
more user friendly than crashing the kernel.

-- 
Kalle Valo
