Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:59162 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755202Ab1ELOPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 10:15:49 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so639106eyx.33
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 07:15:48 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/7] wl12xx: scheduled scan implementation
Date: Thu, 12 May 2011 17:15:33 +0300
Message-Id: <1305209740-30287-1-git-send-email-coelho@ti.com> (sfid-20110512_161552_383549_3472EB3C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is the patch set that I'm going to apply to wl12xx soon.  It's basically
the same as the RFC I sent earlier, but with two extra patches:

* prevent sched_scan in states not supported by the FW (ie. not STA or not idle)
* remove one unused flag (clean-up and not really related to sched_scan)

Cheers,
Luca.


Luciano Coelho (7):
  wl12xx: add configuration values for scheduled scan
  wl12xx: listen to scheduled scan events
  wl12xx: add scheduled scan structures and commands
  wl12xx: implement scheduled scan driver operations and reporting
  wl12xx: export scheduled scan state in debugfs
  wl12xx: prevent sched_scan when not idle or not in station mode
  wl12xx: remove unused flag WL1271_FLAG_IDLE_REQUESTED

 drivers/net/wireless/wl12xx/boot.c    |    4 +-
 drivers/net/wireless/wl12xx/conf.h    |   21 +++
 drivers/net/wireless/wl12xx/debugfs.c |    1 +
 drivers/net/wireless/wl12xx/event.c   |   16 ++
 drivers/net/wireless/wl12xx/main.c    |   79 +++++++++++
 drivers/net/wireless/wl12xx/scan.c    |  243 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/scan.h    |  114 +++++++++++++++
 drivers/net/wireless/wl12xx/wl12xx.h  |    3 +-
 8 files changed, 479 insertions(+), 2 deletions(-)

