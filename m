Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:41736 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab3LSUx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 15:53:26 -0500
Received: by mail-pd0-f182.google.com with SMTP id v10so1609895pde.13
        for <linux-wireless@vger.kernel.org>; Thu, 19 Dec 2013 12:53:25 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux@eikelenboom.it, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/3] cfg80211: process pending regulatory requests
Date: Thu, 19 Dec 2013 12:53:16 -0800
Message-Id: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131219_215330_786332_31AB0B29)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sander spotted that regulatory requests get stalled when
cfg80211 is built-in. This issue is hit since regulatory
requests only trigger a udev rule to run CRDA when
being processed and if cfg80211 is built-in the udev rule
that kicks CRDA could end up doing nothing as the filesystem
path that has CRDA may not be mounted yet. This series of
patches addresses this situation by allowing us to reprocess
the last pending regulatory request. We add support for that
by first taking into consideration the RCU case where the
request being processed is the last request, then by
trying to reprocess the last request if we find it hasn't
been processed yet when checking the queues, and lastly by
adding some opportunistic checks of the pending regulatory
work when bringing an interface up or down.

If folks want to consider this for stable the first two
seem least intrusive and address the issue but those two
patches still require a trigger to process the queue.
Typically the queues will be processed on a system after
bootup after the interface comes up and finds some beacon
hints on 5 gHz, or when a user asks to change regulatory
domains. The last patch tries to avoid requiring this
and I consider it more an enhancement.

Luis R. Rodriguez (3):
  cfg80211: allow reprocessing of pending requests
  cfg80211: fix processing world regdomain when non modular
  cfg80211: processing regulatory requests on netdev notifier

 net/wireless/core.c |  2 ++
 net/wireless/reg.c  | 21 ++++++++++++++-------
 net/wireless/reg.h  |  1 +
 3 files changed, 17 insertions(+), 7 deletions(-)

-- 
1.8.4.3

