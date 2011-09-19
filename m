Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:39309 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010Ab1ISGBw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 02:01:52 -0400
Received: by fxbb27 with SMTP id b27so3658693fxb.29
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 23:01:50 -0700 (PDT)
Subject: pull request: wl12xx 2011-09-19
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 09:01:47 +0300
Message-ID: <1316412107.2157.29.camel@cumari> (sfid-20110919_080156_886946_8A5FB864)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

One more pull request intended for 3.2.  It contains a bunch of bugfixes
and improvements related to our new firmware, by Eliad and Arik, support
for p2p interfaces and support for SSID matching in scheduled scans.  It
also removes a deprecated Kconfig flag that was only meaningful while
our 11n code was still experimental. 

Please pull or let me know if there's any problem. This tree is based
on wireless-next/master.

Thanks!

The following changes since commit
12e62d6f7ec475e546b40bece2045da15d6c21ef:

  MAINTAINERS: update ath6kl (2011-09-16 16:45:43 -0400)

are available in the git repository at:
  git://github.com/lucacoelho/wl12xx.git for-linville

Arik Nemtsov (8):
      wl12xx: don't queue a new dummy packet if one is already pending
      wl12xx: don't indicate up PS-filtered dummy packets
      wl12xx: AP mode - don't regulate FW blocks for non-active STAs
      wl12xx: support up to 8 stations in AP-mode
      wl12xx: don't regulate links when a single STA is connected
      wl12xx: AP mode - enable the BA constraint event from the FW
      wl12xx: AP mode - clean BA and queue state in tx_reset
      wl12xx: set mac80211 flags for A-MPDU aggregation support

Eliad Peller (11):
      wl12xx: print acx id
      wl12xx: print the seq_num of rx packet
      wl12xx: add module_param to trigger BUG() on recovery
      wl12xx: add beacon_filtering debugfs file
      wl12xx: don't disconnect on recovery
      wl12xx: don't use WL1271_SCAN_OPT_PRIORITY_HIGH flag
      wl12xx: check for ROC on scan_complete
      wl12xx: add config_hangover command
      wl12xx: use kstrtoul_from_user
      wl12xx: declare support for WIPHY_FLAG_AP_UAPSD
      wl12xx: support p2p interfaces

Luciano Coelho (4):
      wl12xx: remove deprecated CONFIG_WL12XX_HT flag
      wl12xx: add support for sched_scan filters
      wl12xx: increase number of allowed SSIDs in sched_scan
      wl12xx: ignore sched scan match sets without SSID

drivers/net/wireless/wl12xx/Kconfig   |   10 ---
drivers/net/wireless/wl12xx/acx.c     |   40 +++++++++++
drivers/net/wireless/wl12xx/acx.h     |   18 +++++
drivers/net/wireless/wl12xx/cmd.c     |   17 +++--
drivers/net/wireless/wl12xx/cmd.h     |    7 ++
drivers/net/wireless/wl12xx/conf.h    |   23 ++++--
drivers/net/wireless/wl12xx/debugfs.c |   88 ++++++++++++-----------
drivers/net/wireless/wl12xx/event.c   |   39 ++++++----
drivers/net/wireless/wl12xx/init.c    |    5 ++
drivers/net/wireless/wl12xx/main.c    |   96 +++++++++++++++++++-------
drivers/net/wireless/wl12xx/ps.c      |    8 ++-
drivers/net/wireless/wl12xx/rx.c      |    9 ++-
drivers/net/wireless/wl12xx/scan.c    |  124
++++++++++++++++++++++-----------
drivers/net/wireless/wl12xx/tx.c      |   22 ++++--
drivers/net/wireless/wl12xx/tx.h      |    4 +
drivers/net/wireless/wl12xx/wl12xx.h  |    8 ++-
16 files changed, 359 insertions(+), 159 deletions(-)


-- 
Cheers,
Luca.



