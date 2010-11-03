Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47619 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab0KCVvF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 17:51:05 -0400
Received: by fxm16 with SMTP id 16so938793fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 14:51:03 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
Cc: Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 0/4] Add support for fragmentation offload
Date: Wed,  3 Nov 2010 23:50:49 +0200
Message-Id: <1288821053-19013-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds support for hardware TX fragmentation offload
to mac80211 based drivers. A callback is added to ieee80211_ops
to receive fragmentation threshold updates.

The added functionality is very similar to the one removed by
patch f546638c3f80.

This patchset is required for wl1271 based cards. The firmware
does not support fragmentation in software and in fact clears
the MOREFRAGS flag for TX packets.


Arik Nemtsov (4):
  mac80211: add fragmentation offload definitions
  mac80211: notify drivers about frag threshold changes
  mac80211: don't fragment packets when HW-fragmentation is on
  wl1271: add support for HW TX fragmentation

 drivers/net/wireless/wl12xx/wl1271_acx.c  |    4 +-
 drivers/net/wireless/wl12xx/wl1271_acx.h  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_init.c |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |   34 +++++++++++++++++++++++++++-
 include/net/mac80211.h                    |   12 ++++++++++
 net/mac80211/cfg.c                        |    7 ++++++
 net/mac80211/driver-ops.h                 |   14 ++++++++++++
 net/mac80211/driver-trace.h               |   21 +++++++++++++++++
 net/mac80211/tx.c                         |    8 +++++-
 net/mac80211/util.c                       |    3 ++
 10 files changed, 99 insertions(+), 8 deletions(-)

