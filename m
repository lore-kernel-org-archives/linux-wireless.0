Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vserver.eikelenboom.it ([84.200.39.61]:38880 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab3LTMTU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Dec 2013 07:19:20 -0500
Date: Fri, 20 Dec 2013 13:19:13 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Message-ID: <1322748100.20131220131913@eikelenboom.it> (sfid-20131220_131923_560585_ADF7595E)
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3] cfg80211: process pending regulatory requests
In-Reply-To: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com>
References: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Thursday, December 19, 2013, 9:53:16 PM, you wrote:

> Sander spotted that regulatory requests get stalled when
> cfg80211 is built-in. This issue is hit since regulatory
> requests only trigger a udev rule to run CRDA when
> being processed and if cfg80211 is built-in the udev rule
> that kicks CRDA could end up doing nothing as the filesystem
> path that has CRDA may not be mounted yet. This series of
> patches addresses this situation by allowing us to reprocess
> the last pending regulatory request. We add support for that
> by first taking into consideration the RCU case where the
> request being processed is the last request, then by
> trying to reprocess the last request if we find it hasn't
> been processed yet when checking the queues, and lastly by
> adding some opportunistic checks of the pending regulatory
> work when bringing an interface up or down.

> If folks want to consider this for stable the first two
> seem least intrusive and address the issue but those two
> patches still require a trigger to process the queue.
> Typically the queues will be processed on a system after
> bootup after the interface comes up and finds some beacon
> hints on 5 gHz, or when a user asks to change regulatory
> domains. The last patch tries to avoid requiring this
> and I consider it more an enhancement.

> Luis R. Rodriguez (3):
>   cfg80211: allow reprocessing of pending requests
>   cfg80211: fix processing world regdomain when non modular
>   cfg80211: processing regulatory requests on netdev notifier

>  net/wireless/core.c |  2 ++
>  net/wireless/reg.c  | 21 ++++++++++++++-------
>  net/wireless/reg.h  |  1 +
>  3 files changed, 17 insertions(+), 7 deletions(-)


Hi Luis,

I have tested the patches with 3.13-rc4 with wireless-next pulled on top
(patch 1 doesn't apply cleanly to 3.13-rc4 vanilla).

I can report that it works for me with both cases you describe:
- only patches 1 and 2 applied
- all patches applied

Thanks for fixing it !

--

Sander

