Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:36595 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbZK3IR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 03:17:57 -0500
Subject: [PATCH v2 00/11] wl1251 WMM support and minor fixes
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Nov 2009 10:17:31 +0200
Message-ID: <20091130081706.17360.48084.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello John,

here are few patches for wl1251. Now there is WMM support and also some
minor fixes. The patchset applies on top of the wl1251 power save fixes I
sent earlier today.

These patches are not urgent.

v2: dropped patch "wl1251: fix payload alignment"

---

Kalle Valo (11):
      wl1251: add tx queue status to debugfs
      wl1251: print a debug message when tx_queue is full
      wl1251: fix error handling in wl1251_op_config()
      wl1251: reduce ELP wakeup timeout
      wl1251: simplify ELP wakeup time calculation
      wl1251: use __dev_alloc_skb() on RX
      wl1251: implement acx_ac_cfg to configure hardware queues
      wl1251: implement wl1251_acx_tid_cfg()
      wl1251: implement WMM
      wl1251: update tx_hdr when aliging skb in tx
      wl1251: enable WMM


 drivers/net/wireless/wl12xx/wl1251.h         |    1 
 drivers/net/wireless/wl12xx/wl1251_acx.c     |   69 +++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_acx.h     |   87 ++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_debugfs.c |   23 +++++++
 drivers/net/wireless/wl12xx/wl1251_init.c    |    5 +
 drivers/net/wireless/wl12xx/wl1251_init.h    |   47 ++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_main.c    |   50 ++++++++++++++-
 drivers/net/wireless/wl12xx/wl1251_ps.c      |    9 +--
 drivers/net/wireless/wl12xx/wl1251_rx.c      |    2 -
 drivers/net/wireless/wl12xx/wl1251_tx.c      |    9 +--
 drivers/net/wireless/wl12xx/wl1251_tx.h      |   17 +++++
 11 files changed, 308 insertions(+), 11 deletions(-)

