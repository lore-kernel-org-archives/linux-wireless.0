Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:59323 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761891Ab3DDU5O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 16:57:14 -0400
Received: from mailout-de.gmx.net ([10.1.76.31]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MT5po-1UEPZW2ILO-00SAoA for
 <linux-wireless@vger.kernel.org>; Thu, 04 Apr 2013 22:57:12 +0200
Date: Thu, 4 Apr 2013 22:57:07 +0200
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: Andreas Fenkart <andreas.fenkart@streamunlimited.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"daniel@zonque.org" <daniel@zonque.org>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: Re: [PATCH 1/6] mwifiex: bug: remove NO_PKT_PRIO_TID.
Message-ID: <20130404205706.GA29851@blumentopf> (sfid-20130404_225719_232301_7BF750DA)
References: <20130402000511.GA31921@blumentopf>
 <1364861325-30844-1-git-send-email-andreas.fenkart@streamunlimited.com>
 <477F20668A386D41ADCC57781B1F70430D9DDAB197@SC-VEXCH1.marvell.com>
 <20130403113554.GA14785@blumentopf>
 <477F20668A386D41ADCC57781B1F70430D9DDAB35D@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9DDAB35D@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,
On Wed, Apr 03, 2013 at 11:37:43AM -0700, Bing Zhao wrote:
> 
[snip]
> > How should I proceed? Can I reorder patches to match my
> > development cycle, which is? 2-5;1;6 or more verbosely
> > cleanup first followed by bug fix and proper locking last

> You can separate 6 patches into two patch sets.
> 1-3 fix the bug and clean up.
> 4-6 implement ra list rotation and proper locking.

I reworked the patchset and split into two.


set 1:
1/4 mwifiex: rework round robin scheduling of bss nodes.
2/4 mwifiex: replace ra_list_curr by list rotation.
3/4 mwifiex: bug: hold proper locks when accessing ra_list / bss_prio lists.
4/4 mwifiex: bug: remove NO_PKT_PRIO_TID.

3/4 previous 6/6 is bugfix now:

        ...
        Another race condition exists, if a new highest priority
        packet is added. If concurrently a packet is dequeued, the newly
        set max prio will be overwritten with the value of the dequeued
        packet. This can occur, because selecting a packet and modifying
        the max prio is not atomic. This results in an infinite loop
        unless, a new packet is added that has at least the priority of
        the hidden packet.
        ...


set 2:
1/2 mwifiex: remove unused tid_tbl_lock from mwifiex_tid_tbl.
2/2 mwifiex: bug: wrong list in list_empty check.

Patch set 2 can be delayed, but since hard to read code probably
introduced all the problems, I suggest to apply it promptly.
It simplifies the code a lot.


> 
> We will run stress tests against 4-6.

I'm here at 4+ days, still running. This exceeds all previous
tests on my particular setup.

> 
> Thanks,
> Bing

rgds,
Andi
