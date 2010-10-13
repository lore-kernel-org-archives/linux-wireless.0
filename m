Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:55238 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab0JMOGt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 10:06:49 -0400
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH v4 00/03] wl1271: 11n Support, add support to 80211n spec
Date: Wed, 13 Oct 2010 16:09:38 +0200
Message-Id: <1286978981-21467-1-git-send-email-shahar_levi@ti.com>
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

Changes from v3:
- Fix HW_RX_HIGHEST_RATE to 72 (old value 65)
- In wl1271_acx_set_ht_capabilities() replace ? with if 
- Fix some comments
- Clean to Linux code style.

Shahar Levi (3):
  wl1271: 11n Support, Add Definitions
  wl1271: 11n Support, ACX Commands
  wl1271: 11n Support, functionality and configuration ability

 drivers/net/wireless/wl12xx/Kconfig       |   10 +++
 drivers/net/wireless/wl12xx/wl1271.h      |   11 +++-
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   83 +++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   86 ++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_main.c |  102 ++++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/wl1271_rx.c   |    6 ++
 drivers/net/wireless/wl12xx/wl1271_tx.c   |   11 +++
 7 files changed, 291 insertions(+), 18 deletions(-)

