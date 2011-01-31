Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46371 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab1AaLQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 06:16:37 -0500
Received: by fxm20 with SMTP id 20so5465134fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 03:16:36 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 00/10] wl12xx: AP-mode per link PSM
Date: Mon, 31 Jan 2011 13:16:19 +0200
Message-Id: <1296472589-26401-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset introduces per-link PSM for AP-mode. The PS status of each
link is updated from FW.
The wl12xx concept of PSM is different from the mac80211 one - some data
must remain in FW for a link in PSM since the TIM is updated automatically
by FW. An exported function to manually toggle PSM in mac80211 is added
to bridge this gap.

We set up a skb-queue per link which allows for a cleaner link
disconnection and prepares the code for regulating each link separately.

v1->2: Changed mac80211 PS state change exported functions

A few other AP-mode related small bug fixes and enchancements are included.
Arik Nemtsov (10):
  wl12xx: fix potential race condition with TX queue watermark
  wl12xx: AP-mode - fix race condition on sta connection
  wl12xx: AP-mode - TX queue per link in AC
  mac80211: do not calc frame duration when using HW rate-control
  wl12xx: report invalid TX rate when returning non-TX-ed skbs
  mac80211: add HW flag for disabling auto link-PS in AP mode
  wl12xx: AP-mode - support HW based link PS monitoring
  wl12xx: AP mode - fix bug in cleanup of wl1271_op_sta_add()
  wl12xx: AP-mode - count free FW TX blocks per link
  wl12xx: AP-mode - management of links in PS-mode

 drivers/net/wireless/wl12xx/acx.c    |   25 ++++
 drivers/net/wireless/wl12xx/acx.h    |    9 ++
 drivers/net/wireless/wl12xx/main.c   |  125 +++++++++++++++---
 drivers/net/wireless/wl12xx/ps.c     |   78 +++++++++++
 drivers/net/wireless/wl12xx/ps.h     |    2 +
 drivers/net/wireless/wl12xx/tx.c     |  235 +++++++++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/tx.h     |    3 +
 drivers/net/wireless/wl12xx/wl12xx.h |   37 ++++++
 include/net/mac80211.h               |   54 ++++++++-
 net/mac80211/rx.c                    |   27 ++++-
 net/mac80211/sta_info.c              |    3 +-
 net/mac80211/status.c                |    4 +
 net/mac80211/tx.c                    |    3 +-
 13 files changed, 543 insertions(+), 62 deletions(-)

