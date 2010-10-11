Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:45515 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab0JKPom (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 11:44:42 -0400
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH v3 00/03] wl1271: 11n Support, add support to 80211n spec
Date: Mon, 11 Oct 2010 17:47:15 +0200
Message-Id: <1286812038-19013-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Series that add 80211n spec support to wl1271: scan, connection via MCS rates
Wl12xx driver add HT support:
- Scan includes HT IE
- Connection to HT devices
- HT protection
- Traffic via MCS rates
- A-MSDU in RX path

Missing functionality is:
- BA session as Initiator and Receiver

Changes from v2:
- Add logic on wl1271_op_bss_info_changed()
- add CONFIG_WL1271_HT in tx & rx
- Rebase to latest wl12xx git
- Clean to Linux code style. 

Shahar Levi (3):
  wl1271: 11n Support, Add Definitions
  wl1271: 11n Support, ACX Commands
  wl1271: 11n Support, functionality and configuration ability

 drivers/net/wireless/wl12xx/Kconfig       |   10 +++
 drivers/net/wireless/wl12xx/wl1271.h      |   11 +++-
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   85 ++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   88 +++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_main.c |  108 ++++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/wl1271_rx.c   |    6 ++
 drivers/net/wireless/wl12xx/wl1271_tx.c   |   11 +++
 7 files changed, 301 insertions(+), 18 deletions(-)

