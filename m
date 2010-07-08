Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40339 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab0GHOu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 10:50:27 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/13] wl1271: sending all patches from our internal tree
Date: Thu,  8 Jul 2010 17:49:55 +0300
Message-Id: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

We have accumulted a few more patches in our internal tree again.  Sorry for
that.

These patches contain several improvements and a lot of bug fixes and
stabilization.

Please apply.

Cheers,
Luca.


Juuso Oikarinen (9):
  wl1271: Remove calibration from join command
  wl1271: Add TSF handling
  wl1271: Use the ARP configuration function from mac80211
  wl1271: Use all basic rates for ps-poll, instead of just the slowest
  wl1271: Work around AP's with broken ps-poll functionality
  wl1271: Update hardware ARP filtering configuration handling
  wl1271: Disable dynamic PS based on BT co-ext sense events
  wl1271: Fix warning when disconnecting and ad-hoc network
  wl1271: Update interface to temporarily disable dynamic PS

Luciano Coelho (4):
  wl1271: read fem manufacturer value from nvs
  wl1271: moved scan operations to a separate file
  wl1271: rewritten scanning code
  wl1271: use per-channel max tx power passed by mac80211 when scanning

 drivers/net/wireless/wl12xx/Makefile       |    2 +-
 drivers/net/wireless/wl12xx/wl1271.h       |   24 ++--
 drivers/net/wireless/wl12xx/wl1271_acx.c   |   41 ++++--
 drivers/net/wireless/wl12xx/wl1271_acx.h   |   15 ++-
 drivers/net/wireless/wl12xx/wl1271_boot.c  |    4 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |  248 +--------------------------
 drivers/net/wireless/wl12xx/wl1271_cmd.h   |   68 --------
 drivers/net/wireless/wl12xx/wl1271_conf.h  |   16 +-
 drivers/net/wireless/wl12xx/wl1271_event.c |   99 ++++++++---
 drivers/net/wireless/wl12xx/wl1271_event.h |    1 +
 drivers/net/wireless/wl12xx/wl1271_main.c  |  174 ++++++++-----------
 drivers/net/wireless/wl12xx/wl1271_rx.c    |    6 -
 drivers/net/wireless/wl12xx/wl1271_scan.c  |  257 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_scan.h  |  109 ++++++++++++
 14 files changed, 577 insertions(+), 487 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_scan.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_scan.h

