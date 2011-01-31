Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33441 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab1AaUcl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 15:32:41 -0500
Received: by wwa36 with SMTP id 36so6228533wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 12:32:39 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 0/8] wl12xx: AP-mode per link PSM
Date: Mon, 31 Jan 2011 22:32:23 +0200
Message-Id: <1296505951-29644-1-git-send-email-arik@wizery.com>
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
 drivers/net/wireless/wl12xx/tx.c     |  235 +++++++++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/tx.h     |    3 +
 drivers/net/wireless/wl12xx/wl12xx.h |   37 ++++++
 8 files changed, 457 insertions(+), 57 deletions(-)

