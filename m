Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:48049 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758623Ab1EMMtZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 08:49:25 -0400
Received: by mail-ew0-f48.google.com with SMTP id 22so766133ewy.7
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 05:49:24 -0700 (PDT)
Subject: pull request: wl12xx 2011-05-05
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 15:49:20 +0300
Message-ID: <1305290960.12586.1116.camel@cumari> (sfid-20110513_144928_934618_FB296F91)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

A few more things that would be nice to have included in 2.6.40, if
there is still time to do it.  This pull request includes my changes in
the wl12xx driver to support scheduled scans, Eliad's WoWLAN patches and
two fixes by Shahar: one that enables 802.11h in spectrum management
(which we do support but were not advertising) and one to let HT
information elements be passed up to mac80211 so it can take the
appropriate actions.


Please pull or let me know if there's any problem.  This tree is based
on wireless-next/master.

Thanks!


The following changes since commit 6b86bd62a505a4a9739474f00f8088395b7a80ba:

  mac80211: mesh: move some code to make it static (2011-05-12 14:10:55 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linville

Eliad Peller (7):
      wl12xx: simplify wl1271_ssid_set()
      wl12xx_sdio: set interrupt as wake_up interrupt
      wl12xx: declare suspend/resume callbacks (for wowlan)
      wl12xx_sdio: set MMC_PM_KEEP_POWER flag on suspend
      wl12xx: prevent scheduling while suspending (WoW enabled)
      wl12xx_sdio: declare support for NL80211_WOW_TRIGGER_ANYTHING trigger
      wl12xx: enter/exit psm on wowlan suspend/resume

Luciano Coelho (7):
      wl12xx: add configuration values for scheduled scan
      wl12xx: listen to scheduled scan events
      wl12xx: add scheduled scan structures and commands
      wl12xx: implement scheduled scan driver operations and reporting
      wl12xx: export scheduled scan state in debugfs
      wl12xx: prevent sched_scan when not idle or not in station mode
      wl12xx: remove unused flag WL1271_FLAG_IDLE_REQUESTED

Shahar Levi (2):
      wl12xx: Don't filter beacons that include changed HT IEs
      wl12xx: add IEEE80211_HW_SPECTRUM_MGMT bit to the hw flags

 drivers/net/wireless/wl12xx/boot.c    |    4 +-
 drivers/net/wireless/wl12xx/conf.h    |   21 +++
 drivers/net/wireless/wl12xx/debugfs.c |    1 +
 drivers/net/wireless/wl12xx/event.c   |   23 +++
 drivers/net/wireless/wl12xx/main.c    |  260 +++++++++++++++++++++++++++++++--
 drivers/net/wireless/wl12xx/ps.h      |    2 +
 drivers/net/wireless/wl12xx/scan.c    |  243 ++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/scan.h    |  114 ++++++++++++++
 drivers/net/wireless/wl12xx/sdio.c    |   64 ++++++++-
 drivers/net/wireless/wl12xx/wl12xx.h  |   12 ++-
 10 files changed, 728 insertions(+), 16 deletions(-)

-- 
Cheers,
Luca.

