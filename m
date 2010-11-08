Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63163 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0KHJvP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 04:51:15 -0500
Received: by fxm16 with SMTP id 16so3835093fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Nov 2010 01:51:14 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 0/2] Add support for fragmentation offload
Date: Mon,  8 Nov 2010 11:51:05 +0200
Message-Id: <1289209867-21422-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds support for hardware TX fragmentation offload
to mac80211 based drivers. A callback is added to ieee80211_ops
to receive fragmentation threshold updates.

The added functionality is very similar to the one removed by
patch f546638c3f80.

The patchset is required for wl1271 based cards. The firmware
does not support fragmentation in software and in fact clears
the MOREFRAGS flag for TX packets.

v1->v2: Merge mac80211 patches. Remove flag indicating support
for HW fragmentation. An implemented set_frag_threshold callback
indicates HW fragmentation.

Arik Nemtsov (2):
  mac80211: support hardware TX fragmentation offload
  wl1271: add support for HW TX fragmentation

 drivers/net/wireless/wl12xx/wl1271_acx.c  |    4 +-
 drivers/net/wireless/wl12xx/wl1271_acx.h  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_init.c |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |   31 ++++++++++++++++++++++++++++-
 include/net/mac80211.h                    |    6 +++++
 net/mac80211/cfg.c                        |    7 ++++++
 net/mac80211/driver-ops.h                 |   14 +++++++++++++
 net/mac80211/driver-trace.h               |   21 +++++++++++++++++++
 net/mac80211/tx.c                         |   11 ++++++++-
 net/mac80211/util.c                       |    3 ++
 10 files changed, 94 insertions(+), 7 deletions(-)

