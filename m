Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:22816 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaFDQPi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 12:15:38 -0400
Date: Wed, 4 Jun 2014 21:46:21 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/13] ath9k: Channel context support
Message-ID: <20140604161619.GA14852@qca.qualcomm.com> (sfid-20140604_181542_431423_2F0FD53C)
References: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1401890446.6079.31.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1401890446.6079.31.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 04, 2014 at 04:00:46PM +0200, Johannes Berg wrote:
> On Wed, 2014-06-04 at 19:16 +0530, Rajkumar Manoharan wrote:
> 
> > These patches adds a basic infrastruture for multi channel
> > context. Currently channel context usage is restricted by
> > modparam "use_chanctx" as it is not yet fully implemented.
> 
> This isn't really a review - just a note. You should probably also tell
> mac80211 that you use multiple HW queues (at least per chanctx) so you
> avoid a situation where stopping one channel context leads to stopping
> the entire traffic for that AC even on other contexts, otherwise you
> could unfairly stop the other interface?
>
Completely agree. IEEE80211_HW_QUEUE_CONTROL support is still in-progress.

> I guess I'm also surprised by the implementation just switching from a
> worker, I would have thought you'd switch from a HW timer interrupt and
> use different hardware queues, but hey :)
>
These are just a preparatory changes for enabling MCC. The actual
scheduler is based on HW timers that will kickstart the worker thread.
Will post all of the changes after completing regression test cycle.

-Rajkumar
