Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:44161 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760731Ab3DCCns convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 22:43:48 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"daniel@zonque.org" <daniel@zonque.org>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>
Date: Tue, 2 Apr 2013 19:40:53 -0700
Subject: RE: [PATCH 1/6] mwifiex: bug: remove NO_PKT_PRIO_TID.
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DDAB197@SC-VEXCH1.marvell.com> (sfid-20130403_044353_084625_226F63BB)
References: <20130402000511.GA31921@blumentopf>
 <1364861325-30844-1-git-send-email-andreas.fenkart@streamunlimited.com>
In-Reply-To: <1364861325-30844-1-git-send-email-andreas.fenkart@streamunlimited.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andi,

Thanks for the patchset.

> Using NO_PKT_PRIO_TID and tx_pkts_queued to check for an empty state, can
> lead to a contradictory state, resulting in an infinite loop.
> Currently queueing and dequeuing of packets is not synchronized, and can
> happen concurrently. While tx_pkts_queued is incremented when adding a
> packet, max prio is set to NO_PKT when the WMM list is empty. If a packet
> is added right after the check for empty, but before setting max prio to
> NO_PKT, that packet is trapped and creates an infinite loop.
> Because of the new packet, tx_pkts_queued is at least 1, indicating wmm
> lists are not empty. Opposing that max prio is NO_PKT, which means "skip
> this wmm queue, it has no packets". The infinite loop results, because the
> main loop checks the wmm lists for not empty via tx_pkts_queued, but when
> dequeing uses max_prio to see if it can skip a list. This will never end,
> unless a new packet is added which will restore max prio to the level of
> the trapped packet.
> The solution here is to rely on tx_pkts_queued solely for checking wmm
> queue to be empty, and drop the NO_PKT define. It does not address the
> locking issue.
> 
> Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>

With this patch (1/6) applied, I'm getting soft-lockup watchdog:

BUG: soft lockup - CPU#3 stuck for 22s! [kworker/3:1:37]

I'm running 64-bit Ubuntu 12.04 (latest wireless-testing.git) with SD8787.
The BUG is hit when I enter "dhclient" command after association.

# iw mlan0 scan
# iw mlan0 connect MY_AP
# dhclient mlan0

BTW, if I apply the first 5 patches (1/6-5/6) or all 6 patches together, the soft-lockup BUG is gone.
Any ideas?

Thanks,
Bing

