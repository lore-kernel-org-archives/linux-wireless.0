Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:37432 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753935Ab1GHIci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 04:32:38 -0400
Received: by bwa19 with SMTP id 19so2444825bwa.15
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jul 2011 01:32:36 -0700 (PDT)
Subject: pull request: wl12xx 2011-07-05
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jul 2011 11:32:33 +0300
Message-ID: <1310113953.1514.607.camel@cumari> (sfid-20110708_103242_281645_169EC4F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is another batch of patches for 3.1, probably the last one if Linus
releases 3.0 next week, as he suggested.

These are just a couple of clean-ups and bugfixes, mostly in AP-mode, by
Arik.

Please pull or let me know if there's any problem. This tree is based
on wireless-next/master.

Thanks!

The following changes since commit 5f0dd296a01c8173fcc05a8b262a1168ae90bc74:

  rt2x00: Implement tx_frames_pending mac80211 callback function. (2011-07-07 13:21:00 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linville

Arik Nemtsov (7):
      wl12xx: AP mode - support FW TX inactivity triggers
      wl12xx: use 802.11 header location after relocation to frame start
      wl12xx: schedule TX packets according to FW occupancy
      wl12xx: implement Tx watermarks per AC
      wl12xx: initialize max_power levels for 11a channels
      wl12xx: always initialize AP-mode max power level
      wl12xx: start/stop queues according to global per-AC counters

Eliad Peller (3):
      wl12xx: configure suspend/resume only if associated/started
      wl12xx: add stop_scan command
      wl12xx: implement cancel_hw_scan() callback

Ido Yariv (1):
      wl12xx: Increase low & high TX watermarks

Ohad Ben-Cohen (1):
      wl12xx: one SDIO initialization is enough

Oz Krakowski (1):
      wl12xx: fix Tx security sequence number handling

 drivers/net/wireless/wl12xx/acx.c     |   12 +-
 drivers/net/wireless/wl12xx/acx.h     |    4 +-
 drivers/net/wireless/wl12xx/boot.c    |    4 +-
 drivers/net/wireless/wl12xx/cmd.c     |    6 +-
 drivers/net/wireless/wl12xx/conf.h    |   10 ++-
 drivers/net/wireless/wl12xx/debugfs.c |   15 ++-
 drivers/net/wireless/wl12xx/event.c   |   42 +++++++
 drivers/net/wireless/wl12xx/event.h   |   12 ++-
 drivers/net/wireless/wl12xx/init.c    |    7 +-
 drivers/net/wireless/wl12xx/main.c    |  202 +++++++++++++++++++++++----------
 drivers/net/wireless/wl12xx/ps.c      |    9 +-
 drivers/net/wireless/wl12xx/scan.c    |   27 +++++
 drivers/net/wireless/wl12xx/scan.h    |    1 +
 drivers/net/wireless/wl12xx/sdio.c    |   12 +-
 drivers/net/wireless/wl12xx/tx.c      |  143 ++++++++++++++++--------
 drivers/net/wireless/wl12xx/tx.h      |   28 +++++-
 drivers/net/wireless/wl12xx/wl12xx.h  |   24 +++--
 17 files changed, 414 insertions(+), 144 deletions(-)

-- 
Cheers,
Luca.



