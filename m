Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48656 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbaLPJIR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2014 04:08:17 -0500
Message-ID: <548FF67D.4000902@openwrt.org> (sfid-20141216_100822_930674_434583DC)
Date: Tue, 16 Dec 2014 10:08:13 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Bartosz Szczepanek <barteks7r@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add an intermediate software queue implementation
References: <1416352495-82172-1-git-send-email-nbd@openwrt.org>	<1418390516.2470.46.camel@sipsolutions.net>	<548AF047.9080404@openwrt.org>	<1418392866.2470.49.camel@sipsolutions.net>	<548AFB9C.1060408@openwrt.org>	<1418644802.5731.3.camel@sipsolutions.net> <CAJzaN5pix=R8RR5wzv7vbtYfHcGJytuUfd3f1QsNo-QqKUf-8Q@mail.gmail.com>
In-Reply-To: <CAJzaN5pix=R8RR5wzv7vbtYfHcGJytuUfd3f1QsNo-QqKUf-8Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-12-16 00:25, Bartosz Szczepanek wrote:
> As for drv_wake_tx_queue and ieee80211_tx_dequeue - is it really
> necessary? There are ieee80211_tx_status and ieee80211_free_txskb
> already, which can be used to decide from mac80211 level when to
> dequeue packet. It could be used even in case of drivers that are not
> aware of new mechanism at all. We could compute difference between
> drv_tx and tx_status/free_txskb calls, therefore getting number of
> frames in HW. What could help us to keep queues short.
Keeping the driver queue short is a bad idea if the driver needs deeper
queues to do aggregation.

> I've already written some code. This http://pastebin.com/dSd1zWt7 is
> patch that implements counter of frames in hardware in the way
> described above. It was necessary to differentiate between free_txskb
> and free_txskb. Information about frames in HW is exported to debugfs.
> I thought I could submit it, but just now did I found this thread, so
> I hope that it's adequate place to propose that. I tested it on ath5k
> and brcmsmac.
For aggregation, different drivers need different kinds of scheduling.
Only packets belonging to the same sta/tid can be aggregated, and in AP
mode you can have concurrent traffic of multiple different sta/tid.
The only way to keep queues really short in that case without
sacrificing throughput is to let the aggregation code fetch packets
directly from sta/tid queues.
With ath5k there is no aggregation yet (we could add A-MSDU at some
point), and with brcmsmac, the driver has an internal layer of queueing
to create per-sta/tid queues.
What I'm proposing is having per-sta/tid queues that are shared between
mac80211 and the driver, which will significantly improve queue
management compared to having multiple competing layers of queueing.

> One more thing - why not to use local->pending for holding packets?
> There is tx_pending tasklet already. I'm not sure if I understand the
> idea of local->pending queues correctly, but it seems to be a bit
> incoherent to have both pending and proposed ieee80211_txq.
local->pending is useless for normal tx queueing purposes, because it's
not per-sta/tid.

- Felix
