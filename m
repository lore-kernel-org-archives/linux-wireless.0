Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63500 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab2KVS7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 13:59:53 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3047065eek.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 10:59:52 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 00/14] update 18xx api
Date: Thu, 22 Nov 2012 18:06:10 +0200
Message-Id: <1353600384-32462-1-git-send-email-eliad@wizery.com> (sfid-20121122_195958_251227_5F5B59DA)
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

v2: handle Luca's comments

Eliad Peller (13):
  wlcore: don't call ieee80211_sched_scan_stopped directly
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
 drivers/net/wireless/ti/wl18xx/acx.h      |    8 +-
 drivers/net/wireless/ti/wl18xx/cmd.c      |   80 ++++
 drivers/net/wireless/ti/wl18xx/cmd.h      |   52 +++
 drivers/net/wireless/ti/wl18xx/event.c    |  103 +++++
 drivers/net/wireless/ti/wl18xx/event.h    |   76 ++++
 drivers/net/wireless/ti/wl18xx/main.c     |   37 ++-
 drivers/net/wireless/ti/wl18xx/scan.c     |  320 ++++++++++++++
 drivers/net/wireless/ti/wl18xx/scan.h     |  122 ++++++
 drivers/net/wireless/ti/wl18xx/wl18xx.h   |    4 +-
 drivers/net/wireless/ti/wlcore/acx.h      |    1 -
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
 34 files changed, 2511 insertions(+), 1111 deletions(-)
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

