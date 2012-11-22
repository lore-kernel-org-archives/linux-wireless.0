Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54580 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965185Ab2KVTeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:34:18 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so3326571eaa.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 11:34:17 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/13] update 18xx api
Date: Thu, 22 Nov 2012 14:05:15 +0200
Message-Id: <1353585928-28666-1-git-send-email-eliad@wizery.com> (sfid-20121122_203434_414299_DD55FBA3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset updates wl18xx to use the latest
18xx fw api.

Most of the commands are backward compatible with
the 12xx fw (e.g. new fields were added at the
end of the existing structs).

However, the scan and event mailbox apis were
completely changed, so we had to split the
existing code (while trying to reuse as much
code as possible).

After this patchset, the driver can work with
latest versions of both 12xx and 18xx FWs.

Eliad Peller (12):
  wlcore: make scan scan configuration functions more generic
  wl18xx: change fw name and temporarily fail loading
  wlcore: update commands enum to new fw api
  wlcore: split 18xx and 12xx scan mechanism
  wl18xx: increase MAX_CHANNELS_5GHZ
  wlcore: update acx enum
  wlcore: update channel_switch/stop_channel_switch commands
  wlcore: update events enum/struct to new fw api
  wlcore: pass wmm configuration to the fw
  wlcore: save session_id per-link
  wlcore: call ieee80211_sched_scan_stopped on interface removal
  wl18xx: make driver operational again

Victor Goldenshtein (1):
  wlcore: add new reg-domain configuration command

 drivers/net/wireless/ti/wl12xx/Makefile   |    2 +-
 drivers/net/wireless/ti/wl12xx/cmd.c      |   37 ++
 drivers/net/wireless/ti/wl12xx/cmd.h      |   20 +
 drivers/net/wireless/ti/wl12xx/event.c    |  112 +++++
 drivers/net/wireless/ti/wl12xx/event.h    |  111 +++++
 drivers/net/wireless/ti/wl12xx/main.c     |   35 ++-
 drivers/net/wireless/ti/wl12xx/scan.c     |  500 ++++++++++++++++++++++
 drivers/net/wireless/ti/wl12xx/scan.h     |  140 +++++++
 drivers/net/wireless/ti/wl18xx/Makefile   |    2 +-
 drivers/net/wireless/ti/wl18xx/acx.c      |    2 +-
 drivers/net/wireless/ti/wl18xx/acx.h      |    4 -
 drivers/net/wireless/ti/wl18xx/cmd.c      |   80 ++++
 drivers/net/wireless/ti/wl18xx/cmd.h      |   52 +++
 drivers/net/wireless/ti/wl18xx/event.c    |  103 +++++
 drivers/net/wireless/ti/wl18xx/event.h    |   76 ++++
 drivers/net/wireless/ti/wl18xx/main.c     |   37 ++-
 drivers/net/wireless/ti/wl18xx/scan.c     |  320 ++++++++++++++
 drivers/net/wireless/ti/wl18xx/scan.h     |  122 ++++++
 drivers/net/wireless/ti/wl18xx/wl18xx.h   |    4 +-
 drivers/net/wireless/ti/wlcore/acx.h      |   10 +-
 drivers/net/wireless/ti/wlcore/boot.c     |   21 +-
 drivers/net/wireless/ti/wlcore/cmd.c      |  259 ++++++++-----
 drivers/net/wireless/ti/wlcore/cmd.h      |   68 ++--
 drivers/net/wireless/ti/wlcore/debugfs.c  |    2 -
 drivers/net/wireless/ti/wlcore/event.c    |  336 +++++++--------
 drivers/net/wireless/ti/wlcore/event.h    |  101 ++----
 drivers/net/wireless/ti/wlcore/init.c     |   14 +-
 drivers/net/wireless/ti/wlcore/main.c     |  215 +++++++---
 drivers/net/wireless/ti/wlcore/rx.c       |    4 +
 drivers/net/wireless/ti/wlcore/scan.c     |  644 ++++++-----------------------
 drivers/net/wireless/ti/wlcore/scan.h     |  137 ++-----
 drivers/net/wireless/ti/wlcore/tx.c       |    3 +-
 drivers/net/wireless/ti/wlcore/wlcore.h   |   46 ++-
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    8 +-
 34 files changed, 2513 insertions(+), 1114 deletions(-)
 create mode 100644 drivers/net/wireless/ti/wl12xx/event.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/event.h
 create mode 100644 drivers/net/wireless/ti/wl12xx/scan.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/scan.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/cmd.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/cmd.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/event.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/event.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/scan.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/scan.h

-- 
1.7.6.401.g6a319

