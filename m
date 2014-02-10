Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:64115 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaBJLrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 06:47:42 -0500
Received: by mail-we0-f181.google.com with SMTP id w61so4178098wes.12
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 03:47:41 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/18] wlcore/wl18xx: fw update and various fixes
Date: Mon, 10 Feb 2014 13:47:16 +0200
Message-Id: <1392032854-28126-1-git-send-email-eliad@wizery.com> (sfid-20140210_124745_794532_2968DB26)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update wl18xx to use the latest fw. Since the api was
changed in a way that is no longer compatible with
the current wl12xx api, some patches are needed in
order to make some defines/structs per-hw (rather than common)

Additionally, fix various (mostly minor) fixes, and declare
support for STA CSA.

Arik Nemtsov (5):
  wlcore: cancel Tx watchdog on suspend and rearm on first Tx after
  wlcore: AP: don't start mac80211 PS on non-peer HLIDs
  wlcore: wl18xx: allow CCK rates for AP mode
  wlcore: decrease warning verbosity during recovery
  wlcore: add support for STA CSA with chan contexts

Barak Bercovitz (2):
  wlcore: block read/writes to FW during ELP
  wlcore: don't stop sched_scan on interface removal

Eliad Peller (8):
  wlcore/wl12xx/wl18xx: simplify fw_status handling
  wlcore/wl12xx/wl18xx: configure num_links per-hw
  wlcore/wl12xx/wl18xx: configure max_stations per-hw
  wlcore/wl12xx/wl18xx: configure iface_combinations per-hw
  wl18xx: move to new firmware (wl18xx-fw-3.bin)
  wlcore: don't handle unsetting of default wep key
  wlcore: consider multiple APs when checking active_link_count
  wlcore: enable beacon filtering only after receiving a beacon

Igal Chernobelsky (1):
  wlcore: send EAPOL frames with voice priority

Nadim Zubidat (1):
  wlcore: memset wl->rx_filter_enabled to zero after recovery

Yaniv Machani (1):
  wlcore: increase timeout to 5000 msecs

 drivers/net/wireless/ti/wl12xx/main.c     |  67 ++++++++++-
 drivers/net/wireless/ti/wl12xx/wl12xx.h   |  53 +++++++++
 drivers/net/wireless/ti/wl18xx/main.c     |  85 ++++++++++++-
 drivers/net/wireless/ti/wl18xx/tx.c       |   4 +-
 drivers/net/wireless/ti/wl18xx/wl18xx.h   |  62 +++++++++-
 drivers/net/wireless/ti/wlcore/acx.c      |   7 +-
 drivers/net/wireless/ti/wlcore/acx.h      |   6 +-
 drivers/net/wireless/ti/wlcore/cmd.c      |  24 ++--
 drivers/net/wireless/ti/wlcore/cmd.h      |   9 +-
 drivers/net/wireless/ti/wlcore/event.c    |   4 +-
 drivers/net/wireless/ti/wlcore/hw_ops.h   |   9 ++
 drivers/net/wireless/ti/wlcore/init.c     |   6 +-
 drivers/net/wireless/ti/wlcore/io.h       |   8 +-
 drivers/net/wireless/ti/wlcore/main.c     | 192 +++++++++++++++---------------
 drivers/net/wireless/ti/wlcore/ps.c       |   6 +-
 drivers/net/wireless/ti/wlcore/rx.c       |  19 +--
 drivers/net/wireless/ti/wlcore/rx.h       |   2 +-
 drivers/net/wireless/ti/wlcore/tx.c       |  45 ++++---
 drivers/net/wireless/ti/wlcore/tx.h       |   1 +
 drivers/net/wireless/ti/wlcore/wlcore.h   |  27 +++--
 drivers/net/wireless/ti/wlcore/wlcore_i.h |  86 ++++++-------
 21 files changed, 513 insertions(+), 209 deletions(-)

-- 
1.8.5.2.229.g4448466.dirty

