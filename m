Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:35826 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886Ab1E0Me7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 08:34:59 -0400
Received: by mail-ew0-f41.google.com with SMTP id 9so661715ewy.28
        for <linux-wireless@vger.kernel.org>; Fri, 27 May 2011 05:34:57 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, eliad@wizery.com
Subject: [PATCH 2.6.40 0/4] wl12xx: fix passive and DFS scheduled scan
Date: Fri, 27 May 2011 15:34:44 +0300
Message-Id: <1306499688-26603-1-git-send-email-coelho@ti.com> (sfid-20110527_143502_622093_C45B0249)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

I found an oops in wl12xx when trying to run a passive scheduled scan.  While
at it, I found a few other bugs with the generation of the passive and DFS scan
lists.

This series fixes all this.  Do you think it can be included in 2.6.40 still?
At least the fourth patch is very important because it fixes the oops.  If you
want to take only the oops fix but not the rest, I can make a separate patch
for 2.6.40 to prevent the oops by simply returning -EOPNOTSUPP.

What do you think? Should we push all patches to fix this correctly for 2.6.40
or should we just quick-fix the oops? Please let me know what you prefer.

This series replaces the "fix oops in sched_scan when forcing a passive scan" I
have sent earlier.

Cheers,
Luca.


Luciano Coelho (4):
  wl12xx: fix passive and radar channel generation for scheduled scan
  wl12xx: fix DFS channels handling in scheduled scan
  wl12xx: add separate config value for DFS dwell time on sched scan
  wl12xx: fix oops in sched_scan when forcing a passive scan

 drivers/net/wireless/wl12xx/conf.h |    3 ++
 drivers/net/wireless/wl12xx/main.c |    1 +
 drivers/net/wireless/wl12xx/scan.c |   49 ++++++++++++++++++++++++-----------
 drivers/net/wireless/wl12xx/scan.h |    3 ++
 4 files changed, 40 insertions(+), 16 deletions(-)

