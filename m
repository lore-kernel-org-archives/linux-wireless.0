Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45605 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbYJ2Epm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 00:45:42 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 21:45:42 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18695.59863.727986.319790@gargle.gargle.HOWL> (sfid-20081029_054548_346563_A2EC51DB)
Date: Wed, 29 Oct 2008 10:13:03 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 00/16] Cleanup series
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

A bunch of cleanups mostly, removal of the internal STA list,
internal RX ampdu processing logic among others.

Sujith

Sujith (16):
  ath9k: Node cleanup
  ath9k: Simplify node attach/detach routines
  ath9k: Revamp transmit control block
  ath9k: Remove SM Power Save as it is not supported now
  ath9k: Ensure ath_node is not NULL when updating tx chainmask
  ath9k: Use bitfields to store tid's state in a single variable
  ath9k: Revamp VAP management
  ath9k: Refactor hw.c
  ath9k: Remove unused function ath_get_currentCountry()
  ath9k: Streamline attach/detach
  ath9k: Remove unnecessary TSF reset
  ath9k: Enable interrupts at the proper place
  ath9k: Remove ath_tx_aggr_resp()
  ath9k: Clear HT info on starting the driver
  ath9k: Remove internal RX A-MPDU processing
  mac80211: Add a new event in ieee80211_ampdu_mlme_action

 drivers/net/wireless/ath9k/Makefile |    4 +
 drivers/net/wireless/ath9k/ani.c    |  854 ++++
 drivers/net/wireless/ath9k/ath9k.h  |  376 +-
 drivers/net/wireless/ath9k/beacon.c |   42 +-
 drivers/net/wireless/ath9k/calib.c  |  930 ++++
 drivers/net/wireless/ath9k/core.c   |  486 +--
 drivers/net/wireless/ath9k/core.h   |  157 +-
 drivers/net/wireless/ath9k/eeprom.c | 1605 +++++++
 drivers/net/wireless/ath9k/hw.c     | 8494 ++++++++---------------------------
 drivers/net/wireless/ath9k/hw.h     |    2 +-
 drivers/net/wireless/ath9k/mac.c    | 1031 +++++
 drivers/net/wireless/ath9k/main.c   |  430 +--
 drivers/net/wireless/ath9k/phy.c    |   10 +-
 drivers/net/wireless/ath9k/rc.c     |   91 +-
 drivers/net/wireless/ath9k/recv.c   |  536 ---
 drivers/net/wireless/ath9k/xmit.c   | 1004 ++---
 include/net/mac80211.h              |    2 +
 net/mac80211/ht.c                   |   10 +-
 18 files changed, 7374 insertions(+), 8690 deletions(-)
 create mode 100644 drivers/net/wireless/ath9k/ani.c
 create mode 100644 drivers/net/wireless/ath9k/calib.c
 create mode 100644 drivers/net/wireless/ath9k/eeprom.c
 create mode 100644 drivers/net/wireless/ath9k/mac.c

