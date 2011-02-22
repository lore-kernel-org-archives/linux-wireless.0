Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51429 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab1BVWWk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:40 -0500
Received: by wyg36 with SMTP id 36so264086wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2011 14:22:39 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 0/8] wl12xx: AP-mode per link PSM
Date: Wed, 23 Feb 2011 00:22:23 +0200
Message-Id: <1298413351-15462-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset introduces per-link PSM for AP-mode. The PS status of each
link is updated from FW.
The wl12xx concept of PSM is different from the mac80211 one - some data
must remain in FW for a link in PSM since the TIM is updated automatically
by FW. This functionality depends on the following mac80211 patch:
"mac80211: add HW flag for disabling auto link-PS in AP mode"

We set up a skb-queue per link which allows for a cleaner link
disconnection and prepares the code for regulating each link separately.

A few other AP-mode related small bug fixes and enchancements are included.

v1->2:
- In first patch, use atomic operations when changing the flags
  variable. It is not always changed within a spinlock/mutex.
- Rebase on latest master of maintainer's git

Arik Nemtsov (8):
  wl12xx: fix potential race condition with TX queue watermark
  wl12xx: AP-mode - fix race condition on sta connection
  wl12xx: AP-mode - TX queue per link in AC
  wl12xx: report invalid TX rate when returning non-TX-ed skbs
  wl12xx: AP-mode - support HW based link PS monitoring
  wl12xx: AP mode - fix bug in cleanup of wl1271_op_sta_add()
  wl12xx: AP-mode - count free FW TX blocks per link
  wl12xx: AP-mode - management of links in PS-mode

 drivers/net/wireless/wl12xx/acx.c    |   25 ++++
 drivers/net/wireless/wl12xx/acx.h    |    9 ++
 drivers/net/wireless/wl12xx/main.c   |  125 +++++++++++++++---
 drivers/net/wireless/wl12xx/ps.c     |   78 +++++++++++
 drivers/net/wireless/wl12xx/ps.h     |    2 +
 drivers/net/wireless/wl12xx/tx.c     |  233 +++++++++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/tx.h     |    3 +
 drivers/net/wireless/wl12xx/wl12xx.h |   37 ++++++
 8 files changed, 456 insertions(+), 56 deletions(-)

